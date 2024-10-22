import { render, screen } from "@testing-library/react";
import { Text } from "../Text";

describe("Textコンポーネントのテスト", () => {
  beforeEach(() => {
    render(<Text text="Jestテスト" />);
  });

  test("Text文言が表示されること", () => {
    const textElement = screen.getByText("Jestテスト");
    expect(textElement).toBeInTheDocument();
  });
});
