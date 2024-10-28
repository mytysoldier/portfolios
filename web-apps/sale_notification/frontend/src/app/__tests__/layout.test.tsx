// layout.test.tsx
import { render, screen } from "@testing-library/react";
import RootLayout from "@/app/layout";
// import "@testing-library/jest-dom/extend-expect";

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
jest.mock("next/font/local", () => () => ({
  variable: "mocked-font-variable",
}));

// // Headerコンポーネントのモック
// jest.mock("@/components/Header", () => ({
//   Header: ({ title }: { title: string }) => <header>{title}</header>,
// }));

// // Buttonコンポーネントのモック
// jest.mock("@/components/Button", () => ({
//   Button: ({ title }: { title: string }) => <button>{title}</button>,
// }));

describe("RootLayout", () => {
  test("renders the header and button correctly", () => {
    render(
      <RootLayout>
        <main>Test Content</main>
      </RootLayout>
    );

    // ヘッダーのテキストが正しく表示されるかを確認
    expect(screen.getByText("header.title.list")).toBeInTheDocument();

    // ボタンのテキストが正しく表示されるかを確認
    expect(screen.getByText("button.addSale")).toBeInTheDocument();

    // 子要素がレンダリングされているかを確認
    expect(screen.getByText("Test Content")).toBeInTheDocument();
  });

  //   it("applies font classes to body element", () => {
  //     render(
  //       <RootLayout>
  //         <main>Test Content</main>
  //       </RootLayout>
  //     );

  //     // フォントクラスがbodyに適用されているかを確認
  //     const bodyElement = document.querySelector("body");
  //     expect(bodyElement).toHaveClass("mocked-font-variable");
  //     expect(bodyElement).toHaveClass("antialiased");
  //     expect(bodyElement).toHaveClass("p-8");
  //   });
});
