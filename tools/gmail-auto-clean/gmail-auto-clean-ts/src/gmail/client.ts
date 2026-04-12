import { google } from "googleapis";
import type { OAuth2Client } from "google-auth-library";
import type { Mail } from "../types";

export async function listMessages(auth: OAuth2Client) {
  const gmail = google.gmail({ version: "v1", auth });

  const res = await gmail.users.messages.list({
    userId: "me",
    q: "in:inbox is:unread",
    maxResults: 30,
  });

  return res.data.messages || [];
}

export async function getMessage(
  auth: OAuth2Client,
  id: string,
): Promise<Mail> {
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

/** Gmail システムラベル（ゴミ箱へ移動 = このラベルを付与） */
const TRASH_LABEL_ID = "TRASH";

/**
 * JUNK 一括処理: 1 回の batchModify で AUTO_JUNK を付与し、任意で TRASH（ゴミ箱）も付与。
 * messages.trash を N 回叩くより API 効率がよい。
 */
export async function batchApplyJunkLabels(
  auth: OAuth2Client,
  messageIds: string[],
  autoJunkLabelId: string,
  moveToTrash: boolean,
): Promise<void> {
  if (messageIds.length === 0) return;

  const addLabelIds = [autoJunkLabelId];
  if (moveToTrash) {
    addLabelIds.push(TRASH_LABEL_ID);
  }

  const gmail = google.gmail({ version: "v1", auth });
  await gmail.users.messages.batchModify({
    userId: "me",
    requestBody: {
      ids: messageIds,
      addLabelIds,
    },
  });
}

export async function getOrCreateLabel(
  auth: OAuth2Client,
  labelName: string,
): Promise<string> {
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
