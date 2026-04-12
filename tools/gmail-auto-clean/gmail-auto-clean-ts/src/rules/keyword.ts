import type { Mail } from "../types";

export function isJunk(
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
