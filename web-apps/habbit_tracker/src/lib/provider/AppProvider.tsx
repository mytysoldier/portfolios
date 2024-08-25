import { ReactNode } from "react";
import { HabbitProvider } from "./HabbitContext";

export const AppProvider = ({ children }: { children: ReactNode }) => {
  return <HabbitProvider>{children}</HabbitProvider>;
};
