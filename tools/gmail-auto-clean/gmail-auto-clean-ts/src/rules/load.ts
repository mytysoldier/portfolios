import fs from "fs";
import path from "path";

export function loadKeywordLines(filePath: string): string[] {
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

export function resolveRulePath(filename: string): string {
  const base = process.env.RULES_DIR ?? path.join(process.cwd(), "config");
  return path.join(base, filename);
}

export function loadTextFileRequired(filePath: string): string {
  if (!fs.existsSync(filePath)) {
    throw new Error(`ファイルが見つかりません: ${filePath}`);
  }
  return fs.readFileSync(filePath, "utf8").trim();
}
