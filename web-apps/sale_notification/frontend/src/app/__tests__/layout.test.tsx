import { render, screen } from "@testing-library/react";
import RootLayout from "@/app/layout";

// react-i18nextのモック
jest.mock("react-i18next", () => ({
  useTranslation: () => ({
    t: (key: string) => key,
  }),
  initReactI18next: {
    type: "3rdParty",
    init: jest.fn(),
  },
}));

// next/font/localのモック
jest.mock("next/font/local", () => {
  return jest.fn(() => ({
    variable: "mocked-font-variable", // モックのフォント変数を設定
  }));
});

describe("RootLayout", () => {
  // 以下warningが出るがテストはPASSするため、console.errorをモックしてエラーメッセージを抑制
  // Warning: validateDOMNesting(...): <html> cannot appear as a child of <div>.
  let consoleErrorSpy: jest.SpyInstance;

  beforeAll(() => {
    consoleErrorSpy = jest.spyOn(console, "error").mockImplementation(() => {});
  });

  afterAll(() => {
    // スパイを元に戻す
    consoleErrorSpy.mockRestore();
  });

  test("テキストが表示されること", () => {
    render(
      <RootLayout>
        <div>Test Content</div>
      </RootLayout>,
    );

    // ヘッダーのテキストが正しく表示されるかを確認
    expect(screen.getByText("header.title.list")).toBeInTheDocument();

    // ボタンのテキストが正しく表示されるかを確認
    expect(screen.getByText("form.button.addSale")).toBeInTheDocument();

    // 子要素がレンダリングされているかを確認
    expect(screen.getByText("Test Content")).toBeInTheDocument();
  });

  test("フォントが適用されていること", () => {
    const { container } = render(
      <RootLayout>
        <div>Test Content</div>
      </RootLayout>,
    );

    const bodyElement = container.querySelector("body");
    expect(bodyElement).toHaveClass("mocked-font-variable");
    expect(bodyElement).toHaveClass("antialiased");
    expect(bodyElement).toHaveClass("p-16");
  });
});