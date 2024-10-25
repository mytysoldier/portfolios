"use client";

import { Button, ButtonType } from "@/components/Button";
import { CustomDatePicker } from "@/components/CustomDatePicker";
import { SelectBox } from "@/components/SelectBox";
import { Text } from "@/components/Text";
import { TextArea } from "@/components/TextArea";

export default function Home() {
  return (
    <div>
      <Button title="test" buttonType={ButtonType.TEXT} onClick={() => {}} />
      <Button title="test" buttonType={ButtonType.PRIMARY} onClick={() => {}} />
      <Text text="セール" />
      <TextArea value={""} onChange={() => {}} />
      <SelectBox
        options={[
          { label: "aaa", value: "aaa" },
          { label: "bbb", value: "bbb" },
        ]}
        value={""}
        onChange={() => {}}
      />
      <CustomDatePicker />
    </div>
  );
}
