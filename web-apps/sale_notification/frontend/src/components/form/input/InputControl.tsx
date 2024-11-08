import {
  Controller,
  ControllerRenderProps,
  FieldPath,
  FieldValues,
} from "react-hook-form";
import { Input } from "./Input";

type Props<T extends FieldValues> = {
  fieldName: FieldPath<T>;
} & Omit<
  React.ComponentProps<typeof Input>,
  "errorMessage" | keyof ControllerRenderProps
>;

export const InputControl = <T extends FieldValues>({
  fieldName,
  ...props
}: Props<T>) => {
  return (
    <Controller
      name={fieldName}
      render={({ field, fieldState }) => (
        <Input errorMessage={fieldState.error?.message} {...field} {...props} />
      )}
    />
  );
};
