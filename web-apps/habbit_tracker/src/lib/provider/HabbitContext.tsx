"use client";
import { Habbit } from "@/models/ui/habbit";
import { createContext, ReactNode, useState } from "react";

type HabbitContextType = {
  habbits: Habbit[];
  addHabbit: (newHabbit: Habbit) => void;
};

export const HabbitContext = createContext<HabbitContextType | undefined>(
  undefined
);

export const HabbitProvider = ({ children }: { children: ReactNode }) => {
  // TODO あとで修正、デフォルト値を[]に戻す
  const [habbits, setHabbits] = useState<Habbit[]>([
    { title: "テストタイトル" },
  ]);

  const addHabbit = (newHabbit: Habbit) => {
    setHabbits((prevHabbits) => [...prevHabbits, newHabbit]);
  };

  return (
    <HabbitContext.Provider value={{ habbits, addHabbit }}>
      {children}
    </HabbitContext.Provider>
  );
};
