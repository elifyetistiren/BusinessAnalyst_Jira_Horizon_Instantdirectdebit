-- Validation & reconciliation queries for PayTo / IDD BA Demo

-- 1) Mandate must be ACTIVE to initiate a debit
SELECT mandate_id, status
FROM mandate
WHERE status <> 'ACTIVE';

-- 2) Mandate must be within valid date range
SELECT mandate_id, start_date, end_date
FROM mandate
WHERE now()::date < start_date
   OR (end_date IS NOT NULL AND now()::date > end_date);

-- 3) Debits that exceed max_amount of the mandate
SELECT d.debit_id, d.amount, m.max_amount, d.mandate_id
FROM debit_request d
JOIN mandate m ON m.mandate_id = d.mandate_id
WHERE d.amount > m.max_amount;

-- 4) Debits initiated against mandates that are not ACTIVE
SELECT d.debit_id, d.status AS debit_status, m.status AS mandate_status, d.rejection_reason
FROM debit_request d
JOIN mandate m ON m.mandate_id = d.mandate_id
WHERE m.status <> 'ACTIVE';

-- 5) Mandatory-field completeness check (should return 0 rows if data is clean)
SELECT *
FROM mandate
WHERE payer_id IS NULL
   OR creditor_id IS NULL
   OR max_amount IS NULL
   OR frequency IS NULL
   OR status IS NULL
   OR start_date IS NULL;

-- 6) Duplicate mandate check (same payer+creditor+frequency+start_date)
SELECT payer_id, creditor_id, frequency, start_date, COUNT(*) AS cnt
FROM mandate
GROUP BY payer_id, creditor_id, frequency, start_date
HAVING COUNT(*) > 1;

-- 7) Reconciliation view: debit -> mandate -> outcome event
SELECT
  d.debit_id,
  d.mandate_id,
  d.amount,
  d.status AS debit_status,
  d.rejection_reason,
  e.event_type,
  e.event_time
FROM debit_request d
LEFT JOIN LATERAL (
  SELECT e1.*
  FROM debit_event e1
  WHERE e1.debit_id = d.debit_id
  ORDER BY e1.event_time DESC
  LIMIT 1
) e ON TRUE
ORDER BY d.requested_at DESC;

-- 8) Any debit that is REJECTED but has no failure outcome event
SELECT d.debit_id
FROM debit_request d
LEFT JOIN debit_event e ON e.debit_id = d.debit_id
WHERE d.status = 'REJECTED'
GROUP BY d.debit_id
HAVING SUM(CASE WHEN e.event_type = 'OUTCOME_FAILURE' THEN 1 ELSE 0 END) = 0;

-- 9) Any debit that is VALIDATED/SETTLED but has no success outcome event
SELECT d.debit_id
FROM debit_request d
LEFT JOIN debit_event e ON e.debit_id = d.debit_id
WHERE d.status IN ('VALIDATED','SETTLED')
GROUP BY d.debit_id
HAVING SUM(CASE WHEN e.event_type = 'OUTCOME_SUCCESS' THEN 1 ELSE 0 END) = 0;
