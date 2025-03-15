

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pgsodium";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";





SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."expense" (
    "expense_id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "trip_id" "uuid",
    "payer_id" "uuid",
    "amount" integer
);


ALTER TABLE "public"."expense" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."expense_split" (
    "expense_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "amount" integer,
    "is_paid" character varying,
    "paid_at" timestamp with time zone
);


ALTER TABLE "public"."expense_split" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."group" (
    "group_id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "group_name" character varying,
    "created_by" "uuid"
);


ALTER TABLE "public"."group" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."group_member" (
    "group_id" "uuid" NOT NULL,
    "joined_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "user_id" "uuid"
);


ALTER TABLE "public"."group_member" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."trip" (
    "trip_id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "group_id" "uuid",
    "driver_id" "uuid",
    "vehicle_id" "uuid",
    "name" character varying,
    "start_time" timestamp with time zone,
    "end_time" timestamp with time zone,
    "start_location" character varying,
    "end_location" character varying,
    "total_distance" integer,
    "status" character varying
);


ALTER TABLE "public"."trip" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."trip_member" (
    "trip_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "pickup_location" character varying,
    "status" character varying,
    "pickup_time" timestamp with time zone
);


ALTER TABLE "public"."trip_member" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."user" (
    "user_id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "user_name" character varying DEFAULT ''::character varying
);


ALTER TABLE "public"."user" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."vehicle" (
    "vehicle_id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "make" character varying,
    "model" character varying,
    "license_plate" character varying,
    "capacity" smallint,
    "year" integer,
    "user_id" "uuid" DEFAULT "gen_random_uuid"()
);


ALTER TABLE "public"."vehicle" OWNER TO "postgres";


ALTER TABLE ONLY "public"."expense"
    ADD CONSTRAINT "expense_pkey" PRIMARY KEY ("expense_id");



ALTER TABLE ONLY "public"."expense_split"
    ADD CONSTRAINT "expense_split_pkey" PRIMARY KEY ("expense_id", "user_id");



ALTER TABLE ONLY "public"."group_member"
    ADD CONSTRAINT "group_member_pkey" PRIMARY KEY ("group_id");



ALTER TABLE ONLY "public"."group"
    ADD CONSTRAINT "group_pkey" PRIMARY KEY ("group_id");



ALTER TABLE ONLY "public"."trip_member"
    ADD CONSTRAINT "trip_member_pkey" PRIMARY KEY ("trip_id", "user_id");



ALTER TABLE ONLY "public"."trip"
    ADD CONSTRAINT "trip_pkey" PRIMARY KEY ("trip_id");



ALTER TABLE ONLY "public"."user"
    ADD CONSTRAINT "user_pkey" PRIMARY KEY ("user_id");



ALTER TABLE ONLY "public"."vehicle"
    ADD CONSTRAINT "vehicle_pkey" PRIMARY KEY ("vehicle_id");



ALTER TABLE ONLY "public"."expense"
    ADD CONSTRAINT "expense_payer_id_fkey" FOREIGN KEY ("payer_id") REFERENCES "public"."user"("user_id");



ALTER TABLE ONLY "public"."expense_split"
    ADD CONSTRAINT "expense_split_expense_id_fkey" FOREIGN KEY ("expense_id") REFERENCES "public"."expense"("expense_id");



ALTER TABLE ONLY "public"."expense_split"
    ADD CONSTRAINT "expense_split_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."user"("user_id");



ALTER TABLE ONLY "public"."expense"
    ADD CONSTRAINT "expense_trip_id_fkey" FOREIGN KEY ("trip_id") REFERENCES "public"."trip"("trip_id");



ALTER TABLE ONLY "public"."group"
    ADD CONSTRAINT "group_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."user"("user_id");



ALTER TABLE ONLY "public"."group_member"
    ADD CONSTRAINT "group_member_group_id_fkey" FOREIGN KEY ("group_id") REFERENCES "public"."group"("group_id");



ALTER TABLE ONLY "public"."group_member"
    ADD CONSTRAINT "group_member_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."user"("user_id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."trip"
    ADD CONSTRAINT "trip_driver_id_fkey" FOREIGN KEY ("driver_id") REFERENCES "public"."user"("user_id");



ALTER TABLE ONLY "public"."trip"
    ADD CONSTRAINT "trip_group_id_fkey" FOREIGN KEY ("group_id") REFERENCES "public"."group"("group_id");



ALTER TABLE ONLY "public"."trip_member"
    ADD CONSTRAINT "trip_member_trip_id_fkey" FOREIGN KEY ("trip_id") REFERENCES "public"."trip"("trip_id");



ALTER TABLE ONLY "public"."trip_member"
    ADD CONSTRAINT "trip_member_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."user"("user_id");



ALTER TABLE ONLY "public"."trip"
    ADD CONSTRAINT "trip_vehicle_id_fkey" FOREIGN KEY ("vehicle_id") REFERENCES "public"."vehicle"("vehicle_id");



ALTER TABLE ONLY "public"."vehicle"
    ADD CONSTRAINT "vehicle_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."user"("user_id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE "public"."expense" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."expense_split" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."group" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."group_member" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."trip" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."trip_member" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."user" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."vehicle" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";



































































































































































































GRANT ALL ON TABLE "public"."expense" TO "anon";
GRANT ALL ON TABLE "public"."expense" TO "authenticated";
GRANT ALL ON TABLE "public"."expense" TO "service_role";



GRANT ALL ON TABLE "public"."expense_split" TO "anon";
GRANT ALL ON TABLE "public"."expense_split" TO "authenticated";
GRANT ALL ON TABLE "public"."expense_split" TO "service_role";



GRANT ALL ON TABLE "public"."group" TO "anon";
GRANT ALL ON TABLE "public"."group" TO "authenticated";
GRANT ALL ON TABLE "public"."group" TO "service_role";



GRANT ALL ON TABLE "public"."group_member" TO "anon";
GRANT ALL ON TABLE "public"."group_member" TO "authenticated";
GRANT ALL ON TABLE "public"."group_member" TO "service_role";



GRANT ALL ON TABLE "public"."trip" TO "anon";
GRANT ALL ON TABLE "public"."trip" TO "authenticated";
GRANT ALL ON TABLE "public"."trip" TO "service_role";



GRANT ALL ON TABLE "public"."trip_member" TO "anon";
GRANT ALL ON TABLE "public"."trip_member" TO "authenticated";
GRANT ALL ON TABLE "public"."trip_member" TO "service_role";



GRANT ALL ON TABLE "public"."user" TO "anon";
GRANT ALL ON TABLE "public"."user" TO "authenticated";
GRANT ALL ON TABLE "public"."user" TO "service_role";



GRANT ALL ON TABLE "public"."vehicle" TO "anon";
GRANT ALL ON TABLE "public"."vehicle" TO "authenticated";
GRANT ALL ON TABLE "public"."vehicle" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";






























RESET ALL;
