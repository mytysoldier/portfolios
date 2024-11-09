import { render, screen } from "@testing-library/react";
import { SelectBox } from "../SelectBox";
import userEvent from "@testing-library/user-event";

describe("SelectBox", () => {
  const testItems = [
    { label: "Option 1", value: "1" },
    { label: "Option 2", value: "2" },
    { label: "Option 3", value: "3" },
  ];

  test("全ての選択肢が正しく表示されること", () => {
    render(<SelectBox items={testItems} />);

    testItems.forEach((item) => {
      expect(screen.getByText(item.label)).toBeInTheDocument();
    });
  });

  test("エラーメッセージが与えられたら表示されること", () => {
    const errorMessage = "test error message";
    render(<SelectBox items={testItems} errorMessage={errorMessage} />);

    expect(screen.getByText(errorMessage)).toBeInTheDocument();
  });

  test("エラーメッセージが与えられなければ表示されないこと", () => {
    render(<SelectBox items={testItems} />);

    const errorElements = screen.queryByRole("text-danger");

    expect(errorElements).not.toBeInTheDocument();
  });

  test("他の選択肢が選択できること", async () => {
    const handleChange = jest.fn();
    render(<SelectBox items={testItems} onChange={handleChange} />);

    const select = screen.getByRole("combobox");
    await userEvent.selectOptions(select, "2");

    expect(handleChange).toHaveBeenCalled();
    expect((select as HTMLSelectElement).value).toBe("2");
  });
});
