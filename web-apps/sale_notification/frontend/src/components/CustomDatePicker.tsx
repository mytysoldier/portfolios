import { useState } from "react";
import DatePicker from "react-datepicker";

import "react-datepicker/dist/react-datepicker.css";

// type DatePiclerProps = {};

export const CustomDatePicker: React.FC = () => {
  const [startDate, setStartDate] = useState<Date | null>(null);
  return (
    <DatePicker
      selected={startDate}
      onChange={(date) => date && setStartDate(date)}
      className="px-4 py-2 border rounded-md shadow-sm focus:outline-none focus:border-blue-500"
      // wrapperClassName="w-full"
      popperPlacement="top"
    />
  );
};
