import { render, screen } from "@testing-library/react";
import { FormProvider, useForm } from "react-hook-form";
import { InputControl } from "../InputControl";
import userEvent from "@testing-library/user-event";
import { Form, formSchema } from "@/app/list/components/yupForm";
import { yupResolver } from "@hookform/resolvers/yup";

const FormWrapper = ({ children }: { children: React.ReactNode }) => {
  const methods = useForm({
    defaultValues: {
      saleName: "",
    },
    mode: "onChange",
    resolver: yupResolver(formSchema),
  });
  return <FormProvider {...methods}>{children}</FormProvider>;
};

describe("InputControl", () => {
  test("描画されること", () => {
    render(
      <FormWrapper>
        <InputControl fieldName="test" placeholder="testplaceholder" />
      </FormWrapper>,
    );

    expect(screen.getByPlaceholderText("testplaceholder")).toBeInTheDocument();
  });

  test("Userインプットが正しく反映されること", async () => {
    render(
      <FormWrapper>
        <InputControl fieldName="saleName" placeholder="testplaceholder" />
      </FormWrapper>,
    );

    const input = screen.getByPlaceholderText("testplaceholder");
    await userEvent.type(input, "Hello");

    expect(input).toHaveValue("Hello");
  });

  test("バリデーションエラーがあった際にエラーメッセージが表示されること", async () => {
    const user = userEvent.setup();

    render(
      <FormWrapper>
        <InputControl<Form> fieldName="saleName" placeholder="test" />
      </FormWrapper>,
    );

    const input = screen.getByPlaceholderText("test");

    await user.type(input, "123456");
    expect(
      screen.queryByText("セール名は5文字以内で入力してください。"),
    ).toBeInTheDocument();
  });
});
