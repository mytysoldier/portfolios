type ButtonProps = {
  title: string;
  onClick: VoidFunction;
};

export default function Button({ title, onClick }: ButtonProps) {
  return (
    <button onClick={onClick} className="bg-blue-500 rounded-lg p-4 text-white">
      {title}
    </button>
  );
}
