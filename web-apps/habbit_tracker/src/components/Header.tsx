import Ribbon from "./Ribbon";

type HeaderType = {
  trailingCaption: string;
  trailingTitle: string;
  fontStyle: string;
};

export default function Header({
  trailingCaption,
  trailingTitle,
  fontStyle,
}: HeaderType) {
  return (
    <div className="flex justify-between">
      <div className="text-5xl text-pink-400">Habbit Tracker</div>
      <div className={`${fontStyle} w-64`}>
        <Ribbon caption={trailingCaption} title={trailingTitle} />
      </div>
    </div>
  );
}
