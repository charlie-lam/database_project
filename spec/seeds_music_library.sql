TRUNCATE TABLE albums RESTART IDENTITY;
DROP TABLE IF EXISTS "public"."albums";
-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS albums_id_seq;

-- Table Definition
CREATE TABLE "public"."albums" (
    "id" SERIAL,
    "title" text,
    "release_year" int4
);

-- Table Definition

INSERT INTO "public"."albums" ("title", "release_year") VALUES
('Doolittle', 1989),
('Surfer Rosa', 1988),
('Waterloo', 1974);
