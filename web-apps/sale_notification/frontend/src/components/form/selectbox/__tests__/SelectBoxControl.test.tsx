import { Form, formSchema } from "@/app/list/components/yupForm";
import { yupResolver } from "@hookform/resolvers/yup";
import { render, screen } from "@testing-library/react";
import { FormProvider, useForm } from "react-hook-form";
import { SelectBoxControl } from "../SelectBoxControl";
import userEvent from "@testing-library/user-event";

const FormWrapper = ({ children }: { children: React.ReactNode }) => {
  const methods = useForm({
    defaultValues: {
      saleStatus: "",
    },
    mode: "onChange",
    resolver: yupResolver(formSchema),
  });
  return <FormProvider {...methods}>{children}</FormProvider>;
};

describe("SelectBoxControl", () => {
  const testItems = [
    { label: "Option 1", value: "1" },
    { label: "Option 2", value: "2" },
    { label: "Option 3", value: "3" },
    { label: "未選択", value: "" },
  ];

  test("描画されること", () => {
    render(
      <FormWrapper>
        <SelectBoxControl fieldName="saleStatus" items={testItems} />
      </FormWrapper>,
    );

    expect(screen.getByText("未選択")).toBeInTheDocument();
  });

  test("選択肢が表示されること", () => {
    render(
      <FormWrapper>
        <SelectBoxControl fieldName="saleStatus" items={testItems} />
      </FormWrapper>,
    );

    testItems.forEach((item) => {
      expect(screen.getByText(item.label)).toBeInTheDocument();
    });
  });

  test("ユーザー選択が反映されること", async () => {
    render(
      <FormWrapper>
        <SelectBoxControl<Form> fieldName="saleStatus" items={testItems} />
      </FormWrapper>,
    );

    const select = screen.getByRole("combobox");
    await userEvent.selectOptions(select, "2");

    expect((select as HTMLSelectElement).value).toBe("2");
  });
});
