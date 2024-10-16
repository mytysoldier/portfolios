"use client";
import Image from "next/image";
import { SharedButton } from "shared";

export default function Home() {
  return (
    <div>
      <SharedButton label="test" onClick={() => alert("")} />
    </div>
  );
}
