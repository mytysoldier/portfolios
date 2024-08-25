import { getAllHabbit } from "@/lib/prisma/habbit";
import { getAllUser, getUser } from "@/lib/prisma/user";

export default async function Test() {
  const user = await getUser(1);
  const users = await getAllUser();
  return (
    <>
      <div>
        <div>user_id: {user?.id}</div>
        <div>nickname: {user?.nickname}</div>
        <div>created_at: {user?.created_at.toDateString()}</div>
      </div>
      <div>
        <span>全てのユーザー</span>
        {users?.map((user) => (
          <div key={user.id}>
            <div>user_id: {user?.id}</div>
            <div>nickname: {user?.nickname}</div>
            <div>created_at: {user?.created_at.toDateString()}</div>
          </div>
        ))}
      </div>
    </>
  );
}
