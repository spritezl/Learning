-- Change History:
-- @version  <1>  08/24/16  FZ  EN #19504: [CMM Allocation] DP page - Transfer Rule Setup. (Flame Zhang)


BEGIN
  FOR ITEM IN (WITH SOURCE AS
                  (SELECT TABLE_NAME SOURCE_NAME
                    FROM DBA_TABLES
                   WHERE OWNER = 'BETA'
                  UNION ALL
                  SELECT VIEW_NAME
                    FROM DBA_VIEWS
                   WHERE OWNER = 'BETA'
                  UNION ALL
                  SELECT DISTINCT OBJECT_NAME
                    FROM DBA_PROCEDURES
                   WHERE OWNER = 'BETA'
                     AND OBJECT_TYPE = 'PACKAGE'
                  UNION ALL
                  SELECT SEQUENCE_NAME
                    FROM DBA_SEQUENCES
                   WHERE SEQUENCE_OWNER = 'BETA'
                  UNION ALL
                  SELECT TYPE_NAME
                    FROM DBA_TYPES
                   WHERE OWNER = 'BETA'
                   AND TYPE_NAME NOT LIKE 'SYS%')
                 SELECT S.SOURCE_NAME, T.SYNONYM_NAME
                   FROM SOURCE S
                   FULL OUTER JOIN (SELECT * FROM DBA_SYNONYMS WHERE OWNER='POSUSER') T
                     ON S.SOURCE_NAME = T.SYNONYM_NAME
                  WHERE (S.SOURCE_NAME IS NULL OR T.SYNONYM_NAME IS NULL)
                    ) LOOP
    IF ITEM.SOURCE_NAME IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('DROP SYNONYM POSUSER.' || ITEM.SYNONYM_NAME);
      EXECUTE IMMEDIATE 'DROP SYNONYM POSUSER.' || ITEM.SYNONYM_NAME;
    ELSE
      DBMS_OUTPUT.PUT_LINE('CREATE SYNONYM POSUSER.' || ITEM.SOURCE_NAME ||
                           ' FOR BETA.' || ITEM.SOURCE_NAME);
      EXECUTE IMMEDIATE 'CREATE SYNONYM POSUSER.' || ITEM.SOURCE_NAME ||
                        ' FOR BETA.' || ITEM.SOURCE_NAME;
    END IF;
  
  END LOOP;

END;
/

