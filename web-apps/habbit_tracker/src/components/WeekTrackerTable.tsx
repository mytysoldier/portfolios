"use client";
import FullCalendar from "@fullcalendar/react";
import dayGridPlugin from "@fullcalendar/daygrid";
import "./css/component.css";
import Button from "./Button";
import { ChangeEvent, ChangeEventHandler, useContext, useState } from "react";
import { HabbitContext } from "../lib/provider/HabbitContext";
import { EventClickArg, EventContentArg } from "@fullcalendar/core/index.js";
import { totalmem } from "os";
import { Habbit } from "@/models/ui/habbit";
import { format, isSameDay } from "date-fns";
import InputTitleModal, { CustomModalActionType } from "./InputTitleModal";
import { getWeekDates, toJST, toUTC } from "@/lib/util/date-util";
import { title } from "process";
import { HabbitActivityContext } from "@/lib/provider/HabbitActivityContext";

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

const weekDates = getWeekDates();

// FullCalendarのEventオブジェクトに変換する
// const mapHabbitsToEvents = (habbits: Habbit[]) => {
//   return habbits.map((habbit) => ({
//     title: habbit.title,
//     start: habbit.createdAt,
//   }));
// };

const mapHabbitsToEvents = (habbits: Habbit[]) => {
  console.log(`weekDates: ${weekDates}`);
  return habbits.flatMap((habbit) =>
    // weekDatesごとにマッピングする
    weekDates
      .filter((date) => date <= new Date())
      .map((date) => {
        // habbitActivitiesから該当の日付のactivityを探す
        const activity = habbit.habbitActivities?.find(
          (activity) => isSameDay(new Date(activity.createdAt), date) // 同じ日付のアクティビティを検索
        );

        console.log(
          `habbit: ${habbit.title}, activity createdAt: ${activity?.createdAt}, date: ${date}, checked: ${activity?.checked}`
        );

        return {
          title: habbit.title,
          start: date,
          activity_id: activity ? activity.id : undefined,
          activity_habbit_id: habbit.id,
          checked: activity ? activity.checked : undefined, // 該当するactivityがあればchecked、なければfalse
        };
      })
  );
};

export default function WeekTrackerTable() {
  const habbitContext = useContext(HabbitContext);
  const habbitActivityContext = useContext(HabbitActivityContext);
  const [isAddTitleModalOpen, setIsAddTitleModalOpen] = useState(false);
  const [isUpdateTitleModalOpen, setIsUpdateTitleModalOpen] = useState(false);
  const [updateHabbit, setUpdateHabbit] = useState<Habbit | undefined>(
    undefined
  );

  if (!habbitContext) {
    throw new Error("HabbitContext must be used within a HabbitProvider");
  }

  if (!habbitActivityContext) {
    throw new Error(
      "HabbitActivityContext must be used within a HabbitActivityProvider"
    );
  }

  const { habbits, addHabbit } = habbitContext;
  const { addHabbitActivity, updateHabbitActivity } = habbitActivityContext;

  // console.log(`habbits data: ${JSON.stringify(habbits)}`);

  const handleAddTitleClick = () =>
    setIsAddTitleModalOpen(!isAddTitleModalOpen);

  const handleUpdateTitleClick = () =>
    setIsUpdateTitleModalOpen(!isUpdateTitleModalOpen);

  const handleEventClick = (info: EventClickArg) => {
    const selectedHabbit = habbits.find(
      (item) => item.title === info.event.title
    );
    if (selectedHabbit) {
      setUpdateHabbit(selectedHabbit);
      handleUpdateTitleClick();
    }
  };

  // TODO あとで削除
  // console.log(
  //   `mapHabbitsToEvents: ${JSON.stringify(mapHabbitsToEvents(habbits))}`
  // );

  return (
    <div>
      <div>
        <div>
          <div className="mb-4">
            <Button title="タスク追加" onClick={handleAddTitleClick} />
          </div>

          {/* タスク追加用のモーダル */}
          {isAddTitleModalOpen && (
            <InputTitleModal
              actionType={CustomModalActionType.CREATE}
              modalIsOpen={isAddTitleModalOpen}
              onCancelClick={handleAddTitleClick}
            />
          )}
          {/* タスク編集用のモーダル */}
          {isUpdateTitleModalOpen && (
            <InputTitleModal
              actionType={CustomModalActionType.UPDATE}
              modalIsOpen={isUpdateTitleModalOpen}
              onCancelClick={handleUpdateTitleClick}
              inputHabbit={updateHabbit}
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
              const isChecked = arg.event.extendedProps.checked;
              const habbitActivityId = arg.event.extendedProps.activity_id;
              const habbitId = arg.event.extendedProps.activity_habbit_id;

              // チェックボックスクリック時はeventClickイベントを発火しないようにする
              const handleChange = (e: ChangeEvent<HTMLInputElement>) => {
                e.stopPropagation();
                if (isChecked === undefined) {
                  console.log("activity未登録");
                  console.log(`activity登録date: ${arg.event.start}`);
                  addHabbitActivity({
                    id: 0, // 新規登録時はDBのauto incrementに任せるため、ここでは適当なID値を渡す
                    habbitId: habbitId,
                    checked: true,
                    createdAt: arg.event.start!,
                  });
                } else {
                  // TODO isCheckedの更新をトリガーに画面を再描画する
                  console.log(
                    `updateHabbitActivity: ${JSON.stringify({
                      id: habbitActivityId,
                      habbitId: habbitId,
                      checked: isChecked,
                      createdAt: toUTC(arg.event.start!),
                    })}`
                  );
                  updateHabbitActivity({
                    id: habbitActivityId,
                    habbitId: habbitId,
                    checked: !isChecked,
                    createdAt: toUTC(arg.event.start!),
                  });
                }
              };

              return (
                <div className="w-full px-4 flex justify-between bg-white">
                  <div className="truncate">{arg.event.title}</div>
                  {/* <div>{isChecked ? "✔︎" : ""}</div> */}
                  <input
                    type="checkbox"
                    className="form-checkbox h-5 w-5 text-indigo-600 transition duration-150 ease-in-out"
                    checked={isChecked}
                    onChange={handleChange}
                  />
                </div>
              );
            }}
            eventClick={handleEventClick}
          />
        </div>
      </div>
      <div>
        <span>habbitsのカウント:{habbits.length}</span>
      </div>
    </div>
  );
}
