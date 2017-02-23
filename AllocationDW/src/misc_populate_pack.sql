CREATE OR REPLACE PACKAGE MISC_POPULATE_PACK IS

  -- Author  : FZHANG
  -- Created : 11/28/2016 9:59:25 9:59:25
  -- Purpose : The populate package dedicated for miscellaneous settting

  --known issues:
  --1,so far there are merely two upload formats:
  --   transfer matrix by loc attr * by loc attr
  --   transfer matrix by door * by door

  PROCEDURE POP_TRANSFER_MATRIX(P_IS_INITIAL         BOOLEAN DEFAULT TRUE,
                                P_BASE_UNITS_ID      NUMBER,
                                P_TRANSFER_MATRIX_ID DIM_TRANSFER_MATRIX.TRANSFER_MATRIX_ID%TYPE,
                                P_FROM_LOC_ATTR_ID   DIM_LOC_ATTR.LOC_ATTR_ID%TYPE,
                                P_TO_LOC_ATTR_ID     DIM_LOC_ATTR.LOC_ATTR_ID%TYPE);

  --known issues:
  --1,so far there are merely two upload formats:
  --   box style by prod attr * by loc attr
  --   box style by style color * by door
  --2,parameters
  --   P_IS_INITIAL: whether this is the initialization process
  --   p_base_units_id:box_style.base_units_id
  --   p_prod_attrs: prod attr name string
  --   p_loc_attrs: loc attr name col string the order of which should follow the loc key definition, its value should like loc_attr_value2,loc_attr_value3,loc_attr_value1
  PROCEDURE POP_BOXSTYLE(P_IS_INITIAL    BOOLEAN DEFAULT TRUE,
                         P_BASE_UNITS_ID NUMBER,
                         P_BOXSTYLE_ID   DIM_BOXSTYLE.BOXSTYLE_ID%TYPE,
                         P_PROD_ATTR_ID  DIM_PROD_ATTR.PROD_ATTR_ID%TYPE,
                         P_LOC_ATTRS     VARCHAR2);


  --known issues:
  --1,so far there are merely two upload formats:
  --   box style by prod attr * by loc attr
  --   box style by style color * by door
  --2,parameters
  --   P_IS_INITIAL: whether this is the initialization process
  --   p_base_units_id:box_style.base_units_id
  --   p_prod_attrs: prod attr name string
  --   p_loc_attrs: loc attr name col string the order of which should follow the loc key definition, its value should like loc_attr_value2,loc_attr_value3,loc_attr_value1
  --   EXAMPLE:
  --    BEGIN
  --     BETA.MISC_POPULATE_PACK.POP_CORE_SIZE(P_IS_INITIAL    => FALSE,
  --                                          P_BASE_UNITS_ID => 1,
  --                                          P_CORE_SIZE_ID  => 1,
  --                                          P_PROD_ATTR_ID  => 121,
  --                                          P_LOC_ATTRS     => 'LOC_ATTR1,LOC_ATTR2,LOC_ATTR3');
  --    END;

  PROCEDURE POP_CORE_SIZE(P_IS_INITIAL    BOOLEAN DEFAULT TRUE,
                         P_BASE_UNITS_ID NUMBER,
                         P_CORE_SIZE_ID  DIM_CORE_SIZE.CORE_SIZE_ID%TYPE,
                         P_PROD_ATTR_ID  DIM_PROD_ATTR.PROD_ATTR_ID%TYPE,
                         P_LOC_ATTRS     VARCHAR2);


  --known issues:
  --1,so far there are merely two upload formats:
  --   min max by prod attr * by loc attr
  --   min max by style color * by loc attr
  --2,parameters
  --   P_IS_INITIAL: whether this is the initialization process
  --   p_base_units_id:box_style.base_units_id
  --   p_prod_attr_id: prod attr id
  --   p_loc_attr_id: loc attr id
  PROCEDURE POP_MIN_MAX(P_IS_INITIAL     BOOLEAN DEFAULT TRUE,
                         P_BASE_UNITS_ID NUMBER,
                         P_MIN_MAX_ID    DIM_MIN_MAX.MIN_MAX_ID%TYPE,
                         P_PROD_ATTR_ID  DIM_PROD_ATTR.PROD_ATTR_ID%TYPE,
                         P_LOC_ATTR_ID   DIM_LOC_ATTR.LOC_ATTR_ID%TYPE);

