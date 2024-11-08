import {
  createColumnHelper,
  flexRender,
  getCoreRowModel,
  useReactTable,
} from "@tanstack/react-table";
import { format } from "date-fns";

export type Sales = {
  id: number;
  saleName: string;
  itemCategory: string;
  status: string;
  startAt: Date;
  endAt: Date;
};

type SNTableProps = {
  data: Sales[];
};

const columnHelper = createColumnHelper<Sales>();

const columns = [
  columnHelper.accessor("id", { header: "ID" }),
  columnHelper.accessor("saleName", { header: "Sale Name" }),
  columnHelper.accessor("itemCategory", { header: "Item Category" }),
  columnHelper.accessor("status", { header: "Status" }),
  columnHelper.accessor("startAt", {
    header: "Start Date",
    cell: (info) => format(info.getValue(), "yyyy/MM/dd"),
  }),
  columnHelper.accessor("endAt", {
    header: "End Date",
    cell: (info) => format(info.getValue(), "yyyy/MM/dd"),
  }),
];

export const SNTable: React.FC<SNTableProps> = ({ data }) => {
  const table = useReactTable({
    data,
    columns,
    getCoreRowModel: getCoreRowModel(),
  });

  return (
    <div className="p-16">
      <table className="min-w-full border border-gray-200">
        <thead>
          {table.getHeaderGroups().map((headerGroup) => (
            <tr key={headerGroup.id}>
              {headerGroup.headers.map((header) => (
                <th
                  key={header.id}
                  className="px-4 py-2 text-left border-b border-gray-200 border-r"
                >
                  {flexRender(
                    header.column.columnDef.header,
                    header.getContext(),
                  )}
                </th>
              ))}
            </tr>
          ))}
        </thead>
        <tbody>
          {table.getRowModel().rows.map((row) => (
            <tr key={row.id} className="px-4 py-2 border-b border-gray-200">
              {row.getVisibleCells().map((cell) => (
                <td
                  key={cell.id}
                  className="px-4 py-2 border-b border-gray-200 border-r"
                >
                  {flexRender(cell.column.columnDef.cell, cell.getContext())}
                </td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};
