import { addDays, startOfWeek } from "date-fns";

export const getWeekDates = () => {
  const today = new Date();
  // 週の始まりを日曜日として日曜日を求める
  const sunday = startOfWeek(today, { weekStartsOn: 0 });

  // 日曜日から土曜日までを配列に格納
  const weekDates = Array.from({ length: 7 }, (_, i) => addDays(sunday, i));

  return weekDates;
};
