"use client";
import FullCalendar from "@fullcalendar/react";
import dayGridPlugin from "@fullcalendar/daygrid";
import "./css/component.css";
import Button from "./Button";
import { useContext } from "react";
import { HabbitContext } from "@/lib/provider/HabbitContext";

const events = [{ title: "Meeting", start: new Date() }];

export default function WeekCalendar() {
  const habbitContext = useContext(HabbitContext);

  if (!habbitContext) {
    throw new Error("HabbitContext must be used within a HabbitProvider");
  }

  const { habbits, addHabbit } = habbitContext;

  return (
    <div>
      <span>aaa</span>
      <FullCalendar
        plugins={[dayGridPlugin]}
        initialView="dayGridWeek"
        weekends={true}
        events={events}
        contentHeight={100}
      />
      <div className="mt-4 flex justify-center">
        <Button onClick={() => {}} title="タスクを追加" />
      </div>
      <div>
        <span>habbitsのカウント:{habbits.length}</span>
      </div>
    </div>
  );
}
