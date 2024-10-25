import { fireEvent, render, screen } from "@testing-library/react";
import { CustomDatePicker } from "../CustomDatePicker";

describe("CustomDatePickerコンポーネントのテスト", () => {
  beforeEach(() => {
    render(<CustomDatePicker />);
  });

  test("CustomDatePickerが表示されること", () => {
    const datePickerElement = screen.getByRole("textbox");
    expect(datePickerElement).toBeInTheDocument();
  });

  test("日付選択が反映されること", () => {
    const datePickerElement = screen.getByRole("textbox");

    // 日付選択をシミュレート
    expect(datePickerElement).toHaveValue("");
    fireEvent.change(datePickerElement, { target: { value: "2024-10-25" } });
    expect(datePickerElement).toHaveValue("10/25/2024");
  });
});
