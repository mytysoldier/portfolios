"use client";
import FullCalendar from "@fullcalendar/react";
import dayGridPlugin from "@fullcalendar/daygrid";
import "./css/component.css";
import Button from "./Button";
import { useContext } from "react";
import { HabbitContext } from "../lib/provider/HabbitContext";

const events = [
  { title: "○", start: new Date() },
  { title: "○", start: new Date() },
];

export default function WeekTrackerTable() {
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
        // contentHeight={100}
        dayHeaderContent={(args) => {
          const day = args.date.getDate();
          // const dayName = args.view.calendar.options.weekdays[args.date.getDay()];
          const dayName = "M";
          return (
            <div className="fc-custom-header-cell">
              <div>{day}</div>
              <div>{dayName.charAt(0)}</div>
            </div>
          );
        }}
        // dayCellContent={(args) => {
        //   return <div className="fc-custom-cell">✔︎</div>;
        // }}
        eventContent={(arg) => {
          return <div className="fc-custom-cell">✔︎</div>;
        }}
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
