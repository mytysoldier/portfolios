type ButtonProps = {
  title: string;
  onClick: VoidFunction;
  className?: string;
};

export default function Button({
  title,
  onClick,
  className = "",
}: ButtonProps) {
  return (
    <button
      onClick={onClick}
      className={`bg-blue-500 rounded-lg p-4 text-white ${className}`}
    >
      {title}
    </button>
  );
}
