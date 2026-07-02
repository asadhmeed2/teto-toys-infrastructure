-- ============================================================
-- TetoToys Users Table
-- Auto-executed by MySQL on first container start via
-- /docker-entrypoint-initdb.d/ mount.
-- ============================================================

CREATE TABLE IF NOT EXISTS users (
    user_id           CHAR(36)      PRIMARY KEY,
    email             VARCHAR(255)  UNIQUE NOT NULL,
    password_hash     VARCHAR(255)  NOT NULL,
    first_name        VARCHAR(100)  NOT NULL,
    last_name         VARCHAR(100)  NOT NULL,

    -- Compliance & Security
    is_adult          BOOLEAN       NOT NULL DEFAULT FALSE,
    terms_accepted_at DATETIME      NOT NULL,
    terms_version     VARCHAR(50)   NOT NULL,
    marketing_opt_in  BOOLEAN       DEFAULT FALSE,

    -- Meta
    created_at        DATETIME      DEFAULT CURRENT_TIMESTAMP,
    last_login        DATETIME      NULL,
    is_active         BOOLEAN       DEFAULT TRUE,

    -- Index for fast email lookups during login
    INDEX idx_users_email (email)
);
