import { ReactNode } from "react";
import { HabbitProvider } from "./HabbitContext";
import { HabbitActivityProvider } from "./HabbitActivityContext";

export const AppProvider = ({ children }: { children: ReactNode }) => {
  return (
    <HabbitProvider>
      <HabbitActivityProvider>{children}</HabbitActivityProvider>
    </HabbitProvider>
  );
};
