import { fireEvent, render, screen } from "@testing-library/react";
import Button from "../Button";

describe("Buttonコンポーネントテスト", () => {
  // モック関数を作成
  const handleClick = jest.fn();

  beforeEach(() => {
    render(<Button title="Buttonテスト" onClick={handleClick} />);
  });

  test("タイトルが正しく表示されること", () => {
    const buttonElement = screen.getByRole("button");
    expect(buttonElement).toHaveTextContent("Buttonテスト");
  });

  test("クリックイベントが行われること", () => {
    const buttonElement = screen.getByRole("button");

    // クリックイベントをシミュレート
    fireEvent.click(buttonElement);

    // クリックイベントが呼ばれたことを確認
    expect(handleClick).toHaveBeenCalledTimes(1);
  });
});
