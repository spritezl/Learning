CREATE OR REPLACE PACKAGE META_POPULATE_PACK IS

  -- AUTHOR  : FZHANG
  -- CREATED : 3/28/2016 13:58:43 13:58:43
  -- PURPOSE : METADATA POUPULATE PACKAGE
  PROCEDURE POP_DIMS;
  PROCEDURE POP_DIM_LEVELS;
  PROCEDURE POP_DIM_LEVEL_ATTRS;
  PROCEDURE POP_DIM_HIERARCHIES;
  PROCEDURE POP_DIM_HIER_LEVELS;
  PROCEDURE POP_DIM_HIER_LEVEL_ATTRS;
  PROCEDURE POP_DIM_LEVEL_ATTR_MAPPING;

  PROCEDURE POP_FACTS;
  PROCEDURE POP_FACT_MEASUREMENTS;
  PROCEDURE POP_FACT_DIM_RELATIONS;

  --PLEASE NOTE, THIS PROCEDURE IS ONLY USED FOR APPLYING LOC HIERARCHY SETUP
  PROCEDURE POP_META_FOR_LOC_SETUP;

END META_POPULATE_PACK;
/
CREATE OR REPLACE PACKAGE BODY META_POPULATE_PACK IS

  TYPE BUS_DESC_CACHE IS TABLE OF VARCHAR2(60) INDEX BY VARCHAR2(60);
  L_BUS_DESC_CACHE BUS_DESC_CACHE;

  C_DUMMY CONSTANT VARCHAR2(10) := 'DUMMY';

  TYPE REC_KEY_VAL IS RECORD(
    KEY VARCHAR2(60),
    VAL VARCHAR2(60));
  TYPE KEY_VAL_CACHE IS TABLE OF REC_KEY_VAL;
  L_KEY_VAL_CACHE KEY_VAL_CACHE := KEY_VAL_CACHE();
  L_REC_KEY_VAL   REC_KEY_VAL;

  C_DELIMITER CONSTANT CHAR := '.';

  PROCEDURE POP_DIMS IS
  BEGIN
  
    EXECUTE IMMEDIATE 'TRUNCATE TABLE META_DIMS';
  
    INSERT INTO META_DIMS
      (DIM_NAME, BUSINESS_DESC)
      SELECT 'DATE' DIM_NAME, 'DATE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME, 'STYLE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME, 'STORE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME, 'YEAR_SEASON' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER' DIM_NAME, 'TRANSFER' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME, 'PROMOTION' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'COMMON' DIM_NAME, 'COMMON' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME, 'PO ALLOCATE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME, 'ASN ALLOCATE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'RECEIVER ALLOCATE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'ALLOCATION_REFERENCE' DIM_NAME,
             'ALLOCATION_REFERENCE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'CRITERIA_GROUP' DIM_NAME, 'CRITERIA_GROUP' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_MATRIX' DIM_NAME, 'TRANSFER_MATRIX' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_PRIORITY' DIM_NAME,
             'TRANSFER_PRIORITY' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RULE' DIM_NAME, 'TRANSFER_RULE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'AUDIT' DIM_NAME, 'AUDIT' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'SPREAD_DC' DIM_NAME, 'SPREAD_DC' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_FORECAST' DIM_NAME,
             'TRANSFER_FORECAST' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'BOXSTYLE' DIM_NAME, 'BOXSTYLE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'CORE_SIZE' DIM_NAME, 'CORE_SIZE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_SCOPE' DIM_NAME, 'PROMOTION_SCOPE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'MIN_MAX' DIM_NAME, 'MIN_MAX' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'CLUSTER_SEQUENCE' DIM_NAME, 'CLUSTER_SEQUENCE' BUSINESS_DESC
        FROM DUAL;
  
    COMMIT;
  END POP_DIMS;

  PROCEDURE POP_DIM_LEVELS IS
  BEGIN
  
    EXECUTE IMMEDIATE 'TRUNCATE TABLE META_DIM_LEVELS';
    INSERT INTO META_DIM_LEVELS
      (DIM_NAME,
       LEVEL_NAME,
       DB_TAB_NAME,
       DB_KEY_COL_NAME,
       BUSINESS_DESC,
       ETL_SOURCE)
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'DIM_DATE_CYEAR' DB_TAB_NAME,
             'CYEAR_ID' DB_KEY_COL_NAME,
             'CALENDAR_YEAR' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YEAR' LEVEL_NAME,
             'DIM_DATE_IYEAR' DB_TAB_NAME,
             'IYEAR_ID' DB_KEY_COL_NAME,
             'ISO_YEAR' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'DIM_DATE_CMONTH' DB_TAB_NAME,
             'CMONTH_ID' DB_KEY_COL_NAME,
             'CALENDAR_CMONTH' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             'DIM_DATE_CWEEK' DB_TAB_NAME,
             'CWEEK_ID' DB_KEY_COL_NAME,
             'CALENDAR_WEEK' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_WEEK' LEVEL_NAME,
             'DIM_DATE_IWEEK' DB_TAB_NAME,
             'IWEEK_ID' DB_KEY_COL_NAME,
             'ISO_WEEK' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'DAY' LEVEL_NAME,
             'DIM_DATE_DAY' DB_TAB_NAME,
             'DATE_ID' DB_KEY_COL_NAME,
             'DAY' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'DIM_DATE_SWEEK' DB_TAB_NAME,
             'SWEEK_ID' DB_KEY_COL_NAME,
             '7TH_WEEK' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'DIM_DATE_SMONTH' DB_TAB_NAME,
             'SMONTH_ID' DB_KEY_COL_NAME,
             '7TH_MONTH' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_WYEAR' LEVEL_NAME,
             'DIM_DATE_SWYEAR' DB_TAB_NAME,
             'SWYEAR_ID' DB_KEY_COL_NAME,
             '7TH_WYEAR' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_MYEAR' LEVEL_NAME,
             'DIM_DATE_SMYEAR' DB_TAB_NAME,
             'SMYEAR_ID' DB_KEY_COL_NAME,
             '7TH_MYEAR' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'DIM_DATE_SWEEK_PART' DB_TAB_NAME,
             'SWEEK_PART_ID' DB_KEY_COL_NAME,
             '7TH_WEEK_PART' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'DEPT' LEVEL_NAME,
             'DIM_DEPT' DB_TAB_NAME,
             'DEPT_ID' DB_KEY_COL_NAME,
             'DEPT' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'VENDOR' LEVEL_NAME,
             'DIM_VENDOR' DB_TAB_NAME,
             'VENDOR_ID' DB_KEY_COL_NAME,
             'VENDOR' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'DIM_STYLE' DB_TAB_NAME,
             'STYLE_ID' DB_KEY_COL_NAME,
             'STYLE' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'DIM_STYLE_COLOR' DB_TAB_NAME,
             'STYLE_COLOR_ID' DB_KEY_COL_NAME,
             'STYLE_COLOR' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'DIM_STYLE_COLOR_SIZE' DB_TAB_NAME,
             'STYLE_COLOR_SIZE_ID' DB_KEY_COL_NAME,
             'STYLE_COLOR_SIZE' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'DIM_STYLE_COLOR_SIZE_GP' DB_TAB_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_GP' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'GP' LEVEL_NAME,
             'DIM_GP_GP' DB_TAB_NAME,
             'GP_GP_ID' DB_KEY_COL_NAME,
             'GP_GP' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'GP_SIZE' LEVEL_NAME,
             'DIM_GP_SIZE' DB_TAB_NAME,
             'GP_SIZE_ID' DB_KEY_COL_NAME,
             'GP_SIZE' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SIZE_RANGE' LEVEL_NAME,
             'DIM_SIZE_RANGE' DB_TAB_NAME,
             'SIZE_RANGE_ID' DB_KEY_COL_NAME,
             'SIZE_RANGE' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SIZE_ITEM' LEVEL_NAME,
             'DIM_SIZE_ITEM' DB_TAB_NAME,
             'SIZE_ITEM_ID' DB_KEY_COL_NAME,
             'SIZE_ITEM' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'STORE_ID' DB_KEY_COL_NAME,
             'STORE_DETAIL' BUSINESS_DESC,
             'COMPANY_DOOR@MYLINKAPP' ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'DIM_YEAR_SEASON' DB_TAB_NAME,
             'YEAR_SEASON_ID' DB_KEY_COL_NAME,
             'YEAR_SEASON' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'REAL_YEAR_SEASON' LEVEL_NAME,
             'DIM_YEAR_SEASON' DB_TAB_NAME,
             'YEAR_SEASON_ID' DB_KEY_COL_NAME,
             'YEAR_SEASON' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'STYLE_YEAR_SEASON' LEVEL_NAME,
             'DIM_STYLE_YEAR_SEASON' DB_TAB_NAME,
             'STYLE_YEAR_SEASON_ID' DB_KEY_COL_NAME,
             'STYLE_YEAR_SEASON' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'COUNTRY' LEVEL_NAME,
             'DIM_STORE_LOC' DB_TAB_NAME,
             'STORE_LOC_ID' DB_KEY_COL_NAME,
             'COUNTRY' BUSINESS_DESC,
             'COMPANY_DOOR@MYLINKAPP' ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'DIM_STORE_LOC' DB_TAB_NAME,
             'STORE_LOC_ID' DB_KEY_COL_NAME,
             'DC' BUSINESS_DESC,
             'COMPANY_DOOR@MYLINKAPP' ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'DIM_STORE_LOC' DB_TAB_NAME,
             'STORE_LOC_ID' DB_KEY_COL_NAME,
             'STOCK_CATEGORY' BUSINESS_DESC,
             'COMPANY_DOOR@MYLINKAPP' ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE' LEVEL_NAME,
             'DIM_STORE_LOC' DB_TAB_NAME,
             'STORE_LOC_ID' DB_KEY_COL_NAME,
             'STORE' BUSINESS_DESC,
             'COMPANY_DOOR@MYLINKAPP' ETL_SOURCE
        FROM DUAL
      
      UNION ALL
      SELECT 'TRANSFER' DIM_NAME,
             'TRANSFER' LEVEL_NAME,
             'DIM_TRANSFER_TRANSFER' DB_TAB_NAME,
             'TRANSFER_TRANSFER_ID' DB_KEY_COL_NAME,
             'TRANSFER' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'DIM_TRANSFER_RELEASE' DB_TAB_NAME,
             'TRANSFER_RELEASE_ID' DB_KEY_COL_NAME,
             'TRANSFER_RELEASE' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'SALES_STYLE' LEVEL_NAME,
             'DIM_SALES_STYLE' DB_TAB_NAME,
             'SALES_STYLE_ID' DB_KEY_COL_NAME,
             'SALES_STYLE' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PROMOTION' LEVEL_NAME,
             'DIM_PROMOTION' DB_TAB_NAME,
             'PROMOTION_ID' DB_KEY_COL_NAME,
             'PROMOTION' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'DIM_PROD_ATTR' DB_TAB_NAME,
             'PROD_ATTR_ID' DB_KEY_COL_NAME,
             'PROD_ATTR' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'DIM_PROD_ATTR_VALUE' DB_TAB_NAME,
             'PROD_ATTR_VALUE_ID' DB_KEY_COL_NAME,
             'PROD_ATTR_VALUE' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'DIM_LOC_ATTR' DB_TAB_NAME,
             'LOC_ATTR_ID' DB_KEY_COL_NAME,
             'LOC_ATTR' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'DIM_LOC_ATTR_VALUE' DB_TAB_NAME,
             'LOC_ATTR_VALUE_ID' DB_KEY_COL_NAME,
             'LOC_ATTR_VALUE' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'DIM_COMMON' DB_TAB_NAME,
             'COMMON_ID' DB_KEY_COL_NAME,
             'COMMON' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'DIM_PO_BD' DB_TAB_NAME,
             'PO_BD_ID' DB_KEY_COL_NAME,
             'PO BREAKDOWN' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'DIM_PO_BD_RELEASE' DB_TAB_NAME,
             'PO_BD_RELEASE_ID' DB_KEY_COL_NAME,
             'PO BREAKDOWN RELEASE' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'DIM_PO_ALLOCATE' DB_TAB_NAME,
             'PO_ALLOCATE_ID' DB_KEY_COL_NAME,
             'PO ALLOCATE' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'DIM_PO_RELEASE' DB_TAB_NAME,
             'PO_RELEASE_ID' DB_KEY_COL_NAME,
             'PO RELEASE' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'DIM_ASN_BD' DB_TAB_NAME,
             'ASN_BD_ID' DB_KEY_COL_NAME,
             'ASN BREAKDOWN' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'DIM_ASN_BD_RELEASE' DB_TAB_NAME,
             'ASN_BD_RELEASE_ID' DB_KEY_COL_NAME,
             'ASN BREAKDOWN RELEASE' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'DIM_ASN_ALLOCATE' DB_TAB_NAME,
             'ASN_ALLOCATE_ID' DB_KEY_COL_NAME,
             'ASN ALLOCATE' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'DIM_ASN_RELEASE' DB_TAB_NAME,
             'ASN_RELEASE_ID' DB_KEY_COL_NAME,
             'ASN RELEASE' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'DIM_RECEIVER_BD' DB_TAB_NAME,
             'RECEIVER_BD_ID' DB_KEY_COL_NAME,
             'RECEIVER BREAKDOWN' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'DIM_RECEIVER_BD_RELEASE' DB_TAB_NAME,
             'RECEIVER_BD_RELEASE_ID' DB_KEY_COL_NAME,
             'RECEIVER BREAKDOWN RELEASE' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'DIM_RECEIVER_ALLOCATE' DB_TAB_NAME,
             'RECEIVER_ALLOCATE_ID' DB_KEY_COL_NAME,
             'RECEIVER ALLOCATE' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'DIM_RECEIVER_RELEASE' DB_TAB_NAME,
             'RECEIVER_RELEASE_ID' DB_KEY_COL_NAME,
             'RECEIVER RELEASE' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'ALLOCATION_REFERENCE' DIM_NAME,
             'ALLOCATION_REFERENCE' LEVEL_NAME,
             'DIM_ALLOCATION_REFERENCE' DB_TAB_NAME,
             'ALLOCATION_REFERENCE_ID' DB_KEY_COL_NAME,
             'ALLOCATION_REFERENCE' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'CRITERIA_GROUP' DIM_NAME,
             'CRITERIA_GROUP' LEVEL_NAME,
             'DIM_CRITERIA_GROUP' DB_TAB_NAME,
             'CRITERIA_GROUP_ID' DB_KEY_COL_NAME,
             'CRITERIA_GROUP' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_MATRIX' DIM_NAME,
             'TRANSFER_MATRIX' LEVEL_NAME,
             'DIM_TRANSFER_MATRIX' DB_TAB_NAME,
             'TRANSFER_MATRIX_ID' DB_KEY_COL_NAME,
             'TRANSFER_MATRIX' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_PRIORITY' DIM_NAME,
             'TRANSFER_PRIORITY' LEVEL_NAME,
             'DIM_TRANSFER_PRIORITY' DB_TAB_NAME,
             'TRANSFER_PRIORITY_ID' DB_KEY_COL_NAME,
             'TRANSFER_PRIORITY' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_FORECAST' DIM_NAME,
             'TRANSFER_FORECAST' LEVEL_NAME,
             'DIM_TRANSFER_FORECAST' DB_TAB_NAME,
             'TRANSFER_FORECAST_ID' DB_KEY_COL_NAME,
             'TRANSFER_FORECAST' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RULE' DIM_NAME,
             'TRANSFER_RULE' LEVEL_NAME,
             'DIM_RULE' DB_TAB_NAME,
             'RULE_ID' DB_KEY_COL_NAME,
             'TRANSFER_RULE' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'AUDIT' DIM_NAME,
             'AUDIT' LEVEL_NAME,
             'DIM_AUDIT' DB_TAB_NAME,
             'AUDIT_ID' DB_KEY_COL_NAME,
             'AUDIT' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'SPREAD_DC' DIM_NAME,
             'SPREAD_DC' LEVEL_NAME,
             'DIM_TRANSFER_SPREAD_DC' DB_TAB_NAME,
             'TRANSFER_SPREAD_DC_ID' DB_KEY_COL_NAME,
             'TRANSFER_SPREAD_DC' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'BOXSTYLE' DIM_NAME,
             'BOXSTYLE' LEVEL_NAME,
             'DIM_BOXSTYLE' DB_TAB_NAME,
             'BOXSTYLE_ID' DB_KEY_COL_NAME,
             'BOXSTYLE' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'CORE_SIZE' DIM_NAME,
             'CORE_SIZE' LEVEL_NAME,
             'DIM_CORE_SIZE' DB_TAB_NAME,
             'CORE_SIZE_ID' DB_KEY_COL_NAME,
             'CORE_SIZE' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_SCOPE' DIM_NAME,
             'PROMOTION_SCOPE' LEVEL_NAME,
             'DIM_PROMOTION_SCOPE' DB_TAB_NAME,
             'PROMOTION_SCOPE_ID' DB_KEY_COL_NAME,
             'PROMOTION_SCOPE' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'MIN_MAX' DIM_NAME,
             'MIN_MAX' LEVEL_NAME,
             'DIM_MIN_MAX' DB_TAB_NAME,
             'MIN_MAX_ID' DB_KEY_COL_NAME,
             'MIN_MAX' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL
      UNION ALL
      SELECT 'CLUSTER_SEQUENCE' DIM_NAME,
             'CLUSTER_SEQUENCE' LEVEL_NAME,
             'DIM_CLUSTER_SEQUENCE' DB_TAB_NAME,
             'CLUSTER_SEQUENCE_ID' DB_KEY_COL_NAME,
             'CLUSTER_SEQUENCE' BUSINESS_DESC,
             C_DUMMY ETL_SOURCE
        FROM DUAL;
  
    COMMIT;
  END POP_DIM_LEVELS;

  PROCEDURE POP_DIM_LEVEL_ATTRS IS
  BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE META_DIM_LEVEL_ATTRS';
  
    --DATE
    INSERT INTO META_DIM_LEVEL_ATTRS
      (DIM_NAME,
       LEVEL_NAME,
       ATTR_NAME,
       DB_COL_NAME,
       BUSINESS_DESC,
       VISABLE)
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'CYEAR_ID' ATTR_NAME,
             'CYEAR_ID' DB_COL_NAME,
             'CYEAR_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'CYEAR_DESC' ATTR_NAME,
             'CYEAR_DESC' DB_COL_NAME,
             'CYEAR_DESC' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'START_DATE' ATTR_NAME,
             'START_DATE' DB_COL_NAME,
             'START_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'END_DATE' ATTR_NAME,
             'END_DATE' DB_COL_NAME,
             'END_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'TIME_SPAN' ATTR_NAME,
             'TIME_SPAN' DB_COL_NAME,
             'TIME_SPAN' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'CYEAR_NUM' ATTR_NAME,
             'CYEAR_NUM' DB_COL_NAME,
             'CYEAR_NUM' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'DATE' DIM_NAME,
             'ISO_YEAR' LEVEL_NAME,
             'IYEAR_ID' ATTR_NAME,
             'IYEAR_ID' DB_COL_NAME,
             'IYEAR_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YEAR' LEVEL_NAME,
             'IYEAR_DESC' ATTR_NAME,
             'IYEAR_DESC' DB_COL_NAME,
             'IYEAR_DESC' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YEAR' LEVEL_NAME,
             'START_DATE' ATTR_NAME,
             'START_DATE' DB_COL_NAME,
             'START_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YEAR' LEVEL_NAME,
             'END_DATE' ATTR_NAME,
             'END_DATE' DB_COL_NAME,
             'END_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YEAR' LEVEL_NAME,
             'TIME_SPAN' ATTR_NAME,
             'TIME_SPAN' DB_COL_NAME,
             'TIME_SPAN' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YEAR' LEVEL_NAME,
             'IYEAR_NUM' ATTR_NAME,
             'IYEAR_NUM' DB_COL_NAME,
             'IYEAR_NUM' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'MONTH_ID' ATTR_NAME,
             'MONTH_ID' DB_COL_NAME,
             'MONTH_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'MONTH_DESC' ATTR_NAME,
             'MONTH_DESC' DB_COL_NAME,
             'MONTH_DESC' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'CYEAR_ID' ATTR_NAME,
             'CYEAR_ID' DB_COL_NAME,
             'CYEAR_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'MONTH_OF_CYEAR' ATTR_NAME,
             'MONTH_OF_CYEAR' DB_COL_NAME,
             'MONTH_OF_CYEAR' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'MONTH_NAME' ATTR_NAME,
             'MONTH_NAME' DB_COL_NAME,
             'MONTH_NAME' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'START_DATE' ATTR_NAME,
             'START_DATE' DB_COL_NAME,
             'START_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'END_DATE' ATTR_NAME,
             'END_DATE' DB_COL_NAME,
             'END_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'TIME_SPAN' ATTR_NAME,
             'TIME_SPAN' DB_COL_NAME,
             'TIME_SPAN' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'MONTH_NUM' ATTR_NAME,
             'MONTH_NUM' DB_COL_NAME,
             'MONTH_NUM' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             'CWEEK_ID' ATTR_NAME,
             'CWEEK_ID' DB_COL_NAME,
             'CWEEK_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             'CWEEK_DESC' ATTR_NAME,
             'CWEEK_DESC' DB_COL_NAME,
             'CWEEK_DESC' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             'CYEAR_ID' ATTR_NAME,
             'CYEAR_ID' DB_COL_NAME,
             'CYEAR_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             'CWEEK_OF_CYEAR' ATTR_NAME,
             'CWEEK_OF_CYEAR' DB_COL_NAME,
             'CWEEK_OF_CYEAR' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             'START_DATE' ATTR_NAME,
             'START_DATE' DB_COL_NAME,
             'START_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             'END_DATE' ATTR_NAME,
             'END_DATE' DB_COL_NAME,
             'END_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             'TIME_SPAN' ATTR_NAME,
             'TIME_SPAN' DB_COL_NAME,
             'TIME_SPAN' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             'CWEEK_NUM' ATTR_NAME,
             'CWEEK_NUM' DB_COL_NAME,
             'CWEEK_NUM' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'DATE' DIM_NAME,
             'ISO_WEEK' LEVEL_NAME,
             'IWEEK_ID' ATTR_NAME,
             'IWEEK_ID' DB_COL_NAME,
             'IWEEK_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_WEEK' LEVEL_NAME,
             'IWEEK_DESC' ATTR_NAME,
             'IWEEK_DESC' DB_COL_NAME,
             'IWEEK_DESC' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_WEEK' LEVEL_NAME,
             'IWEEK_OF_IYEAR' ATTR_NAME,
             'IWEEK_OF_IYEAR' DB_COL_NAME,
             'IWEEK_OF_IYEAR' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_WEEK' LEVEL_NAME,
             'IYEAR_ID' ATTR_NAME,
             'IYEAR_ID' DB_COL_NAME,
             'IYEAR_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_WEEK' LEVEL_NAME,
             'START_DATE' ATTR_NAME,
             'START_DATE' DB_COL_NAME,
             'START_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_WEEK' LEVEL_NAME,
             'END_DATE' ATTR_NAME,
             'END_DATE' DB_COL_NAME,
             'END_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_WEEK' LEVEL_NAME,
             'TIME_SPAN' ATTR_NAME,
             'TIME_SPAN' DB_COL_NAME,
             'TIME_SPAN' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_WEEK' LEVEL_NAME,
             'IWEEK_NUM' ATTR_NAME,
             'IWEEK_NUM' DB_COL_NAME,
             'IWEEK_NUM' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'DAY' LEVEL_NAME,
             'DATE_ID' ATTR_NAME,
             'DATE_ID' DB_COL_NAME,
             'DATE_ID' BUSINESS_DESC,
             'N'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'DAY' LEVEL_NAME,
             'DAY_DATE' ATTR_NAME,
             'DAY_DATE' DB_COL_NAME,
             'DAY_DATE' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'DAY' LEVEL_NAME,
             'DAY_DESC' ATTR_NAME,
             'DAY_DESC' DB_COL_NAME,
             'DAY_DESC' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'DAY' LEVEL_NAME,
             'CWEEK_ID' ATTR_NAME,
             'CWEEK_ID' DB_COL_NAME,
             'CWEEK_ID' BUSINESS_DESC,
             'N'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'DAY' LEVEL_NAME,
             'IWEEK_ID' ATTR_NAME,
             'IWEEK_ID' DB_COL_NAME,
             'IWEEK_ID' BUSINESS_DESC,
             'N'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'DAY' LEVEL_NAME,
             'MONTH_ID' ATTR_NAME,
             'MONTH_ID' DB_COL_NAME,
             'MONTH_ID' BUSINESS_DESC,
             'N'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_CWEEK' ATTR_NAME,
             'DAY_OF_CWEEK' DB_COL_NAME,
             'DAY_OF_CWEEK' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_IWEEK' ATTR_NAME,
             'DAY_OF_IWEEK' DB_COL_NAME,
             'DAY_OF_IWEEK' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_MONTH' ATTR_NAME,
             'DAY_OF_MONTH' DB_COL_NAME,
             'DAY_OF_MONTH' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_CYEAR' ATTR_NAME,
             'DAY_OF_CYEAR' DB_COL_NAME,
             'DAY_OF_CYEAR' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_IYEAR' ATTR_NAME,
             'DAY_OF_IYEAR' DB_COL_NAME,
             'DAY_OF_IYEAR' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'DAY' LEVEL_NAME,
             'START_DATE' ATTR_NAME,
             'START_DATE' DB_COL_NAME,
             'START_DATE' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'DAY' LEVEL_NAME,
             'END_DATE' ATTR_NAME,
             'END_DATE' DB_COL_NAME,
             'END_DATE' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'DAY' LEVEL_NAME,
             'TIME_SPAN' ATTR_NAME,
             'TIME_SPAN' DB_COL_NAME,
             'TIME_SPAN' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'DAY' LEVEL_NAME,
             'DAY_NUM' ATTR_NAME,
             'DAY_NUM' DB_COL_NAME,
             'DAY_NUM' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'DAY' LEVEL_NAME,
             'SWEEK_ID' ATTR_NAME,
             'SWEEK_ID' DB_COL_NAME,
             'SWEEK_ID' BUSINESS_DESC,
             'N'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_SWEEK' ATTR_NAME,
             'DAY_OF_SWEEK' DB_COL_NAME,
             'DAY_OF_SWEEK' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_SMONTH' ATTR_NAME,
             'DAY_OF_SMONTH' DB_COL_NAME,
             'DAY_OF_SMONTH' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_SYEAR' ATTR_NAME,
             'DAY_OF_SYEAR' DB_COL_NAME,
             'DAY_OF_SYEAR' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SWEEK_ID' ATTR_NAME,
             'SWEEK_ID' DB_COL_NAME,
             'SWEEK_ID' BUSINESS_DESC,
             'N'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SWEEK_DESC' ATTR_NAME,
             'SWEEK_DESC' DB_COL_NAME,
             'SWEEK_DESC' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SMONTH_ID' ATTR_NAME,
             'SMONTH_ID' DB_COL_NAME,
             'SMONTH_ID' BUSINESS_DESC,
             'N'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SWEEK_OF_SMONTH' ATTR_NAME,
             'SWEEK_OF_SMONTH' DB_COL_NAME,
             'SWEEK_OF_SMONTH' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SWEEK_OF_SYEAR' ATTR_NAME,
             'SWEEK_OF_SYEAR' DB_COL_NAME,
             'SWEEK_OF_SYEAR' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'START_DATE' ATTR_NAME,
             'START_DATE' DB_COL_NAME,
             'START_DATE' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'END_DATE' ATTR_NAME,
             'END_DATE' DB_COL_NAME,
             'END_DATE' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'TIME_SPAN' ATTR_NAME,
             'TIME_SPAN' DB_COL_NAME,
             'TIME_SPAN' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SWEEK_NUM' ATTR_NAME,
             'SWEEK_NUM' DB_COL_NAME,
             'SWEEK_NUM' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SMONTH_ID' ATTR_NAME,
             'SMONTH_ID' DB_COL_NAME,
             'SMONTH_ID' BUSINESS_DESC,
             'N'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SMONTH_DESC' ATTR_NAME,
             'SMONTH_DESC' DB_COL_NAME,
             'SMONTH_DESC' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SYEAR_ID' ATTR_NAME,
             'SYEAR_ID' DB_COL_NAME,
             'SYEAR_ID' BUSINESS_DESC,
             'N'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SMONTH_OF_SYEAR' ATTR_NAME,
             'SMONTH_OF_SYEAR' DB_COL_NAME,
             'SMONTH_OF_SYEAR' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SMONTH_NAME' ATTR_NAME,
             'SMONTH_NAME' DB_COL_NAME,
             'SMONTH_NAME' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'START_DATE' ATTR_NAME,
             'START_DATE' DB_COL_NAME,
             'START_DATE' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'END_DATE' ATTR_NAME,
             'END_DATE' DB_COL_NAME,
             'END_DATE' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'TIME_SPAN' ATTR_NAME,
             'TIME_SPAN' DB_COL_NAME,
             'TIME_SPAN' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SMONTH_NUM' ATTR_NAME,
             'SMONTH_NUM' DB_COL_NAME,
             'SMONTH_NUM' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YEAR' LEVEL_NAME,
             'SYEAR_ID' ATTR_NAME,
             'SYEAR_ID' DB_COL_NAME,
             'SYEAR_ID' BUSINESS_DESC,
             'N'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YEAR' LEVEL_NAME,
             'SYEAR_DESC' ATTR_NAME,
             'SYEAR_DESC' DB_COL_NAME,
             'SYEAR_DESC' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YEAR' LEVEL_NAME,
             'START_DATE' ATTR_NAME,
             'START_DATE' DB_COL_NAME,
             'START_DATE' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YEAR' LEVEL_NAME,
             'END_DATE' ATTR_NAME,
             'END_DATE' DB_COL_NAME,
             'END_DATE' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YEAR' LEVEL_NAME,
             'TIME_SPAN' ATTR_NAME,
             'TIME_SPAN' DB_COL_NAME,
             'TIME_SPAN' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YEAR' LEVEL_NAME,
             'SYEAR_NUM' ATTR_NAME,
             'SYEAR_NUM' DB_COL_NAME,
             'SYEAR_NUM' BUSINESS_DESC,
             'Y'
        FROM DUAL;
  
    --STYLE
    INSERT INTO META_DIM_LEVEL_ATTRS
      (DIM_NAME,
       LEVEL_NAME,
       ATTR_NAME,
       DB_COL_NAME,
       BUSINESS_DESC,
       VISABLE)
      SELECT 'STYLE' DIM_NAME,
             'DEPT' LEVEL_NAME,
             'DEPT_ID' ATTR_NAME,
             'DEPT_ID' DB_COL_NAME,
             'DEPT_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'DEPT' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'DEPT' LEVEL_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'TARGET_BUSKEY' DB_COL_NAME,
             'TARGET_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'DEPT' LEVEL_NAME,
             'DEPT_NUM' ATTR_NAME,
             'DEPT_NUM' DB_COL_NAME,
             'DEPT_NUM' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'DEPT' LEVEL_NAME,
             'DEPT' ATTR_NAME,
             'DEPT' DB_COL_NAME,
             'DEPT' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'DEPT' LEVEL_NAME,
             'DIVISION' ATTR_NAME,
             'DIVISION' DB_COL_NAME,
             'DIVISION' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'DEPT' LEVEL_NAME,
             'CORPORATE_DIVISION' ATTR_NAME,
             'CORPORATE_DIVISION' DB_COL_NAME,
             'CORPORATE_DIVISION' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'DEPT' LEVEL_NAME,
             'ORI_DEPT_ID' ATTR_NAME,
             'ORI_DEPT_ID' DB_COL_NAME,
             'ORI_DEPT_ID' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'VENDOR' LEVEL_NAME,
             'VENDOR_ID' ATTR_NAME,
             'VENDOR_ID' DB_COL_NAME,
             'VENDOR_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'VENDOR' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'VENDOR' LEVEL_NAME,
             'NAME' ATTR_NAME,
             'NAME' DB_COL_NAME,
             'NAME' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'VENDOR' LEVEL_NAME,
             'VENDOR_DIVISION' ATTR_NAME,
             'VENDOR_DIVISION' DB_COL_NAME,
             'VENDOR_DIVISION' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'VENDOR' LEVEL_NAME,
             'VENDOR_DEPT' ATTR_NAME,
             'VENDOR_DEPT' DB_COL_NAME,
             'VENDOR_DEPT' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'VENDOR' LEVEL_NAME,
             'VENDOR_PRODUCT_CATEGORY' ATTR_NAME,
             'VENDOR_PRODUCT_CATEGORY' DB_COL_NAME,
             'VENDOR_PRODUCT_CATEGORY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'VENDOR' LEVEL_NAME,
             'ORI_MIC_ID' ATTR_NAME,
             'ORI_MIC_ID' DB_COL_NAME,
             'ORI_MIC_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'VENDOR' LEVEL_NAME,
             'MIC_CODE' ATTR_NAME,
             'MIC_CODE' DB_COL_NAME,
             'MIC_CODE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'VENDOR' LEVEL_NAME,
             'MIC_DESC' ATTR_NAME,
             'MIC_DESC' DB_COL_NAME,
             'MIC_DESC' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'VENDOR' LEVEL_NAME,
             'PO_DIRECTION' ATTR_NAME,
             'PO_DIRECTION' DB_COL_NAME,
             'PO_DIRECTION' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'VENDOR' LEVEL_NAME,
             'VENDOR_REF_NUMBER' ATTR_NAME,
             'VENDOR_REF_NUMBER' DB_COL_NAME,
             'VENDOR_REF_NUMBER' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'VENDOR' LEVEL_NAME,
             'ORI_VENDOR_COMPANY_ID' ATTR_NAME,
             'ORI_VENDOR_COMPANY_ID' DB_COL_NAME,
             'ORI_VENDOR_COMPANY_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'VENDOR' LEVEL_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'TARGET_BUSKEY' DB_COL_NAME,
             'TARGET_BUSKEY' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'STYLE_ID' ATTR_NAME,
             'STYLE_ID' DB_COL_NAME,
             'STYLE_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'TARGET_BUSKEY' DB_COL_NAME,
             'TARGET_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'STYLE_NUMBER' ATTR_NAME,
             'STYLE_NUMBER' DB_COL_NAME,
             'STYLE_NUMBER' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'DESCRIPTION' ATTR_NAME,
             'DESCRIPTION' DB_COL_NAME,
             'DESCRIPTION' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'DEPT_ID' ATTR_NAME,
             'DEPT_ID' DB_COL_NAME,
             'DEPT_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'VENDOR_NAME' ATTR_NAME,
             'VENDOR_NAME' DB_COL_NAME,
             'VENDOR_NAME' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'SIZE_RANGE' ATTR_NAME,
             'SIZE_RANGE' DB_COL_NAME,
             'SIZE_RANGE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'DEPT_TYPE' ATTR_NAME,
             'DEPT_TYPE' DB_COL_NAME,
             'DEPT_TYPE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'DIVISION_TYPE' ATTR_NAME,
             'DIVISION_TYPE' DB_COL_NAME,
             'DIVISION_TYPE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'CLASS_CODE' ATTR_NAME,
             'CLASS_CODE' DB_COL_NAME,
             'CLASS_CODE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'CLASS' ATTR_NAME,
             'CLASS' DB_COL_NAME,
             'CLASS' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'PRODUCT_CATEGORY' ATTR_NAME,
             'PRODUCT_CATEGORY' DB_COL_NAME,
             'PRODUCT_CATEGORY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'CATEGORY' ATTR_NAME,
             'CATEGORY' DB_COL_NAME,
             'CATEGORY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'PRODUCTION_TYPE' ATTR_NAME,
             'PRODUCTION_TYPE' DB_COL_NAME,
             'PRODUCTION_TYPE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'FIBER_CONTENT' ATTR_NAME,
             'FIBER_CONTENT' DB_COL_NAME,
             'FIBER_CONTENT' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'FABRICATION' ATTR_NAME,
             'FABRICATION' DB_COL_NAME,
             'FABRICATION' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'PRODUCT_GROUP' ATTR_NAME,
             'PRODUCT_GROUP' DB_COL_NAME,
             'PRODUCT_GROUP' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'RANGE_CODE' ATTR_NAME,
             'RANGE_CODE' DB_COL_NAME,
             'RANGE_CODE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'COLLAR' ATTR_NAME,
             'COLLAR' DB_COL_NAME,
             'COLLAR' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'SLEEVE' ATTR_NAME,
             'SLEEVE' DB_COL_NAME,
             'SLEEVE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'LABEL_CODE' ATTR_NAME,
             'LABEL_CODE' DB_COL_NAME,
             'LABEL_CODE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'TERM' ATTR_NAME,
             'TERM' DB_COL_NAME,
             'TERM' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'PRODUCT_CATEGORY_CODE' ATTR_NAME,
             'PRODUCT_CATEGORY_CODE' DB_COL_NAME,
             'PRODUCT_CATEGORY_CODE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'SEASON_CODE' ATTR_NAME,
             'SEASON_CODE' DB_COL_NAME,
             'SEASON_CODE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'PRODUCT_GROUP_CODE' ATTR_NAME,
             'PRODUCT_GROUP_CODE' DB_COL_NAME,
             'PRODUCT_GROUP_CODE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'STYLE_REF_NUMBER' ATTR_NAME,
             'STYLE_REF_NUMBER' DB_COL_NAME,
             'STYLE_REF_NUMBER' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'STYLE_NAME' ATTR_NAME,
             'STYLE_NAME' DB_COL_NAME,
             'STYLE_NAME' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'SUB_CLASS' ATTR_NAME,
             'SUB_CLASS' DB_COL_NAME,
             'SUB_CLASS' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'MINOR_CLASS' ATTR_NAME,
             'MINOR_CLASS' DB_COL_NAME,
             'MINOR_CLASS' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'HANG_FOLD' ATTR_NAME,
             'HANG_FOLD' DB_COL_NAME,
             'HANG_FOLD' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'YIELD' ATTR_NAME,
             'YIELD' DB_COL_NAME,
             'YIELD' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'DISCONTINUE_DATE' ATTR_NAME,
             'DISCONTINUE_DATE' DB_COL_NAME,
             'DISCONTINUE_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'CHANGE_DATE' ATTR_NAME,
             'CHANGE_DATE' DB_COL_NAME,
             'CHANGE_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'REPLENISHMENT_IND' ATTR_NAME,
             'REPLENISHMENT_IND' DB_COL_NAME,
             'REPLENISHMENT_IND' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'ORI_STYLE_ID' ATTR_NAME,
             'ORI_STYLE_ID' DB_COL_NAME,
             'ORI_STYLE_ID' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'ORI_COMPANY_ID' ATTR_NAME,
             'ORI_COMPANY_ID' DB_COL_NAME,
             'ORI_COMPANY_ID' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'ORI_BUYER_COMPANY_ID' ATTR_NAME,
             'ORI_BUYER_COMPANY_ID' DB_COL_NAME,
             'ORI_BUYER_COMPANY_ID' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'ORI_BUYER_CLASS_ID' ATTR_NAME,
             'ORI_BUYER_CLASS_ID' DB_COL_NAME,
             'ORI_BUYER_CLASS_ID' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'ORI_BUYER_SUBCLASS_ID' ATTR_NAME,
             'ORI_BUYER_SUBCLASS_ID' DB_COL_NAME,
             'ORI_BUYER_SUBCLASS_ID' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'ORI_MINOR_CLASS_ID' ATTR_NAME,
             'ORI_MINOR_CLASS_ID' DB_COL_NAME,
             'ORI_MINOR_CLASS_ID' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'ORI_PRODUCTION_TYPE_ID' ATTR_NAME,
             'ORI_PRODUCTION_TYPE_ID' DB_COL_NAME,
             'ORI_PRODUCTION_TYPE_ID' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'LOW_COST' ATTR_NAME,
             'LOW_COST' DB_COL_NAME,
             'LOW_COST' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'LOW_RETAIL' ATTR_NAME,
             'LOW_RETAIL' DB_COL_NAME,
             'LOW_RETAIL' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'STANDARD_COST' ATTR_NAME,
             'STANDARD_COST' DB_COL_NAME,
             'STANDARD_COST' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'VENDOR_REF_NUMBER' ATTR_NAME,
             'VENDOR_REF_NUMBER' DB_COL_NAME,
             'VENDOR_REF_NUMBER' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'STATUS' ATTR_NAME,
             'STATUS' DB_COL_NAME,
             'STATUS' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'STYLE_COLOR_ID' ATTR_NAME,
             'STYLE_COLOR_ID' DB_COL_NAME,
             'STYLE_COLOR_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'TARGET_BUSKEY' DB_COL_NAME,
             'TARGET_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'STYLE_ID' ATTR_NAME,
             'STYLE_ID' DB_COL_NAME,
             'STYLE_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'COLOR_NAME' ATTR_NAME,
             'COLOR_NAME' DB_COL_NAME,
             'COLOR_NAME' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'COLOR_CODE' ATTR_NAME,
             'COLOR_CODE' DB_COL_NAME,
             'COLOR_CODE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'VENDOR_COLOR_CODE' ATTR_NAME,
             'VENDOR_COLOR_CODE' DB_COL_NAME,
             'VENDOR_COLOR_CODE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'COLOR_FAMILY' ATTR_NAME,
             'COLOR_FAMILY' DB_COL_NAME,
             'COLOR_FAMILY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SHORT_COLOR_NAME' ATTR_NAME,
             'SHORT_COLOR_NAME' DB_COL_NAME,
             'SHORT_COLOR_NAME' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'COLOR_GROUP' ATTR_NAME,
             'COLOR_GROUP' DB_COL_NAME,
             'COLOR_GROUP' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'PATTERN' ATTR_NAME,
             'PATTERN' DB_COL_NAME,
             'PATTERN' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'ACCOUNT_EXCLUSIVE' ATTR_NAME,
             'ACCOUNT_EXCLUSIVE' DB_COL_NAME,
             'ACCOUNT_EXCLUSIVE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'START_SHIP_DATE' ATTR_NAME,
             'START_SHIP_DATE' DB_COL_NAME,
             'START_SHIP_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'PRODUCT_TEAM' ATTR_NAME,
             'PRODUCT_TEAM' DB_COL_NAME,
             'PRODUCT_TEAM' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'KEY_ITEM_INDICATOR' ATTR_NAME,
             'KEY_ITEM_INDICATOR' DB_COL_NAME,
             'KEY_ITEM_INDICATOR' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'PRODUCT_STOP_DATE' ATTR_NAME,
             'PRODUCT_STOP_DATE' DB_COL_NAME,
             'PRODUCT_STOP_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'OUTLET_STYLE_INDICATOR' ATTR_NAME,
             'OUTLET_STYLE_INDICATOR' DB_COL_NAME,
             'OUTLET_STYLE_INDICATOR' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'MULTI_CHANNEL_IND' ATTR_NAME,
             'MULTI_CHANNEL_IND' DB_COL_NAME,
             'MULTI_CHANNEL_IND' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'ORI_STYLE_COLOR_ID' ATTR_NAME,
             'ORI_STYLE_COLOR_ID' DB_COL_NAME,
             'ORI_STYLE_COLOR_ID' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'STYLE_COLOR_SIZE_ID' ATTR_NAME,
             'STYLE_COLOR_SIZE_ID' DB_COL_NAME,
             'STYLE_COLOR_SIZE_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'TARGET_BUSKEY' DB_COL_NAME,
             'TARGET_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'STYLE_COLOR_ID' ATTR_NAME,
             'STYLE_COLOR_ID' DB_COL_NAME,
             'STYLE_COLOR_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'SIZE_CODE' ATTR_NAME,
             'SIZE_CODE' DB_COL_NAME,
             'SIZE_CODE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'SIZE_ITEM_ID' ATTR_NAME,
             'SIZE_ITEM_ID' DB_COL_NAME,
             'SIZE_ITEM_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'UPC' ATTR_NAME,
             'UPC' DB_COL_NAME,
             'UPC' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'ARTICLE_NUMBER' ATTR_NAME,
             'ARTICLE_NUMBER' DB_COL_NAME,
             'ARTICLE_NUMBER' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'ORI_STYLE_SIZE_ID' ATTR_NAME,
             'ORI_STYLE_SIZE_ID' DB_COL_NAME,
             'ORI_STYLE_SIZE_ID' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'STYLE_COLOR_SIZE_GP_ID' ATTR_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_COL_NAME,
             'STYLE_COLOR_SIZE_GP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'TARGET_BUSKEY' DB_COL_NAME,
             'TARGET_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'GP_SIZE_ID' ATTR_NAME,
             'GP_SIZE_ID' DB_COL_NAME,
             'GP_SIZE_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'STYLE_COLOR_SIZE_ID' ATTR_NAME,
             'STYLE_COLOR_SIZE_ID' DB_COL_NAME,
             'STYLE_COLOR_SIZE_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'PREPACK_CODE' ATTR_NAME,
             'PREPACK_CODE' DB_COL_NAME,
             'PREPACK_CODE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'PREPACK_TYPE' ATTR_NAME,
             'PREPACK_TYPE' DB_COL_NAME,
             'PREPACK_TYPE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SIZE_RANGE' LEVEL_NAME,
             'SIZE_RANGE_ID' ATTR_NAME,
             'SIZE_RANGE_ID' DB_COL_NAME,
             'SIZE_RANGE_ID' BUSINESS_DESC,
             'N'
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SIZE_RANGE' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      
      SELECT 'STYLE' DIM_NAME,
             'SIZE_RANGE' LEVEL_NAME,
             'NAME' ATTR_NAME,
             'NAME' DB_COL_NAME,
             'NAME' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SIZE_RANGE' LEVEL_NAME,
             'DEPT_ID' ATTR_NAME,
             'DEPT_ID' DB_COL_NAME,
             'DEPT_ID' BUSINESS_DESC,
             'N'
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SIZE_ITEM' LEVEL_NAME,
             'SIZE_ITEM_ID' ATTR_NAME,
             'SIZE_ITEM_ID' DB_COL_NAME,
             'SIZE_ITEM_ID' BUSINESS_DESC,
             'N'
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SIZE_ITEM' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SIZE_ITEM' LEVEL_NAME,
             'SIZE_RANGE_ID' ATTR_NAME,
             'SIZE_RANGE_ID' DB_COL_NAME,
             'SIZE_RANGE_ID' BUSINESS_DESC,
             'N'
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SIZE_ITEM' LEVEL_NAME,
             'SIZE_CODE' ATTR_NAME,
             'SIZE_CODE' DB_COL_NAME,
             'SIZE_CODE' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SIZE_ITEM' LEVEL_NAME,
             'SIZE_NAME1' ATTR_NAME,
             'SIZE_NAME1' DB_COL_NAME,
             'SIZE_NAME1' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SIZE_ITEM' LEVEL_NAME,
             'SIZE_NAME2' ATTR_NAME,
             'SIZE_NAME2' DB_COL_NAME,
             'SIZE_NAME2' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SIZE_ITEM' LEVEL_NAME,
             'SIZE_SEQ1' ATTR_NAME,
             'SIZE_SEQ1' DB_COL_NAME,
             'SIZE_SEQ1' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SIZE_ITEM' LEVEL_NAME,
             'SIZE_SEQ2' ATTR_NAME,
             'SIZE_SEQ2' DB_COL_NAME,
             'SIZE_SEQ2' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SIZE_ITEM' LEVEL_NAME,
             'CORE_SIZE_INDICATOR' ATTR_NAME,
             'CORE_SIZE_INDICATOR' DB_COL_NAME,
             'CORE_SIZE_INDICATOR' BUSINESS_DESC,
             'Y'
        FROM DUAL;
  
    --STORE
    INSERT INTO META_DIM_LEVEL_ATTRS
      (DIM_NAME,
       LEVEL_NAME,
       ATTR_NAME,
       DB_COL_NAME,
       BUSINESS_DESC,
       VISABLE)
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'STORE_ID' ATTR_NAME,
             'STORE_ID' DB_COL_NAME,
             'STORE_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'STORE_LOC_ID' ATTR_NAME,
             'STORE_LOC_ID' DB_COL_NAME,
             'STORE_LOC_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'DOOR_NUM' ATTR_NAME,
             'DOOR_NUM' DB_COL_NAME,
             'DOOR_NUM' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'DOOR_NAME' ATTR_NAME,
             'DOOR_NAME' DB_COL_NAME,
             'DOOR_NAME' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'REGION' ATTR_NAME,
             'REGION' DB_COL_NAME,
             'REGION' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'DEMOGRAPHIC' ATTR_NAME,
             'DEMOGRAPHIC' DB_COL_NAME,
             'DEMOGRAPHIC' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'DOOR_TYPE' ATTR_NAME,
             'DOOR_TYPE' DB_COL_NAME,
             'DOOR_TYPE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'ETHNICITY' ATTR_NAME,
             'ETHNICITY' DB_COL_NAME,
             'ETHNICITY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'GEOGRAPHY' ATTR_NAME,
             'GEOGRAPHY' DB_COL_NAME,
             'GEOGRAPHY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'CLIMATE' ATTR_NAME,
             'CLIMATE' DB_COL_NAME,
             'CLIMATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'STORE_GROUP' ATTR_NAME,
             'STORE_GROUP' DB_COL_NAME,
             'STORE_GROUP' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'PRICING_ZONE' ATTR_NAME,
             'PRICING_ZONE' DB_COL_NAME,
             'PRICING_ZONE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'LOC_ATTR1' ATTR_NAME,
             'LOC_ATTR1' DB_COL_NAME,
             'LOC_ATTR1' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'LOC_ATTR2' ATTR_NAME,
             'LOC_ATTR2' DB_COL_NAME,
             'LOC_ATTR2' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'LOC_ATTR3' ATTR_NAME,
             'LOC_ATTR3' DB_COL_NAME,
             'LOC_ATTR3' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'LOC_ATTR4' ATTR_NAME,
             'LOC_ATTR4' DB_COL_NAME,
             'LOC_ATTR4' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'LOC_ATTR5' ATTR_NAME,
             'LOC_ATTR5' DB_COL_NAME,
             'LOC_ATTR5' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'LOC_ATTR6' ATTR_NAME,
             'LOC_ATTR6' DB_COL_NAME,
             'LOC_ATTR6' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'DISTANCE' ATTR_NAME,
             'DISTANCE' DB_COL_NAME,
             'DISTANCE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'LOC_ATTR7' ATTR_NAME,
             'LOC_ATTR7' DB_COL_NAME,
             'LOC_ATTR7' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'ORI_COMPANY_DOOR_ID' ATTR_NAME,
             'ORI_COMPANY_DOOR_ID' DB_COL_NAME,
             'ORI_COMPANY_DOOR_ID' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'STORE_CATEGORY' ATTR_NAME,
             'STORE_CATEGORY' DB_COL_NAME,
             'STORE_CATEGORY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'SEQUENCE' ATTR_NAME,
             'SEQUENCE' DB_COL_NAME,
             'SEQUENCE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'ORI_SISTER_DOOR_ID' ATTR_NAME,
             'ORI_SISTER_DOOR_ID' DB_COL_NAME,
             'ORI_SISTER_DOOR_ID' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'SISTER_STORE_ID' ATTR_NAME,
             'SISTER_STORE_ID' DB_COL_NAME,
             'SISTER_STORE_ID' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'TOTAL_SQ_FT' ATTR_NAME,
             'TOTAL_SQ_FT' DB_COL_NAME,
             'TOTAL_SQ_FT' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'COMP_INDICATOR' ATTR_NAME,
             'COMP_INDICATOR' DB_COL_NAME,
             'COMP_INDICATOR' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'AVAILABLE' ATTR_NAME,
             'AVAILABLE' DB_COL_NAME,
             'AVAILABLE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'TURN_DATE' ATTR_NAME,
             'TURN_DATE' DB_COL_NAME,
             'TURN_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'SOFT_DATE' ATTR_NAME,
             'SOFT_DATE' DB_COL_NAME,
             'SOFT_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'GO_DATE' ATTR_NAME,
             'GO_DATE' DB_COL_NAME,
             'GO_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'CLOSE_DATE' ATTR_NAME,
             'CLOSE_DATE' DB_COL_NAME,
             'CLOSE_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'TRANSFER_DOOR_ID' ATTR_NAME,
             'TRANSFER_DOOR_ID' DB_COL_NAME,
             'TRANSFER_DOOR_ID' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'DISPLAY_CAPACITY' ATTR_NAME,
             'DISPLAY_CAPACITY' DB_COL_NAME,
             'DISPLAY_CAPACITY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'INVENTORY_CAPACITY' ATTR_NAME,
             'INVENTORY_CAPACITY' DB_COL_NAME,
             'INVENTORY_CAPACITY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'REMODEL_TURN_DATE' ATTR_NAME,
             'REMODEL_TURN_DATE' DB_COL_NAME,
             'REMODEL_TURN_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'REMODEL_START_DATE' ATTR_NAME,
             'REMODEL_START_DATE' DB_COL_NAME,
             'REMODEL_START_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'REMODEL_END_DATE' ATTR_NAME,
             'REMODEL_END_DATE' DB_COL_NAME,
             'REMODEL_END_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'COMMENTS' ATTR_NAME,
             'COMMENTS' DB_COL_NAME,
             'COMMENTS' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      --ADDED BY FLAME@18/08/2016
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'COUNTRY' ATTR_NAME,
             'COUNTRY' DB_COL_NAME,
             'COUNTRY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'DC' ATTR_NAME,
             'DC' DB_COL_NAME,
             'DC' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'STOCK_CATEGORY' ATTR_NAME,
             'STOCK_CATEGORY' DB_COL_NAME,
             'STOCK_CATEGORY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'STORE_TYPE' ATTR_NAME,
             'STORE_TYPE' DB_COL_NAME,
             'STORE_TYPE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'ORI_STORE_TYPE_ID' ATTR_NAME,
             'ORI_STORE_TYPE_ID' DB_COL_NAME,
             'ORI_STORE_TYPE_ID' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      --FLAME ADDED 21/09/2016
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'TARGET_BUSKEY' DB_COL_NAME,
             'TARGET_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'COUNTRY' LEVEL_NAME,
             'STORE_LOC_ID' ATTR_NAME,
             'STORE_LOC_ID' DB_COL_NAME,
             'STORE_LOC_ID' BUSINESS_DESC,
             'N'
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'COUNTRY' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'COUNTRY' LEVEL_NAME,
             'LOC_DESC' ATTR_NAME,
             'LOC_DESC' DB_COL_NAME,
             'LOC_DESC' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'COUNTRY' LEVEL_NAME,
             'LOC_TYPE' ATTR_NAME,
             'LOC_TYPE' DB_COL_NAME,
             'LOC_TYPE' BUSINESS_DESC,
             'Y'
        FROM DUAL
      --FLAME ADDED 21/09/2016
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'COUNTRY' LEVEL_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'TARGET_BUSKEY' DB_COL_NAME,
             'TARGET_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'STORE_LOC_ID' ATTR_NAME,
             'STORE_LOC_ID' DB_COL_NAME,
             'STORE_LOC_ID' BUSINESS_DESC,
             'N'
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'LOC_DESC' ATTR_NAME,
             'LOC_DESC' DB_COL_NAME,
             'LOC_DESC' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'LOC_TYPE' ATTR_NAME,
             'LOC_TYPE' DB_COL_NAME,
             'LOC_TYPE' BUSINESS_DESC,
             'Y'
        FROM DUAL
      --FLAME ADDED 21/09/2016
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'TARGET_BUSKEY' DB_COL_NAME,
             'TARGET_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'STORE_LOC_ID' ATTR_NAME,
             'STORE_LOC_ID' DB_COL_NAME,
             'STORE_LOC_ID' BUSINESS_DESC,
             'N'
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'LOC_DESC' ATTR_NAME,
             'LOC_DESC' DB_COL_NAME,
             'LOC_DESC' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'LOC_TYPE' ATTR_NAME,
             'LOC_TYPE' DB_COL_NAME,
             'LOC_TYPE' BUSINESS_DESC,
             'Y'
        FROM DUAL
      --FLAME ADDED 21/09/2016
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'TARGET_BUSKEY' DB_COL_NAME,
             'TARGET_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      --FLAME ADDED 21/09/2016
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE' LEVEL_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'TARGET_BUSKEY' DB_COL_NAME,
             'TARGET_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE' LEVEL_NAME,
             'STORE_LOC_ID' ATTR_NAME,
             'STORE_LOC_ID' DB_COL_NAME,
             'STORE_LOC_ID' BUSINESS_DESC,
             'N'
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE' LEVEL_NAME,
             'LOC_DESC' ATTR_NAME,
             'LOC_DESC' DB_COL_NAME,
             'LOC_DESC' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE' LEVEL_NAME,
             'LOC_TYPE' ATTR_NAME,
             'LOC_TYPE' DB_COL_NAME,
             'LOC_TYPE' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'COUNTRY' LEVEL_NAME,
             'LOC_ATTR1' ATTR_NAME,
             'LOC_ATTR1' DB_COL_NAME,
             'LOC_ATTR1' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'LOC_ATTR1' ATTR_NAME,
             'LOC_ATTR1' DB_COL_NAME,
             'LOC_ATTR1' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'LOC_ATTR1' ATTR_NAME,
             'LOC_ATTR1' DB_COL_NAME,
             'LOC_ATTR1' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE' LEVEL_NAME,
             'LOC_ATTR1' ATTR_NAME,
             'LOC_ATTR1' DB_COL_NAME,
             'LOC_ATTR1' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'COUNTRY' LEVEL_NAME,
             'LOC_ATTR2' ATTR_NAME,
             'LOC_ATTR2' DB_COL_NAME,
             'LOC_ATTR2' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'LOC_ATTR2' ATTR_NAME,
             'LOC_ATTR2' DB_COL_NAME,
             'LOC_ATTR2' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'LOC_ATTR2' ATTR_NAME,
             'LOC_ATTR2' DB_COL_NAME,
             'LOC_ATTR2' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE' LEVEL_NAME,
             'LOC_ATTR2' ATTR_NAME,
             'LOC_ATTR2' DB_COL_NAME,
             'LOC_ATTR2' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'COUNTRY' LEVEL_NAME,
             'LOC_ATTR3' ATTR_NAME,
             'LOC_ATTR3' DB_COL_NAME,
             'LOC_ATTR3' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'LOC_ATTR3' ATTR_NAME,
             'LOC_ATTR3' DB_COL_NAME,
             'LOC_ATTR3' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'LOC_ATTR3' ATTR_NAME,
             'LOC_ATTR3' DB_COL_NAME,
             'LOC_ATTR3' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE' LEVEL_NAME,
             'LOC_ATTR3' ATTR_NAME,
             'LOC_ATTR3' DB_COL_NAME,
             'LOC_ATTR3' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'COUNTRY' LEVEL_NAME,
             'LOC_ATTR4' ATTR_NAME,
             'LOC_ATTR4' DB_COL_NAME,
             'LOC_ATTR4' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'LOC_ATTR4' ATTR_NAME,
             'LOC_ATTR4' DB_COL_NAME,
             'LOC_ATTR4' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'LOC_ATTR4' ATTR_NAME,
             'LOC_ATTR4' DB_COL_NAME,
             'LOC_ATTR4' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE' LEVEL_NAME,
             'LOC_ATTR4' ATTR_NAME,
             'LOC_ATTR4' DB_COL_NAME,
             'LOC_ATTR4' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'COUNTRY' LEVEL_NAME,
             'LOC_ATTR5' ATTR_NAME,
             'LOC_ATTR5' DB_COL_NAME,
             'LOC_ATTR5' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'LOC_ATTR5' ATTR_NAME,
             'LOC_ATTR5' DB_COL_NAME,
             'LOC_ATTR5' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'LOC_ATTR5' ATTR_NAME,
             'LOC_ATTR5' DB_COL_NAME,
             'LOC_ATTR5' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE' LEVEL_NAME,
             'LOC_ATTR5' ATTR_NAME,
             'LOC_ATTR5' DB_COL_NAME,
             'LOC_ATTR5' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'COUNTRY' LEVEL_NAME,
             'LOC_ATTR6' ATTR_NAME,
             'LOC_ATTR6' DB_COL_NAME,
             'LOC_ATTR6' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'LOC_ATTR6' ATTR_NAME,
             'LOC_ATTR6' DB_COL_NAME,
             'LOC_ATTR6' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'LOC_ATTR6' ATTR_NAME,
             'LOC_ATTR6' DB_COL_NAME,
             'LOC_ATTR6' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE' LEVEL_NAME,
             'LOC_ATTR6' ATTR_NAME,
             'LOC_ATTR6' DB_COL_NAME,
             'LOC_ATTR6' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'COUNTRY' LEVEL_NAME,
             'LOC_ATTR7' ATTR_NAME,
             'LOC_ATTR7' DB_COL_NAME,
             'LOC_ATTR7' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'LOC_ATTR7' ATTR_NAME,
             'LOC_ATTR7' DB_COL_NAME,
             'LOC_ATTR7' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'LOC_ATTR7' ATTR_NAME,
             'LOC_ATTR7' DB_COL_NAME,
             'LOC_ATTR7' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE' LEVEL_NAME,
             'LOC_ATTR7' ATTR_NAME,
             'LOC_ATTR7' DB_COL_NAME,
             'LOC_ATTR7' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'COUNTRY' LEVEL_NAME,
             'LOC_ATTR8' ATTR_NAME,
             'LOC_ATTR8' DB_COL_NAME,
             'LOC_ATTR8' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'LOC_ATTR8' ATTR_NAME,
             'LOC_ATTR8' DB_COL_NAME,
             'LOC_ATTR8' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'LOC_ATTR8' ATTR_NAME,
             'LOC_ATTR8' DB_COL_NAME,
             'LOC_ATTR8' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE' LEVEL_NAME,
             'LOC_ATTR8' ATTR_NAME,
             'LOC_ATTR8' DB_COL_NAME,
             'LOC_ATTR8' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'COUNTRY' LEVEL_NAME,
             'LOC_ATTR9' ATTR_NAME,
             'LOC_ATTR9' DB_COL_NAME,
             'LOC_ATTR9' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'LOC_ATTR9' ATTR_NAME,
             'LOC_ATTR9' DB_COL_NAME,
             'LOC_ATTR9' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'LOC_ATTR9' ATTR_NAME,
             'LOC_ATTR9' DB_COL_NAME,
             'LOC_ATTR9' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE' LEVEL_NAME,
             'LOC_ATTR9' ATTR_NAME,
             'LOC_ATTR9' DB_COL_NAME,
             'LOC_ATTR9' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'COUNTRY' LEVEL_NAME,
             'LOC_ATTR10' ATTR_NAME,
             'LOC_ATTR10' DB_COL_NAME,
             'LOC_ATTR10' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'LOC_ATTR10' ATTR_NAME,
             'LOC_ATTR10' DB_COL_NAME,
             'LOC_ATTR10' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'LOC_ATTR10' ATTR_NAME,
             'LOC_ATTR10' DB_COL_NAME,
             'LOC_ATTR10' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE' LEVEL_NAME,
             'LOC_ATTR10' ATTR_NAME,
             'LOC_ATTR10' DB_COL_NAME,
             'LOC_ATTR10' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL;
  
    --YEAR_SEASON
    INSERT INTO META_DIM_LEVEL_ATTRS
      (DIM_NAME,
       LEVEL_NAME,
       ATTR_NAME,
       DB_COL_NAME,
       BUSINESS_DESC,
       VISABLE)
    --YEAR_SEASON
      SELECT 'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'YEAR_SEASON_ID' ATTR_NAME,
             'YEAR_SEASON_ID' DB_COL_NAME,
             'YEAR_SEASON_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'STYLE_YEAR' ATTR_NAME,
             'STYLE_YEAR' DB_COL_NAME,
             'STYLE_YEAR' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'SEASON_NAME' ATTR_NAME,
             'SEASON_NAME' DB_COL_NAME,
             'SEASON_NAME' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'ORI_SEASON_ID' ATTR_NAME,
             'ORI_SEASON_ID' DB_COL_NAME,
             'ORI_SEASON_ID' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      --REAL_YEAR_SEASON
      SELECT 'YEAR_SEASON' DIM_NAME,
             'REAL_YEAR_SEASON' LEVEL_NAME,
             'YEAR_SEASON_ID' ATTR_NAME,
             'YEAR_SEASON_ID' DB_COL_NAME,
             'YEAR_SEASON_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'REAL_YEAR_SEASON' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'REAL_YEAR_SEASON' LEVEL_NAME,
             'STYLE_YEAR' ATTR_NAME,
             'STYLE_YEAR' DB_COL_NAME,
             'STYLE_YEAR' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'REAL_YEAR_SEASON' LEVEL_NAME,
             'SEASON_NAME' ATTR_NAME,
             'SEASON_NAME' DB_COL_NAME,
             'SEASON_NAME' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'REAL_YEAR_SEASON' LEVEL_NAME,
             'ORI_SEASON_ID' ATTR_NAME,
             'ORI_SEASON_ID' DB_COL_NAME,
             'ORI_SEASON_ID' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      --STYLE_YEAR_SEASON
      SELECT 'YEAR_SEASON' DIM_NAME,
             'STYLE_YEAR_SEASON' LEVEL_NAME,
             'STYLE_YEAR_SEASON_ID' ATTR_NAME,
             'STYLE_YEAR_SEASON_ID' DB_COL_NAME,
             'STYLE_YEAR_SEASON_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'STYLE_YEAR_SEASON' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'STYLE_YEAR_SEASON' LEVEL_NAME,
             'STYLE_COLOR_ID' ATTR_NAME,
             'STYLE_COLOR_ID' DB_COL_NAME,
             'STYLE_COLOR_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'STYLE_YEAR_SEASON' LEVEL_NAME,
             'SMONTH_ID' ATTR_NAME,
             'SMONTH_ID' DB_COL_NAME,
             'SMONTH_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'STYLE_YEAR_SEASON' LEVEL_NAME,
             'YEAR_SEASON_ID' ATTR_NAME,
             'YEAR_SEASON_ID' DB_COL_NAME,
             'YEAR_SEASON_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'STYLE_YEAR_SEASON' LEVEL_NAME,
             'REAL_YEAR_SEASON_ID' ATTR_NAME,
             'REAL_YEAR_SEASON_ID' DB_COL_NAME,
             'REAL_YEAR_SEASON_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL;
  
    --TRANSFER
    INSERT INTO META_DIM_LEVEL_ATTRS
      (DIM_NAME,
       LEVEL_NAME,
       ATTR_NAME,
       DB_COL_NAME,
       BUSINESS_DESC,
       VISABLE)
      SELECT 'TRANSFER' DIM_NAME,
             'TRANSFER' LEVEL_NAME,
             'TRANSFER_TRANSFER_ID' ATTR_NAME,
             'TRANSFER_TRANSFER_ID' DB_COL_NAME,
             'TRANSFER_TRANSFER_ID' BUSINESS_DESC,
             'N'
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER' DIM_NAME,
             'TRANSFER' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER' DIM_NAME,
             'TRANSFER' LEVEL_NAME,
             'TRANSFER_DATE' ATTR_NAME,
             'TRANSFER_DATE' DB_COL_NAME,
             'TRANSFER_DATE' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER' DIM_NAME,
             'TRANSFER' LEVEL_NAME,
             'TRANSFER_NAME' ATTR_NAME,
             'TRANSFER_NAME' DB_COL_NAME,
             'TRANSFER_NAME' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER' DIM_NAME,
             'TRANSFER' LEVEL_NAME,
             'PROD_CRITERIAL_GROUP_ID' ATTR_NAME,
             'PROD_CRITERIAL_GROUP_ID' DB_COL_NAME,
             'PROD_CRITERIAL_GROUP_ID' BUSINESS_DESC,
             'N'
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER' DIM_NAME,
             'TRANSFER' LEVEL_NAME,
             'LOC_CRITERIAL_GROUP_ID' ATTR_NAME,
             'LOC_CRITERIAL_GROUP_ID' DB_COL_NAME,
             'LOC_CRITERIAL_GROUP_ID' BUSINESS_DESC,
             'N'
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'TRANSFER_RELEASE_ID' ATTR_NAME,
             'TRANSFER_RELEASE_ID' DB_COL_NAME,
             'TRANSFER_RELEASE_ID' BUSINESS_DESC,
             'N'
        FROM DUAL
      --TRANSFER RELEASE
      UNION ALL
      SELECT 'TRANSFER' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'TRANSFER_TRANSFER_ID' ATTR_NAME,
             'TRANSFER_TRANSFER_ID' DB_COL_NAME,
             'TRANSFER_TRANSFER_ID' BUSINESS_DESC,
             'N'
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'RELEASE_DATE' ATTR_NAME,
             'RELEASE_DATE' DB_COL_NAME,
             'RELEASE_DATE' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'PROD_CRITERIAL_GROUP_ID' ATTR_NAME,
             'PROD_CRITERIAL_GROUP_ID' DB_COL_NAME,
             'PROD_CRITERIAL_GROUP_ID' BUSINESS_DESC,
             'N'
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'LOC_CRITERIAL_GROUP_ID' ATTR_NAME,
             'LOC_CRITERIAL_GROUP_ID' DB_COL_NAME,
             'LOC_CRITERIAL_GROUP_ID' BUSINESS_DESC,
             'N'
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'RELEASE_NAME' ATTR_NAME,
             'RELEASE_NAME' DB_COL_NAME,
             'RELEASE_NAME' BUSINESS_DESC,
             'Y'
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'SALES_STYLE' LEVEL_NAME,
             'SALES_STYLE_ID' ATTR_NAME,
             'SALES_STYLE_ID' DB_COL_NAME,
             'SALES_STYLE_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'SALES_STYLE' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'SALES_STYLE' LEVEL_NAME,
             'SALES_STYLE_CODE' ATTR_NAME,
             'SALES_STYLE_CODE' DB_COL_NAME,
             'SALES_STYLE_CODE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'SALES_STYLE' LEVEL_NAME,
             'SALES_STYLE_NAME' ATTR_NAME,
             'SALES_STYLE_NAME' DB_COL_NAME,
             'SALES_STYLE_NAME' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'SALES_STYLE' LEVEL_NAME,
             'ORI_SALES_STYLE_ID' ATTR_NAME,
             'ORI_SALES_STYLE_ID' DB_COL_NAME,
             'ORI_SALES_STYLE_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PROMOTION' LEVEL_NAME,
             'PROMOTION_ID' ATTR_NAME,
             'PROMOTION_ID' DB_COL_NAME,
             'PROMOTION_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PROMOTION' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PROMOTION' LEVEL_NAME,
             'SALES_STYLE_ID' ATTR_NAME,
             'SALES_STYLE_ID' DB_COL_NAME,
             'SALES_STYLE_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PROMOTION' LEVEL_NAME,
             'GROUP_CODE' ATTR_NAME,
             'GROUP_CODE' DB_COL_NAME,
             'GROUP_CODE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PROMOTION' LEVEL_NAME,
             'GROUP_NAME' ATTR_NAME,
             'GROUP_NAME' DB_COL_NAME,
             'GROUP_NAME' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PROMOTION' LEVEL_NAME,
             'TYPE' ATTR_NAME,
             'TYPE' DB_COL_NAME,
             'TYPE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PROMOTION' LEVEL_NAME,
             'CODE' ATTR_NAME,
             'CODE' DB_COL_NAME,
             'CODE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PROMOTION' LEVEL_NAME,
             'NAME' ATTR_NAME,
             'NAME' DB_COL_NAME,
             'NAME' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PROMOTION' LEVEL_NAME,
             'START_DATE' ATTR_NAME,
             'START_DATE' DB_COL_NAME,
             'START_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PROMOTION' LEVEL_NAME,
             'END_DATE' ATTR_NAME,
             'END_DATE' DB_COL_NAME,
             'END_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PROMOTION' LEVEL_NAME,
             'PROMO_PERCENT' ATTR_NAME,
             'PROMO_PERCENT' DB_COL_NAME,
             'PROMO_PERCENT' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'PROD_ATTR_ID' ATTR_NAME,
             'PROD_ATTR_ID' DB_COL_NAME,
             'PROD_ATTR_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'PROD_ATTR_NAME1' ATTR_NAME,
             'PROD_ATTR_NAME1' DB_COL_NAME,
             'PROD_ATTR_NAME1' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'PROD_ATTR_NAME2' ATTR_NAME,
             'PROD_ATTR_NAME2' DB_COL_NAME,
             'PROD_ATTR_NAME2' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'PROD_ATTR_NAME3' ATTR_NAME,
             'PROD_ATTR_NAME3' DB_COL_NAME,
             'PROD_ATTR_NAME3' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'PROD_ATTR_NAME4' ATTR_NAME,
             'PROD_ATTR_NAME4' DB_COL_NAME,
             'PROD_ATTR_NAME4' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'PROD_ATTR_NAME5' ATTR_NAME,
             'PROD_ATTR_NAME5' DB_COL_NAME,
             'PROD_ATTR_NAME5' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'PROD_ATTR_NAME6' ATTR_NAME,
             'PROD_ATTR_NAME6' DB_COL_NAME,
             'PROD_ATTR_NAME6' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'PROD_ATTR_NAME7' ATTR_NAME,
             'PROD_ATTR_NAME7' DB_COL_NAME,
             'PROD_ATTR_NAME7' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'PROD_ATTR_NAME8' ATTR_NAME,
             'PROD_ATTR_NAME8' DB_COL_NAME,
             'PROD_ATTR_NAME8' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'PROD_ATTR_NAME9' ATTR_NAME,
             'PROD_ATTR_NAME9' DB_COL_NAME,
             'PROD_ATTR_NAME9' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'PROD_ATTR_NAME10' ATTR_NAME,
             'PROD_ATTR_NAME10' DB_COL_NAME,
             'PROD_ATTR_NAME10' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'PROD_ATTR_NAME11' ATTR_NAME,
             'PROD_ATTR_NAME11' DB_COL_NAME,
             'PROD_ATTR_NAME11' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'PROD_ATTR_NAME12' ATTR_NAME,
             'PROD_ATTR_NAME12' DB_COL_NAME,
             'PROD_ATTR_NAME12' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'PROD_ATTR_NAME13' ATTR_NAME,
             'PROD_ATTR_NAME13' DB_COL_NAME,
             'PROD_ATTR_NAME13' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'PROD_ATTR_NAME14' ATTR_NAME,
             'PROD_ATTR_NAME14' DB_COL_NAME,
             'PROD_ATTR_NAME14' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'PROD_ATTR_NAME15' ATTR_NAME,
             'PROD_ATTR_NAME15' DB_COL_NAME,
             'PROD_ATTR_NAME15' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'PROD_ATTR_NAME16' ATTR_NAME,
             'PROD_ATTR_NAME16' DB_COL_NAME,
             'PROD_ATTR_NAME16' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'PROD_ATTR_NAME17' ATTR_NAME,
             'PROD_ATTR_NAME17' DB_COL_NAME,
             'PROD_ATTR_NAME17' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'PROD_ATTR_NAME18' ATTR_NAME,
             'PROD_ATTR_NAME18' DB_COL_NAME,
             'PROD_ATTR_NAME18' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'PROD_ATTR_NAME19' ATTR_NAME,
             'PROD_ATTR_NAME19' DB_COL_NAME,
             'PROD_ATTR_NAME19' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'PROD_ATTR_NAME20' ATTR_NAME,
             'PROD_ATTR_NAME20' DB_COL_NAME,
             'PROD_ATTR_NAME20' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE_ID' ATTR_NAME,
             'PROD_ATTR_VALUE_ID' DB_COL_NAME,
             'PROD_ATTR_VALUE_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_ID' ATTR_NAME,
             'PROD_ATTR_ID' DB_COL_NAME,
             'PROD_ATTR_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE1' ATTR_NAME,
             'PROD_ATTR_VALUE1' DB_COL_NAME,
             'PROD_ATTR_VALUE1' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE2' ATTR_NAME,
             'PROD_ATTR_VALUE2' DB_COL_NAME,
             'PROD_ATTR_VALUE2' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE3' ATTR_NAME,
             'PROD_ATTR_VALUE3' DB_COL_NAME,
             'PROD_ATTR_VALUE3' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE4' ATTR_NAME,
             'PROD_ATTR_VALUE4' DB_COL_NAME,
             'PROD_ATTR_VALUE4' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE5' ATTR_NAME,
             'PROD_ATTR_VALUE5' DB_COL_NAME,
             'PROD_ATTR_VALUE5' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE6' ATTR_NAME,
             'PROD_ATTR_VALUE6' DB_COL_NAME,
             'PROD_ATTR_VALUE6' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE7' ATTR_NAME,
             'PROD_ATTR_VALUE7' DB_COL_NAME,
             'PROD_ATTR_VALUE7' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE8' ATTR_NAME,
             'PROD_ATTR_VALUE8' DB_COL_NAME,
             'PROD_ATTR_VALUE8' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE9' ATTR_NAME,
             'PROD_ATTR_VALUE9' DB_COL_NAME,
             'PROD_ATTR_VALUE9' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE10' ATTR_NAME,
             'PROD_ATTR_VALUE10' DB_COL_NAME,
             'PROD_ATTR_VALUE10' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE11' ATTR_NAME,
             'PROD_ATTR_VALUE11' DB_COL_NAME,
             'PROD_ATTR_VALUE11' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE12' ATTR_NAME,
             'PROD_ATTR_VALUE12' DB_COL_NAME,
             'PROD_ATTR_VALUE12' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE13' ATTR_NAME,
             'PROD_ATTR_VALUE13' DB_COL_NAME,
             'PROD_ATTR_VALUE13' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE14' ATTR_NAME,
             'PROD_ATTR_VALUE14' DB_COL_NAME,
             'PROD_ATTR_VALUE14' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE15' ATTR_NAME,
             'PROD_ATTR_VALUE15' DB_COL_NAME,
             'PROD_ATTR_VALUE15' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE16' ATTR_NAME,
             'PROD_ATTR_VALUE16' DB_COL_NAME,
             'PROD_ATTR_VALUE16' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE17' ATTR_NAME,
             'PROD_ATTR_VALUE17' DB_COL_NAME,
             'PROD_ATTR_VALUE17' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE18' ATTR_NAME,
             'PROD_ATTR_VALUE18' DB_COL_NAME,
             'PROD_ATTR_VALUE18' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE19' ATTR_NAME,
             'PROD_ATTR_VALUE19' DB_COL_NAME,
             'PROD_ATTR_VALUE19' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE20' ATTR_NAME,
             'PROD_ATTR_VALUE20' DB_COL_NAME,
             'PROD_ATTR_VALUE20' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'LOC_ATTR_ID' ATTR_NAME,
             'LOC_ATTR_ID' DB_COL_NAME,
             'LOC_ATTR_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'LOC_ATTR_NAME1' ATTR_NAME,
             'LOC_ATTR_NAME1' DB_COL_NAME,
             'LOC_ATTR_NAME1' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'LOC_ATTR_NAME2' ATTR_NAME,
             'LOC_ATTR_NAME2' DB_COL_NAME,
             'LOC_ATTR_NAME2' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'LOC_ATTR_NAME3' ATTR_NAME,
             'LOC_ATTR_NAME3' DB_COL_NAME,
             'LOC_ATTR_NAME3' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'LOC_ATTR_NAME4' ATTR_NAME,
             'LOC_ATTR_NAME4' DB_COL_NAME,
             'LOC_ATTR_NAME4' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'LOC_ATTR_NAME5' ATTR_NAME,
             'LOC_ATTR_NAME5' DB_COL_NAME,
             'LOC_ATTR_NAME5' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'LOC_ATTR_NAME6' ATTR_NAME,
             'LOC_ATTR_NAME6' DB_COL_NAME,
             'LOC_ATTR_NAME6' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'LOC_ATTR_NAME7' ATTR_NAME,
             'LOC_ATTR_NAME7' DB_COL_NAME,
             'LOC_ATTR_NAME7' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'LOC_ATTR_NAME8' ATTR_NAME,
             'LOC_ATTR_NAME8' DB_COL_NAME,
             'LOC_ATTR_NAME8' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'LOC_ATTR_NAME9' ATTR_NAME,
             'LOC_ATTR_NAME9' DB_COL_NAME,
             'LOC_ATTR_NAME9' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'LOC_ATTR_NAME10' ATTR_NAME,
             'LOC_ATTR_NAME10' DB_COL_NAME,
             'LOC_ATTR_NAME10' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'LOC_ATTR_NAME11' ATTR_NAME,
             'LOC_ATTR_NAME11' DB_COL_NAME,
             'LOC_ATTR_NAME11' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'LOC_ATTR_NAME12' ATTR_NAME,
             'LOC_ATTR_NAME12' DB_COL_NAME,
             'LOC_ATTR_NAME12' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'LOC_ATTR_NAME13' ATTR_NAME,
             'LOC_ATTR_NAME13' DB_COL_NAME,
             'LOC_ATTR_NAME13' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'LOC_ATTR_NAME14' ATTR_NAME,
             'LOC_ATTR_NAME14' DB_COL_NAME,
             'LOC_ATTR_NAME14' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'LOC_ATTR_NAME15' ATTR_NAME,
             'LOC_ATTR_NAME15' DB_COL_NAME,
             'LOC_ATTR_NAME15' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'LOC_ATTR_NAME16' ATTR_NAME,
             'LOC_ATTR_NAME16' DB_COL_NAME,
             'LOC_ATTR_NAME16' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'LOC_ATTR_NAME17' ATTR_NAME,
             'LOC_ATTR_NAME17' DB_COL_NAME,
             'LOC_ATTR_NAME17' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'LOC_ATTR_NAME18' ATTR_NAME,
             'LOC_ATTR_NAME18' DB_COL_NAME,
             'LOC_ATTR_NAME18' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'LOC_ATTR_NAME19' ATTR_NAME,
             'LOC_ATTR_NAME19' DB_COL_NAME,
             'LOC_ATTR_NAME19' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'LOC_ATTR_NAME20' ATTR_NAME,
             'LOC_ATTR_NAME20' DB_COL_NAME,
             'LOC_ATTR_NAME20' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE_ID' ATTR_NAME,
             'LOC_ATTR_VALUE_ID' DB_COL_NAME,
             'LOC_ATTR_VALUE_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_ID' ATTR_NAME,
             'LOC_ATTR_ID' DB_COL_NAME,
             'LOC_ATTR_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE1' ATTR_NAME,
             'LOC_ATTR_VALUE1' DB_COL_NAME,
             'LOC_ATTR_VALUE1' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE2' ATTR_NAME,
             'LOC_ATTR_VALUE2' DB_COL_NAME,
             'LOC_ATTR_VALUE2' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE3' ATTR_NAME,
             'LOC_ATTR_VALUE3' DB_COL_NAME,
             'LOC_ATTR_VALUE3' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE4' ATTR_NAME,
             'LOC_ATTR_VALUE4' DB_COL_NAME,
             'LOC_ATTR_VALUE4' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE5' ATTR_NAME,
             'LOC_ATTR_VALUE5' DB_COL_NAME,
             'LOC_ATTR_VALUE5' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE6' ATTR_NAME,
             'LOC_ATTR_VALUE6' DB_COL_NAME,
             'LOC_ATTR_VALUE6' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE7' ATTR_NAME,
             'LOC_ATTR_VALUE7' DB_COL_NAME,
             'LOC_ATTR_VALUE7' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE8' ATTR_NAME,
             'LOC_ATTR_VALUE8' DB_COL_NAME,
             'LOC_ATTR_VALUE8' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE9' ATTR_NAME,
             'LOC_ATTR_VALUE9' DB_COL_NAME,
             'LOC_ATTR_VALUE9' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE10' ATTR_NAME,
             'LOC_ATTR_VALUE10' DB_COL_NAME,
             'LOC_ATTR_VALUE10' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE11' ATTR_NAME,
             'LOC_ATTR_VALUE11' DB_COL_NAME,
             'LOC_ATTR_VALUE11' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE12' ATTR_NAME,
             'LOC_ATTR_VALUE12' DB_COL_NAME,
             'LOC_ATTR_VALUE12' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE13' ATTR_NAME,
             'LOC_ATTR_VALUE13' DB_COL_NAME,
             'LOC_ATTR_VALUE13' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE14' ATTR_NAME,
             'LOC_ATTR_VALUE14' DB_COL_NAME,
             'LOC_ATTR_VALUE14' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE15' ATTR_NAME,
             'LOC_ATTR_VALUE15' DB_COL_NAME,
             'LOC_ATTR_VALUE15' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE16' ATTR_NAME,
             'LOC_ATTR_VALUE16' DB_COL_NAME,
             'LOC_ATTR_VALUE16' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE17' ATTR_NAME,
             'LOC_ATTR_VALUE17' DB_COL_NAME,
             'LOC_ATTR_VALUE17' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE18' ATTR_NAME,
             'LOC_ATTR_VALUE18' DB_COL_NAME,
             'LOC_ATTR_VALUE18' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE19' ATTR_NAME,
             'LOC_ATTR_VALUE19' DB_COL_NAME,
             'LOC_ATTR_VALUE19' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE20' ATTR_NAME,
             'LOC_ATTR_VALUE20' DB_COL_NAME,
             'LOC_ATTR_VALUE20' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      
      UNION ALL
      SELECT 'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'COMMON_ID' ATTR_NAME,
             'COMMON_ID' DB_COL_NAME,
             'COMMON_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'COMMON_CODE' ATTR_NAME,
             'COMMON_CODE' DB_COL_NAME,
             'COMMON_CODE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'COMMON_VALUE' ATTR_NAME,
             'COMMON_VALUE' DB_COL_NAME,
             'COMMON_VALUE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'COMMON_DESC' ATTR_NAME,
             'COMMON_DESC' DB_COL_NAME,
             'COMMON_DESC' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'PO_ALLOCATE_ID' ATTR_NAME,
             'PO_ALLOCATE_ID' DB_COL_NAME,
             'PO_ALLOCATE_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'PO_NUMBER' ATTR_NAME,
             'PO_NUMBER' DB_COL_NAME,
             'PO_NUMBER' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'PO_ALLOCATE_DATE' ATTR_NAME,
             'PO_ALLOCATE_DATE' DB_COL_NAME,
             'PO_ALLOCATE_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'PO_ALLOCATE_NAME' ATTR_NAME,
             'PO_ALLOCATE_NAME' DB_COL_NAME,
             'PO_ALLOCATE_NAME' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' ATTR_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' DB_COL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'PO_RELEASE_ID' ATTR_NAME,
             'PO_RELEASE_ID' DB_COL_NAME,
             'PO_RELEASE_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'PO_ALLOCATE_ID' ATTR_NAME,
             'PO_ALLOCATE_ID' DB_COL_NAME,
             'PO_ALLOCATE_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'PO_ALLOCATE_DATE' ATTR_NAME,
             'PO_ALLOCATE_DATE' DB_COL_NAME,
             'PO_ALLOCATE_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'PO_ALLOCATE_NAME' ATTR_NAME,
             'PO_ALLOCATE_NAME' DB_COL_NAME,
             'PO_ALLOCATE_NAME' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' ATTR_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' DB_COL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PO_BD_ID' ATTR_NAME,
             'PO_BD_ID' DB_COL_NAME,
             'PO_BD_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PO_NUMBER' ATTR_NAME,
             'PO_NUMBER' DB_COL_NAME,
             'PO_NUMBER' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PO_BD_DATE' ATTR_NAME,
             'PO_BD_DATE' DB_COL_NAME,
             'PO_BD_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PO_BD_NAME' ATTR_NAME,
             'PO_BD_NAME' DB_COL_NAME,
             'PO_BD_NAME' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' ATTR_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' DB_COL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PO_BD_RELEASE_ID' ATTR_NAME,
             'PO_BD_RELEASE_ID' DB_COL_NAME,
             'PO_BD_RELEASE_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PO_BD_ID' ATTR_NAME,
             'PO_BD_ID' DB_COL_NAME,
             'PO_BD_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PO_BD_RELEASE_DATE' ATTR_NAME,
             'PO_BD_RELEASE_DATE' DB_COL_NAME,
             'PO_BD_RELEASE_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PO_BD_RELEASE_NAME' ATTR_NAME,
             'PO_BD_RELEASE_NAME' DB_COL_NAME,
             'PO_BD_RELEASE_NAME' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' ATTR_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' DB_COL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'ASN_ALLOCATE_ID' ATTR_NAME,
             'ASN_ALLOCATE_ID' DB_COL_NAME,
             'ASN_ALLOCATE_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'ASN_NUMBER' ATTR_NAME,
             'ASN_NUMBER' DB_COL_NAME,
             'ASN_NUMBER' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'ASN_ALLOCATE_DATE' ATTR_NAME,
             'ASN_ALLOCATE_DATE' DB_COL_NAME,
             'ASN_ALLOCATE_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'ASN_ALLOCATE_NAME' ATTR_NAME,
             'ASN_ALLOCATE_NAME' DB_COL_NAME,
             'ASN_ALLOCATE_NAME' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' ATTR_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' DB_COL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'ASN_RELEASE_ID' ATTR_NAME,
             'ASN_RELEASE_ID' DB_COL_NAME,
             'ASN_RELEASE_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'ASN_ALLOCATE_ID' ATTR_NAME,
             'ASN_ALLOCATE_ID' DB_COL_NAME,
             'ASN_ALLOCATE_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'ASN_ALLOCATE_DATE' ATTR_NAME,
             'ASN_ALLOCATE_DATE' DB_COL_NAME,
             'ASN_ALLOCATE_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'ASN_ALLOCATE_NAME' ATTR_NAME,
             'ASN_ALLOCATE_NAME' DB_COL_NAME,
             'ASN_ALLOCATE_NAME' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' ATTR_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' DB_COL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'ASN_BD_ID' ATTR_NAME,
             'ASN_BD_ID' DB_COL_NAME,
             'ASN_BD_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'ASN_NUMBER' ATTR_NAME,
             'ASN_NUMBER' DB_COL_NAME,
             'ASN_NUMBER' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'ASN_BD_DATE' ATTR_NAME,
             'ASN_BD_DATE' DB_COL_NAME,
             'ASN_BD_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'ASN_BD_NAME' ATTR_NAME,
             'ASN_BD_NAME' DB_COL_NAME,
             'ASN_BD_NAME' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' ATTR_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' DB_COL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'ASN_BD_RELEASE_ID' ATTR_NAME,
             'ASN_BD_RELEASE_ID' DB_COL_NAME,
             'ASN_BD_RELEASE_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'ASN_BD_ID' ATTR_NAME,
             'ASN_BD_ID' DB_COL_NAME,
             'ASN_BD_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'ASN_BD_RELEASE_DATE' ATTR_NAME,
             'ASN_BD_RELEASE_DATE' DB_COL_NAME,
             'ASN_BD_RELEASE_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'ASN_BD_RELEASE_NAME' ATTR_NAME,
             'ASN_BD_RELEASE_NAME' DB_COL_NAME,
             'ASN_BD_RELEASE_NAME' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' ATTR_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' DB_COL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'RECEIVER_ALLOCATE_ID' ATTR_NAME,
             'RECEIVER_ALLOCATE_ID' DB_COL_NAME,
             'RECEIVER_ALLOCATE_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'RECEIVER_NUMBER' ATTR_NAME,
             'RECEIVER_NUMBER' DB_COL_NAME,
             'RECEIVER_NUMBER' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'RECEIVER_ALLOCATE_DATE' ATTR_NAME,
             'RECEIVER_ALLOCATE_DATE' DB_COL_NAME,
             'RECEIVER_ALLOCATE_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'RECEIVER_ALLOCATE_NAME' ATTR_NAME,
             'RECEIVER_ALLOCATE_NAME' DB_COL_NAME,
             'RECEIVER_ALLOCATE_NAME' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' ATTR_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' DB_COL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'RECEIVER_RELEASE_ID' ATTR_NAME,
             'RECEIVER_RELEASE_ID' DB_COL_NAME,
             'RECEIVER_RELEASE_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'RECEIVER_ALLOCATE_ID' ATTR_NAME,
             'RECEIVER_ALLOCATE_ID' DB_COL_NAME,
             'RECEIVER_ALLOCATE_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'RECEIVER_ALLOCATE_DATE' ATTR_NAME,
             'RECEIVER_ALLOCATE_DATE' DB_COL_NAME,
             'RECEIVER_ALLOCATE_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'RECEIVER_ALLOCATE_NAME' ATTR_NAME,
             'RECEIVER_ALLOCATE_NAME' DB_COL_NAME,
             'RECEIVER_ALLOCATE_NAME' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' ATTR_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' DB_COL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'RECEIVER_BD_ID' ATTR_NAME,
             'RECEIVER_BD_ID' DB_COL_NAME,
             'RECEIVER_BD_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'RECEIVER_NUMBER' ATTR_NAME,
             'RECEIVER_NUMBER' DB_COL_NAME,
             'RECEIVER_NUMBER' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'RECEIVER_BD_DATE' ATTR_NAME,
             'RECEIVER_BD_DATE' DB_COL_NAME,
             'RECEIVER_BD_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'RECEIVER_BD_NAME' ATTR_NAME,
             'RECEIVER_BD_NAME' DB_COL_NAME,
             'RECEIVER_BD_NAME' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' ATTR_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' DB_COL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'RECEIVER_BD_RELEASE_ID' ATTR_NAME,
             'RECEIVER_BD_RELEASE_ID' DB_COL_NAME,
             'RECEIVER_BD_RELEASE_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'RECEIVER_BD_ID' ATTR_NAME,
             'RECEIVER_BD_ID' DB_COL_NAME,
             'RECEIVER_BD_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'RECEIVER_BD_RELEASE_DATE' ATTR_NAME,
             'RECEIVER_BD_RELEASE_DATE' DB_COL_NAME,
             'RECEIVER_BD_RELEASE_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'RECEIVER_BD_RELEASE_NAME' ATTR_NAME,
             'RECEIVER_BD_RELEASE_NAME' DB_COL_NAME,
             'RECEIVER_BD_RELEASE_NAME' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' ATTR_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' DB_COL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      
      UNION ALL
      SELECT 'ALLOCATION_REFERENCE' DIM_NAME,
             'ALLOCATION_REFERENCE' LEVEL_NAME,
             'ALLOCATION_REFERENCE_ID' ATTR_NAME,
             'ALLOCATION_REFERENCE_ID' DB_COL_NAME,
             'ALLOCATION_REFERENCE_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ALLOCATION_REFERENCE' DIM_NAME,
             'ALLOCATION_REFERENCE' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ALLOCATION_REFERENCE' DIM_NAME,
             'ALLOCATION_REFERENCE' LEVEL_NAME,
             'PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ALLOCATION_REFERENCE' DIM_NAME,
             'ALLOCATION_REFERENCE' LEVEL_NAME,
             'LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ALLOCATION_REFERENCE' DIM_NAME,
             'ALLOCATION_REFERENCE' LEVEL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' ATTR_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' DB_COL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ALLOCATION_REFERENCE' DIM_NAME,
             'ALLOCATION_REFERENCE' LEVEL_NAME,
             'ALLOCATION_SETTING_BK' ATTR_NAME,
             'ALLOCATION_SETTING_BK' DB_COL_NAME,
             'ALLOCATION_SETTING_BK' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'CRITERIA_GROUP' DIM_NAME,
             'CRITERIA_GROUP' LEVEL_NAME,
             'CRITERIA_GROUP_ID' ATTR_NAME,
             'CRITERIA_GROUP_ID' DB_COL_NAME,
             'CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'CRITERIA_GROUP' DIM_NAME,
             'CRITERIA_GROUP' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'CRITERIA_GROUP' DIM_NAME,
             'CRITERIA_GROUP' LEVEL_NAME,
             'DIMENSION' ATTR_NAME,
             'DIMENSION' DB_COL_NAME,
             'DIMENSION' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'CRITERIA_GROUP' DIM_NAME,
             'CRITERIA_GROUP' LEVEL_NAME,
             'DW_START_DATE' ATTR_NAME,
             'DW_START_DATE' DB_COL_NAME,
             'DW_START_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'CRITERIA_GROUP' DIM_NAME,
             'CRITERIA_GROUP' LEVEL_NAME,
             'DW_END_DATE' ATTR_NAME,
             'DW_END_DATE' DB_COL_NAME,
             'DW_END_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'CRITERIA_GROUP' DIM_NAME,
             'CRITERIA_GROUP' LEVEL_NAME,
             'DW_VERSION' ATTR_NAME,
             'DW_VERSION' DB_COL_NAME,
             'DW_VERSION' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'CRITERIA_GROUP' DIM_NAME,
             'CRITERIA_GROUP' LEVEL_NAME,
             'DW_CURRFLAG' ATTR_NAME,
             'DW_CURRFLAG' DB_COL_NAME,
             'DW_CURRFLAG' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'CRITERIA_GROUP' DIM_NAME,
             'CRITERIA_GROUP' LEVEL_NAME,
             'HIERARCHY' ATTR_NAME,
             'HIERARCHY' DB_COL_NAME,
             'HIERARCHY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_MATRIX' DIM_NAME,
             'TRANSFER_MATRIX' LEVEL_NAME,
             'TRANSFER_MATRIX_ID' ATTR_NAME,
             'TRANSFER_MATRIX_ID' DB_COL_NAME,
             'TRANSFER_MATRIX_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_MATRIX' DIM_NAME,
             'TRANSFER_MATRIX' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_MATRIX' DIM_NAME,
             'TRANSFER_MATRIX' LEVEL_NAME,
             'PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_MATRIX' DIM_NAME,
             'TRANSFER_MATRIX' LEVEL_NAME,
             'LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_MATRIX' DIM_NAME,
             'TRANSFER_MATRIX' LEVEL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' ATTR_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' DB_COL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_MATRIX' DIM_NAME,
             'TRANSFER_MATRIX' LEVEL_NAME,
             'BASE_UNITS_BK' ATTR_NAME,
             'BASE_UNITS_BK' DB_COL_NAME,
             'BASE_UNITS_BK' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_PRIORITY' DIM_NAME,
             'TRANSFER_PRIORITY' LEVEL_NAME,
             'TRANSFER_PRIORITY_ID' ATTR_NAME,
             'TRANSFER_PRIORITY_ID' DB_COL_NAME,
             'TRANSFER_PRIORITY_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_PRIORITY' DIM_NAME,
             'TRANSFER_PRIORITY' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_PRIORITY' DIM_NAME,
             'TRANSFER_PRIORITY' LEVEL_NAME,
             'NAME' ATTR_NAME,
             'NAME' DB_COL_NAME,
             'NAME' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_PRIORITY' DIM_NAME,
             'TRANSFER_PRIORITY' LEVEL_NAME,
             'PRIORITY1' ATTR_NAME,
             'PRIORITY1' DB_COL_NAME,
             'PRIORITY1' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_PRIORITY' DIM_NAME,
             'TRANSFER_PRIORITY' LEVEL_NAME,
             'PRIORITY2' ATTR_NAME,
             'PRIORITY2' DB_COL_NAME,
             'PRIORITY2' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_PRIORITY' DIM_NAME,
             'TRANSFER_PRIORITY' LEVEL_NAME,
             'PRIORITY3' ATTR_NAME,
             'PRIORITY3' DB_COL_NAME,
             'PRIORITY3' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_PRIORITY' DIM_NAME,
             'TRANSFER_PRIORITY' LEVEL_NAME,
             'PRIORITY4' ATTR_NAME,
             'PRIORITY4' DB_COL_NAME,
             'PRIORITY4' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_PRIORITY' DIM_NAME,
             'TRANSFER_PRIORITY' LEVEL_NAME,
             'PRIORITY5' ATTR_NAME,
             'PRIORITY5' DB_COL_NAME,
             'PRIORITY5' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_PRIORITY' DIM_NAME,
             'TRANSFER_PRIORITY' LEVEL_NAME,
             'PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_PRIORITY' DIM_NAME,
             'TRANSFER_PRIORITY' LEVEL_NAME,
             'LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_PRIORITY' DIM_NAME,
             'TRANSFER_PRIORITY' LEVEL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' ATTR_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' DB_COL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_PRIORITY' DIM_NAME,
             'TRANSFER_PRIORITY' LEVEL_NAME,
             'PRIORITY_TYPE' ATTR_NAME,
             'PRIORITY_TYPE' DB_COL_NAME,
             'PRIORITY_TYPE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_PRIORITY' DIM_NAME,
             'TRANSFER_PRIORITY' LEVEL_NAME,
             'DW_START_DATE' ATTR_NAME,
             'DW_START_DATE' DB_COL_NAME,
             'DW_START_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_PRIORITY' DIM_NAME,
             'TRANSFER_PRIORITY' LEVEL_NAME,
             'DW_END_DATE' ATTR_NAME,
             'DW_END_DATE' DB_COL_NAME,
             'DW_END_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_PRIORITY' DIM_NAME,
             'TRANSFER_PRIORITY' LEVEL_NAME,
             'DW_VERSION' ATTR_NAME,
             'DW_VERSION' DB_COL_NAME,
             'DW_VERSION' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_PRIORITY' DIM_NAME,
             'TRANSFER_PRIORITY' LEVEL_NAME,
             'DW_CURRFLAG' ATTR_NAME,
             'DW_CURRFLAG' DB_COL_NAME,
             'DW_CURRFLAG' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RULE' DIM_NAME,
             'TRANSFER_RULE' LEVEL_NAME,
             'RULE_ID' ATTR_NAME,
             'RULE_ID' DB_COL_NAME,
             'RULE_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RULE' DIM_NAME,
             'TRANSFER_RULE' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RULE' DIM_NAME,
             'TRANSFER_RULE' LEVEL_NAME,
             'PARENT_SOURCE_BUSKEY' ATTR_NAME,
             'PARENT_SOURCE_BUSKEY' DB_COL_NAME,
             'PARENT_SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RULE' DIM_NAME,
             'TRANSFER_RULE' LEVEL_NAME,
             'NAME' ATTR_NAME,
             'NAME' DB_COL_NAME,
             'NAME' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RULE' DIM_NAME,
             'TRANSFER_RULE' LEVEL_NAME,
             'RULE_TYPE' ATTR_NAME,
             'RULE_TYPE' DB_COL_NAME,
             'RULE_TYPE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RULE' DIM_NAME,
             'TRANSFER_RULE' LEVEL_NAME,
             'START_DATE' ATTR_NAME,
             'START_DATE' DB_COL_NAME,
             'START_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RULE' DIM_NAME,
             'TRANSFER_RULE' LEVEL_NAME,
             'END_DATE' ATTR_NAME,
             'END_DATE' DB_COL_NAME,
             'END_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RULE' DIM_NAME,
             'TRANSFER_RULE' LEVEL_NAME,
             'WEEKS_NOT_ALLOWED_OUT' ATTR_NAME,
             'WEEKS_NOT_ALLOWED_OUT' DB_COL_NAME,
             'WEEKS_NOT_ALLOWED_OUT' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RULE' DIM_NAME,
             'TRANSFER_RULE' LEVEL_NAME,
             'WEEKS_TO_BE_MAINTAINED' ATTR_NAME,
             'WEEKS_TO_BE_MAINTAINED' DB_COL_NAME,
             'WEEKS_TO_BE_MAINTAINED' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RULE' DIM_NAME,
             'TRANSFER_RULE' LEVEL_NAME,
             'WEEKS_OF_PREV_SALES' ATTR_NAME,
             'WEEKS_OF_PREV_SALES' DB_COL_NAME,
             'WEEKS_OF_PREV_SALES' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RULE' DIM_NAME,
             'TRANSFER_RULE' LEVEL_NAME,
             'WEEKS_PRIOR_CURR_DATE' ATTR_NAME,
             'WEEKS_PRIOR_CURR_DATE' DB_COL_NAME,
             'WEEKS_PRIOR_CURR_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RULE' DIM_NAME,
             'TRANSFER_RULE' LEVEL_NAME,
             'SUPPLY_PERCENT' ATTR_NAME,
             'SUPPLY_PERCENT' DB_COL_NAME,
             'SUPPLY_PERCENT' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RULE' DIM_NAME,
             'TRANSFER_RULE' LEVEL_NAME,
             'WEEKS_NOT_SOLD' ATTR_NAME,
             'WEEKS_NOT_SOLD' DB_COL_NAME,
             'WEEKS_NOT_SOLD' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RULE' DIM_NAME,
             'TRANSFER_RULE' LEVEL_NAME,
             'IS_CHECK_RECEIPT_CUMULATIVE' ATTR_NAME,
             'IS_CHECK_RECEIPT_CUMULATIVE' DB_COL_NAME,
             'IS_CHECK_RECEIPT_CUMULATIVE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RULE' DIM_NAME,
             'TRANSFER_RULE' LEVEL_NAME,
             'WEEKS_AFTER_FIRST_RECEIPT' ATTR_NAME,
             'WEEKS_AFTER_FIRST_RECEIPT' DB_COL_NAME,
             'WEEKS_AFTER_FIRST_RECEIPT' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RULE' DIM_NAME,
             'TRANSFER_RULE' LEVEL_NAME,
             'CUMULATIVE_PERCENT' ATTR_NAME,
             'CUMULATIVE_PERCENT' DB_COL_NAME,
             'CUMULATIVE_PERCENT' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RULE' DIM_NAME,
             'TRANSFER_RULE' LEVEL_NAME,
             'PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RULE' DIM_NAME,
             'TRANSFER_RULE' LEVEL_NAME,
             'LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RULE' DIM_NAME,
             'TRANSFER_RULE' LEVEL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' ATTR_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' DB_COL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RULE' DIM_NAME,
             'TRANSFER_RULE' LEVEL_NAME,
             'DW_START_DATE' ATTR_NAME,
             'DW_START_DATE' DB_COL_NAME,
             'DW_START_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RULE' DIM_NAME,
             'TRANSFER_RULE' LEVEL_NAME,
             'DW_END_DATE' ATTR_NAME,
             'DW_END_DATE' DB_COL_NAME,
             'DW_END_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RULE' DIM_NAME,
             'TRANSFER_RULE' LEVEL_NAME,
             'DW_VERSION' ATTR_NAME,
             'DW_VERSION' DB_COL_NAME,
             'DW_VERSION' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RULE' DIM_NAME,
             'TRANSFER_RULE' LEVEL_NAME,
             'DW_CURRFLAG' ATTR_NAME,
             'DW_CURRFLAG' DB_COL_NAME,
             'DW_CURRFLAG' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'AUDIT' DIM_NAME,
             'AUDIT' LEVEL_NAME,
             'AUDIT_ID' ATTR_NAME,
             'AUDIT_ID' DB_COL_NAME,
             'AUDIT_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'AUDIT' DIM_NAME,
             'AUDIT' LEVEL_NAME,
             'DW_SOURCE' ATTR_NAME,
             'DW_SOURCE' DB_COL_NAME,
             'DW_SOURCE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'AUDIT' DIM_NAME,
             'AUDIT' LEVEL_NAME,
             'DW_UPDATE_USER' ATTR_NAME,
             'DW_UPDATE_USER' DB_COL_NAME,
             'DW_UPDATE_USER' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'AUDIT' DIM_NAME,
             'AUDIT' LEVEL_NAME,
             'DW_UPDATE_DATE' ATTR_NAME,
             'DW_UPDATE_DATE' DB_COL_NAME,
             'DW_UPDATE_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'AUDIT' DIM_NAME,
             'AUDIT' LEVEL_NAME,
             'DW_NUM_REC_LOADED' ATTR_NAME,
             'DW_NUM_REC_LOADED' DB_COL_NAME,
             'DW_NUM_REC_LOADED' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'AUDIT' DIM_NAME,
             'AUDIT' LEVEL_NAME,
             'DW_NUM_REC_REJECTED' ATTR_NAME,
             'DW_NUM_REC_REJECTED' DB_COL_NAME,
             'DW_NUM_REC_REJECTED' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'SPREAD_DC' DIM_NAME,
             'SPREAD_DC' LEVEL_NAME,
             'TRANSFER_SPREAD_DC_ID' ATTR_NAME,
             'TRANSFER_SPREAD_DC_ID' DB_COL_NAME,
             'TRANSFER_SPREAD_DC_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'SPREAD_DC' DIM_NAME,
             'SPREAD_DC' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'SPREAD_DC' DIM_NAME,
             'SPREAD_DC' LEVEL_NAME,
             'SPREAD_DC_DATE' ATTR_NAME,
             'SPREAD_DC_DATE' DB_COL_NAME,
             'SPREAD_DC_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'SPREAD_DC' DIM_NAME,
             'SPREAD_DC' LEVEL_NAME,
             'SPREAD_DC_DT' ATTR_NAME,
             'SPREAD_DC_DT' DB_COL_NAME,
             'SPREAD_DC_DT' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'SPREAD_DC' DIM_NAME,
             'SPREAD_DC' LEVEL_NAME,
             'SPREAD_DC_NAME' ATTR_NAME,
             'SPREAD_DC_NAME' DB_COL_NAME,
             'SPREAD_DC_NAME' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'SPREAD_DC' DIM_NAME,
             'SPREAD_DC' LEVEL_NAME,
             'PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'SPREAD_DC' DIM_NAME,
             'SPREAD_DC' LEVEL_NAME,
             'LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_FORECAST' DIM_NAME,
             'TRANSFER_FORECAST' LEVEL_NAME,
             'TRANSFER_FORECAST_ID' ATTR_NAME,
             'TRANSFER_FORECAST_ID' DB_COL_NAME,
             'TRANSFER_FORECAST_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_FORECAST' DIM_NAME,
             'TRANSFER_FORECAST' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_FORECAST' DIM_NAME,
             'TRANSFER_FORECAST' LEVEL_NAME,
             'FORECAST_DATE' ATTR_NAME,
             'FORECAST_DATE' DB_COL_NAME,
             'FORECAST_DATE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_FORECAST' DIM_NAME,
             'TRANSFER_FORECAST' LEVEL_NAME,
             'FORECAST_DT' ATTR_NAME,
             'FORECAST_DT' DB_COL_NAME,
             'FORECAST_DT' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_FORECAST' DIM_NAME,
             'TRANSFER_FORECAST' LEVEL_NAME,
             'FORECAST_NAME' ATTR_NAME,
             'FORECAST_NAME' DB_COL_NAME,
             'FORECAST_NAME' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_FORECAST' DIM_NAME,
             'TRANSFER_FORECAST' LEVEL_NAME,
             'PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_FORECAST' DIM_NAME,
             'TRANSFER_FORECAST' LEVEL_NAME,
             'LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'BOXSTYLE' DIM_NAME,
             'BOXSTYLE' LEVEL_NAME,
             'BOXSTYLE_ID' ATTR_NAME,
             'BOXSTYLE_ID' DB_COL_NAME,
             'BOXSTYLE_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'BOXSTYLE' DIM_NAME,
             'BOXSTYLE' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'BOXSTYLE' DIM_NAME,
             'BOXSTYLE' LEVEL_NAME,
             'PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'BOXSTYLE' DIM_NAME,
             'BOXSTYLE' LEVEL_NAME,
             'LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'BOXSTYLE' DIM_NAME,
             'BOXSTYLE' LEVEL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' ATTR_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' DB_COL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'BOXSTYLE' DIM_NAME,
             'BOXSTYLE' LEVEL_NAME,
             'BASE_UNITS_BK' ATTR_NAME,
             'BASE_UNITS_BK' DB_COL_NAME,
             'BASE_UNITS_BK' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'CORE_SIZE' DIM_NAME,
             'CORE_SIZE' LEVEL_NAME,
             'CORE_SIZE_ID' ATTR_NAME,
             'CORE_SIZE_ID' DB_COL_NAME,
             'CORE_SIZE_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'CORE_SIZE' DIM_NAME,
             'CORE_SIZE' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'CORE_SIZE' DIM_NAME,
             'CORE_SIZE' LEVEL_NAME,
             'PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'CORE_SIZE' DIM_NAME,
             'CORE_SIZE' LEVEL_NAME,
             'LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'CORE_SIZE' DIM_NAME,
             'CORE_SIZE' LEVEL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' ATTR_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' DB_COL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'CORE_SIZE' DIM_NAME,
             'CORE_SIZE' LEVEL_NAME,
             'BASE_UNITS_BK' ATTR_NAME,
             'BASE_UNITS_BK' DB_COL_NAME,
             'BASE_UNITS_BK' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_SCOPE' DIM_NAME,
             'PROMOTION_SCOPE' LEVEL_NAME,
             'PROMOTION_SCOPE_ID' ATTR_NAME,
             'PROMOTION_SCOPE_ID' DB_COL_NAME,
             'PROMOTION_SCOPE_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_SCOPE' DIM_NAME,
             'PROMOTION_SCOPE' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_SCOPE' DIM_NAME,
             'PROMOTION_SCOPE' LEVEL_NAME,
             'PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_SCOPE' DIM_NAME,
             'PROMOTION_SCOPE' LEVEL_NAME,
             'LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_SCOPE' DIM_NAME,
             'PROMOTION_SCOPE' LEVEL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' ATTR_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' DB_COL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_SCOPE' DIM_NAME,
             'PROMOTION_SCOPE' LEVEL_NAME,
             'SETTING_VALUE_BK' ATTR_NAME,
             'SETTING_VALUE_BK' DB_COL_NAME,
             'SETTING_VALUE_BK' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'MIN_MAX' DIM_NAME,
             'MIN_MAX' LEVEL_NAME,
             'MIN_MAX_ID' ATTR_NAME,
             'MIN_MAX_ID' DB_COL_NAME,
             'MIN_MAX_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'MIN_MAX' DIM_NAME,
             'MIN_MAX' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'MIN_MAX' DIM_NAME,
             'MIN_MAX' LEVEL_NAME,
             'PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'MIN_MAX' DIM_NAME,
             'MIN_MAX' LEVEL_NAME,
             'LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'MIN_MAX' DIM_NAME,
             'MIN_MAX' LEVEL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' ATTR_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' DB_COL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'MIN_MAX' DIM_NAME,
             'MIN_MAX' LEVEL_NAME,
             'BASE_UNITS_BK' ATTR_NAME,
             'BASE_UNITS_BK' DB_COL_NAME,
             'BASE_UNITS_BK' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'CLUSTER_SEQUENCE' DIM_NAME,
             'CLUSTER_SEQUENCE' LEVEL_NAME,
             'CLUSTER_SEQUENCE_ID' ATTR_NAME,
             'CLUSTER_SEQUENCE_ID' DB_COL_NAME,
             'CLUSTER_SEQUENCE_ID' BUSINESS_DESC,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'CLUSTER_SEQUENCE' DIM_NAME,
             'CLUSTER_SEQUENCE' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'CLUSTER_SEQUENCE' DIM_NAME,
             'CLUSTER_SEQUENCE' LEVEL_NAME,
             'CLUSTER_NAME' ATTR_NAME,
             'CLUSTER_NAME' DB_COL_NAME,
             'CLUSTER_NAME' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'CLUSTER_SEQUENCE' DIM_NAME,
             'CLUSTER_SEQUENCE' LEVEL_NAME,
             'SEQUENCE' ATTR_NAME,
             'SEQUENCE' DB_COL_NAME,
             'SEQUENCE' BUSINESS_DESC,
             'Y' VISABLE
        FROM DUAL;
  
    --POPULATE ATTRIBUTES' BUSINESS DESCRIPTION
    FORALL I IN 1 .. L_KEY_VAL_CACHE.COUNT
      UPDATE META_DIM_LEVEL_ATTRS T
         SET T.BUSINESS_DESC = L_KEY_VAL_CACHE(I).VAL
       WHERE T.DIM_NAME || C_DELIMITER || T.LEVEL_NAME || C_DELIMITER ||
             T.ATTR_NAME = L_KEY_VAL_CACHE(I).KEY;
  
    COMMIT;
  END POP_DIM_LEVEL_ATTRS;

  PROCEDURE POP_DIM_HIERARCHIES IS
  BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE META_DIM_HIERARCHIES';
  
    INSERT INTO META_DIM_HIERARCHIES
      (DIM_NAME, HIERARCHY_NAME, DB_TAB_NAME, BUSINESS_DESC)
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'CALENDAR_YMD' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'CALENDAR_YWD' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YM' HIERARCHY_NAME,
             'V_DIM_TIME_CALENDAR_YM' DB_TAB_NAME,
             'CALENDAR_YM' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YW' HIERARCHY_NAME,
             'V_DIM_TIME_CALENDAR_YW' DB_TAB_NAME,
             'CALENDAR_YW' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'ISO_YWD' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YW' HIERARCHY_NAME,
             'V_DIM_TIME_ISO_YW' DB_TAB_NAME,
             'ISO_YWD' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YM' HIERARCHY_NAME,
             'V_DIM_TIME_7TH_YM' DB_TAB_NAME,
             '7TH_YM' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             '7TH_YMD' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YW' HIERARCHY_NAME,
             'V_DIM_TIME_7TH_YW' DB_TAB_NAME,
             '7TH_YW' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             '7TH_YWD' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             '7TH_YMSWP' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             '7TH_YWSWP' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'PRIMARY_SIZE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'PRIMARY_GP' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'V_DIM_YEARSEASON_PRIMARY_STYLE' DB_TAB_NAME,
             'PRIMARY_STYLE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_STORE' HIERARCHY_NAME,
             'V_STORE_PRIMARY_STORE' DB_TAB_NAME,
             'PRIMARY_STORE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIERARCHY_NAME,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'PRIMARY_DETAIL' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'PRIMARY_SIZE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'PRIMARY_GP' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'V_DIM_PROMO_PRIMARY_PROMOTION' DB_TAB_NAME,
             'PRIMARY' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'PAV_VALUE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'LAV_VALUE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'V_DIM_PO_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PO PRIMARY BREADDOWN RELEASE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'V_DIM_PO_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PO PRIMARY ALLOCATE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'PO PRIMARY RELEASE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'V_DIM_ASN_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'ASN PRIMARY BREADDOWN RELEASE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'V_DIM_ASN_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'ASN PRIMARY ALLOCATE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'ASN PRIMARY RELEASE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'V_DIM_REC_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'RECEIVER PRIMARY BREADDOWN RELEASE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'V_DIM_REC_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'RECEIVER PRIMARY ALLOCATE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'RECEIVER PRIMARY RELEASE' BUSINESS_DESC
        FROM DUAL;
  
    COMMIT;
  END POP_DIM_HIERARCHIES;

  PROCEDURE POP_DIM_HIER_LEVELS IS
  BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE META_DIM_HIER_LEVELS';
  
    INSERT INTO META_DIM_HIER_LEVELS
    --CALENDAR_YMD
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             1 LEVEL_ID,
             'Y' TOP,
             'N' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_DATE_CYEAR' DB_TAB_NAME,
             'CYEAR_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             2 LEVEL_ID,
             'N' TOP,
             'N' BOTTOM,
             'CALENDAR_YEAR' PARENT_LEVEL_NAME,
             'DIM_DATE_MONTH' DB_TAB_NAME,
             'MONTH_ID' DB_KEY_COL_NAME,
             'CYEAR_ID' DB_JOIN_COL_NAME,
             'DIM_DATE_CYEAR' DB_PARENT_TAB_NAME,
             'CYEAR_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'DAY' LEVEL_NAME,
             3 LEVEL_ID,
             'N' TOP,
             'Y' BOTTOM,
             'CALENDAR_MONTH' PARENT_LEVEL_NAME,
             'DIM_DATE_DAY' DB_TAB_NAME,
             'DATE_ID' DB_KEY_COL_NAME,
             'MONTH_ID' DB_JOIN_COL_NAME,
             'DIM_DATE_MONTH' DB_PARENT_TAB_NAME,
             'MONTH_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      --CALENDAR_YM
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YM' HIERARCHY_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             1 LEVEL_ID,
             'Y' TOP,
             'N' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_DATE_CYEAR' DB_TAB_NAME,
             'CYEAR_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YM' HIERARCHY_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             2 LEVEL_ID,
             'N' TOP,
             'Y' BOTTOM,
             'CALENDAR_YEAR' PARENT_LEVEL_NAME,
             'DIM_DATE_MONTH' DB_TAB_NAME,
             'MONTH_ID' DB_KEY_COL_NAME,
             'CYEAR_ID' DB_JOIN_COL_NAME,
             'DIM_DATE_CYEAR' DB_PARENT_TAB_NAME,
             'CYEAR_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      --CALENDAR_YWD
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             1 LEVEL_ID,
             'Y' TOP,
             'N' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_DATE_CYEAR' DB_TAB_NAME,
             'CYEAR_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             2 LEVEL_ID,
             'N' TOP,
             'N' BOTTOM,
             'CALENDAR_YEAR' PARENT_LEVEL_NAME,
             'DIM_DATE_WEEK' DB_TAB_NAME,
             'CWEEK_ID' DB_KEY_COL_NAME,
             'CYEAR_ID' DB_JOIN_COL_NAME,
             'DIM_DATE_CYEAR' DB_PARENT_TAB_NAME,
             'CYEAR_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'DAY' LEVEL_NAME,
             3 LEVEL_ID,
             'N' TOP,
             'Y' BOTTOM,
             'CALENDAR_WEEK' PARENT_LEVEL_NAME,
             'DIM_DATE_DAY' DB_TAB_NAME,
             'DATE_ID' DB_KEY_COL_NAME,
             'CWEEK_ID' DB_JOIN_COL_NAME,
             'DIM_DATE_CWEEK' DB_PARENT_TAB_NAME,
             'CWEEK_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      --ISO_YWD
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'ISO_YEAR' LEVEL_NAME,
             1 LEVEL_ID,
             'Y' TOP,
             'N' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_DATE_IYEAR' DB_TAB_NAME,
             'IYEAR_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'ISO_WEEK' LEVEL_NAME,
             2 LEVEL_ID,
             'N' TOP,
             'N' BOTTOM,
             'ISO_YEAR' PARENT_LEVEL_NAME,
             'DIM_DATE_IWEEK' DB_TAB_NAME,
             'IWEEK_ID' DB_KEY_COL_NAME,
             'IYEAR_ID' DB_JOIN_COL_NAME,
             'DIM_DATE_IYEAR' DB_PARENT_TAB_NAME,
             'IYEAR_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'DAY' LEVEL_NAME,
             3 LEVEL_ID,
             'N' TOP,
             'Y' BOTTOM,
             'ISO_WEEK' PARENT_LEVEL_NAME,
             'DIM_DATE_DAY' DB_TAB_NAME,
             'DAY_ID' DB_KEY_COL_NAME,
             'IWEEK_ID' DB_JOIN_COL_NAME,
             'DIM_DATE_IWEEK' DB_PARENT_TAB_NAME,
             'IWEEK_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      --ISO_YW
      SELECT 'DATE' DIM_NAME,
             'ISO_YW' HIERARCHY_NAME,
             'ISO_YEAR' LEVEL_NAME,
             1 LEVEL_ID,
             'Y' TOP,
             'N' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_DATE_IYEAR' DB_TAB_NAME,
             'IYEAR_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YW' HIERARCHY_NAME,
             'ISO_WEEK' LEVEL_NAME,
             2 LEVEL_ID,
             'N' TOP,
             'Y' BOTTOM,
             'ISO_YEAR' PARENT_LEVEL_NAME,
             'DIM_DATE_IWEEK' DB_TAB_NAME,
             'IWEEK_ID' DB_KEY_COL_NAME,
             'IYEAR_ID' DB_JOIN_COL_NAME,
             'DIM_DATE_IYEAR' DB_PARENT_TAB_NAME,
             'IYEAR_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      --7TH_YM
      SELECT 'DATE' DIM_NAME,
             '7TH_YM' HIERARCHY_NAME,
             '7TH_MYEAR' LEVEL_NAME,
             1 LEVEL_ID,
             'Y' TOP,
             'N' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_DATE_SMYEAR' DB_TAB_NAME,
             'SMYEAR_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YM' HIERARCHY_NAME,
             '7TH_MONTH' LEVEL_NAME,
             2 LEVEL_ID,
             'N' TOP,
             'Y' BOTTOM,
             '7TH_MYEAR' PARENT_LEVEL_NAME,
             'DIM_DATE_SMONTH' DB_TAB_NAME,
             'SMONTH_ID' DB_KEY_COL_NAME,
             'SMYEAR_ID' DB_JOIN_COL_NAME,
             'DIM_DATE_SMYEAR' DB_PARENT_TAB_NAME,
             'SMYEAR_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      --7TH_YW
      SELECT 'DATE' DIM_NAME,
             '7TH_YW' HIERARCHY_NAME,
             '7TH_WYEAR' LEVEL_NAME,
             1 LEVEL_ID,
             'Y' TOP,
             'N' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_DATE_SWYEAR' DB_TAB_NAME,
             'SWYEAR_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YW' HIERARCHY_NAME,
             '7TH_WEEK' LEVEL_NAME,
             2 LEVEL_ID,
             'N' TOP,
             'Y' BOTTOM,
             '7TH_WYEAR' PARENT_LEVEL_NAME,
             'DIM_DATE_SWEEK' DB_TAB_NAME,
             'SWEEK_ID' DB_KEY_COL_NAME,
             'SWYEAR_ID' DB_JOIN_COL_NAME,
             'DIM_DATE_SWYEAR' DB_PARENT_TAB_NAME,
             'SWYEAR_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      
      --7TH_YMD
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             '7TH_MYEAR' LEVEL_NAME,
             1 LEVEL_ID,
             'Y' TOP,
             'N' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_DATE_SMYEAR' DB_TAB_NAME,
             'SMYEAR_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             '7TH_MONTH' LEVEL_NAME,
             2 LEVEL_ID,
             'N' TOP,
             'N' BOTTOM,
             '7TH_MYEAR' PARENT_LEVEL_NAME,
             'DIM_DATE_SMONTH' DB_TAB_NAME,
             'SMONTH_ID' DB_KEY_COL_NAME,
             'SMYEAR_ID' DB_JOIN_COL_NAME,
             'DIM_DATE_SMYEAR' DB_PARENT_TAB_NAME,
             'SMYEAR_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             3 LEVEL_ID,
             'N' TOP,
             'N' BOTTOM,
             '7TH_MONTH' PARENT_LEVEL_NAME,
             'DIM_DATE_SWEEK_PART' DB_TAB_NAME,
             'SWEEK_PART_ID' DB_KEY_COL_NAME,
             'SMONTH_ID' DB_JOIN_COL_NAME,
             'DIM_DATE_SMONTH' DB_PARENT_TAB_NAME,
             'SMONTH_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'DAY' LEVEL_NAME,
             4 LEVEL_ID,
             'N' TOP,
             'Y' BOTTOM,
             '7TH_WEEK_PART' PARENT_LEVEL_NAME,
             'DIM_DATE_DAY' DB_TAB_NAME,
             'DATE_ID' DB_KEY_COL_NAME,
             'SWEEK_PART_ID' DB_JOIN_COL_NAME,
             'DIM_DATE_SWEEK_PART' DB_PARENT_TAB_NAME,
             'SWEEK_PART_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      
      --7TH_YWD
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             '7TH_WYEAR' LEVEL_NAME,
             1 LEVEL_ID,
             'Y' TOP,
             'N' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_DATE_SWYEAR' DB_TAB_NAME,
             'SWYEAR_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             '7TH_WEEK' LEVEL_NAME,
             2 LEVEL_ID,
             'N' TOP,
             'N' BOTTOM,
             '7TH_WYEAR' PARENT_LEVEL_NAME,
             'DIM_DATE_SWEEK' DB_TAB_NAME,
             'SWEEK_ID' DB_KEY_COL_NAME,
             'SWYEAR_ID' DB_JOIN_COL_NAME,
             'DIM_DATE_SWYEAR' DB_PARENT_TAB_NAME,
             'SWYEAR_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             3 LEVEL_ID,
             'N' TOP,
             'N' BOTTOM,
             '7TH_WEEK' PARENT_LEVEL_NAME,
             'DIM_DATE_SWEEK_PART' DB_TAB_NAME,
             'SWEEK_PART_ID' DB_KEY_COL_NAME,
             'SWEEK_ID' DB_JOIN_COL_NAME,
             'DIM_DATE_SWEEK' DB_PARENT_TAB_NAME,
             'SWEEK_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'DAY' LEVEL_NAME,
             4 LEVEL_ID,
             'N' TOP,
             'Y' BOTTOM,
             '7TH_WEEK_PART' PARENT_LEVEL_NAME,
             'DIM_DATE_DAY' DB_TAB_NAME,
             'DATE_ID' DB_KEY_COL_NAME,
             'SWEEK_PART_ID' DB_JOIN_COL_NAME,
             'DIM_DATE_SWEEK_PART' DB_PARENT_TAB_NAME,
             'SWEEK_PART_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      --7TH_YMSWP
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             '7TH_MYEAR' LEVEL_NAME,
             1 LEVEL_ID,
             'Y' TOP,
             'N' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_DATE_SMYEAR' DB_TAB_NAME,
             'SMYEAR_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             '7TH_MONTH' LEVEL_NAME,
             2 LEVEL_ID,
             'N' TOP,
             'N' BOTTOM,
             '7TH_MYEAR' PARENT_LEVEL_NAME,
             'DIM_DATE_SMONTH' DB_TAB_NAME,
             'SMONTH_ID' DB_KEY_COL_NAME,
             'SMYEAR_ID' DB_JOIN_COL_NAME,
             'DIM_DATE_SMYEAR' DB_PARENT_TAB_NAME,
             'SMYEAR_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             3 LEVEL_ID,
             'N' TOP,
             'Y' BOTTOM,
             '7TH_MONTH' PARENT_LEVEL_NAME,
             'DIM_DATE_SWEEK_PART' DB_TAB_NAME,
             'SWEEK_PART_ID' DB_KEY_COL_NAME,
             'SMONTH_ID' DB_JOIN_COL_NAME,
             'DIM_DATE_SMONTH' DB_PARENT_TAB_NAME,
             'SMONTH_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      --7TH_YWSWP
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             '7TH_WYEAR' LEVEL_NAME,
             1 LEVEL_ID,
             'Y' TOP,
             'N' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_DATE_SWYEAR' DB_TAB_NAME,
             'SWYEAR_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             '7TH_WEEK' LEVEL_NAME,
             2 LEVEL_ID,
             'N' TOP,
             'N' BOTTOM,
             '7TH_WYEAR' PARENT_LEVEL_NAME,
             'DIM_DATE_SWEEK' DB_TAB_NAME,
             'SWEEK_ID' DB_KEY_COL_NAME,
             'SWYEAR_ID' DB_JOIN_COL_NAME,
             'DIM_DATE_SWYEAR' DB_PARENT_TAB_NAME,
             'SWYEAR_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             3 LEVEL_ID,
             'N' TOP,
             'Y' BOTTOM,
             '7TH_WEEK' PARENT_LEVEL_NAME,
             'DIM_DATE_SWEEK_PART' DB_TAB_NAME,
             'SWEEK_PART_ID' DB_KEY_COL_NAME,
             'SWEEK_ID' DB_JOIN_COL_NAME,
             'DIM_DATE_SWEEK' DB_PARENT_TAB_NAME,
             'SWEEK_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      --STYLE:PRIMARY_SIZE
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'DEPT' LEVEL_NAME,
             1 LEVEL_ID,
             'Y' TOP,
             'N' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_DEPT' DB_TAB_NAME,
             'DEPT_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'STYLE' LEVEL_NAME,
             2 LEVEL_ID,
             'N' TOP,
             'N' BOTTOM,
             'DEPT' PARENT_LEVEL_NAME,
             'DIM_STYLE' DB_TAB_NAME,
             'STYLE_ID' DB_KEY_COL_NAME,
             'DEPT_ID' DB_JOIN_COL_NAME,
             'DIM_DEPT' DB_PARENT_TAB_NAME,
             'DEPT_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             3 LEVEL_ID,
             'N' TOP,
             'N' BOTTOM,
             'STYLE' PARENT_LEVEL_NAME,
             'DIM_STYLE_COLOR' DB_TAB_NAME,
             'STYLE_COLOR_ID' DB_KEY_COL_NAME,
             'STYLE_ID' DB_JOIN_COL_NAME,
             'DIM_STYLE' DB_PARENT_TAB_NAME,
             'STYLE_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             4 LEVEL_ID,
             'N' TOP,
             'Y' BOTTOM,
             'STYLE_COLOR' PARENT_LEVEL_NAME,
             'DIM_STYLE_COLOR_SIZE' DB_TAB_NAME,
             'STYLE_COLOR_SIZE_ID' DB_KEY_COL_NAME,
             'STYLE_COLOR_ID' DB_JOIN_COL_NAME,
             'DIM_STYLE_COLOR' DB_PARENT_TAB_NAME,
             'STYLE_COLOR_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      --STYLE:PRIMARY_GP
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'DEPT' LEVEL_NAME,
             1 LEVEL_ID,
             'Y' TOP,
             'N' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_DEPT' DB_TAB_NAME,
             'DEPT_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'STYLE' LEVEL_NAME,
             2 LEVEL_ID,
             'N' TOP,
             'N' BOTTOM,
             'DEPT' PARENT_LEVEL_NAME,
             'DIM_STYLE' DB_TAB_NAME,
             'STYLE_ID' DB_KEY_COL_NAME,
             'DEPT_ID' DB_JOIN_COL_NAME,
             'DIM_DEPT' DB_PARENT_TAB_NAME,
             'DEPT_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             3 LEVEL_ID,
             'N' TOP,
             'N' BOTTOM,
             'STYLE' PARENT_LEVEL_NAME,
             'DIM_STYLE_COLOR' DB_TAB_NAME,
             'STYLE_COLOR_ID' DB_KEY_COL_NAME,
             'STYLE_ID' DB_JOIN_COL_NAME,
             'DIM_STYLE' DB_PARENT_TAB_NAME,
             'STYLE_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             4 LEVEL_ID,
             'N' TOP,
             'N' BOTTOM,
             'STYLE_COLOR' PARENT_LEVEL_NAME,
             'DIM_STYLE_COLOR_SIZE' DB_TAB_NAME,
             'STYLE_COLOR_SIZE_ID' DB_KEY_COL_NAME,
             'STYLE_COLOR_ID' DB_JOIN_COL_NAME,
             'DIM_STYLE_COLOR' DB_PARENT_TAB_NAME,
             'STYLE_COLOR_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             5 LEVEL_ID,
             'N' TOP,
             'Y' BOTTOM,
             'STYLE_COLOR_SIZE' PARENT_LEVEL_NAME,
             'DIM_STYLE_COLOR_SIZE_GP' DB_TAB_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_ID' DB_JOIN_COL_NAME,
             'DIM_STYLE_COLOR' DB_PARENT_TAB_NAME,
             'STYLE_COLOR_SIZE_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      
      --STYLE:SECONDARY_SIZE
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'VENDOR' LEVEL_NAME,
             1 LEVEL_ID,
             'Y' TOP,
             'N' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_VENDOR' DB_TAB_NAME,
             'VENDOR_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'STYLE' LEVEL_NAME,
             2 LEVEL_ID,
             'N' TOP,
             'N' BOTTOM,
             'VENDOR' PARENT_LEVEL_NAME,
             'DIM_STYLE' DB_TAB_NAME,
             'STYLE_ID' DB_KEY_COL_NAME,
             'VENDOR_ID' DB_JOIN_COL_NAME,
             'DIM_VENDOR' DB_PARENT_TAB_NAME,
             'VENDOR_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             3 LEVEL_ID,
             'N' TOP,
             'N' BOTTOM,
             'STYLE' PARENT_LEVEL_NAME,
             'DIM_STYLE_COLOR' DB_TAB_NAME,
             'STYLE_COLOR_ID' DB_KEY_COL_NAME,
             'STYLE_ID' DB_JOIN_COL_NAME,
             'DIM_STYLE' DB_PARENT_TAB_NAME,
             'STYLE_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             4 LEVEL_ID,
             'N' TOP,
             'Y' BOTTOM,
             'STYLE_COLOR' PARENT_LEVEL_NAME,
             'DIM_STYLE_COLOR_SIZE' DB_TAB_NAME,
             'STYLE_COLOR_SIZE_ID' DB_KEY_COL_NAME,
             'STYLE_COLOR_ID' DB_JOIN_COL_NAME,
             'DIM_STYLE_COLOR' DB_PARENT_TAB_NAME,
             'STYLE_COLOR_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      --STYLE:SECONDARY_GP
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'VENDOR' LEVEL_NAME,
             1 LEVEL_ID,
             'Y' TOP,
             'N' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_VENDOR' DB_TAB_NAME,
             'VENDOR_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'STYLE' LEVEL_NAME,
             2 LEVEL_ID,
             'N' TOP,
             'N' BOTTOM,
             'VENDOR' PARENT_LEVEL_NAME,
             'DIM_STYLE' DB_TAB_NAME,
             'STYLE_ID' DB_KEY_COL_NAME,
             'VENDOR_ID' DB_JOIN_COL_NAME,
             'DIM_VENDOR' DB_PARENT_TAB_NAME,
             'VENDOR_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             3 LEVEL_ID,
             'N' TOP,
             'N' BOTTOM,
             'STYLE' PARENT_LEVEL_NAME,
             'DIM_STYLE_COLOR' DB_TAB_NAME,
             'STYLE_COLOR_ID' DB_KEY_COL_NAME,
             'STYLE_ID' DB_JOIN_COL_NAME,
             'DIM_STYLE' DB_PARENT_TAB_NAME,
             'STYLE_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             4 LEVEL_ID,
             'N' TOP,
             'N' BOTTOM,
             'STYLE_COLOR' PARENT_LEVEL_NAME,
             'DIM_STYLE_COLOR_SIZE' DB_TAB_NAME,
             'STYLE_COLOR_SIZE_ID' DB_KEY_COL_NAME,
             'STYLE_COLOR_ID' DB_JOIN_COL_NAME,
             'DIM_STYLE_COLOR' DB_PARENT_TAB_NAME,
             'STYLE_COLOR_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             5 LEVEL_ID,
             'N' TOP,
             'Y' BOTTOM,
             'STYLE_COLOR_SIZE' PARENT_LEVEL_NAME,
             'DIM_STYLE_COLOR_SIZE_GP' DB_TAB_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_ID' DB_JOIN_COL_NAME,
             'DIM_STYLE_COLOR' DB_PARENT_TAB_NAME,
             'STYLE_COLOR_SIZE_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      
      --YEAR_SEASON:PRIMARY_STYLE
      SELECT 'YEAR_SEASON' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             1 LEVEL_ID,
             'Y' TOP,
             'N' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_YEAR_SEASON' DB_TAB_NAME,
             'YEAR_SEASON_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'STYLE_YEAR_SEASON' LEVEL_NAME,
             2 LEVEL_ID,
             'N' TOP,
             'Y' BOTTOM,
             'YEAR_SEASON' PARENT_LEVEL_NAME,
             'DIM_STYLE_YEAR_SEASON' DB_TAB_NAME,
             'STYLE_YEAR_SEASON_ID' DB_KEY_COL_NAME,
             'REAL_YEAR_SEASON_ID' DB_JOIN_COL_NAME,
             'DIM_YEAR_SEASON' DB_PARENT_TAB_NAME,
             'YEAR_SEASON_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_STORE' HIERARCHY_NAME,
             'COUNTRY' LEVEL_NAME,
             1 LEVEL_ID,
             'Y' TOP,
             'N' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_STORE_LOC' DB_TAB_NAME,
             'STORE_LOC_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_STORE' HIERARCHY_NAME,
             'DC' LEVEL_NAME,
             2 LEVEL_ID,
             'N' TOP,
             'N' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_STORE_LOC' DB_TAB_NAME,
             'STORE_LOC_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_STORE' HIERARCHY_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             3 LEVEL_ID,
             'N' TOP,
             'N' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_STORE_LOC' DB_TAB_NAME,
             'STORE_LOC_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_STORE' HIERARCHY_NAME,
             'STORE' LEVEL_NAME,
             4 LEVEL_ID,
             'N' TOP,
             'Y' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_STORE_LOC' DB_TAB_NAME,
             'STORE_LOC_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIERARCHY_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             1 LEVEL_ID,
             'Y' TOP,
             'Y' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'STORE_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'SALES_STYLE' LEVEL_NAME,
             1 LEVEL_ID,
             'Y' TOP,
             'N' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_SALES_STYLE' DB_TAB_NAME,
             'SALES_STYLE_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'PROMOTION' LEVEL_NAME,
             2 LEVEL_ID,
             'N' TOP,
             'Y' BOTTOM,
             'SALES_STYLE' PARENT_LEVEL_NAME,
             'DIM_PROMOTION' DB_TAB_NAME,
             'PROMOTION_ID' DB_KEY_COL_NAME,
             'SALES_STYLE_ID' DB_JOIN_COL_NAME,
             'DIM_SALES_STYLE' DB_PARENT_TAB_NAME,
             'SALES_STYLE_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'PROD_ATTR' LEVEL_NAME,
             1 LEVEL_ID,
             'Y' TOP,
             'N' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_PROD_ATTR' DB_TAB_NAME,
             'PROD_ATTR_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             2 LEVEL_ID,
             'N' TOP,
             'Y' BOTTOM,
             'PROD_ATTR' PARENT_LEVEL_NAME,
             'DIM_PROD_ATTR_VALUE' DB_TAB_NAME,
             'PROD_ATTR_VALUE_ID' DB_KEY_COL_NAME,
             'PROD_ATTR_ID' DB_JOIN_COL_NAME,
             'DIM_PROD_ATTR' DB_PARENT_TAB_NAME,
             'PROD_ATTR_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'LOC_ATTR' LEVEL_NAME,
             1 LEVEL_ID,
             'Y' TOP,
             'N' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_LOC_ATTR' DB_TAB_NAME,
             'LOC_ATTR_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             2 LEVEL_ID,
             'N' TOP,
             'Y' BOTTOM,
             'LOC_ATTR' PARENT_LEVEL_NAME,
             'DIM_LOC_ATTR_VALUE' DB_TAB_NAME,
             'LOC_ATTR_VALUE_ID' DB_KEY_COL_NAME,
             'LOC_ATTR_ID' DB_JOIN_COL_NAME,
             'DIM_LOC_ATTR' DB_PARENT_TAB_NAME,
             'LOC_ATTR_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'BREAKDOWN' LEVEL_NAME,
             1 LEVEL_ID,
             'Y' TOP,
             'N' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_PO_BD' DB_TAB_NAME,
             'PO_BD_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             2 LEVEL_ID,
             'N' TOP,
             'Y' BOTTOM,
             'BREAKDOWN' PARENT_LEVEL_NAME,
             'DIM_PO_BD_RELEASE' DB_TAB_NAME,
             'PO_BD_RELEASE_ID' DB_KEY_COL_NAME,
             'PO_BD_ID' DB_JOIN_COL_NAME,
             'DIM_PO_BD' DB_PARENT_TAB_NAME,
             'PO_BD_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'BREAKDOWN' LEVEL_NAME,
             1 LEVEL_ID,
             'Y' TOP,
             'N' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_ASN_BD' DB_TAB_NAME,
             'PO_ASN_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             2 LEVEL_ID,
             'N' TOP,
             'Y' BOTTOM,
             'BREAKDOWN' PARENT_LEVEL_NAME,
             'DIM_ASN_BD_RELEASE' DB_TAB_NAME,
             'ASN_BD_RELEASE_ID' DB_KEY_COL_NAME,
             'ASN_BD_ID' DB_JOIN_COL_NAME,
             'DIM_ASN_BD' DB_PARENT_TAB_NAME,
             'ASN_BD_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'BREAKDOWN' LEVEL_NAME,
             1 LEVEL_ID,
             'Y' TOP,
             'N' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_RECEIVER_BD' DB_TAB_NAME,
             'RECEIVER_ASN_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             2 LEVEL_ID,
             'N' TOP,
             'Y' BOTTOM,
             'BREAKDOWN' PARENT_LEVEL_NAME,
             'DIM_RECEIVER_BD_RELEASE' DB_TAB_NAME,
             'RECEIVER_BD_RELEASE_ID' DB_KEY_COL_NAME,
             'RECEIVER_BD_ID' DB_JOIN_COL_NAME,
             'DIM_RECEIVER_BD' DB_PARENT_TAB_NAME,
             'RECEIVER_BD_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'BREAKDOWN' LEVEL_NAME,
             1 LEVEL_ID,
             'Y' TOP,
             'N' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_PO_BD' DB_TAB_NAME,
             'PO_BD_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             2 LEVEL_ID,
             'N' TOP,
             'N' BOTTOM,
             'BREAKDOWN' PARENT_LEVEL_NAME,
             'DIM_PO_BD_RELEASE' DB_TAB_NAME,
             'PO_BD_RELEASE_ID' DB_KEY_COL_NAME,
             'PO_BD_ID' DB_JOIN_COL_NAME,
             'DIM_PO_BD' DB_PARENT_TAB_NAME,
             'PO_BD_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'ALLOCATE' LEVEL_NAME,
             3 LEVEL_ID,
             'N' TOP,
             'Y' BOTTOM,
             'BREAKDOWN_RELEASE' PARENT_LEVEL_NAME,
             'DIM_PO_ALLOCATE' DB_TAB_NAME,
             'PO_ALLOCATE_ID' DB_KEY_COL_NAME,
             'PO_ALLOCATE_ID' DB_JOIN_COL_NAME,
             'DIM_PO_BD_RELEASE' DB_PARENT_TAB_NAME,
             'PO_BD_RELEASE_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'BREAKDOWN' LEVEL_NAME,
             1 LEVEL_ID,
             'Y' TOP,
             'N' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_ASN_BD' DB_TAB_NAME,
             'ASN_BD_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             2 LEVEL_ID,
             'N' TOP,
             'N' BOTTOM,
             'BREAKDOWN' PARENT_LEVEL_NAME,
             'DIM_ASN_BD_RELEASE' DB_TAB_NAME,
             'ASN_BD_RELEASE_ID' DB_KEY_COL_NAME,
             'ASN_BD_ID' DB_JOIN_COL_NAME,
             'DIM_ASN_BD' DB_PARENT_TAB_NAME,
             'ASN_BD_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'ALLOCATE' LEVEL_NAME,
             3 LEVEL_ID,
             'N' TOP,
             'Y' BOTTOM,
             'BREAKDOWN_RELEASE' PARENT_LEVEL_NAME,
             'DIM_ASN_ALLOCATE' DB_TAB_NAME,
             'ASN_ALLOCATE_ID' DB_KEY_COL_NAME,
             'ASN_ALLOCATE_ID' DB_JOIN_COL_NAME,
             'DIM_ASN_BD_RELEASE' DB_PARENT_TAB_NAME,
             'ASN_BD_RELEASE_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'BREAKDOWN' LEVEL_NAME,
             1 LEVEL_ID,
             'Y' TOP,
             'N' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_RECEIVER_BD' DB_TAB_NAME,
             'RECEIVER_BD_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             2 LEVEL_ID,
             'N' TOP,
             'N' BOTTOM,
             'BREAKDOWN' PARENT_LEVEL_NAME,
             'DIM_RECEIVER_BD_RELEASE' DB_TAB_NAME,
             'RECEIVER_BD_RELEASE_ID' DB_KEY_COL_NAME,
             'RECEIVER_BD_ID' DB_JOIN_COL_NAME,
             'DIM_RECEIVER_BD' DB_PARENT_TAB_NAME,
             'RECEIVER_BD_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'ALLOCATE' LEVEL_NAME,
             3 LEVEL_ID,
             'N' TOP,
             'Y' BOTTOM,
             'BREAKDOWN_RELEASE' PARENT_LEVEL_NAME,
             'DIM_RECEIVER_ALLOCATE' DB_TAB_NAME,
             'RECEIVER_ALLOCATE_ID' DB_KEY_COL_NAME,
             'RECEIVER_ALLOCATE_ID' DB_JOIN_COL_NAME,
             'DIM_RECEIVER_BD_RELEASE' DB_PARENT_TAB_NAME,
             'RECEIVER_BD_RELEASE_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'BREAKDOWN' LEVEL_NAME,
             1 LEVEL_ID,
             'Y' TOP,
             'N' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_PO_BD' DB_TAB_NAME,
             'PO_BD_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             2 LEVEL_ID,
             'N' TOP,
             'N' BOTTOM,
             'BREAKDOWN' PARENT_LEVEL_NAME,
             'DIM_PO_BD_RELEASE' DB_TAB_NAME,
             'PO_BD_RELEASE_ID' DB_KEY_COL_NAME,
             'PO_BD_ID' DB_JOIN_COL_NAME,
             'DIM_PO_BD' DB_PARENT_TAB_NAME,
             'PO_BD_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'ALLOCATE' LEVEL_NAME,
             3 LEVEL_ID,
             'N' TOP,
             'N' BOTTOM,
             'BREAKDOWN_RELEASE' PARENT_LEVEL_NAME,
             'DIM_PO_ALLOCATE' DB_TAB_NAME,
             'PO_ALLOCATE_ID' DB_KEY_COL_NAME,
             'PO_ALLOCATE_ID' DB_JOIN_COL_NAME,
             'DIM_PO_BD_RELEASE' DB_PARENT_TAB_NAME,
             'PO_BD_RELEASE_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'RELEASE' LEVEL_NAME,
             4 LEVEL_ID,
             'N' TOP,
             'Y' BOTTOM,
             'ALLOCATE' PARENT_LEVEL_NAME,
             'DIM_PO_RELEASE' DB_TAB_NAME,
             'PO_RELEASE_ID' DB_KEY_COL_NAME,
             'PO_ALLOCATE_ID' DB_JOIN_COL_NAME,
             'DIM_PO_ALLOCATE' DB_PARENT_TAB_NAME,
             'PO_ALLOCATE_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'BREAKDOWN' LEVEL_NAME,
             1 LEVEL_ID,
             'Y' TOP,
             'N' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_ASN_BD' DB_TAB_NAME,
             'ASN_BD_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             2 LEVEL_ID,
             'N' TOP,
             'N' BOTTOM,
             'BREAKDOWN' PARENT_LEVEL_NAME,
             'DIM_ASN_BD_RELEASE' DB_TAB_NAME,
             'ASN_BD_RELEASE_ID' DB_KEY_COL_NAME,
             'ASN_BD_ID' DB_JOIN_COL_NAME,
             'DIM_ASN_BD' DB_PARENT_TAB_NAME,
             'ASN_BD_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'ALLOCATE' LEVEL_NAME,
             3 LEVEL_ID,
             'N' TOP,
             'N' BOTTOM,
             'BREAKDOWN_RELEASE' PARENT_LEVEL_NAME,
             'DIM_ASN_ALLOCATE' DB_TAB_NAME,
             'ASN_ALLOCATE_ID' DB_KEY_COL_NAME,
             'ASN_ALLOCATE_ID' DB_JOIN_COL_NAME,
             'DIM_ASN_BD_RELEASE' DB_PARENT_TAB_NAME,
             'ASN_BD_RELEASE_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'RELEASE' LEVEL_NAME,
             4 LEVEL_ID,
             'N' TOP,
             'Y' BOTTOM,
             'ALLOCATE' PARENT_LEVEL_NAME,
             'DIM_ASN_RELEASE' DB_TAB_NAME,
             'ASN_RELEASE_ID' DB_KEY_COL_NAME,
             'ASN_ALLOCATE_ID' DB_JOIN_COL_NAME,
             'DIM_ASN_ALLOCATE' DB_PARENT_TAB_NAME,
             'ASN_ALLOCATE_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'BREAKDOWN' LEVEL_NAME,
             1 LEVEL_ID,
             'Y' TOP,
             'N' BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_RECEIVER_BD' DB_TAB_NAME,
             'RECEIVER_BD_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             2 LEVEL_ID,
             'N' TOP,
             'N' BOTTOM,
             'BREAKDOWN' PARENT_LEVEL_NAME,
             'DIM_RECEIVER_BD_RELEASE' DB_TAB_NAME,
             'RECEIVER_BD_RELEASE_ID' DB_KEY_COL_NAME,
             'RECEIVER_BD_ID' DB_JOIN_COL_NAME,
             'DIM_RECEIVER_BD' DB_PARENT_TAB_NAME,
             'RECEIVER_BD_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'ALLOCATE' LEVEL_NAME,
             3 LEVEL_ID,
             'N' TOP,
             'N' BOTTOM,
             'BREAKDOWN_RELEASE' PARENT_LEVEL_NAME,
             'DIM_RECEIVER_ALLOCATE' DB_TAB_NAME,
             'RECEIVER_ALLOCATE_ID' DB_KEY_COL_NAME,
             'RECEIVER_ALLOCATE_ID' DB_JOIN_COL_NAME,
             'DIM_RECEIVER_BD_RELEASE' DB_PARENT_TAB_NAME,
             'RECEIVER_BD_RELEASE_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'RELEASE' LEVEL_NAME,
             4 LEVEL_ID,
             'N' TOP,
             'Y' BOTTOM,
             'ALLOCATE' PARENT_LEVEL_NAME,
             'DIM_RECEIVER_RELEASE' DB_TAB_NAME,
             'RECEIVER_RELEASE_ID' DB_KEY_COL_NAME,
             'RECEIVER_ALLOCATE_ID' DB_JOIN_COL_NAME,
             'DIM_RECEIVER_ALLOCATE' DB_PARENT_TAB_NAME,
             'RECEIVER_ALLOCATE_ID' DB_PARENT_KEY_COL_NAME
        FROM DUAL;
  
    COMMIT;
  END POP_DIM_HIER_LEVELS;

  PROCEDURE POP_DIM_HIER_LEVEL_ATTRS IS
  BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE META_DIM_HIER_LEVEL_ATTRS';
    INSERT INTO META_DIM_HIER_LEVEL_ATTRS
      (DIM_NAME,
       HIERARCHY_NAME,
       ATTR_NAME,
       LEVEL_NAME,
       BUSINESS_DESC,
       DB_TAB_NAME,
       DB_COL_NAME,
       VISABLE)
    --STYLE:PRIMARY_GP
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'D_DEPT_ID' ATTR_NAME,
             'DEPT' LEVEL_NAME,
             'D_DEPT_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'D_DEPT_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'D_SOURCE_BUSKEY' ATTR_NAME,
             'DEPT' LEVEL_NAME,
             'D_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'D_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'D_TARGET_BUSKEY' ATTR_NAME,
             'DEPT' LEVEL_NAME,
             'D_TARGET_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'D_TARGET_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'D_DEPT_NUM' ATTR_NAME,
             'DEPT' LEVEL_NAME,
             'D_DEPT_NUM' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'D_DEPT_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'D_DEPT' ATTR_NAME,
             'DEPT' LEVEL_NAME,
             'D_DEPT' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'D_DEPT' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'D_DIVISION' ATTR_NAME,
             'DEPT' LEVEL_NAME,
             'D_DIVISION' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'D_DIVISION' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'D_CORPORATE_DIVISION' ATTR_NAME,
             'DEPT' LEVEL_NAME,
             'D_CORPORATE_DIVISION' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'D_CORPORATE_DIVISION' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'D_ORI_DEPT_ID' ATTR_NAME,
             'DEPT' LEVEL_NAME,
             'D_ORI_DEPT_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'D_ORI_DEPT_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_STYLE_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_STYLE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_STYLE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_SOURCE_BUSKEY' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_TARGET_BUSKEY' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_TARGET_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_TARGET_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_STYLE_NUMBER' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_STYLE_NUMBER' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_STYLE_NUMBER' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_DESCRIPTION' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_DESCRIPTION' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_DESCRIPTION' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_DEPT_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_DEPT_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_DEPT_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_VENDOR_NAME' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_VENDOR_NAME' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_VENDOR_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_SIZE_RANGE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_SIZE_RANGE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_SIZE_RANGE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_DEPT_TYPE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_DEPT_TYPE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_DEPT_TYPE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_DIVISION_TYPE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_DIVISION_TYPE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_DIVISION_TYPE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_CLASS_CODE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_CLASS_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_CLASS_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_CLASS' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_CLASS' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_CLASS' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_PRODUCT_CATEGORY' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_PRODUCT_CATEGORY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_PRODUCT_CATEGORY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_CATEGORY' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_CATEGORY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_CATEGORY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_PRODUCTION_TYPE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_PRODUCTION_TYPE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_PRODUCTION_TYPE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_FIBER_CONTENT' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_FIBER_CONTENT' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_FIBER_CONTENT' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_FABRICATION' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_FABRICATION' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_FABRICATION' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_PRODUCT_GROUP' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_PRODUCT_GROUP' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_PRODUCT_GROUP' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_RANGE_CODE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_RANGE_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_RANGE_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_COLLAR' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_COLLAR' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_COLLAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_SLEEVE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_SLEEVE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_SLEEVE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_LABEL_CODE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_LABEL_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_LABEL_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_TERM' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_TERM' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_TERM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_PRODUCT_CATEGORY_CODE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_PRODUCT_CATEGORY_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_PRODUCT_CATEGORY_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_SEASON_CODE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_SEASON_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_SEASON_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_PRODUCT_GROUP_CODE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_PRODUCT_GROUP_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_PRODUCT_GROUP_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_STYLE_REF_NUMBER' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_STYLE_REF_NUMBER' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_STYLE_REF_NUMBER' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_STYLE_NAME' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_STYLE_NAME' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_STYLE_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_SUB_CLASS' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_SUB_CLASS' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_SUB_CLASS' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_MINOR_CLASS' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_MINOR_CLASS' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_MINOR_CLASS' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_HANG_FOLD' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_HANG_FOLD' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_HANG_FOLD' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_YIELD' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_YIELD' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_YIELD' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_DISCONTINUE_DATE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_DISCONTINUE_DATE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_DISCONTINUE_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_CHANGE_DATE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_CHANGE_DATE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_CHANGE_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_REPLENISHMENT_IND' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_REPLENISHMENT_IND' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_REPLENISHMENT_IND' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_ORI_STYLE_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_ORI_STYLE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_ORI_STYLE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_ORI_COMPANY_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_ORI_COMPANY_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_ORI_COMPANY_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_ORI_BUYER_COMPANY_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_ORI_BUYER_COMPANY_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_ORI_BUYER_COMPANY_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_ORI_BUYER_CLASS_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_ORI_BUYER_CLASS_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_ORI_BUYER_CLASS_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_ORI_BUYER_SUBCLASS_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_ORI_BUYER_SUBCLASS_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_ORI_BUYER_SUBCLASS_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_ORI_MINOR_CLASS_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_ORI_MINOR_CLASS_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_ORI_MINOR_CLASS_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_ORI_PRODUCTION_TYPE_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_ORI_PRODUCTION_TYPE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_ORI_PRODUCTION_TYPE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_LOW_COST' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_LOW_COST' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_LOW_COST' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_LOW_RETAIL' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_LOW_RETAIL' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_LOW_RETAIL' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_STANDARD_COST' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_STANDARD_COST' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_STANDARD_COST' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_VENDOR_REF_NUMBER' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_VENDOR_REF_NUMBER' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_VENDOR_REF_NUMBER' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'S_STATUS' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_STATUS' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_STATUS' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SC_STYLE_COLOR_ID' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_STYLE_COLOR_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_STYLE_COLOR_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SC_SOURCE_BUSKEY' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SC_TARGET_BUSKEY' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_TARGET_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_TARGET_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SC_STYLE_ID' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_STYLE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_STYLE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SC_COLOR_NAME' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_COLOR_NAME' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_COLOR_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SC_COLOR_CODE' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_COLOR_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_COLOR_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SC_VENDOR_COLOR_CODE' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_VENDOR_COLOR_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_VENDOR_COLOR_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SC_COLOR_FAMILY' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_COLOR_FAMILY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_COLOR_FAMILY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SC_SHORT_COLOR_NAME' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_SHORT_COLOR_NAME' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_SHORT_COLOR_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SC_COLOR_GROUP' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_COLOR_GROUP' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_COLOR_GROUP' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SC_PATTERN' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_PATTERN' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_PATTERN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SC_ACCOUNT_EXCLUSIVE' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_ACCOUNT_EXCLUSIVE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_ACCOUNT_EXCLUSIVE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SC_START_SHIP_DATE' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_START_SHIP_DATE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_START_SHIP_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SC_PRODUCT_TEAM' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_PRODUCT_TEAM' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_PRODUCT_TEAM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SC_KEY_ITEM_INDICATOR' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_KEY_ITEM_INDICATOR' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_KEY_ITEM_INDICATOR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SC_PRODUCT_STOP_DATE' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_PRODUCT_STOP_DATE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_PRODUCT_STOP_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SC_OUTLET_STYLE_INDICATOR' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_OUTLET_STYLE_INDICATOR' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_OUTLET_STYLE_INDICATOR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SC_MULTI_CHANNEL_IND' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_MULTI_CHANNEL_IND' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_MULTI_CHANNEL_IND' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SC_ORI_STYLE_COLOR_ID' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_ORI_STYLE_COLOR_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_ORI_STYLE_COLOR_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SCS_STYLE_COLOR_SIZE_ID' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'SCS_STYLE_COLOR_SIZE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SCS_STYLE_COLOR_SIZE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SCS_SOURCE_BUSKEY' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'SCS_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SCS_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SCS_TARGET_BUSKEY' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'SCS_TARGET_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SCS_TARGET_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SCS_STYLE_COLOR_ID' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'SCS_STYLE_COLOR_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SCS_STYLE_COLOR_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SCS_SIZE_CODE' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'SCS_SIZE_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SCS_SIZE_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SCS_UPC' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'SCS_UPC' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SCS_UPC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SCS_ARTICLE_NUMBER' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'SCS_ARTICLE_NUMBER' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SCS_ARTICLE_NUMBER' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SCS_ORI_STYLE_SIZE_ID' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'SCS_ORI_STYLE_SIZE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SCS_ORI_STYLE_SIZE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'STYLE_COLOR_SIZE_GP_ID' ATTR_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'STYLE_COLOR_SIZE_GP_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'TARGET_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'TARGET_BUSKEY' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'GP_SIZE_ID' ATTR_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'GP_SIZE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'GP_SIZE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'STYLE_COLOR_SIZE_ID' ATTR_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'STYLE_COLOR_SIZE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'STYLE_COLOR_SIZE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'PREPACK_CODE' ATTR_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'PREPACK_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'PREPACK_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'PREPACK_TYPE' ATTR_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'PREPACK_TYPE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'PREPACK_TYPE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'GS_GP_SIZE_ID' ATTR_NAME,
             'GP_SIZE' LEVEL_NAME,
             'GS_GP_SIZE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'GS_GP_SIZE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'GS_SOURCE_BUSKEY' ATTR_NAME,
             'GP_SIZE' LEVEL_NAME,
             'GS_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'GS_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'GS_GP_GP_ID' ATTR_NAME,
             'GP_SIZE' LEVEL_NAME,
             'GS_GP_GP_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'GS_GP_GP_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'GS_SIZE_CODE' ATTR_NAME,
             'GP_SIZE' LEVEL_NAME,
             'GS_SIZE_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'GS_SIZE_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'GS_RATIO' ATTR_NAME,
             'GP_SIZE' LEVEL_NAME,
             'GS_RATIO' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'GS_RATIO' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'G_GP_GP_ID' ATTR_NAME,
             'GP' LEVEL_NAME,
             'G_GP_GP_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'G_GP_GP_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'G_SOURCE_BUSKEY' ATTR_NAME,
             'GP' LEVEL_NAME,
             'G_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'G_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'G_NAME' ATTR_NAME,
             'GP' LEVEL_NAME,
             'G_NAME' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'G_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SR_DEPT_ID' ATTR_NAME,
             'SIZE_RANGE' LEVEL_NAME,
             'SR_DEPT_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SR_DEPT_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SR_NAME' ATTR_NAME,
             'SIZE_RANGE' LEVEL_NAME,
             'SR_NAME' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SR_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SR_SIZE_RANGE_ID' ATTR_NAME,
             'SIZE_RANGE' LEVEL_NAME,
             'SR_SIZE_RANGE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SR_SIZE_RANGE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SR_SOURCE_BUSKEY' ATTR_NAME,
             'SIZE_RANGE' LEVEL_NAME,
             'SR_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SR_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SI_SIZE_NAME1' ATTR_NAME,
             'SIZE_ITEM' LEVEL_NAME,
             'SI_SIZE_NAME1' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SI_SIZE_NAME1' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SI_SIZE_NAME2' ATTR_NAME,
             'SIZE_ITEM' LEVEL_NAME,
             'SI_SIZE_NAME2' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SI_SIZE_NAME2' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SI_SIZE_SEQ1' ATTR_NAME,
             'SIZE_ITEM' LEVEL_NAME,
             'SI_SIZE_SEQ1' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SI_SIZE_SEQ1' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SI_SIZE_SEQ2' ATTR_NAME,
             'SIZE_ITEM' LEVEL_NAME,
             'SI_SIZE_SEQ2' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SI_SIZE_SEQ2' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_GP' HIERARCHY_NAME,
             'SI_CORE_SIZE_INDICATOR' ATTR_NAME,
             'SIZE_ITEM' LEVEL_NAME,
             'SI_CORE_SIZE_INDICATOR' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SI_CORE_SIZE_INDICATOR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      --STYLE:PRIMARY_SIZE
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'D_DEPT_ID' ATTR_NAME,
             'DEPT' LEVEL_NAME,
             'D_DEPT_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'D_DEPT_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'D_SOURCE_BUSKEY' ATTR_NAME,
             'DEPT' LEVEL_NAME,
             'D_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'D_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'D_TARGET_BUSKEY' ATTR_NAME,
             'DEPT' LEVEL_NAME,
             'D_TARGET_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'D_TARGET_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'D_DEPT_NUM' ATTR_NAME,
             'DEPT' LEVEL_NAME,
             'D_DEPT_NUM' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'D_DEPT_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'D_DEPT' ATTR_NAME,
             'DEPT' LEVEL_NAME,
             'D_DEPT' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'D_DEPT' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'D_DIVISION' ATTR_NAME,
             'DEPT' LEVEL_NAME,
             'D_DIVISION' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'D_DIVISION' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'D_CORPORATE_DIVISION' ATTR_NAME,
             'DEPT' LEVEL_NAME,
             'D_CORPORATE_DIVISION' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'D_CORPORATE_DIVISION' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'D_ORI_DEPT_ID' ATTR_NAME,
             'DEPT' LEVEL_NAME,
             'D_ORI_DEPT_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'D_ORI_DEPT_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_STYLE_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_STYLE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_STYLE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_SOURCE_BUSKEY' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_TARGET_BUSKEY' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_TARGET_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_TARGET_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_STYLE_NUMBER' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_STYLE_NUMBER' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_STYLE_NUMBER' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_DESCRIPTION' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_DESCRIPTION' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_DESCRIPTION' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_DEPT_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_DEPT_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_DEPT_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_VENDOR_NAME' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_VENDOR_NAME' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_VENDOR_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_SIZE_RANGE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_SIZE_RANGE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_SIZE_RANGE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_DEPT_TYPE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_DEPT_TYPE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_DEPT_TYPE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_DIVISION_TYPE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_DIVISION_TYPE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_DIVISION_TYPE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_CLASS_CODE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_CLASS_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_CLASS_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_CLASS' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_CLASS' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_CLASS' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_PRODUCT_CATEGORY' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_PRODUCT_CATEGORY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_PRODUCT_CATEGORY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_CATEGORY' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_CATEGORY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_CATEGORY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_PRODUCTION_TYPE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_PRODUCTION_TYPE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_PRODUCTION_TYPE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_FIBER_CONTENT' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_FIBER_CONTENT' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_FIBER_CONTENT' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_FABRICATION' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_FABRICATION' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_FABRICATION' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_PRODUCT_GROUP' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_PRODUCT_GROUP' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_PRODUCT_GROUP' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_RANGE_CODE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_RANGE_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_RANGE_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_COLLAR' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_COLLAR' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_COLLAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_SLEEVE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_SLEEVE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_SLEEVE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_LABEL_CODE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_LABEL_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_LABEL_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_TERM' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_TERM' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_TERM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_PRODUCT_CATEGORY_CODE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_PRODUCT_CATEGORY_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_PRODUCT_CATEGORY_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_SEASON_CODE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_SEASON_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_SEASON_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_PRODUCT_GROUP_CODE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_PRODUCT_GROUP_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_PRODUCT_GROUP_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_STYLE_REF_NUMBER' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_STYLE_REF_NUMBER' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_STYLE_REF_NUMBER' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_STYLE_NAME' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_STYLE_NAME' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_STYLE_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_SUB_CLASS' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_SUB_CLASS' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_SUB_CLASS' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_MINOR_CLASS' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_MINOR_CLASS' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_MINOR_CLASS' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_HANG_FOLD' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_HANG_FOLD' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_HANG_FOLD' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_YIELD' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_YIELD' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_YIELD' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_DISCONTINUE_DATE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_DISCONTINUE_DATE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_DISCONTINUE_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_CHANGE_DATE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_CHANGE_DATE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_CHANGE_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_REPLENISHMENT_IND' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_REPLENISHMENT_IND' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_REPLENISHMENT_IND' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_ORI_STYLE_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_ORI_STYLE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_ORI_STYLE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_ORI_COMPANY_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_ORI_COMPANY_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_ORI_COMPANY_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_ORI_BUYER_COMPANY_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_ORI_BUYER_COMPANY_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_ORI_BUYER_COMPANY_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_ORI_BUYER_CLASS_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_ORI_BUYER_CLASS_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_ORI_BUYER_CLASS_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_ORI_BUYER_SUBCLASS_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_ORI_BUYER_SUBCLASS_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_ORI_BUYER_SUBCLASS_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_ORI_MINOR_CLASS_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_ORI_MINOR_CLASS_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_ORI_MINOR_CLASS_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_ORI_PRODUCTION_TYPE_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_ORI_PRODUCTION_TYPE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_ORI_PRODUCTION_TYPE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_LOW_COST' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_LOW_COST' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_LOW_COST' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_LOW_RETAIL' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_LOW_RETAIL' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_LOW_RETAIL' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_STANDARD_COST' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_STANDARD_COST' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_STANDARD_COST' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_VENDOR_REF_NUMBER' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_VENDOR_REF_NUMBER' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_VENDOR_REF_NUMBER' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'S_STATUS' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_STATUS' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_STATUS' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'SC_STYLE_COLOR_ID' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_STYLE_COLOR_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_STYLE_COLOR_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'SC_SOURCE_BUSKEY' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'SC_TARGET_BUSKEY' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_TARGET_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_TARGET_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'SC_STYLE_ID' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_STYLE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_STYLE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'SC_COLOR_NAME' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_COLOR_NAME' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_COLOR_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'SC_COLOR_CODE' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_COLOR_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_COLOR_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'SC_VENDOR_COLOR_CODE' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_VENDOR_COLOR_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_VENDOR_COLOR_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'SC_COLOR_FAMILY' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_COLOR_FAMILY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_COLOR_FAMILY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'SC_SHORT_COLOR_NAME' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_SHORT_COLOR_NAME' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_SHORT_COLOR_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'SC_COLOR_GROUP' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_COLOR_GROUP' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_COLOR_GROUP' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'SC_PATTERN' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_PATTERN' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_PATTERN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'SC_ACCOUNT_EXCLUSIVE' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_ACCOUNT_EXCLUSIVE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_ACCOUNT_EXCLUSIVE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'SC_START_SHIP_DATE' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_START_SHIP_DATE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_START_SHIP_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'SC_PRODUCT_TEAM' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_PRODUCT_TEAM' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_PRODUCT_TEAM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'SC_KEY_ITEM_INDICATOR' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_KEY_ITEM_INDICATOR' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_KEY_ITEM_INDICATOR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'SC_PRODUCT_STOP_DATE' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_PRODUCT_STOP_DATE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_PRODUCT_STOP_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'SC_OUTLET_STYLE_INDICATOR' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_OUTLET_STYLE_INDICATOR' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_OUTLET_STYLE_INDICATOR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'SC_MULTI_CHANNEL_IND' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_MULTI_CHANNEL_IND' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_MULTI_CHANNEL_IND' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'SC_ORI_STYLE_COLOR_ID' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_ORI_STYLE_COLOR_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_ORI_STYLE_COLOR_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'STYLE_COLOR_SIZE_ID' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'STYLE_COLOR_SIZE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'STYLE_COLOR_SIZE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'TARGET_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'TARGET_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'STYLE_COLOR_ID' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'STYLE_COLOR_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'STYLE_COLOR_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'SIZE_CODE' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'SIZE_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SIZE_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'SI_SIZE_NAME1' ATTR_NAME,
             'SIZE_ITEM' LEVEL_NAME,
             'SI_SIZE_NAME1' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SI_SIZE_NAME1' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'SI_SIZE_NAME2' ATTR_NAME,
             'SIZE_ITEM' LEVEL_NAME,
             'SI_SIZE_NAME2' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SI_SIZE_NAME2' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'SI_SIZE_SEQ1' ATTR_NAME,
             'SIZE_ITEM' LEVEL_NAME,
             'SI_SIZE_SEQ1' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SI_SIZE_SEQ1' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'SI_SIZE_SEQ2' ATTR_NAME,
             'SIZE_ITEM' LEVEL_NAME,
             'SI_SIZE_SEQ2' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SI_SIZE_SEQ2' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'SI_CORE_SIZE_INDICATOR' ATTR_NAME,
             'SIZE_ITEM' LEVEL_NAME,
             'SI_CORE_SIZE_INDICATOR' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SI_CORE_SIZE_INDICATOR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'SR_DEPT_ID' ATTR_NAME,
             'SIZE_RANGE' LEVEL_NAME,
             'SR_DEPT_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SR_DEPT_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'SR_NAME' ATTR_NAME,
             'SIZE_RANGE' LEVEL_NAME,
             'SR_NAME' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SR_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'SR_SIZE_RANGE_ID' ATTR_NAME,
             'SIZE_RANGE' LEVEL_NAME,
             'SR_SIZE_RANGE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SR_SIZE_RANGE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'SR_SOURCE_BUSKEY' ATTR_NAME,
             'SIZE_RANGE' LEVEL_NAME,
             'SR_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SR_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'UPC' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'UPC' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'UPC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'ARTICLE_NUMBER' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'ARTICLE_NUMBER' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'ARTICLE_NUMBER' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PRIMARY_SIZE' HIERARCHY_NAME,
             'ORI_STYLE_SIZE_ID' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'ORI_STYLE_SIZE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'ORI_STYLE_SIZE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      
      --STYLE:SECONDARY_GP
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'V_VENDOR_ID' ATTR_NAME,
             'VENDOR' LEVEL_NAME,
             'V_VENDOR_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'V_VENDOR_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'V_SOURCE_BUSKEY' ATTR_NAME,
             'VENDOR' LEVEL_NAME,
             'V_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'V_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'V_NAME' ATTR_NAME,
             'VENDOR' LEVEL_NAME,
             'V_NAME' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'V_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'V_VENDOR_DIVISION' ATTR_NAME,
             'VENDOR' LEVEL_NAME,
             'V_VENDOR_DIVISION' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'V_VENDOR_DIVISION' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'V_VENDOR_DEPT' ATTR_NAME,
             'VENDOR' LEVEL_NAME,
             'V_VENDOR_DEPT' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'V_VENDOR_DEPT' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'V_VENDOR_PRODUCT_CATEGORY' ATTR_NAME,
             'VENDOR' LEVEL_NAME,
             'V_VENDOR_PRODUCT_CATEGORY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'V_VENDOR_PRODUCT_CATEGORY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'V_ORI_MIC_ID' ATTR_NAME,
             'VENDOR' LEVEL_NAME,
             'V_ORI_MIC_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'V_ORI_MIC_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'V_MIC_CODE' ATTR_NAME,
             'VENDOR' LEVEL_NAME,
             'D_MIC_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'V_MIC_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'V_MIC_DESC' ATTR_NAME,
             'VENDOR' LEVEL_NAME,
             'V_MIC_DESC' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'V_MIC_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'V_PO_DIRECTION' ATTR_NAME,
             'VENDOR' LEVEL_NAME,
             'V_PO_DIRECTION' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'V_PO_DIRECTION' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'V_VENDOR_REF_NUMBER' ATTR_NAME,
             'VENDOR' LEVEL_NAME,
             'V_VENDOR_REF_NUMBER' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'V_VENDOR_REF_NUMBER' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'V_ORI_VENDOR_COMPANY_ID' ATTR_NAME,
             'VENDOR' LEVEL_NAME,
             'V_ORI_VENDOR_COMPANY_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'V_ORI_VENDOR_COMPANY_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'V_TARGET_BUSKEY' ATTR_NAME,
             'VENDOR' LEVEL_NAME,
             'V_TARGET_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'V_TARGET_BUSKEY' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_STYLE_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_STYLE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_STYLE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_SOURCE_BUSKEY' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_TARGET_BUSKEY' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_TARGET_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_TARGET_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_STYLE_NUMBER' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_STYLE_NUMBER' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_STYLE_NUMBER' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_DESCRIPTION' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_DESCRIPTION' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_DESCRIPTION' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_DEPT_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_DEPT_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_DEPT_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_VENDOR_NAME' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_VENDOR_NAME' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_VENDOR_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_SIZE_RANGE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_SIZE_RANGE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_SIZE_RANGE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_DEPT_TYPE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_DEPT_TYPE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_DEPT_TYPE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_DIVISION_TYPE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_DIVISION_TYPE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_DIVISION_TYPE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_CLASS_CODE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_CLASS_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_CLASS_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_CLASS' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_CLASS' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_CLASS' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_PRODUCT_CATEGORY' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_PRODUCT_CATEGORY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_PRODUCT_CATEGORY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_CATEGORY' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_CATEGORY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_CATEGORY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_PRODUCTION_TYPE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_PRODUCTION_TYPE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_PRODUCTION_TYPE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_FIBER_CONTENT' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_FIBER_CONTENT' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_FIBER_CONTENT' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_FABRICATION' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_FABRICATION' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_FABRICATION' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_PRODUCT_GROUP' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_PRODUCT_GROUP' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_PRODUCT_GROUP' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_RANGE_CODE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_RANGE_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_RANGE_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_COLLAR' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_COLLAR' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_COLLAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_SLEEVE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_SLEEVE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_SLEEVE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_LABEL_CODE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_LABEL_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_LABEL_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_TERM' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_TERM' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_TERM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_PRODUCT_CATEGORY_CODE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_PRODUCT_CATEGORY_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_PRODUCT_CATEGORY_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_SEASON_CODE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_SEASON_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_SEASON_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_PRODUCT_GROUP_CODE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_PRODUCT_GROUP_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_PRODUCT_GROUP_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_STYLE_REF_NUMBER' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_STYLE_REF_NUMBER' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_STYLE_REF_NUMBER' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_STYLE_NAME' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_STYLE_NAME' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_STYLE_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_SUB_CLASS' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_SUB_CLASS' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_SUB_CLASS' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_MINOR_CLASS' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_MINOR_CLASS' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_MINOR_CLASS' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_HANG_FOLD' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_HANG_FOLD' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_HANG_FOLD' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_YIELD' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_YIELD' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_YIELD' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_DISCONTINUE_DATE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_DISCONTINUE_DATE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_DISCONTINUE_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_CHANGE_DATE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_CHANGE_DATE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_CHANGE_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_REPLENISHMENT_IND' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_REPLENISHMENT_IND' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_REPLENISHMENT_IND' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_ORI_STYLE_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_ORI_STYLE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_ORI_STYLE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_ORI_COMPANY_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_ORI_COMPANY_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_ORI_COMPANY_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_ORI_BUYER_COMPANY_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_ORI_BUYER_COMPANY_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_ORI_BUYER_COMPANY_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_ORI_BUYER_CLASS_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_ORI_BUYER_CLASS_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_ORI_BUYER_CLASS_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_ORI_BUYER_SUBCLASS_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_ORI_BUYER_SUBCLASS_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_ORI_BUYER_SUBCLASS_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_ORI_MINOR_CLASS_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_ORI_MINOR_CLASS_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_ORI_MINOR_CLASS_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_ORI_PRODUCTION_TYPE_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_ORI_PRODUCTION_TYPE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_ORI_PRODUCTION_TYPE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_LOW_COST' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_LOW_COST' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_LOW_COST' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_LOW_RETAIL' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_LOW_RETAIL' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_LOW_RETAIL' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_STANDARD_COST' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_STANDARD_COST' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_STANDARD_COST' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_VENDOR_REF_NUMBER' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_VENDOR_REF_NUMBER' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_VENDOR_REF_NUMBER' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'S_STATUS' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_STATUS' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'S_STATUS' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SC_STYLE_COLOR_ID' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_STYLE_COLOR_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_STYLE_COLOR_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SC_SOURCE_BUSKEY' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SC_TARGET_BUSKEY' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_TARGET_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_TARGET_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SC_STYLE_ID' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_STYLE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_STYLE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SC_COLOR_NAME' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_COLOR_NAME' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_COLOR_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SC_COLOR_CODE' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_COLOR_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_COLOR_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SC_VENDOR_COLOR_CODE' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_VENDOR_COLOR_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_VENDOR_COLOR_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SC_COLOR_FAMILY' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_COLOR_FAMILY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_COLOR_FAMILY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SC_SHORT_COLOR_NAME' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_SHORT_COLOR_NAME' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_SHORT_COLOR_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SC_COLOR_GROUP' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_COLOR_GROUP' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_COLOR_GROUP' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SC_PATTERN' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_PATTERN' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_PATTERN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SC_ACCOUNT_EXCLUSIVE' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_ACCOUNT_EXCLUSIVE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_ACCOUNT_EXCLUSIVE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SC_START_SHIP_DATE' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_START_SHIP_DATE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_START_SHIP_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SC_PRODUCT_TEAM' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_PRODUCT_TEAM' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_PRODUCT_TEAM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SC_KEY_ITEM_INDICATOR' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_KEY_ITEM_INDICATOR' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_KEY_ITEM_INDICATOR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SC_PRODUCT_STOP_DATE' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_PRODUCT_STOP_DATE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_PRODUCT_STOP_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SC_OUTLET_STYLE_INDICATOR' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_OUTLET_STYLE_INDICATOR' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_OUTLET_STYLE_INDICATOR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SC_MULTI_CHANNEL_IND' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_MULTI_CHANNEL_IND' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_MULTI_CHANNEL_IND' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SC_ORI_STYLE_COLOR_ID' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_ORI_STYLE_COLOR_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SC_ORI_STYLE_COLOR_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SCS_STYLE_COLOR_SIZE_ID' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'SCS_STYLE_COLOR_SIZE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SCS_STYLE_COLOR_SIZE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SCS_SOURCE_BUSKEY' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'SCS_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SCS_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SCS_TARGET_BUSKEY' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'SCS_TARGET_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SCS_TARGET_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SCS_STYLE_COLOR_ID' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'SCS_STYLE_COLOR_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SCS_STYLE_COLOR_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SCS_SIZE_CODE' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'SCS_SIZE_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SCS_SIZE_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SCS_UPC' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'SCS_UPC' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SCS_UPC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SCS_ARTICLE_NUMBER' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'SCS_ARTICLE_NUMBER' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SCS_ARTICLE_NUMBER' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SCS_ORI_STYLE_SIZE_ID' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'SCS_ORI_STYLE_SIZE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SCS_ORI_STYLE_SIZE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'STYLE_COLOR_SIZE_GP_ID' ATTR_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'STYLE_COLOR_SIZE_GP_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'TARGET_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'TARGET_BUSKEY' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'GP_SIZE_ID' ATTR_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'GP_SIZE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'GP_SIZE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'STYLE_COLOR_SIZE_ID' ATTR_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'STYLE_COLOR_SIZE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'STYLE_COLOR_SIZE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'GS_GP_SIZE_ID' ATTR_NAME,
             'GP_SIZE' LEVEL_NAME,
             'GS_GP_SIZE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'GS_GP_SIZE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'GS_SOURCE_BUSKEY' ATTR_NAME,
             'GP_SIZE' LEVEL_NAME,
             'GS_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'GS_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'GS_GP_GP_ID' ATTR_NAME,
             'GP_SIZE' LEVEL_NAME,
             'GS_GP_GP_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'GS_GP_GP_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'GS_SIZE_CODE' ATTR_NAME,
             'GP_SIZE' LEVEL_NAME,
             'GS_SIZE_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'GS_SIZE_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'GS_RATIO' ATTR_NAME,
             'GP_SIZE' LEVEL_NAME,
             'GS_RATIO' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'GS_RATIO' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'G_GP_GP_ID' ATTR_NAME,
             'GP' LEVEL_NAME,
             'G_GP_GP_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'G_GP_GP_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'G_SOURCE_BUSKEY' ATTR_NAME,
             'GP' LEVEL_NAME,
             'G_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'G_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'G_NAME' ATTR_NAME,
             'GP' LEVEL_NAME,
             'G_NAME' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'G_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SR_DEPT_ID' ATTR_NAME,
             'SIZE_RANGE' LEVEL_NAME,
             'SR_DEPT_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SR_DEPT_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SR_NAME' ATTR_NAME,
             'SIZE_RANGE' LEVEL_NAME,
             'SR_NAME' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SR_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SR_SIZE_RANGE_ID' ATTR_NAME,
             'SIZE_RANGE' LEVEL_NAME,
             'SR_SIZE_RANGE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SR_SIZE_RANGE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SR_SOURCE_BUSKEY' ATTR_NAME,
             'SIZE_RANGE' LEVEL_NAME,
             'SR_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SR_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SI_SIZE_NAME1' ATTR_NAME,
             'SIZE_ITEM' LEVEL_NAME,
             'SI_SIZE_NAME1' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SI_SIZE_NAME1' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SI_SIZE_NAME2' ATTR_NAME,
             'SIZE_ITEM' LEVEL_NAME,
             'SI_SIZE_NAME2' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SI_SIZE_NAME2' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SI_SIZE_SEQ1' ATTR_NAME,
             'SIZE_ITEM' LEVEL_NAME,
             'SI_SIZE_SEQ1' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SI_SIZE_SEQ1' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SI_SIZE_SEQ2' ATTR_NAME,
             'SIZE_ITEM' LEVEL_NAME,
             'SI_SIZE_SEQ2' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SI_SIZE_SEQ2' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_GP' HIERARCHY_NAME,
             'SI_CORE_SIZE_INDICATOR' ATTR_NAME,
             'SIZE_ITEM' LEVEL_NAME,
             'SI_CORE_SIZE_INDICATOR' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_GP' DB_TAB_NAME,
             'SI_CORE_SIZE_INDICATOR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      --STYLE:SECONDARY_SIZE
      
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'V_VENDOR_ID' ATTR_NAME,
             'VENDOR' LEVEL_NAME,
             'V_VENDOR_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'V_VENDOR_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'V_SOURCE_BUSKEY' ATTR_NAME,
             'VENDOR' LEVEL_NAME,
             'V_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'V_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'V_NAME' ATTR_NAME,
             'VENDOR' LEVEL_NAME,
             'V_NAME' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'V_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'V_VENDOR_DIVISION' ATTR_NAME,
             'VENDOR' LEVEL_NAME,
             'V_VENDOR_DIVISION' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'V_VENDOR_DIVISION' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'V_VENDOR_DEPT' ATTR_NAME,
             'VENDOR' LEVEL_NAME,
             'V_VENDOR_DEPT' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'V_VENDOR_DEPT' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'V_VENDOR_PRODUCT_CATEGORY' ATTR_NAME,
             'VENDOR' LEVEL_NAME,
             'V_VENDOR_PRODUCT_CATEGORY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'V_VENDOR_PRODUCT_CATEGORY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'V_ORI_MIC_ID' ATTR_NAME,
             'VENDOR' LEVEL_NAME,
             'V_ORI_MIC_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'V_ORI_MIC_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'V_MIC_CODE' ATTR_NAME,
             'VENDOR' LEVEL_NAME,
             'V_MIC_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'V_MIC_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'V_MIC_DESC' ATTR_NAME,
             'VENDOR' LEVEL_NAME,
             'V_MIC_DESC' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'V_MIC_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'V_PO_DIRECTION' ATTR_NAME,
             'VENDOR' LEVEL_NAME,
             'V_PO_DIRECTION' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'V_PO_DIRECTION' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'V_VENDOR_REF_NUMBER' ATTR_NAME,
             'VENDOR' LEVEL_NAME,
             'V_VENDOR_REF_NUMBER' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'V_VENDOR_REF_NUMBER' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'V_ORI_VENDOR_COMPANY_ID' ATTR_NAME,
             'VENDOR' LEVEL_NAME,
             'V_ORI_VENDOR_COMPANY_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'V_ORI_VENDOR_COMPANY_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'V_TARGET_BUSKEY' ATTR_NAME,
             'VENDOR' LEVEL_NAME,
             'V_TARGET_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'V_TARGET_BUSKEY' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_STYLE_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_STYLE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_STYLE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_SOURCE_BUSKEY' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_TARGET_BUSKEY' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_TARGET_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_TARGET_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_STYLE_NUMBER' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_STYLE_NUMBER' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_STYLE_NUMBER' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_DESCRIPTION' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_DESCRIPTION' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_DESCRIPTION' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_DEPT_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_DEPT_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_DEPT_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_VENDOR_NAME' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_VENDOR_NAME' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_VENDOR_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_SIZE_RANGE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_SIZE_RANGE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_SIZE_RANGE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_DEPT_TYPE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_DEPT_TYPE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_DEPT_TYPE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_DIVISION_TYPE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_DIVISION_TYPE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_DIVISION_TYPE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_CLASS_CODE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_CLASS_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_CLASS_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_CLASS' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_CLASS' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_CLASS' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_PRODUCT_CATEGORY' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_PRODUCT_CATEGORY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_PRODUCT_CATEGORY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_CATEGORY' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_CATEGORY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_CATEGORY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_PRODUCTION_TYPE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_PRODUCTION_TYPE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_PRODUCTION_TYPE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_FIBER_CONTENT' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_FIBER_CONTENT' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_FIBER_CONTENT' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_FABRICATION' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_FABRICATION' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_FABRICATION' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_PRODUCT_GROUP' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_PRODUCT_GROUP' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_PRODUCT_GROUP' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_RANGE_CODE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_RANGE_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_RANGE_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_COLLAR' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_COLLAR' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_COLLAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_SLEEVE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_SLEEVE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_SLEEVE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_LABEL_CODE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_LABEL_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_LABEL_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_TERM' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_TERM' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_TERM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_PRODUCT_CATEGORY_CODE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_PRODUCT_CATEGORY_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_PRODUCT_CATEGORY_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_SEASON_CODE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_SEASON_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_SEASON_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_PRODUCT_GROUP_CODE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_PRODUCT_GROUP_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_PRODUCT_GROUP_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_STYLE_REF_NUMBER' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_STYLE_REF_NUMBER' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_STYLE_REF_NUMBER' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_STYLE_NAME' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_STYLE_NAME' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_STYLE_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_SUB_CLASS' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_SUB_CLASS' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_SUB_CLASS' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_MINOR_CLASS' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_MINOR_CLASS' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_MINOR_CLASS' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_HANG_FOLD' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_HANG_FOLD' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_HANG_FOLD' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_YIELD' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_YIELD' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_YIELD' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_DISCONTINUE_DATE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_DISCONTINUE_DATE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_DISCONTINUE_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_CHANGE_DATE' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_CHANGE_DATE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_CHANGE_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_REPLENISHMENT_IND' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_REPLENISHMENT_IND' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_REPLENISHMENT_IND' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_ORI_STYLE_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_ORI_STYLE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_ORI_STYLE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_ORI_COMPANY_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_ORI_COMPANY_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_ORI_COMPANY_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_ORI_BUYER_COMPANY_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_ORI_BUYER_COMPANY_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_ORI_BUYER_COMPANY_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_ORI_BUYER_CLASS_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_ORI_BUYER_CLASS_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_ORI_BUYER_CLASS_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_ORI_BUYER_SUBCLASS_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_ORI_BUYER_SUBCLASS_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_ORI_BUYER_SUBCLASS_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_ORI_MINOR_CLASS_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_ORI_MINOR_CLASS_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_ORI_MINOR_CLASS_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_ORI_PRODUCTION_TYPE_ID' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_ORI_PRODUCTION_TYPE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_ORI_PRODUCTION_TYPE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_LOW_COST' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_LOW_COST' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_LOW_COST' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_LOW_RETAIL' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_LOW_RETAIL' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_LOW_RETAIL' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_STANDARD_COST' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_STANDARD_COST' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_STANDARD_COST' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_VENDOR_REF_NUMBER' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_VENDOR_REF_NUMBER' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_VENDOR_REF_NUMBER' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'S_STATUS' ATTR_NAME,
             'STYLE' LEVEL_NAME,
             'S_STATUS' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'S_STATUS' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'SC_STYLE_COLOR_ID' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_STYLE_COLOR_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_STYLE_COLOR_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'SC_SOURCE_BUSKEY' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'SC_TARGET_BUSKEY' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_TARGET_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_TARGET_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'SC_STYLE_ID' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_STYLE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_STYLE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'SC_COLOR_NAME' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_COLOR_NAME' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_COLOR_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'SC_COLOR_CODE' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_COLOR_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_COLOR_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'SC_VENDOR_COLOR_CODE' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_VENDOR_COLOR_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_VENDOR_COLOR_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'SC_COLOR_FAMILY' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_COLOR_FAMILY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_COLOR_FAMILY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'SC_SHORT_COLOR_NAME' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_SHORT_COLOR_NAME' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_SHORT_COLOR_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'SC_COLOR_GROUP' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_COLOR_GROUP' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_COLOR_GROUP' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'SC_PATTERN' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_PATTERN' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_PATTERN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'SC_ACCOUNT_EXCLUSIVE' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_ACCOUNT_EXCLUSIVE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_ACCOUNT_EXCLUSIVE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'SC_START_SHIP_DATE' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_START_SHIP_DATE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_START_SHIP_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'SC_PRODUCT_TEAM' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_PRODUCT_TEAM' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_PRODUCT_TEAM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'SC_KEY_ITEM_INDICATOR' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_KEY_ITEM_INDICATOR' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_KEY_ITEM_INDICATOR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'SC_PRODUCT_STOP_DATE' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_PRODUCT_STOP_DATE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_PRODUCT_STOP_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'SC_OUTLET_STYLE_INDICATOR' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_OUTLET_STYLE_INDICATOR' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_OUTLET_STYLE_INDICATOR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'SC_MULTI_CHANNEL_IND' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_MULTI_CHANNEL_IND' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_MULTI_CHANNEL_IND' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'SC_ORI_STYLE_COLOR_ID' ATTR_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SC_ORI_STYLE_COLOR_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SC_ORI_STYLE_COLOR_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'STYLE_COLOR_SIZE_ID' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'STYLE_COLOR_SIZE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'STYLE_COLOR_SIZE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'TARGET_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'TARGET_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'STYLE_COLOR_ID' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'STYLE_COLOR_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'STYLE_COLOR_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'SIZE_CODE' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'SIZE_CODE' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SIZE_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'SI_SIZE_NAME1' ATTR_NAME,
             'SIZE_ITEM' LEVEL_NAME,
             'SI_SIZE_NAME1' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SI_SIZE_NAME1' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'SI_SIZE_NAME2' ATTR_NAME,
             'SIZE_ITEM' LEVEL_NAME,
             'SI_SIZE_NAME2' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SI_SIZE_NAME2' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'SI_SIZE_SEQ1' ATTR_NAME,
             'SIZE_ITEM' LEVEL_NAME,
             'SI_SIZE_SEQ1' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SI_SIZE_SEQ1' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'SI_SIZE_SEQ2' ATTR_NAME,
             'SIZE_ITEM' LEVEL_NAME,
             'SI_SIZE_SEQ2' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SI_SIZE_SEQ2' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'SI_CORE_SIZE_INDICATOR' ATTR_NAME,
             'SIZE_ITEM' LEVEL_NAME,
             'SI_CORE_SIZE_INDICATOR' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SI_CORE_SIZE_INDICATOR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'SR_DEPT_ID' ATTR_NAME,
             'SIZE_RANGE' LEVEL_NAME,
             'SR_DEPT_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SR_DEPT_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'SR_NAME' ATTR_NAME,
             'SIZE_RANGE' LEVEL_NAME,
             'SR_NAME' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SR_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'SR_SIZE_RANGE_ID' ATTR_NAME,
             'SIZE_RANGE' LEVEL_NAME,
             'SR_SIZE_RANGE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SR_SIZE_RANGE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'SR_SOURCE_BUSKEY' ATTR_NAME,
             'SIZE_RANGE' LEVEL_NAME,
             'SR_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'SR_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'UPC' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'UPC' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'UPC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'ARTICLE_NUMBER' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'ARTICLE_NUMBER' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'ARTICLE_NUMBER' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'SECONDARY_SIZE' HIERARCHY_NAME,
             'ORI_STYLE_SIZE_ID' ATTR_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'ORI_STYLE_SIZE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PRIMARY_SIZE' DB_TAB_NAME,
             'ORI_STYLE_SIZE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      
      --V_DIM_TIME_7TH_YMD
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'DATE_ID' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DATE_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'DATE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'DAY_DATE' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'DAY_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'DAY_DESC' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_DESC' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'DAY_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'CWEEK_ID' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'CWEEK_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'CWEEK_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'CMONTH_ID' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'CMONTH_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'CMONTH_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'IWEEK_ID' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IWEEK_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'IWEEK_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SWEEK_PART_ID' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'SWEEK_PART_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SWEEK_PART_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'DAY_OF_CWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_CWEEK' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'DAY_OF_CWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'DAY_OF_CMONTH' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_CMONTH' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'DAY_OF_CMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'DAY_OF_CYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_CYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'DAY_OF_CYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'DAY_OF_IWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_IWEEK' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'DAY_OF_IWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'DAY_OF_IYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_IYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'DAY_OF_IYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'DAY_OF_SWEEK_PART' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_SWEEK_PART' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'DAY_OF_SWEEK_PART' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'DAY_OF_SWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_SWEEK' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'DAY_OF_SWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'DAY_OF_SWYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_SWYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'DAY_OF_SWYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'DAY_OF_SMONTH' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_SMONTH' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'DAY_OF_SMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'DAY_OF_SMYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_SMYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'DAY_OF_SMYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'IS_FIRST_OF_CWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_CWEEK' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'IS_FIRST_OF_CWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'IS_LAST_OF_CWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_CWEEK' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'IS_LAST_OF_CWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'IS_FIRST_OF_CMONTH' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_CMONTH' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'IS_FIRST_OF_CMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'IS_LAST_OF_CMONTH' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_CMONTH' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'IS_LAST_OF_CMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'IS_FIRST_OF_CYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_CYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'IS_FIRST_OF_CYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'IS_LAST_OF_CYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_CYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'IS_LAST_OF_CYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'IS_FIRST_OF_IWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_IWEEK' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'IS_FIRST_OF_IWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'IS_LAST_OF_IWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_IWEEK' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'IS_LAST_OF_IWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'IS_FIRST_OF_IYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_IYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'IS_FIRST_OF_IYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'IS_LAST_OF_IYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_IYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'IS_LAST_OF_IYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'IS_FIRST_OF_SWEEK_PART' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_SWEEK_PART' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'IS_FIRST_OF_SWEEK_PART' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'IS_LAST_OF_SWEEK_PART' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_SWEEK_PART' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'IS_LAST_OF_SWEEK_PART' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'IS_FIRST_OF_SWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_SWEEK' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'IS_FIRST_OF_SWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'IS_LAST_OF_SWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_SWEEK' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'IS_LAST_OF_SWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'IS_FIRST_OF_SWYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_SWYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'IS_FIRST_OF_SWYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'IS_LAST_OF_SWYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_SWYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'IS_LAST_OF_SWYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'IS_FIRST_OF_SMONTH' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_SMONTH' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'IS_FIRST_OF_SMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'IS_LAST_OF_SMONTH' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_SMONTH' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'IS_LAST_OF_SMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'IS_FIRST_OF_SMYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_SMYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'IS_FIRST_OF_SMYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'IS_LAST_OF_SMYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_SMYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'IS_LAST_OF_SMYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'START_DATE' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'END_DATE' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'TIME_SPAN' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'DAY_NUM' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_NUM' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'DAY_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'DAY_SEQ' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'DAY_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SWP_SWEEK_PART_ID' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWP_SWEEK_PART_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SWP_SWEEK_PART_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SWP_SWEEK_PART_DESC' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWP_SWEEK_PART_DESC' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SWP_SWEEK_PART_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SWP_SMONTH_ID' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWP_SMONTH_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SWP_SMONTH_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SWP_SWEEK_ID' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWP_SWEEK_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SWP_SWEEK_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SWP_SWEEK_PART_OF_SMONTH' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWP_SWEEK_PART_OF_SMONTH' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SWP_SWEEK_PART_OF_SMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SWP_SWEEK_PART_OF_SWEEK' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWP_SWEEK_PART_OF_SWEEK' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SWP_SWEEK_PART_OF_SWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SWP_IS_FIRST_OF_SMONTH' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWP_IS_FIRST_OF_SMONTH' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SWP_IS_FIRST_OF_SMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SWP_IS_LAST_OF_SMONTH' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWP_IS_LAST_OF_SMONTH' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SWP_IS_LAST_OF_SMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SWP_IS_FIRST_OF_SWEEK' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWP_IS_FIRST_OF_SWEEK' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SWP_IS_FIRST_OF_SWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SWP_IS_LAST_OF_SWEEK' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWP_IS_LAST_OF_SWEEK' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SWP_IS_LAST_OF_SWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SWP_START_DATE' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWP_START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SWP_START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SWP_END_DATE' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWP_END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SWP_END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SWP_TIME_SPAN' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWP_TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SWP_TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SWP_SWEEK_PART_NUM' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWP_SWEEK_PART_NUM' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SWP_SWEEK_PART_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SWP_SWEEK_PART_SEQ' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWP_SWEEK_PART_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SWP_SWEEK_PART_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SM_SMONTH_ID' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SM_SMONTH_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SM_SMONTH_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SM_SMONTH_DESC' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SM_SMONTH_DESC' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SM_SMONTH_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SM_SMYEAR_ID' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SM_SMYEAR_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SM_SMYEAR_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SM_SMONTH_OF_SMYEAR' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SM_SMONTH_OF_SMYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SM_SMONTH_OF_SMYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SM_SMONTH_NAME' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SM_SMONTH_NAME' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SM_SMONTH_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SM_IS_FIRST_OF_SMYEAR' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SM_IS_FIRST_OF_SMYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SM_IS_FIRST_OF_SMYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SM_IS_LAST_OF_SMYEAR' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SM_IS_LAST_OF_SMYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SM_IS_LAST_OF_SMYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SM_START_DATE' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SM_START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SM_START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SM_END_DATE' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SM_END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SM_END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SM_TIME_SPAN' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SM_TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SM_TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SM_SMONTH_NUM' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SM_SMONTH_NUM' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SM_SMONTH_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SM_SMONTH_SEQ' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SM_SMONTH_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SM_SMONTH_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SMY_SMYEAR_ID' ATTR_NAME,
             '7TH_MYEAR' LEVEL_NAME,
             'SMY_SMYEAR_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SMY_SMYEAR_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SMY_SMYEAR_DESC' ATTR_NAME,
             '7TH_MYEAR' LEVEL_NAME,
             'SMY_SMYEAR_DESC' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SMY_SMYEAR_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SMY_START_DATE' ATTR_NAME,
             '7TH_MYEAR' LEVEL_NAME,
             'SMY_START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SMY_START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SMY_END_DATE' ATTR_NAME,
             '7TH_MYEAR' LEVEL_NAME,
             'SMY_END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SMY_END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SMY_TIME_SPAN' ATTR_NAME,
             '7TH_MYEAR' LEVEL_NAME,
             'SMY_TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SMY_TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SMY_SMYEAR_NUM' ATTR_NAME,
             '7TH_MYEAR' LEVEL_NAME,
             'SMY_SMYEAR_NUM' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SMY_SMYEAR_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMD' HIERARCHY_NAME,
             'SMY_SMYEAR_SEQ' ATTR_NAME,
             '7TH_MYEAR' LEVEL_NAME,
             'SMY_SMYEAR_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMD' DB_TAB_NAME,
             'SMY_SMYEAR_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      --V_DIM_TIME_7TH_YM
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YM' HIERARCHY_NAME,
             'SMONTH_ID' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SMONTH_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YM' DB_TAB_NAME,
             'SMONTH_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YM' HIERARCHY_NAME,
             'SMONTH_DESC' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SMONTH_DESC' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YM' DB_TAB_NAME,
             'SMONTH_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YM' HIERARCHY_NAME,
             'SMYEAR_ID' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SMYEAR_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YM' DB_TAB_NAME,
             'SMYEAR_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YM' HIERARCHY_NAME,
             'SMONTH_OF_SMYEAR' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SMONTH_OF_SMYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YM' DB_TAB_NAME,
             'SMONTH_OF_SMYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YM' HIERARCHY_NAME,
             'SMONTH_NAME' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SMONTH_NAME' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YM' DB_TAB_NAME,
             'SMONTH_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YM' HIERARCHY_NAME,
             'IS_FIRST_OF_SMYEAR' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'IS_FIRST_OF_SMYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YM' DB_TAB_NAME,
             'IS_FIRST_OF_SMYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YM' HIERARCHY_NAME,
             'IS_LAST_OF_SMYEAR' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'IS_LAST_OF_SMYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YM' DB_TAB_NAME,
             'IS_LAST_OF_SMYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YM' HIERARCHY_NAME,
             'START_DATE' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YM' DB_TAB_NAME,
             'START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YM' HIERARCHY_NAME,
             'END_DATE' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YM' DB_TAB_NAME,
             'END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YM' HIERARCHY_NAME,
             'TIME_SPAN' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YM' DB_TAB_NAME,
             'TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YM' HIERARCHY_NAME,
             'SMONTH_NUM' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SMONTH_NUM' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YM' DB_TAB_NAME,
             'SMONTH_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YM' HIERARCHY_NAME,
             'SMONTH_SEQ' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SMONTH_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YM' DB_TAB_NAME,
             'SMONTH_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YM' HIERARCHY_NAME,
             'SMY_SMYEAR_ID' ATTR_NAME,
             '7TH_MYEAR' LEVEL_NAME,
             'SMY_SMYEAR_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YM' DB_TAB_NAME,
             'SMY_SMYEAR_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YM' HIERARCHY_NAME,
             'SMY_SMYEAR_DESC' ATTR_NAME,
             '7TH_MYEAR' LEVEL_NAME,
             'SMY_SMYEAR_DESC' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YM' DB_TAB_NAME,
             'SMY_SMYEAR_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YM' HIERARCHY_NAME,
             'SMY_START_DATE' ATTR_NAME,
             '7TH_MYEAR' LEVEL_NAME,
             'SMY_START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YM' DB_TAB_NAME,
             'SMY_START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YM' HIERARCHY_NAME,
             'SMY_END_DATE' ATTR_NAME,
             '7TH_MYEAR' LEVEL_NAME,
             'SMY_END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YM' DB_TAB_NAME,
             'SMY_END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YM' HIERARCHY_NAME,
             'SMY_TIME_SPAN' ATTR_NAME,
             '7TH_MYEAR' LEVEL_NAME,
             'SMY_TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YM' DB_TAB_NAME,
             'SMY_TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YM' HIERARCHY_NAME,
             'SMY_SMYEAR_NUM' ATTR_NAME,
             '7TH_MYEAR' LEVEL_NAME,
             'SMY_SMYEAR_NUM' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YM' DB_TAB_NAME,
             'SMY_SMYEAR_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YM' HIERARCHY_NAME,
             'SMY_SMYEAR_SEQ' ATTR_NAME,
             '7TH_MYEAR' LEVEL_NAME,
             'SMY_SMYEAR_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YM' DB_TAB_NAME,
             'SMY_SMYEAR_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      --V_DIM_TIME_7TH_YWD
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'DATE_ID' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DATE_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'DATE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'DAY_DATE' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'DAY_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'DAY_DESC' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_DESC' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'DAY_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'CWEEK_ID' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'CWEEK_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'CWEEK_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'CMONTH_ID' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'CMONTH_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'CMONTH_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'IWEEK_ID' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IWEEK_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'IWEEK_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SWEEK_PART_ID' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'SWEEK_PART_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SWEEK_PART_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'DAY_OF_CWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_CWEEK' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'DAY_OF_CWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'DAY_OF_CMONTH' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_CMONTH' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'DAY_OF_CMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'DAY_OF_CYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_CYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'DAY_OF_CYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'DAY_OF_IWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_IWEEK' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'DAY_OF_IWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'DAY_OF_IYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_IYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'DAY_OF_IYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'DAY_OF_SWEEK_PART' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_SWEEK_PART' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'DAY_OF_SWEEK_PART' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'DAY_OF_SWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_SWEEK' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'DAY_OF_SWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'DAY_OF_SWYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_SWYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'DAY_OF_SWYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'DAY_OF_SMONTH' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_SMONTH' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'DAY_OF_SMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'DAY_OF_SMYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_SMYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'DAY_OF_SMYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'IS_FIRST_OF_CWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_CWEEK' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'IS_FIRST_OF_CWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'IS_LAST_OF_CWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_CWEEK' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'IS_LAST_OF_CWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'IS_FIRST_OF_CMONTH' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_CMONTH' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'IS_FIRST_OF_CMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'IS_LAST_OF_CMONTH' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_CMONTH' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'IS_LAST_OF_CMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'IS_FIRST_OF_CYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_CYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'IS_FIRST_OF_CYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'IS_LAST_OF_CYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_CYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'IS_LAST_OF_CYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'IS_FIRST_OF_IWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_IWEEK' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'IS_FIRST_OF_IWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'IS_LAST_OF_IWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_IWEEK' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'IS_LAST_OF_IWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'IS_FIRST_OF_IYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_IYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'IS_FIRST_OF_IYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'IS_LAST_OF_IYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_IYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'IS_LAST_OF_IYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'IS_FIRST_OF_SWEEK_PART' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_SWEEK_PART' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'IS_FIRST_OF_SWEEK_PART' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'IS_LAST_OF_SWEEK_PART' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_SWEEK_PART' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'IS_LAST_OF_SWEEK_PART' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'IS_FIRST_OF_SWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_SWEEK' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'IS_FIRST_OF_SWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'IS_LAST_OF_SWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_SWEEK' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'IS_LAST_OF_SWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'IS_FIRST_OF_SWYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_SWYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'IS_FIRST_OF_SWYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'IS_LAST_OF_SWYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_SWYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'IS_LAST_OF_SWYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'IS_FIRST_OF_SMONTH' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_SMONTH' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'IS_FIRST_OF_SMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'IS_LAST_OF_SMONTH' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_SMONTH' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'IS_LAST_OF_SMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'IS_FIRST_OF_SMYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_SMYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'IS_FIRST_OF_SMYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'IS_LAST_OF_SMYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_SMYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'IS_LAST_OF_SMYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'START_DATE' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'END_DATE' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'TIME_SPAN' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'DAY_NUM' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_NUM' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'DAY_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'DAY_SEQ' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'DAY_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SWP_SWEEK_PART_ID' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWP_SWEEK_PART_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SWP_SWEEK_PART_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SWP_SWEEK_PART_DESC' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWP_SWEEK_PART_DESC' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SWP_SWEEK_PART_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SWP_SMONTH_ID' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWP_SMONTH_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SWP_SMONTH_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SWP_SWEEK_ID' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWP_SWEEK_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SWP_SWEEK_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SWP_SWEEK_PART_OF_SMONTH' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWP_SWEEK_PART_OF_SMONTH' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SWP_SWEEK_PART_OF_SMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SWP_SWEEK_PART_OF_SWEEK' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWP_SWEEK_PART_OF_SWEEK' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SWP_SWEEK_PART_OF_SWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SWP_IS_FIRST_OF_SMONTH' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWP_IS_FIRST_OF_SMONTH' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SWP_IS_FIRST_OF_SMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SWP_IS_LAST_OF_SMONTH' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWP_IS_LAST_OF_SMONTH' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SWP_IS_LAST_OF_SMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SWP_IS_FIRST_OF_SWEEK' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWP_IS_FIRST_OF_SWEEK' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SWP_IS_FIRST_OF_SWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SWP_IS_LAST_OF_SWEEK' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWP_IS_LAST_OF_SWEEK' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SWP_IS_LAST_OF_SWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SWP_START_DATE' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWP_START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SWP_START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SWP_END_DATE' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWP_END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SWP_END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SWP_TIME_SPAN' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWP_TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SWP_TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SWP_SWEEK_PART_NUM' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWP_SWEEK_PART_NUM' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SWP_SWEEK_PART_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SWP_SWEEK_PART_SEQ' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWP_SWEEK_PART_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SWP_SWEEK_PART_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SW_SWEEK_ID' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SW_SWEEK_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SW_SWEEK_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SW_SWEEK_DESC' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SW_SWEEK_DESC' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SW_SWEEK_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SW_SWYEAR_ID' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SW_SWYEAR_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SW_SWYEAR_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SW_SWEEK_OF_SWYEAR' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SW_SWEEK_OF_SWYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SW_SWEEK_OF_SWYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SW_IS_FIRST_OF_SWYEAR' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SW_IS_FIRST_OF_SWYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SW_IS_FIRST_OF_SWYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SW_IS_LAST_OF_SWYEAR' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SW_IS_LAST_OF_SWYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SW_IS_LAST_OF_SWYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SW_START_DATE' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SW_START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SW_START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SW_END_DATE' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SW_END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SW_END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SW_TIME_SPAN' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SW_TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SW_TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SW_SWEEK_NUM' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SW_SWEEK_NUM' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SW_SWEEK_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SW_SWEEK_SEQ' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SW_SWEEK_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SW_SWEEK_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SWY_SWYEAR_ID' ATTR_NAME,
             '7TH_WYEAR' LEVEL_NAME,
             'SWY_SWYEAR_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SWY_SWYEAR_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SWY_SWYEAR_DESC' ATTR_NAME,
             '7TH_WYEAR' LEVEL_NAME,
             'SWY_SWYEAR_DESC' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SWY_SWYEAR_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SWY_START_DATE' ATTR_NAME,
             '7TH_WYEAR' LEVEL_NAME,
             'SWY_START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SWY_START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SWY_END_DATE' ATTR_NAME,
             '7TH_WYEAR' LEVEL_NAME,
             'SWY_END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SWY_END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SWY_TIME_SPAN' ATTR_NAME,
             '7TH_WYEAR' LEVEL_NAME,
             'SWY_TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SWY_TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SWY_SWYEAR_NUM' ATTR_NAME,
             '7TH_WYEAR' LEVEL_NAME,
             'SWY_SWYEAR_NUM' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SWY_SWYEAR_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWD' HIERARCHY_NAME,
             'SWY_SWYEAR_SEQ' ATTR_NAME,
             '7TH_WYEAR' LEVEL_NAME,
             'SWY_SWYEAR_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YWD' DB_TAB_NAME,
             'SWY_SWYEAR_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      --V_DIM_TIME_7TH_YW
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YW' HIERARCHY_NAME,
             'SWEEK_ID' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SWEEK_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YW' DB_TAB_NAME,
             'SWEEK_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YW' HIERARCHY_NAME,
             'SWEEK_DESC' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SWEEK_DESC' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YW' DB_TAB_NAME,
             'SWEEK_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YW' HIERARCHY_NAME,
             'SWYEAR_ID' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SWYEAR_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YW' DB_TAB_NAME,
             'SWYEAR_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YW' HIERARCHY_NAME,
             'SWEEK_OF_SWYEAR' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SWEEK_OF_SWYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YW' DB_TAB_NAME,
             'SWEEK_OF_SWYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YW' HIERARCHY_NAME,
             'IS_FIRST_OF_SWYEAR' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'IS_FIRST_OF_SWYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YW' DB_TAB_NAME,
             'IS_FIRST_OF_SWYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YW' HIERARCHY_NAME,
             'IS_LAST_OF_SWYEAR' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'IS_LAST_OF_SWYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YW' DB_TAB_NAME,
             'IS_LAST_OF_SWYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YW' HIERARCHY_NAME,
             'START_DATE' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YW' DB_TAB_NAME,
             'START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YW' HIERARCHY_NAME,
             'END_DATE' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YW' DB_TAB_NAME,
             'END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YW' HIERARCHY_NAME,
             'TIME_SPAN' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YW' DB_TAB_NAME,
             'TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YW' HIERARCHY_NAME,
             'SWEEK_NUM' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SWEEK_NUM' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YW' DB_TAB_NAME,
             'SWEEK_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YW' HIERARCHY_NAME,
             'SWEEK_SEQ' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SWEEK_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YW' DB_TAB_NAME,
             'SWEEK_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YW' HIERARCHY_NAME,
             'SWY_SWYEAR_ID' ATTR_NAME,
             '7TH_WYEAR' LEVEL_NAME,
             'SWY_SWYEAR_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YW' DB_TAB_NAME,
             'SWY_SWYEAR_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YW' HIERARCHY_NAME,
             'SWY_SWYEAR_DESC' ATTR_NAME,
             '7TH_WYEAR' LEVEL_NAME,
             'SWY_SWYEAR_DESC' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YW' DB_TAB_NAME,
             'SWY_SWYEAR_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YW' HIERARCHY_NAME,
             'SWY_START_DATE' ATTR_NAME,
             '7TH_WYEAR' LEVEL_NAME,
             'SWY_START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YW' DB_TAB_NAME,
             'SWY_START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YW' HIERARCHY_NAME,
             'SWY_END_DATE' ATTR_NAME,
             '7TH_WYEAR' LEVEL_NAME,
             'SWY_END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YW' DB_TAB_NAME,
             'SWY_END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YW' HIERARCHY_NAME,
             'SWY_TIME_SPAN' ATTR_NAME,
             '7TH_WYEAR' LEVEL_NAME,
             'SWY_TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YW' DB_TAB_NAME,
             'SWY_TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YW' HIERARCHY_NAME,
             'SWY_SWYEAR_NUM' ATTR_NAME,
             '7TH_WYEAR' LEVEL_NAME,
             'SWY_SWYEAR_NUM' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YW' DB_TAB_NAME,
             'SWY_SWYEAR_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YW' HIERARCHY_NAME,
             'SWY_SWYEAR_SEQ' ATTR_NAME,
             '7TH_WYEAR' LEVEL_NAME,
             'SWY_SWYEAR_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YW' DB_TAB_NAME,
             'SWY_SWYEAR_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      --7TH_YMSWP:V_DIM_TIME_7TH_YMWSWP       
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'SWEEK_PART_ID' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWEEK_PART_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SWEEK_PART_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'SWEEK_PART_DESC' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWEEK_PART_DESC' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SWEEK_PART_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'SMONTH_ID' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SMONTH_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SMONTH_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'SWEEK_ID' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWEEK_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SWEEK_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'SWEEK_PART_OF_SMONTH' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWEEK_PART_OF_SMONTH' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SWEEK_PART_OF_SMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'SWEEK_PART_OF_SWEEK' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWEEK_PART_OF_SWEEK' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SWEEK_PART_OF_SWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'IS_FIRST_OF_SMONTH' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'IS_FIRST_OF_SMONTH' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'IS_FIRST_OF_SMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'IS_LAST_OF_SMONTH' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'IS_LAST_OF_SMONTH' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'IS_LAST_OF_SMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'IS_FIRST_OF_SWEEK' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'IS_FIRST_OF_SWEEK' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'IS_FIRST_OF_SWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'IS_LAST_OF_SWEEK' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'IS_LAST_OF_SWEEK' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'IS_LAST_OF_SWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'START_DATE' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'END_DATE' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'TIME_SPAN' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'SWEEK_PART_NUM' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWEEK_PART_NUM' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SWEEK_PART_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'SWEEK_PART_SEQ' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWEEK_PART_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SWEEK_PART_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'SM_SMONTH_ID' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SM_SMONTH_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SM_SMONTH_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'SM_SMONTH_DESC' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SM_SMONTH_DESC' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SM_SMONTH_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'SM_SMYEAR_ID' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SM_SMYEAR_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SM_SMYEAR_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'SM_SMONTH_OF_SMYEAR' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SM_SMONTH_OF_SMYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SM_SMONTH_OF_SMYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'SM_SMONTH_NAME' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SM_SMONTH_NAME' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SM_SMONTH_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'SM_IS_FIRST_OF_SMYEAR' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SM_IS_FIRST_OF_SMYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SM_IS_FIRST_OF_SMYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'SM_IS_LAST_OF_SMYEAR' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SM_IS_LAST_OF_SMYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SM_IS_LAST_OF_SMYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'SM_START_DATE' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SM_START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SM_START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'SM_END_DATE' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SM_END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SM_END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'SM_TIME_SPAN' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SM_TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SM_TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'SM_SMONTH_NUM' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SM_SMONTH_NUM' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SM_SMONTH_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'SM_SMONTH_SEQ' ATTR_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'SM_SMONTH_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SM_SMONTH_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'SMY_SMYEAR_ID' ATTR_NAME,
             '7TH_MYEAR' LEVEL_NAME,
             'SMY_SMYEAR_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SMY_SMYEAR_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'SMY_SMYEAR_DESC' ATTR_NAME,
             '7TH_MYEAR' LEVEL_NAME,
             'SMY_SMYEAR_DESC' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SMY_SMYEAR_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'SMY_START_DATE' ATTR_NAME,
             '7TH_MYEAR' LEVEL_NAME,
             'SMY_START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SMY_START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'SMY_END_DATE' ATTR_NAME,
             '7TH_MYEAR' LEVEL_NAME,
             'SMY_END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SMY_END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'SMY_TIME_SPAN' ATTR_NAME,
             '7TH_MYEAR' LEVEL_NAME,
             'SMY_TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SMY_TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'SMY_SMYEAR_NUM' ATTR_NAME,
             '7TH_MYEAR' LEVEL_NAME,
             'SMY_SMYEAR_NUM' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SMY_SMYEAR_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YMSWP' HIERARCHY_NAME,
             'SMY_SMYEAR_SEQ' ATTR_NAME,
             '7TH_MYEAR' LEVEL_NAME,
             'SMY_SMYEAR_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SMY_SMYEAR_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      --7TH_YWSWP:V_DIM_TIME_7TH_YMWSWP
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'SWEEK_PART_ID' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWEEK_PART_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SWEEK_PART_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'SWEEK_PART_DESC' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWEEK_PART_DESC' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SWEEK_PART_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'SMONTH_ID' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SMONTH_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SMONTH_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'SWEEK_ID' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWEEK_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SWEEK_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'SWEEK_PART_OF_SMONTH' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWEEK_PART_OF_SMONTH' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SWEEK_PART_OF_SMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'SWEEK_PART_OF_SWEEK' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWEEK_PART_OF_SWEEK' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SWEEK_PART_OF_SWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'IS_FIRST_OF_SMONTH' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'IS_FIRST_OF_SMONTH' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'IS_FIRST_OF_SMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'IS_LAST_OF_SMONTH' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'IS_LAST_OF_SMONTH' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'IS_LAST_OF_SMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'IS_FIRST_OF_SWEEK' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'IS_FIRST_OF_SWEEK' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'IS_FIRST_OF_SWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'IS_LAST_OF_SWEEK' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'IS_LAST_OF_SWEEK' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'IS_LAST_OF_SWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'START_DATE' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'END_DATE' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'TIME_SPAN' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'SWEEK_PART_NUM' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWEEK_PART_NUM' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SWEEK_PART_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'SWEEK_PART_SEQ' ATTR_NAME,
             '7TH_WEEK_PART' LEVEL_NAME,
             'SWEEK_PART_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SWEEK_PART_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'SW_SWEEK_ID' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SW_SWEEK_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SW_SWEEK_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'SW_SWEEK_DESC' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SW_SWEEK_DESC' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SW_SWEEK_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'SW_SWYEAR_ID' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SW_SWYEAR_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SW_SWYEAR_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'SW_SWEEK_OF_SWYEAR' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SW_SWEEK_OF_SWYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SW_SWEEK_OF_SWYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'SW_IS_FIRST_OF_SWYEAR' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SW_IS_FIRST_OF_SWYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SW_IS_FIRST_OF_SWYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'SW_IS_LAST_OF_SWYEAR' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SW_IS_LAST_OF_SWYEAR' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SW_IS_LAST_OF_SWYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'SW_START_DATE' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SW_START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SW_START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'SW_END_DATE' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SW_END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SW_END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'SW_TIME_SPAN' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SW_TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SW_TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'SW_SWEEK_NUM' ATTR_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'SW_SWEEK_NUM' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SW_SWEEK_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'SWY_SWYEAR_ID' ATTR_NAME,
             '7TH_WYEAR' LEVEL_NAME,
             'SWY_SWYEAR_ID' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SWY_SWYEAR_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'SWY_SWYEAR_DESC' ATTR_NAME,
             '7TH_WYEAR' LEVEL_NAME,
             'SWY_SWYEAR_DESC' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SWY_SWYEAR_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'SWY_START_DATE' ATTR_NAME,
             '7TH_WYEAR' LEVEL_NAME,
             'SWY_START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SWY_START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'SWY_END_DATE' ATTR_NAME,
             '7TH_WYEAR' LEVEL_NAME,
             'SWY_END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SWY_END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'SWY_TIME_SPAN' ATTR_NAME,
             '7TH_WYEAR' LEVEL_NAME,
             'SWY_TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SWY_TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'SWY_SWYEAR_NUM' ATTR_NAME,
             '7TH_WYEAR' LEVEL_NAME,
             'SWY_SWYEAR_NUM' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SWY_SWYEAR_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             '7TH_YWSWP' HIERARCHY_NAME,
             'SWY_SWYEAR_SEQ' ATTR_NAME,
             '7TH_WYEAR' LEVEL_NAME,
             'SWY_SWYEAR_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_7TH_YMWSWP' DB_TAB_NAME,
             'SWY_SWYEAR_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      
      --V_DIM_TIME_CALENDAR_YM
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YM' HIERARCHY_NAME,
             'CMONTH_ID' ATTR_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'CMONTH_ID' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YM' DB_TAB_NAME,
             'CMONTH_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YM' HIERARCHY_NAME,
             'CMONTH_DESC' ATTR_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'CMONTH_DESC' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YM' DB_TAB_NAME,
             'CMONTH_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YM' HIERARCHY_NAME,
             'CYEAR_ID' ATTR_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'CYEAR_ID' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YM' DB_TAB_NAME,
             'CYEAR_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YM' HIERARCHY_NAME,
             'CMONTH_OF_CYEAR' ATTR_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'CMONTH_OF_CYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YM' DB_TAB_NAME,
             'CMONTH_OF_CYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YM' HIERARCHY_NAME,
             'CMONTH_NAME' ATTR_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'CMONTH_NAME' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YM' DB_TAB_NAME,
             'CMONTH_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YM' HIERARCHY_NAME,
             'IS_FIRST_OF_CYEAR' ATTR_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'IS_FIRST_OF_CYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YM' DB_TAB_NAME,
             'IS_FIRST_OF_CYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YM' HIERARCHY_NAME,
             'IS_LAST_OF_CYEAR' ATTR_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'IS_LAST_OF_CYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YM' DB_TAB_NAME,
             'IS_LAST_OF_CYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YM' HIERARCHY_NAME,
             'START_DATE' ATTR_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YM' DB_TAB_NAME,
             'START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YM' HIERARCHY_NAME,
             'END_DATE' ATTR_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YM' DB_TAB_NAME,
             'END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YM' HIERARCHY_NAME,
             'TIME_SPAN' ATTR_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YM' DB_TAB_NAME,
             'TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YM' HIERARCHY_NAME,
             'CMONTH_NUM' ATTR_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'CMONTH_NUM' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YM' DB_TAB_NAME,
             'CMONTH_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YM' HIERARCHY_NAME,
             'CMONTH_SEQ' ATTR_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'CMONTH_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YM' DB_TAB_NAME,
             'CMONTH_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YM' HIERARCHY_NAME,
             'CY_CYEAR_ID' ATTR_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'CY_CYEAR_ID' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YM' DB_TAB_NAME,
             'CY_CYEAR_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YM' HIERARCHY_NAME,
             'CY_CYEAR_DESC' ATTR_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'CY_CYEAR_DESC' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YM' DB_TAB_NAME,
             'CY_CYEAR_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YM' HIERARCHY_NAME,
             'CY_START_DATE' ATTR_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'CY_START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YM' DB_TAB_NAME,
             'CY_START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YM' HIERARCHY_NAME,
             'CY_END_DATE' ATTR_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'CY_END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YM' DB_TAB_NAME,
             'CY_END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YM' HIERARCHY_NAME,
             'CY_TIME_SPAN' ATTR_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'CY_TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YM' DB_TAB_NAME,
             'CY_TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YM' HIERARCHY_NAME,
             'CY_CYEAR_NUM' ATTR_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'CY_CYEAR_NUM' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YM' DB_TAB_NAME,
             'CY_CYEAR_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YM' HIERARCHY_NAME,
             'CY_CYEAR_SEQ' ATTR_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'CY_CYEAR_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YM' DB_TAB_NAME,
             'CY_CYEAR_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      --V_DIM_TIME_CALENDAR_YMD
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'DATE_ID' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DATE_ID' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'DATE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'DAY_DATE' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_DATE' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'DAY_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'DAY_DESC' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_DESC' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'DAY_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'CWEEK_ID' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'CWEEK_ID' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'CWEEK_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'CMONTH_ID' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'CMONTH_ID' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'CMONTH_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'IWEEK_ID' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IWEEK_ID' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'IWEEK_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'SWEEK_PART_ID' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'SWEEK_PART_ID' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'SWEEK_PART_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'DAY_OF_CWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_CWEEK' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'DAY_OF_CWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'DAY_OF_CMONTH' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_CMONTH' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'DAY_OF_CMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'DAY_OF_CYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_CYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'DAY_OF_CYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'DAY_OF_IWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_IWEEK' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'DAY_OF_IWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'DAY_OF_IYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_IYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'DAY_OF_IYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'DAY_OF_SWEEK_PART' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_SWEEK_PART' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'DAY_OF_SWEEK_PART' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'DAY_OF_SWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_SWEEK' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'DAY_OF_SWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'DAY_OF_SWYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_SWYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'DAY_OF_SWYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'DAY_OF_SMONTH' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_SMONTH' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'DAY_OF_SMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'DAY_OF_SMYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_SMYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'DAY_OF_SMYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'IS_FIRST_OF_CWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_CWEEK' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'IS_FIRST_OF_CWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'IS_LAST_OF_CWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_CWEEK' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'IS_LAST_OF_CWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'IS_FIRST_OF_CMONTH' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_CMONTH' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'IS_FIRST_OF_CMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'IS_LAST_OF_CMONTH' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_CMONTH' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'IS_LAST_OF_CMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'IS_FIRST_OF_CYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_CYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'IS_FIRST_OF_CYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'IS_LAST_OF_CYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_CYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'IS_LAST_OF_CYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'IS_FIRST_OF_IWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_IWEEK' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'IS_FIRST_OF_IWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'IS_LAST_OF_IWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_IWEEK' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'IS_LAST_OF_IWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'IS_FIRST_OF_IYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_IYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'IS_FIRST_OF_IYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'IS_LAST_OF_IYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_IYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'IS_LAST_OF_IYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'IS_FIRST_OF_SWEEK_PART' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_SWEEK_PART' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'IS_FIRST_OF_SWEEK_PART' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'IS_LAST_OF_SWEEK_PART' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_SWEEK_PART' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'IS_LAST_OF_SWEEK_PART' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'IS_FIRST_OF_SWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_SWEEK' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'IS_FIRST_OF_SWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'IS_LAST_OF_SWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_SWEEK' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'IS_LAST_OF_SWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'IS_FIRST_OF_SWYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_SWYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'IS_FIRST_OF_SWYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'IS_LAST_OF_SWYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_SWYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'IS_LAST_OF_SWYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'IS_FIRST_OF_SMONTH' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_SMONTH' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'IS_FIRST_OF_SMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'IS_LAST_OF_SMONTH' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_SMONTH' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'IS_LAST_OF_SMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'IS_FIRST_OF_SMYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_SMYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'IS_FIRST_OF_SMYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'IS_LAST_OF_SMYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_SMYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'IS_LAST_OF_SMYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'START_DATE' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'END_DATE' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'TIME_SPAN' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'DAY_NUM' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_NUM' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'DAY_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'DAY_SEQ' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'DAY_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'CM_CMONTH_ID' ATTR_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'CM_CMONTH_ID' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'CM_CMONTH_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'CM_CMONTH_DESC' ATTR_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'CM_CMONTH_DESC' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'CM_CMONTH_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'CM_CYEAR_ID' ATTR_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'CM_CYEAR_ID' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'CM_CYEAR_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'CM_CMONTH_OF_CYEAR' ATTR_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'CM_CMONTH_OF_CYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'CM_CMONTH_OF_CYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'CM_CMONTH_NAME' ATTR_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'CM_CMONTH_NAME' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'CM_CMONTH_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'CM_IS_FIRST_OF_CYEAR' ATTR_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'CM_IS_FIRST_OF_CYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'CM_IS_FIRST_OF_CYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'CM_IS_LAST_OF_CYEAR' ATTR_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'CM_IS_LAST_OF_CYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'CM_IS_LAST_OF_CYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'CM_START_DATE' ATTR_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'CM_START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'CM_START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'CM_END_DATE' ATTR_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'CM_END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'CM_END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'CM_TIME_SPAN' ATTR_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'CM_TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'CM_TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'CM_CMONTH_NUM' ATTR_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'CM_CMONTH_NUM' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'CM_CMONTH_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'CM_CMONTH_SEQ' ATTR_NAME,
             'CALENDAR_MONTH' LEVEL_NAME,
             'CM_CMONTH_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'CM_CMONTH_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'CY_CYEAR_ID' ATTR_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'CY_CYEAR_ID' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'CY_CYEAR_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'CY_CYEAR_DESC' ATTR_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'CY_CYEAR_DESC' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'CY_CYEAR_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'CY_START_DATE' ATTR_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'CY_START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'CY_START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'CY_END_DATE' ATTR_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'CY_END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'CY_END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'CY_TIME_SPAN' ATTR_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'CY_TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'CY_TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'CY_CYEAR_NUM' ATTR_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'CY_CYEAR_NUM' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'CY_CYEAR_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YMD' HIERARCHY_NAME,
             'CY_CYEAR_SEQ' ATTR_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'CY_CYEAR_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YMD' DB_TAB_NAME,
             'CY_CYEAR_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      --V_DIM_TIME_CALENDAR_YW
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YW' HIERARCHY_NAME,
             'CWEEK_ID' ATTR_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             'CWEEK_ID' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YW' DB_TAB_NAME,
             'CWEEK_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YW' HIERARCHY_NAME,
             'CWEEK_DESC' ATTR_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             'CWEEK_DESC' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YW' DB_TAB_NAME,
             'CWEEK_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YW' HIERARCHY_NAME,
             'CYEAR_ID' ATTR_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             'CYEAR_ID' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YW' DB_TAB_NAME,
             'CYEAR_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YW' HIERARCHY_NAME,
             'CWEEK_OF_CYEAR' ATTR_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             'CWEEK_OF_CYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YW' DB_TAB_NAME,
             'CWEEK_OF_CYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YW' HIERARCHY_NAME,
             'IS_FIRST_OF_CYEAR' ATTR_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             'IS_FIRST_OF_CYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YW' DB_TAB_NAME,
             'IS_FIRST_OF_CYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YW' HIERARCHY_NAME,
             'IS_LAST_OF_CYEAR' ATTR_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             'IS_LAST_OF_CYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YW' DB_TAB_NAME,
             'IS_LAST_OF_CYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YW' HIERARCHY_NAME,
             'START_DATE' ATTR_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             'START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YW' DB_TAB_NAME,
             'START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YW' HIERARCHY_NAME,
             'END_DATE' ATTR_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             'END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YW' DB_TAB_NAME,
             'END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YW' HIERARCHY_NAME,
             'TIME_SPAN' ATTR_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             'TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YW' DB_TAB_NAME,
             'TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YW' HIERARCHY_NAME,
             'CWEEK_NUM' ATTR_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             'CWEEK_NUM' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YW' DB_TAB_NAME,
             'CWEEK_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YW' HIERARCHY_NAME,
             'CWEEK_SEQ' ATTR_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             'CWEEK_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YW' DB_TAB_NAME,
             'CWEEK_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YW' HIERARCHY_NAME,
             'CY_CYEAR_ID' ATTR_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'CY_CYEAR_ID' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YW' DB_TAB_NAME,
             'CY_CYEAR_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YW' HIERARCHY_NAME,
             'CY_CYEAR_DESC' ATTR_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'CY_CYEAR_DESC' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YW' DB_TAB_NAME,
             'CY_CYEAR_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YW' HIERARCHY_NAME,
             'CY_START_DATE' ATTR_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'CY_START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YW' DB_TAB_NAME,
             'CY_START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YW' HIERARCHY_NAME,
             'CY_END_DATE' ATTR_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'CY_END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YW' DB_TAB_NAME,
             'CY_END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YW' HIERARCHY_NAME,
             'CY_TIME_SPAN' ATTR_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'CY_TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YW' DB_TAB_NAME,
             'CY_TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YW' HIERARCHY_NAME,
             'CY_CYEAR_NUM' ATTR_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'CY_CYEAR_NUM' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YW' DB_TAB_NAME,
             'CY_CYEAR_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YW' HIERARCHY_NAME,
             'CY_CYEAR_SEQ' ATTR_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'CY_CYEAR_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YW' DB_TAB_NAME,
             'CY_CYEAR_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      --V_DIM_TIME_CALENDAR_YWD
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'DATE_ID' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DATE_ID' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'DATE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'DAY_DATE' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_DATE' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'DAY_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'DAY_DESC' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_DESC' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'DAY_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'CWEEK_ID' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'CWEEK_ID' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'CWEEK_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'CMONTH_ID' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'CMONTH_ID' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'CMONTH_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'IWEEK_ID' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IWEEK_ID' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'IWEEK_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'SWEEK_PART_ID' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'SWEEK_PART_ID' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'SWEEK_PART_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'DAY_OF_CWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_CWEEK' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'DAY_OF_CWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'DAY_OF_CMONTH' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_CMONTH' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'DAY_OF_CMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'DAY_OF_CYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_CYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'DAY_OF_CYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'DAY_OF_IWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_IWEEK' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'DAY_OF_IWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'DAY_OF_IYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_IYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'DAY_OF_IYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'DAY_OF_SWEEK_PART' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_SWEEK_PART' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'DAY_OF_SWEEK_PART' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'DAY_OF_SWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_SWEEK' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'DAY_OF_SWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'DAY_OF_SWYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_SWYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'DAY_OF_SWYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'DAY_OF_SMONTH' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_SMONTH' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'DAY_OF_SMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'DAY_OF_SMYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_SMYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'DAY_OF_SMYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'IS_FIRST_OF_CWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_CWEEK' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'IS_FIRST_OF_CWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'IS_LAST_OF_CWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_CWEEK' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'IS_LAST_OF_CWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'IS_FIRST_OF_CMONTH' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_CMONTH' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'IS_FIRST_OF_CMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'IS_LAST_OF_CMONTH' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_CMONTH' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'IS_LAST_OF_CMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'IS_FIRST_OF_CYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_CYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'IS_FIRST_OF_CYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'IS_LAST_OF_CYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_CYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'IS_LAST_OF_CYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'IS_FIRST_OF_IWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_IWEEK' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'IS_FIRST_OF_IWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'IS_LAST_OF_IWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_IWEEK' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'IS_LAST_OF_IWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'IS_FIRST_OF_IYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_IYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'IS_FIRST_OF_IYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'IS_LAST_OF_IYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_IYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'IS_LAST_OF_IYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'IS_FIRST_OF_SWEEK_PART' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_SWEEK_PART' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'IS_FIRST_OF_SWEEK_PART' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'IS_LAST_OF_SWEEK_PART' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_SWEEK_PART' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'IS_LAST_OF_SWEEK_PART' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'IS_FIRST_OF_SWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_SWEEK' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'IS_FIRST_OF_SWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'IS_LAST_OF_SWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_SWEEK' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'IS_LAST_OF_SWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'IS_FIRST_OF_SWYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_SWYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'IS_FIRST_OF_SWYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'IS_LAST_OF_SWYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_SWYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'IS_LAST_OF_SWYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'IS_FIRST_OF_SMONTH' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_SMONTH' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'IS_FIRST_OF_SMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'IS_LAST_OF_SMONTH' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_SMONTH' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'IS_LAST_OF_SMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'IS_FIRST_OF_SMYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_SMYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'IS_FIRST_OF_SMYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'IS_LAST_OF_SMYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_SMYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'IS_LAST_OF_SMYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'START_DATE' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'END_DATE' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'TIME_SPAN' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'DAY_NUM' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_NUM' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'DAY_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'DAY_SEQ' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'DAY_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'CW_CWEEK_ID' ATTR_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             'CW_CWEEK_ID' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'CW_CWEEK_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'CW_CWEEK_DESC' ATTR_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             'CW_CWEEK_DESC' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'CW_CWEEK_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'CW_CYEAR_ID' ATTR_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             'CW_CYEAR_ID' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'CW_CYEAR_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'CW_CWEEK_OF_CYEAR' ATTR_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             'CW_CWEEK_OF_CYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'CW_CWEEK_OF_CYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'CW_IS_FIRST_OF_CYEAR' ATTR_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             'CW_IS_FIRST_OF_CYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'CW_IS_FIRST_OF_CYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'CW_IS_LAST_OF_CYEAR' ATTR_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             'CW_IS_LAST_OF_CYEAR' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'CW_IS_LAST_OF_CYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'CW_START_DATE' ATTR_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             'CW_START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'CW_START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'CW_END_DATE' ATTR_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             'CW_END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'CW_END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'CW_TIME_SPAN' ATTR_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             'CW_TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'CW_TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'CW_CWEEK_NUM' ATTR_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             'CW_CWEEK_NUM' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'CW_CWEEK_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'CW_CWEEK_SEQ' ATTR_NAME,
             'CALENDAR_WEEK' LEVEL_NAME,
             'CW_CWEEK_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'CW_CWEEK_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'CY_CYEAR_ID' ATTR_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'CY_CYEAR_ID' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'CY_CYEAR_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'CY_CYEAR_DESC' ATTR_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'CY_CYEAR_DESC' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'CY_CYEAR_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'CY_START_DATE' ATTR_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'CY_START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'CY_START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'CY_END_DATE' ATTR_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'CY_END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'CY_END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'CY_TIME_SPAN' ATTR_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'CY_TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'CY_TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'CY_CYEAR_NUM' ATTR_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'CY_CYEAR_NUM' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'CY_CYEAR_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'CALENDAR_YWD' HIERARCHY_NAME,
             'CY_CYEAR_SEQ' ATTR_NAME,
             'CALENDAR_YEAR' LEVEL_NAME,
             'CY_CYEAR_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_CALENDAR_YWD' DB_TAB_NAME,
             'CY_CYEAR_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      --V_DIM_TIME_ISO_YW
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YW' HIERARCHY_NAME,
             'IWEEK_ID' ATTR_NAME,
             'ISO_WEEK' LEVEL_NAME,
             'IWEEK_ID' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YW' DB_TAB_NAME,
             'IWEEK_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YW' HIERARCHY_NAME,
             'IWEEK_DESC' ATTR_NAME,
             'ISO_WEEK' LEVEL_NAME,
             'IWEEK_DESC' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YW' DB_TAB_NAME,
             'IWEEK_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YW' HIERARCHY_NAME,
             'IYEAR_ID' ATTR_NAME,
             'ISO_WEEK' LEVEL_NAME,
             'IYEAR_ID' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YW' DB_TAB_NAME,
             'IYEAR_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YW' HIERARCHY_NAME,
             'IWEEK_OF_IYEAR' ATTR_NAME,
             'ISO_WEEK' LEVEL_NAME,
             'IWEEK_OF_IYEAR' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YW' DB_TAB_NAME,
             'IWEEK_OF_IYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YW' HIERARCHY_NAME,
             'IS_FIRST_OF_IYEAR' ATTR_NAME,
             'ISO_WEEK' LEVEL_NAME,
             'IS_FIRST_OF_IYEAR' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YW' DB_TAB_NAME,
             'IS_FIRST_OF_IYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YW' HIERARCHY_NAME,
             'IS_LAST_OF_IYEAR' ATTR_NAME,
             'ISO_WEEK' LEVEL_NAME,
             'IS_LAST_OF_IYEAR' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YW' DB_TAB_NAME,
             'IS_LAST_OF_IYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YW' HIERARCHY_NAME,
             'START_DATE' ATTR_NAME,
             'ISO_WEEK' LEVEL_NAME,
             'START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YW' DB_TAB_NAME,
             'START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YW' HIERARCHY_NAME,
             'END_DATE' ATTR_NAME,
             'ISO_WEEK' LEVEL_NAME,
             'END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YW' DB_TAB_NAME,
             'END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YW' HIERARCHY_NAME,
             'TIME_SPAN' ATTR_NAME,
             'ISO_WEEK' LEVEL_NAME,
             'TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YW' DB_TAB_NAME,
             'TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YW' HIERARCHY_NAME,
             'IWEEK_NUM' ATTR_NAME,
             'ISO_WEEK' LEVEL_NAME,
             'IWEEK_NUM' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YW' DB_TAB_NAME,
             'IWEEK_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YW' HIERARCHY_NAME,
             'IWEEK_SEQ' ATTR_NAME,
             'ISO_WEEK' LEVEL_NAME,
             'IWEEK_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YW' DB_TAB_NAME,
             'IWEEK_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YW' HIERARCHY_NAME,
             'IY_IYEAR_ID' ATTR_NAME,
             'ISO_YEAR' LEVEL_NAME,
             'IY_IYEAR_ID' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YW' DB_TAB_NAME,
             'IY_IYEAR_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YW' HIERARCHY_NAME,
             'IY_IYEAR_DESC' ATTR_NAME,
             'ISO_YEAR' LEVEL_NAME,
             'IY_IYEAR_DESC' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YW' DB_TAB_NAME,
             'IY_IYEAR_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YW' HIERARCHY_NAME,
             'IY_START_DATE' ATTR_NAME,
             'ISO_YEAR' LEVEL_NAME,
             'IY_START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YW' DB_TAB_NAME,
             'IY_START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YW' HIERARCHY_NAME,
             'IY_END_DATE' ATTR_NAME,
             'ISO_YEAR' LEVEL_NAME,
             'IY_END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YW' DB_TAB_NAME,
             'IY_END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YW' HIERARCHY_NAME,
             'IY_TIME_SPAN' ATTR_NAME,
             'ISO_YEAR' LEVEL_NAME,
             'IY_TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YW' DB_TAB_NAME,
             'IY_TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YW' HIERARCHY_NAME,
             'IY_IYEAR_NUM' ATTR_NAME,
             'ISO_YEAR' LEVEL_NAME,
             'IY_IYEAR_NUM' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YW' DB_TAB_NAME,
             'IY_IYEAR_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YW' HIERARCHY_NAME,
             'IY_IYEAR_SEQ' ATTR_NAME,
             'ISO_YEAR' LEVEL_NAME,
             'IY_IYEAR_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YW' DB_TAB_NAME,
             'IY_IYEAR_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      --V_DIM_TIME_ISO_YWD
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'DATE_ID' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DATE_ID' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'DATE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'DAY_DATE' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_DATE' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'DAY_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'DAY_DESC' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_DESC' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'DAY_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'CWEEK_ID' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'CWEEK_ID' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'CWEEK_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'CMONTH_ID' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'CMONTH_ID' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'CMONTH_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IWEEK_ID' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IWEEK_ID' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IWEEK_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'SWEEK_PART_ID' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'SWEEK_PART_ID' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'SWEEK_PART_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'DAY_OF_CWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_CWEEK' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'DAY_OF_CWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'DAY_OF_CMONTH' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_CMONTH' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'DAY_OF_CMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'DAY_OF_CYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_CYEAR' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'DAY_OF_CYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'DAY_OF_IWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_IWEEK' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'DAY_OF_IWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'DAY_OF_IYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_IYEAR' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'DAY_OF_IYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'DAY_OF_SWEEK_PART' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_SWEEK_PART' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'DAY_OF_SWEEK_PART' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'DAY_OF_SWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_SWEEK' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'DAY_OF_SWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'DAY_OF_SWYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_SWYEAR' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'DAY_OF_SWYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'DAY_OF_SMONTH' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_SMONTH' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'DAY_OF_SMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'DAY_OF_SMYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_OF_SMYEAR' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'DAY_OF_SMYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IS_FIRST_OF_CWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_CWEEK' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IS_FIRST_OF_CWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IS_LAST_OF_CWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_CWEEK' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IS_LAST_OF_CWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IS_FIRST_OF_CMONTH' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_CMONTH' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IS_FIRST_OF_CMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IS_LAST_OF_CMONTH' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_CMONTH' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IS_LAST_OF_CMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IS_FIRST_OF_CYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_CYEAR' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IS_FIRST_OF_CYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IS_LAST_OF_CYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_CYEAR' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IS_LAST_OF_CYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IS_FIRST_OF_IWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_IWEEK' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IS_FIRST_OF_IWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IS_LAST_OF_IWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_IWEEK' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IS_LAST_OF_IWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IS_FIRST_OF_IYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_IYEAR' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IS_FIRST_OF_IYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IS_LAST_OF_IYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_IYEAR' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IS_LAST_OF_IYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IS_FIRST_OF_SWEEK_PART' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_SWEEK_PART' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IS_FIRST_OF_SWEEK_PART' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IS_LAST_OF_SWEEK_PART' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_SWEEK_PART' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IS_LAST_OF_SWEEK_PART' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IS_FIRST_OF_SWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_SWEEK' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IS_FIRST_OF_SWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IS_LAST_OF_SWEEK' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_SWEEK' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IS_LAST_OF_SWEEK' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IS_FIRST_OF_SWYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_SWYEAR' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IS_FIRST_OF_SWYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IS_LAST_OF_SWYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_SWYEAR' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IS_LAST_OF_SWYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IS_FIRST_OF_SMONTH' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_SMONTH' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IS_FIRST_OF_SMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IS_LAST_OF_SMONTH' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_SMONTH' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IS_LAST_OF_SMONTH' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IS_FIRST_OF_SMYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_FIRST_OF_SMYEAR' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IS_FIRST_OF_SMYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IS_LAST_OF_SMYEAR' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'IS_LAST_OF_SMYEAR' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IS_LAST_OF_SMYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'START_DATE' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'END_DATE' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'TIME_SPAN' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'DAY_NUM' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_NUM' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'DAY_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'DAY_SEQ' ATTR_NAME,
             'DAY' LEVEL_NAME,
             'DAY_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'DAY_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IW_IWEEK_ID' ATTR_NAME,
             'ISO_WEEK' LEVEL_NAME,
             'IW_IWEEK_ID' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IW_IWEEK_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IW_IWEEK_DESC' ATTR_NAME,
             'ISO_WEEK' LEVEL_NAME,
             'IW_IWEEK_DESC' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IW_IWEEK_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IW_IYEAR_ID' ATTR_NAME,
             'ISO_WEEK' LEVEL_NAME,
             'IW_IYEAR_ID' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IW_IYEAR_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IW_IWEEK_OF_IYEAR' ATTR_NAME,
             'ISO_WEEK' LEVEL_NAME,
             'IW_IWEEK_OF_IYEAR' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IW_IWEEK_OF_IYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IW_IS_FIRST_OF_IYEAR' ATTR_NAME,
             'ISO_WEEK' LEVEL_NAME,
             'IW_IS_FIRST_OF_IYEAR' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IW_IS_FIRST_OF_IYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IW_IS_LAST_OF_IYEAR' ATTR_NAME,
             'ISO_WEEK' LEVEL_NAME,
             'IW_IS_LAST_OF_IYEAR' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IW_IS_LAST_OF_IYEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IW_START_DATE' ATTR_NAME,
             'ISO_WEEK' LEVEL_NAME,
             'IW_START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IW_START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IW_END_DATE' ATTR_NAME,
             'ISO_WEEK' LEVEL_NAME,
             'IW_END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IW_END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IW_TIME_SPAN' ATTR_NAME,
             'ISO_WEEK' LEVEL_NAME,
             'IW_TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IW_TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IW_IWEEK_NUM' ATTR_NAME,
             'ISO_WEEK' LEVEL_NAME,
             'IW_IWEEK_NUM' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IW_IWEEK_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IW_IWEEK_SEQ' ATTR_NAME,
             'ISO_WEEK' LEVEL_NAME,
             'IW_IWEEK_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IW_IWEEK_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IY_IYEAR_ID' ATTR_NAME,
             'ISO_YEAR' LEVEL_NAME,
             'IY_IYEAR_ID' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IY_IYEAR_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IY_IYEAR_DESC' ATTR_NAME,
             'ISO_YEAR' LEVEL_NAME,
             'IY_IYEAR_DESC' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IY_IYEAR_DESC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IY_START_DATE' ATTR_NAME,
             'ISO_YEAR' LEVEL_NAME,
             'IY_START_DATE' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IY_START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IY_END_DATE' ATTR_NAME,
             'ISO_YEAR' LEVEL_NAME,
             'IY_END_DATE' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IY_END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IY_TIME_SPAN' ATTR_NAME,
             'ISO_YEAR' LEVEL_NAME,
             'IY_TIME_SPAN' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IY_TIME_SPAN' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IY_IYEAR_NUM' ATTR_NAME,
             'ISO_YEAR' LEVEL_NAME,
             'IY_IYEAR_NUM' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IY_IYEAR_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'DATE' DIM_NAME,
             'ISO_YWD' HIERARCHY_NAME,
             'IY_IYEAR_SEQ' ATTR_NAME,
             'ISO_YEAR' LEVEL_NAME,
             'IY_IYEAR_SEQ' BUSINESS_DESC,
             'V_DIM_TIME_ISO_YWD' DB_TAB_NAME,
             'IY_IYEAR_SEQ' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      --V_DIM_YEARSEASON_PRIMARY_STYLE
      SELECT 'YEAR_SEASON' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'YS_YEAR_SEASON_ID' ATTR_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'YS_YEAR_SEASON_ID' BUSINESS_DESC,
             'V_DIM_YEARSEASON_PRIMARY_STYLE' DB_TAB_NAME,
             'YS_YEAR_SEASON_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'YS_SOURCE_BUSKEY' ATTR_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'YS_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_YEARSEASON_PRIMARY_STYLE' DB_TAB_NAME,
             'YS_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'YS_STYLE_YEAR' ATTR_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'YS_STYLE_YEAR' BUSINESS_DESC,
             'V_DIM_YEARSEASON_PRIMARY_STYLE' DB_TAB_NAME,
             'YS_STYLE_YEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'YS_SEASON_NAME' ATTR_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'YS_SEASON_NAME' BUSINESS_DESC,
             'V_DIM_YEARSEASON_PRIMARY_STYLE' DB_TAB_NAME,
             'YS_SEASON_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'YS_ORI_SEASON_ID' ATTR_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'YS_ORI_SEASON_ID' BUSINESS_DESC,
             'V_DIM_YEARSEASON_PRIMARY_STYLE' DB_TAB_NAME,
             'YS_ORI_SEASON_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'RYS_YEAR_SEASON_ID' ATTR_NAME,
             'REAL_YEAR_SEASON' LEVEL_NAME,
             'RYS_YEAR_SEASON_ID' BUSINESS_DESC,
             'V_DIM_YEARSEASON_PRIMARY_STYLE' DB_TAB_NAME,
             'RYS_YEAR_SEASON_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'RYS_SOURCE_BUSKEY' ATTR_NAME,
             'REAL_YEAR_SEASON' LEVEL_NAME,
             'RYS_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_YEARSEASON_PRIMARY_STYLE' DB_TAB_NAME,
             'RYS_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'RYS_STYLE_YEAR' ATTR_NAME,
             'REAL_YEAR_SEASON' LEVEL_NAME,
             'RYS_STYLE_YEAR' BUSINESS_DESC,
             'V_DIM_YEARSEASON_PRIMARY_STYLE' DB_TAB_NAME,
             'RYS_STYLE_YEAR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'RYS_SEASON_NAME' ATTR_NAME,
             'REAL_YEAR_SEASON' LEVEL_NAME,
             'RYS_SEASON_NAME' BUSINESS_DESC,
             'V_DIM_YEARSEASON_PRIMARY_STYLE' DB_TAB_NAME,
             'RYS_SEASON_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'RYS_ORI_SEASON_ID' ATTR_NAME,
             'REAL_YEAR_SEASON' LEVEL_NAME,
             'RYS_ORI_SEASON_ID' BUSINESS_DESC,
             'V_DIM_YEARSEASON_PRIMARY_STYLE' DB_TAB_NAME,
             'RYS_ORI_SEASON_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'STYLE_YEAR_SEASON_ID' ATTR_NAME,
             'STYLE_YEAR_SEASON' LEVEL_NAME,
             'STYLE_YEAR_SEASON_ID' BUSINESS_DESC,
             'V_DIM_YEARSEASON_PRIMARY_STYLE' DB_TAB_NAME,
             'STYLE_YEAR_SEASON_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'STYLE_YEAR_SEASON' LEVEL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_YEARSEASON_PRIMARY_STYLE' DB_TAB_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'STYLE_COLOR_ID' ATTR_NAME,
             'STYLE_YEAR_SEASON' LEVEL_NAME,
             'STYLE_COLOR_ID' BUSINESS_DESC,
             'V_DIM_YEARSEASON_PRIMARY_STYLE' DB_TAB_NAME,
             'STYLE_COLOR_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'MONTH_ID' ATTR_NAME,
             'STYLE_YEAR_SEASON' LEVEL_NAME,
             'MONTH_ID' BUSINESS_DESC,
             'V_DIM_YEARSEASON_PRIMARY_STYLE' DB_TAB_NAME,
             'MONTH_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'YEAR_SEASON_ID' ATTR_NAME,
             'STYLE_YEAR_SEASON' LEVEL_NAME,
             'YEAR_SEASON_ID' BUSINESS_DESC,
             'V_DIM_YEARSEASON_PRIMARY_STYLE' DB_TAB_NAME,
             'YEAR_SEASON_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'YEAR_SEASON' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'REAL_YEAR_SEASON_ID' ATTR_NAME,
             'STYLE_YEAR_SEASON' LEVEL_NAME,
             'REAL_YEAR_SEASON_ID' BUSINESS_DESC,
             'V_DIM_YEARSEASON_PRIMARY_STYLE' DB_TAB_NAME,
             'REAL_YEAR_SEASON_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      --STORE.PRIAMRY_DETAIL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'AVAILABLE' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'AVAILABLE' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'AVAILABLE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'CLIMATE' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'CLIMATE' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'CLIMATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'CLOSE_DATE' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'CLOSE_DATE' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'CLOSE_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'COMMENTS' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'COMMENTS' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'COMMENTS' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'COMP_INDICATOR' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'COMP_INDICATOR' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'COMP_INDICATOR' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'COUNTRY' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'COUNTRY' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'COUNTRY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'DC' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'DC' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'DC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'DEMOGRAPHIC' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'DEMOGRAPHIC' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'DEMOGRAPHIC' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'DISPLAY_CAPACITY' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'DISPLAY_CAPACITY' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'DISPLAY_CAPACITY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'DISTANCE' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'DISTANCE' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'DISTANCE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'DOOR_NAME' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'DOOR_NAME' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'DOOR_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'DOOR_NUM' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'DOOR_NUM' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'DOOR_NUM' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'DOOR_TYPE' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'DOOR_TYPE' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'DOOR_TYPE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'ETHNICITY' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'ETHNICITY' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'ETHNICITY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'GEOGRAPHY' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'GEOGRAPHY' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'GEOGRAPHY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'GO_DATE' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'GO_DATE' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'GO_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'INVENTORY_CAPACITY' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'INVENTORY_CAPACITY' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'INVENTORY_CAPACITY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'LOC_ATTR1' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'LOC_ATTR1' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'LOC_ATTR1' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'LOC_ATTR2' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'LOC_ATTR2' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'LOC_ATTR2' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'LOC_ATTR3' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'LOC_ATTR3' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'LOC_ATTR3' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'LOC_ATTR4' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'LOC_ATTR4' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'LOC_ATTR4' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'LOC_ATTR5' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'LOC_ATTR5' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'LOC_ATTR5' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'LOC_ATTR6' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'LOC_ATTR6' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'LOC_ATTR6' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'LOC_ATTR7' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'LOC_ATTR7' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'LOC_ATTR7' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'ORI_COMPANY_DOOR_ID' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'ORI_COMPANY_DOOR_ID' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'ORI_COMPANY_DOOR_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'ORI_STORE_TYPE_ID' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'ORI_STORE_TYPE_ID' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'ORI_STORE_TYPE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'PRICING_ZONE' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'PRICING_ZONE' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'PRICING_ZONE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'REGION' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'REGION' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'REGION' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'REMODEL_END_DATE' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'REMODEL_END_DATE' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'REMODEL_END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'REMODEL_START_DATE' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'REMODEL_START_DATE' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'REMODEL_START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'REMODEL_TURN_DATE' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'REMODEL_TURN_DATE' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'REMODEL_TURN_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'SEQUENCE' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'SEQUENCE' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'SEQUENCE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'ORI_SISTER_DOOR_ID' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'ORI_SISTER_DOOR_ID' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'ORI_SISTER_DOOR_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'SISTER_STORE_ID' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'SISTER_STORE_ID' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'SISTER_STORE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'SOFT_DATE' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'SOFT_DATE' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'SOFT_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'STOCK_CATEGORY' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'STOCK CATEGORY' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'STOCK_CATEGORY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'STORE_CATEGORY' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'STORE_CATEGORY' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'STORE_CATEGORY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'STORE_GROUP' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'STORE_GROUP' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'STORE_GROUP' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'STORE_ID' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'STORE_ID' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'STORE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'STORE_LOC_ID' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'STORE_LOC_ID' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'STORE_LOC_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'STORE_TYPE' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'STORE_TYPE' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'STORE_TYPE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'TOTAL_SQ_FT' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'TOTAL_SQ_FT' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'TOTAL_SQ_FT' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'TRANSFER_DOOR_ID' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'TRANSFER_DOOR_ID' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'TRANSFER_DOOR_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'TURN_DATE' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'TURN_DATE' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'TURN_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'PRIMARY_DETAIL' HIER_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'TARGET_BUSKEY' BUSINESS_DESC,
             'DIM_STORE_STORE' DB_TAB_NAME,
             'TARGET_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'S_SALES_STYLE_ID' ATTR_NAME,
             'SALES_STYLE' LEVEL_NAME,
             'S_SALES_STYLE_ID' BUSINESS_DESC,
             'V_DIM_PROMO_PRIMARY_PROMOTION' DB_TAB_NAME,
             'S_SALES_STYLE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'S_SOURCE_BUSKEY' ATTR_NAME,
             'SALES_STYLE' LEVEL_NAME,
             'S_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_PROMO_PRIMARY_PROMOTION' DB_TAB_NAME,
             'S_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'S_SALES_STYLE_CODE' ATTR_NAME,
             'SALES_STYLE' LEVEL_NAME,
             'S_SALES_STYLE_CODE' BUSINESS_DESC,
             'V_DIM_PROMO_PRIMARY_PROMOTION' DB_TAB_NAME,
             'S_SALES_STYLE_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'S_SALES_STYLE_NAME' ATTR_NAME,
             'SALES_STYLE' LEVEL_NAME,
             'S_SALES_STYLE_NAME' BUSINESS_DESC,
             'V_DIM_PROMO_PRIMARY_PROMOTION' DB_TAB_NAME,
             'S_SALES_STYLE_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'S_ORI_SALES_STYLE_ID' ATTR_NAME,
             'SALES_STYLE' LEVEL_NAME,
             'S_ORI_SALES_STYLE_ID' BUSINESS_DESC,
             'V_DIM_PROMO_PRIMARY_PROMOTION' DB_TAB_NAME,
             'S_ORI_SALES_STYLE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'PROMOTION_ID' ATTR_NAME,
             'PROMOTION' LEVEL_NAME,
             'PROMOTION_ID' BUSINESS_DESC,
             'V_DIM_PROMO_PRIMARY_PROMOTION' DB_TAB_NAME,
             'PROMOTION_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'PROMOTION' LEVEL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_PROMO_PRIMARY_PROMOTION' DB_TAB_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'SALES_STYLE_ID' ATTR_NAME,
             'PROMOTION' LEVEL_NAME,
             'SALES_STYLE_ID' BUSINESS_DESC,
             'V_DIM_PROMO_PRIMARY_PROMOTION' DB_TAB_NAME,
             'SALES_STYLE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'GROUP_CODE' ATTR_NAME,
             'PROMOTION' LEVEL_NAME,
             'GROUP_CODE' BUSINESS_DESC,
             'V_DIM_PROMO_PRIMARY_PROMOTION' DB_TAB_NAME,
             'GROUP_CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'GROUP_NAME' ATTR_NAME,
             'PROMOTION' LEVEL_NAME,
             'GROUP_NAME' BUSINESS_DESC,
             'V_DIM_PROMO_PRIMARY_PROMOTION' DB_TAB_NAME,
             'GROUP_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'TYPE' ATTR_NAME,
             'PROMOTION' LEVEL_NAME,
             'TYPE' BUSINESS_DESC,
             'V_DIM_PROMO_PRIMARY_PROMOTION' DB_TAB_NAME,
             'TYPE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'CODE' ATTR_NAME,
             'PROMOTION' LEVEL_NAME,
             'CODE' BUSINESS_DESC,
             'V_DIM_PROMO_PRIMARY_PROMOTION' DB_TAB_NAME,
             'CODE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'NAME' ATTR_NAME,
             'PROMOTION' LEVEL_NAME,
             'NAME' BUSINESS_DESC,
             'V_DIM_PROMO_PRIMARY_PROMOTION' DB_TAB_NAME,
             'NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'START_DATE' ATTR_NAME,
             'PROMOTION' LEVEL_NAME,
             'START_DATE' BUSINESS_DESC,
             'V_DIM_PROMO_PRIMARY_PROMOTION' DB_TAB_NAME,
             'START_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'END_DATE' ATTR_NAME,
             'PROMOTION' LEVEL_NAME,
             'END_DATE' BUSINESS_DESC,
             'V_DIM_PROMO_PRIMARY_PROMOTION' DB_TAB_NAME,
             'END_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PRIMARY' HIERARCHY_NAME,
             'PROMO_PERCENT' ATTR_NAME,
             'PROMOTION' LEVEL_NAME,
             'PROMO_PERCENT' BUSINESS_DESC,
             'V_DIM_PROMO_PRIMARY_PROMOTION' DB_TAB_NAME,
             'PROMO_PERCENT' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'P_PROD_ATTR_ID' ATTR_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'P_PROD_ATTR_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'P_PROD_ATTR_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'P_PROD_ATTR_NAME1' ATTR_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'P_PROD_ATTR_NAME1' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'P_PROD_ATTR_NAME1' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'P_PROD_ATTR_NAME2' ATTR_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'P_PROD_ATTR_NAME2' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'P_PROD_ATTR_NAME2' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'P_PROD_ATTR_NAME3' ATTR_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'P_PROD_ATTR_NAME3' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'P_PROD_ATTR_NAME3' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'P_PROD_ATTR_NAME4' ATTR_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'P_PROD_ATTR_NAME4' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'P_PROD_ATTR_NAME4' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'P_PROD_ATTR_NAME5' ATTR_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'P_PROD_ATTR_NAME5' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'P_PROD_ATTR_NAME5' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'P_PROD_ATTR_NAME6' ATTR_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'P_PROD_ATTR_NAME6' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'P_PROD_ATTR_NAME6' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'P_PROD_ATTR_NAME7' ATTR_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'P_PROD_ATTR_NAME7' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'P_PROD_ATTR_NAME7' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'P_PROD_ATTR_NAME8' ATTR_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'P_PROD_ATTR_NAME8' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'P_PROD_ATTR_NAME8' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'P_PROD_ATTR_NAME9' ATTR_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'P_PROD_ATTR_NAME9' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'P_PROD_ATTR_NAME9' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'P_PROD_ATTR_NAME10' ATTR_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'P_PROD_ATTR_NAME10' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'P_PROD_ATTR_NAME10' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'P_PROD_ATTR_NAME11' ATTR_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'P_PROD_ATTR_NAME11' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'P_PROD_ATTR_NAME11' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'P_PROD_ATTR_NAME12' ATTR_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'P_PROD_ATTR_NAME12' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'P_PROD_ATTR_NAME12' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'P_PROD_ATTR_NAME13' ATTR_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'P_PROD_ATTR_NAME13' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'P_PROD_ATTR_NAME13' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'P_PROD_ATTR_NAME14' ATTR_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'P_PROD_ATTR_NAME14' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'P_PROD_ATTR_NAME14' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'P_PROD_ATTR_NAME15' ATTR_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'P_PROD_ATTR_NAME15' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'P_PROD_ATTR_NAME15' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'P_PROD_ATTR_NAME16' ATTR_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'P_PROD_ATTR_NAME16' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'P_PROD_ATTR_NAME16' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'P_PROD_ATTR_NAME17' ATTR_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'P_PROD_ATTR_NAME17' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'P_PROD_ATTR_NAME17' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'P_PROD_ATTR_NAME18' ATTR_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'P_PROD_ATTR_NAME18' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'P_PROD_ATTR_NAME18' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'P_PROD_ATTR_NAME19' ATTR_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'P_PROD_ATTR_NAME19' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'P_PROD_ATTR_NAME19' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'P_PROD_ATTR_NAME20' ATTR_NAME,
             'PROD_ATTR' LEVEL_NAME,
             'P_PROD_ATTR_NAME20' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'P_PROD_ATTR_NAME20' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'PROD_ATTR_VALUE_ID' ATTR_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'PROD_ATTR_VALUE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'PROD_ATTR_ID' ATTR_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_ID' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'PROD_ATTR_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'PROD_ATTR_VALUE1' ATTR_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE1' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'PROD_ATTR_VALUE1' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'PROD_ATTR_VALUE2' ATTR_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE2' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'PROD_ATTR_VALUE2' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'PROD_ATTR_VALUE3' ATTR_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE3' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'PROD_ATTR_VALUE3' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'PROD_ATTR_VALUE4' ATTR_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE4' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'PROD_ATTR_VALUE4' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'PROD_ATTR_VALUE5' ATTR_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE5' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'PROD_ATTR_VALUE5' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'PROD_ATTR_VALUE6' ATTR_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE6' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'PROD_ATTR_VALUE6' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'PROD_ATTR_VALUE7' ATTR_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE7' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'PROD_ATTR_VALUE7' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'PROD_ATTR_VALUE8' ATTR_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE8' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'PROD_ATTR_VALUE8' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'PROD_ATTR_VALUE9' ATTR_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE9' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'PROD_ATTR_VALUE9' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'PROD_ATTR_VALUE10' ATTR_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE10' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'PROD_ATTR_VALUE10' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'PROD_ATTR_VALUE11' ATTR_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE11' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'PROD_ATTR_VALUE11' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'PROD_ATTR_VALUE12' ATTR_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE12' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'PROD_ATTR_VALUE12' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'PROD_ATTR_VALUE13' ATTR_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE13' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'PROD_ATTR_VALUE13' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'PROD_ATTR_VALUE14' ATTR_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE14' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'PROD_ATTR_VALUE14' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'PROD_ATTR_VALUE15' ATTR_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE15' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'PROD_ATTR_VALUE15' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'PROD_ATTR_VALUE16' ATTR_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE16' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'PROD_ATTR_VALUE16' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'PROD_ATTR_VALUE17' ATTR_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE17' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'PROD_ATTR_VALUE17' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'PROD_ATTR_VALUE18' ATTR_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE18' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'PROD_ATTR_VALUE18' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'PROD_ATTR_VALUE19' ATTR_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE19' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'PROD_ATTR_VALUE19' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'PAV_VALUE' HIERARCHY_NAME,
             'PROD_ATTR_VALUE20' ATTR_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'PROD_ATTR_VALUE20' BUSINESS_DESC,
             'V_DIM_STYLE_PAV_VALUE' DB_TAB_NAME,
             'PROD_ATTR_VALUE20' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'L_LOC_ATTR_ID' ATTR_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'L_LOC_ATTR_ID' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'L_LOC_ATTR_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'L_LOC_ATTR_NAME1' ATTR_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'L_LOC_ATTR_NAME1' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'L_LOC_ATTR_NAME1' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'L_LOC_ATTR_NAME2' ATTR_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'L_LOC_ATTR_NAME2' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'L_LOC_ATTR_NAME2' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'L_LOC_ATTR_NAME3' ATTR_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'L_LOC_ATTR_NAME3' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'L_LOC_ATTR_NAME3' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'L_LOC_ATTR_NAME4' ATTR_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'L_LOC_ATTR_NAME4' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'L_LOC_ATTR_NAME4' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'L_LOC_ATTR_NAME5' ATTR_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'L_LOC_ATTR_NAME5' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'L_LOC_ATTR_NAME5' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'L_LOC_ATTR_NAME6' ATTR_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'L_LOC_ATTR_NAME6' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'L_LOC_ATTR_NAME6' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'L_LOC_ATTR_NAME7' ATTR_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'L_LOC_ATTR_NAME7' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'L_LOC_ATTR_NAME7' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'L_LOC_ATTR_NAME8' ATTR_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'L_LOC_ATTR_NAME8' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'L_LOC_ATTR_NAME8' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'L_LOC_ATTR_NAME9' ATTR_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'L_LOC_ATTR_NAME9' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'L_LOC_ATTR_NAME9' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'L_LOC_ATTR_NAME10' ATTR_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'L_LOC_ATTR_NAME10' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'L_LOC_ATTR_NAME10' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'L_LOC_ATTR_NAME11' ATTR_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'L_LOC_ATTR_NAME11' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'L_LOC_ATTR_NAME11' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'L_LOC_ATTR_NAME12' ATTR_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'L_LOC_ATTR_NAME12' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'L_LOC_ATTR_NAME12' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'L_LOC_ATTR_NAME13' ATTR_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'L_LOC_ATTR_NAME13' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'L_LOC_ATTR_NAME13' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'L_LOC_ATTR_NAME14' ATTR_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'L_LOC_ATTR_NAME14' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'L_LOC_ATTR_NAME14' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'L_LOC_ATTR_NAME15' ATTR_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'L_LOC_ATTR_NAME15' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'L_LOC_ATTR_NAME15' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'L_LOC_ATTR_NAME16' ATTR_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'L_LOC_ATTR_NAME16' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'L_LOC_ATTR_NAME16' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'L_LOC_ATTR_NAME17' ATTR_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'L_LOC_ATTR_NAME17' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'L_LOC_ATTR_NAME17' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'L_LOC_ATTR_NAME18' ATTR_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'L_LOC_ATTR_NAME18' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'L_LOC_ATTR_NAME18' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'L_LOC_ATTR_NAME19' ATTR_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'L_LOC_ATTR_NAME19' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'L_LOC_ATTR_NAME19' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'L_LOC_ATTR_NAME20' ATTR_NAME,
             'LOC_ATTR' LEVEL_NAME,
             'L_LOC_ATTR_NAME20' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'L_LOC_ATTR_NAME20' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'LOC_ATTR_VALUE_ID' ATTR_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE_ID' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'LOC_ATTR_VALUE_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'LOC_ATTR_ID' ATTR_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_ID' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'LOC_ATTR_ID' DB_COL_NAME,
             'N' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'LOC_ATTR_VALUE1' ATTR_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE1' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'LOC_ATTR_VALUE1' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'LOC_ATTR_VALUE2' ATTR_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE2' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'LOC_ATTR_VALUE2' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'LOC_ATTR_VALUE3' ATTR_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE3' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'LOC_ATTR_VALUE3' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'LOC_ATTR_VALUE4' ATTR_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE4' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'LOC_ATTR_VALUE4' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'LOC_ATTR_VALUE5' ATTR_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE5' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'LOC_ATTR_VALUE5' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'LOC_ATTR_VALUE6' ATTR_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE6' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'LOC_ATTR_VALUE6' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'LOC_ATTR_VALUE7' ATTR_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE7' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'LOC_ATTR_VALUE7' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'LOC_ATTR_VALUE8' ATTR_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE8' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'LOC_ATTR_VALUE8' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'LOC_ATTR_VALUE9' ATTR_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE9' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'LOC_ATTR_VALUE9' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'LOC_ATTR_VALUE10' ATTR_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE10' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'LOC_ATTR_VALUE10' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'LOC_ATTR_VALUE11' ATTR_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE11' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'LOC_ATTR_VALUE11' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'LOC_ATTR_VALUE12' ATTR_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE12' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'LOC_ATTR_VALUE12' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'LOC_ATTR_VALUE13' ATTR_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE13' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'LOC_ATTR_VALUE13' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'LOC_ATTR_VALUE14' ATTR_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE14' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'LOC_ATTR_VALUE14' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'LOC_ATTR_VALUE15' ATTR_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE15' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'LOC_ATTR_VALUE15' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'LOC_ATTR_VALUE16' ATTR_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE16' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'LOC_ATTR_VALUE16' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'LOC_ATTR_VALUE17' ATTR_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE17' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'LOC_ATTR_VALUE17' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'LOC_ATTR_VALUE18' ATTR_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE18' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'LOC_ATTR_VALUE18' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'LOC_ATTR_VALUE19' ATTR_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE19' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'LOC_ATTR_VALUE19' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'LAV_VALUE' HIERARCHY_NAME,
             'LOC_ATTR_VALUE20' ATTR_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'LOC_ATTR_VALUE20' BUSINESS_DESC,
             'V_DIM_STORE_LAV_VALUE' DB_TAB_NAME,
             'LOC_ATTR_VALUE20' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'PB_PO_BD_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_PO_BD_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PB_PO_BD_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'PB_SOURCE_BUSKEY' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PB_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'PB_PO_NUMBER' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_PO_NUMBER' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PB_PO_NUMBER' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'PB_PO_BD_DATE' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_PO_BD_DATE' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PB_PO_BD_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'PB_PO_BD_NAME' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_PO_BD_NAME' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PB_PO_BD_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'PB_PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PB_PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'PB_LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PB_LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'PB_YS_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_YS_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PB_YS_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'PO_BD_RELEASE_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PO_BD_RELEASE_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PO_BD_RELEASE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'PO_BD_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PO_BD_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PO_BD_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'PO_BD_RELEASE_DATE' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PO_BD_RELEASE_DATE' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PO_BD_RELEASE_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'PO_BD_RELEASE_NAME' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PO_BD_RELEASE_NAME' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PO_BD_RELEASE_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PB_PO_BD_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_PO_BD_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PB_PO_BD_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PB_SOURCE_BUSKEY' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PB_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PB_PO_NUMBER' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_PO_NUMBER' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PB_PO_NUMBER' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PB_PO_BD_DATE' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_PO_BD_DATE' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PB_PO_BD_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PB_PO_BD_NAME' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_PO_BD_NAME' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PB_PO_BD_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PB_PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PB_PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PB_LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PB_LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PB_YS_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_YS_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PB_YS_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PBR_PO_BD_RELEASE_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_PO_BD_RELEASE_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PBR_PO_BD_RELEASE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PBR_SOURCE_BUSKEY' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PBR_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PBR_PO_BD_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_PO_BD_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PBR_PO_BD_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PBR_PO_BD_RELEASE_DATE' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_PO_BD_RELEASE_DATE' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PBR_PO_BD_RELEASE_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PBR_PO_BD_RELEASE_NAME' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_PO_BD_RELEASE_NAME' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PBR_PO_BD_RELEASE_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PBR_PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PBR_PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PBR_LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PBR_LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PBR_YS_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_YS_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PBR_YS_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PO_ALLOCATE_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PO_ALLOCATE_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PO_ALLOCATE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PO_ALLOCATE_DATE' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PO_ALLOCATE_DATE' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PO_ALLOCATE_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PO_ALLOCATE_NAME' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PO_ALLOCATE_NAME' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PO_ALLOCATE_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PO_BD_RELEASE_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PO_BD_RELEASE_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PO_BD_RELEASE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PB_PO_BD_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_PO_BD_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'PB_PO_BD_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PB_SOURCE_BUSKEY' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'PB_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PB_PO_NUMBER' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_PO_NUMBER' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'PB_PO_NUMBER' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PB_PO_BD_DATE' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_PO_BD_DATE' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'PB_PO_BD_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PB_PO_BD_NAME' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_PO_BD_NAME' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'PB_PO_BD_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PB_PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'PB_PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PB_LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'PB_LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PB_YS_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_YS_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'PB_YS_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PBR_PO_BD_RELEASE_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_PO_BD_RELEASE_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'PBR_PO_BD_RELEASE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PBR_SOURCE_BUSKEY' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'PBR_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PBR_PO_BD_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_PO_BD_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'PBR_PO_BD_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PBR_PO_BD_RELEASE_DATE' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_PO_BD_RELEASE_DATE' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'PBR_PO_BD_RELEASE_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PBR_PO_BD_RELEASE_NAME' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_PO_BD_RELEASE_NAME' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'PBR_PO_BD_RELEASE_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PBR_PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'PBR_PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PBR_LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'PBR_LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PBR_YS_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_YS_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'PBR_YS_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PA_PO_ALLOCATE_ID' ATTR_NAME,
             'ALLOCATE' LEVEL_NAME,
             'PA_PO_ALLOCATE_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'PA_PO_ALLOCATE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PA_SOURCE_BUSKEY' ATTR_NAME,
             'ALLOCATE' LEVEL_NAME,
             'PA_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'PA_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PA_PO_ALLOCATE_DATE' ATTR_NAME,
             'ALLOCATE' LEVEL_NAME,
             'PA_PO_ALLOCATE_DATE' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'PA_PO_ALLOCATE_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PA_PO_ALLOCATE_NAME' ATTR_NAME,
             'ALLOCATE' LEVEL_NAME,
             'PA_PO_ALLOCATE_NAME' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'PA_PO_ALLOCATE_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PA_PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'ALLOCATE' LEVEL_NAME,
             'PA_PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'PA_PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PA_LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'ALLOCATE' LEVEL_NAME,
             'PA_LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'PA_LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PA_YS_CRITERIA_GROUP_ID' ATTR_NAME,
             'ALLOCATE' LEVEL_NAME,
             'PA_YS_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'PA_YS_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PA_PO_BD_RELEASE_ID' ATTR_NAME,
             'ALLOCATE' LEVEL_NAME,
             'PA_PO_BD_RELEASE_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'PA_PO_BD_RELEASE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PO_RELEASE_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PO_RELEASE_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'PO_RELEASE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PO_ALLOCATE_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PO_ALLOCATE_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'PO_ALLOCATE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PO_RELEASE_DATE' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PO_RELEASE_DATE' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'PO_RELEASE_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PO_RELEASE_NAME' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PO_RELEASE_NAME' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'PO_RELEASE_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_PO_PRIMARY_RELEASE' DB_TAB_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'PB_ASN_BD_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_ASN_BD_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PB_ASN_BD_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'PB_SOURCE_BUSKEY' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PB_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'PB_ASN_NUMBER' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_ASN_NUMBER' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PB_ASN_NUMBER' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'PB_ASN_BD_DATE' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_ASN_BD_DATE' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PB_ASN_BD_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'PB_ASN_BD_NAME' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_ASN_BD_NAME' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PB_ASN_BD_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'PB_PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PB_PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'PB_LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PB_LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'PB_YS_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_YS_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PB_YS_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'ASN_BD_RELEASE_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'ASN_BD_RELEASE_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'ASN_BD_RELEASE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'ASN_BD_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'ASN_BD_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'ASN_BD_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'ASN_BD_RELEASE_DATE' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'ASN_BD_RELEASE_DATE' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'ASN_BD_RELEASE_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'ASN_BD_RELEASE_NAME' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'ASN_BD_RELEASE_NAME' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'ASN_BD_RELEASE_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PB_ASN_BD_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_ASN_BD_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PB_ASN_BD_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PB_SOURCE_BUSKEY' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PB_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PB_ASN_NUMBER' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_ASN_NUMBER' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PB_ASN_NUMBER' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PB_ASN_BD_DATE' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_ASN_BD_DATE' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PB_ASN_BD_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PB_ASN_BD_NAME' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_ASN_BD_NAME' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PB_ASN_BD_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PB_PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PB_PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PB_LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PB_LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PB_YS_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_YS_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PB_YS_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PBR_ASN_BD_RELEASE_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_ASN_BD_RELEASE_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PBR_ASN_BD_RELEASE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PBR_SOURCE_BUSKEY' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PBR_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PBR_ASN_BD_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_ASN_BD_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PBR_ASN_BD_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PBR_ASN_BD_RELEASE_DATE' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_ASN_BD_RELEASE_DATE' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PBR_ASN_BD_RELEASE_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PBR_ASN_BD_RELEASE_NAME' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_ASN_BD_RELEASE_NAME' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PBR_ASN_BD_RELEASE_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PBR_PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PBR_PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PBR_LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PBR_LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PBR_YS_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_YS_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PBR_YS_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'ASN_ALLOCATE_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'ASN_ALLOCATE_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'ASN_ALLOCATE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'ASN_ALLOCATE_DATE' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'ASN_ALLOCATE_DATE' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'ASN_ALLOCATE_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'ASN_ALLOCATE_NAME' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'ASN_ALLOCATE_NAME' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'ASN_ALLOCATE_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'ASN_BD_RELEASE_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'ASN_BD_RELEASE_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'ASN_BD_RELEASE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PB_ASN_BD_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_ASN_BD_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'PB_ASN_BD_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PB_SOURCE_BUSKEY' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'PB_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PB_ASN_NUMBER' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_ASN_NUMBER' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'PB_ASN_NUMBER' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PB_ASN_BD_DATE' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_ASN_BD_DATE' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'PB_ASN_BD_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PB_ASN_BD_NAME' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_ASN_BD_NAME' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'PB_ASN_BD_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PB_PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'PB_PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PB_LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'PB_LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PB_YS_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_YS_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'PB_YS_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PBR_ASN_BD_RELEASE_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_ASN_BD_RELEASE_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'PBR_ASN_BD_RELEASE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PBR_SOURCE_BUSKEY' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'PBR_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PBR_ASN_BD_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_ASN_BD_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'PBR_ASN_BD_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PBR_ASN_BD_RELEASE_DATE' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_ASN_BD_RELEASE_DATE' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'PBR_ASN_BD_RELEASE_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PBR_ASN_BD_RELEASE_NAME' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_ASN_BD_RELEASE_NAME' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'PBR_ASN_BD_RELEASE_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PBR_PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'PBR_PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PBR_LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'PBR_LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PBR_YS_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_YS_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'PBR_YS_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PA_ASN_ALLOCATE_ID' ATTR_NAME,
             'ALLOCATE' LEVEL_NAME,
             'PA_ASN_ALLOCATE_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'PA_ASN_ALLOCATE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PA_SOURCE_BUSKEY' ATTR_NAME,
             'ALLOCATE' LEVEL_NAME,
             'PA_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'PA_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PA_ASN_ALLOCATE_DATE' ATTR_NAME,
             'ALLOCATE' LEVEL_NAME,
             'PA_ASN_ALLOCATE_DATE' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'PA_ASN_ALLOCATE_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PA_ASN_ALLOCATE_NAME' ATTR_NAME,
             'ALLOCATE' LEVEL_NAME,
             'PA_ASN_ALLOCATE_NAME' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'PA_ASN_ALLOCATE_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PA_PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'ALLOCATE' LEVEL_NAME,
             'PA_PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'PA_PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PA_LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'ALLOCATE' LEVEL_NAME,
             'PA_LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'PA_LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PA_YS_CRITERIA_GROUP_ID' ATTR_NAME,
             'ALLOCATE' LEVEL_NAME,
             'PA_YS_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'PA_YS_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PA_ASN_BD_RELEASE_ID' ATTR_NAME,
             'ALLOCATE' LEVEL_NAME,
             'PA_ASN_BD_RELEASE_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'PA_ASN_BD_RELEASE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'ASN_RELEASE_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'ASN_RELEASE_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'ASN_RELEASE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'ASN_ALLOCATE_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'ASN_ALLOCATE_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'ASN_ALLOCATE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'ASN_RELEASE_DATE' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'ASN_RELEASE_DATE' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'ASN_RELEASE_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'ASN_RELEASE_NAME' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'ASN_RELEASE_NAME' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'ASN_RELEASE_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_ASN_PRIMARY_RELEASE' DB_TAB_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'PB_RECEIVER_BD_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_RECEIVER_BD_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PB_RECEIVER_BD_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'PB_SOURCE_BUSKEY' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PB_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'PB_RECEIVER_NUMBER' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_RECEIVER_NUMBER' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PB_RECEIVER_NUMBER' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'PB_RECEIVER_BD_DATE' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_RECEIVER_BD_DATE' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PB_RECEIVER_BD_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'PB_RECEIVER_BD_NAME' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_RECEIVER_BD_NAME' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PB_RECEIVER_BD_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'PB_PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PB_PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'PB_LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PB_LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'PB_YS_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_YS_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PB_YS_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'RECEIVER_BD_RELEASE_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'RECEIVER_BD_RELEASE_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'RECEIVER_BD_RELEASE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'RECEIVER_BD_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'RECEIVER_BD_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'RECEIVER_BD_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'RECEIVER_BD_RELEASE_DATE' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'RECEIVER_BD_RELEASE_DATE' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'RECEIVER_BD_RELEASE_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'RECEIVER_BD_RELEASE_NAME' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'RECEIVER_BD_RELEASE_NAME' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'RECEIVER_BD_RELEASE_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_BD_RELEASE' HIERARCHY_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_BD_RELEASE' DB_TAB_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PB_RECEIVER_BD_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_RECEIVER_BD_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PB_RECEIVER_BD_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PB_SOURCE_BUSKEY' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PB_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PB_RECEIVER_NUMBER' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_RECEIVER_NUMBER' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PB_RECEIVER_NUMBER' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PB_RECEIVER_BD_DATE' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_RECEIVER_BD_DATE' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PB_RECEIVER_BD_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PB_RECEIVER_BD_NAME' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_RECEIVER_BD_NAME' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PB_RECEIVER_BD_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PB_PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PB_PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PB_LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PB_LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PB_YS_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_YS_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PB_YS_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PBR_RECEIVER_BD_RELEASE_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_RECEIVER_BD_RELEASE_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PBR_RECEIVER_BD_RELEASE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PBR_SOURCE_BUSKEY' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PBR_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PBR_RECEIVER_BD_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_RECEIVER_BD_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PBR_RECEIVER_BD_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PBR_RECEIVER_BD_RELEASE_DATE' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_RECEIVER_BD_RELEASE_DATE' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PBR_RECEIVER_BD_RELEASE_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PBR_RECEIVER_BD_RELEASE_NAME' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_RECEIVER_BD_RELEASE_NAME' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PBR_RECEIVER_BD_RELEASE_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PBR_PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PBR_PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PBR_LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PBR_LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PBR_YS_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_YS_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PBR_YS_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'RECEIVER_ALLOCATE_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'RECEIVER_ALLOCATE_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'RECEIVER_ALLOCATE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'RECEIVER_ALLOCATE_DATE' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'RECEIVER_ALLOCATE_DATE' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'RECEIVER_ALLOCATE_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'RECEIVER_ALLOCATE_NAME' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'RECEIVER_ALLOCATE_NAME' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'RECEIVER_ALLOCATE_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_ALLOCATE' HIERARCHY_NAME,
             'RECEIVER_BD_RELEASE_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'RECEIVER_BD_RELEASE_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_ALLOCATE' DB_TAB_NAME,
             'RECEIVER_BD_RELEASE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PB_RECEIVER_BD_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_RECEIVER_BD_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'PB_RECEIVER_BD_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PB_SOURCE_BUSKEY' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'PB_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PB_RECEIVER_NUMBER' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_RECEIVER_NUMBER' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'PB_RECEIVER_NUMBER' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PB_RECEIVER_BD_DATE' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_RECEIVER_BD_DATE' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'PB_RECEIVER_BD_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PB_RECEIVER_BD_NAME' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_RECEIVER_BD_NAME' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'PB_RECEIVER_BD_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PB_PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'PB_PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PB_LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'PB_LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PB_YS_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'PB_YS_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'PB_YS_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PBR_RECEIVER_BD_RELEASE_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_RECEIVER_BD_RELEASE_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'PBR_RECEIVER_BD_RELEASE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PBR_SOURCE_BUSKEY' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'PBR_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PBR_RECEIVER_BD_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_RECEIVER_BD_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'PBR_RECEIVER_BD_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PBR_RECEIVER_BD_RELEASE_DATE' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_RECEIVER_BD_RELEASE_DATE' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'PBR_RECEIVER_BD_RELEASE_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PBR_RECEIVER_BD_RELEASE_NAME' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_RECEIVER_BD_RELEASE_NAME' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'PBR_RECEIVER_BD_RELEASE_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PBR_PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'PBR_PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PBR_LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'PBR_LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PBR_YS_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PBR_YS_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'PBR_YS_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PA_RECEIVER_ALLOCATE_ID' ATTR_NAME,
             'ALLOCATE' LEVEL_NAME,
             'PA_RECEIVER_ALLOCATE_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'PA_RECEIVER_ALLOCATE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PA_SOURCE_BUSKEY' ATTR_NAME,
             'ALLOCATE' LEVEL_NAME,
             'PA_SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'PA_SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PA_RECEIVER_ALLOCATE_DATE' ATTR_NAME,
             'ALLOCATE' LEVEL_NAME,
             'PA_RECEIVER_ALLOCATE_DATE' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'PA_RECEIVER_ALLOCATE_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PA_RECEIVER_ALLOCATE_NAME' ATTR_NAME,
             'ALLOCATE' LEVEL_NAME,
             'PA_RECEIVER_ALLOCATE_NAME' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'PA_RECEIVER_ALLOCATE_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PA_PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'ALLOCATE' LEVEL_NAME,
             'PA_PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'PA_PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PA_LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'ALLOCATE' LEVEL_NAME,
             'PA_LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'PA_LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PA_YS_CRITERIA_GROUP_ID' ATTR_NAME,
             'ALLOCATE' LEVEL_NAME,
             'PA_YS_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'PA_YS_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PA_RECEIVER_BD_RELEASE_ID' ATTR_NAME,
             'ALLOCATE' LEVEL_NAME,
             'PA_RECEIVER_BD_RELEASE_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'PA_RECEIVER_BD_RELEASE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'RECEIVER_RELEASE_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'RECEIVER_RELEASE_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'RECEIVER_RELEASE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'SOURCE_BUSKEY' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'SOURCE_BUSKEY' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'RECEIVER_ALLOCATE_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'RECEIVER_ALLOCATE_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'RECEIVER_ALLOCATE_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'RECEIVER_RELEASE_DATE' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'RECEIVER_RELEASE_DATE' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'RECEIVER_RELEASE_DATE' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'RECEIVER_RELEASE_NAME' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'RECEIVER_RELEASE_NAME' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'RECEIVER_RELEASE_NAME' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'PROD_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'PROD_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'PROD_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'LOC_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'LOC_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'LOC_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' DIM_NAME,
             'PRIMARY_RELEASE' HIERARCHY_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' ATTR_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' BUSINESS_DESC,
             'V_DIM_REC_PRIMARY_RELEASE' DB_TAB_NAME,
             'YEARSEASON_CRITERIA_GROUP_ID' DB_COL_NAME,
             'Y' VISABLE
        FROM DUAL;
  
    FORALL I IN 1 .. L_KEY_VAL_CACHE.COUNT
      UPDATE META_DIM_HIER_LEVEL_ATTRS T
         SET T.BUSINESS_DESC = L_KEY_VAL_CACHE(I).VAL
       WHERE T.DIM_NAME || C_DELIMITER || T.HIERARCHY_NAME || C_DELIMITER ||
             T.ATTR_NAME = L_KEY_VAL_CACHE(I).KEY;
  
    COMMIT;
  
  END POP_DIM_HIER_LEVEL_ATTRS;

  PROCEDURE POP_DIM_LEVEL_ATTR_MAPPING IS
  BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE META_DIM_LEVEL_ATTR_MAPPING';
  
    INSERT INTO META_DIM_LEVEL_ATTR_MAPPING
      (DIM_NAME, LEVEL_NAME, ATTR_NAME, SOURCE_FIELD, FIELD_SEQ)
      SELECT 'STORE' DIM_NAME,
             'COUNTRY' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'COUNTRY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'COUNTRY' LEVEL_NAME,
             'LOC_DESC' ATTR_NAME,
             'COUNTRY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'COUNTRY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'DC' SOURCE_FIELD,
             2FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'LOC_DESC' ATTR_NAME,
             'DC' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'COUNTRY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'DC' SOURCE_FIELD,
             2 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'STOCK_CATEGORY' SOURCE_FIELD,
             3 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'LOC_DESC' ATTR_NAME,
             'STOCK_CATEGORY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'DOOR_NUM' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE' LEVEL_NAME,
             'LOC_DESC' ATTR_NAME,
             'DOOR_NAME' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'COUNTRY' LEVEL_NAME,
             'LOC_ATTR1' ATTR_NAME,
             'COUNTRY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'LOC_ATTR1' ATTR_NAME,
             'COUNTRY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'LOC_ATTR1' ATTR_NAME,
             'COUNTRY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE' LEVEL_NAME,
             'LOC_ATTR1' ATTR_NAME,
             'COUNTRY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'COUNTRY' LEVEL_NAME,
             'LOC_ATTR2' ATTR_NAME,
             'DUMMY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'LOC_ATTR2' ATTR_NAME,
             'DC' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'LOC_ATTR2' ATTR_NAME,
             'DC' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE' LEVEL_NAME,
             'LOC_ATTR2' ATTR_NAME,
             'DC' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'COUNTRY' LEVEL_NAME,
             'LOC_ATTR3' ATTR_NAME,
             'DUMMY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'LOC_ATTR3' ATTR_NAME,
             'DUMMY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'LOC_ATTR3' ATTR_NAME,
             'STOCK_CATEGORY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE' LEVEL_NAME,
             'LOC_ATTR3' ATTR_NAME,
             'STOCK_CATEGORY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'COUNTRY' LEVEL_NAME,
             'LOC_ATTR4' ATTR_NAME,
             'DUMMY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'LOC_ATTR4' ATTR_NAME,
             'DUMMY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'LOC_ATTR4' ATTR_NAME,
             'DUMMY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE' LEVEL_NAME,
             'LOC_ATTR4' ATTR_NAME,
             'DUMMY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'COUNTRY' LEVEL_NAME,
             'LOC_ATTR5' ATTR_NAME,
             'DUMMY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'LOC_ATTR5' ATTR_NAME,
             'DUMMY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'LOC_ATTR5' ATTR_NAME,
             'DUMMY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE' LEVEL_NAME,
             'LOC_ATTR5' ATTR_NAME,
             'DUMMY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'COUNTRY' LEVEL_NAME,
             'LOC_ATTR6' ATTR_NAME,
             'DUMMY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'LOC_ATTR6' ATTR_NAME,
             'DUMMY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'LOC_ATTR6' ATTR_NAME,
             'DUMMY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE' LEVEL_NAME,
             'LOC_ATTR6' ATTR_NAME,
             'DUMMY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'COUNTRY' LEVEL_NAME,
             'LOC_ATTR7' ATTR_NAME,
             'DUMMY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'LOC_ATTR7' ATTR_NAME,
             'DUMMY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'LOC_ATTR7' ATTR_NAME,
             'DUMMY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE' LEVEL_NAME,
             'LOC_ATTR7' ATTR_NAME,
             'DUMMY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'COUNTRY' LEVEL_NAME,
             'LOC_ATTR8' ATTR_NAME,
             'DUMMY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'LOC_ATTR8' ATTR_NAME,
             'DUMMY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'LOC_ATTR8' ATTR_NAME,
             'DUMMY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE' LEVEL_NAME,
             'LOC_ATTR8' ATTR_NAME,
             'DUMMY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'COUNTRY' LEVEL_NAME,
             'LOC_ATTR9' ATTR_NAME,
             'DUMMY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'LOC_ATTR9' ATTR_NAME,
             'DUMMY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'LOC_ATTR9' ATTR_NAME,
             'DUMMY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE' LEVEL_NAME,
             'LOC_ATTR9' ATTR_NAME,
             'DUMMY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'COUNTRY' LEVEL_NAME,
             'LOC_ATTR10' ATTR_NAME,
             'DUMMY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'LOC_ATTR10' ATTR_NAME,
             'DUMMY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'LOC_ATTR10' ATTR_NAME,
             'DUMMY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE' LEVEL_NAME,
             'LOC_ATTR10' ATTR_NAME,
             'DUMMY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'COUNTRY' LEVEL_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'COUNTRY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'COUNTRY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'DC' SOURCE_FIELD,
             2 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'COUNTRY' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'DC' SOURCE_FIELD,
             2 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'STOCK_CATEGORY' SOURCE_FIELD,
             3 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE' LEVEL_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'DOOR_NUM' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'COMPANY_DOOR_ID' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'DOOR_NUM' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'DEPT' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'BUYER_DEPT_NUM' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'DEPT' LEVEL_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'BUYER_DEPT_ID' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      
      SELECT 'STYLE' DIM_NAME,
             'VENDOR' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'MIC_CODE' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'VENDOR' LEVEL_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'COMPANY_ID' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'STYLE_NUMBER' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE' LEVEL_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'STYLE_ID' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'STYLE_NUMBER' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'COLOR_CODE' SOURCE_FIELD,
             2 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'STYLE_COLOR_ID' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'STYLE_NUMBER' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'COLOR_CODE' SOURCE_FIELD,
             2 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SIZE_CODE' SOURCE_FIELD,
             3 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'STYLE_COLOR_ID' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'STYLE_SIZE_ID' SOURCE_FIELD,
             2 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'STYLE_NUMBER' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'COLOR_CODE' SOURCE_FIELD,
             2 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SIZE_CODE' SOURCE_FIELD,
             3 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'PREPACK_CODE' SOURCE_FIELD,
             4 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'PREPACK_TYPE' SOURCE_FIELD,
             5 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'STYLE_COLOR_ID' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'STYLE_SIZE_ID' SOURCE_FIELD,
             2 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'PREPACK_CODE' SOURCE_FIELD,
             3 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'TARGET_BUSKEY' ATTR_NAME,
             'PREPACK_TYPE' SOURCE_FIELD,
             4 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'SALES_STYLE' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'SALES_STYLE_CODE' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION' DIM_NAME,
             'PROMOTION' LEVEL_NAME,
             'SOURCE_BUSKEY' ATTR_NAME,
             'PROMO_CODE' SOURCE_FIELD,
             1 FIELD_SEQ
        FROM DUAL;
  
    COMMIT;
  END POP_DIM_LEVEL_ATTR_MAPPING;

  PROCEDURE POP_FACTS IS
  BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE META_FACTS';
  
    INSERT INTO META_FACTS
      (FACT_NAME, DB_TAB_NAME, BUSINESS_DESC)
      SELECT 'POS_SALES' FACT_NAME,
             'FACT_POS_SALES',
             'POS_SALES' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'POS_INVENTORY' FACT_NAME,
             'FACT_POS_INVENTORY',
             'POS_INVENTORY' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'POS_SALES_ITEM' FACT_NAME,
             'FACT_POS_SALES_ITEM',
             'POS_SALES_ITEM' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'POS_SALES_ITEM_WEEK' FACT_NAME,
             'FACT_POS_SALES_ITEM_WEEK',
             'POS_SALES_ITEM_WEEK' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'POS_SALES_STYLECOLOR' FACT_NAME,
             'FACT_POS_SALES_STYLECOLOR',
             'POS_SALES_STYLECOLOR' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'POS_SALES_STYLECOLOR_WEEK' FACT_NAME,
             'FACT_POS_SALES_STYLECOLOR_WEEK',
             'POS_SALES_STYLECOLOR_WEEK' BUSINESS_DESC
        FROM DUAL
      
      UNION ALL
      SELECT 'POS_INV_ITEM' FACT_NAME,
             'FACT_POS_INV_ITEM',
             'POS_INV_ITEM' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'POS_INV_ITEM_WEEK' FACT_NAME,
             'FACT_POS_INV_ITEM_WEEK',
             'POS_INV_ITEM_WEEK' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'POS_INV_STYLECOLOR' FACT_NAME,
             'FACT_POS_INV_STYLECOLOR',
             'POS_INV_STYLECOLOR' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'POS_INV_STYLECOLOR_WEEK' FACT_NAME,
             'FACT_POS_INV_STYLECOLOR_WEEK',
             'POS_INV_STYLECOLOR_WEEK' BUSINESS_DESC
        FROM DUAL
      --2016/11/29
      UNION ALL
      SELECT 'LOC_INV' FACT_NAME, 'FACT_LOC_INV', 'LOC_INV' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'CMM_TRANSFER' FACT_NAME,
             'FACT_CMM_TRANSFER',
             'CMM_TRANSFER' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_PROD_DOOR' FACT_NAME,
             'FACT_PROMOTION_PROD_DOOR',
             'PROMOTION_PROD_DOOR' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_PROD_LOC' FACT_NAME,
             'FACT_PROMOTION_PROD_LOC',
             'PROMOTION_PROD_LOC' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_SC_LOC' FACT_NAME,
             'FACT_PROMOTION_SC_LOC',
             'PROMOTION_SC_LOC' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_SC_DOOR' FACT_NAME,
             'FACT_PROMOTION_SC_DOOR',
             'PROMOTION_SC_DOOR' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'SPREAD_DC' FACT_NAME,
             'FACT_SPREAD_DC',
             'SPREAD_DC' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER' FACT_NAME,
             'FACT_TRANSFER',
             'TRANSFER' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RELEASE' FACT_NAME,
             'FACT_TRANSFER_RELEASE',
             'TRANSFER_RELEASE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_SNAPSHOT' FACT_NAME,
             'FACT_TRANSFER_SNAPSHOT',
             'TRANSFER_SNAPSHOT' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_MATRIX_DOOR_DOOR' FACT_NAME,
             'FACT_TRANSFER_MATRIX_DOOR_DOOR',
             'TRANSFER_MATRIX_DOOR_DOOR' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_MATRIX_LOC_LOC' FACT_NAME,
             'FACT_TRANSFER_MATRIX_LOC_LOC',
             'TRANSFER_MATRIX_LOC_LOC' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'SALES_INDEX' FACT_NAME,
             'FACT_SALES_INDEX',
             'SALES_INDEX' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'SIZE_PROFILE' FACT_NAME,
             'FACT_SIZE_PROFILE',
             'SIZE_PROFILE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'STORE_CLUSTER' FACT_NAME,
             'FACT_STORE_CLUSTER',
             'STORE_CLUSTER' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'SMOOTH_ALPHA' FACT_NAME,
             'FACT_SMOOTH_ALPHA',
             'SMOOTH_ALPHA' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'PO' FACT_NAME, 'FACT_PO', 'PO' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'PO_BREAKDOWN' FACT_NAME,
             'FACT_PO_BD',
             'PO BREAKDOWN' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'PO_BREAKDOWN_RELEASE' FACT_NAME,
             'FACT_PO_BD_RELEASE',
             'PO BREAKDOWN RELEASE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' FACT_NAME,
             'FACT_PO_ALLOCATE',
             'PO_ALLOCATE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE_RESERVE' FACT_NAME,
             'FACT_PO_ALLOCATE_RESERVE',
             'PO_ALLOCATE_RESERVE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'PO_RELEASE' FACT_NAME,
             'FACT_PO_RELEASE',
             'PO_RELEASE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'PO_RELEASE_RESERVE' FACT_NAME,
             'FACT_PO_RELEASE_RESERVE',
             'PO_RELEASE_RESERVE' BUSINESS_DESC
        FROM DUAL
      
      UNION ALL
      SELECT 'ASN' FACT_NAME, 'FACT_ASN', 'ASN' BUSINESS_DESC
        FROM DUAL
      
      UNION ALL
      SELECT 'ASN_BREAKDOWN' FACT_NAME,
             'FACT_ASN_BD',
             'ASN BREAKDOWN' BUSINESS_DESC
        FROM DUAL
      
      UNION ALL
      SELECT 'ASN_BREAKDOWN_RELEASE' FACT_NAME,
             'FACT_ASN_BD_RELEASE',
             'ASN BREAKDOWN RELEASE' BUSINESS_DESC
        FROM DUAL
      
      UNION ALL
      SELECT 'ASN_ALLOCATE' FACT_NAME,
             'FACT_ASN_ALLOCATE',
             'ASN_ALLOCATE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE_RESERVE' FACT_NAME,
             'FACT_ASN_ALLOCATE_RESERVE',
             'ASN_ALLOCATE_RESERVE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'ASN_RELEASE' FACT_NAME,
             'FACT_ASN_RELEASE',
             'ASN_RELEASE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'ASN_RELEASE_RESERVE' FACT_NAME,
             'FACT_ASN_RELEASE_RESERVE',
             'ASN_RELEASE_RESERVE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER' FACT_NAME,
             'FACT_RECEIVER',
             'RECEIVER' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' FACT_NAME,
             'FACT_RECEIVER_ALLOCATE',
             'RECEIVER_ALLOCATE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE_RESERVE' FACT_NAME,
             'FACT_RECEIVER_ALLOCATE_RESERVE',
             'RECEIVER_ALLOCATE_RESERVE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_RELEASE' FACT_NAME,
             'FACT_RECEIVER_RELEASE',
             'RECEIVER_RELEASE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_RELEASE_RESERVE' FACT_NAME,
             'FACT_RECEIVER_RELEASE_RESERVE',
             'RECEIVER_RELEASE_RESERVE' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'FORECAST_DEMAND' FACT_NAME,
             'FACT_FORECAST_DEMAND',
             'FORECAST_DEMAND' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'BOXSTYLE_SC_LOC' FACT_NAME,
             'FACT_BOXSTYLE_SC_LOC',
             'BOXSTYLE_SC_LOC' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'BOXSTYLE_PROD_LOC' FACT_NAME,
             'FACT_BOXSTYLE_PROD_LOC',
             'BOXSTYLE_PROD_LOC' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'MIN_MAX_PROD_LOC' FACT_NAME,
             'FACT_MIN_MAX_PROD_LOC',
             'MIN_MAX_PROD_LOC' BUSINESS_DESC
        FROM DUAL
      UNION ALL
      SELECT 'MIN_MAX_SC_LOC' FACT_NAME,
             'FACT_MIN_MAX_SC_LOC',
             'MIN_MAX_SC_LOC' BUSINESS_DESC
        FROM DUAL;
  
    COMMIT;
  END POP_FACTS;

  PROCEDURE POP_FACT_MEASUREMENTS IS
  BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE META_FACT_MEASUREMENTS';
    INSERT INTO META_FACT_MEASUREMENTS
      (FACT_NAME,
       FACT_MEASUREMENT_NAME,
       DB_COL_NAME,
       BUSINESS_DESC,
       AGGREGATE_FUNCTION,
       MEASURE_EXPRESSION,
       VISABLE)
      SELECT 'POS_SALES' AS FACT_NAME,
             'SALES_UNIT' FACT_MEASUREMENT_NAME,
             'SALES_UNIT' DB_COL_NAME,
             'SALES_UNIT' BUSINESS_DESC,
             'SUM' AGGREGATE_FUNCTION,
             C_DUMMY MEASURE_EXPRESSION,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'POS_SALES' AS FACT_NAME,
             'SALES_RETAIL' FACT_MEASUREMENT_NAME,
             'SALES_RETAIL' DB_COL_NAME,
             'SALES_RETAIL' BUSINESS_DESC,
             'SUM' AGGREGATE_FUNCTION,
             C_DUMMY MEASURE_EXPRESSION,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'POS_SALES' AS FACT_NAME,
             'SALES_COST' FACT_MEASUREMENT_NAME,
             'SALES_COST' DB_COL_NAME,
             'SALES_COST' BUSINESS_DESC,
             'SUM' AGGREGATE_FUNCTION,
             C_DUMMY MEASURE_EXPRESSION,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      
      SELECT 'POS_SALES' AS FACT_NAME,
             'RECEIPT_UNIT' FACT_MEASUREMENT_NAME,
             'RECEIPT_UNIT' DB_COL_NAME,
             'RECEIPT_UNIT' BUSINESS_DESC,
             'SUM' AGGREGATE_FUNCTION,
             C_DUMMY MEASURE_EXPRESSION,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'POS_SALES' AS FACT_NAME,
             'RECEIPT_RETAIL' FACT_MEASUREMENT_NAME,
             'RECEIPT_RETAIL' DB_COL_NAME,
             'RECEIPT_RETAIL' BUSINESS_DESC,
             'SUM' AGGREGATE_FUNCTION,
             C_DUMMY MEASURE_EXPRESSION,
             'Y' VISABLE
        FROM DUAL
      UNION ALL
      SELECT 'POS_SALES' AS FACT_NAME,
             'RECEIPT_COST' FACT_MEASUREMENT_NAME,
             'RECEIPT_COST' DB_COL_NAME,
             'RECEIPT_COST' BUSINESS_DESC,
             'SUM' AGGREGATE_FUNCTION,
             C_DUMMY MEASURE_EXPRESSION,
             'Y' VISABLE
        FROM DUAL;
    COMMIT;
  END POP_FACT_MEASUREMENTS;

  PROCEDURE POP_FACT_DIM_RELATIONS IS
  BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE META_FACT_DIM_RELATIONS';
    INSERT INTO META_FACT_DIM_RELATIONS
      SELECT 'POS_SALES' FACT_NAME,
             'DATE' DIM_NAME,
             'DAY' LEVEL_NAME,
             'FACT_POS_SALES' DB_FACT_TAB_NAME,
             'DATE_ID' DB_FACT_KEY_COL_NAME,
             'DATE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_SALES' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'FACT_POS_SALES' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_SALES' FACT_NAME,
             'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'FACT_POS_SALES' DB_FACT_TAB_NAME,
             'STORE_ID' DB_FACT_KEY_COL_NAME,
             'STORE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_SALES' FACT_NAME,
             'PROMOTION' DIM_NAME,
             'SALES_STYLE' LEVEL_NAME,
             'FACT_POS_SALES' DB_FACT_TAB_NAME,
             'SALES_STYLE_ID' DB_FACT_KEY_COL_NAME,
             'SALES_STYLE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_SALES' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'STYLE_YEAR_SEASON' LEVEL_NAME,
             'FACT_POS_SALES' DB_FACT_TAB_NAME,
             'STYLE_YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_INVENTORY' FACT_NAME,
             'DATE' DIM_NAME,
             'DAY' LEVEL_NAME,
             'FACT_POS_INVENTORY' DB_FACT_TAB_NAME,
             'DATE_ID' DB_FACT_KEY_COL_NAME,
             'DATE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_INVENTORY' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'FACT_POS_INVENTORY' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_INVENTORY' FACT_NAME,
             'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'FACT_POS_INVENTORY' DB_FACT_TAB_NAME,
             'STORE_ID' DB_FACT_KEY_COL_NAME,
             'STORE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_INVENTORY' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'STYLE_YEAR_SEASON' LEVEL_NAME,
             'FACT_POS_INVENTORY' DB_FACT_TAB_NAME,
             'STYLE_YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'POS_SALES_ITEM' FACT_NAME,
             'DATE' DIM_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'FACT_POS_SALES_ITEM' DB_FACT_TAB_NAME,
             'SMONTH_ID' DB_FACT_KEY_COL_NAME,
             'SMONTH_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_SALES_ITEM' FACT_NAME,
             'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'FACT_POS_SALES_ITEM' DB_FACT_TAB_NAME,
             'STORE_ID' DB_FACT_KEY_COL_NAME,
             'STORE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_SALES_ITEM' FACT_NAME,
             'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'FACT_POS_SALES_ITEM' DB_FACT_TAB_NAME,
             'PROD_ATTR_VALUE_ID' DB_FACT_KEY_COL_NAME,
             'PROD_ATTR_VALUE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_SALES_ITEM' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_POS_SALES_ITEM' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_SALES_ITEM' FACT_NAME,
             'PROMOTION' DIM_NAME,
             'SALES_STYLE' LEVEL_NAME,
             'FACT_POS_SALES_ITEM' DB_FACT_TAB_NAME,
             'SALES_STYLE_ID' DB_FACT_KEY_COL_NAME,
             'SALES_STYLE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_SALES_ITEM_WEEK' FACT_NAME,
             'DATE' DIM_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'FACT_POS_SALES_ITEM_WEEK' DB_FACT_TAB_NAME,
             'SWEEK_ID' DB_FACT_KEY_COL_NAME,
             'SWEEK_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_SALES_ITEM_WEEK' FACT_NAME,
             'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'FACT_POS_SALES_ITEM_WEEK' DB_FACT_TAB_NAME,
             'STORE_ID' DB_FACT_KEY_COL_NAME,
             'STORE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_SALES_ITEM_WEEK' FACT_NAME,
             'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'FACT_POS_SALES_ITEM_WEEK' DB_FACT_TAB_NAME,
             'PROD_ATTR_VALUE_ID' DB_FACT_KEY_COL_NAME,
             'PROD_ATTR_VALUE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_SALES_ITEM_WEEK' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_POS_SALES_ITEM_WEEK' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_SALES_ITEM_WEEK' FACT_NAME,
             'PROMOTION' DIM_NAME,
             'SALES_STYLE' LEVEL_NAME,
             'FACT_POS_SALES_ITEM_WEEK' DB_FACT_TAB_NAME,
             'SALES_STYLE_ID' DB_FACT_KEY_COL_NAME,
             'SALES_STYLE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_SALES_STYLECOLOR' FACT_NAME,
             'DATE' DIM_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'FACT_POS_SALES_STYLECOLOR' DB_FACT_TAB_NAME,
             'SMONTH_ID' DB_FACT_KEY_COL_NAME,
             'SMONTH_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_SALES_STYLECOLOR' FACT_NAME,
             'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'FACT_POS_SALES_STYLECOLOR' DB_FACT_TAB_NAME,
             'STORE_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_SALES_STYLECOLOR' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'FACT_POS_SALES_STYLECOLOR' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_SALES_STYLECOLOR' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'STYLE_YEAR_SEASON' LEVEL_NAME,
             'FACT_POS_SALES_STYLECOLOR' DB_FACT_TAB_NAME,
             'STYLE_YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_SALES_STYLECOLOR' FACT_NAME,
             'PROMOTION' DIM_NAME,
             'SALES_STYLE' LEVEL_NAME,
             'FACT_POS_SALES_STYLECOLOR' DB_FACT_TAB_NAME,
             'SALES_STYLE_ID' DB_FACT_KEY_COL_NAME,
             'SALES_STYLE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'POS_SALES_STYLECOLOR_WEEK' FACT_NAME,
             'DATE' DIM_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'FACT_POS_SALES_STYLECOLOR_WEEK' DB_FACT_TAB_NAME,
             'SWEEK_ID' DB_FACT_KEY_COL_NAME,
             'SWEEK_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_SALES_STYLECOLOR_WEEK' FACT_NAME,
             'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'FACT_POS_SALES_STYLECOLOR_WEEK' DB_FACT_TAB_NAME,
             'STORE_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_SALES_STYLECOLOR_WEEK' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'FACT_POS_SALES_STYLECOLOR_WEEK' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_SALES_STYLECOLOR_WEEK' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'STYLE_YEAR_SEASON' LEVEL_NAME,
             'FACT_POS_SALES_STYLECOLOR_WEEK' DB_FACT_TAB_NAME,
             'STYLE_YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_SALES_STYLECOLOR_WEEK' FACT_NAME,
             'PROMOTION' DIM_NAME,
             'SALES_STYLE' LEVEL_NAME,
             'FACT_POS_SALES_STYLECOLOR_WEEK' DB_FACT_TAB_NAME,
             'SALES_STYLE_ID' DB_FACT_KEY_COL_NAME,
             'SALES_STYLE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_INV_ITEM' FACT_NAME,
             'DATE' DIM_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'FACT_POS_INV_ITEM' DB_FACT_TAB_NAME,
             'SMONTH_ID' DB_FACT_KEY_COL_NAME,
             'SMONTH_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_INV_ITEM' FACT_NAME,
             'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'FACT_POS_INV_ITEM' DB_FACT_TAB_NAME,
             'STORE_ID' DB_FACT_KEY_COL_NAME,
             'STORE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_INV_ITEM' FACT_NAME,
             'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'FACT_POS_INV_ITEM' DB_FACT_TAB_NAME,
             'PROD_ATTR_VALUE_ID' DB_FACT_KEY_COL_NAME,
             'PROD_ATTR_VALUE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_INV_ITEM' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_POS_INV_ITEM' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_INV_ITEM_WEEK' FACT_NAME,
             'DATE' DIM_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'FACT_POS_INV_ITEM_WEEK' DB_FACT_TAB_NAME,
             'SWEEK_ID' DB_FACT_KEY_COL_NAME,
             'SWEEK_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_INV_ITEM_WEEK' FACT_NAME,
             'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'FACT_POS_INV_ITEM_WEEK' DB_FACT_TAB_NAME,
             'STORE_ID' DB_FACT_KEY_COL_NAME,
             'STORE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_INV_ITEM_WEEK' FACT_NAME,
             'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'FACT_POS_INV_ITEM_WEEK' DB_FACT_TAB_NAME,
             'PROD_ATTR_VALUE_ID' DB_FACT_KEY_COL_NAME,
             'PROD_ATTR_VALUE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_INV_ITEM_WEEK' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_POS_INV_ITEM_WEEK' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_INV_STYLECOLOR' FACT_NAME,
             'DATE' DIM_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'FACT_POS_INV_STYLECOLOR' DB_FACT_TAB_NAME,
             'SMONTH_ID' DB_FACT_KEY_COL_NAME,
             'SMONTH_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_INV_STYLECOLOR' FACT_NAME,
             'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'FACT_POS_INV_STYLECOLOR' DB_FACT_TAB_NAME,
             'STORE_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_INV_STYLECOLOR' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'FACT_POS_INV_STYLECOLOR' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_INV_STYLECOLOR' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'STYLE_YEAR_SEASON' LEVEL_NAME,
             'FACT_POS_INV_STYLECOLOR' DB_FACT_TAB_NAME,
             'STYLE_YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'POS_INV_STYLECOLOR_WEEK' FACT_NAME,
             'DATE' DIM_NAME,
             '7TH_WEEK' LEVEL_NAME,
             'FACT_POS_INV_STYLECOLOR_WEEK' DB_FACT_TAB_NAME,
             'SWEEK_ID' DB_FACT_KEY_COL_NAME,
             'SWEEK_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_INV_STYLECOLOR_WEEK' FACT_NAME,
             'STORE' DIM_NAME,
             'STOCK_CATEGORY' LEVEL_NAME,
             'FACT_POS_INV_STYLECOLOR_WEEK' DB_FACT_TAB_NAME,
             'STORE_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_INV_STYLECOLOR_WEEK' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'FACT_POS_INV_STYLECOLOR_WEEK' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'POS_INV_STYLECOLOR_WEEK' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'STYLE_YEAR_SEASON' LEVEL_NAME,
             'FACT_POS_INV_STYLECOLOR_WEEK' DB_FACT_TAB_NAME,
             'STYLE_YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      --2016/11/29
      UNION ALL
      SELECT 'LOC_INV' FACT_NAME,
             'DATE' DIM_NAME,
             'DAY' LEVEL_NAME,
             'FACT_LOC_INV' DB_FACT_TAB_NAME,
             'DATE_ID' DB_FACT_KEY_COL_NAME,
             'DATE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'LOC_INV' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'FACT_LOC_INV' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'LOC_INV' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'STYLE_YEAR_SEASON' LEVEL_NAME,
             'FACT_LOC_INV' DB_FACT_TAB_NAME,
             'STYLE_YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'LOC_INV' FACT_NAME,
             'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'FACT_LOC_INV' DB_FACT_TAB_NAME,
             'STORE_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'CMM_TRANSFER' FACT_NAME,
             'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'FACT_CMM_TRANSFER' DB_FACT_TAB_NAME,
             'SENDING_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'CMM_TRANSFER' FACT_NAME,
             'STORE' DIM_NAME,
             'STORE' LEVEL_NAME,
             'FACT_CMM_TRANSFER' DB_FACT_TAB_NAME,
             'RECEIVING_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'CMM_TRANSFER' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'FACT_CMM_TRANSFER' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'CMM_TRANSFER' FACT_NAME,
             'DATE' DIM_NAME,
             'DAY' LEVEL_NAME,
             'FACT_CMM_TRANSFER' DB_FACT_TAB_NAME,
             'DATE_ID' DB_FACT_KEY_COL_NAME,
             'DATE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'CMM_TRANSFER' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_CMM_TRANSFER' DB_FACT_TAB_NAME,
             'TYPE_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'FORECAST_DEMAND' FACT_NAME,
             'TRANSFER_FORECAST' DIM_NAME,
             'TRANSFER_FORECAST' LEVEL_NAME,
             'FACT_FORECAST_DEMAND' DB_FACT_TAB_NAME,
             'TRANSFER_FORECAST_ID' DB_FACT_KEY_COL_NAME,
             'TRANSFER_FORECAST_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'FORECAST_DEMAND' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'FACT_FORECAST_DEMAND' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'FORECAST_DEMAND' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'STYLE_YEAR_SEASON' LEVEL_NAME,
             'FACT_FORECAST_DEMAND' DB_FACT_TAB_NAME,
             'STYLE_YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'FORECAST_DEMAND' FACT_NAME,
             'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'FACT_FORECAST_DEMAND' DB_FACT_TAB_NAME,
             'STORE_ID' DB_FACT_KEY_COL_NAME,
             'STORE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'FORECAST_DEMAND' FACT_NAME,
             'TRANSFER_RULE' DIM_NAME,
             'TRANSFER_RULE' LEVEL_NAME,
             'FACT_FORECAST_DEMAND' DB_FACT_TAB_NAME,
             'RULE_ID' DB_FACT_KEY_COL_NAME,
             'RULE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'FORECAST_DEMAND' FACT_NAME,
             'AUDIT' DIM_NAME,
             'AUDIT' LEVEL_NAME,
             'FACT_FORECAST_DEMAND' DB_FACT_TAB_NAME,
             'AUDIT_ID' DB_FACT_KEY_COL_NAME,
             'AUDIT_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_PROD_DOOR' FACT_NAME,
             'PROMOTION_SCOPE' DIM_NAME,
             'PROMOTION_SCOPE' LEVEL_NAME,
             'FACT_PROMOTION_PROD_DOOR' DB_FACT_TAB_NAME,
             'PROMOTION_SCOPE_ID' DB_FACT_KEY_COL_NAME,
             'PROMOTION_SCOPE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_PROD_DOOR' FACT_NAME,
             'PROMOTION' DIM_NAME,
             'PROMOTION' LEVEL_NAME,
             'FACT_PROMOTION_PROD_DOOR' DB_FACT_TAB_NAME,
             'PROMOTION_ID' DB_FACT_KEY_COL_NAME,
             'PROMOTION_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_PROD_DOOR' FACT_NAME,
             'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'FACT_PROMOTION_PROD_DOOR' DB_FACT_TAB_NAME,
             'PROD_ATTR_VALUE_ID' DB_FACT_KEY_COL_NAME,
             'PROD_ATTR_VALUE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_PROD_DOOR' FACT_NAME,
             'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'FACT_PROMOTION_PROD_DOOR' DB_FACT_TAB_NAME,
             'STORE_ID' DB_FACT_KEY_COL_NAME,
             'STORE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_PROD_DOOR' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_PROMOTION_PROD_DOOR' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_PROD_DOOR' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_PROMOTION_PROD_DOOR' DB_FACT_TAB_NAME,
             'STATUS_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_PROD_DOOR' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_PROMOTION_PROD_DOOR' DB_FACT_TAB_NAME,
             'ACTION_TYPE_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_PROD_LOC' FACT_NAME,
             'PROMOTION_SCOPE' DIM_NAME,
             'PROMOTION_SCOPE' LEVEL_NAME,
             'FACT_PROMOTION_PROD_LOC' DB_FACT_TAB_NAME,
             'PROMOTION_SCOPE_ID' DB_FACT_KEY_COL_NAME,
             'PROMOTION_SCOPE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_PROD_LOC' FACT_NAME,
             'PROMOTION' DIM_NAME,
             'PROMOTION' LEVEL_NAME,
             'FACT_PROMOTION_PROD_LOC' DB_FACT_TAB_NAME,
             'PROMOTION_ID' DB_FACT_KEY_COL_NAME,
             'PROMOTION_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_PROD_LOC' FACT_NAME,
             'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'FACT_PROMOTION_PROD_LOC' DB_FACT_TAB_NAME,
             'PROD_ATTR_VALUE_ID' DB_FACT_KEY_COL_NAME,
             'PROD_ATTR_VALUE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_PROD_LOC' FACT_NAME,
             'STORE' DIM_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'FACT_PROMOTION_PROD_LOC' DB_FACT_TAB_NAME,
             'LOC_ATTR_VALUE_ID' DB_FACT_KEY_COL_NAME,
             'LOC_ATTR_VALUE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_PROD_LOC' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_PROMOTION_PROD_LOC' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_PROD_LOC' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_PROMOTION_PROD_LOC' DB_FACT_TAB_NAME,
             'STATUS_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_PROD_LOC' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_PROMOTION_PROD_LOC' DB_FACT_TAB_NAME,
             'ACTION_TYPE_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_SC_DOOR' FACT_NAME,
             'PROMOTION_SCOPE' DIM_NAME,
             'PROMOTION_SCOPE' LEVEL_NAME,
             'FACT_PROMOTION_SC_DOOR' DB_FACT_TAB_NAME,
             'PROMOTION_SCOPE_ID' DB_FACT_KEY_COL_NAME,
             'PROMOTION_SCOPE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_SC_DOOR' FACT_NAME,
             'PROMOTION' DIM_NAME,
             'PROMOTION' LEVEL_NAME,
             'FACT_PROMOTION_SC_DOOR' DB_FACT_TAB_NAME,
             'PROMOTION_ID' DB_FACT_KEY_COL_NAME,
             'PROMOTION_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_SC_DOOR' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'FACT_PROMOTION_SC_DOOR' DB_FACT_TAB_NAME,
             'STYLE_COLOR_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_SC_DOOR' FACT_NAME,
             'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'FACT_PROMOTION_SC_DOOR' DB_FACT_TAB_NAME,
             'STORE_ID' DB_FACT_KEY_COL_NAME,
             'STORE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_SC_DOOR' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_PROMOTION_SC_DOOR' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_SC_DOOR' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_PROMOTION_SC_DOOR' DB_FACT_TAB_NAME,
             'STATUS_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_SC_DOOR' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_PROMOTION_SC_DOOR' DB_FACT_TAB_NAME,
             'ACTION_TYPE_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_SC_LOC' FACT_NAME,
             'PROMOTION_SCOPE' DIM_NAME,
             'PROMOTION_SCOPE' LEVEL_NAME,
             'FACT_PROMOTION_SC_LOC' DB_FACT_TAB_NAME,
             'PROMOTION_SCOPE_ID' DB_FACT_KEY_COL_NAME,
             'PROMOTION_SCOPE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_SC_LOC' FACT_NAME,
             'PROMOTION' DIM_NAME,
             'PROMOTION' LEVEL_NAME,
             'FACT_PROMOTION_SC_LOC' DB_FACT_TAB_NAME,
             'PROMOTION_ID' DB_FACT_KEY_COL_NAME,
             'PROMOTION_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_SC_LOC' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'FACT_PROMOTION_SC_LOC' DB_FACT_TAB_NAME,
             'STYLE_COLOR_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_SC_LOC' FACT_NAME,
             'STORE' DIM_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'FACT_PROMOTION_SC_LOC' DB_FACT_TAB_NAME,
             'LOC_ATTR_VALUE_ID' DB_FACT_KEY_COL_NAME,
             'LOC_ATTR_VALUE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_SC_LOC' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_PROMOTION_SC_LOC' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_SC_LOC' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_PROMOTION_SC_LOC' DB_FACT_TAB_NAME,
             'STATUS_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PROMOTION_SC_LOC' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_PROMOTION_SC_LOC' DB_FACT_TAB_NAME,
             'ACTION_TYPE_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'SPREAD_DC' FACT_NAME,
             'SPREAD_DC' DIM_NAME,
             'SPREAD_DC' LEVEL_NAME,
             'FACT_SPREAD_DC' DB_FACT_TAB_NAME,
             'TRANSFER_SPREAD_DC_ID' DB_FACT_KEY_COL_NAME,
             'TRANSFER_SPREAD_DC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'SPREAD_DC' FACT_NAME,
             'DATE' DIM_NAME,
             'DAY' LEVEL_NAME,
             'FACT_SPREAD_DC' DB_FACT_TAB_NAME,
             'DATE_ID' DB_FACT_KEY_COL_NAME,
             'DATE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'SPREAD_DC' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'FACT_SPREAD_DC' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'SPREAD_DC' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'STYLE_YEAR_SEASON' LEVEL_NAME,
             'FACT_SPREAD_DC' DB_FACT_TAB_NAME,
             'STYLE_YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'SPREAD_DC' FACT_NAME,
             'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'FACT_SPREAD_DC' DB_FACT_TAB_NAME,
             'STORE_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'SPREAD_DC' FACT_NAME,
             'TRANSFER_RULE' DIM_NAME,
             'TRANSFER_RULE' LEVEL_NAME,
             'FACT_SPREAD_DC' DB_FACT_TAB_NAME,
             'RULE_ID' DB_FACT_KEY_COL_NAME,
             'RULE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'SPREAD_DC' FACT_NAME,
             'AUDIT' DIM_NAME,
             'AUDIT' LEVEL_NAME,
             'FACT_SPREAD_DC' DB_FACT_TAB_NAME,
             'AUDIT_ID' DB_FACT_KEY_COL_NAME,
             'AUDIT_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'SPREAD_DC' FACT_NAME,
             'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'FACT_SPREAD_DC' DB_FACT_TAB_NAME,
             'PARENT_STORE_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'TRANSFER' FACT_NAME,
             'TRANSFER' DIM_NAME,
             'TRANSFER' LEVEL_NAME,
             'FACT_TRANSFER' DB_FACT_TAB_NAME,
             'TRANSFER_TRANSFER_ID' DB_FACT_KEY_COL_NAME,
             'TRANSFER_TRANSFER_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'FACT_TRANSFER' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'STYLE_YEAR_SEASON' LEVEL_NAME,
             'FACT_TRANSFER' DB_FACT_TAB_NAME,
             'STYLE_YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER' FACT_NAME,
             'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'FACT_TRANSFER' DB_FACT_TAB_NAME,
             'FROM_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER' FACT_NAME,
             'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'FACT_TRANSFER' DB_FACT_TAB_NAME,
             'TO_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER' FACT_NAME,
             'TRANSFER_RULE' DIM_NAME,
             'TRANSFER_RULE' LEVEL_NAME,
             'FACT_TRANSFER' DB_FACT_TAB_NAME,
             'FROM_RULE_ID' DB_FACT_KEY_COL_NAME,
             'RULE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER' FACT_NAME,
             'TRANSFER_RULE' DIM_NAME,
             'TRANSFER_RULE' LEVEL_NAME,
             'FACT_TRANSFER' DB_FACT_TAB_NAME,
             'TO_RULE_ID' DB_FACT_KEY_COL_NAME,
             'RULE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_TRANSFER' DB_FACT_TAB_NAME,
             'STATUS_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER' FACT_NAME,
             'AUDIT' DIM_NAME,
             'AUDIT' LEVEL_NAME,
             'FACT_TRANSFER' DB_FACT_TAB_NAME,
             'AUDIT_ID' DB_FACT_KEY_COL_NAME,
             'AUDIT_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER' FACT_NAME,
             'TRANSFER_PRIORITY' DIM_NAME,
             'TRANSFER_PRIORITY' LEVEL_NAME,
             'FACT_TRANSFER' DB_FACT_TAB_NAME,
             'TRANSFER_PRIORITY_ID' DB_FACT_KEY_COL_NAME,
             'TRANSFER_PRIORITY_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'TRANSFER_RELEASE' FACT_NAME,
             'TRANSFER' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'FACT_TRANSFER_RELEASE' DB_FACT_TAB_NAME,
             'TRANSFER_RELEASE_ID' DB_FACT_KEY_COL_NAME,
             'TRANSFER_RELEASE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RELEASE' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'FACT_TRANSFER_RELEASE' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RELEASE' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'STYLE_YEAR_SEASON' LEVEL_NAME,
             'FACT_TRANSFER_RELEASE' DB_FACT_TAB_NAME,
             'STYLE_YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RELEASE' FACT_NAME,
             'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'FACT_TRANSFER_RELEASE' DB_FACT_TAB_NAME,
             'FROM_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RELEASE' FACT_NAME,
             'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'FACT_TRANSFER_RELEASE' DB_FACT_TAB_NAME,
             'TO_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RELEASE' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_TRANSFER_RELEASE' DB_FACT_TAB_NAME,
             'STATUS_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_RELEASE' FACT_NAME,
             'AUDIT' DIM_NAME,
             'AUDIT' LEVEL_NAME,
             'FACT_TRANSFER_RELEASE' DB_FACT_TAB_NAME,
             'AUDIT_ID' DB_FACT_KEY_COL_NAME,
             'AUDIT_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'TRANSFER_SNAPSHOT' FACT_NAME,
             'TRANSFER' DIM_NAME,
             'TRANSFER' LEVEL_NAME,
             'FACT_TRANSFER_SNAPSHOT' DB_FACT_TAB_NAME,
             'TRANSFER_TRANSFER_ID' DB_FACT_KEY_COL_NAME,
             'TRANSFER_TRANSFER_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_SNAPSHOT' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE' LEVEL_NAME,
             'FACT_TRANSFER_SNAPSHOT' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_SNAPSHOT' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'STYLE_YEAR_SEASON' LEVEL_NAME,
             'FACT_TRANSFER_SNAPSHOT' DB_FACT_TAB_NAME,
             'STYLE_YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_SNAPSHOT' FACT_NAME,
             'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'FACT_TRANSFER_SNAPSHOT' DB_FACT_TAB_NAME,
             'STORE_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'TRANSFER_MATRIX_DOOR_DOOR' FACT_NAME,
             'TRANSFER_MATRIX' DIM_NAME,
             'TRANSFER_MATRIX' LEVEL_NAME,
             'FACT_TRANSFER_MATRIX_DOOR_DOOR' DB_FACT_TAB_NAME,
             'TRANSFER_MATRIX_ID' DB_FACT_KEY_COL_NAME,
             'TRANSFER_MATRIX_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_MATRIX_DOOR_DOOR' FACT_NAME,
             'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'FACT_TRANSFER_MATRIX_DOOR_DOOR' DB_FACT_TAB_NAME,
             'FROM_STORE_ID' DB_FACT_KEY_COL_NAME,
             'STORE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_MATRIX_DOOR_DOOR' FACT_NAME,
             'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'FACT_TRANSFER_MATRIX_DOOR_DOOR' DB_FACT_TAB_NAME,
             'TO_STORE_ID' DB_FACT_KEY_COL_NAME,
             'STORE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'TRANSFER_MATRIX_LOC_LOC' FACT_NAME,
             'TRANSFER_MATRIX' DIM_NAME,
             'TRANSFER_MATRIX' LEVEL_NAME,
             'FACT_TRANSFER_MATRIX_LOC_LOC' DB_FACT_TAB_NAME,
             'TRANSFER_MATRIX_ID' DB_FACT_KEY_COL_NAME,
             'TRANSFER_MATRIX_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_MATRIX_LOC_LOC' FACT_NAME,
             'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'FACT_TRANSFER_MATRIX_LOC_LOC' DB_FACT_TAB_NAME,
             'FROM_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'TRANSFER_MATRIX_LOC_LOC' FACT_NAME,
             'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'FACT_TRANSFER_MATRIX_LOC_LOC' DB_FACT_TAB_NAME,
             'TO_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'SALES_INDEX' FACT_NAME,
             'ALLOCATION_REFERENCE' DIM_NAME,
             'ALLOCATION_REFERENCE' LEVEL_NAME,
             'FACT_SALES_INDEX' DB_FACT_TAB_NAME,
             'ALLOCATION_REFERENCE_ID' DB_FACT_KEY_COL_NAME,
             'ALLOCATION_REFERENCE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'SALES_INDEX' FACT_NAME,
             'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'FACT_SALES_INDEX' DB_FACT_TAB_NAME,
             'FE_ATTR_VALUE_ID' DB_FACT_KEY_COL_NAME,
             'PROD_ATTR_VALUE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'SALES_INDEX' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_SALES_INDEX' DB_FACT_TAB_NAME,
             'FE_LEVEL_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'SALES_INDEX' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_SALES_INDEX' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'SALES_INDEX' FACT_NAME,
             'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'FACT_SALES_INDEX' DB_FACT_TAB_NAME,
             'STORE_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'SALES_INDEX' FACT_NAME,
             'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE_ID' LEVEL_NAME,
             'FACT_SALES_INDEX' DB_FACT_TAB_NAME,
             'PROD_ATTR_VALUE_ID' DB_FACT_KEY_COL_NAME,
             'PROD_ATTR_VALUE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'SALES_INDEX' FACT_NAME,
             'DATE' DIM_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'FACT_SALES_INDEX' DB_FACT_TAB_NAME,
             'SMONTH_ID' DB_FACT_KEY_COL_NAME,
             'SMONTH_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'SIZE_PROFILE' FACT_NAME,
             'ALLOCATION_REFERENCE' DIM_NAME,
             'ALLOCATION_REFERENCE' LEVEL_NAME,
             'FACT_SIZE_PROFILE' DB_FACT_TAB_NAME,
             'ALLOCATION_REFERENCE_ID' DB_FACT_KEY_COL_NAME,
             'ALLOCATION_REFERENCE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'SIZE_PROFILE' FACT_NAME,
             'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'FACT_SIZE_PROFILE' DB_FACT_TAB_NAME,
             'FE_ATTR_VALUE_ID' DB_FACT_KEY_COL_NAME,
             'PROD_ATTR_VALUE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'SIZE_PROFILE' FACT_NAME,
             'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'FACT_SIZE_PROFILE' DB_FACT_TAB_NAME,
             'PROD_ATTR_VALUE_ID' DB_FACT_KEY_COL_NAME,
             'PROD_ATTR_VALUE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'SIZE_PROFILE' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_SIZE_PROFILE' DB_FACT_TAB_NAME,
             'FE_LEVEL_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'SIZE_PROFILE' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_SIZE_PROFILE' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'SIZE_PROFILE' FACT_NAME,
             'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'FACT_SIZE_PROFILE' DB_FACT_TAB_NAME,
             'STORE_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'SIZE_PROFILE' FACT_NAME,
             'STYLE' DIM_NAME,
             'SIZE_ITEM' LEVEL_NAME,
             'FACT_SIZE_PROFILE' DB_FACT_TAB_NAME,
             'SIZE_ITEM_ID' DB_FACT_KEY_COL_NAME,
             'SIZE_ITEM_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'SMOOTH_ALPHA' FACT_NAME,
             'ALLOCATION_REFERENCE' DIM_NAME,
             'ALLOCATION_REFERENCE' LEVEL_NAME,
             'FACT_SMOOTH_ALPHA' DB_FACT_TAB_NAME,
             'ALLOCATION_REFERENCE_ID' DB_FACT_KEY_COL_NAME,
             'ALLOCATION_REFERENCE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'SMOOTH_ALPHA' FACT_NAME,
             'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'FACT_SMOOTH_ALPHA' DB_FACT_TAB_NAME,
             'FE_ATTR_VALUE_ID' DB_FACT_KEY_COL_NAME,
             'PROD_ATTR_VALUE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'SMOOTH_ALPHA' FACT_NAME,
             'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'FACT_SMOOTH_ALPHA' DB_FACT_TAB_NAME,
             'PROD_ATTR_VALUE_ID' DB_FACT_KEY_COL_NAME,
             'PROD_ATTR_VALUE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'SMOOTH_ALPHA' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_SMOOTH_ALPHA' DB_FACT_TAB_NAME,
             'FE_LEVEL_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'SMOOTH_ALPHA' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_SMOOTH_ALPHA' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'STORE_CLUSTER' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_STORE_CLUSTER' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'STORE_CLUSTER' FACT_NAME,
             'ALLOCATION_REFERENCE' DIM_NAME,
             'ALLOCATION_REFERENCE' LEVEL_NAME,
             'FACT_STORE_CLUSTER' DB_FACT_TAB_NAME,
             'ALLOCATION_REFERENCE_ID' DB_FACT_KEY_COL_NAME,
             'ALLOCATION_REFERENCE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'STORE_CLUSTER' FACT_NAME,
             'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'FACT_STORE_CLUSTER' DB_FACT_TAB_NAME,
             'FE_ATTR_VALUE_ID' DB_FACT_KEY_COL_NAME,
             'PROD_ATTR_VALUE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'STORE_CLUSTER' FACT_NAME,
             'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'FACT_STORE_CLUSTER' DB_FACT_TAB_NAME,
             'PROD_ATTR_VALUE_ID' DB_FACT_KEY_COL_NAME,
             'PROD_ATTR_VALUE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'STORE_CLUSTER' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_STORE_CLUSTER' DB_FACT_TAB_NAME,
             'FE_LEVEL_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'STORE_CLUSTER' FACT_NAME,
             'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'FACT_STORE_CLUSTER' DB_FACT_TAB_NAME,
             'STORE_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'STORE_CLUSTER' FACT_NAME,
             'DATE' DIM_NAME,
             '7TH_MONTH' LEVEL_NAME,
             'FACT_STORE_CLUSTER' DB_FACT_TAB_NAME,
             'SMONTH_ID' DB_FACT_KEY_COL_NAME,
             'SMONTH_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'PO' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'FACT_PO' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_PO' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO' FACT_NAME,
             'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'FACT_PO' DB_FACT_TAB_NAME,
             'STORE_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_PO' DB_FACT_TAB_NAME,
             'STATUS_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'FACT_ASN' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_ASN' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN' FACT_NAME,
             'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'FACT_ASN' DB_FACT_TAB_NAME,
             'STORE_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_ASN' DB_FACT_TAB_NAME,
             'STATUS_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'RECEIVER' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'FACT_RECEIVER' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_RECEIVER' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER' FACT_NAME,
             'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'FACT_RECEIVER' DB_FACT_TAB_NAME,
             'STORE_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_RECEIVER' DB_FACT_TAB_NAME,
             'STATUS_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'PO_BREAKDOWN' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_PO_BD' DB_FACT_TAB_NAME,
             'STATUS_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO_BREAKDOWN' FACT_NAME,
             'PO_ALLOCATE' DIM_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'FACT_PO_BD' DB_FACT_TAB_NAME,
             'PO_BD_ID' DB_FACT_KEY_COL_NAME,
             'PO_BD_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO_BREAKDOWN' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'FACT_PO_BD' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO_BREAKDOWN' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_PO_BD' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO_BREAKDOWN' FACT_NAME,
             'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'FACT_PO_BD' DB_FACT_TAB_NAME,
             'STORE_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'PO_BREAKDOWN_RELEASE' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_PO_BD_RELEASE' DB_FACT_TAB_NAME,
             'STATUS_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO_BREAKDOWN_RELEASE' FACT_NAME,
             'PO_ALLOCATE' DIM_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'FACT_PO_BD_RELEASE' DB_FACT_TAB_NAME,
             'PO_BD_RELEASE_ID' DB_FACT_KEY_COL_NAME,
             'PO_BD_RELEASE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO_BREAKDOWN_RELEASE' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'FACT_PO_BD_RELEASE' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO_BREAKDOWN_RELEASE' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_PO_BD_RELEASE' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO_BREAKDOWN_RELEASE' FACT_NAME,
             'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'FACT_PO_BD_RELEASE' DB_FACT_TAB_NAME,
             'STORE_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'PO_ALLOCATE' FACT_NAME,
             'PO_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'FACT_PO_ALLOCATE' DB_FACT_TAB_NAME,
             'PO_ALLOCATE_ID' DB_FACT_KEY_COL_NAME,
             'PO_ALLOCATE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'FACT_PO_ALLOCATE' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_PO_ALLOCATE' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' FACT_NAME,
             'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'FACT_PO_ALLOCATE' DB_FACT_TAB_NAME,
             'STORE_ID' DB_FACT_KEY_COL_NAME,
             'STORE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_PO_ALLOCATE' DB_FACT_TAB_NAME,
             'STATUS_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'ASN_BREAKDOWN' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_ASN_BD' DB_FACT_TAB_NAME,
             'STATUS_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN_BREAKDOWN' FACT_NAME,
             'ASN_ALLOCATE' DIM_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'FACT_ASN_BD' DB_FACT_TAB_NAME,
             'ASN_BD_ID' DB_FACT_KEY_COL_NAME,
             'ASN_BD_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN_BREAKDOWN' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'FACT_ASN_BD' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN_BREAKDOWN' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_ASN_BD' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN_BREAKDOWN' FACT_NAME,
             'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'FACT_ASN_BD' DB_FACT_TAB_NAME,
             'STORE_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'ASN_BREAKDOWN_RELEASE' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_ASN_BD_RELEASE' DB_FACT_TAB_NAME,
             'STATUS_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN_BREAKDOWN_RELEASE' FACT_NAME,
             'ASN_ALLOCATE' DIM_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'FACT_ASN_BD_RELEASE' DB_FACT_TAB_NAME,
             'ASN_BD_RELEASE_ID' DB_FACT_KEY_COL_NAME,
             'ASN_BD_RELEASE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN_BREAKDOWN_RELEASE' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'FACT_ASN_BD_RELEASE' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN_BREAKDOWN_RELEASE' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_ASN_BD_RELEASE' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN_BREAKDOWN_RELEASE' FACT_NAME,
             'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'FACT_ASN_BD_RELEASE' DB_FACT_TAB_NAME,
             'STORE_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'ASN_ALLOCATE' FACT_NAME,
             'ASN_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'FACT_ASN_ALLOCATE' DB_FACT_TAB_NAME,
             'ASN_ALLOCATE_ID' DB_FACT_KEY_COL_NAME,
             'ASN_ALLOCATE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'FACT_ASN_ALLOCATE' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_ASN_ALLOCATE' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' FACT_NAME,
             'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'FACT_ASN_ALLOCATE' DB_FACT_TAB_NAME,
             'STORE_ID' DB_FACT_KEY_COL_NAME,
             'STORE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_ASN_ALLOCATE' DB_FACT_TAB_NAME,
             'STATUS_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' FACT_NAME,
             'RECEIVER_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'FACT_RECEIVER_ALLOCATE' DB_FACT_TAB_NAME,
             'RECEIVER_ALLOCATE_ID' DB_FACT_KEY_COL_NAME,
             'RECEIVER_ALLOCATE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'FACT_RECEIVER_ALLOCATE' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_RECEIVER_ALLOCATE' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' FACT_NAME,
             'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'FACT_RECEIVER_ALLOCATE' DB_FACT_TAB_NAME,
             'STORE_ID' DB_FACT_KEY_COL_NAME,
             'STORE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_RECEIVER_ALLOCATE' DB_FACT_TAB_NAME,
             'STATUS_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'RECEIVER_BREAKDOWN' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_RECEIVER_BD' DB_FACT_TAB_NAME,
             'STATUS_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_BREAKDOWN' FACT_NAME,
             'RECEIVER_ALLOCATE' DIM_NAME,
             'BREAKDOWN' LEVEL_NAME,
             'FACT_RECEIVER_BD' DB_FACT_TAB_NAME,
             'RECEIVER_BD_ID' DB_FACT_KEY_COL_NAME,
             'RECEIVER_BD_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_BREAKDOWN' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'FACT_RECEIVER_BD' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_BREAKDOWN' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_RECEIVER_BD' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_BREAKDOWN' FACT_NAME,
             'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'FACT_RECEIVER_BD' DB_FACT_TAB_NAME,
             'STORE_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'RECEIVER_BREAKDOWN_RELEASE' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_RECEIVER_BD_RELEASE' DB_FACT_TAB_NAME,
             'STATUS_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_BREAKDOWN_RELEASE' FACT_NAME,
             'RECEIVER_ALLOCATE' DIM_NAME,
             'BREAKDOWN_RELEASE' LEVEL_NAME,
             'FACT_RECEIVER_BD_RELEASE' DB_FACT_TAB_NAME,
             'RECEIVER_BD_RELEASE_ID' DB_FACT_KEY_COL_NAME,
             'RECEIVER_BD_RELEASE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_BREAKDOWN_RELEASE' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'FACT_RECEIVER_BD_RELEASE' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_BREAKDOWN_RELEASE' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_RECEIVER_BD_RELEASE' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_BREAKDOWN_RELEASE' FACT_NAME,
             'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'FACT_RECEIVER_BD_RELEASE' DB_FACT_TAB_NAME,
             'STORE_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'PO_ALLOCATE_RESERVE' FACT_NAME,
             'PO_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'FACT_PO_ALLOCATE_RESERVE' DB_FACT_TAB_NAME,
             'PO_ALLOCATE_ID' DB_FACT_KEY_COL_NAME,
             'PO_ALLOCATE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE_RESERVE' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'FACT_PO_ALLOCATE_RESERVE' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE_RESERVE' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_PO_ALLOCATE_RESERVE' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE_RESERVE' FACT_NAME,
             'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'FACT_PO_ALLOCATE_RESERVE' DB_FACT_TAB_NAME,
             'STORE_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO_ALLOCATE_RESERVE' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_PO_ALLOCATE_RESERVE' DB_FACT_TAB_NAME,
             'STATUS_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'ASN_ALLOCATE_RESERVE' FACT_NAME,
             'ASN_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'FACT_ASN_ALLOCATE_RESERVE' DB_FACT_TAB_NAME,
             'ASN_ALLOCATE_ID' DB_FACT_KEY_COL_NAME,
             'ASN_ALLOCATE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE_RESERVE' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'FACT_ASN_ALLOCATE_RESERVE' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE_RESERVE' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_ASN_ALLOCATE_RESERVE' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE_RESERVE' FACT_NAME,
             'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'FACT_ASN_ALLOCATE_RESERVE' DB_FACT_TAB_NAME,
             'STORE_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN_ALLOCATE_RESERVE' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_ASN_ALLOCATE_RESERVE' DB_FACT_TAB_NAME,
             'STATUS_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE_RESERVE' FACT_NAME,
             'RECEIVER_ALLOCATE' DIM_NAME,
             'ALLOCATE' LEVEL_NAME,
             'FACT_RECEIVER_ALLOCATE_RESERVE' DB_FACT_TAB_NAME,
             'RECEIVER_ALLOCATE_ID' DB_FACT_KEY_COL_NAME,
             'RECEIVER_ALLOCATE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE_RESERVE' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'FACT_RECEIVER_ALLOCATE_RESERVE' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE_RESERVE' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_RECEIVER_ALLOCATE_RESERVE' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE_RESERVE' FACT_NAME,
             'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'FACT_RECEIVER_ALLOCATE_RESERVE' DB_FACT_TAB_NAME,
             'STORE_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_ALLOCATE_RESERVE' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_RECEIVER_ALLOCATE_RESERVE' DB_FACT_TAB_NAME,
             'STATUS_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'PO_RELEASE' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_PO_RELEASE' DB_FACT_TAB_NAME,
             'STATUS_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO_RELEASE' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'FACT_PO_RELEASE' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO_RELEASE' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_PO_RELEASE' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO_RELEASE' FACT_NAME,
             'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'FACT_PO_RELEASE' DB_FACT_TAB_NAME,
             'STORE_ID' DB_FACT_KEY_COL_NAME,
             'STORE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO_RELEASE' FACT_NAME,
             'PO_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'FACT_PO_RELEASE' DB_FACT_TAB_NAME,
             'PO_RELEASE_ID' DB_FACT_KEY_COL_NAME,
             'PO_RELEASE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'ASN_RELEASE' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_ASN_RELEASE' DB_FACT_TAB_NAME,
             'STATUS_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN_RELEASE' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'FACT_ASN_RELEASE' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN_RELEASE' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_ASN_RELEASE' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN_RELEASE' FACT_NAME,
             'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'FACT_ASN_RELEASE' DB_FACT_TAB_NAME,
             'STORE_ID' DB_FACT_KEY_COL_NAME,
             'STORE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN_RELEASE' FACT_NAME,
             'ASN_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'FACT_ASN_RELEASE' DB_FACT_TAB_NAME,
             'ASN_RELEASE_ID' DB_FACT_KEY_COL_NAME,
             'ASN_RELEASE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'RECEIVER_RELEASE' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_RECEIVER_RELEASE' DB_FACT_TAB_NAME,
             'STATUS_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_RELEASE' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'FACT_RECEIVER_RELEASE' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_RELEASE' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_RECEIVER_RELEASE' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_RELEASE' FACT_NAME,
             'STORE' DIM_NAME,
             'STORE_DETAIL' LEVEL_NAME,
             'FACT_RECEIVER_RELEASE' DB_FACT_TAB_NAME,
             'STORE_ID' DB_FACT_KEY_COL_NAME,
             'STORE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_RELEASE' FACT_NAME,
             'RECEIVER_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'FACT_RECEIVER_RELEASE' DB_FACT_TAB_NAME,
             'RECEIVER_RELEASE_ID' DB_FACT_KEY_COL_NAME,
             'RECEIVER_RELEASE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'PO_RELEASE_RESERVE' FACT_NAME,
             'PO_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'FACT_PO_RELEASE_RESERVE' DB_FACT_TAB_NAME,
             'PO_RELEASE_ID' DB_FACT_KEY_COL_NAME,
             'PO_RELEASE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO_RELEASE_RESERVE' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'FACT_PO_RELEASE_RESERVE' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO_RELEASE_RESERVE' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_PO_RELEASE_RESERVE' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO_RELEASE_RESERVE' FACT_NAME,
             'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'FACT_PO_RELEASE_RESERVE' DB_FACT_TAB_NAME,
             'STORE_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'PO_RELEASE_RESERVE' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_PO_RELEASE_RESERVE' DB_FACT_TAB_NAME,
             'STATUS_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'ASN_RELEASE_RESERVE' FACT_NAME,
             'ASN_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'FACT_ASN_RELEASE_RESERVE' DB_FACT_TAB_NAME,
             'ASN_RELEASE_ID' DB_FACT_KEY_COL_NAME,
             'ASN_RELEASE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN_RELEASE_RESERVE' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'FACT_ASN_RELEASE_RESERVE' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN_RELEASE_RESERVE' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_ASN_RELEASE_RESERVE' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN_RELEASE_RESERVE' FACT_NAME,
             'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'FACT_ASN_RELEASE_RESERVE' DB_FACT_TAB_NAME,
             'STORE_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'ASN_RELEASE_RESERVE' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_ASN_RELEASE_RESERVE' DB_FACT_TAB_NAME,
             'STATUS_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'RECEIVER_RELEASE_RESERVE' FACT_NAME,
             'RECEIVER_ALLOCATE' DIM_NAME,
             'RELEASE' LEVEL_NAME,
             'FACT_RECEIVER_RELEASE_RESERVE' DB_FACT_TAB_NAME,
             'RECEIVER_RELEASE_ID' DB_FACT_KEY_COL_NAME,
             'RECEIVER_RELEASE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_RELEASE_RESERVE' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR_SIZE_GP' LEVEL_NAME,
             'FACT_RECEIVER_RELEASE_RESERVE' DB_FACT_TAB_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_SIZE_GP_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_RELEASE_RESERVE' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_RECEIVER_RELEASE_RESERVE' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_RELEASE_RESERVE' FACT_NAME,
             'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'FACT_RECEIVER_RELEASE_RESERVE' DB_FACT_TAB_NAME,
             'STORE_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'RECEIVER_RELEASE_RESERVE' FACT_NAME,
             'COMMON' DIM_NAME,
             'COMMON' LEVEL_NAME,
             'FACT_RECEIVER_RELEASE_RESERVE' DB_FACT_TAB_NAME,
             'STATUS_ID' DB_FACT_KEY_COL_NAME,
             'COMMON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      --BOXSTYLE
      UNION ALL
      SELECT 'BOXSTYLE_SC_LOC' FACT_NAME,
             'BOXSTYLE' DIM_NAME,
             'BOXSTYLE' LEVEL_NAME,
             'FACT_BOXSTYLE_SC_LOC' DB_FACT_TAB_NAME,
             'BOXSTYLE_ID' DB_FACT_KEY_COL_NAME,
             'BOXSTYLE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'BOXSTYLE_SC_LOC' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'FACT_BOXSTYLE_SC_LOC' DB_FACT_TAB_NAME,
             'STYLE_COLOR_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'BOXSTYLE_SC_LOC' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_BOXSTYLE_SC_LOC' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'BOXSTYLE_SC_LOC' FACT_NAME,
             'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'FACT_BOXSTYLE_SC_LOC' DB_FACT_TAB_NAME,
             'STORE_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'BOXSTYLE_PROD_LOC' FACT_NAME,
             'BOXSTYLE' DIM_NAME,
             'BOXSTYLE' LEVEL_NAME,
             'FACT_BOXSTYLE_PROD_LOC' DB_FACT_TAB_NAME,
             'BOXSTYLE_ID' DB_FACT_KEY_COL_NAME,
             'BOXSTYLE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'BOXSTYLE_PROD_LOC' FACT_NAME,
             'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'FACT_BOXSTYLE_PROD_LOC' DB_FACT_TAB_NAME,
             'PROD_ATTR_VALUE_ID' DB_FACT_KEY_COL_NAME,
             'PROD_ATTR_VALUE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'BOXSTYLE_PROD_LOC' FACT_NAME,
             'YEAR_SEASON' DIM_NAME,
             'YEAR_SEASON' LEVEL_NAME,
             'FACT_BOXSTYLE_PROD_LOC' DB_FACT_TAB_NAME,
             'YEAR_SEASON_ID' DB_FACT_KEY_COL_NAME,
             'YEAR_SEASON_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'BOXSTYLE_PROD_LOC' FACT_NAME,
             'STORE' DIM_NAME,
             'DC' LEVEL_NAME,
             'FACT_BOXSTYLE_PROD_LOC' DB_FACT_TAB_NAME,
             'STORE_LOC_ID' DB_FACT_KEY_COL_NAME,
             'STORE_LOC_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      
      UNION ALL
      SELECT 'MIN_MAX_PROD_LOC' FACT_NAME,
             'STYLE' DIM_NAME,
             'PROD_ATTR_VALUE' LEVEL_NAME,
             'FACT_MIN_MAX_PROD_LOC' DB_FACT_TAB_NAME,
             'PROD_ATTR_VALUE_ID' DB_FACT_KEY_COL_NAME,
             'PROD_ATTR_VALUE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'MIN_MAX_PROD_LOC' FACT_NAME,
             'STORE' DIM_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'FACT_MIN_MAX_PROD_LOC' DB_FACT_TAB_NAME,
             'LOC_ATTR_VALUE_ID' DB_FACT_KEY_COL_NAME,
             'LOC_ATTR_VALUE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'MIN_MAX_PROD_LOC' FACT_NAME,
             'MIN_MAX' DIM_NAME,
             'MIN_MAX' LEVEL_NAME,
             'FACT_MIN_MAX_PROD_LOC' DB_FACT_TAB_NAME,
             'MIN_MAX_ID' DB_FACT_KEY_COL_NAME,
             'MIN_MAX_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'MIN_MAX_PROD_LOC' FACT_NAME,
             'CLUSTER_SEQUENCE' DIM_NAME,
             'CLUSTER_SEQUENCE' LEVEL_NAME,
             'FACT_MIN_MAX_PROD_LOC' DB_FACT_TAB_NAME,
             'CLUSTER_SEQUENCE_ID' DB_FACT_KEY_COL_NAME,
             'CLUSTER_SEQUENCE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'MIN_MAX_SC_LOC' FACT_NAME,
             'STYLE' DIM_NAME,
             'STYLE_COLOR' LEVEL_NAME,
             'FACT_MIN_MAX_SC_LOC' DB_FACT_TAB_NAME,
             'STYLE_COLOR_ID' DB_FACT_KEY_COL_NAME,
             'STYLE_COLOR_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'MIN_MAX_SC_LOC' FACT_NAME,
             'STORE' DIM_NAME,
             'LOC_ATTR_VALUE' LEVEL_NAME,
             'FACT_MIN_MAX_SC_LOC' DB_FACT_TAB_NAME,
             'LOC_ATTR_VALUE_ID' DB_FACT_KEY_COL_NAME,
             'LOC_ATTR_VALUE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'MIN_MAX_SC_LOC' FACT_NAME,
             'MIN_MAX' DIM_NAME,
             'MIN_MAX' LEVEL_NAME,
             'FACT_MIN_MAX_SC_LOC' DB_FACT_TAB_NAME,
             'MIN_MAX_ID' DB_FACT_KEY_COL_NAME,
             'MIN_MAX_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL
      UNION ALL
      SELECT 'MIN_MAX_SC_LOC' FACT_NAME,
             'CLUSTER_SEQUENCE' DIM_NAME,
             'CLUSTER_SEQUENCE' LEVEL_NAME,
             'FACT_MIN_MAX_SC_LOC' DB_FACT_TAB_NAME,
             'CLUSTER_SEQUENCE_ID' DB_FACT_KEY_COL_NAME,
             'CLUSTER_SEQUENCE_ID' DB_DIM_LEVEL_KEY_COL_NAME
        FROM DUAL;
  
    COMMIT;
  END POP_FACT_DIM_RELATIONS;

  PROCEDURE POP_META_FOR_LOC_SETUP IS
  BEGIN
    --CLEAR DEFAULT LOC HIERARCHY
    DELETE FROM META_DIM_LEVELS
     WHERE DIM_NAME = 'STORE'
       AND LEVEL_NAME NOT IN ('LOC_ATTR', 'LOC_ATTR_VALUE', 'STORE_DETAIL');
  
    DELETE FROM META_DIM_LEVEL_ATTRS
     WHERE DIM_NAME = 'STORE'
       AND LEVEL_NAME NOT IN ('LOC_ATTR', 'LOC_ATTR_VALUE', 'STORE_DETAIL');
  
    DELETE FROM META_DIM_HIER_LEVELS
     WHERE DIM_NAME = 'STORE'
       AND HIERARCHY_NAME = 'PRIMARY_STORE';
  
    DELETE FROM META_DIM_HIER_LEVEL_ATTRS
     WHERE DIM_NAME = 'STORE'
       AND HIERARCHY_NAME = 'PRIMARY_STORE';
  
    DELETE FROM META_DIM_LEVEL_ATTR_MAPPING
     WHERE DIM_NAME = 'STORE'
       AND LEVEL_NAME NOT IN ('LOC_ATTR', 'LOC_ATTR_VALUE', 'STORE_DETAIL');
  
    INSERT INTO META_DIM_LEVELS
      (DIM_NAME,
       LEVEL_NAME,
       DB_TAB_NAME,
       DB_KEY_COL_NAME,
       BUSINESS_DESC,
       ETL_SOURCE)
      SELECT C.DIM_NAME,
             C.LEVEL_NAME,
             'DIM_STORE_LOC',
             'STORE_LOC_ID',
             C.LEVEL_NAME,
             'COMPANY_DOOR@MYLINKAPP'
        FROM COMPANY_HIERARCHY_LEVEL@MYLINKAPP C
       ORDER BY C.LEVEL_ID;
  
    INSERT INTO META_DIM_LEVEL_ATTRS
      (DIM_NAME,
       LEVEL_NAME,
       ATTR_NAME,
       DB_COL_NAME,
       BUSINESS_DESC,
       VISABLE)
      SELECT C.DIM_NAME,
             C.LEVEL_NAME,
             D.COLUMN_NAME ATTR_NAME,
             D.COLUMN_NAME DB_COL_NAME,
             NVL(E.ATTR_DESC, D.COLUMN_NAME) BUSINESS_DESC,
             (CASE
               WHEN D.COLUMN_NAME LIKE '%!_ID' ESCAPE '!' THEN
                'N'
               ELSE
                'Y'
             END) VISABLE
        FROM COMPANY_HIERARCHY_LEVEL@MYLINKAPP C
        FULL JOIN (SELECT COLUMN_NAME, COLUMN_ID
                     FROM USER_TAB_COLS
                    WHERE TABLE_NAME = 'DIM_STORE_LOC') D
          ON 1 = 1
        LEFT JOIN (SELECT *
                     FROM COMPANY_HIERARCHY_LEVEL_KEY@MYLINKAPP
                    WHERE KEY_NAME LIKE 'LOC_ATTR%') E
          ON C.LEVEL_ID = E.LEVEL_ID
         AND D.COLUMN_NAME = E.KEY_NAME
       ORDER BY C.LEVEL_ID, D.COLUMN_ID;
  
    INSERT INTO META_DIM_HIER_LEVELS
      (DIM_NAME,
       HIERARCHY_NAME,
       LEVEL_NAME,
       LEVEL_ID,
       TOP,
       BOTTOM,
       PARENT_LEVEL_NAME,
       DB_TAB_NAME,
       DB_KEY_COL_NAME,
       DB_JOIN_COL_NAME,
       DB_PARENT_TAB_NAME,
       DB_PARENT_KEY_COL_NAME)
      SELECT C.DIM_NAME DIM_NAME,
             'PRIMARY_STORE' HIERARCHY_NAME,
             C.LEVEL_NAME LEVEL_NAME,
             C.LEVEL_ID,
             (CASE
               WHEN C.LEVEL_ID = 1 THEN
                'Y'
               ELSE
                'N'
             END) TOP,
             (CASE
               WHEN C.LEVEL_ID = D.MAX_LEVEL_ID THEN
                'Y'
               ELSE
                'N'
             END) BOTTOM,
             C_DUMMY PARENT_LEVEL_NAME,
             'DIM_STORE_LOC' DB_TAB_NAME,
             'STORE_LOC_ID' DB_KEY_COL_NAME,
             C_DUMMY DB_JOIN_COL_NAME,
             C_DUMMY DB_PARENT_TAB_NAME,
             C_DUMMY DB_PARENT_KEY_COL_NAME
        FROM COMPANY_HIERARCHY_LEVEL@MYLINKAPP C,
             (SELECT MAX(LEVEL_ID) MAX_LEVEL_ID
                FROM COMPANY_HIERARCHY_LEVEL@MYLINKAPP) D
       ORDER BY C.LEVEL_ID;
  
    INSERT INTO META_DIM_LEVEL_ATTR_MAPPING
      (DIM_NAME, LEVEL_NAME, ATTR_NAME, SOURCE_FIELD, FIELD_SEQ)
      SELECT C.DIM_NAME,
             C.LEVEL_NAME,
             D.COLUMN_NAME ATTR_NAME,
             NVL(E.ATTR_NAME, C_DUMMY) SOURCE_FIELD,
             NVL(E.ATTR_SEQ, 1)
        FROM COMPANY_HIERARCHY_LEVEL@MYLINKAPP C
        FULL JOIN (SELECT COLUMN_NAME, COLUMN_ID
                     FROM USER_TAB_COLS
                    WHERE TABLE_NAME = 'DIM_STORE_LOC'
                      AND COLUMN_NAME NOT IN ('STORE_LOC_ID', 'LOC_TYPE')) D
          ON 1 = 1
        LEFT JOIN COMPANY_HIERARCHY_LEVEL_KEY@MYLINKAPP E
          ON C.LEVEL_ID = E.LEVEL_ID
         AND D.COLUMN_NAME = E.KEY_NAME
       ORDER BY C.LEVEL_ID, D.COLUMN_ID, E.ATTR_SEQ;
  
    COMMIT;
  END POP_META_FOR_LOC_SETUP;

BEGIN

  --1,STYLE ALL LEVELS
  L_BUS_DESC_CACHE('STYLE.DEPT.DEPT_NUM') := 'DEPARTMENT NUM';
  L_BUS_DESC_CACHE('STYLE.DEPT.DEPT') := 'DEPARTMENT NAME';
  L_BUS_DESC_CACHE('STYLE.DEPT.ORI_DEPT_ID') := 'DEPARTMENT';
  L_BUS_DESC_CACHE('STYLE.DEPT.DIVISION') := 'DIVISION';
  L_BUS_DESC_CACHE('STYLE.DEPT.CORPORATE_DIVISION') := 'CORPORATE DIVISION';
  L_BUS_DESC_CACHE('STYLE.VENDOR.ORI_COMPANY_ID') := 'VENDOR NAME';
  L_BUS_DESC_CACHE('STYLE.STYLE.STYLE_NUMBER') := 'STYLE #';
  L_BUS_DESC_CACHE('STYLE.STYLE.DESCRIPTION') := 'STYLE DESCRIPTION';
  L_BUS_DESC_CACHE('STYLE.STYLE.VENDOR_NAME') := 'VENDOR COMPANY NAME';
  L_BUS_DESC_CACHE('STYLE.STYLE.SIZE_RANGE') := 'SIZE RANGE';
  L_BUS_DESC_CACHE('STYLE.STYLE.DEPT_TYPE') := 'DEPARTMENT TYPE';
  L_BUS_DESC_CACHE('STYLE.STYLE.DIVISION_TYPE') := 'DIVISION TYPE';
  L_BUS_DESC_CACHE('STYLE.STYLE.CLASS_CODE') := 'CLASS CODE';
  L_BUS_DESC_CACHE('STYLE.STYLE.CLASS') := 'CLASS DESC';
  L_BUS_DESC_CACHE('STYLE.STYLE.ORI_BUYER_CLASS_ID') := 'CLASS';
  L_BUS_DESC_CACHE('STYLE.STYLE.PRODUCT_CATEGORY') := 'PRODUCT CATEGORY';
  L_BUS_DESC_CACHE('STYLE.STYLE.CATEGORY') := 'CATEGORY TYPE';
  L_BUS_DESC_CACHE('STYLE.STYLE.PRODUCTION_TYPE') := 'PRODUCTION TYPE NAME';
  L_BUS_DESC_CACHE('STYLE.STYLE.ORI_PRODUCTION_TYPE_ID') := 'PRODUCTION TYPE';
  L_BUS_DESC_CACHE('STYLE.STYLE.FIBER_CONTENT') := 'FIBER CONTENT';
  L_BUS_DESC_CACHE('STYLE.STYLE.FABRICATION') := 'FABRICATION';
  L_BUS_DESC_CACHE('STYLE.STYLE.PRODUCT_GROUP') := 'PRODUCT GROUP';
  L_BUS_DESC_CACHE('STYLE.STYLE.RANGE_CODE') := 'RANGE CODE';
  L_BUS_DESC_CACHE('STYLE.STYLE.COLLAR') := 'COLLAR';
  L_BUS_DESC_CACHE('STYLE.STYLE.SLEEVE') := 'SLEEVE';
  L_BUS_DESC_CACHE('STYLE.STYLE.LABEL_CODE') := 'LABEL CODE';
  L_BUS_DESC_CACHE('STYLE.STYLE.TERM') := 'TERM';
  L_BUS_DESC_CACHE('STYLE.STYLE.PRODUCT_CATEGORY_CODE') := 'PRODUCT CATEGORY CODE';
  L_BUS_DESC_CACHE('STYLE.STYLE.SEASON_CODE') := 'SEASON CODE';
  L_BUS_DESC_CACHE('STYLE.STYLE.PRODUCT_GROUP_CODE') := 'PRODUCT GROUP CODE';
  L_BUS_DESC_CACHE('STYLE.STYLE.STYLE_REF_NUMBER') := 'STYLE REFERENCE NUMBER';
  L_BUS_DESC_CACHE('STYLE.STYLE.STYLE_NAME') := 'STYLE NAME';
  L_BUS_DESC_CACHE('STYLE.STYLE.SUB_CLASS') := 'SUB CLASS DESC';
  L_BUS_DESC_CACHE('STYLE.STYLE.ORI_BUYER_SUBCLASS_ID') := 'SUB CLASS';
  L_BUS_DESC_CACHE('STYLE.STYLE.MINOR_CLASS') := 'MINOR CLASS DESC';
  L_BUS_DESC_CACHE('STYLE.STYLE.ORI_BUYER_MINORCLASS_ID') := 'MINOR CLASS';
  L_BUS_DESC_CACHE('STYLE.STYLE.HANG_FOLD') := 'HANG/FOLD';
  L_BUS_DESC_CACHE('STYLE.STYLE.YIELD') := 'YIELD/UNIT';
  L_BUS_DESC_CACHE('STYLE.STYLE.DISCONTINUE_DATE') := 'DISCONTINUE DATE';
  L_BUS_DESC_CACHE('STYLE.STYLE.CHANGE_DATE') := 'CHANGE DATE';
  L_BUS_DESC_CACHE('STYLE.STYLE.REPLENISHMENT_IND') := 'REPLENISHMENT INDICATOR';
  L_BUS_DESC_CACHE('STYLE.STYLE_COLOR.COLOR_NAME') := 'COLOR NAME';
  L_BUS_DESC_CACHE('STYLE.STYLE_COLOR.COLOR_CODE') := 'COLOR CODE';
  L_BUS_DESC_CACHE('STYLE.STYLE_COLOR.VENDOR_COLOR_CODE') := 'RETAILER COLOR CODE';
  L_BUS_DESC_CACHE('STYLE.STYLE_COLOR.COLOR_FAMILY') := 'COLOR FAMILY';
  L_BUS_DESC_CACHE('STYLE.STYLE_COLOR.SHORT_COLOR_NAME') := 'SHORT COLOR DESCRIPTION';
  L_BUS_DESC_CACHE('STYLE.STYLE_COLOR.COLOR_GROUP') := 'COLOR GROUP';
  L_BUS_DESC_CACHE('STYLE.STYLE_COLOR.PATTERN') := 'PATTERN NUMBER';
  L_BUS_DESC_CACHE('STYLE.STYLE_COLOR.ACCOUNT_EXCLUSIVE') := 'EXCLUSIVE';
  L_BUS_DESC_CACHE('STYLE.STYLE_COLOR.START_SHIP_DATE') := 'START SHIP DATE';
  L_BUS_DESC_CACHE('STYLE.STYLE_COLOR.PRODUCT_TEAM') := 'PRODUCT TEAM';
  L_BUS_DESC_CACHE('STYLE.STYLE_COLOR.KEY_ITEM_INDICATOR') := 'KEY ITEM INDICATOR';
  L_BUS_DESC_CACHE('STYLE.STYLE_COLOR.PRODUCT_STOP_DATE') := 'PRODUCT STOP DATE';
  L_BUS_DESC_CACHE('STYLE.STYLE_COLOR.OUTLET_STYLE_INDICATOR') := 'OUTLET STYLE INDICATOR';
  L_BUS_DESC_CACHE('STYLE.STYLE_COLOR.MULTI_CHANNEL_IND') := 'MULTI CHANNEL INDICATOR';
  L_BUS_DESC_CACHE('STYLE.STYLE_COLOR_SIZE.SIZE_CODE') := 'SIZE CODE';
  L_BUS_DESC_CACHE('STYLE.SIZE_ITEM.SIZE_NAME1') := 'SIZE DESCRIPTION 1';
  L_BUS_DESC_CACHE('STYLE.SIZE_ITEM.SIZE_NAME2') := 'SIZE DESCRIPTION 2';
  L_BUS_DESC_CACHE('STYLE.STYLE_COLOR_SIZE.UPC') := 'UPC';
  L_BUS_DESC_CACHE('STYLE.STYLE_COLOR_SIZE.ARTICLE_NUMBER') := 'ARTICLE #';
  L_BUS_DESC_CACHE('YEAR_SEASON.YEAR_SEASON.STYLE_YEAR') := 'YEAR';
  L_BUS_DESC_CACHE('YEAR_SEASON.YEAR_SEASON.SEASON_NAME') := 'SEASON NAME';
  L_BUS_DESC_CACHE('YEAR_SEASON.YEAR_SEASON.ORI_SEASON_ID') := 'SEASON';
  L_BUS_DESC_CACHE('YEAR_SEASON.REAL_YEAR_SEASON.STYLE_YEAR') := 'STYLE YEAR';
  L_BUS_DESC_CACHE('YEAR_SEASON.REAL_YEAR_SEASON.SEASON_NAME') := 'STYLE SEASON NAME';
  L_BUS_DESC_CACHE('YEAR_SEASON.REAL_YEAR_SEASON.ORI_SEASON_ID') := 'STYLE SEASON';
  L_BUS_DESC_CACHE('STORE.STORE_DETAIL.STOCK_CATEGORY') := 'STOCK CATEGORY';
  L_BUS_DESC_CACHE('STORE.STORE_DETAIL.STORE_CATEGORY') := 'STORE CATEGORY';
  L_BUS_DESC_CACHE('STORE.STORE_DETAIL.LOC_ATTR1') := 'LOCATION ATTRIBUTE 1';
  L_BUS_DESC_CACHE('STORE.STORE_DETAIL.LOC_ATTR2') := 'LOCATION ATTRIBUTE 2';
  L_BUS_DESC_CACHE('STORE.STORE_DETAIL.LOC_ATTR3') := 'LOCATION ATTRIBUTE 3';
  L_BUS_DESC_CACHE('STORE.STORE_DETAIL.LOC_ATTR4') := 'LOCATION ATTRIBUTE 4';
  L_BUS_DESC_CACHE('STORE.STORE_DETAIL.LOC_ATTR5') := 'LOCATION ATTRIBUTE 5';
  L_BUS_DESC_CACHE('STORE.STORE_DETAIL.LOC_ATTR6') := 'LOCATION ATTRIBUTE 6';
  L_BUS_DESC_CACHE('STORE.STORE_DETAIL.LOC_ATTR7') := 'LOCATION ATTRIBUTE 7';
  L_BUS_DESC_CACHE('STORE.STORE_DETAIL.STORE_GROUP') := 'STORE GROUP';
  L_BUS_DESC_CACHE('STORE.STORE_DETAIL.STORE_TYPE') := 'STORE TYPE';
  L_BUS_DESC_CACHE('STORE.STORE_DETAIL.ORI_STORE_TYPE_ID') := 'STORE TYPE CODE';
  L_BUS_DESC_CACHE('STORE.STORE_DETAIL.PRICING_ZONE') := 'PRICING ZONE';
  L_BUS_DESC_CACHE('STORE.STORE_DETAIL.DISPLAY_CAPACITY') := 'STORE DISPLAY CAPACITY';
  L_BUS_DESC_CACHE('STORE.STORE_DETAIL.INVENTORY_CAPACITY') := 'STORE INVENTORY CAPACITY';

  --2,ALL HIERARCHIES
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.D_DEPT_NUM') := 'DEPARTMENT NUM';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.D_DEPT') := 'DEPARTMENT NAME';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.D_ORI_DEPT_ID') := 'DEPARTMENT';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.D_DIVISION') := 'DIVISION';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.D_CORPORATE_DIVISION') := 'CORPORATE DIVISION';

  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_STYLE_NUMBER') := 'STYLE #';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_DESCRIPTION') := 'STYLE DESCRIPTION';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_VENDOR_NAME') := 'VENDOR COMPANY NAME';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_SIZE_RANGE') := 'SIZE RANGE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_DEPT_TYPE') := 'DEPARTMENT TYPE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_DIVISION_TYPE') := 'DIVISION TYPE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_CLASS_CODE') := 'CLASS CODE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_CLASS') := 'CLASS DESC';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_ORI_BUYER_CLASS_ID') := 'CLASS';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_PRODUCT_CATEGORY') := 'PRODUCT CATEGORY';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_CATEGORY') := 'CATEGORY TYPE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_PRODUCTION_TYPE') := 'PRODUCTION TYPE NAME';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_ORI_PRODUCTION_TYPE_ID') := 'PRODUCTION TYPE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_FIBER_CONTENT') := 'FIBER CONTENT';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_FABRICATION') := 'FABRICATION';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_PRODUCT_GROUP') := 'PRODUCT GROUP';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_RANGE_CODE') := 'RANGE CODE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_COLLAR') := 'COLLAR';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_SLEEVE') := 'SLEEVE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_LABEL_CODE') := 'LABEL CODE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_TERM') := 'TERM';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_PRODUCT_CATEGORY_CODE') := 'PRODUCT CATEGORY CODE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_SEASON_CODE') := 'SEASON CODE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_PRODUCT_GROUP_CODE') := 'PRODUCT GROUP CODE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_STYLE_REF_NUMBER') := 'STYLE REFERENCE NUMBER';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_STYLE_NAME') := 'STYLE NAME';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_SUB_CLASS') := 'SUB CLASS DESC';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_ORI_BUYER_SUBCLASS_ID') := 'SUB CLASS';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_MINOR_CLASS') := 'MINOR CLASS DESC';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_ORI_BUYER_MINORCLASS_ID') := 'MINOR CLASS';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_HANG_FOLD') := 'HANG/FOLD';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_YIELD') := 'YIELD/UNIT';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_DISCONTINUE_DATE') := 'DISCONTINUE DATE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_CHANGE_DATE') := 'CHANGE DATE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.S_REPLENISHMENT_IND') := 'REPLENISHMENT INDICATOR';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.SC_COLOR_NAME') := 'COLOR NAME';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.SC_COLOR_CODE') := 'COLOR CODE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.SC_VENDOR_COLOR_CODE') := 'RETAILER COLOR CODE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.SC_COLOR_FAMILY') := 'COLOR FAMILY';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.SC_SHORT_COLOR_NAME') := 'SHORT COLOR DESCRIPTION';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.SC_COLOR_GROUP') := 'COLOR GROUP';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.SC_PATTERN') := 'PATTERN NUMBER';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.SC_ACCOUNT_EXCLUSIVE') := 'EXCLUSIVE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.SC_START_SHIP_DATE') := 'START SHIP DATE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.SC_PRODUCT_TEAM') := 'PRODUCT TEAM';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.SC_KEY_ITEM_INDICATOR') := 'KEY ITEM INDICATOR';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.SC_PRODUCT_STOP_DATE') := 'PRODUCT STOP DATE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.SC_OUTLET_STYLE_INDICATOR') := 'OUTLET STYLE INDICATOR';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.SC_MULTI_CHANNEL_IND') := 'MULTI CHANNEL INDICATOR';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.SIZE_CODE') := 'SIZE CODE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.SI_SIZE_NAME1') := 'SIZE DESCRIPTION 1';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.SI_SIZE_NAME2') := 'SIZE DESCRIPTION 2';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.UPC') := 'UPC';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_SIZE.ARTICLE_NUMBER') := 'ARTICLE #';

  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.D_DEPT_NUM') := 'DEPARTMENT NUM';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.D_DEPT') := 'DEPARTMENT NAME';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.D_ORI_DEPT_ID') := 'DEPARTMENT';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.D_DIVISION') := 'DIVISION';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.D_CORPORATE_DIVISION') := 'CORPORATE DIVISION';

  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_STYLE_NUMBER') := 'STYLE #';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_DESCRIPTION') := 'STYLE DESCRIPTION';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_VENDOR_NAME') := 'VENDOR COMPANY NAME';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_SIZE_RANGE') := 'SIZE RANGE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_DEPT_TYPE') := 'DEPARTMENT TYPE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_DIVISION_TYPE') := 'DIVISION TYPE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_CLASS_CODE') := 'CLASS CODE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_CLASS') := 'CLASS DESC';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_ORI_BUYER_CLASS_ID') := 'CLASS';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_PRODUCT_CATEGORY') := 'PRODUCT CATEGORY';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_CATEGORY') := 'CATEGORY TYPE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_PRODUCTION_TYPE') := 'PRODUCTION TYPE NAME';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_ORI_PRODUCTION_TYPE_ID') := 'PRODUCTION TYPE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_FIBER_CONTENT') := 'FIBER CONTENT';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_FABRICATION') := 'FABRICATION';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_PRODUCT_GROUP') := 'PRODUCT GROUP';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_RANGE_CODE') := 'RANGE CODE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_COLLAR') := 'COLLAR';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_SLEEVE') := 'SLEEVE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_LABEL_CODE') := 'LABEL CODE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_TERM') := 'TERM';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_PRODUCT_CATEGORY_CODE') := 'PRODUCT CATEGORY CODE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_SEASON_CODE') := 'SEASON CODE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_PRODUCT_GROUP_CODE') := 'PRODUCT GROUP CODE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_STYLE_REF_NUMBER') := 'STYLE REFERENCE NUMBER';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_STYLE_NAME') := 'STYLE NAME';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_SUB_CLASS') := 'SUB CLASS DESC';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_ORI_BUYER_SUBCLASS_ID') := 'SUB CLASS';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_MINOR_CLASS') := 'MINOR CLASS DESC';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_ORI_BUYER_MINORCLASS_ID') := 'MINOR CLASS';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_HANG_FOLD') := 'HANG/FOLD';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_YIELD') := 'YIELD/UNIT';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_DISCONTINUE_DATE') := 'DISCONTINUE DATE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_CHANGE_DATE') := 'CHANGE DATE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.S_REPLENISHMENT_IND') := 'REPLENISHMENT INDICATOR';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.SC_COLOR_NAME') := 'COLOR NAME';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.SC_COLOR_CODE') := 'COLOR CODE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.SC_VENDOR_COLOR_CODE') := 'RETAILER COLOR CODE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.SC_COLOR_FAMILY') := 'COLOR FAMILY';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.SC_SHORT_COLOR_NAME') := 'SHORT COLOR DESCRIPTION';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.SC_COLOR_GROUP') := 'COLOR GROUP';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.SC_PATTERN') := 'PATTERN NUMBER';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.SC_ACCOUNT_EXCLUSIVE') := 'EXCLUSIVE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.SC_START_SHIP_DATE') := 'START SHIP DATE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.SC_PRODUCT_TEAM') := 'PRODUCT TEAM';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.SC_KEY_ITEM_INDICATOR') := 'KEY ITEM INDICATOR';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.SC_PRODUCT_STOP_DATE') := 'PRODUCT STOP DATE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.SC_OUTLET_STYLE_INDICATOR') := 'OUTLET STYLE INDICATOR';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.SC_MULTI_CHANNEL_IND') := 'MULTI CHANNEL INDICATOR';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.SCS_SIZE_CODE') := 'SIZE CODE';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.SI_SIZE_NAME1') := 'SIZE DESCRIPTION 1';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.SI_SIZE_NAME2') := 'SIZE DESCRIPTION 2';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.UPC') := 'UPC';
  L_BUS_DESC_CACHE('STYLE.PRIMARY_GP.ARTICLE_NUMBER') := 'ARTICLE #';

  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.V_ORI_COMPANY_ID') := 'VENDOR NAME';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_STYLE_NUMBER') := 'STYLE #';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_DESCRIPTION') := 'STYLE DESCRIPTION';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_VENDOR_NAME') := 'VENDOR COMPANY NAME';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_SIZE_RANGE') := 'SIZE RANGE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_DEPT_TYPE') := 'DEPARTMENT TYPE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_DIVISION_TYPE') := 'DIVISION TYPE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_CLASS_CODE') := 'CLASS CODE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_CLASS') := 'CLASS DESC';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_ORI_BUYER_CLASS_ID') := 'CLASS';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_PRODUCT_CATEGORY') := 'PRODUCT CATEGORY';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_CATEGORY') := 'CATEGORY TYPE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_PRODUCTION_TYPE') := 'PRODUCTION TYPE NAME';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_ORI_PRODUCTION_TYPE_ID') := 'PRODUCTION TYPE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_FIBER_CONTENT') := 'FIBER CONTENT';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_FABRICATION') := 'FABRICATION';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_PRODUCT_GROUP') := 'PRODUCT GROUP';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_RANGE_CODE') := 'RANGE CODE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_COLLAR') := 'COLLAR';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_SLEEVE') := 'SLEEVE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_LABEL_CODE') := 'LABEL CODE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_TERM') := 'TERM';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_PRODUCT_CATEGORY_CODE') := 'PRODUCT CATEGORY CODE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_SEASON_CODE') := 'SEASON CODE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_PRODUCT_GROUP_CODE') := 'PRODUCT GROUP CODE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_STYLE_REF_NUMBER') := 'STYLE REFERENCE NUMBER';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_STYLE_NAME') := 'STYLE NAME';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_SUB_CLASS') := 'SUB CLASS DESC';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_ORI_BUYER_SUBCLASS_ID') := 'SUB CLASS';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_MINOR_CLASS') := 'MINOR CLASS DESC';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_ORI_BUYER_MINORCLASS_ID') := 'MINOR CLASS';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_HANG_FOLD') := 'HANG/FOLD';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_YIELD') := 'YIELD/UNIT';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_DISCONTINUE_DATE') := 'DISCONTINUE DATE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_CHANGE_DATE') := 'CHANGE DATE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.S_REPLENISHMENT_IND') := 'REPLENISHMENT INDICATOR';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.SC_COLOR_NAME') := 'COLOR NAME';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.SC_COLOR_CODE') := 'COLOR CODE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.SC_VENDOR_COLOR_CODE') := 'RETAILER COLOR CODE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.SC_COLOR_FAMILY') := 'COLOR FAMILY';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.SC_SHORT_COLOR_NAME') := 'SHORT COLOR DESCRIPTION';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.SC_COLOR_GROUP') := 'COLOR GROUP';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.SC_PATTERN') := 'PATTERN NUMBER';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.SC_ACCOUNT_EXCLUSIVE') := 'EXCLUSIVE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.SC_START_SHIP_DATE') := 'START SHIP DATE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.SC_PRODUCT_TEAM') := 'PRODUCT TEAM';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.SC_KEY_ITEM_INDICATOR') := 'KEY ITEM INDICATOR';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.SC_PRODUCT_STOP_DATE') := 'PRODUCT STOP DATE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.SC_OUTLET_STYLE_INDICATOR') := 'OUTLET STYLE INDICATOR';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.SC_MULTI_CHANNEL_IND') := 'MULTI CHANNEL INDICATOR';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.SIZE_CODE') := 'SIZE CODE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.SI_SIZE_NAME1') := 'SIZE DESCRIPTION 1';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.SI_SIZE_NAME2') := 'SIZE DESCRIPTION 2';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.UPC') := 'UPC';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_SIZE.ARTICLE_NUMBER') := 'ARTICLE #';

  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.V_ORI_COMPANY_ID') := 'VENDOR NAME';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_STYLE_NUMBER') := 'STYLE #';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_DESCRIPTION') := 'STYLE DESCRIPTION';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_VENDOR_NAME') := 'VENDOR COMPANY NAME';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_SIZE_RANGE') := 'SIZE RANGE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_DEPT_TYPE') := 'DEPARTMENT TYPE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_DIVISION_TYPE') := 'DIVISION TYPE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_CLASS_CODE') := 'CLASS CODE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_CLASS') := 'CLASS DESC';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_ORI_BUYER_CLASS_ID') := 'CLASS';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_PRODUCT_CATEGORY') := 'PRODUCT CATEGORY';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_CATEGORY') := 'CATEGORY TYPE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_PRODUCTION_TYPE') := 'PRODUCTION TYPE NAME';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_ORI_PRODUCTION_TYPE_ID') := 'PRODUCTION TYPE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_FIBER_CONTENT') := 'FIBER CONTENT';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_FABRICATION') := 'FABRICATION';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_PRODUCT_GROUP') := 'PRODUCT GROUP';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_RANGE_CODE') := 'RANGE CODE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_COLLAR') := 'COLLAR';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_SLEEVE') := 'SLEEVE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_LABEL_CODE') := 'LABEL CODE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_TERM') := 'TERM';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_PRODUCT_CATEGORY_CODE') := 'PRODUCT CATEGORY CODE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_SEASON_CODE') := 'SEASON CODE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_PRODUCT_GROUP_CODE') := 'PRODUCT GROUP CODE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_STYLE_REF_NUMBER') := 'STYLE REFERENCE NUMBER';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_STYLE_NAME') := 'STYLE NAME';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_SUB_CLASS') := 'SUB CLASS DESC';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_ORI_BUYER_SUBCLASS_ID') := 'SUB CLASS';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_MINOR_CLASS') := 'MINOR CLASS DESC';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_ORI_BUYER_MINORCLASS_ID') := 'MINOR CLASS';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_HANG_FOLD') := 'HANG/FOLD';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_YIELD') := 'YIELD/UNIT';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_DISCONTINUE_DATE') := 'DISCONTINUE DATE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_CHANGE_DATE') := 'CHANGE DATE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.S_REPLENISHMENT_IND') := 'REPLENISHMENT INDICATOR';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.SC_COLOR_NAME') := 'COLOR NAME';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.SC_COLOR_CODE') := 'COLOR CODE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.SC_VENDOR_COLOR_CODE') := 'RETAILER COLOR CODE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.SC_COLOR_FAMILY') := 'COLOR FAMILY';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.SC_SHORT_COLOR_NAME') := 'SHORT COLOR DESCRIPTION';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.SC_COLOR_GROUP') := 'COLOR GROUP';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.SC_PATTERN') := 'PATTERN NUMBER';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.SC_ACCOUNT_EXCLUSIVE') := 'EXCLUSIVE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.SC_START_SHIP_DATE') := 'START SHIP DATE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.SC_PRODUCT_TEAM') := 'PRODUCT TEAM';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.SC_KEY_ITEM_INDICATOR') := 'KEY ITEM INDICATOR';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.SC_PRODUCT_STOP_DATE') := 'PRODUCT STOP DATE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.SC_OUTLET_STYLE_INDICATOR') := 'OUTLET STYLE INDICATOR';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.SC_MULTI_CHANNEL_IND') := 'MULTI CHANNEL INDICATOR';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.SCS_SIZE_CODE') := 'SIZE CODE';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.SI_SIZE_NAME1') := 'SIZE DESCRIPTION 1';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.SI_SIZE_NAME2') := 'SIZE DESCRIPTION 2';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.UPC') := 'UPC';
  L_BUS_DESC_CACHE('STYLE.SECONDARY_GP.ARTICLE_NUMBER') := 'ARTICLE #';

  L_BUS_DESC_CACHE('YEAR_SEASON.PRIMARY.RYS_STYLE_YEAR') := 'STYLE YEAR';
  L_BUS_DESC_CACHE('YEAR_SEASON.PRIMARY.RYS_SEASON_NAME') := 'STYLE SEASON NAME';
  L_BUS_DESC_CACHE('YEAR_SEASON.PRIMARY.RYS_ORI_SEASON_ID') := 'STYLE SEASON';

  L_BUS_DESC_CACHE('YEAR_SEASON.PRIMARY.YS_STYLE_YEAR') := 'YEAR';
  L_BUS_DESC_CACHE('YEAR_SEASON.PRIMARY.YS_SEASON_NAME') := 'SEASON NAME';
  L_BUS_DESC_CACHE('YEAR_SEASON.PRIMARY.YS_ORI_SEASON_ID') := 'SEASON';

  L_BUS_DESC_CACHE('STORE.PRIMARY_DETAIL.STOCK_CATEGORY') := 'STOCK CATEGORY';
  L_BUS_DESC_CACHE('STORE.PRIMARY_DETAIL.STORE_CATEGORY') := 'STORE CATEGORY';

  L_BUS_DESC_CACHE('STORE.PRIMARY_DETAIL.LOC_ATTR1') := 'LOCATION ATTRIBUTE 1';
  L_BUS_DESC_CACHE('STORE.PRIMARY_DETAIL.LOC_ATTR2') := 'LOCATION ATTRIBUTE 2';
  L_BUS_DESC_CACHE('STORE.PRIMARY_DETAIL.LOC_ATTR3') := 'LOCATION ATTRIBUTE 3';
  L_BUS_DESC_CACHE('STORE.PRIMARY_DETAIL.LOC_ATTR4') := 'LOCATION ATTRIBUTE 4';
  L_BUS_DESC_CACHE('STORE.PRIMARY_DETAIL.LOC_ATTR5') := 'LOCATION ATTRIBUTE 5';
  L_BUS_DESC_CACHE('STORE.PRIMARY_DETAIL.LOC_ATTR6') := 'LOCATION ATTRIBUTE 6';
  L_BUS_DESC_CACHE('STORE.PRIMARY_DETAIL.LOC_ATTR7') := 'LOCATION ATTRIBUTE 7';

  L_BUS_DESC_CACHE('STORE.PRIMARY_DETAIL.STORE_GROUP') := 'STORE GROUP';
  L_BUS_DESC_CACHE('STORE.PRIMARY_DETAIL.STORE_TYPE') := 'STORE TYPE';
  L_BUS_DESC_CACHE('STORE.PRIMARY_DETAIL.ORI_STORE_TYPE_ID') := 'STORE TYPE CODE';
  L_BUS_DESC_CACHE('STORE.PRIMARY_DETAIL.PRICING_ZONE') := 'PRICING ZONE';
  L_BUS_DESC_CACHE('STORE.PRIMARY_DETAIL.DISPLAY_CAPACITY') := 'STORE DISPLAY CAPACITY';
  L_BUS_DESC_CACHE('STORE.PRIMARY_DETAIL.INVENTORY_CAPACITY') := 'STORE INVENTORY CAPACITY';

  L_REC_KEY_VAL.KEY := L_BUS_DESC_CACHE.FIRST;

  LOOP
    EXIT WHEN L_REC_KEY_VAL.KEY IS NULL;
    L_REC_KEY_VAL.VAL := L_BUS_DESC_CACHE(L_REC_KEY_VAL.KEY);
    L_KEY_VAL_CACHE.EXTEND();
    L_KEY_VAL_CACHE(L_KEY_VAL_CACHE.LAST) := L_REC_KEY_VAL;
  
    L_REC_KEY_VAL.KEY := L_BUS_DESC_CACHE.NEXT(L_REC_KEY_VAL.KEY);
  
  END LOOP;

  FOR I IN 1 .. L_KEY_VAL_CACHE.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE(L_KEY_VAL_CACHE(I)
                         .KEY || ':' || L_KEY_VAL_CACHE(I).VAL);
  END LOOP;

END META_POPULATE_PACK;
/