END MISC_POPULATE_PACK;
/
CREATE OR REPLACE PACKAGE BODY MISC_POPULATE_PACK IS

  C_DUMMY                     CONSTANT VARCHAR2(10) := 'DUMMY';
  C_DELIMITER                 CONSTANT CHAR := '-';

  TYPE NNT_CACHE IS TABLE OF DIM_PROD_ATTR.TARGET_BUSKEY_HASH_STR%TYPE INDEX BY PLS_INTEGER;
  L_CACHE_PROD_ATTR_BK     NNT_CACHE;
  L_CACHE_LOC_ATTR_BK      NNT_CACHE;

  TYPE TEMP_REC IS RECORD(
       ATTR_ID DIM_PROD_ATTR.PROD_ATTR_ID%TYPE,
       TARGET_BUSKEY_HASH_STR DIM_PROD_ATTR.TARGET_BUSKEY_HASH_STR%TYPE);

  TYPE TEMP_CACHE IS TABLE OF TEMP_REC;
  L_TEMP_CACHE               TEMP_CACHE;


  --This is an internal function to generate join clause when the source links to dim_prod_attr/dim_loc_attr/dim_yearseason_attr
  --1,P_LEFT_TAB_ALIAS:Left hand table alias
  --2,RIGHT_TAB_ALIAS:Right hand table alias
  --3,LEFT_TEMPLATE_COLUMN_NAME:Left hand template column name such as prod_attr/loc_attr
  --4,RIGHT_TEMPLATE_COLUMN_NAME:Right hand template column name such as prod_attr/loc_attr
  --5,SOURCE_BUSKEY_HASH_STR: dim_prod_attr/dim_loc_attr.SOURCE_BUSKEY_HASH_STR
  --the returning string should like:
  --    AND NVL(UPPER(A.PROD_ATTR1),'DUMMY')=B.PROD_ATTR_VALUE1
  --    AND NVL(UPPER(A.PROD_ATTR2),'DUMMY')=B.PROD_ATTR_VALUE2
  FUNCTION GET_ATTR_JOIN_CLAUSE(P_LEFT_TAB_ALIAS             VARCHAR2,
                                P_RIGHT_TAB_ALIAS            VARCHAR2,
                                P_LEFT_TEMPLATE_COLUMN_NAME  VARCHAR2,
                                P_RIGHT_TEMPLATE_COLUMN_NAME VARCHAR2,
                                P_TARGET_BUSKEY_HASH_STR     VARCHAR2)
    RETURN VARCHAR2 IS
    L_ATTR_JOIN_CLAUSE VARCHAR2(1000);
  BEGIN

    SELECT LISTAGG('AND NVL(UPPER('||P_LEFT_TAB_ALIAS||'.' || P_LEFT_TEMPLATE_COLUMN_NAME || ID ||
                   '),'''||C_DUMMY||''')='||P_RIGHT_TAB_ALIAS||'.' || P_RIGHT_TEMPLATE_COLUMN_NAME || SEQ,
                   CHR(10)) WITHIN GROUP(ORDER BY ID)
      INTO L_ATTR_JOIN_CLAUSE
      FROM (SELECT ROW_NUMBER() OVER(ORDER BY INSTR(',' || P_TARGET_BUSKEY_HASH_STR || ',',
                            ',' || O.SEQ || ',')) ID, O.SEQ
              FROM (SELECT LEVEL SEQ FROM DUAL CONNECT BY LEVEL <= 20) O
             WHERE ',' || P_TARGET_BUSKEY_HASH_STR || ',' LIKE
                   '%,' || O.SEQ || ',%'
             ORDER BY INSTR(',' || P_TARGET_BUSKEY_HASH_STR || ',',
                            ',' || O.SEQ || ','));
    RETURN L_ATTR_JOIN_CLAUSE;
  END GET_ATTR_JOIN_CLAUSE;


  FUNCTION GET_LOC_SOURCE_BUSKEY_CLAUSE(P_LOC_ATTRS       VARCHAR2,
                                 P_LOC_TEMPLATE_COL_NAME  VARCHAR2,
                                 P_LEFT_TAB_ALIAS         VARCHAR2,
                                 P_MAX_LOC_ATTRS          NUMBER)
     RETURN VARCHAR2 IS
     L_SOURCE_BUSKEY_STR VARCHAR2(500):='UPPER(TRIM(';
     BEGIN
       FOR ITEM IN (SELECT P_LOC_TEMPLATE_COL_NAME || TO_CHAR(O.SEQ) LOC_ATTR,
                           INSTR(UPPER(P_LOC_ATTRS),
                              P_LOC_TEMPLATE_COL_NAME || TO_CHAR(O.SEQ)) SEQ
                   FROM (SELECT LEVEL SEQ
                           FROM DUAL
                         CONNECT BY LEVEL <= P_MAX_LOC_ATTRS) O
                  WHERE '%,' || UPPER(P_LOC_ATTRS) || ',%' LIKE
                        '%,' || P_LOC_TEMPLATE_COL_NAME || TO_CHAR(O.SEQ) || ',%'
                  ORDER BY INSTR(UPPER(P_LOC_ATTRS),
                                 P_LOC_TEMPLATE_COL_NAME || TO_CHAR(O.SEQ))) LOOP
        L_SOURCE_BUSKEY_STR := L_SOURCE_BUSKEY_STR || (CASE
                                 WHEN ITEM.SEQ = 1 THEN
                                  ' '
                                 ELSE
                                  '||'''||C_DELIMITER||'''||'
                               END) || 'NVL('||P_LEFT_TAB_ALIAS||'.' || ITEM.LOC_ATTR || ','' '')';
      END LOOP;
      L_SOURCE_BUSKEY_STR:=L_SOURCE_BUSKEY_STR||'))';
      RETURN L_SOURCE_BUSKEY_STR;
  END GET_LOC_SOURCE_BUSKEY_CLAUSE;

  PROCEDURE POP_TRANSFER_MATRIX(P_IS_INITIAL         BOOLEAN DEFAULT TRUE,
                                P_BASE_UNITS_ID      NUMBER,
                                P_TRANSFER_MATRIX_ID DIM_TRANSFER_MATRIX.TRANSFER_MATRIX_ID%TYPE,
                                P_FROM_LOC_ATTR_ID   DIM_LOC_ATTR.LOC_ATTR_ID%TYPE,
                                P_TO_LOC_ATTR_ID     DIM_LOC_ATTR.LOC_ATTR_ID%TYPE) IS
                                L_SQL VARCHAR2(32767);

  BEGIN
    IF P_IS_INITIAL THEN

      DIM_POPULATE_PACK.DISABLE_ALL_CONS;

      EXECUTE IMMEDIATE 'TRUNCATE TABLE FACT_TRANSFER_MATRIX_LOC_LOC';
      EXECUTE IMMEDIATE 'TRUNCATE TABLE FACT_TRANSFER_MATRIX_DOOR_DOOR';

      DIM_POPULATE_PACK.RELY_ALL_CONS;

    END IF;

    IF P_FROM_LOC_ATTR_ID>0 AND P_TO_LOC_ATTR_ID>0 THEN

      L_SQL :='
      MERGE INTO FACT_TRANSFER_MATRIX_LOC_LOC T
      USING (SELECT :TRANSFER_MATRIX_ID TRANSFER_MATRIX_ID,
                    NVL(B.LOC_ATTR_VALUE_ID, 0) FROM_LOC_ATTR_VALUE_ID,
                    NVL(C.LOC_ATTR_VALUE_ID, 0) TO_LOC_ATTR_VALUE_ID,
                    NVL(A.PRIORITY, 0) PRIORITY,
                    NVL(A.LEADTIME, 0) LEADTIME
               FROM TRANSFER_MATRIX@MYLINKAPP A
               LEFT JOIN DIM_LOC_ATTR_VALUE B
                 ON B.LOC_ATTR_ID = :FROM_LOC_ATTR_ID'||CHR(10)||GET_ATTR_JOIN_CLAUSE('A','B','FROM_LOC_ATTR','LOC_ATTR_VALUE', L_CACHE_LOC_ATTR_BK(P_FROM_LOC_ATTR_ID))||CHR(10)||
               'LEFT JOIN DIM_LOC_ATTR_VALUE C
                 ON C.LOC_ATTR_ID = :TO_LOC_ATTR_ID'||CHR(10)||GET_ATTR_JOIN_CLAUSE('A','C','DEST_LOC_ATTR','LOC_ATTR_VALUE', L_CACHE_LOC_ATTR_BK(P_TO_LOC_ATTR_ID))||CHR(10)||
              'WHERE A.FROM_COMPANY_DOOR_ID IS NULL
                AND A.DEST_COMPANY_DOOR_ID IS NULL
                AND A.BASE_UNITS_ID =:BASE_UNITS_ID) S
      ON (T.TRANSFER_MATRIX_ID = S.TRANSFER_MATRIX_ID AND T.FROM_LOC_ATTR_VALUE_ID = S.FROM_LOC_ATTR_VALUE_ID AND T.TO_LOC_ATTR_VALUE_ID = S.TO_LOC_ATTR_VALUE_ID)
      WHEN MATCHED THEN
        UPDATE SET T.PRIORITY = S.PRIORITY, T.LEADTIME = S.LEADTIME
      WHEN NOT MATCHED THEN
        INSERT
          (T.TRANSFER_MATRIX_ID,
           T.FROM_LOC_ATTR_VALUE_ID,
           T.TO_LOC_ATTR_VALUE_ID,
           T.PRIORITY,
           T.LEADTIME)
        VALUES
          (S.TRANSFER_MATRIX_ID,
           S.FROM_LOC_ATTR_VALUE_ID,
           S.TO_LOC_ATTR_VALUE_ID,
           S.PRIORITY,
           S.LEADTIME)';
      DBMS_OUTPUT.PUT_LINE(L_SQL);
      EXECUTE IMMEDIATE L_SQL USING P_TRANSFER_MATRIX_ID,P_FROM_LOC_ATTR_ID,P_TO_LOC_ATTR_ID, P_BASE_UNITS_ID;

    END IF;

    MERGE INTO FACT_TRANSFER_MATRIX_DOOR_DOOR T
    USING (SELECT P_TRANSFER_MATRIX_ID TRANSFER_MATRIX_ID,
                  NVL(B.STORE_ID, 0) FROM_STORE_ID,
                  NVL(C.STORE_ID, 0) TO_STORE_ID,
                  NVL(A.PRIORITY, 0) PRIORITY,
                  NVL(A.LEADTIME, 0) LEADTIME
             FROM TRANSFER_MATRIX@MYLINKAPP A
             LEFT JOIN DIM_STORE_STORE B
               ON B.TARGET_BUSKEY = UPPER(A.FROM_COMPANY_DOOR_ID)
             LEFT JOIN DIM_STORE_STORE C
               ON C.TARGET_BUSKEY = UPPER(A.DEST_COMPANY_DOOR_ID)
            WHERE A.FROM_COMPANY_DOOR_ID IS NOT NULL
              AND A.DEST_COMPANY_DOOR_ID IS NOT NULL
              AND A.BASE_UNITS_ID =P_BASE_UNITS_ID) S
    ON (T.TRANSFER_MATRIX_ID = S.TRANSFER_MATRIX_ID AND T.FROM_STORE_ID = S.FROM_STORE_ID AND T.TO_STORE_ID = S.TO_STORE_ID)
    WHEN MATCHED THEN
      UPDATE SET T.PRIORITY = S.PRIORITY, T.LEADTIME = S.LEADTIME
    WHEN NOT MATCHED THEN
      INSERT
        (T.TRANSFER_MATRIX_ID,
         T.FROM_STORE_ID,
         T.TO_STORE_ID,
         T.PRIORITY,
         T.LEADTIME)
      VALUES
        (S.TRANSFER_MATRIX_ID,
         S.FROM_STORE_ID,
         S.TO_STORE_ID,
         S.PRIORITY,
         S.LEADTIME);

    COMMIT;

  END POP_TRANSFER_MATRIX;

  PROCEDURE POP_BOXSTYLE(P_IS_INITIAL    BOOLEAN DEFAULT TRUE,
                         P_BASE_UNITS_ID NUMBER,
                         P_BOXSTYLE_ID   DIM_BOXSTYLE.BOXSTYLE_ID%TYPE,
                         P_PROD_ATTR_ID  DIM_PROD_ATTR.PROD_ATTR_ID%TYPE,
                         P_LOC_ATTRS     VARCHAR2) IS

    L_SQL               VARCHAR2(32767);
    L_SOURCE_BUSKEY_STR VARCHAR2(1000);
    C_MAX_LOC_ATTRS     CONSTANT PLS_INTEGER := 6;
    C_LOC_ATTR_COL_NAME CONSTANT VARCHAR2(20) := 'LOC_ATTR_VALUE';
  BEGIN
    IF P_IS_INITIAL THEN

      DIM_POPULATE_PACK.DISABLE_ALL_CONS;

      EXECUTE IMMEDIATE 'TRUNCATE TABLE FACT_BOXSTYLE_PROD_LOC';
      EXECUTE IMMEDIATE 'TRUNCATE TABLE FACT_BOXSTYLE_SC_LOC';

      DIM_POPULATE_PACK.RELY_ALL_CONS;

    END IF;

    L_SQL := '
    BEGIN
    MERGE INTO FACT_BOXSTYLE_PROD_LOC T
    USING (SELECT :BOXSTYLE_ID BOXSTYLE_ID,
                  NVL(B.PROD_ATTR_VALUE_ID, 0) PROD_ATTR_VALUE_ID,
                  NVL(C.STORE_LOC_ID, 0) STORE_LOC_ID,
                  NVL(D.YEAR_SEASON_ID, 0) YEAR_SEASON_ID,
                  NVL(A.BOX_GROUP_CODE, '''||C_DUMMY||''') BOX_GROUP_CODE,
                  NVL(A.BOX_GROUP_NAME, '''||C_DUMMY||''') BOX_GROUP_NAME,
                  NVL(A.BOX_CODE, '''||C_DUMMY||''') BOX_CODE,
                  NVL(A.BOX_NAME, '''||C_DUMMY||''') BOX_NAME,
                  NVL(A.CORE_STYLE_INDICATOR, ''N'') CORE_STYLE_INDICATOR
             FROM BOX_STYLE@MYLINKAPP A
             LEFT JOIN DIM_PROD_ATTR_VALUE B
               ON B.PROD_ATTR_ID = :PROD_ATTR_ID'||CHR(10)||GET_ATTR_JOIN_CLAUSE('A','B','PROD_ATTR_VALUE','PROD_ATTR_VALUE',L_CACHE_PROD_ATTR_BK(P_PROD_ATTR_ID))||CHR(10)||
             'LEFT JOIN DIM_STORE_LOC C
               ON C.SOURCE_BUSKEY =<SOURCE_BUSKEY_STR>
             LEFT JOIN DIM_YEAR_SEASON D
               ON A.STYLE_YEAR = D.STYLE_YEAR
              AND A.STYLE_SEASON_ID = D.ORI_SEASON_ID
            WHERE A.STYLE_COLOR_ID IS NULL
            AND A.BASE_UNITS_ID=:BASE_UNITS_ID) S
    ON (T.BOXSTYLE_ID = S.BOXSTYLE_ID AND T.PROD_ATTR_VALUE_ID = S.PROD_ATTR_VALUE_ID AND T.YEAR_SEASON_ID = S.YEAR_SEASON_ID AND T.STORE_LOC_ID = S.STORE_LOC_ID)
    WHEN MATCHED THEN
      UPDATE
         SET T.BOX_GROUP_CODE = S.BOX_GROUP_CODE,
             T.BOX_GROUP_NAME = S.BOX_GROUP_NAME,
             T.BOX_CODE       = S.BOX_CODE,
             T.BOX_NAME       = S.BOX_NAME
    WHEN NOT MATCHED THEN
      INSERT
        (T.BOXSTYLE_ID,
         T.PROD_ATTR_VALUE_ID,
         T.YEAR_SEASON_ID,
         T.STORE_LOC_ID,
         T.BOX_GROUP_CODE,
         T.BOX_GROUP_NAME,
         T.BOX_CODE,
         T.BOX_NAME,
         T.CORE_STYLE_INDICATOR)
      VALUES
        (S.BOXSTYLE_ID,
         S.PROD_ATTR_VALUE_ID,
         S.YEAR_SEASON_ID,
         S.STORE_LOC_ID,
         S.BOX_GROUP_CODE,
         S.BOX_GROUP_NAME,
         S.BOX_CODE,
         S.BOX_NAME,
         S.CORE_STYLE_INDICATOR);

    MERGE INTO FACT_BOXSTYLE_SC_LOC T
    USING (SELECT :BOXSTYLE_ID BOXSTYLE_ID,
                  NVL(B.STYLE_COLOR_ID, 0) STYLE_COLOR_ID,
                  NVL(C.STORE_LOC_ID, 0) STORE_LOC_ID,
                  NVL(D.YEAR_SEASON_ID, 0) YEAR_SEASON_ID,
                  NVL(A.BOX_GROUP_CODE, '''||C_DUMMY||''') BOX_GROUP_CODE,
                  NVL(A.BOX_GROUP_NAME, '''||C_DUMMY||''') BOX_GROUP_NAME,
                  NVL(A.BOX_CODE, '''||C_DUMMY||''') BOX_CODE,
                  NVL(A.BOX_NAME, '''||C_DUMMY||''') BOX_NAME,
                  NVL(A.CORE_STYLE_INDICATOR, ''N'') CORE_STYLE_INDICATOR
             FROM BOX_STYLE@MYLINKAPP A
             LEFT JOIN DIM_STYLE_COLOR B
             ON B.ORI_STYLE_COLOR_ID=A.STYLE_COLOR_ID
             LEFT JOIN DIM_STORE_LOC C
               ON C.SOURCE_BUSKEY =<SOURCE_BUSKEY_STR>
             LEFT JOIN DIM_YEAR_SEASON D
               ON A.STYLE_YEAR = D.STYLE_YEAR
              AND A.STYLE_SEASON_ID = D.ORI_SEASON_ID
            WHERE A.STYLE_COLOR_ID IS NOT NULL
            AND A.BASE_UNITS_ID=:BASE_UNITS_ID) S
    ON (T.BOXSTYLE_ID = S.BOXSTYLE_ID AND T.STYLE_COLOR_ID = S.STYLE_COLOR_ID AND T.YEAR_SEASON_ID = S.YEAR_SEASON_ID AND T.STORE_LOC_ID = S.STORE_LOC_ID)
    WHEN MATCHED THEN
      UPDATE
         SET T.BOX_GROUP_CODE = S.BOX_GROUP_CODE,
             T.BOX_GROUP_NAME = S.BOX_GROUP_NAME,
             T.BOX_CODE       = S.BOX_CODE,
             T.BOX_NAME       = S.BOX_NAME
    WHEN NOT MATCHED THEN
      INSERT
        (T.BOXSTYLE_ID,
         T.STYLE_COLOR_ID,
         T.YEAR_SEASON_ID,
         T.STORE_LOC_ID,
         T.BOX_GROUP_CODE,
         T.BOX_GROUP_NAME,
         T.BOX_CODE,
         T.BOX_NAME,
         T.CORE_STYLE_INDICATOR)
      VALUES
        (S.BOXSTYLE_ID,
         S.STYLE_COLOR_ID,
         S.YEAR_SEASON_ID,
         S.STORE_LOC_ID,
         S.BOX_GROUP_CODE,
         S.BOX_GROUP_NAME,
         S.BOX_CODE,
         S.BOX_NAME,
         S.CORE_STYLE_INDICATOR);
         END;';

    L_SOURCE_BUSKEY_STR:=GET_LOC_SOURCE_BUSKEY_CLAUSE(UPPER(P_LOC_ATTRS),UPPER(C_LOC_ATTR_COL_NAME),'A',C_MAX_LOC_ATTRS);
    L_SQL := REPLACE(L_SQL, '<SOURCE_BUSKEY_STR>', L_SOURCE_BUSKEY_STR);

    DBMS_OUTPUT.PUT_LINE(L_SQL);
    EXECUTE IMMEDIATE L_SQL USING P_BOXSTYLE_ID,P_PROD_ATTR_ID,P_BASE_UNITS_ID;

    COMMIT;

  END POP_BOXSTYLE;


  PROCEDURE POP_CORE_SIZE(P_IS_INITIAL    BOOLEAN DEFAULT TRUE,
                         P_BASE_UNITS_ID NUMBER,
                         P_CORE_SIZE_ID  DIM_CORE_SIZE.CORE_SIZE_ID%TYPE,
                         P_PROD_ATTR_ID  DIM_PROD_ATTR.PROD_ATTR_ID%TYPE,
                         P_LOC_ATTRS     VARCHAR2) IS

    L_SQL               VARCHAR2(32767);
    L_SOURCE_BUSKEY_STR VARCHAR2(1000) := 'UPPER(TRIM(';
    C_MAX_LOC_ATTRS     CONSTANT PLS_INTEGER := 6;
    C_LOC_ATTR_COL_NAME CONSTANT VARCHAR2(20) := 'LOC_ATTR';
  BEGIN
    IF P_IS_INITIAL THEN

      DIM_POPULATE_PACK.DISABLE_ALL_CONS;

      EXECUTE IMMEDIATE 'TRUNCATE TABLE FACT_CORE_SIZE';

      DIM_POPULATE_PACK.RELY_ALL_CONS;

    END IF;

    L_SQL := '
    MERGE INTO FACT_CORE_SIZE T
    USING (SELECT :CORE_SIZE_ID CORE_SIZE_ID,
                  NVL(D.SIZE_ITEM_ID, 0) SIZE_ITEM_ID,
                  NVL(B.PROD_ATTR_VALUE_ID, 0) PROD_ATTR_VALUE_ID,
                  NVL(C.STORE_LOC_ID, 0) STORE_LOC_ID,
                  DECODE(NVL(A.CORE_SIZE_INDICATOR, 0),1,''Y'',''N'') CORE_SIZE_INDICATOR
             FROM (
                SELECT DISTINCT UPPER(A3.BUYER_DEPT_NUM) || '''||C_DELIMITER||''' ||
                       UPPER(A2.SIZE_RANGE_NAME) || '''||C_DELIMITER||''' || UPPER(A2.SIZE_CODE) SIZE_ITEM_BK,
                       A1.*
                FROM CORE_SIZE@MYLINKAPP A1
               INNER JOIN SIZE_RANGE@MYLINKAPP A2
                  ON A1.SIZE_RANGE_ID = A2.SIZE_RANGE_ID
               INNER JOIN BUYER_DEPT@MYLINKAPP A3
                  ON A2.BUYER_DEPT_ID = A3.BUYER_DEPT_ID) A
             LEFT JOIN DIM_PROD_ATTR_VALUE B
               ON B.PROD_ATTR_ID = :PROD_ATTR_ID'||CHR(10)||GET_ATTR_JOIN_CLAUSE('A','B','PROD_ATTR_VALUE','PROD_ATTR_VALUE',L_CACHE_PROD_ATTR_BK(P_PROD_ATTR_ID))||CHR(10)||
             'LEFT JOIN DIM_STORE_LOC C
               ON C.SOURCE_BUSKEY =<SOURCE_BUSKEY_STR>
             LEFT JOIN DIM_SIZE_ITEM D
               ON A.SIZE_ITEM_BK = D.SOURCE_BUSKEY
            WHERE A.BASE_UNITS_ID=:BASE_UNITS_ID) S
    ON (T.CORE_SIZE_ID = S.CORE_SIZE_ID AND T.SIZE_ITEM_ID = S.SIZE_ITEM_ID AND T.PROD_ATTR_VALUE_ID = S.PROD_ATTR_VALUE_ID AND T.STORE_LOC_ID = S.STORE_LOC_ID)
    WHEN MATCHED THEN
      UPDATE
         SET T.CORE_SIZE_INDICATOR = S.CORE_SIZE_INDICATOR
    WHEN NOT MATCHED THEN
      INSERT
        (T.CORE_SIZE_ID,
         T.SIZE_ITEM_ID,
         T.PROD_ATTR_VALUE_ID,
         T.STORE_LOC_ID,
         T.CORE_SIZE_INDICATOR)
      VALUES
        (S.CORE_SIZE_ID,
         S.SIZE_ITEM_ID,
         S.PROD_ATTR_VALUE_ID,
         S.STORE_LOC_ID,
         S.CORE_SIZE_INDICATOR)';

    L_SOURCE_BUSKEY_STR:=GET_LOC_SOURCE_BUSKEY_CLAUSE(UPPER(P_LOC_ATTRS),UPPER(C_LOC_ATTR_COL_NAME),'A',C_MAX_LOC_ATTRS);
    L_SQL := REPLACE(L_SQL, '<SOURCE_BUSKEY_STR>', L_SOURCE_BUSKEY_STR);

    DBMS_OUTPUT.PUT_LINE(L_SQL);
    EXECUTE IMMEDIATE L_SQL USING P_CORE_SIZE_ID,P_PROD_ATTR_ID,P_BASE_UNITS_ID;

    COMMIT;

  END POP_CORE_SIZE;

  PROCEDURE POP_MIN_MAX(P_IS_INITIAL     BOOLEAN DEFAULT TRUE,
                         P_BASE_UNITS_ID NUMBER,
                         P_MIN_MAX_ID    DIM_MIN_MAX.MIN_MAX_ID%TYPE,
                         P_PROD_ATTR_ID  DIM_PROD_ATTR.PROD_ATTR_ID%TYPE,
                         P_LOC_ATTR_ID   DIM_LOC_ATTR.LOC_ATTR_ID%TYPE)
                         IS
    L_SQL VARCHAR2(32767);

  BEGIN
    IF P_IS_INITIAL THEN

      DIM_POPULATE_PACK.DISABLE_ALL_CONS;

      EXECUTE IMMEDIATE 'TRUNCATE TABLE FACT_MIN_MAX_PROD_LOC';
      EXECUTE IMMEDIATE 'TRUNCATE TABLE FACT_MIN_MAX_SC_LOC';

      DIM_POPULATE_PACK.RELY_ALL_CONS;

    END IF;

    L_SQL := '
    BEGIN
    MERGE INTO FACT_MIN_MAX_PROD_LOC T
    USING (SELECT :MIN_MAX_ID MIN_MAX_ID,
                  NVL(B.PROD_ATTR_VALUE_ID, 0) PROD_ATTR_VALUE_ID,
                  NVL(C.LOC_ATTR_VALUE_ID, 0) LOC_ATTR_VALUE_ID,
                  NVL(A.MIN_QTY, 0) MIN_QTY,
                  NVL(A.MAX_QTY, 0) MAX_QTY
             FROM MIN_MAX@MYLINKAPP A
             LEFT JOIN DIM_PROD_ATTR_VALUE B
               ON B.PROD_ATTR_ID = :PROD_ATTR_ID'||CHR(10)||GET_ATTR_JOIN_CLAUSE('A','B','PROD_ATTR_VALUE','PROD_ATTR_VALUE',L_CACHE_PROD_ATTR_BK(P_PROD_ATTR_ID))||CHR(10)||
             'LEFT JOIN DIM_LOC_ATTR_VALUE C
                ON C.LOC_ATTR_ID = :TO_LOC_ATTR_ID'||CHR(10)||GET_ATTR_JOIN_CLAUSE('A','C','LOC_ATTR','LOC_ATTR_VALUE', L_CACHE_LOC_ATTR_BK(P_LOC_ATTR_ID))||CHR(10)||
             'WHERE A.STYLE_COLOR_ID IS NULL
            AND A.BASE_UNITS_ID=:BASE_UNITS_ID) S
    ON (T.MIN_MAX_ID = S.MIN_MAX_ID AND T.PROD_ATTR_VALUE_ID = S.PROD_ATTR_VALUE_ID AND T.LOC_ATTR_VALUE_ID = S.LOC_ATTR_VALUE_ID)
    WHEN MATCHED THEN
      UPDATE
         SET T.MIN_QTY = S.MIN_QTY,
             T.MAX_QTY = S.MAX_QTY
    WHEN NOT MATCHED THEN
      INSERT
        (T.MIN_MAX_ID,
         T.PROD_ATTR_VALUE_ID,
         T.LOC_ATTR_VALUE_ID,
         T.MIN_QTY,
         T.MAX_QTY)
      VALUES
        (S.MIN_MAX_ID,
         S.PROD_ATTR_VALUE_ID,
         S.LOC_ATTR_VALUE_ID,
         S.MIN_QTY,
         S.MAX_QTY);

    MERGE INTO FACT_MIN_MAX_SC_LOC T
    USING (SELECT :MIN_MAX_ID MIN_MAX_ID,
                  NVL(B.STYLE_COLOR_ID, 0) STYLE_COLOR_ID,
                  NVL(C.LOC_ATTR_VALUE_ID, 0) LOC_ATTR_VALUE_ID,
                  NVL(A.MIN_QTY, 0) MIN_QTY,
                  NVL(A.MAX_QTY, 0) MAX_QTY
             FROM MIN_MAX@MYLINKAPP A
             LEFT JOIN DIM_STYLE_COLOR B
             ON B.ORI_STYLE_COLOR_ID=A.STYLE_COLOR_ID'||CHR(10)||
             'LEFT JOIN DIM_LOC_ATTR_VALUE C
                ON C.LOC_ATTR_ID = :TO_LOC_ATTR_ID'||CHR(10)||GET_ATTR_JOIN_CLAUSE('A','C','LOC_ATTR','LOC_ATTR_VALUE', L_CACHE_LOC_ATTR_BK(P_LOC_ATTR_ID))||CHR(10)||
            'WHERE A.STYLE_COLOR_ID IS NOT NULL
            AND A.BASE_UNITS_ID=:BASE_UNITS_ID) S
    ON (T.MIN_MAX_ID = S.MIN_MAX_ID AND T.STYLE_COLOR_ID = S.STYLE_COLOR_ID AND T.LOC_ATTR_VALUE_ID = S.LOC_ATTR_VALUE_ID)
    WHEN MATCHED THEN
      UPDATE
         SET T.MIN_QTY = S.MIN_QTY,
             T.MAX_QTY = S.MAX_QTY
    WHEN NOT MATCHED THEN
      INSERT
        (T.MIN_MAX_ID,
         T.STYLE_COLOR_ID,
         T.LOC_ATTR_VALUE_ID,
         T.MIN_QTY,
         T.MAX_QTY)
      VALUES
        (S.MIN_MAX_ID,
         S.STYLE_COLOR_ID,
         S.LOC_ATTR_VALUE_ID,
         S.MIN_QTY,
         S.MAX_QTY);
         END;';

    DBMS_OUTPUT.PUT_LINE(L_SQL);

    EXECUTE IMMEDIATE L_SQL USING P_MIN_MAX_ID,P_PROD_ATTR_ID,P_LOC_ATTR_ID, P_BASE_UNITS_ID;

    COMMIT;

  END POP_MIN_MAX;


BEGIN

  SELECT S.PROD_ATTR_ID ATTR_ID, S.TARGET_BUSKEY_HASH_STR
    BULK COLLECT
    INTO L_TEMP_CACHE
    FROM DIM_PROD_ATTR S;

  FOR J IN L_TEMP_CACHE.FIRST .. L_TEMP_CACHE.LAST LOOP
    L_CACHE_PROD_ATTR_BK(L_TEMP_CACHE(J).ATTR_ID) := L_TEMP_CACHE(J).TARGET_BUSKEY_HASH_STR;
  END LOOP;

  SELECT S.LOC_ATTR_ID ATTR_ID, S.TARGET_BUSKEY_HASH_STR
    BULK COLLECT
    INTO L_TEMP_CACHE
    FROM DIM_LOC_ATTR S;

  FOR J IN L_TEMP_CACHE.FIRST .. L_TEMP_CACHE.LAST LOOP
    L_CACHE_LOC_ATTR_BK(L_TEMP_CACHE(J).ATTR_ID) := L_TEMP_CACHE(J).TARGET_BUSKEY_HASH_STR;
  END LOOP;

END MISC_POPULATE_PACK;
/
