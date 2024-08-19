-- CreateTable
CREATE TABLE "user" (
    "id" SERIAL NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "habbit" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "title" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "habbit_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "habbit_activity" (
    "id" SERIAL NOT NULL,
    "habbit_id" INTEGER NOT NULL,
    "checked" BOOLEAN NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "habbit_activity_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "habbit" ADD CONSTRAINT "habbit_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "habbit_activity" ADD CONSTRAINT "habbit_activity_habbit_id_fkey" FOREIGN KEY ("habbit_id") REFERENCES "habbit"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
