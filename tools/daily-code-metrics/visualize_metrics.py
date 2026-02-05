#!/usr/bin/env python3
from __future__ import annotations

import argparse
import datetime as dt
from pathlib import Path

import matplotlib.dates as mdates
import matplotlib.pyplot as plt
import pandas as pd


def load_summary(output_dir: Path) -> pd.DataFrame | None:
    paths = sorted(output_dir.glob("*/daily_code_summary.csv"))
    if not paths:
        return None

    frames: list[pd.DataFrame] = []
    for path in paths:
        df = pd.read_csv(path)
        df["date"] = pd.to_datetime(df["date"])
        frames.append(df)

    summary = pd.concat(frames, ignore_index=True)
    summary = summary.sort_values("date")
    summary = summary.drop_duplicates(subset=["date"], keep="last")
    return summary


def aggregate_summary(summary: pd.DataFrame, granularity: str) -> pd.DataFrame:
    if granularity == "daily":
        grouped = summary.groupby(summary["date"].dt.normalize(), as_index=False)["touched"].sum()
        grouped = grouped.rename(columns={"date": "period_start"})
    elif granularity == "weekly":
        period = summary["date"].dt.to_period("W-SUN")
        grouped = summary.groupby(period, as_index=False)["touched"].sum()
        grouped["period_start"] = grouped["date"].dt.start_time
        grouped = grouped.drop(columns=["date"])
    else:
        period = summary["date"].dt.to_period("M")
        grouped = summary.groupby(period, as_index=False)["touched"].sum()
        grouped["period_start"] = grouped["date"].dt.start_time
        grouped = grouped.drop(columns=["date"])

    grouped = grouped.rename(columns={"period_start": "date"})
    return grouped.sort_values("date")


def plot_summary(summary: pd.DataFrame, plots_dir: Path, granularity: str) -> Path:
    title_map = {
        "daily": "Daily total touched lines",
        "weekly": "Weekly total touched lines",
        "monthly": "Monthly total touched lines",
    }
    fig, ax = plt.subplots(figsize=(10, 5))
    ax.plot(summary["date"], summary["touched"], label="touched", color="#2f6f8f")
    ax.set_title(title_map[granularity])
    ax.set_xlabel("date")
    ax.set_ylabel("lines")
    ax.grid(True, alpha=0.3)
    date_range = summary["date"].max() - summary["date"].min()
    if date_range <= pd.Timedelta(days=31):
        locator = mdates.DayLocator(interval=1)
        formatter = mdates.DateFormatter("%Y-%m-%d")
    elif date_range <= pd.Timedelta(days=366):
        locator = mdates.MonthLocator(interval=1)
        formatter = mdates.DateFormatter("%Y-%m")
    else:
        locator = mdates.YearLocator()
        formatter = mdates.DateFormatter("%Y")

    ax.xaxis.set_major_locator(locator)
    ax.xaxis.set_major_formatter(formatter)
    fig.autofmt_xdate()

    out_path = plots_dir / "summary_timeseries.png"
    fig.tight_layout()
    fig.savefig(out_path, dpi=150)
    plt.close(fig)
    return out_path


def default_plots_dir(output_dir: Path) -> Path:
    today = dt.date.today().isoformat()
    return output_dir / "report" / today


def main() -> int:
    parser = argparse.ArgumentParser(description="Visualize daily code metrics CSVs.")
    parser.add_argument(
        "--output-dir",
        default="output",
        help="Directory that contains date folders with CSVs.",
    )
    parser.add_argument(
        "--plots-dir",
        default=None,
        help="Directory to write plot images. Defaults to output/report/YYYY-MM-DD.",
    )
    parser.add_argument(
        "--granularity",
        choices=["daily", "weekly", "monthly"],
        default="daily",
        help="Aggregate data by day, week, or month. Default is daily.",
    )
    parser.add_argument(
        "--show",
        action="store_true",
        help="Show plots interactively instead of only saving PNGs.",
    )
    args = parser.parse_args()

    output_dir = Path(args.output_dir)
    plots_dir = Path(args.plots_dir) if args.plots_dir else default_plots_dir(output_dir)
    plots_dir.mkdir(parents=True, exist_ok=True)

    summary = load_summary(output_dir)
    if summary is None or summary.empty:
        print(f"No summary CSVs found under: {output_dir}")
        return 1

    summary = aggregate_summary(summary, args.granularity)
    summary_path = plot_summary(summary, plots_dir, args.granularity)
    print(f"Wrote: {summary_path}")

    if args.show:
        plt.show()

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
