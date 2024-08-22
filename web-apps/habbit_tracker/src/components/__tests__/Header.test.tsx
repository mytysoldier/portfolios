import { fireEvent, render, screen } from "@testing-library/react";
import Header from "../Header";

describe("Headerコンポーネントテスト", () => {
  beforeEach(() => {
    render(
      <Header
        trailingCaption="test caption"
        trailingTitle="test title"
        fontStyle="testStyle"
      />
    );
  });

  test("Headerコンポーネントが描画されること", () => {
    const headerElement = screen.getByText("Habbit Tracker");
    expect(headerElement).toBeInTheDocument();
  });

  test("trailingCaptionが正しく表示されること", () => {
    const headerElement = screen.getByText("test title");
    expect(headerElement).toBeInTheDocument();
  });

  test("trailingTitleが正しく表示されること", () => {
    const headerElement = screen.getByText("test title");
    expect(headerElement).toBeInTheDocument();
  });

  test("fontStyleが適用されること", () => {
    const headerElement = screen.getByText("Habbit Tracker").nextSibling;
    expect(headerElement).toHaveClass("testStyle");
  });
});
