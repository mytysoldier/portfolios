import { render, screen } from "@testing-library/react";
import { Header } from "../Header";

describe("Headerコンポーネントのテスト", () => {
  beforeEach(() => {
    render(<Header title="Jestテスト" />);
  });

  test("Headerタイトルが表示されること", () => {
    const headerElement = screen.getByRole("heading", { level: 1 });
    expect(headerElement).toHaveTextContent("Jestテスト");
  });
});
