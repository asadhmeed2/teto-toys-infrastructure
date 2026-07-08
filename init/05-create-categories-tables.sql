-- ============================================================
-- Categories & Subcategories tables (Integer IDs)
-- ============================================================

CREATE TABLE IF NOT EXISTS categories (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(255) NOT NULL UNIQUE,
    slug        VARCHAR(255) NOT NULL UNIQUE,
    created_at  DATETIME      DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS subcategories (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    category_id    INT NOT NULL,
    name           VARCHAR(255) NOT NULL,
    created_at     DATETIME      DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_subcat_cat FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
    UNIQUE KEY uq_subcat_name (category_id, name)
);

-- Seed default "general" category & subcategory
INSERT INTO categories (id, name, slug) VALUES (1, 'General', 'general')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO subcategories (id, category_id, name) VALUES (1, 1, 'General')
ON DUPLICATE KEY UPDATE name=name;

-- Drop foreign keys if they exist
SET @exist_cat_fk = (SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_schema = 'TetoToys' AND table_name = 'products' AND constraint_name = 'fk_products_category');
SET @sql_cat_fk = IF(@exist_cat_fk > 0, 'ALTER TABLE products DROP FOREIGN KEY fk_products_category;', 'SELECT 1;');
PREPARE stmt_cat FROM @sql_cat_fk;
EXECUTE stmt_cat;
DEALLOCATE PREPARE stmt_cat;

SET @exist_subcat_fk = (SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_schema = 'TetoToys' AND table_name = 'products' AND constraint_name = 'fk_products_subcategory');
SET @sql_subcat_fk = IF(@exist_subcat_fk > 0, 'ALTER TABLE products DROP FOREIGN KEY fk_products_subcategory;', 'SELECT 1;');
PREPARE stmt_subcat FROM @sql_subcat_fk;
EXECUTE stmt_subcat;
DEALLOCATE PREPARE stmt_subcat;

-- Standardize all existing products' category/subcategory columns to '1' (which maps to the default General category/subcategory id)
UPDATE products SET category = '1' WHERE category IS NULL OR category = '' OR category = 'general';
UPDATE products SET subcategory = '1' WHERE subcategory IS NULL OR subcategory = '' OR subcategory = 'general';

-- Change the columns' type in products table to INT
ALTER TABLE products MODIFY category INT NOT NULL;
ALTER TABLE products MODIFY subcategory INT NULL;

-- Recreate foreign key constraints linking products to categories(id) and subcategories(id)
ALTER TABLE products ADD CONSTRAINT fk_products_category FOREIGN KEY (category) REFERENCES categories(id);
ALTER TABLE products ADD CONSTRAINT fk_products_subcategory FOREIGN KEY (subcategory) REFERENCES subcategories(id);
