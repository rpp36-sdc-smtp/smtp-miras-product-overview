-- CHECK AND CREATE PRODUCT_OVERVIEW DATABASE
DROP DATABASE IF EXISTS product_overview;
CREATE DATABASE product_overview;

-- CONNECT TO PRODUCT_OVERVIEW DATABASE
\c product_overview;

-- CHECK AND CREATE PRODUCTS TABLE
DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id INTEGER NOT NULL,
  name VARCHAR(255) NULL DEFAULT NULL,
  slogan VARCHAR(255) NULL DEFAULT NULL,
  description text NULL DEFAULT NULL,
  category VARCHAR(30) NULL DEFAULT NULL,
  default_price DECIMAL NULL DEFAULT NULL,
  PRIMARY KEY (id)
);

-- LOAD ALL RECORDS INTO PRODUCTS TABLE FROM CSV
COPY products (
id,
name,
slogan,
description,
category,
default_price    )
FROM '/Users/mirasadilov/Desktop/hackreactor/data/product.csv'
DELIMITER ','
CSV HEADER;

-- DROP AND CREATE INDEX ON PRODUCTS
DROP INDEX IF EXISTS idx_products_id;
CREATE INDEX idx_products_id ON products USING btree (id);

-- CHECK AND CREATE STYLES TABLE
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

--LOAD ALL RECORDS INTO STYLES TABLE FROM CSV
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

-- DROP AND CREATE INDEX ON STYLES
DROP INDEX IF EXISTS idx_styles_style_id;
CREATE INDEX idx_styles_style_id ON styles USING btree (style_id);
DROP INDEX IF EXISTS idx_styles_product_id;
CREATE INDEX idx_styles_product_id ON styles USING btree (product_id);

-- CHECK AND CREATE PHOTOS TABLE
DROP TABLE IF EXISTS photos CASCADE;
CREATE TABLE photos (
  photos_id INTEGER NOT NULL,
  style_id INTEGER NOT NULL,
  url TEXT DEFAULT NULL,
  thumbnail_url TEXT NULL DEFAULT NULL,
  PRIMARY KEY (photos_id)
);

--LOAD ALL RECORDS INTO STYLES TABLE FROM CSV
COPY photos (
photos_id,
style_id,
url,
thumbnail_url )
FROM '/Users/mirasadilov/Desktop/hackreactor/data/photos.csv'
DELIMITER ','
CSV HEADER;

-- DROP AND CREATE INDEX ON PHOTOS
DROP INDEX IF EXISTS idx_photos_id;
CREATE INDEX idx_photos_id ON photos USING btree (photos_id);
DROP INDEX IF EXISTS idx_photos_style_id;
CREATE INDEX idx_photos_style_id ON photos USING btree (style_id);

-- CHECK AND CREATE RELATED TABLE
DROP TABLE IF EXISTS related CASCADE;
CREATE TABLE related (
  entry_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  related_product_id INTEGER NULL DEFAULT NULL,
  PRIMARY KEY (entry_id)
);

--LOAD ALL RECORDS INTO RELATED TABLE FROM CSV
COPY related (
entry_id,
product_id,
related_product_id)
FROM '/Users/mirasadilov/Desktop/hackreactor/data/related.csv'
DELIMITER ','
CSV HEADER;

-- DROP AND CREATE INDEX ON RELATED
DROP INDEX IF EXISTS idx_related_id;
CREATE INDEX idx_related_id ON related USING btree (product_id);

-- DROP AND CREATE INDEX ON FEATURES
DROP TABLE IF EXISTS features CASCADE;
CREATE TABLE features (
  feature_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  feature varchar(255) NULL DEFAULT NULL,
  "value" varchar(255) NULL DEFAULT NULL,
  PRIMARY KEY (feature_id)
);

--LOAD ALL RECORDS INTO FEATURES TABLE FROM CSV
COPY features (
feature_id,
product_id,
feature,
"value"     )
FROM '/Users/mirasadilov/Desktop/hackreactor/data/features.csv'
DELIMITER ','
CSV HEADER;

