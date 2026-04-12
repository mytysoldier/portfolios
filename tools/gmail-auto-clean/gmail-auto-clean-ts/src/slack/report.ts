import type { Mail } from "../types";

function escapeSlackMrkdwn(text: string): string {
  return text.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
}

async function slackApi<T>(
  token: string,
  method: string,
  body: Record<string, unknown>,
): Promise<T> {
  const res = await fetch(`https://slack.com/api/${method}`, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${token}`,
      "Content-Type": "application/json; charset=utf-8",
    },
    body: JSON.stringify(body),
  });
  return res.json() as Promise<T>;
}

async function resolveSlackDmUserId(token: string): Promise<string | null> {
  const direct =
    process.env.SLACK_DM_USER_ID ?? process.env.SLACK_USER_ID ?? "";
  if (direct.trim()) return direct.trim();

  const email = process.env.SLACK_NOTIFY_EMAIL?.trim();
  if (!email) return null;

  const data = await slackApi<{
    ok?: boolean;
    user?: { id?: string };
    error?: string;
  }>(token, "users.lookupByEmail", { email });
  if (!data.ok || !data.user?.id) {
    console.warn(
      `Slack users.lookupByEmail 失敗: ${data.error ?? "unknown"}`,
    );
    return null;
  }
  return data.user.id;
}

async function slackOpenDmChannel(
  token: string,
  userId: string,
): Promise<string> {
  const data = await slackApi<{
    ok?: boolean;
    channel?: { id?: string };
    error?: string;
  }>(token, "conversations.open", { users: userId });

  if (!data.ok || !data.channel?.id) {
    throw new Error(
      `conversations.open: ${data.error ?? "unknown"}`,
    );
  }
  return data.channel.id;
}

async function slackPostMessage(
  token: string,
  channel: string,
  text: string,
): Promise<void> {
  const data = await slackApi<{ ok?: boolean; error?: string }>(
    token,
    "chat.postMessage",
    {
      channel,
      text,
      mrkdwn: true,
    },
  );
  if (!data.ok) {
    throw new Error(`chat.postMessage: ${data.error ?? "unknown"}`);
  }
}

/** Slack chat.postMessage の text は概ね 4000 文字上限 */
function chunkString(s: string, maxLen: number): string[] {
  if (s.length <= maxLen) return [s];
  const chunks: string[] = [];
  for (let i = 0; i < s.length; i += maxLen) {
    chunks.push(s.slice(i, i + maxLen));
  }
  return chunks;
}

function buildSlackReport(params: {
  modeLabel: string;
  labeledJunk: Mail[];
  kept: Mail[];
  moveJunkToTrash?: boolean;
}): string[] {
  const { modeLabel, labeledJunk, kept, moveJunkToTrash } = params;
  const h = (s: string) => escapeSlackMrkdwn(s);

  const actionNote = moveJunkToTrash
    ? "JUNK には *AUTO_JUNK* ラベルを付け、*ゴミ箱へ移動*しました（Gmail から復元可能。完全削除ではありません）。"
    : "メールは *ゴミ箱には入れていません*。JUNK 扱いには *AUTO_JUNK* ラベルのみ付けています。";

  const header = `*Gmail 整理レポート*（判定: ${h(modeLabel)}）\n${actionNote}\n`;

  const junkTitle = moveJunkToTrash
    ? `*AUTO_JUNK + ゴミ箱へ移動（JUNK）* — ${labeledJunk.length} 件`
    : `*AUTO_JUNK のみ（JUNK）* — ${labeledJunk.length} 件`;

  const junkBlock =
    `${junkTitle}\n` +
    (labeledJunk.length === 0
      ? "_（なし）_\n"
      : labeledJunk
          .map(
            (m, i) =>
              `${i + 1}. *${h(m.subject || "(件名なし)")}*\n   ${h(m.from || "(From なし)")}`,
          )
          .join("\n") + "\n");

  const keepBlock =
    `*ラベルなし（KEEP）* — ${kept.length} 件\n` +
    (kept.length === 0
      ? "_（なし）_\n"
      : kept
          .map(
            (m, i) =>
              `${i + 1}. *${h(m.subject || "(件名なし)")}*\n   ${h(m.from || "(From なし)")}`,
          )
          .join("\n") + "\n");

  const full = `${header}\n${junkBlock}\n${keepBlock}`;
  return chunkString(full, 3800);
}

export async function sendSlackDmReport(params: {
  modeLabel: string;
  labeledJunk: Mail[];
  kept: Mail[];
  moveJunkToTrash?: boolean;
}): Promise<void> {
  const token = process.env.SLACK_BOT_TOKEN?.trim();
  if (!token) {
    console.log("Slack 通知スキップ: SLACK_BOT_TOKEN 未設定");
    return;
  }

  const userId = await resolveSlackDmUserId(token);
  if (!userId) {
    console.log(
      "Slack 通知スキップ: SLACK_DM_USER_ID（または SLACK_USER_ID / SLACK_NOTIFY_EMAIL）未設定",
    );
    return;
  }

  try {
    const channel = await slackOpenDmChannel(token, userId);
    const chunks = buildSlackReport(params);
    for (let i = 0; i < chunks.length; i++) {
      const prefix =
        chunks.length > 1 ? `（${i + 1}/${chunks.length}）\n` : "";
      await slackPostMessage(token, channel, prefix + chunks[i]);
    }
    console.log("Slack DM でレポートを送信しました");
  } catch (e) {
    console.error("Slack 送信エラー:", e);
  }
}
