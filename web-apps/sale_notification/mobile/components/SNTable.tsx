import { StyleSheet, View } from "react-native";
import {
  Table,
  TableWrapper,
  Row,
  Rows,
  Col,
  Cols,
  Cell,
} from "react-native-reanimated-table";

const TableHead = [
  "ID",
  "Sale Name",
  "Item Category",
  "Status",
  "Start At",
  "End At",
];

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

export const SNTable: React.FC<SNTableProps> = ({ data }) => {
  return (
    <View style={styles.container}>
      <Table borderStyle={{ borderWidth: 1 }}>
        <Row data={TableHead} style={styles.head} />
        <Rows
          data={data.map((item) => [
            item.id,
            item.saleName,
            item.itemCategory,
            item.status,
            item.startAt.toDateString(),
            item.endAt.toDateString(),
          ])}
          textStyle={styles.text}
        />
        {data.map((item, index) => (
          <Row
            key={index}
            data={[
              item.id,
              item.saleName,
              item.itemCategory,
              item.status,
              item.startAt.toDateString(),
              item.endAt.toDateString(),
            ]}
            textStyle={styles.text}
          />
        ))}
      </Table>
    </View>
  );
};

const styles = StyleSheet.create({
  container: { flex: 1, padding: 16, paddingTop: 30, backgroundColor: "#fff" },
  head: { height: 40, backgroundColor: "#f1f8ff" },
  text: { margin: 6 },
});
