#!/usr/bin/env python3
"""Finalize a region pack: dedup by barcode, index, build the FTS5 search index,
optimize + vacuum. Run after the DuckDB extraction. Prints the product count.

(The standalone sqlite3 CLI here lacks FTS5; Python's bundled sqlite3 has it,
as does the app's bundled sqlite3_flutter_libs.)
"""
import sqlite3
import sys

db = sys.argv[1]
con = sqlite3.connect(db)
con.executescript(
    """
    DELETE FROM products
      WHERE rowid NOT IN (SELECT min(rowid) FROM products GROUP BY barcode);
    -- normalize "no score" nutriscore values to NULL
    UPDATE products SET nutriscore = NULL
      WHERE nutriscore IN ('unknown', 'not-applicable');
    CREATE UNIQUE INDEX IF NOT EXISTS idx_barcode ON products(barcode);
    CREATE VIRTUAL TABLE IF NOT EXISTS products_fts USING fts5(
      name, brand,
      content='products', content_rowid='rowid',
      tokenize='unicode61 remove_diacritics 2'
    );
    INSERT INTO products_fts(rowid, name, brand)
      SELECT rowid, name, COALESCE(brand, '') FROM products;
    INSERT INTO products_fts(products_fts) VALUES('optimize');
    """
)
con.commit()
con.execute("VACUUM")
con.execute("ANALYZE")
con.commit()
print(con.execute("SELECT count(*) FROM products").fetchone()[0])
con.close()
