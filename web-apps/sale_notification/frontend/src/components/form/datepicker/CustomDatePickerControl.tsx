import {
  Controller,
  ControllerRenderProps,
  FieldPath,
  FieldValues,
} from "react-hook-form";
import { CustomDatePicker } from "./CustomDatePicker";

type Props<T extends FieldValues> = {
  fieldName: FieldPath<T>;
} & Omit<
  React.ComponentProps<typeof CustomDatePicker>,
  "errorMessage" | keyof ControllerRenderProps
>;

export const CustomDatePickerControl = <T extends FieldValues>({
  fieldName,
  ...props
}: Props<T>) => {
  return (
    <Controller
      name={fieldName}
      render={({ field, fieldState }) => (
        <CustomDatePicker
          selected={field.value}
          errorMessage={fieldState.error?.message}
          {...field}
          {...props}
        />
      )}
    />
  );
};
