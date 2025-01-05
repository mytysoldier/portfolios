import {
  Controller,
  ControllerRenderProps,
  FieldPath,
  FieldValues,
} from "react-hook-form";
import { SelectBox } from "./SelectBox";

type Props<T extends FieldValues> = {
  fieldName: FieldPath<T>;
} & Omit<
  React.ComponentProps<typeof SelectBox>,
  "errorMessage" | keyof ControllerRenderProps
>;

export const SelectBoxControl = <T extends FieldValues>({
  fieldName,
  ...props
}: Props<T>) => {
  return (
    <Controller
      name={fieldName}
      render={({ field: { value, onChange }, fieldState }) => (
        <SelectBox
          errorMessage={fieldState.error?.message}
          selectedValue={value}
          onValueChange={onChange}
          // {...field}
          {...props}
        />
      )}
    />
  );
};
