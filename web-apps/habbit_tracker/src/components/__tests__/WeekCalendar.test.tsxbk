import { render, screen } from "@testing-library/react";
import WeekCalendar from "../WeekCalendar";

// @fullcalendarのインポートでエラーになるため、該当モジュールをモック
jest.mock("@fullcalendar/react", () => {
  const MockCalendar = () => <div role="grid">Mock Calendar</div>;
  MockCalendar.displayName = "MockCalendar";
  return MockCalendar;
});

jest.mock("@fullcalendar/daygrid", () => {
  return {};
});

describe("WeekCalendarコンポーネントテスト", () => {
  beforeEach(() => {
    render(<WeekCalendar />);
  });

  test("WeekCalendarコンポーネントが描画されること", () => {
    const weekCalendarElement = screen.getByRole("grid");
    expect(weekCalendarElement).toBeInTheDocument();
  });

  test("ボタンが表示されること", () => {
    const buttonElement = screen.getByRole("button");
    expect(buttonElement).toBeInTheDocument();
    expect(buttonElement).toHaveTextContent("タスクを追加");
  });
});
