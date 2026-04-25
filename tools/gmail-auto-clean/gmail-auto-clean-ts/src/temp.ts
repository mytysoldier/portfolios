import { google } from "googleapis";
import http from "http";
import { URL } from "url";
import "dotenv/config";

const redirectPort = Number(process.env.OAUTH_REDIRECT_PORT) || 8080;
const redirectUri = `http://127.0.0.1:${redirectPort}`;

const oAuth2Client = new google.auth.OAuth2(
  process.env.GOOGLE_CLIENT_ID,
  process.env.GOOGLE_CLIENT_SECRET,
  redirectUri,
);

const authUrl = oAuth2Client.generateAuthUrl({
  access_type: "offline",
  prompt: "consent",
  scope: ["https://www.googleapis.com/auth/gmail.modify"],
});

const server = http.createServer(async (req, res) => {
  if (!req.url) {
    res.writeHead(400);
    res.end();
    return;
  }

  const u = new URL(req.url, redirectUri);
  const code = u.searchParams.get("code");
  const err = u.searchParams.get("error");

  if (err) {
    res.writeHead(400, { "Content-Type": "text/html; charset=utf-8" });
    res.end(`<p>認可エラー: ${err}</p>`);
    server.close();
    console.error("認可エラー:", err);
    process.exitCode = 1;
    return;
  }

  if (!code) {
    res.writeHead(404);
    res.end();
    return;
  }

  try {
    const { tokens } = await oAuth2Client.getToken(code);
    console.log("取得した tokens:", tokens);
    res.writeHead(200, { "Content-Type": "text/html; charset=utf-8" });
    res.end(
      "<p>認可が完了しました。このタブは閉じて、ターミナルの出力を確認してください。</p>",
    );
  } catch (e) {
    console.error("getToken 失敗:", e);
    res.writeHead(500, { "Content-Type": "text/html; charset=utf-8" });
    res.end("<p>トークン取得に失敗しました。ターミナルを確認してください。</p>");
    process.exitCode = 1;
  } finally {
    server.close();
  }
});

server.listen(redirectPort, "127.0.0.1", () => {
  console.log(
    `リダイレクト先 ${redirectUri} で待機しています。Google Cloud Console の「承認済みのリダイレクト URI」にこの URL を追加してください。`,
  );
  console.log("ブラウザで開く:", authUrl);
});
