import { render, screen } from "@testing-library/react";
import { FormProvider, useForm } from "react-hook-form";
import { CustomDatePickerControl } from "../CustomDatePickerControl";

const TestWrapper = ({ children }: { children: React.ReactNode }) => {
  const methods = useForm({
    defaultValues: {
      testDate: new Date("2024-01-01"),
    },
  });

  return <FormProvider {...methods}>{children}</FormProvider>;
};

describe("CustomDatePickerControl", () => {
  test("描画されること", () => {
    render(
      <TestWrapper>
        <CustomDatePickerControl fieldName="testDate" />
      </TestWrapper>,
    );

    expect(screen.getByRole("textbox")).toBeInTheDocument();
  });

  test("初期値が反映されること", () => {
    render(
      <TestWrapper>
        <CustomDatePickerControl fieldName="testDate" />
      </TestWrapper>,
    );

    expect(screen.getByDisplayValue("2024/01/01")).toBeInTheDocument();
  });
});
