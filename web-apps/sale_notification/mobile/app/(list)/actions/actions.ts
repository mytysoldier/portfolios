import { SaleItem } from "@/models/saleItem";
import { SaleListReq } from "../models/request";

export async function getSaleList(req?: SaleListReq): Promise<SaleItem[]> {
  try {
    // const result = await fetch("http://localhost:3001/saleList");
    let result;
    if (req) {
      result = await fetch(
        `https://quick-pets-end.loca.lt/saleList?name=${req.name}&start_at=${
          req.startAt?.toDateString() ?? "1970-01-01"
        }&end_at=${req.endAt?.toDateString() ?? "9999-01-01"}`
      );
    } else {
      result = await fetch("https://quick-pets-end.loca.lt/saleList");
    }
    const jsonBody = (await result.json()) as SaleItem[];
    console.log(`api result : ${JSON.stringify(jsonBody)}`);
    return jsonBody;
  } catch (error) {
    console.error(`error occured: ${error}`);
    return [];
  }
}
