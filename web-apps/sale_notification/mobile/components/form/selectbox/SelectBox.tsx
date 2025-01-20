import { Picker } from "@react-native-picker/picker";
import React, { useState } from "react";
import { StyleSheet, Text, TextInput, View } from "react-native";
import Select from "react-select";
import RNPickerSelect from "react-native-picker-select";
import ModalSelector from "react-native-modal-selector";

type SelectItem = {
  key?: number;
  label: string;
  value: string | number;
};

type Props = {
  items: SelectItem[];
  selectedValue?: string | number;
  onValueChange?: (itemValue: unknown, itemIndex: number) => void;
  errorMessage?: string;
} & Omit<React.ComponentProps<typeof ModalSelector>, "ref">;

export const SelectBox = React.forwardRef<any, Props>(
  ({ items, errorMessage, selectedValue, onValueChange, ...props }, ref) => {
    const [selectedLanguage, setSelectedLanguage] = useState("TypeScript");
    console.log("select items", selectedValue);

    let modalRef: any = null;

    const itemsWithKeys = items.map((item, index) => ({
      ...item,
      key: item.key || index,
    }));

    return (
      <View style={styles.picker}>
        <ModalSelector
          data={itemsWithKeys}
          selectTextStyle={styles.modal}
          initValue={selectedValue as string}
          onChange={(option) => {
            console.log("option");
            if (onValueChange) {
              onValueChange(option.value, option.key);
            }
            // if (modalRef) {
            //   modalRef.close();
            // }
          }}
          ref={(selector) => {
            modalRef = selector;
          }}
        >
          {/* <TextInput editable={false} value={selectedValue as string} /> */}
        </ModalSelector>
        {/* <Picker
          {...props}
          ref={ref}
          mode="dialog"
          placeholder="選択してください"
          selectionColor="blue"
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
        </Picker> */}
        {/* <Picker
          selectedValue={selectedValue}
          onValueChange={onValueChange}
          mode="dialog"
        >
          {items.map((item) => (
            <Picker.Item
              key={item.label}
              label={item.label}
              value={item.value}
              color="blue"
            />
          ))}
          {errorMessage ? (
            <Text style={styles.errorText}>{errorMessage}</Text>
          ) : null}
        </Picker> */}
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
    // height: 150,
    // height: 50,
    width: "100%",
    // color: "black",
    // width: 120,
    // backgroundColor: "red",
  },
  modal: {
    color: "blue",
  },
  errorText: {
    color: "red",
    fontSize: 12,
    marginTop: 5,
  },
});

SelectBox.displayName = "SelectBox";
