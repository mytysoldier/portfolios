import WeekCalendar from "@/components/WeekCalendar";
import { AppProvider } from "@/lib/provider/AppProvider";
import { HabbitContext } from "@/lib/provider/HabbitContext";
import Image from "next/image";
import { useContext } from "react";

export default function Home() {
  return (
    <AppProvider>
      <WeekCalendar />
    </AppProvider>
  );
}
