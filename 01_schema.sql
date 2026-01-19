-- PayTo / IDD BA Demo (PostgreSQL)
-- Schema: payer, creditor, mandate, debit_request, debit_event

-- Optional clean re-run (uncomment if needed)
-- DROP TABLE IF EXISTS debit_event;
-- DROP TABLE IF EXISTS debit_request;
-- DROP TABLE IF EXISTS mandate;
-- DROP TABLE IF EXISTS creditor;
-- DROP TABLE IF EXISTS payer;

CREATE TABLE IF NOT EXISTS payer (
  payer_id   UUID PRIMARY KEY,
  full_name  TEXT NOT NULL,
  email      TEXT
);

CREATE TABLE IF NOT EXISTS creditor (
  creditor_id    UUID PRIMARY KEY,
  business_name  TEXT NOT NULL
);

-- Mandate (PayTo agreement)
CREATE TABLE IF NOT EXISTS mandate (
  mandate_id  UUID PRIMARY KEY,
  payer_id    UUID NOT NULL REFERENCES payer(payer_id),
  creditor_id UUID NOT NULL REFERENCES creditor(creditor_id),
  max_amount  NUMERIC(12,2) NOT NULL,
  frequency   TEXT NOT NULL CHECK (frequency IN ('ONE_OFF','WEEKLY','MONTHLY')),
  start_date  DATE NOT NULL,
  end_date    DATE,
  status      TEXT NOT NULL CHECK (status IN ('PENDING_AUTH','ACTIVE','PAUSED','CANCELLED')),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Debit requests under a mandate
CREATE TABLE IF NOT EXISTS debit_request (
  debit_id         UUID PRIMARY KEY,
  mandate_id       UUID NOT NULL REFERENCES mandate(mandate_id),
  amount           NUMERIC(12,2) NOT NULL,
  requested_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  status           TEXT NOT NULL CHECK (status IN ('RECEIVED','VALIDATED','REJECTED','SETTLED')),
  rejection_reason TEXT
);

-- Outcome events (notification-friendly)
CREATE TABLE IF NOT EXISTS debit_event (
  event_id    UUID PRIMARY KEY,
  debit_id    UUID NOT NULL REFERENCES debit_request(debit_id),
  event_type  TEXT NOT NULL CHECK (event_type IN ('OUTCOME_SUCCESS','OUTCOME_FAILURE')),
  event_time  TIMESTAMPTZ NOT NULL DEFAULT now(),
  details     JSONB
);

-- Helpful indexes
CREATE INDEX IF NOT EXISTS idx_mandate_payer ON mandate(payer_id);
CREATE INDEX IF NOT EXISTS idx_mandate_creditor ON mandate(creditor_id);
CREATE INDEX IF NOT EXISTS idx_debit_mandate ON debit_request(mandate_id);
CREATE INDEX IF NOT EXISTS idx_debit_status ON debit_request(status);
CREATE INDEX IF NOT EXISTS idx_event_debit ON debit_event(debit_id);
