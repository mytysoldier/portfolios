import { SaleItem } from "@/models/saleItem";

export async function getSaleDetail(id: number): Promise<SaleItem | null> {
  try {
    // const result = await fetch(`http://localhost:3001/saleDetail?id=${id}`);
    const result = await fetch(
      `https://upset-onions-enjoy.loca.lt/saleDetail?id=${id}`
    );
    const jsonBody = (await result.json()) as SaleItem;
    console.log(`api result : ${JSON.stringify(jsonBody)}`);
    return jsonBody;
  } catch (error) {
    console.error(`error occured: ${error}`);
    return null;
  }
}
