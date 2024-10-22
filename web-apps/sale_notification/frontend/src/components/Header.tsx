type HeaderProps = {
  title: string;
};

export const Header: React.FC<HeaderProps> = ({ title }) => {
  return (
    <header className="p-4 text-center">
      <h1 className="text-xl font-bold">{title}</h1>
    </header>
  );
};
