-- DROP DATABASE IF EXISTS product_overview;

-- CREATE DATABASE product_overview;

-- \c product_overview;

DROP TABLE IF EXISTS ref_products;

CREATE TABLE ref_products (
  id INTEGER NOT NULL,
  name VARCHAR(255) NULL DEFAULT NULL,
  slogan VARCHAR(255) NULL DEFAULT NULL,
  description text NULL DEFAULT NULL,
  category VARCHAR(30) NULL DEFAULT NULL,
  default_price DECIMAL NULL DEFAULT NULL,
  PRIMARY KEY (id)
);

COPY ref_products (
id,
name,
slogan,
description,
category,
default_price    )
FROM '/Users/mirasadilov/Desktop/hackreactor/data/product.csv'
DELIMITER ','
CSV HEADER;

-- ---
-- Table 'Styles'
--
-- ---

DROP TABLE IF EXISTS styles CASCADE;

CREATE TABLE styles (
  style_id INTEGER NOT NULL,
  product_id INTEGER NULL DEFAULT NULL,
  "name" TEXT NULL DEFAULT NULL,
  sale_price VARCHAR(100) NULL DEFAULT NULL,
  original_price VARCHAR(100) NULL DEFAULT NULL,
  default_style BOOLEAN NULL DEFAULT NULL,
  PRIMARY KEY (style_id)
);

COPY styles (
style_id,
product_id,
"name",
sale_price,
original_price,
default_style    )
FROM '/Users/mirasadilov/Desktop/hackreactor/data/styles.csv'
DELIMITER ','
CSV HEADER;


-- ---
-- Table 'photos'
--
-- ---

DROP TABLE IF EXISTS photos CASCADE;

CREATE TABLE photos (
  photos_id INTEGER NOT NULL,
  style_id INTEGER NOT NULL,
  url TEXT DEFAULT NULL,
  thumbnail_url TEXT NULL DEFAULT NULL,
  PRIMARY KEY (photos_id)
);


COPY photos (
photos_id,
style_id,
url,
thumbnail_url )
FROM '/Users/mirasadilov/Desktop/hackreactor/data/photos.csv'
DELIMITER ','
CSV HEADER;


-- ---
-- Table 'results'
--
-- ---



-- SELECT a.id, a.name, a.slogan, a.description, a.category, a.default_price,
-- json_agg(json_build_object('features', features.feature, 'values', features.value))
-- features FROM products AS a JOIN features ON features.product_id = a.id
-- GROUP BY features.feature_id, a.id LIMIT 100


-- DROP TABLE IF EXISTS results CASCADE;

-- CREATE TABLE results (
--   style_id INTEGER NULL DEFAULT NULL,
--   name MEDIUMTEXT NULL DEFAULT NULL,
--   original_price DOUBLE NULL DEFAULT NULL,
--   sale_price DOUBLE NULL DEFAULT NULL,
--   default? VARCHAR(10) NULL DEFAULT NULL,
--   PRIMARY KEY ()
-- );

-- ---
-- Table 'related'
--
-- ---

DROP TABLE IF EXISTS related CASCADE;

CREATE TABLE related (
  entry_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  related_product_id INTEGER NULL DEFAULT NULL,
  PRIMARY KEY (entry_id)
);

COPY related (
entry_id,
product_id,
related_product_id)
FROM '/Users/mirasadilov/Desktop/hackreactor/data/related.csv'
DELIMITER ','
CSV HEADER;


-- ---
-- Table 'features'
--
-- ---

DROP TABLE IF EXISTS features CASCADE;

CREATE TABLE features (
  feature_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  feature varchar(255) NULL DEFAULT NULL,
  "value" varchar(255) NULL DEFAULT NULL,
  PRIMARY KEY (feature_id)
);

COPY FEATURES (
feature_id,
product_id,
feature,
"value"     )
FROM '/Users/mirasadilov/Desktop/hackreactor/data/features.csv'
DELIMITER ','
CSV HEADER;



DROP TABLE IF EXISTS skus CASCADE;

CREATE TABLE skus (
	skus_id INTEGER NOT NULL,
    style_id INTEGER NOT NULL,
     size VARCHAR(15) NULL DEFAULT NULL,
     quantity INTEGER NULL DEFAULT NULL,
      PRIMARY KEY(skus_id)
	);

COPY skus (
skus_id,
style_id,
size,
quantity)
FROM '/Users/mirasadilov/Desktop/hackreactor/data/skus.csv'
DELIMITER ','
CSV HEADER;

-- ---
-- Foreign Keys
-- ---

ALTER TABLE  styles ADD FOREIGN KEY (product_id) REFERENCES products (id);
-- ALTER TABLE  results ADD FOREIGN KEY (style_id) REFERENCES styles (product_id);
-- ALTER TABLE  results ADD FOREIGN KEY (style_id) REFERENCES photos (style_id);
ALTER TABLE  related ADD FOREIGN KEY (product_id) REFERENCES products (id);
ALTER TABLE  features ADD FOREIGN KEY (product_id) REFERENCES products (id);

CREATE INDEX IF NOT EXISTS idx_products_id ON products USING btree (id);
CREATE INDEX IF NOT EXISTS idx_skus_style_id ON skus USING btree (style_id);
CREATE INDEX IF NOT EXISTS idx_photos_id ON photos USING btree (photos_id);
CREATE INDEX IF NOT EXISTS idx_photos_style_id ON photos USING btree (style_id);
CREATE INDEX IF NOT EXISTS idx_styles_style_id ON styles USING btree (style_id);
CREATE INDEX IF NOT EXISTS idx_styles_product_id ON styles USING btree (product_id);