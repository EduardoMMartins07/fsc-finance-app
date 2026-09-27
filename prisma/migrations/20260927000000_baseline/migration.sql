CREATE TABLE "users" (
    "id" UUID PRIMARY KEY,
    "first_name" VARCHAR(50) NOT NULL,
    "last_name" VARCHAR(50) NOT NULL,
    "email" VARCHAR(100) UNIQUE NOT NULL,
    "password" VARCHAR(100) NOT NULL
);

CREATE TYPE "transaction_type" AS ENUM ('EARNING', 'EXPENSE', 'INVESTIMENT');

CREATE TABLE "transactions" (
    "id" UUID PRIMARY KEY,
    "user_id" UUID NOT NULL REFERENCES "users"("id") ON DELETE CASCADE,
    "name" VARCHAR(100) NOT NULL,
    "date" DATE NOT NULL,
    "amount" NUMERIC(10, 2) NOT NULL,
    "type" "transaction_type" NOT NULL
);

CREATE OR REPLACE FUNCTION get_user_balance(uid UUID)
RETURNS TABLE (
    earnings NUMERIC(10, 2),
    expenses NUMERIC(10, 2),
    investments NUMERIC(10, 2),
    balance NUMERIC(10, 2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        SUM(CASE WHEN type = 'EARNING' THEN amount ELSE 0 END),
        SUM(CASE WHEN type = 'EXPENSE' THEN amount ELSE 0 END),
        SUM(CASE WHEN type = 'INVESTIMENT' THEN amount ELSE 0 END),
        SUM(CASE WHEN type = 'EARNING' THEN amount ELSE 0 END) -
        SUM(CASE WHEN type = 'EXPENSE' THEN amount ELSE 0 END) +
        SUM(CASE WHEN type = 'INVESTIMENT' THEN amount ELSE 0 END)
    FROM transactions
    WHERE user_id = get_user_balance.uid;
END; $$ LANGUAGE plpgsql;
