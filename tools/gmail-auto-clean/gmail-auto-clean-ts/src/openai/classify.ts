import type { Mail } from "../types";

function stripJsonFence(content: string): string {
  return content
    .trim()
    .replace(/^```(?:json)?\s*/i, "")
    .replace(/```\s*$/i, "");
}

function parseBatchJunkJson(
  content: string,
): Array<{ id: string; junk: boolean }> {
  const trimmed = stripJsonFence(content);
  const parsed = JSON.parse(trimmed) as { results?: unknown };
  if (!Array.isArray(parsed.results)) {
    throw new Error('応答 JSON に "results" 配列がありません');
  }
  const out: Array<{ id: string; junk: boolean }> = [];
  for (const row of parsed.results) {
    if (!row || typeof row !== "object") continue;
    const r = row as { id?: unknown; junk?: unknown };
    if (typeof r.id === "string" && typeof r.junk === "boolean") {
      out.push({ id: r.id, junk: r.junk });
    }
  }
  return out;
}

async function openAiChatJson(
  systemContent: string,
  userContent: string,
): Promise<string> {
  const apiKey = process.env.OPENAI_API_KEY;
  if (!apiKey) {
    throw new Error("AI モードには OPENAI_API_KEY が必要です");
  }
  const model = process.env.OPENAI_MODEL ?? "gpt-4o-mini";

  const res = await fetch("https://api.openai.com/v1/chat/completions", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${apiKey}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      model,
      temperature: 0,
      response_format: { type: "json_object" },
      messages: [
        { role: "system", content: systemContent },
        { role: "user", content: userContent },
      ],
    }),
  });

  const raw = await res.text();
  if (!res.ok) {
    throw new Error(`OpenAI API エラー: ${res.status} ${raw}`);
  }
  const data = JSON.parse(raw) as {
    choices?: Array<{ message?: { content?: string } }>;
  };
  const text = data.choices?.[0]?.message?.content;
  if (!text) {
    throw new Error("OpenAI から本文がありません");
  }
  return text;
}

/** 全メールを 1 回の Chat Completions で junk/keep 判定（OpenAI へのアクセスは 1 回） */
export async function classifyJunkBatchWithOpenAI(
  mails: Mail[],
  systemInstructions: string,
): Promise<Map<string, boolean>> {
  const map = new Map<string, boolean>();
  if (mails.length === 0) return map;

  const systemContent = [
    systemInstructions,
    "",
    "複数メールを一括で判定する。応答は JSON オブジェクト 1 つだけ。",
    'キー "results" に { "id": "<入力と同一のメッセージID>", "junk": true または false } の配列を入れる。',
    "入力に出た全メールについて results に必ず 1 件ずつ含める（欠番なし）。",
  ].join("\n");

  const userContent = [
    "次のメール一覧を junk / keep 判定し、指定の JSON 形式のみで返す。",
    "",
    "--- メール一覧 ---",
    ...mails.map(
      (m, i) =>
        `${i + 1}. id: ${m.id}\n   件名: ${m.subject}\n   From: ${m.from}`,
    ),
  ].join("\n");

  const raw = await openAiChatJson(systemContent, userContent);
  const rows = parseBatchJunkJson(raw);
  for (const { id, junk } of rows) {
    map.set(id, junk);
  }

  for (const m of mails) {
    if (!map.has(m.id)) {
      console.warn(
        `AI 応答に id がありません: ${m.id} … KEEP 扱い`,
      );
      map.set(m.id, false);
    }
  }

  return map;
}
