"use client";
import FullCalendar from "@fullcalendar/react";
import dayGridPlugin from "@fullcalendar/daygrid";

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
      />
    </div>
  );
}
