import {
  Controller,
  ControllerRenderProps,
  FieldPath,
  FieldValues,
} from "react-hook-form";
import { CustomDatePicker } from "./CustomDatePicker";
import { Keyboard, TouchableWithoutFeedback } from "react-native";

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
      render={({ field: { onChange, onBlur, value, ref }, fieldState }) => (
        <CustomDatePicker
          ref={ref}
          selected={value}
          onChange={onChange}
          errorMessage={fieldState.error?.message}
          // {...field}
          {...props}
        />
      )}
    />
  );
};
