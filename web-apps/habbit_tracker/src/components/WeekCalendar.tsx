"use client";
import FullCalendar from "@fullcalendar/react";
import dayGridPlugin from "@fullcalendar/daygrid";
import "./css/component.css";
import Button from "./Button";

const events = [{ title: "Meeting", start: new Date() }];

export default function WeekCalendar() {
  return (
    <div>
      <span></span>
      <FullCalendar
        plugins={[dayGridPlugin]}
        initialView="dayGridWeek"
        weekends={false}
        events={events}
        contentHeight={100}
      />
      <div className="mt-4 flex justify-center">
        <Button onClick={() => {}} title="タスクを追加" />
      </div>
    </div>
  );
}
