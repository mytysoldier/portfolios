import React from "react";

type SelectItem = {
  label: string;
  value: string | number;
};

type Props = {
  items: SelectItem[];
  errorMessage?: string;
} & React.ComponentProps<"select">;

export const SelectBox = React.forwardRef<HTMLSelectElement, Props>(
  ({ items, errorMessage, ...props }, ref) => (
    <>
      <select className="form-select" ref={ref} {...props}>
        {items.map((item) => (
          <option key={item.label} value={item.value}>
            {item.label}
          </option>
        ))}
      </select>
      {errorMessage ? <div className="text-danger">{errorMessage}</div> : null}
    </>
  ),
);

SelectBox.displayName = "SelectBox";
