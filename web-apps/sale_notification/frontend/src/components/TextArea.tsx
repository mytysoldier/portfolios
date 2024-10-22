import { ChangeEvent } from "react";

type TextAreaProps = {
  value: string;
  onChange: (e: ChangeEvent<HTMLTextAreaElement>) => void;
  maxLength?: number;
  placeholder?: string;
};

export const TextArea: React.FC<TextAreaProps> = ({
  value,
  onChange,
  maxLength = 100,
  placeholder,
}) => {
  return (
    <textarea
      className="w-full p-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
      placeholder={placeholder}
      value={value}
      onChange={onChange}
      maxLength={maxLength}
      rows={1}
    />
  );
};
