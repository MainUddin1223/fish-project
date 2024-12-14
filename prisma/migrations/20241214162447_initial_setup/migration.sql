/*
  Warnings:

  - Added the required column `updatedAt` to the `user` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "Fish_type" AS ENUM ('telapia', 'rui', 'catla', 'mrigel', 'pangas', 'mirka', 'carp', 'kalibaus');

-- AlterTable
ALTER TABLE "user" ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL;

-- CreateTable
CREATE TABLE "syndicate" (
    "id" SERIAL NOT NULL,
    "syndicate_name" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    "is_paid" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "syndicate_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "leader" (
    "id" SERIAL NOT NULL,
    "syndicate_id" INTEGER NOT NULL,
    "user_id" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "leader_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "members" (
    "id" SERIAL NOT NULL,
    "syndicate_id" INTEGER NOT NULL,
    "user_id" INTEGER NOT NULL,
    "stake" DOUBLE PRECISION NOT NULL,
    "investment" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "members_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "care_taker" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "salary" INTEGER NOT NULL,
    "syndicate_id" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "care_taker_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "season" (
    "id" SERIAL NOT NULL,
    "duration" INTEGER NOT NULL,
    "year" TEXT NOT NULL,
    "targeted_cost" INTEGER NOT NULL,
    "targeted_sales" INTEGER NOT NULL,
    "targeted_revenue" INTEGER NOT NULL,
    "syndicate_id" INTEGER NOT NULL,
    "total_investment" INTEGER NOT NULL,
    "total_sales" INTEGER NOT NULL,
    "leader_id" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "season_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sales" (
    "id" SERIAL NOT NULL,
    "total_wight" INTEGER NOT NULL,
    "rate" INTEGER NOT NULL,
    "fish_type" "Fish_type" NOT NULL,
    "total_amount" INTEGER NOT NULL,
    "season_id" INTEGER NOT NULL,
    "syndicate_id" INTEGER NOT NULL,
    "leader_id" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "sales_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cost" (
    "id" SERIAL NOT NULL,
    "date" TEXT NOT NULL,
    "total_cost" INTEGER NOT NULL,
    "reason" TEXT NOT NULL,
    "prove" TEXT NOT NULL,
    "season_id" INTEGER NOT NULL,
    "syndicate_id" INTEGER NOT NULL,
    "leader_id" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

-- CreateTable
CREATE TABLE "profit_share" (
    "id" SERIAL NOT NULL,
    "member_id" INTEGER NOT NULL,
    "total_amount" INTEGER NOT NULL,
    "paid_amount" INTEGER NOT NULL,
    "syndicate_id" INTEGER NOT NULL,
    "season_id" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

-- CreateTable
CREATE TABLE "payment_record" (
    "id" SERIAL NOT NULL,
    "member_id" INTEGER NOT NULL,
    "paid_amount" INTEGER NOT NULL,
    "syndicate_id" INTEGER NOT NULL,
    "season_id" INTEGER NOT NULL,
    "payment_date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "cost_id_key" ON "cost"("id");

-- CreateIndex
CREATE UNIQUE INDEX "profit_share_id_key" ON "profit_share"("id");

-- CreateIndex
CREATE UNIQUE INDEX "payment_record_id_key" ON "payment_record"("id");

-- AddForeignKey
ALTER TABLE "leader" ADD CONSTRAINT "leader_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "leader" ADD CONSTRAINT "leader_syndicate_id_fkey" FOREIGN KEY ("syndicate_id") REFERENCES "syndicate"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "members" ADD CONSTRAINT "members_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "members" ADD CONSTRAINT "members_syndicate_id_fkey" FOREIGN KEY ("syndicate_id") REFERENCES "syndicate"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "care_taker" ADD CONSTRAINT "care_taker_syndicate_id_fkey" FOREIGN KEY ("syndicate_id") REFERENCES "syndicate"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "season" ADD CONSTRAINT "season_leader_id_fkey" FOREIGN KEY ("leader_id") REFERENCES "leader"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "season" ADD CONSTRAINT "season_syndicate_id_fkey" FOREIGN KEY ("syndicate_id") REFERENCES "syndicate"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sales" ADD CONSTRAINT "sales_leader_id_fkey" FOREIGN KEY ("leader_id") REFERENCES "leader"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sales" ADD CONSTRAINT "sales_syndicate_id_fkey" FOREIGN KEY ("syndicate_id") REFERENCES "syndicate"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sales" ADD CONSTRAINT "sales_season_id_fkey" FOREIGN KEY ("season_id") REFERENCES "season"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cost" ADD CONSTRAINT "cost_leader_id_fkey" FOREIGN KEY ("leader_id") REFERENCES "leader"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cost" ADD CONSTRAINT "cost_syndicate_id_fkey" FOREIGN KEY ("syndicate_id") REFERENCES "syndicate"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cost" ADD CONSTRAINT "cost_season_id_fkey" FOREIGN KEY ("season_id") REFERENCES "season"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "profit_share" ADD CONSTRAINT "profit_share_member_id_fkey" FOREIGN KEY ("member_id") REFERENCES "members"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "profit_share" ADD CONSTRAINT "profit_share_syndicate_id_fkey" FOREIGN KEY ("syndicate_id") REFERENCES "syndicate"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "profit_share" ADD CONSTRAINT "profit_share_season_id_fkey" FOREIGN KEY ("season_id") REFERENCES "season"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_record" ADD CONSTRAINT "payment_record_member_id_fkey" FOREIGN KEY ("member_id") REFERENCES "members"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_record" ADD CONSTRAINT "payment_record_syndicate_id_fkey" FOREIGN KEY ("syndicate_id") REFERENCES "syndicate"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_record" ADD CONSTRAINT "payment_record_season_id_fkey" FOREIGN KEY ("season_id") REFERENCES "season"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
