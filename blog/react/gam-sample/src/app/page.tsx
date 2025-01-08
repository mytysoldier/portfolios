"use client";
import { initializeGpt } from "@/script/gpt";
import { useEffect } from "react";

export default function Home() {
  useEffect(() => {
    import("../script/gpt");
    initializeGpt();
  }, []);
  return (
    <div>
      <div>以下のGAMテスト広告を表示</div>
      <div id="gam-display"></div>
    </div>
  );
}
