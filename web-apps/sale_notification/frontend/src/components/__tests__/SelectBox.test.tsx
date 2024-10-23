import { fireEvent, render, screen } from "@testing-library/react";
import { useState } from "react";
import { SelectBox, SelectBoxOption } from "../SelectBox";

describe("SelectBoxコンポーネントのテスト", () => {
  const selectBoxOptions: SelectBoxOption[] = [
    { label: "未開始", value: "NotStarted" },
    { label: "開催中", value: "Starting" },
    { label: "終了", value: "Finished" },
  ];

  const SelectBoxWrapper = ({ initialValue = "", disabled = false }) => {
    const [value, setValue] = useState(initialValue);
    return (
      <SelectBox
        options={selectBoxOptions}
        value={value}
        onChange={(e) => setValue(e.target.value)}
        disabled={disabled}
      />
    );
  };

  test("プレースホルダーが表示されること", () => {
    render(<SelectBoxWrapper />);
    const selectBoxElement = screen.getByText("未選択");
    expect(selectBoxElement).toBeInTheDocument();
  });

  test("オプションが表示されること", () => {
    render(<SelectBoxWrapper />);
    selectBoxOptions.forEach((option) => {
      const optionElement = screen.getByText(option.label);
      expect(optionElement).toBeInTheDocument();
    });
  });

  test("オプション選択時に値が反映されること", () => {
    render(<SelectBoxWrapper />);
    const selectBoxElement = screen.getByRole("combobox");

    // オプション選択のテスト
    selectBoxOptions.forEach((option) => {
      fireEvent.change(selectBoxElement, { target: { value: option.value } });
      expect(selectBoxElement).toHaveValue(option.value);
    });
  });

  test("無効状態のときに選択ができないこと", () => {
    render(<SelectBoxWrapper disabled={true} />);

    const selectBoxElement = screen.getByRole("combobox");
    expect(selectBoxElement).toBeDisabled();
  });
});
