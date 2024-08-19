This is a [Next.js](https://nextjs.org/) project bootstrapped with [`create-next-app`](https://github.com/vercel/next.js/tree/canary/packages/create-next-app).

## 当アプリについて

自作習慣トラッカーの Web アプリ

## 使用技術

- React
- Next.js
- Docker
- PostgreSQL
- Prisma
- react-big-calendar

## 起動方法

### DB 起動

```bash
docker-compose up -d
```

※DB 接続コマンド

```bash
docker exec -it postgres psql -U user -d habbit_tracker
```

### Web アプリ起動

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
# or
bun dev
```

Web ブラウザで[http://localhost:3000](http://localhost:3000)にアクセス
