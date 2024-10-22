import classNames from "classnames";

export enum ButtonType {
  TEXT,
  PRIMARY,
}

type ButtonProps = {
  title: string;
  buttonType: ButtonType;
  onClick: VoidFunction;
};

export const Button: React.FC<ButtonProps> = ({
  title,
  buttonType,
  onClick,
}) => {
  const buttonClass = classNames("px-4 py-2 rounded-md text-base", {
    "bg-blue-500 text-white hover:bg-blue-600":
      buttonType === ButtonType.PRIMARY,
    "bg-transparent text-blue-500 hover:underline":
      buttonType === ButtonType.TEXT,
  });
  return (
    <button className={buttonClass} onClick={onClick}>
      {title}
    </button>
  );
};
