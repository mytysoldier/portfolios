import { fireEvent, render, screen } from "@testing-library/react";
import { CustomDatePicker } from "../CustomDatePicker";

describe("CustomDatePicker", () => {
  const handleChange = jest.fn();

  test("描画されること", () => {
    render(<CustomDatePicker onChange={handleChange} />);
    expect(screen.getByRole("textbox")).toBeInTheDocument();
  });

  test("選択した日付が反映されること", () => {
    const selectedDate = new Date("2024-01-01");
    render(
      <CustomDatePicker onChange={handleChange} selected={selectedDate} />,
    );
    expect(screen.getByDisplayValue("2024/01/01")).toBeInTheDocument();
  });

  test("エラーメッセージが表示されること", () => {
    const errorMessage = "test error message";
    render(
      <CustomDatePicker onChange={handleChange} errorMessage={errorMessage} />,
    );
    expect(screen.getByText(errorMessage)).toBeInTheDocument();
  });

  test("日付を選択した時に、onChangeイベントが発火すること", () => {
    render(<CustomDatePicker onChange={handleChange} />);

    const input = screen.getByRole("textbox");
    fireEvent.change(input, { target: { value: "2024/01/01" } });

    expect(handleChange).toHaveBeenCalled();
  });

  test("classNameが設定されていること", () => {
    render(<CustomDatePicker onChange={handleChange} />);
    const input = screen.getByRole("textbox");
    expect(input).toHaveClass("border", "h-10", "text-black");
  });
});
