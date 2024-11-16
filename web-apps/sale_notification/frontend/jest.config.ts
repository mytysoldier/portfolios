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
    "^@/(.*)$": "<rootDir>/src/$1", // エイリアスをsrcディレクトリにマッピング
    "\\.(css|less|scss|sass)$": "identity-obj-proxy",
  },
  extensionsToTreatAsEsm: [".ts", ".tsx"],
  collectCoverage: true,
  coverageDirectory: "coverage",
  collectCoverageFrom: [
    "src/**/*.{js,jsx,ts,tsx}",
    "!src/**/*.d.ts",
    "!src/**/__tests__/**",
    "!src/**/*.test.{js,jsx,ts,tsx}",
    "!src/**/index.{js,jsx,ts,tsx}",
    "!**/node_modules/**",
  ],
  coverageReporters: ["text", "lcov", "json", "html"],
};
