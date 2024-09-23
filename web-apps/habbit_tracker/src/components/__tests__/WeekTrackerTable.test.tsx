import { render, screen, waitFor } from "@testing-library/react";
import WeekTrackerTable from "../WeekTrackerTable";
import React, { act } from "react";
import { HabbitProvider } from "../../lib/provider/HabbitContext";
import fetchMock from "jest-fetch-mock";

// @fullcalendarのインポートでエラーになるため、該当モジュールをモック
jest.mock("@fullcalendar/react", () => {
  const MockCalendar = () => <div role="grid">Mock Calendar</div>;
  MockCalendar.displayName = "MockCalendar";
  return MockCalendar;
});

jest.mock("@fullcalendar/daygrid", () => {
  return {};
});

fetchMock.enableMocks();

describe("WeekCalendarコンポーネントテスト", () => {
  beforeEach(async () => {
    fetchMock.resetMocks();
    fetchMock.mockResponseOnce(
      JSON.stringify({
        data: [
          {
            id: 1,
            user_id: 1,
            title: "Test Habbit",
            created_at: null,
            updated_at: null,
            deleted_at: null,
          },
        ],
      })
    );

    await act(async () => {
      render(
        <HabbitProvider>
          <WeekTrackerTable />
        </HabbitProvider>
      );
    });
  });

  test("WeekCalendarコンポーネントが描画されること", async () => {
    const weekCalendarElement = screen.getByRole("grid");
    await waitFor(() => expect(weekCalendarElement).toBeInTheDocument());
  });

  test("ボタンが表示されること", async () => {
    const buttonElement = screen.getByRole("button");
    await waitFor(() => {
      expect(buttonElement).toBeInTheDocument();
      expect(buttonElement).toHaveTextContent("タスク追加");
    });
  });
});
