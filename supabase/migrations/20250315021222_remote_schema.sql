create type "public"."payment_status" as enum ('paid', 'pending', 'waived');

create type "public"."trip_member_status" as enum ('waiting', 'picked_up', 'dropped_off', 'cancelled');

create type "public"."trip_status" as enum ('scheduled', 'in_progress', 'completed', 'cancelled');

alter table "public"."expense_split" alter column "is_paid" set default 'pending'::payment_status;

alter table "public"."expense_split" alter column "is_paid" set data type payment_status using "is_paid"::payment_status;

alter table "public"."trip" alter column "status" set default 'scheduled'::trip_status;

alter table "public"."trip" alter column "status" set data type trip_status using "status"::trip_status;

alter table "public"."trip_member" alter column "status" set default 'waiting'::trip_member_status;

alter table "public"."trip_member" alter column "status" set data type trip_member_status using "status"::trip_member_status;


