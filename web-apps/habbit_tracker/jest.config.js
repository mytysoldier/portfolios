module.exports = {
  testEnvironment: "jest-environment-jsdom",
  transform: {
    "^.+\\.(ts|tsx|js|jsx)$": [
      "babel-jest",
      {
        presets: [
          "@babel/preset-env",
          ["@babel/preset-react", { runtime: "automatic" }], // JSXサポートを追加
          "@babel/preset-typescript",
        ],
        plugins: [
          // Babelのプラグインをここに直接指定
          "@babel/plugin-transform-runtime",
        ],
      },
    ], // TypeScript,JavaScriptファイルをトランスパイル
  },
  moduleFileExtensions: ["ts", "tsx", "js", "jsx"], // 拡張子を追加
  setupFilesAfterEnv: ["<rootDir>/setupTests.ts"],
  moduleNameMapper: {
    "\\.(css|less|scss|sass)$": "identity-obj-proxy",
  },
  extensionsToTreatAsEsm: [".ts", ".tsx"],
};
