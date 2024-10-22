type TextProps = {
  text: string;
};

export const Text: React.FC<TextProps> = ({ text }) => {
  return <span className="text-lg">{text}</span>;
};
