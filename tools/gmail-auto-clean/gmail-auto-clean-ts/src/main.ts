import type { Mail } from "./types";
import { getAuth } from "./auth/google";
import {
  loadKeywordLines,
  loadTextFileRequired,
  resolveRulePath,
} from "./rules/load";
import { isJunk } from "./rules/keyword";
import { classifyJunkBatchWithOpenAI } from "./openai/classify";
import {
  batchApplyJunkLabels,
  getMessage,
  getOrCreateLabel,
  listMessages,
} from "./gmail/client";
import { sendSlackDmReport } from "./slack/report";

export async function main() {
  const mode = (process.env.CLASSIFY_MODE ?? "keyword").toLowerCase();
  const useAi = mode === "ai" || mode === "openai";

  let whitelist: string[] = [];
  let blacklist: string[] = [];
  let aiInstructions = "";

  if (useAi) {
    const promptPath =
      process.env.CLASSIFY_PROMPT_PATH ??
      resolveRulePath("classify-prompt.txt");
    aiInstructions = loadTextFileRequired(promptPath);
  } else {
    const whitelistPath =
      process.env.WHITELIST_PATH ?? resolveRulePath("whitelist.txt");
    const blacklistPath =
      process.env.BLACKLIST_PATH ?? resolveRulePath("blacklist.txt");
    whitelist = loadKeywordLines(whitelistPath);
    blacklist = loadKeywordLines(blacklistPath);
  }

  const auth = getAuth();
  const messages = await listMessages(auth);
  const labelId = await getOrCreateLabel(auth, "AUTO_JUNK");

  const mails: Mail[] = [];
  for (const msg of messages) {
    if (!msg.id) {
      console.log("idなしスキップ");
      continue;
    }
    mails.push(await getMessage(auth, msg.id));
  }

  const trashOnJunk = isTruthyEnv(process.env.GMAIL_TRASH_ON_JUNK);

  console.log(`対象メール数: ${mails.length}`);
  console.log(`判定モード: ${useAi ? "ai (OpenAI・1 回バッチ)" : "keyword"}`);
  console.log(
    `JUNK をゴミ箱へ移動: ${trashOnJunk ? "有効 (GMAIL_TRASH_ON_JUNK)" : "無効"}`,
  );

  let junkById = new Map<string, boolean>();
  if (useAi && mails.length > 0) {
    junkById = await classifyJunkBatchWithOpenAI(mails, aiInstructions);
  }

  const labeledJunk: Mail[] = [];
  const kept: Mail[] = [];

  for (const mail of mails) {
    console.log(`\n件名: ${mail.subject}`);
    console.log(`From: ${mail.from}`);

    const junk = useAi
      ? (junkById.get(mail.id) ?? false)
      : isJunk(mail, whitelist, blacklist);

    if (junk) {
      console.log("→ JUNK判定");
      labeledJunk.push(mail);
    } else {
      console.log("→ KEEP");
      kept.push(mail);
    }
  }

  if (labeledJunk.length > 0) {
    await batchApplyJunkLabels(
      auth,
      labeledJunk.map((m) => m.id),
      labelId,
      trashOnJunk,
    );
    console.log(
      `\n→ batchModify 1 回: AUTO_JUNK${trashOnJunk ? " + ゴミ箱 (TRASH)" : ""} … ${labeledJunk.length} 件`,
    );
  }

  await sendSlackDmReport({
    modeLabel: useAi ? "AI" : "keyword",
    labeledJunk,
    kept,
    moveJunkToTrash: trashOnJunk,
  });
}

function isTruthyEnv(v: string | undefined): boolean {
  if (!v) return false;
  const s = v.trim().toLowerCase();
  return s === "1" || s === "true" || s === "yes" || s === "on";
}
