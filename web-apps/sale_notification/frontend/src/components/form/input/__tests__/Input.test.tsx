import { render, screen } from "@testing-library/react";
import { Input } from "../Input";
import React from "react";

describe("Input", () => {
  test(" 描画されること", () => {
    render(<Input />);

    expect(screen.getByRole("textbox")).toBeInTheDocument();
  });

  test("エラーメッセージが表示されること", () => {
    const errorMessage = "test error message";

    render(<Input errorMessage={errorMessage} />);

    expect(screen.getByText(errorMessage)).toBeInTheDocument();
  });

  test("エラーがなければエラーメッセージが表示されないこと", () => {
    render(<Input />);

    expect(screen.queryByRole("text-danger")).not.toBeInTheDocument();
  });

  test("forward refが正しく渡されること", () => {
    const ref = React.createRef<HTMLInputElement>();
    render(<Input ref={ref} />);
    expect(ref.current).toBeInstanceOf(HTMLInputElement);
  });

  test("その他のPropsが渡せること", () => {
    const placeholder = "test placeholder";
    render(<Input placeholder={placeholder} data-testid="input" />);

    const input = screen.getByTestId("input");
    expect(input).toHaveAttribute("placeholder", placeholder);
  });

  test("form-controlCSSクラスが反映されること", () => {
    render(<Input />);
    expect(screen.getByRole("textbox")).toHaveClass("form-control");
  });
});
