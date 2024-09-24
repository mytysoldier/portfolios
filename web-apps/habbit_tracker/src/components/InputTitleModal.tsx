import { HabbitContext } from "../lib/provider/HabbitContext";
import { useContext, useState } from "react";
import Modal from "react-modal";
import Button from "./Button";
import { Habbit } from "@/models/ui/habbit";
import { deleteHabbit } from "@/lib/prisma/habbit";

export enum CustomModalActionType {
  CREATE,
  UPDATE,
  DELETE,
}

type CustomModalType = {
  actionType: CustomModalActionType;
  modalIsOpen: boolean;
  inputHabbit?: Habbit;
  onCancelClick: VoidFunction;
};

export default function InputTitleModal({
  actionType,
  modalIsOpen,
  onCancelClick,
  inputHabbit,
}: CustomModalType) {
  const [title, setTitle] = useState(inputHabbit?.title ?? "");
  const habbitContext = useContext(HabbitContext);

  if (!habbitContext) {
    throw new Error("HabbitContext must be used within a HabbitProvider");
  }

  const { addHabbit, updateHabbit, deleteHabbit } = habbitContext;

  const handleSubmit = async () => {
    switch (actionType) {
      case CustomModalActionType.CREATE:
        await addHabbit({ title });
        break;
      case CustomModalActionType.UPDATE:
        await updateHabbit({ id: inputHabbit?.id, title });
        break;
      default:
        break;
    }
    // モーダルを閉じる
    onCancelClick();
  };

  const handleDelete = async () => {
    await deleteHabbit(inputHabbit?.id!);
    // モーダルを閉じる
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
        <Button
          title={actionType === CustomModalActionType.CREATE ? "追加" : "更新"}
          onClick={handleSubmit}
          className="mr-4"
        />
        {actionType === CustomModalActionType.UPDATE && (
          <Button title="削除" onClick={handleDelete} className="mr-4" />
        )}
        <button type="button" onClick={onCancelClick}>
          キャンセル
        </button>
      </div>
    </Modal>
  );
}
