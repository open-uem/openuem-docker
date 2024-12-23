#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "postgres" <<-EOSQL
	CREATE DATABASE openuem;
    CREATE USER test WITH ENCRYPTED PASSWORD 'test';
	GRANT ALL PRIVILEGES ON DATABASE openuem TO test;
    ALTER DATABASE openuem OWNER TO test;
EOSQL
