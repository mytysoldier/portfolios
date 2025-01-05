import { Picker } from "@react-native-picker/picker";
import React, { useState } from "react";
import { StyleSheet, Text, View } from "react-native";
import Select from "react-select";
import RNPickerSelect from "react-native-picker-select";

type SelectItem = {
  label: string;
  value: string | number;
};

type Props = {
  items: SelectItem[];
  errorMessage?: string;
} & Omit<React.ComponentProps<typeof Picker>, "ref">;

export const SelectBox = React.forwardRef<any, Props>(
  ({ items, errorMessage, selectedValue, onValueChange, ...props }, ref) => {
    const [selectedLanguage, setSelectedLanguage] = useState("TypeScript");
    console.log("select items", selectedValue);
    return (
      <View style={styles.picker}>
        {/* <Picker {...props} ref={ref} mode="dialog">
          {items.map((item) => (
            <Picker.Item
              key={item.label}
              label={item.label}
              value={item.value}
            />
          ))}
          {errorMessage ? (
            <Text style={styles.errorText}>{errorMessage}</Text>
          ) : null}
        </Picker> */}
        <Picker
          selectedValue={selectedValue}
          onValueChange={onValueChange}
          mode="dialog"
        >
          {items.map((item) => (
            <Picker.Item
              key={item.label}
              label={item.label}
              value={item.value}
            />
          ))}
          {errorMessage ? (
            <Text style={styles.errorText}>{errorMessage}</Text>
          ) : null}
        </Picker>
        {/* <RNPickerSelect
          items={[
            { label: "TypeScript", value: "TypeScript" },
            { label: "Swift", value: "Swift" },
            { label: "Kotlin", value: "Kotlin" },
          ]}
          placeholder={{
            label: "アイテムを選んでください…",
            value: "",
            color: "#9EA0A4",
          }}
          value={selectedValue}
          // style={{
          //   inputIOS: styles.inputIOS,
          //   inputAndroid: styles.inputAndroid,
          // }}
          onValueChange={(value) => {
            setSelectedValue(value);
          }}
        /> */}
      </View>
    );
  }
);

const styles = StyleSheet.create({
  picker: {
    height: 150,
    // width: "100%",
    width: 120,
    // backgroundColor: "red",
  },
  errorText: {
    color: "red",
    fontSize: 12,
    marginTop: 5,
  },
});

SelectBox.displayName = "SelectBox";
