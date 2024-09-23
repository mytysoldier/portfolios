"use client";
import { Habbit } from "@/models/ui/habbit";
import { createContext, ReactNode, useEffect, useId, useState } from "react";
import { getAllHabbitByUserId } from "../prisma/habbit";
import { title } from "process";

type HabbitContextType = {
  habbits: Habbit[];
  addHabbit: (newHabbit: Habbit) => Promise<void>;
};

export const HabbitContext = createContext<HabbitContextType | undefined>(
  undefined
);

export const HabbitProvider = ({ children }: { children: ReactNode }) => {
  // TODO あとで修正、デフォルト値を[]に戻す
  const [habbits, setHabbits] = useState<Habbit[]>([]);

  useEffect(() => {
    const fetchHabbits = async () => {
      // TODO ログイン情報から取得する
      const userId = 1;
      try {
        const response = await fetch(`/api/habbit/${userId}`);
        if (!response.ok) {
          throw new Error("Failed to get habbit data");
        }
        const jsonResponse = await response.json();
        console.log(`response data: ${JSON.stringify(jsonResponse)}`);
        const data: Habbit[] = jsonResponse.data.map((item: any) => ({
          id: item.id,
          userId: item.user_id,
          title: item.title,
          createdAt: item.created_at,
          updatedAt: item.updated_at,
          deletedAt: item.deleted_at,
        }));
        console.log(`mapped response data: ${JSON.stringify(data)}`);
        setHabbits(data);
      } catch (error) {
        console.error("Failed to fetch habbits:", error);
      }
    };

    fetchHabbits();
  }, []);

  const addHabbit = async (newHabbit: Habbit) => {
    // TODO ログイン情報から取得する
    const userId = 1;
    try {
      const response = await fetch(`/api/habbit/${userId}`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          user_id: userId,
          title: newHabbit.title,
        }),
      });
      if (!response.ok) {
        throw new Error("Failed to add habbit data");
      }
      const jsonResponse = await response.json();
      console.log(`added response data: ${JSON.stringify(jsonResponse)}`);
      // const data: Habbit = jsonResponse.data.map((item: any) => ({
      //   id: item.id,
      //   userId: item.user_id,
      //   title: item.title,
      //   createdAt: item.created_at,
      //   updatedAt: item.updated_at,
      //   deletedAt: item.deleted_at,
      // }));
      const data: Habbit = {
        id: jsonResponse.data.id,
        userId: jsonResponse.data.user_id,
        title: jsonResponse.data.title,
        createdAt: jsonResponse.data.created_at,
        updatedAt: jsonResponse.data.updated_at,
        deletedAt: jsonResponse.data.deleted_at,
      };
      console.log(`added mapped response data: ${JSON.stringify(data)}`);
      // TODO
      setHabbits((prevHabbits) => [...prevHabbits, data]);
    } catch (error) {
      console.error("Failed to add habbit:", error);
    }
  };

  return (
    <HabbitContext.Provider value={{ habbits, addHabbit }}>
      {children}
    </HabbitContext.Provider>
  );
};