-- DROP AND CREATE INDEX ON FEATURES
DROP INDEX IF EXISTS idx_features_id;
CREATE INDEX idx_features_id ON features USING btree (feature_id);

--LOAD ALL RECORDS INTO AGGREGATED FEATURES TABLE FROM CSV
DROP TABLE IF EXISTS aggregated_features CASCADE;
CREATE TABLE aggregated_features (
  product_id INTEGER NOT NULL,
  features JSON
);

--INSERT ALL RECORDS INTO AGGREGATED FEATURES TABLE
INSERT INTO aggregated_features
SELECT
  a.id,
  json_agg(json_build_object('features', f.feature, 'values', f.value)) as features
FROM
  products AS a JOIN features AS f ON f.product_id = a.id
GROUP BY
  a.id;

-- DROP AND CREATE INDEX ON AGGREGATED FEATURES
DROP INDEX IF EXISTS idx_aggregated_features_id;
CREATE INDEX idx_aggregated_features_id ON aggregated_features USING btree (product_id);

DROP TABLE IF EXISTS APIResponseRecords CASCADE;
CREATE TABLE APIResponseRecords (
  id INTEGER NOT NULL,
  name VARCHAR(255) NULL DEFAULT NULL,
  slogan VARCHAR(255) NULL DEFAULT NULL,
  description text NULL DEFAULT NULL,
  category VARCHAR(30) NULL DEFAULT NULL,
  default_price DECIMAL NULL DEFAULT NULL,
  features JSON
);

--INSERT ALL RECORDS INTO AGGREGATED FEATURES TABLE
INSERT INTO APIResponseRecords
SELECT
  p.id, p.name, p.slogan, p.description, p.category, p.default_price, af.features
FROM
  products AS p JOIN aggregated_features AS af ON af.product_id = p.id;


-- DROP AND CREATE INDEX ON AGGREGATED FEATURES
DROP INDEX IF EXISTS idx_APIResponseRecords_id;
CREATE INDEX idx_APIResponseRecords_id ON APIResponseRecords USING btree (id);
DROP INDEX IF EXISTS idx_APIResponseRecords_category;
CREATE INDEX idx_APIResponseRecords_category ON APIResponseRecords USING btree (category);
DROP INDEX IF EXISTS idx_APIResponseRecords_name;
CREATE INDEX idx_APIResponseRecords_name ON APIResponseRecords USING btree (name);

-- DROP AND CREATE INDEX ON SKUS
DROP TABLE IF EXISTS skus CASCADE;
CREATE TABLE skus (
	skus_id INTEGER NOT NULL,
  style_id INTEGER NOT NULL,
  size VARCHAR(15) NULL DEFAULT NULL,
  quantity INTEGER NULL DEFAULT NULL,
  PRIMARY KEY(skus_id)
	);

--LOAD ALL RECORDS INTO SKUS TABLE FROM CSV
COPY skus (
skus_id,
style_id,
size,
quantity)
FROM '/Users/mirasadilov/Desktop/hackreactor/data/skus.csv'
DELIMITER ','
CSV HEADER;

-- DROP AND CREATE INDEX ON SKUS
DROP INDEX IF EXISTS idx_skus_style_id;
CREATE INDEX idx_skus_style_id ON skus USING btree (style_id);

--ALTERING TABLE TO ADD FOREIGN KEYS
ALTER TABLE  styles ADD FOREIGN KEY (product_id) REFERENCES products (id);
-- ALTER TABLE  results ADD FOREIGN KEY (style_id) REFERENCES styles (product_id);
-- ALTER TABLE  results ADD FOREIGN KEY (style_id) REFERENCES photos (style_id);
ALTER TABLE  related ADD FOREIGN KEY (product_id) REFERENCES products (id);
ALTER TABLE  features ADD FOREIGN KEY (product_id) REFERENCES products (id);

