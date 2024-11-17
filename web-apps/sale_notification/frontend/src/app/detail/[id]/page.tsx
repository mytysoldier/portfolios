export default function Detail({ params }: { params: { id: string } }) {
  return <div>詳細画面 ID: {params.id}</div>;
}
