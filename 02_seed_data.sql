-- Seed data for PayTo / IDD BA Demo (PostgreSQL)
-- Uses fixed UUIDs for repeatable inserts.

-- Payers
INSERT INTO payer (payer_id, full_name, email) VALUES
  ('11111111-1111-1111-1111-111111111111', 'Asha Kumar', 'asha.kumar@example.com'),
  ('22222222-2222-2222-2222-222222222222', 'Rohan Mehta', 'rohan.mehta@example.com')
ON CONFLICT (payer_id) DO NOTHING;

-- Creditors
INSERT INTO creditor (creditor_id, business_name) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'PayToCreditor Utilities Pty Ltd'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'PayToCreditor Subscriptions Pty Ltd')
ON CONFLICT (creditor_id) DO NOTHING;

-- Mandates (PayTo Agreements)
-- 1) ACTIVE (good)
-- 2) PAUSED (should reject debits)
-- 3) PENDING_AUTH (should reject debits)
INSERT INTO mandate (
  mandate_id, payer_id, creditor_id, max_amount, frequency, start_date, end_date, status
) VALUES
  ('0a0a0a0a-0a0a-0a0a-0a0a-0a0a0a0a0a0a', '11111111-1111-1111-1111-111111111111', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 250.00, 'MONTHLY', DATE '2025-01-01', NULL, 'ACTIVE'),
  ('0b0b0b0b-0b0b-0b0b-0b0b-0b0b0b0b0b0b', '11111111-1111-1111-1111-111111111111', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 50.00,  'WEEKLY',  DATE '2025-01-01', NULL, 'PAUSED'),
  ('0c0c0c0c-0c0c-0c0c-0c0c-0c0c0c0c0c0c', '22222222-2222-2222-2222-222222222222', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 120.00, 'ONE_OFF', DATE '2025-01-01', DATE '2025-12-31', 'PENDING_AUTH')
ON CONFLICT (mandate_id) DO NOTHING;

-- Debit requests
-- A) Valid debit under ACTIVE mandate
-- B) Invalid: amount exceeds max_amount
-- C) Invalid: mandate PAUSED
-- D) Invalid: mandate PENDING_AUTH
INSERT INTO debit_request (debit_id, mandate_id, amount, requested_at, status, rejection_reason) VALUES
  ('d1d1d1d1-d1d1-d1d1-d1d1-d1d1d1d1d1d1', '0a0a0a0a-0a0a-0a0a-0a0a-0a0a0a0a0a0a', 49.99,  now(), 'VALIDATED', NULL),
  ('d2d2d2d2-d2d2-d2d2-d2d2-d2d2d2d2d2d2', '0a0a0a0a-0a0a-0a0a-0a0a-0a0a0a0a0a0a', 999.99, now(), 'REJECTED', 'AMOUNT_EXCEEDS_MANDATE_MAX'),
  ('d3d3d3d3-d3d3-d3d3-d3d3-d3d3d3d3d3d3', '0b0b0b0b-0b0b-0b0b-0b0b-0b0b0b0b0b0b', 25.00,  now(), 'REJECTED', 'MANDATE_NOT_ACTIVE'),
  ('d4d4d4d4-d4d4-d4d4-d4d4-d4d4d4d4d4d4', '0c0c0c0c-0c0c-0c0c-0c0c-0c0c0c0c0c0c', 10.00,  now(), 'REJECTED', 'MANDATE_NOT_AUTHORIZED')
ON CONFLICT (debit_id) DO NOTHING;

-- Outcome events (notifications)
INSERT INTO debit_event (event_id, debit_id, event_type, event_time, details) VALUES
  ('e1e1e1e1-e1e1-e1e1-e1e1-e1e1e1e1e1e1', 'd1d1d1d1-d1d1-d1d1-d1d1-d1d1d1d1d1d1', 'OUTCOME_SUCCESS', now(), '{"message":"Debit validated and settled (simulated)","settlementRef":"SIM-SETTLE-001"}'),
  ('e2e2e2e2-e2e2-e2e2-e2e2-e2e2e2e2e2e2', 'd2d2d2d2-d2d2-d2d2-d2d2-d2d2d2d2d2d2', 'OUTCOME_FAILURE', now(), '{"message":"Rejected: amount exceeds mandate max"}'),
  ('e3e3e3e3-e3e3-e3e3-e3e3-e3e3e3e3e3e3', 'd3d3d3d3-d3d3-d3d3-d3d3-d3d3d3d3d3d3', 'OUTCOME_FAILURE', now(), '{"message":"Rejected: mandate not active"}'),
  ('e4e4e4e4-e4e4-e4e4-e4e4-e4e4e4e4e4e4', 'd4d4d4d4-d4d4-d4d4-d4d4-d4d4d4d4d4d4', 'OUTCOME_FAILURE', now(), '{"message":"Rejected: mandate not authorized"}')
ON CONFLICT (event_id) DO NOTHING;
