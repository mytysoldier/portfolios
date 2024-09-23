import { HabbitContext } from "../lib/provider/HabbitContext";
import { useContext, useState } from "react";
import Modal from "react-modal";
import Button from "./Button";

type CustomModalType = {
  modalIsOpen: boolean;
  onCancelClick: VoidFunction;
};

export default function InputModal({
  modalIsOpen,
  onCancelClick,
}: CustomModalType) {
  const [title, setTitle] = useState("");
  const habbitContext = useContext(HabbitContext);

  if (!habbitContext) {
    throw new Error("HabbitContext must be used within a HabbitProvider");
  }

  const { addHabbit } = habbitContext;

  const handleSubmit = async () => {
    await addHabbit({ title });
    onCancelClick();
  };

  return (
    <Modal
      isOpen={modalIsOpen}
      overlayClassName="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-40"
      className="w-1/3 bg-white rounded-lg p-6 shadow-lg flex flex-col justify-between z-50"
    >
      <input
        type="text"
        value={title}
        onChange={(e) => setTitle(e.target.value)}
        placeholder="タイトルを入力"
        className="w-full p-2 mb-4 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
      />
      <div>
        <Button title="追加" onClick={handleSubmit} className="mr-4" />
        <button type="button" onClick={onCancelClick}>
          キャンセル
        </button>
      </div>
    </Modal>
  );
}
