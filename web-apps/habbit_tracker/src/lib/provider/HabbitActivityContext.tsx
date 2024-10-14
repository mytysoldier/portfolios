"use client";
import { HabbitActivity } from "@/models/ui/habbit_activity";
import { createContext, ReactNode } from "react";

type HabbitActivbityContextType = {
  addHabbitActivity: (newHabbitActivity: HabbitActivity) => Promise<void>;
  updateHabbitActivity: (habbitActivity: HabbitActivity) => Promise<void>;
};

export const HabbitActivityContext = createContext<
  HabbitActivbityContextType | undefined
>(undefined);

export const HabbitActivityProvider = ({
  children,
}: {
  children: ReactNode;
}) => {
  const addHabbitActivity = async (newHabbitActivity: HabbitActivity) => {
    try {
      const response = await fetch("/api/habbit_activity", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          habbit_id: newHabbitActivity.habbitId,
          checked: newHabbitActivity.checked,
          id: newHabbitActivity.id,
          created_at: newHabbitActivity.createdAt,
        }),
      });
      if (!response.ok) {
        throw new Error("Failed to add habbit activity data");
      }
      const jsonResponse = await response.json();
      console.log(`added response data: ${JSON.stringify(jsonResponse)}`);
    } catch (error) {
      console.error("Failed to add habbit activity:", error);
    }
  };
  const updateHabbitActivity = async (habbitActivity: HabbitActivity) => {
    try {
      const response = await fetch("/api/habbit_activity", {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          habbit_activity_id: habbitActivity.id,
          habbit_id: habbitActivity.habbitId,
          checked: habbitActivity.checked,
        }),
      });
      if (!response.ok) {
        throw new Error("Failed to update habbit activity data");
      }
      const jsonResponse = await response.json();
      console.log(`updated response data: ${JSON.stringify(jsonResponse)}`);
    } catch (error) {
      console.error("Failed to update habbit activity:", error);
    }
  };
  return (
    <HabbitActivityContext.Provider
      value={{ addHabbitActivity, updateHabbitActivity }}
    >
      {children}
    </HabbitActivityContext.Provider>
  );
};
