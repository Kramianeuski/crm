-- migrate:up
CREATE TABLE bull.bull_log (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  queue text NOT NULL,
  payload jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_bull_log_created_at
  ON bull.bull_log (created_at);

CREATE INDEX idx_bull_log_queue
  ON bull.bull_log (queue);

INSERT INTO public.schema_migrations (version) VALUES ('004');
