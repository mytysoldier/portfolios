import React, { useState } from "react";
import DatePicker from "react-native-ui-datepicker";
import {
  Modal,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from "react-native";
import {
  DateType,
  SingleChange,
} from "react-native-ui-datepicker/lib/typescript/src/types";

type Props = {
  errorMessage?: string;
  selected?: Date | null;
} & Omit<React.ComponentProps<typeof DatePicker>, "onDateChange" | "date"> & {
    onChange: (date: Date | null) => void;
  };

export const CustomDatePicker = React.forwardRef<typeof DatePicker, Props>(
  ({ errorMessage, selected, onChange, ...props }, ref) => {
    const [isPickerVisible, setPickerVisible] = useState(false);

    const handleConfirm = (date: Date) => {
      setPickerVisible(false);
      onChange(date);
    };
    return (
      <View>
        <TouchableOpacity
          onPress={() => {
            console.log("onPress picker");
            setPickerVisible(true);
          }}
          style={styles.touchable}
        >
          <Text style={styles.textInput}>
            {selected ? selected.toDateString() : "Select date"}
          </Text>
        </TouchableOpacity>

        <Modal
          transparent={true}
          animationType="slide"
          visible={isPickerVisible}
          onRequestClose={() => setPickerVisible(false)}
          onDismiss={() => setPickerVisible(false)}
        >
          <View style={styles.modalContainer}>
            <View style={styles.pickerContainer}>
              <DatePicker
                date={selected || new Date()}
                onChange={(params: { date: DateType }) => {
                  console.log("onChange picker");
                  console.log(params);
                  handleConfirm(new Date(params.date as string));
                }}
                mode="single"
                // {...props}
              />
              <TouchableOpacity onPress={() => setPickerVisible(false)}>
                <Text style={styles.closeButton}>Close</Text>
              </TouchableOpacity>
            </View>
          </View>
        </Modal>
        {errorMessage && <Text style={styles.errorText}>{errorMessage}</Text>}
      </View>
    );
  }
);

CustomDatePicker.displayName = "CustomDatePicker";

const styles = StyleSheet.create({
  touchable: {
    width: "100%",
  },
  textInput: {
    height: 140,
    backgroundColor: "red",
    borderBottomWidth: 1,
    borderColor: "#ccc",
    padding: 10,
  },
  modalContainer: {
    // flex: 1,
    height: "100%",
    justifyContent: "center",
    alignItems: "center",
    backgroundColor: "rgba(0, 0, 0, 0.5)",
  },
  pickerContainer: {
    backgroundColor: "white",
    padding: 20,
    borderRadius: 10,
    alignItems: "center",
  },
  closeButton: {
    marginTop: 20,
    color: "blue",
  },
  errorText: {
    color: "red",
    marginTop: 5,
  },
});
