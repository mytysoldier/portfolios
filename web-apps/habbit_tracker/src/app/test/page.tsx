"use client";
import { getAllHabbit, upsertHabbit } from "@/lib/prisma/habbit";
import { getAllUser, getUser } from "@/lib/prisma/user";
import { HabbitDto } from "@/models/db/habbitDto";
import { useEffect, useState } from "react";

export default function Test() {
  const addHabbit = async () => {
    const newHabbit = new HabbitDto(1, "new Habbit");
    try {
      console.log("start create");
      await upsertHabbit(newHabbit);
      console.log("end create");
    } catch (e) {
      console.error(`error: ${e}`);
    }
  };

  return (
    <>
      <div>test</div>
      <button type="button" onClick={addHabbit}>
        追加
      </button>
    </>
  );
}
