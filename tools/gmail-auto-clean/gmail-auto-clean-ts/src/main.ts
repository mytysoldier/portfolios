import type { Mail } from "./types";
import { getAuth } from "./auth/google";
import { loadTextFileIfExists, resolveRulePath } from "./rules/load";
import { classifyJunkBatchWithOpenAI } from "./openai/classify";
import {
  batchApplyJunkLabels,
  getMessage,
  getOrCreateLabel,
  listMessages,
} from "./gmail/client";
import { sendSlackDmReport } from "./slack/report";

export async function main() {
  const aiInstructions = resolveAiClassifyPrompt();

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
  console.log(`判定: OpenAI（1 回バッチ）`);
  console.log(
    `JUNK をゴミ箱へ移動: ${trashOnJunk ? "有効 (GMAIL_TRASH_ON_JUNK)" : "無効"}`,
  );

  let junkById = new Map<string, boolean>();
  if (mails.length > 0) {
    junkById = await classifyJunkBatchWithOpenAI(mails, aiInstructions);
  }

  const labeledJunk: Mail[] = [];
  const kept: Mail[] = [];

  for (const mail of mails) {
    console.log(`\n件名: ${mail.subject}`);
    console.log(`From: ${mail.from}`);

    const junk = junkById.get(mail.id) ?? false;

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
    modeLabel: "AI",
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

/** 優先順: CLASSIFY_PROMPT → classify-prompt.txt（任意）。無ければ空の指示。 */
function resolveAiClassifyPrompt(): string {
  const inline = process.env.CLASSIFY_PROMPT?.trim();
  if (inline) return inline;

  const promptPath =
    process.env.CLASSIFY_PROMPT_PATH ??
    resolveRulePath("classify-prompt.txt");
  const fromFile = loadTextFileIfExists(promptPath);
  if (fromFile) return fromFile;

  return "";
}
