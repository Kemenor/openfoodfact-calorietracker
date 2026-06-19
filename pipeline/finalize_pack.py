#!/usr/bin/env python3
"""Finalize a region pack: dedup by barcode, re-sort deterministically, index,
build the FTS5 search index, optimize + vacuum. Prints the product count.

Determinism matters: the pack's content hash is its version, so a rebuild of
unchanged data must produce byte-identical output (no spurious "update
available"). Hence we re-sort by barcode (source row order can vary), skip
ANALYZE (its sampled stats aren't deterministic), and the caller gzips with -n.

(The standalone sqlite3 CLI here lacks FTS5; Python's bundled sqlite3 has it,
as does the app's bundled sqlite3_flutter_libs.)
"""
import sqlite3
import sys

db = sys.argv[1]
con = sqlite3.connect(db)
con.executescript(
    """
    -- Dedup by barcode (keep first), normalize "no score" nutriscore to NULL,
    -- and re-sort by barcode into fresh sequential rowids for a stable layout.
    CREATE TABLE products_new AS
      SELECT barcode, name, brand, lang, serving_label, serving_g,
             kcal100, protein100, carb100, fat100, fiber100, sugar100,
             satfat100, sodium_mg100, salt100,
             CASE WHEN nutriscore IN ('unknown', 'not-applicable')
                  THEN NULL ELSE nutriscore END AS nutriscore
      FROM products
      WHERE rowid IN (SELECT min(rowid) FROM products GROUP BY barcode)
      ORDER BY barcode;
    DROP TABLE products;
    ALTER TABLE products_new RENAME TO products;

    CREATE UNIQUE INDEX idx_barcode ON products(barcode);
    CREATE VIRTUAL TABLE products_fts USING fts5(
      name, brand,
      content='products', content_rowid='rowid',
      tokenize='unicode61 remove_diacritics 2'
    );
    INSERT INTO products_fts(rowid, name, brand)
      SELECT rowid, name, COALESCE(brand, '') FROM products ORDER BY rowid;
    INSERT INTO products_fts(products_fts) VALUES('optimize');
    """
)
con.commit()
con.execute("VACUUM")
con.commit()
print(con.execute("SELECT count(*) FROM products").fetchone()[0])
con.close()
