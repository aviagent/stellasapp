-- ══════════════════════════════════════════════════════════════
-- STELLA'S AI HOST — Supabase Schema
-- Extends the Moxies schema with takeout_orders table
-- Run in Supabase SQL Editor
-- ══════════════════════════════════════════════════════════════

-- Run the original moxies_supabase_schema.sql first, then this file

-- ── TAKEOUT ORDERS ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS takeout_orders (
  id              bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  customer_name   text NOT NULL,
  customer_phone  text DEFAULT '',
  pickup_time     text DEFAULT 'ASAP',
  items           jsonb DEFAULT '[]',         -- array of {name, price}
  total           numeric,
  mode            text DEFAULT 'takeout',     -- 'takeout' | 'dine'
  table_num       text,                       -- null for takeout
  payment_method  text DEFAULT 'pay_at_restaurant',  -- 'pay_at_restaurant' | 'stripe'
  stripe_session_id text DEFAULT '',          -- Stripe Checkout Session ID when paid online
  status          text DEFAULT 'pending',     -- pending | confirmed | ready | picked_up
  created_at      timestamptz DEFAULT now()
);

ALTER TABLE takeout_orders ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public_read_takeout"  ON takeout_orders FOR SELECT USING (true);
CREATE POLICY "anon_write_takeout"   ON takeout_orders FOR ALL USING (true) WITH CHECK (true);
CREATE INDEX IF NOT EXISTS idx_takeout_status ON takeout_orders (status, created_at DESC);
