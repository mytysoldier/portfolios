import fs from "fs";
import path from "path";

export function resolveRulePath(filename: string): string {
  const base = process.env.RULES_DIR ?? path.join(process.cwd(), "config");
  return path.join(base, filename);
}

/** ファイルがあれば内容を返し、無ければ null */
export function loadTextFileIfExists(filePath: string): string | null {
  if (!fs.existsSync(filePath)) return null;
  const raw = fs.readFileSync(filePath, "utf8").trim();
  return raw.length > 0 ? raw : null;
}
