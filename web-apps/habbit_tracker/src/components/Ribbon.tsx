import "./css/component.css";

type RibbonType = {
  caption: string;
  title: string;
};

export default function Ribbon({ caption, title }: RibbonType) {
  return (
    <div className="bg-pink-200 p-2 text-lg ribbon-cut w-64 h-16">
      <div>{caption}</div>
      <div className="text-2xl text-center">{title}</div>
    </div>
  );
}
