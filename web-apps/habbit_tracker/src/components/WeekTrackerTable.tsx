"use client";
import FullCalendar from "@fullcalendar/react";
import dayGridPlugin from "@fullcalendar/daygrid";
import "./css/component.css";
import Button from "./Button";
import { useContext, useState } from "react";
import { HabbitContext } from "../lib/provider/HabbitContext";
import { EventContentArg } from "@fullcalendar/core/index.js";
import { totalmem } from "os";
import { Habbit } from "@/models/ui/habbit";
import { format } from "date-fns";
import InputModal from "./AddHabbitModal";

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

// FullCalendarのEventオブジェクトに変換する
const mapHabbitsToEvents = (habbits: Habbit[]) => {
  return habbits.map((habbit) => ({
    title: habbit.title,
    start: habbit.createdAt,
  }));
};

export default function WeekTrackerTable() {
  const habbitContext = useContext(HabbitContext);
  const [isAddTitleModalOpen, setIsAddTitleModalOpen] = useState(false);

  if (!habbitContext) {
    throw new Error("HabbitContext must be used within a HabbitProvider");
  }

  const { habbits, addHabbit } = habbitContext;

  // console.log(`habbits data: ${JSON.stringify(habbits)}`);

  const handleAddTitleClick = () =>
    setIsAddTitleModalOpen(!isAddTitleModalOpen);

  return (
    <div>
      <div>
        <div>
          <div className="mb-4">
            <Button title="タスク追加" onClick={handleAddTitleClick} />
          </div>

          {isAddTitleModalOpen && (
            <InputModal
              modalIsOpen={isAddTitleModalOpen}
              onCancelClick={handleAddTitleClick}
            />
          )}

          <FullCalendar
            plugins={[dayGridPlugin]}
            initialView="dayGridWeek"
            weekends={true}
            events={mapHabbitsToEvents(habbits)}
            // contentHeight={100}
            dayHeaderContent={(args) => {
              const day = args.date.getDate();
              // const dayName = args.view.calendar.options.weekdays[args.date.getDay()];
              const dayName = format(args.date, "EEEEE");
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
                <div className="w-full px-4 flex justify-between bg-white">
                  <div className="truncate">{arg.event.title}</div>
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
