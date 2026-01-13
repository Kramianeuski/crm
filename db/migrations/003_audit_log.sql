-- migrate:up

CREATE TABLE audit.audit_log (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  event_type text NOT NULL,
  entity_type text,
  entity_id uuid,
  actor_user_id uuid,
  payload jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_audit_log_created_at
  ON audit.audit_log (created_at);

CREATE INDEX idx_audit_log_entity
  ON audit.audit_log (entity_type, entity_id);

-- migrate:down

DROP TABLE IF EXISTS audit.audit_log;
