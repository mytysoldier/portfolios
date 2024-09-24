import { HabbitContext } from "../lib/provider/HabbitContext";
import { useContext, useState } from "react";
import Modal from "react-modal";
import Button from "./Button";
import { Habbit } from "@/models/ui/habbit";

type AlertModalType = {
  modalIsOpen: boolean;
  modalText: string;
  onSubmitClick: VoidFunction;
  onCancelClick: VoidFunction;
};

export default function AlertModal({
  modalIsOpen,
  modalText,
  onSubmitClick,
  onCancelClick,
}: AlertModalType) {
  return (
    <Modal
      isOpen={modalIsOpen}
      overlayClassName="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-40"
      className="w-1/3 bg-white rounded-lg p-6 shadow-lg flex flex-col justify-between z-50"
    >
      <div>{modalText}</div>
      <div>
        <Button title="OK" onClick={onSubmitClick} className="mr-4" />
        <button type="button" onClick={onCancelClick}>
          キャンセル
        </button>
      </div>
    </Modal>
  );
}
