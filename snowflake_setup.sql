CREATE DATABASE SUPERSTORE;

USE DATABASE SUPERSTORE;

CREATE ROLE SUPERSTORE_USER;

GRANT CREATE STAGE ON SCHEMA PUBLIC TO ROLE SUPERSTORE_USER;

DESC INTEGRATION S3_INT;

GRANT USAGE ON INTEGRATION S3_INT TO ROLE SUPERSTORE_USER;

ALTER STORAGE INTEGRATION S3_INT
SET STORAGE_ALLOWED_LOCATIONS = ('s3://superstore-raw-data-0410/','s3://raw-data-dw-0410/raw-data/');

CREATE OR REPLACE FILE FORMAT CSV_FORMAT
TYPE = 'CSV'
FIELD_DELIMITER = ','
SKIP_HEADER = 1
NULL_IF = 'NULL'
EMPTY_FIELD_AS_NULL = TRUE
FIELD_OPTIONALLY_ENCLOSED_BY = '"';

DROP STAGE SS_RAW_STAGE;

CREATE STAGE SS_RAW_STAGE
STORAGE_INTEGRATION = S3_INT
URL = 's3://superstore-raw-data-0410/Superstore.csv'
FILE_FORMAT = csv_format;

CREATE STAGE SR_RAW_STAGE
STORAGE_INTEGRATION = S3_INT
URL = 's3://superstore-raw-data-0410/Returns.csv'
FILE_FORMAT = csv_format;

CREATE STAGE SP_RAW_STAGE
STORAGE_INTEGRATION = S3_INT
URL = 's3://superstore-raw-data-0410/People.csv'
FILE_FORMAT = csv_format;

CREATE TABLE ALL_DATA
AS 
SELECT $2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21 from @SS_RAW_STAGE;

select * from all_data;

CREATE TABLE RETURNS AS 
SELECT $1,$2 FROM @SR_RAW_STAGE;
 
SELECT * FROM RETURNS;

CREATE TABLE PEOPLE AS
SELECT $1,$2 FROM @SP_RAW_STAGE;

SELECT * FROM PEOPLE;

ALTER SESSION SET AUTOCOMMIT = FALSE;
