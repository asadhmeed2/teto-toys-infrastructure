-- ============================================================
-- Backfill missing 'en' translation rows.
--
-- Every read query resolves text as: requested language -> 'en' -> any language.
-- Rows authored only in a non-English language have no 'en' row, which forced the
-- third (per-row subquery) fallback and previously produced a NULL name.
--
-- The create paths now seed an 'en' row automatically; this repairs rows written
-- before that. Idempotent: INSERT IGNORE plus a HAVING that skips anything that
-- already has 'en', so it is safe to re-run.
--
-- Each source row is wrapped in a derived table so MySQL materialises the SELECT
-- before inserting into the same table it reads from.
--
-- Seeded rows hold the original non-English text until properly translated —
-- the same text the fallback would have displayed, just resolved without a lookup.
-- ============================================================

INSERT IGNORE INTO category_translations (category_id, language_code, name)
SELECT * FROM (
    SELECT ct.category_id, 'en' AS language_code, ct.name
    FROM category_translations ct
    JOIN (
        SELECT category_id, MIN(language_code) AS pick
        FROM category_translations
        GROUP BY category_id
        HAVING SUM(language_code = 'en') = 0
    ) c ON c.category_id = ct.category_id AND c.pick = ct.language_code
) src;

INSERT IGNORE INTO subcategory_translations (subcategory_id, language_code, name)
SELECT * FROM (
    SELECT st.subcategory_id, 'en' AS language_code, st.name
    FROM subcategory_translations st
    JOIN (
        SELECT subcategory_id, MIN(language_code) AS pick
        FROM subcategory_translations
        GROUP BY subcategory_id
        HAVING SUM(language_code = 'en') = 0
    ) s ON s.subcategory_id = st.subcategory_id AND s.pick = st.language_code
) src;

INSERT IGNORE INTO product_translations (product_id, language_code, title, subtitle, description)
SELECT * FROM (
    SELECT pt.product_id, 'en' AS language_code, pt.title, pt.subtitle, pt.description
    FROM product_translations pt
    JOIN (
        SELECT product_id, MIN(language_code) AS pick
        FROM product_translations
        GROUP BY product_id
        HAVING SUM(language_code = 'en') = 0
    ) p ON p.product_id = pt.product_id AND p.pick = pt.language_code
) src;

INSERT IGNORE INTO part_translations (part_id, language_code, title, description)
SELECT * FROM (
    SELECT prt.part_id, 'en' AS language_code, prt.title, prt.description
    FROM part_translations prt
    JOIN (
        SELECT part_id, MIN(language_code) AS pick
        FROM part_translations
        GROUP BY part_id
        HAVING SUM(language_code = 'en') = 0
    ) pr ON pr.part_id = prt.part_id AND pr.pick = prt.language_code
) src;
