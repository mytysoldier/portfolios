import { fireEvent, render, screen } from "@testing-library/react";
import Header from "../Header";

describe("Headerコンポーネントテスト", () => {
  beforeEach(() => {
    render(
      <Header
        trailingCaption="test caption"
        trailingTitle="test title"
        fontStyle="test style"
      />
    );
  });

  test("Headerコンポーネントが描画されること", () => {
    const headerElement = screen.getByText("Habbit Tracker");
    expect(headerElement).toBeInTheDocument();
  });
});
