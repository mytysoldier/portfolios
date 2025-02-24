import { SaleItem } from "@/models/saleItem";

export async function getSaleList(): Promise<SaleItem[]> {
  try {
    const result = await fetch("http://localhost:3001/saleList");
    const jsonBody = (await result.json()) as SaleItem[];
    console.log(`api result : ${JSON.stringify(jsonBody)}`);
    return jsonBody;
  } catch (error) {
    console.error(`error occured: ${error}`);
    return [];
  }
}
