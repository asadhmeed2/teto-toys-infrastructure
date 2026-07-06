-- ============================================================
-- Products, Parts and many-to-many Junction Table
-- ============================================================

CREATE TABLE IF NOT EXISTS products (
    product_id  CHAR(36)       PRIMARY KEY,
    title       VARCHAR(255)   NOT NULL,
    subtitle    VARCHAR(255)   NULL,
    description TEXT           NULL,
    category    VARCHAR(100)   NOT NULL,
    subcategory VARCHAR(100)   NULL,
    price       DECIMAL(10, 2) NOT NULL,
    image_urls  JSON           NULL,
    created_at  DATETIME      DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS parts (
    part_id     CHAR(36)       PRIMARY KEY,
    title       VARCHAR(255)   NOT NULL,
    description TEXT           NULL,
    price       DECIMAL(10, 2) NOT NULL,
    image_urls  JSON           NULL,
    created_at  DATETIME      DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS product_parts (
    product_id CHAR(36) NOT NULL,
    part_id    CHAR(36) NOT NULL,
    PRIMARY KEY (product_id, part_id),
    CONSTRAINT fk_pp_product FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    CONSTRAINT fk_pp_part FOREIGN KEY (part_id) REFERENCES parts(part_id) ON DELETE CASCADE
);
