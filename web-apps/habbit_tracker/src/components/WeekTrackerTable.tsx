"use client";
import FullCalendar from "@fullcalendar/react";
import dayGridPlugin from "@fullcalendar/daygrid";
import "./css/component.css";
import Button from "./Button";
import { useContext } from "react";
import { HabbitContext } from "../lib/provider/HabbitContext";
import { EventContentArg } from "@fullcalendar/core/index.js";
import { totalmem } from "os";

let tomorrow = new Date();
tomorrow.setDate(tomorrow.getDate() + 1);

let yesterday = new Date();
yesterday.setDate(yesterday.getDate() - 1);

const events = [
  { title: "筋トレ", start: new Date() },
  { title: "散歩", start: new Date() },
  { title: "買い物", start: tomorrow },
  { title: "ジム", start: yesterday },
];

export default function WeekTrackerTable() {
  const habbitContext = useContext(HabbitContext);

  if (!habbitContext) {
    throw new Error("HabbitContext must be used within a HabbitProvider");
  }

  const { habbits, addHabbit } = habbitContext;

  return (
    <div>
      <div>
        <div>
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
            eventContent={(arg: EventContentArg) => {
              // return <div className="fc-custom-cell">{arg.event.title} ✔︎</div>;
              return (
                <div className="w-full px-4 flex justify-between">
                  <div>{arg.event.title}</div>
                  <div>✔︎</div>
                </div>
              );
            }}
            eventClick={(info) => {
              console.log(`evnet click: ${info.event.title}`);
            }}
          />
        </div>
      </div>
      <div className="mt-4 flex justify-center">
        <Button onClick={() => {}} title="タスクを追加" />
      </div>
      <div>
        <span>habbitsのカウント:{habbits.length}</span>
      </div>
    </div>
  );
}
