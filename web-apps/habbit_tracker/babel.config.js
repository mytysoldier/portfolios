module.exports = {
  presets: [
    "@babel/preset-env",
    ["@babel/preset-react", { runtime: "automatic" }], // JSXサポートを追加
    "@babel/preset-typescript", // TypeScriptサポート
  ],
};
