--1,POPULATE ALL META DATA
BEGIN 
  META_POPULATE_PACK.POP_DIMS;
  META_POPULATE_PACK.POP_DIM_LEVELS;
  META_POPULATE_PACK.POP_DIM_LEVEL_ATTRS;
  META_POPULATE_PACK.POP_DIM_HIERARCHIES;
  META_POPULATE_PACK.POP_DIM_HIER_LEVELS;
  META_POPULATE_PACK.POP_DIM_HIER_LEVEL_ATTRS;
  META_POPULATE_PACK.POP_FACTS;
  META_POPULATE_PACK.POP_FACT_MEASUREMENTS;
  META_POPULATE_PACK.POP_FACT_DIM_RELATIONS;
  META_POPULATE_PACK.POP_DIM_LEVEL_ATTR_MAPPING;
END;
/

--2,populate date,style,sales_style,error,common

DECLARE
  L PLS_INTEGER := 0;
BEGIN

  DIM_POPULATE_PACK.POP_DIM_TIME();
  DIM_POPULATE_PACK.POP_DIM_STYLE(TRUE);
  DIM_POPULATE_PACK.POP_DIM_PROMOTION(TRUE);
  DIM_POPULATE_PACK.POP_DIM_ERROR;
  DIM_POPULATE_PACK.POP_DIM_COMMON;
  DIM_POPULATE_PACK.POP_DIM_YEARSEASON(TRUE);
  DIM_POPULATE_PACK.POP_DIM_STORE(TRUE);
  DIM_POPULATE_PACK.POP_DIM_CRITERIA_GROUP(TRUE);
  DIM_POPULATE_PACK.POP_DIM_AUDIT;
  DIM_POPULATE_PACK.POP_DIM_TRANSFER;
  DIM_POPULATE_PACK.POP_DIM_PROD_ATTR_VALUE(P_IS_INITIAL             => TRUE,
                                            P_VIEW_COL_COMMENTS      => '',
                                            P_SOURCE_BUSKEY_HASH_STR => 'DUMMY',
                                            P_TARGET_BUSKEY_HASH_STR => 'DUMMY',
                                            P_DELIMITER              => ',',
                                            P_PROD_ATTR_ID           => L);
  DIM_POPULATE_PACK.POP_DIM_YEARSEASON_ATTR_VALUE(P_IS_INITIAL             => TRUE,
                                                  P_VIEW_COL_COMMENTS      => '',
                                                  P_SOURCE_BUSKEY_HASH_STR => 'DUMMY',
                                                  P_TARGET_BUSKEY_HASH_STR => 'DUMMY',
                                                  P_DELIMITER              => ',',
                                                  P_YEARSEASON_ATTR_ID               => L);
  DIM_POPULATE_PACK.POP_DIM_LOC_ATTR_VALUE(P_IS_INITIAL             => TRUE,
                                           P_VIEW_COL_COMMENTS      => '',
                                           P_SOURCE_BUSKEY_HASH_STR => 'DUMMY',
                                           P_TARGET_BUSKEY_HASH_STR => 'DUMMY',
                                           P_DELIMITER              => ',',
                                           P_LOC_ATTR_ID           => L);
  DIM_POPULATE_PACK.POP_DIM_BOXSTYLE;
  DIM_POPULATE_PACK.POP_DIM_ALLOCATE;
  DIM_POPULATE_PACK.POP_DIM_RULE;
  DIM_POPULATE_PACK.POP_DIM_TRANSFER_MATRIX;
  DIM_POPULATE_PACK.POP_DIM_ALLOCATION_REFERENCE;
  --  DIM_POPULATE_PACK.POP_FACT_STYLE_BUYER_DETAIL(P_IS_INITIAL => TRUE);
END;
/