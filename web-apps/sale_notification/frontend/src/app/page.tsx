"use client";

import { Button, ButtonType } from "@/components/Button";
import { Text } from "@/components/Text";

export default function Home() {
  return (
    <div>
      <Button title="test" buttonType={ButtonType.TEXT} onClick={() => {}} />
      <Button title="test" buttonType={ButtonType.PRIMARY} onClick={() => {}} />
      <Text text="セール" />
    </div>
  );
}
