import fs from "fs";
import path from "path";
import { google } from "googleapis";
import "dotenv/config";

type Mail = {
  id: string;
  subject: string;
  from: string;
};

// =====================
// 認証（環境変数のみ）
// =====================
function getAuth() {
  if (
    !process.env.GOOGLE_CLIENT_ID ||
    !process.env.GOOGLE_CLIENT_SECRET ||
    !process.env.GOOGLE_REDIRECT_URI ||
    !process.env.GOOGLE_REFRESH_TOKEN
  ) {
    throw new Error("環境変数が足りない");
  }

  const oAuth2Client = new google.auth.OAuth2(
    process.env.GOOGLE_CLIENT_ID,
    process.env.GOOGLE_CLIENT_SECRET,
    process.env.GOOGLE_REDIRECT_URI,
  );

  oAuth2Client.setCredentials({
    refresh_token: process.env.GOOGLE_REFRESH_TOKEN,
  });

  return oAuth2Client;
}

// =====================
// ルール判定（config のテキストファイル）
// =====================
function loadKeywordLines(filePath: string): string[] {
  if (!fs.existsSync(filePath)) {
    console.warn(`警告: ${filePath} が見つかりません。空として扱います。`);
    return [];
  }
  const raw = fs.readFileSync(filePath, "utf8");
  return raw
    .split(/\r?\n/)
    .map((line) => line.trim())
    .filter((line) => line.length > 0 && !line.startsWith("#"));
}

function resolveRulePath(filename: string): string {
  const base = process.env.RULES_DIR ?? path.join(process.cwd(), "config");
  return path.join(base, filename);
}

function isJunk(
  mail: Mail,
  whitelist: string[],
  blacklist: string[],
): boolean {
  const subject = mail.subject.toLowerCase();
  const from = mail.from.toLowerCase();

  for (const kw of whitelist) {
    const k = kw.toLowerCase();
    if (subject.includes(k) || from.includes(k)) return false;
  }

  for (const kw of blacklist) {
    const k = kw.toLowerCase();
    if (subject.includes(k) || from.includes(k)) return true;
  }

  return false;
}

// =====================
// Gmail API
// =====================
async function listMessages(auth: any) {
  const gmail = google.gmail({ version: "v1", auth });

  const res = await gmail.users.messages.list({
    userId: "me",
    q: "in:inbox is:unread",
    maxResults: 30,
  });

  return res.data.messages || [];
}

async function getMessage(auth: any, id: string): Promise<Mail> {
  const gmail = google.gmail({ version: "v1", auth });

  const res = await gmail.users.messages.get({
    userId: "me",
    id,
    format: "metadata",
    metadataHeaders: ["Subject", "From"],
  });

  const headers = res.data.payload?.headers || [];

  const subject = headers.find((h) => h.name === "Subject")?.value || "";
  const from = headers.find((h) => h.name === "From")?.value || "";

  return { id, subject, from };
}

async function addLabel(auth: any, messageId: string, labelId: string) {
  const gmail = google.gmail({ version: "v1", auth });

  await gmail.users.messages.modify({
    userId: "me",
    id: messageId,
    requestBody: {
      addLabelIds: [labelId],
    },
  });
}

async function getOrCreateLabel(auth: any, labelName: string): Promise<string> {
  const gmail = google.gmail({ version: "v1", auth });

  const res = await gmail.users.labels.list({ userId: "me" });
  const labels = res.data.labels || [];

  const existing = labels.find((l) => l.name === labelName);
  if (existing) return existing.id!;

  const createRes = await gmail.users.labels.create({
    userId: "me",
    requestBody: {
      name: labelName,
      labelListVisibility: "labelShow",
      messageListVisibility: "show",
    },
  });

  return createRes.data.id!;
}

// =====================
// メイン処理
// =====================
async function main() {
  const whitelistPath =
    process.env.WHITELIST_PATH ?? resolveRulePath("whitelist.txt");
  const blacklistPath =
    process.env.BLACKLIST_PATH ?? resolveRulePath("blacklist.txt");
  const whitelist = loadKeywordLines(whitelistPath);
  const blacklist = loadKeywordLines(blacklistPath);

  const auth = getAuth();
  const messages = await listMessages(auth);
  const labelId = await getOrCreateLabel(auth, "AUTO_JUNK");

  console.log(`対象メール数: ${messages.length}`);

  for (const msg of messages) {
    if (!msg.id) {
      console.log("idなしスキップ");
      continue;
    }

    const mail = await getMessage(auth, msg.id);

    console.log(`\n件名: ${mail.subject}`);
    console.log(`From: ${mail.from}`);

    if (isJunk(mail, whitelist, blacklist)) {
      console.log("→ JUNK判定");
      await addLabel(auth, mail.id, labelId);
    } else {
      console.log("→ KEEP");
    }
  }
}

main().catch(console.error);
