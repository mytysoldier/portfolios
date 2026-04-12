import { google } from "googleapis";
import readline from "readline";
import "dotenv/config";

const oAuth2Client = new google.auth.OAuth2(
  process.env.GOOGLE_CLIENT_ID,
  process.env.GOOGLE_CLIENT_SECRET,
  "http://localhost",
);

const url = oAuth2Client.generateAuthUrl({
  access_type: "offline",
  scope: ["https://www.googleapis.com/auth/gmail.modify"],
});

console.log("このURL開く:", url);

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

rl.question("code入力: ", async (code) => {
  const { tokens } = await oAuth2Client.getToken(code);
  console.log(tokens);
  rl.close();
});
