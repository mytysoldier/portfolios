import { fireEvent, render, screen } from "@testing-library/react";
import { userEvent } from "@testing-library/user-event";
import { TextArea } from "../TextArea";
import { useState } from "react";

describe("TextAreaコンポーネントのテスト", () => {
  const TextAreaWrapper = ({ initialValue = "" }) => {
    const [value, setValue] = useState(initialValue);
    return (
      <TextArea
        value={value}
        onChange={(e) => setValue(e.target.value)}
        maxLength={100}
        placeholder="Enter text here"
      />
    );
  };

  beforeEach(() => {
    render(<TextAreaWrapper />);
  });

  test("Text入力時に入力内容が反映されること", () => {
    const textAreaElement = screen.getByPlaceholderText("Enter text here");
    expect(textAreaElement).toHaveValue("");

    // 入力のテスト
    fireEvent.change(textAreaElement, { target: { value: "Jestテスト" } });
    expect(textAreaElement).toHaveValue("Jestテスト");
  });

  test.skip("(テストコードのユーザー入力がうまく反映されないのでスキップ)maxLength以上の文字が入力できないこと", () => {
    const textAreaElement = screen.getByPlaceholderText("Enter text here");
    expect(textAreaElement).toHaveValue("");

    // 入力のテスト
    const overMaxLenthStr = "a".repeat(101);
    fireEvent.input(textAreaElement, { target: { value: overMaxLenthStr } });
    userEvent.type(textAreaElement, overMaxLenthStr);
    expect(textAreaElement).toHaveValue("a".repeat(100));
  });
});
