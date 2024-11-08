import React from "react";
import DatePicker from "react-datepicker";

type Props = {
  errorMessage?: string;
  selected?: Date | null;
} & Omit<React.ComponentProps<typeof DatePicker>, "onChange" | "selected"> & {
    onChange: (
      date: Date | null,
      event?: React.MouseEvent<HTMLElement> | React.KeyboardEvent<HTMLElement>,
    ) => void;
  };

export const CustomDatePicker = React.forwardRef<DatePicker, Props>(
  ({ errorMessage, selected, onChange }, ref) => (
    <>
      <DatePicker
        ref={ref}
        dateFormat="yyyy/MM/dd"
        selected={selected}
        onChange={onChange}
        className="border h-10"
        // {...props}
      />
      {errorMessage && <div className="text-danger">{errorMessage}</div>}
    </>
  ),
);

CustomDatePicker.displayName = "CustomDatePicker";
