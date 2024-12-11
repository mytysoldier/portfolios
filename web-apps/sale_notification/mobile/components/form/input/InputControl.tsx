import React from "react";
import {
  Controller,
  ControllerRenderProps,
  FieldPath,
  FieldValue,
  FieldValues,
} from "react-hook-form";
import { Input } from "./Input";
import { Keyboard, TextInput, TouchableWithoutFeedback } from "react-native";

type Props<T extends FieldValues> = {
  fieldName: FieldPath<T>;
} & Omit<
  React.ComponentPropsWithoutRef<typeof Input>,
  "errorMessage" | keyof ControllerRenderProps
>;

export const InputControl = <T extends FieldValues>({
  fieldName,
  ...props
}: Props<T>) => {
  return (
    <TouchableWithoutFeedback onPress={Keyboard.dismiss} accessible={false}>
      <Controller
        name={fieldName}
        render={({ field: { onChange, onBlur, value, ref }, fieldState }) => (
          <Input
            ref={ref as React.Ref<TextInput>}
            onChangeText={onChange}
            onBlur={onBlur}
            value={value}
            errorMessage={fieldState.error?.message}
            {...props}
          />
        )}
      />
    </TouchableWithoutFeedback>
  );
};
