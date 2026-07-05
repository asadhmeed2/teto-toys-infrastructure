-- ============================================================
-- Admin Users Table
-- Separate from the customers `users` table.
-- Roles: 'Admin', 'Partner'
-- ============================================================

CREATE TABLE IF NOT EXISTS admin_users (
    admin_id      CHAR(36)      PRIMARY KEY,
    email         VARCHAR(255)  UNIQUE NOT NULL,
    password_hash VARCHAR(255)  NOT NULL,
    first_name    VARCHAR(100)  NOT NULL,
    last_name     VARCHAR(100)  NOT NULL,
    role          ENUM('Admin', 'Partner') NOT NULL DEFAULT 'Partner',
    is_active     BOOLEAN       DEFAULT TRUE,
    created_at    DATETIME      DEFAULT CURRENT_TIMESTAMP,
    last_login    DATETIME      NULL,

    INDEX idx_admin_users_email (email)
);
