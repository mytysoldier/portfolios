import React from "react";
import { Text } from "react-native";
import { StyleSheet, TextInput, TextInputProps, View } from "react-native";

type Props = {
  errorMessage?: string;
} & TextInputProps;

export const Input = React.forwardRef<TextInput, Props>(
  ({ errorMessage, style, ...props }, ref) => (
    <View>
      <TextInput
        ref={ref}
        style={[styles.input, errorMessage && styles.inputError, style]}
        {...props}
      />
      {errorMessage ? (
        <Text style={styles.errorText}>{errorMessage}</Text>
      ) : null}
    </View>
  ),
);

Input.displayName = "Input";

const styles = StyleSheet.create({
  input: {
    height: 40,
    borderWidth: 1,
    borderColor: "#ccc",
    borderRadius: 4,
    paddingHorizontal: 10,
    backgroundColor: "#fff",
    marginBottom: 5,
  },
  inputError: {
    borderColor: "red",
  },
  errorText: {
    color: "red",
    fontSize: 12,
    marginBottom: 10,
  },
});
