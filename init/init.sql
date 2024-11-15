-- ./init/init.sql

CREATE DATABASE prod_db;
CREATE DATABASE raw_db;

\c prod_db
CREATE SCHEMA staging;
CREATE SCHEMA marts;
CREATE SCHEMA raw;

\c dev_db
CREATE SCHEMA staging;
CREATE SCHEMA marts;
CREATE SCHEMA raw;

