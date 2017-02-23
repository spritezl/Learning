--please make sure tablespace beta_data, tnsname opti7app and opti7pos are in place.
--please run the following sql to create the user as sysdba
DROP USER BETA CASCADE;

CREATE USER BETA IDENTIFIED BY sol
DEFAULT TABLESPACE BETA_DATA;

GRANT DBA TO BETA;

GRANT DROP ANY SEQUENCE TO BETA;
GRANT CREATE ANY SEQUENCE TO BETA;

--please run the following sql to create the user as beta
CREATE DATABASE LINK MYLINKAPP
  CONNECT TO APPUSER IDENTIFIED BY sol
  USING 'OPTI7APP';
  
  
CREATE DATABASE LINK MYLINKPOS
  CONNECT TO POSUSER IDENTIFIED BY sol
  USING 'OPTI7POS';
