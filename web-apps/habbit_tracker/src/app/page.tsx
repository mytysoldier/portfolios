import WeekCalendar from "@/components/WeekCalendar";
import WeekTrackerTable from "@/components/WeekTrackerTable";
import { AppProvider } from "@/lib/provider/AppProvider";
import { HabbitContext } from "@/lib/provider/HabbitContext";
import Image from "next/image";
import React, { useMemo } from "react";
import { useContext } from "react";

export default function Home() {
  return (
    <AppProvider>
      <WeekTrackerTable />
    </AppProvider>
  );
}
