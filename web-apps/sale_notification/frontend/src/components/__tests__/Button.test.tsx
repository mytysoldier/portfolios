import { fireEvent, render, screen } from "@testing-library/react";
import { Button, ButtonType } from "../Button";

describe("Text Buttonコンポーネントのテスト", () => {
  // ButtonコンポーネントのonClickイベントテスト用
  let handleClick: jest.Mock;

  beforeEach(() => {
    handleClick = jest.fn();
    render(
      <Button
        title="Jestテスト"
        buttonType={ButtonType.TEXT}
        onClick={handleClick}
      />
    );
  });

  test("Text Buttonが表示されること", () => {
    const buttonElement = screen.getByRole("button");
    expect(buttonElement).toHaveTextContent("Jestテスト");
  });

  test("Text ButtonのonClickが動作すること", () => {
    const buttonElement = screen.getByRole("button");

    fireEvent.click(buttonElement);
    expect(handleClick).toHaveBeenCalledTimes(1);
  });
});

describe("Primary Buttonコンポーネントのテスト", () => {
  // ButtonコンポーネントのonClickイベントテスト用
  let handleClick: jest.Mock;

  beforeEach(() => {
    handleClick = jest.fn();
    render(
      <Button
        title="Jestテスト"
        buttonType={ButtonType.PRIMARY}
        onClick={handleClick}
      />
    );
  });

  test("Primary Buttonが表示されること", () => {
    const buttonElement = screen.getByRole("button");
    expect(buttonElement).toHaveTextContent("Jestテスト");
  });

  test("Primary ButtonのonClickが動作すること", () => {
    const buttonElement = screen.getByRole("button");

    fireEvent.click(buttonElement);
    expect(handleClick).toHaveBeenCalledTimes(1);
  });
});
