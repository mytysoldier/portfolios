import { useNavigation, NavigationProp } from "@react-navigation/native";
import { Link, useRouter } from "expo-router";
import { StyleSheet, TouchableOpacity, View } from "react-native";
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
  const router = useRouter();
  const navigation = useNavigation();

  console.log(`SNTable data: ${JSON.stringify(data)}`);

  return (
    <View style={styles.container}>
      <Table borderStyle={{ borderWidth: 1 }}>
        <Row data={TableHead} style={styles.head} />
        {/* <Rows
          data={data.map((item) => [
            item.id,
            item.saleName,
            item.itemCategory,
            item.status,
            item.startAt,
            item.endAt,
          ])}
          textStyle={styles.text}
        /> */}
        {data.map((item, index) => (
          <Link
            key={index}
            href={{
              pathname: "/(detail)",
              params: { id: item.id },
            }}
          >
            <Row
              key={index}
              data={[
                item.id,
                item.saleName,
                item.itemCategory,
                item.status,
                item.startAt,
                item.endAt,
              ]}
              textStyle={styles.text}
            />
          </Link>
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
