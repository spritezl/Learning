CREATE OR REPLACE PACKAGE CMMTRANSFER_POPULATE_PACK IS

  -- Author  : FZHANG
  -- Created : 7/14/2016
  -- Purpose : CMM_TRANSFER POPULATE PACKAGE

  TYPE REC_CMM_TRANSFER IS RECORD(
    --FACT_CMM_TRANSFER COLUMNS
    TRANS_BUSKEY        FACT_CMM_TRANSFER.TRANS_BUSKEY%TYPE,
    STYLE_COLOR_SIZE_ID FACT_CMM_TRANSFER.STYLE_COLOR_SIZE_ID%TYPE,
    SENDING_LOC_ID      FACT_CMM_TRANSFER.SENDING_LOC_ID %TYPE,
    RECEIVING_LOC_ID    FACT_CMM_TRANSFER.RECEIVING_LOC_ID %TYPE,
    TYPE_ID             FACT_CMM_TRANSFER.TYPE_ID%TYPE,
    DATE_ID             FACT_CMM_TRANSFER.DATE_ID %TYPE,
    START_DATE          FACT_CMM_TRANSFER.START_DATE %TYPE,
    RECEIVING_DATE      FACT_CMM_TRANSFER.RECEIVING_DATE %TYPE,
    START_DT            FACT_CMM_TRANSFER.START_DT %TYPE,
    RECEIVING_DT        FACT_CMM_TRANSFER.RECEIVING_DT %TYPE,
    DOOR_QTY            FACT_CMM_TRANSFER.DOOR_QTY %TYPE,
    TOTAL_RETAIL        FACT_CMM_TRANSFER.TOTAL_RETAIL %TYPE,
    TOTAL_COST          FACT_CMM_TRANSFER.TOTAL_COST %TYPE,
    --CMM_TRANSFER_RAW COLUMNS
    CORPORATE_DIVISION CMM_TRANSFER_RAW.CORPORATE_DIVISION%TYPE,
    VENDOR_REF_NUMBER  CMM_TRANSFER_RAW.VENDOR_REF_NUMBER %TYPE,
    --    TRACKING_NUMBER    CMM_TRANSFER_RAW.TRACKING_NUMBER %TYPE,
    CURRENT_YEAR       CMM_TRANSFER_RAW.CURRENT_YEAR %TYPE,
    CURRENT_MONTH      CMM_TRANSFER_RAW.CURRENT_MONTH %TYPE,
    CURRENT_DAY        CMM_TRANSFER_RAW.CURRENT_DAY %TYPE,
    CURRENT_WEEK       CMM_TRANSFER_RAW.CURRENT_WEEK %TYPE,
    UPC                CMM_TRANSFER_RAW.UPC %TYPE,
    STYLE_NUMBER       CMM_TRANSFER_RAW.STYLE_NUMBER %TYPE,
    COLOR_CODE         CMM_TRANSFER_RAW.COLOR_CODE %TYPE,
    COLOR_NAME         CMM_TRANSFER_RAW.COLOR_NAME %TYPE,
    SIZE_CODE          CMM_TRANSFER_RAW.SIZE_CODE %TYPE,
    SIZE_DESC1         CMM_TRANSFER_RAW.SIZE_DESC1 %TYPE,
    SIZE_DESC2         CMM_TRANSFER_RAW.SIZE_DESC2 %TYPE,
    COST               CMM_TRANSFER_RAW.COST %TYPE,
    RETAIL             CMM_TRANSFER_RAW.RETAIL %TYPE,
    SENDING_DOOR_NUM   CMM_TRANSFER_RAW.SENDING_DOOR_NUM %TYPE,
    RECEIVING_DOOR_NUM CMM_TRANSFER_RAW.RECEIVING_DOOR_NUM%TYPE,
    COUNTRY            CMM_TRANSFER_RAW.COUNTRY %TYPE,
    SENDING_DC         CMM_TRANSFER_RAW.SENDING_DC %TYPE,
    UNIQUE_KEY_ATTR1   CMM_TRANSFER_RAW.UNIQUE_KEY_ATTR1 %TYPE,
    UNIQUE_KEY_ATTR2   CMM_TRANSFER_RAW.UNIQUE_KEY_ATTR2 %TYPE,
    UNIQUE_KEY_ATTR3   CMM_TRANSFER_RAW.UNIQUE_KEY_ATTR3 %TYPE,
    UNIQUE_KEY_ATTR4   CMM_TRANSFER_RAW.UNIQUE_KEY_ATTR4 %TYPE,
    UNIQUE_KEY_ATTR5   CMM_TRANSFER_RAW.UNIQUE_KEY_ATTR5 %TYPE,
    UNIQUE_KEY_ATTR6   CMM_TRANSFER_RAW.UNIQUE_KEY_ATTR6 %TYPE,
    TRANSACTION_DATE   CMM_TRANSFER_RAW.TRANSACTION_DATE %TYPE,

    --FACT_ERROR_LOG COLUMNS
    LOG_DATE     FACT_ERROR_LOG.LOG_DATE%TYPE,
    UPLOAD_ID    FACT_ERROR_LOG.UPLOAD_ID%TYPE,
    FILE_ROW_NUM FACT_ERROR_LOG.FILE_ROW_NUM%TYPE,
    ERROR_ID     FACT_ERROR_LOG.ERROR_ID%TYPE,
    FIELD_VALUE  FACT_ERROR_LOG.FIELD_VALUE%TYPE);

  TYPE NNT_CMM_TRANSFER IS TABLE OF REC_CMM_TRANSFER;

  TYPE CMM_TRANSFER_RAW_CURSOR IS REF CURSOR RETURN CMM_TRANSFER_RAW%ROWTYPE;

  FUNCTION RESULTSET_CMMTRANSFER(P_CMM_TRANSFER_RAW_CUR IN CMM_TRANSFER_RAW_CURSOR)
    RETURN NNT_CMM_TRANSFER
    PIPELINED
    PARALLEL_ENABLE(PARTITION P_CMM_TRANSFER_RAW_CUR BY ANY);

  PROCEDURE POPULATE_CMMTRANSFER(P_UPLOAD_ID CMM_TRANSFER_RAW.UPLOAD_ID%TYPE);

END CMMTRANSFER_POPULATE_PACK;
/
CREATE OR REPLACE PACKAGE BODY CMMTRANSFER_POPULATE_PACK IS
  C_DELIMITER          CONSTANT CHAR := '-';
  C_MAX_ROWS_PER_FETCH CONSTANT PLS_INTEGER := 100000;

  TYPE REC_LOC_ATTRS IS RECORD(
    COUNTRY  DIM_STORE_LOC.SOURCE_BUSKEY%TYPE,
    DC       DIM_STORE_LOC.SOURCE_BUSKEY%TYPE,
    DOOR_NUM DIM_STORE_LOC.SOURCE_BUSKEY%TYPE);

  TYPE NNT_CACHE IS TABLE OF NUMBER(8) INDEX BY VARCHAR2(60);
  L_CACHE_STORE_LOC        NNT_CACHE;
  L_CACHE_ERROR            NNT_CACHE;
  L_CACHE_VENDOR           NNT_CACHE;
  L_CACHE_STYLE            NNT_CACHE;
  L_CACHE_STYLE_COLOR      NNT_CACHE;
  L_CACHE_STYLE_COLOR_SIZE NNT_CACHE;
  L_CACHE_DATE             NNT_CACHE;
  L_CACHE_YEAR             NNT_CACHE;
  L_CACHE_MONTH            NNT_CACHE;
  L_CACHE_TYPE             NNT_CACHE;

  TYPE TEMP_REC IS RECORD(
    ID            NUMBER(8),
    SOURCE_BUSKEY VARCHAR2(40));
  TYPE TEMP_CACHE IS TABLE OF TEMP_REC;
  L_TEMP_CACHE TEMP_CACHE;

  TYPE NNT_MEASURES IS TABLE OF NUMBER(15, 4);

  TYPE REC_STYLE_ATTRS IS RECORD(
    CORPORATE_DIVISION CMM_TRANSFER_RAW.CORPORATE_DIVISION%TYPE,
    UPC                CMM_TRANSFER_RAW.UPC%TYPE,
    VENDOR_REF_NUMBER  CMM_TRANSFER_RAW.VENDOR_REF_NUMBER%TYPE,
    STYLE_NUMBER       CMM_TRANSFER_RAW.STYLE_NUMBER%TYPE,
    COLOR_CODE         CMM_TRANSFER_RAW.COLOR_CODE%TYPE,
    COLOR_NAME         CMM_TRANSFER_RAW.COLOR_NAME%TYPE,
    SIZE_CODE          CMM_TRANSFER_RAW.SIZE_CODE%TYPE,
    SIZE_DESC1         CMM_TRANSFER_RAW.SIZE_DESC1%TYPE,
    SIZE_DESC2         CMM_TRANSFER_RAW.SIZE_DESC2%TYPE,
    UNIQUE_KEY_ATTR1   CMM_TRANSFER_RAW.UNIQUE_KEY_ATTR1 %TYPE,
    UNIQUE_KEY_ATTR2   CMM_TRANSFER_RAW.UNIQUE_KEY_ATTR2 %TYPE,
    UNIQUE_KEY_ATTR3   CMM_TRANSFER_RAW.UNIQUE_KEY_ATTR3 %TYPE,
    UNIQUE_KEY_ATTR4   CMM_TRANSFER_RAW.UNIQUE_KEY_ATTR4 %TYPE,
    UNIQUE_KEY_ATTR5   CMM_TRANSFER_RAW.UNIQUE_KEY_ATTR5 %TYPE,
    UNIQUE_KEY_ATTR6   CMM_TRANSFER_RAW.UNIQUE_KEY_ATTR6 %TYPE);

  TYPE REC_DATE_ATTRS IS RECORD(
    YEAR             CMM_TRANSFER_RAW.CURRENT_YEAR%TYPE,
    MONTH            CMM_TRANSFER_RAW.CURRENT_MONTH%TYPE,
    WEEK             CMM_TRANSFER_RAW.CURRENT_WEEK%TYPE,
    DAY              CMM_TRANSFER_RAW.CURRENT_DAY%TYPE,
    TRANSACTION_DATE CMM_TRANSFER_RAW.TRANSACTION_DATE%TYPE);

  --VALIDATE_TIME
  PROCEDURE VALIDATE_TIME(P_REC_DATE_ATTRS REC_DATE_ATTRS,
                          P_DATE_ID        IN OUT DIM_DATE_DAY.DATE_ID%TYPE) IS
    L_SOURCE_BUSKEY VARCHAR2(10);

  BEGIN
    P_DATE_ID := 0;

    IF (P_REC_DATE_ATTRS.TRANSACTION_DATE IS NULL AND
       P_REC_DATE_ATTRS.YEAR IS NULL AND P_REC_DATE_ATTRS.MONTH IS NULL AND
       P_REC_DATE_ATTRS.DAY IS NULL) THEN

      RAISE_APPLICATION_ERROR(DIM_POPULATE_PACK.C_ALL_DATE_BLANK, '');

    ELSIF P_REC_DATE_ATTRS.TRANSACTION_DATE IS NOT NULL THEN
      L_SOURCE_BUSKEY := P_REC_DATE_ATTRS.TRANSACTION_DATE;

      IF NOT L_CACHE_DATE.EXISTS(L_SOURCE_BUSKEY) THEN
        RAISE_APPLICATION_ERROR(DIM_POPULATE_PACK.C_TRANSACTION_DATE_NOTEXIST,
                                P_REC_DATE_ATTRS.TRANSACTION_DATE);
      ELSE
        P_DATE_ID := L_CACHE_DATE(L_SOURCE_BUSKEY);
      END IF;
    ELSE

      IF P_REC_DATE_ATTRS.YEAR IS NULL THEN
        RAISE_APPLICATION_ERROR(DIM_POPULATE_PACK.C_YEAR_BLANK, '');
      END IF;

      IF P_REC_DATE_ATTRS.MONTH IS NULL THEN
        RAISE_APPLICATION_ERROR(DIM_POPULATE_PACK.C_MONTH_BLANK, '');
      END IF;

      IF P_REC_DATE_ATTRS.DAY IS NULL THEN
        RAISE_APPLICATION_ERROR(DIM_POPULATE_PACK.C_DAY_BLANK, '');
      END IF;

      L_SOURCE_BUSKEY := TO_CHAR(P_REC_DATE_ATTRS.YEAR * 10000 +
                                 P_REC_DATE_ATTRS.MONTH * 100 +
                                 P_REC_DATE_ATTRS.DAY);

      IF NOT L_CACHE_DATE.EXISTS(L_SOURCE_BUSKEY) THEN
        L_SOURCE_BUSKEY := TO_CHAR(P_REC_DATE_ATTRS.YEAR * 100 +
                                   P_REC_DATE_ATTRS.MONTH);
        IF NOT L_CACHE_MONTH.EXISTS(L_SOURCE_BUSKEY) THEN
          L_SOURCE_BUSKEY := P_REC_DATE_ATTRS.YEAR;
          IF NOT L_CACHE_YEAR.EXISTS(L_SOURCE_BUSKEY) THEN
            RAISE_APPLICATION_ERROR(DIM_POPULATE_PACK.C_YEAR_NOTEXIST,
                                    P_REC_DATE_ATTRS.YEAR);
          ELSE
            RAISE_APPLICATION_ERROR(DIM_POPULATE_PACK.C_MONTH_NOTEXIST,
                                    P_REC_DATE_ATTRS.MONTH);
          END IF;
        ELSE
          RAISE_APPLICATION_ERROR(DIM_POPULATE_PACK.C_DAY_NOTEXIST,
                                  P_REC_DATE_ATTRS.DAY);

        END IF;
      ELSE
        P_DATE_ID := L_CACHE_DATE(L_SOURCE_BUSKEY);
      END IF;
    END IF;

  END VALIDATE_TIME;

  --VALIDATE STYLE
  PROCEDURE VALIDATE_STYLE(P_REC_STYLE_ATTRS     REC_STYLE_ATTRS,
                           P_STYLE_COLOR_SIZE_ID IN OUT DIM_STYLE_COLOR_SIZE.STYLE_COLOR_SIZE_ID%TYPE) IS
    L_SOURCE_BUSKEY DIM_STYLE_COLOR_SIZE.SOURCE_BUSKEY%TYPE;
  BEGIN
    --STYLE_NUMBER
    IF P_REC_STYLE_ATTRS.STYLE_NUMBER IS NULL THEN
      RAISE_APPLICATION_ERROR(DIM_POPULATE_PACK.C_STYLE_NUMBER_BLANK, '');
    END IF;

    --COLOR_CODE
    IF P_REC_STYLE_ATTRS.COLOR_CODE IS NULL THEN
      RAISE_APPLICATION_ERROR(DIM_POPULATE_PACK.C_COLOR_CODE_BLANK, '');
    END IF;

    --SIZE_CODE
    IF P_REC_STYLE_ATTRS.SIZE_CODE IS NULL THEN
      RAISE_APPLICATION_ERROR(DIM_POPULATE_PACK.C_SIZE_CODE_BLANK, '');
    END IF;

    --VENDOR_REF_NUMBER
    IF P_REC_STYLE_ATTRS.VENDOR_REF_NUMBER IS NULL THEN
      RAISE_APPLICATION_ERROR(DIM_POPULATE_PACK.C_VENDOR_REF_NUM_BLANK, '');
    END IF;

    --CHECK EXISTENCE
    L_SOURCE_BUSKEY := UPPER(P_REC_STYLE_ATTRS.VENDOR_REF_NUMBER) ||
                       C_DELIMITER || UPPER(P_REC_STYLE_ATTRS.STYLE_NUMBER) ||
                       C_DELIMITER || UPPER(P_REC_STYLE_ATTRS.COLOR_CODE) ||
                       C_DELIMITER || UPPER(P_REC_STYLE_ATTRS.SIZE_CODE);
    IF L_CACHE_STYLE_COLOR_SIZE.EXISTS(L_SOURCE_BUSKEY) THEN
      P_STYLE_COLOR_SIZE_ID := L_CACHE_STYLE_COLOR_SIZE(L_SOURCE_BUSKEY);
    ELSE
      L_SOURCE_BUSKEY := UPPER(P_REC_STYLE_ATTRS.VENDOR_REF_NUMBER) ||
                         C_DELIMITER ||
                         UPPER(P_REC_STYLE_ATTRS.STYLE_NUMBER) ||
                         C_DELIMITER || UPPER(P_REC_STYLE_ATTRS.COLOR_CODE);
      IF NOT L_CACHE_STYLE_COLOR.EXISTS(L_SOURCE_BUSKEY) THEN
        L_SOURCE_BUSKEY := UPPER(P_REC_STYLE_ATTRS.VENDOR_REF_NUMBER) ||
                           C_DELIMITER ||
                           UPPER(P_REC_STYLE_ATTRS.STYLE_NUMBER);
        IF NOT L_CACHE_STYLE.EXISTS(L_SOURCE_BUSKEY) THEN
          L_SOURCE_BUSKEY := UPPER(P_REC_STYLE_ATTRS.VENDOR_REF_NUMBER);
          IF NOT L_CACHE_VENDOR.EXISTS(L_SOURCE_BUSKEY) THEN
            RAISE_APPLICATION_ERROR(DIM_POPULATE_PACK.C_VENDOR_REF_NUM_NOTEXIST,
                                    L_SOURCE_BUSKEY);
          ELSE
            RAISE_APPLICATION_ERROR(DIM_POPULATE_PACK.C_STYLE_NUMBER_NOTEXIST,
                                    UPPER(P_REC_STYLE_ATTRS.VENDOR_REF_NUMBER) ||
                                     C_DELIMITER ||
                                     UPPER(P_REC_STYLE_ATTRS.STYLE_NUMBER));
          END IF;
        END IF;

        RAISE_APPLICATION_ERROR(DIM_POPULATE_PACK.C_COLOR_CODE_NOTEXIST,
                                UPPER(P_REC_STYLE_ATTRS.COLOR_CODE));
      END IF;

      RAISE_APPLICATION_ERROR(DIM_POPULATE_PACK.C_SIZE_CODE_NOTEXIST,
                              UPPER(P_REC_STYLE_ATTRS.SIZE_CODE));
    END IF;

  END VALIDATE_STYLE;

  PROCEDURE VALIDATE_SENDING_LOC(P_REC_LOC_ATTRS REC_LOC_ATTRS,
                                 P_STORE_LOC_ID  IN OUT DIM_STORE_LOC.STORE_LOC_ID%TYPE) IS
    L_SOURCE_BUSKEY DIM_STORE_LOC.SOURCE_BUSKEY%TYPE;
  BEGIN
    P_STORE_LOC_ID := 0;

    IF P_REC_LOC_ATTRS.DOOR_NUM IS NULL THEN

      IF P_REC_LOC_ATTRS.DC IS NULL THEN
        RAISE_APPLICATION_ERROR(DIM_POPULATE_PACK.C_SENDING_DC_DOOR_BLANK,
                                '');
      ELSE
        IF P_REC_LOC_ATTRS.COUNTRY IS NULL THEN
          RAISE_APPLICATION_ERROR(DIM_POPULATE_PACK.C_STORE_COUNTRY_BLANK,
                                  '');
        ELSE
          L_SOURCE_BUSKEY := UPPER(P_REC_LOC_ATTRS.COUNTRY);
          IF NOT L_CACHE_STORE_LOC.EXISTS(L_SOURCE_BUSKEY) THEN
            RAISE_APPLICATION_ERROR(DIM_POPULATE_PACK.C_STORE_COUNTRY_NOTEXIST,
                                    P_REC_LOC_ATTRS.COUNTRY);
          ELSE
            L_SOURCE_BUSKEY := UPPER(P_REC_LOC_ATTRS.COUNTRY || C_DELIMITER ||
                                     P_REC_LOC_ATTRS.DC);
            IF NOT L_CACHE_STORE_LOC.EXISTS(L_SOURCE_BUSKEY) THEN
              RAISE_APPLICATION_ERROR(DIM_POPULATE_PACK.C_STORE_DC_NOTEXIST,
                                      P_REC_LOC_ATTRS.DC);
            ELSE
              P_STORE_LOC_ID := L_CACHE_STORE_LOC(L_SOURCE_BUSKEY);
            END IF;

          END IF;
        END IF;
      END IF;

    ELSE
      L_SOURCE_BUSKEY := UPPER(P_REC_LOC_ATTRS.DOOR_NUM);
      IF NOT L_CACHE_STORE_LOC.EXISTS(L_SOURCE_BUSKEY) THEN
        RAISE_APPLICATION_ERROR(DIM_POPULATE_PACK.C_SENDING_DOOR_NOTEXIST,
                                L_SOURCE_BUSKEY);
      ELSE
        P_STORE_LOC_ID := L_CACHE_STORE_LOC(L_SOURCE_BUSKEY);
      END IF;

    END IF;

  END VALIDATE_SENDING_LOC;

  --PLEASE NOTE, HERE IS AT THE DOOR LEVEL
  PROCEDURE VALIDATE_RECEIVING_LOC(P_REC_LOC_ATTRS REC_LOC_ATTRS,
                                   P_STORE_LOC_ID  IN OUT DIM_STORE_LOC.STORE_LOC_ID%TYPE) IS
    L_SOURCE_BUSKEY DIM_STORE_LOC.SOURCE_BUSKEY%TYPE;
  BEGIN
    L_SOURCE_BUSKEY := UPPER(P_REC_LOC_ATTRS.DOOR_NUM);
    IF L_SOURCE_BUSKEY IS NULL THEN
      RAISE_APPLICATION_ERROR(DIM_POPULATE_PACK.C_RECEIVING_DOOR_BLANK, '');
    ELSIF NOT L_CACHE_STORE_LOC.EXISTS(L_SOURCE_BUSKEY) THEN
      RAISE_APPLICATION_ERROR(DIM_POPULATE_PACK.C_RECEIVING_DOOR_NOTEXIST,
                              L_SOURCE_BUSKEY);
    ELSE
      P_STORE_LOC_ID := L_CACHE_STORE_LOC(L_SOURCE_BUSKEY);
    END IF;

  END VALIDATE_RECEIVING_LOC;

  --VALIDATE MEASURES
  PROCEDURE VALIDATE_MEASURES(P_NNT_MEASURES NNT_MEASURES) IS
    L_SQLCODE VARCHAR2(10);
  BEGIN
    L_SQLCODE := DIM_POPULATE_PACK.C_MEASUREMENTS_BLANK;

    FOR I IN P_NNT_MEASURES.FIRST .. P_NNT_MEASURES.LAST LOOP
      IF NVL(P_NNT_MEASURES(I), 0) != 0 THEN
        L_SQLCODE := 0;
        EXIT;
      END IF;
    END LOOP;

    IF L_SQLCODE != 0 THEN
      RAISE_APPLICATION_ERROR(L_SQLCODE, '');
    END IF;

    --HERE L_SQLCODE IS 0 MEANS EVERY MEASURES IS CORRECT SO FAR
    --THE FOLLOWING CHECK NEGATIVE NUMBER
    FOR I IN P_NNT_MEASURES.FIRST .. P_NNT_MEASURES.LAST LOOP
      IF NVL(P_NNT_MEASURES(I), 0) < 0 THEN
        L_SQLCODE := DIM_POPULATE_PACK.C_MEASUREMENTS_NEGATIVE;
        EXIT;
      END IF;
    END LOOP;

    IF L_SQLCODE != 0 THEN
      RAISE_APPLICATION_ERROR(L_SQLCODE, '');
    END IF;

  END VALIDATE_MEASURES;

  PROCEDURE VALIDATE_MISC_DATES(P_TRANSACTION_DATE   DATE,
                                P_START_DATE_RAW     CMM_TRANSFER_RAW.START_DATE%TYPE,
                                P_RECEIVING_DATE_RAW CMM_TRANSFER_RAW.RECEIVING_DATE%TYPE,
                                P_START_DATE         OUT DATE,
                                P_RECEIVING_DATE     OUT DATE,
                                P_TYPE_ID            OUT FACT_CMM_TRANSFER.TYPE_ID%TYPE) IS
                                C_TYPE_SYSTEM_SUGGESTED CONSTANT VARCHAR2(30):= 'SYSTEM_SUGGESTED';
                                C_TYPE_USER_UPLOADED    CONSTANT VARCHAR2(30):= 'USER_UPLOADED';

  BEGIN
    P_TYPE_ID:=0;
    P_START_DATE:=TRUNC(SYSDATE);
    P_RECEIVING_DATE:=TRUNC(SYSDATE);

    IF P_START_DATE_RAW IS NULL THEN
      RAISE_APPLICATION_ERROR(DIM_POPULATE_PACK.C_START_DATE_BLANK, '');
    ELSE
      BEGIN
        P_START_DATE := TO_DATE(P_START_DATE_RAW, 'YYYYMMDD');
      EXCEPTION
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(DIM_POPULATE_PACK.C_START_DATE_INCORRECT,
                                  P_START_DATE_RAW);
      END;
    END IF;

    IF P_RECEIVING_DATE_RAW IS NULL THEN
      P_TYPE_ID:=L_CACHE_TYPE(C_TYPE_SYSTEM_SUGGESTED);
    ELSE
      P_TYPE_ID:=L_CACHE_TYPE(C_TYPE_USER_UPLOADED);
    END IF;

    BEGIN
      P_RECEIVING_DATE := TO_DATE(NVL(P_RECEIVING_DATE_RAW, '99991231'),
                                  'YYYYMMDD');
    EXCEPTION
      WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(DIM_POPULATE_PACK.C_RECEIVING_DATE_INCORRECT,
                                P_RECEIVING_DATE_RAW);
    END;


    IF P_START_DATE > P_TRANSACTION_DATE THEN
      RAISE_APPLICATION_ERROR(DIM_POPULATE_PACK.C_START_DATE_TOO_LARGE,
                              TO_CHAR(P_START_DATE, 'YYYYMMDD'));
    ELSIF P_RECEIVING_DATE < P_START_DATE THEN
      RAISE_APPLICATION_ERROR(DIM_POPULATE_PACK.C_RECEIVING_DATE_TOO_LESS,
                              TO_CHAR(P_RECEIVING_DATE, 'YYYYMMDD'));
    END IF;
  END VALIDATE_MISC_DATES;

  PROCEDURE VALIDATE_CMM_TRANSFER(P_TRANS_BUSKEY CMM_TRANSFER_RAW.TRACKING_NUMBER%TYPE) IS
  BEGIN
    IF P_TRANS_BUSKEY IS NULL THEN
      RAISE_APPLICATION_ERROR(DIM_POPULATE_PACK.C_CMM_TRANSFER_BLANK, '');
    END IF;
  END VALIDATE_CMM_TRANSFER;

  PROCEDURE VALIDATE_SENDING_RECEIVING_LOC(P_SENDING_LOC_ID   FACT_CMM_TRANSFER.SENDING_LOC_ID%TYPE,
                                           P_RECEIVING_LOC_ID FACT_CMM_TRANSFER.RECEIVING_LOC_ID%TYPE) IS
  BEGIN
    IF P_SENDING_LOC_ID = P_RECEIVING_LOC_ID THEN
      RAISE_APPLICATION_ERROR(DIM_POPULATE_PACK.C_SENDING_RECEIVING_DOOR_SAME,
                              '');
    END IF;
  END VALIDATE_SENDING_RECEIVING_LOC;

  FUNCTION RESULTSET_CMMTRANSFER(P_CMM_TRANSFER_RAW_CUR IN CMM_TRANSFER_RAW_CURSOR)
    RETURN NNT_CMM_TRANSFER
    PIPELINED
    PARALLEL_ENABLE(PARTITION P_CMM_TRANSFER_RAW_CUR BY ANY) IS

    TYPE NNT_CMM_TRANSFER_RAW IS TABLE OF CMM_TRANSFER_RAW%ROWTYPE;
    L_CACHE_CMM_TRANSFER_RAW NNT_CMM_TRANSFER_RAW;
    L_REC_CMM_TRANSFER       REC_CMM_TRANSFER;

    L_REC_STYLE_ATTRS REC_STYLE_ATTRS;
    L_REC_LOC_ATTRS   REC_LOC_ATTRS;
    L_NNT_MEASURES    NNT_MEASURES;
    L_REC_DATE_ATTRS  REC_DATE_ATTRS;

  BEGIN

    LOOP
      FETCH P_CMM_TRANSFER_RAW_CUR BULK COLLECT
        INTO L_CACHE_CMM_TRANSFER_RAW LIMIT C_MAX_ROWS_PER_FETCH;
      EXIT WHEN L_CACHE_CMM_TRANSFER_RAW.COUNT = 0;

      FOR I IN L_CACHE_CMM_TRANSFER_RAW.FIRST .. L_CACHE_CMM_TRANSFER_RAW.LAST LOOP
        BEGIN

          L_REC_CMM_TRANSFER.DOOR_QTY           := NVL(L_CACHE_CMM_TRANSFER_RAW(I).DOOR_QTY,0);
          L_REC_CMM_TRANSFER.TOTAL_RETAIL       := L_CACHE_CMM_TRANSFER_RAW(I).TOTAL_RETAIL;
          L_REC_CMM_TRANSFER.TOTAL_COST         := L_CACHE_CMM_TRANSFER_RAW(I).TOTAL_COST;
          L_REC_CMM_TRANSFER.CORPORATE_DIVISION := L_CACHE_CMM_TRANSFER_RAW(I).CORPORATE_DIVISION;
          L_REC_CMM_TRANSFER.VENDOR_REF_NUMBER  := L_CACHE_CMM_TRANSFER_RAW(I).VENDOR_REF_NUMBER;
          L_REC_CMM_TRANSFER.TRANS_BUSKEY       := L_CACHE_CMM_TRANSFER_RAW(I).TRACKING_NUMBER;
          L_REC_CMM_TRANSFER.CURRENT_YEAR       := L_CACHE_CMM_TRANSFER_RAW(I).CURRENT_YEAR;
          L_REC_CMM_TRANSFER.CURRENT_MONTH      := L_CACHE_CMM_TRANSFER_RAW(I).CURRENT_MONTH;
          L_REC_CMM_TRANSFER.CURRENT_DAY        := L_CACHE_CMM_TRANSFER_RAW(I).CURRENT_DAY;
          L_REC_CMM_TRANSFER.CURRENT_WEEK       := L_CACHE_CMM_TRANSFER_RAW(I).CURRENT_WEEK;
          L_REC_CMM_TRANSFER.UPC                := L_CACHE_CMM_TRANSFER_RAW(I).UPC;
          L_REC_CMM_TRANSFER.STYLE_NUMBER       := L_CACHE_CMM_TRANSFER_RAW(I).STYLE_NUMBER;
          L_REC_CMM_TRANSFER.COLOR_CODE         := L_CACHE_CMM_TRANSFER_RAW(I).COLOR_CODE;
          L_REC_CMM_TRANSFER.SIZE_CODE          := L_CACHE_CMM_TRANSFER_RAW(I).SIZE_CODE;
          L_REC_CMM_TRANSFER.SIZE_DESC1         := L_CACHE_CMM_TRANSFER_RAW(I).SIZE_DESC1;
          L_REC_CMM_TRANSFER.SIZE_DESC2         := L_CACHE_CMM_TRANSFER_RAW(I).SIZE_DESC2;
          L_REC_CMM_TRANSFER.COST               := NVL(L_CACHE_CMM_TRANSFER_RAW(I).COST,0);
          L_REC_CMM_TRANSFER.RETAIL             := NVL(L_CACHE_CMM_TRANSFER_RAW(I).RETAIL,0);
          L_REC_CMM_TRANSFER.SENDING_DOOR_NUM   := L_CACHE_CMM_TRANSFER_RAW(I).SENDING_DOOR_NUM;
          L_REC_CMM_TRANSFER.RECEIVING_DOOR_NUM := L_CACHE_CMM_TRANSFER_RAW(I).RECEIVING_DOOR_NUM;
          L_REC_CMM_TRANSFER.DOOR_QTY           := NVL(L_CACHE_CMM_TRANSFER_RAW(I).DOOR_QTY,0);
          L_REC_CMM_TRANSFER.TOTAL_RETAIL       := NVL(L_CACHE_CMM_TRANSFER_RAW(I).TOTAL_RETAIL,0);
          L_REC_CMM_TRANSFER.TOTAL_COST         := NVL(L_CACHE_CMM_TRANSFER_RAW(I).TOTAL_COST,0);
          L_REC_CMM_TRANSFER.COUNTRY            := L_CACHE_CMM_TRANSFER_RAW(I).COUNTRY;
          L_REC_CMM_TRANSFER.SENDING_DC         := L_CACHE_CMM_TRANSFER_RAW(I).SENDING_DC;
          L_REC_CMM_TRANSFER.TRANSACTION_DATE   := L_CACHE_CMM_TRANSFER_RAW(I).TRANSACTION_DATE;

          L_REC_CMM_TRANSFER.STYLE_COLOR_SIZE_ID :=0;
          L_REC_CMM_TRANSFER.SENDING_LOC_ID      :=0;
          L_REC_CMM_TRANSFER.RECEIVING_LOC_ID    :=0;
          L_REC_CMM_TRANSFER.DATE_ID             :=0;
          L_REC_CMM_TRANSFER.TYPE_ID             :=0;
          L_REC_CMM_TRANSFER.START_DATE          :=TO_DATE('19000101','YYYYMMDD');
          L_REC_CMM_TRANSFER.RECEIVING_DATE      :=TO_DATE('99991231','YYYYMMDD');
          L_REC_CMM_TRANSFER.START_DT            :=19000101;
          L_REC_CMM_TRANSFER.RECEIVING_DT        :=99991231;

          L_REC_CMM_TRANSFER.LOG_DATE     := SYSDATE;
          L_REC_CMM_TRANSFER.UPLOAD_ID    := L_CACHE_CMM_TRANSFER_RAW(I).UPLOAD_ID;
          L_REC_CMM_TRANSFER.FILE_ROW_NUM := L_CACHE_CMM_TRANSFER_RAW(I).FILE_ROW_NUM;
          L_REC_CMM_TRANSFER.ERROR_ID     := 0;
          L_REC_CMM_TRANSFER.FIELD_VALUE  := '0';

          VALIDATE_CMM_TRANSFER(L_REC_CMM_TRANSFER.TRANS_BUSKEY);

          --1,Validate Measurement
          L_NNT_MEASURES := NNT_MEASURES(L_REC_CMM_TRANSFER.COST,
                                         L_REC_CMM_TRANSFER.RETAIL,
                                         L_REC_CMM_TRANSFER.DOOR_QTY,
                                         L_REC_CMM_TRANSFER.TOTAL_RETAIL,
                                         L_REC_CMM_TRANSFER.TOTAL_COST);
          VALIDATE_MEASURES(L_NNT_MEASURES);

          --2,Validate time dimension
          L_REC_DATE_ATTRS.YEAR             := L_REC_CMM_TRANSFER.CURRENT_YEAR;
          L_REC_DATE_ATTRS.MONTH            := L_REC_CMM_TRANSFER.CURRENT_MONTH;
          L_REC_DATE_ATTRS.WEEK             := L_REC_CMM_TRANSFER.CURRENT_WEEK;
          L_REC_DATE_ATTRS.DAY              := L_REC_CMM_TRANSFER.CURRENT_DAY;
          L_REC_DATE_ATTRS.TRANSACTION_DATE := L_REC_CMM_TRANSFER.TRANSACTION_DATE;
          VALIDATE_TIME(L_REC_DATE_ATTRS, L_REC_CMM_TRANSFER.DATE_ID);

          --3,Validate style dimension
          L_REC_STYLE_ATTRS.CORPORATE_DIVISION := L_REC_CMM_TRANSFER.CORPORATE_DIVISION;
          L_REC_STYLE_ATTRS.UPC                := L_REC_CMM_TRANSFER.UPC;
          L_REC_STYLE_ATTRS.VENDOR_REF_NUMBER  := L_REC_CMM_TRANSFER.VENDOR_REF_NUMBER;
          L_REC_STYLE_ATTRS.STYLE_NUMBER       := L_REC_CMM_TRANSFER.STYLE_NUMBER;
          L_REC_STYLE_ATTRS.COLOR_CODE         := L_REC_CMM_TRANSFER.COLOR_CODE;
          L_REC_STYLE_ATTRS.SIZE_CODE          := L_REC_CMM_TRANSFER.SIZE_CODE;
          L_REC_STYLE_ATTRS.SIZE_DESC1         := L_REC_CMM_TRANSFER.SIZE_DESC1;
          L_REC_STYLE_ATTRS.SIZE_DESC2         := L_REC_CMM_TRANSFER.SIZE_DESC2;
          VALIDATE_STYLE(L_REC_STYLE_ATTRS,
                         L_REC_CMM_TRANSFER.STYLE_COLOR_SIZE_ID);

          --4,Validate sending loc
          L_REC_LOC_ATTRS.COUNTRY  := L_REC_CMM_TRANSFER.COUNTRY;
          L_REC_LOC_ATTRS.DC       := L_REC_CMM_TRANSFER.SENDING_DC;
          L_REC_LOC_ATTRS.DOOR_NUM := L_REC_CMM_TRANSFER.SENDING_DOOR_NUM;
          VALIDATE_SENDING_LOC(L_REC_LOC_ATTRS,
                               L_REC_CMM_TRANSFER.SENDING_LOC_ID);

          --5,Validate receiving loc
          L_REC_LOC_ATTRS.COUNTRY  := NULL;
          L_REC_LOC_ATTRS.DC       := NULL;
          L_REC_LOC_ATTRS.DOOR_NUM := L_REC_CMM_TRANSFER.RECEIVING_DOOR_NUM;
          VALIDATE_RECEIVING_LOC(L_REC_LOC_ATTRS,
                                 L_REC_CMM_TRANSFER.RECEIVING_LOC_ID);

          --6,Validate if sending door num and receiving door num are the same
          VALIDATE_SENDING_RECEIVING_LOC(L_REC_CMM_TRANSFER.SENDING_LOC_ID,
                                         L_REC_CMM_TRANSFER.RECEIVING_LOC_ID);

          --7,Validate the comparison between start date , transaction date, receiving date
          VALIDATE_MISC_DATES(TO_DATE(TO_CHAR(L_REC_CMM_TRANSFER.DATE_ID),
                                      'YYYYMMDD'),
                              L_CACHE_CMM_TRANSFER_RAW(I).START_DATE,
                              L_CACHE_CMM_TRANSFER_RAW(I).RECEIVING_DATE,
                              L_REC_CMM_TRANSFER.START_DATE,
                              L_REC_CMM_TRANSFER.RECEIVING_DATE,
                              L_REC_CMM_TRANSFER.TYPE_ID);

          L_REC_CMM_TRANSFER.START_DT     := TO_NUMBER(TO_CHAR(L_REC_CMM_TRANSFER.START_DATE,'YYYYMMDD'));
          L_REC_CMM_TRANSFER.RECEIVING_DT := TO_NUMBER(TO_CHAR(L_REC_CMM_TRANSFER.RECEIVING_DATE,'YYYYMMDD'));

          PIPE ROW(L_REC_CMM_TRANSFER);

        EXCEPTION
          WHEN OTHERS THEN
            BEGIN
              L_REC_CMM_TRANSFER.FIELD_VALUE := REGEXP_REPLACE(SQLERRM,
                                                               'ORA-[[:digit:]]{5}: ',
                                                               '');
              L_REC_CMM_TRANSFER.ERROR_ID    := L_CACHE_ERROR(SQLCODE);
              PIPE ROW(L_REC_CMM_TRANSFER);
            END;
        END;
      END LOOP;

    END LOOP;

  END RESULTSET_CMMTRANSFER;

  PROCEDURE POPULATE_FACT_CMM_TRANSFER IS
  BEGIN

    FOR ITEM IN (SELECT DISTINCT F.DATE_ID, S.D_DEPT_ID
                   FROM FACT_CMM_TRANSFER_STEP2_TEMP F
                  INNER JOIN V_DIM_STYLE_PRIMARY_SIZE S
                     ON F.STYLE_COLOR_SIZE_ID = S.STYLE_COLOR_SIZE_ID) LOOP
      DELETE FROM FACT_CMM_TRANSFER T
       WHERE EXISTS (SELECT 1
                FROM V_DIM_STYLE_PRIMARY_SIZE S
               WHERE T.STYLE_COLOR_SIZE_ID = S.STYLE_COLOR_SIZE_ID
                 AND S.D_DEPT_ID = ITEM.D_DEPT_ID)
         AND T.DATE_ID = ITEM.DATE_ID;
    END LOOP;

    INSERT INTO FACT_CMM_TRANSFER T
      (TRANS_BUSKEY,
       STYLE_COLOR_SIZE_ID,
       SENDING_LOC_ID,
       RECEIVING_LOC_ID,
       TYPE_ID,
       DATE_ID,
       START_DATE,
       RECEIVING_DATE,
       START_DT,
       RECEIVING_DT,
       DOOR_QTY,
       COST,
       RETAIL,
       TOTAL_RETAIL,
       TOTAL_COST)
      SELECT S.TRANS_BUSKEY,
             S.STYLE_COLOR_SIZE_ID,
             S.SENDING_LOC_ID,
             S.RECEIVING_LOC_ID,
             S.TYPE_ID,
             S.DATE_ID,
             S.START_DATE,
             S.RECEIVING_DATE,
             S.START_DT,
             S.RECEIVING_DT,
             S.DOOR_QTY,
             S.COST,
             S.RETAIL,
             S.TOTAL_RETAIL,
             S.TOTAL_COST
        FROM FACT_CMM_TRANSFER_STEP2_TEMP S;

  END POPULATE_FACT_CMM_TRANSFER;

  PROCEDURE POPULATE_CMMTRANSFER(P_UPLOAD_ID CMM_TRANSFER_RAW.UPLOAD_ID%TYPE) IS
    L_ROWCOUNT    PLS_INTEGER;
    L_FAILURE_NUM PLS_INTEGER;
    L_NNT_IDS     NNT_IDS := NNT_IDS();

  BEGIN

    INSERT INTO DIM_UPLOAD_TRACKING
      (UPLOAD_ID, UPLOAD_TYPE, AFFECTED_IDS, SUCCEED_NUM, FAILURE_NUM)
    VALUES
      (P_UPLOAD_ID, 'CMM_TRANSFER', NULL, 0, 0);

    EXECUTE IMMEDIATE '
    INSERT
    ALL WHEN ERROR_ID = 0 THEN INTO FACT_CMM_TRANSFER_STEP1_TEMP(
      TRANS_BUSKEY    ,
      STYLE_COLOR_SIZE_ID,
      SENDING_LOC_ID     ,
      RECEIVING_LOC_ID   ,
      TYPE_ID            ,
      DATE_ID            ,
      START_DATE         ,
      START_DT           ,
      RECEIVING_DATE     ,
      RECEIVING_DT       ,
      DOOR_QTY           ,
      COST               ,
      RETAIL             ,
      TOTAL_RETAIL       ,
      TOTAL_COST         ,
      FILE_ROW_NUM)
    VALUES(
      TRANS_BUSKEY    ,
      STYLE_COLOR_SIZE_ID,
      SENDING_LOC_ID     ,
      RECEIVING_LOC_ID   ,
      TYPE_ID            ,
      DATE_ID            ,
      START_DATE         ,
      START_DT           ,
      RECEIVING_DATE     ,
      RECEIVING_DT       ,
      DOOR_QTY           ,
      COST               ,
      RETAIL             ,
      TOTAL_RETAIL       ,
      TOTAL_COST         ,
      FILE_ROW_NUM)
   ELSE INTO FACT_ERROR_LOG PARTITION FOR(' ||
                      TO_CHAR(P_UPLOAD_ID) || ')
      (DATE_ID,
      UPLOAD_ID,
      ERROR_ID,
      FIELD_VALUE,
      LOG_DATE,
      FILE_ROW_NUM)
    VALUES
      (TO_NUMBER(TO_CHAR(LOG_DATE,''YYYYMMDD'')),
      UPLOAD_ID,
      ERROR_ID,
      FIELD_VALUE,
      LOG_DATE,
      FILE_ROW_NUM)
      SELECT /*+PARALLEL*/*
        FROM TABLE(CMMTRANSFER_POPULATE_PACK.RESULTSET_CMMTRANSFER(CURSOR
                                                         (SELECT *
                                                            FROM CMM_TRANSFER_RAW P
                                                           WHERE UPLOAD_ID=' ||
                      TO_CHAR(P_UPLOAD_ID) || ')))';

    L_ROWCOUNT := SQL%ROWCOUNT;

    SELECT COUNT(*)
      INTO L_FAILURE_NUM
      FROM FACT_ERROR_LOG
     WHERE UPLOAD_ID = P_UPLOAD_ID;

    SELECT /*+PARALLEL(P)*/
     SET(CAST(COLLECT(D.DATE_ID) AS NNT_IDS))
      INTO L_NNT_IDS
      FROM CMM_TRANSFER_RAW P
     INNER JOIN DIM_DATE_DAY D
        ON NVL(P.TRANSACTION_DATE,
               P.CURRENT_YEAR * 10000 + P.CURRENT_MONTH * 100 +
               P.CURRENT_DAY) = TO_CHAR(D.DATE_ID)
     WHERE UPLOAD_ID = P_UPLOAD_ID;

    UPDATE DIM_UPLOAD_TRACKING
       SET AFFECTED_IDS = L_NNT_IDS,
           SUCCEED_NUM  = L_ROWCOUNT - L_FAILURE_NUM,
           FAILURE_NUM  = L_FAILURE_NUM
     WHERE UPLOAD_ID = P_UPLOAD_ID;

    INSERT INTO FACT_CMM_TRANSFER_STEP2_TEMP
      (TRANS_BUSKEY,
       STYLE_COLOR_SIZE_ID,
       SENDING_LOC_ID,
       RECEIVING_LOC_ID,
       TYPE_ID,
       DATE_ID,
       START_DATE,
       RECEIVING_DATE,
       START_DT,
       RECEIVING_DT,
       DOOR_QTY,
       COST,
       RETAIL,
       TOTAL_RETAIL,
       TOTAL_COST)
      SELECT TRANS_BUSKEY,
             STYLE_COLOR_SIZE_ID,
             SENDING_LOC_ID,
             RECEIVING_LOC_ID,
             TYPE_ID,
             DATE_ID,
             START_DATE,
             RECEIVING_DATE,
             START_DT,
             RECEIVING_DT,
             SUM(DOOR_QTY) DOOR_QTY,
             MAX(COST) KEEP(DENSE_RANK LAST ORDER BY FILE_ROW_NUM) COST,
             MAX(RETAIL) KEEP(DENSE_RANK LAST ORDER BY FILE_ROW_NUM) RETRAIL,
             SUM(TOTAL_RETAIL) TOTAL_RETAIL,
             SUM(TOTAL_COST) TOTAL_COST
        FROM FACT_CMM_TRANSFER_STEP1_TEMP
       GROUP BY TRANS_BUSKEY,
                STYLE_COLOR_SIZE_ID,
                SENDING_LOC_ID,
                RECEIVING_LOC_ID,
                TYPE_ID,
                DATE_ID,
                START_DATE,
                RECEIVING_DATE,
                START_DT,
                RECEIVING_DT;

    POPULATE_FACT_CMM_TRANSFER;

    COMMIT;

    EXECUTE IMMEDIATE 'ALTER TABLE CMM_TRANSFER_RAW TRUNCATE PARTITION FOR(' ||
                      TO_CHAR(P_UPLOAD_ID) || ')';

  END POPULATE_CMMTRANSFER;

BEGIN

  SELECT S.ERROR_ID ID, S.ERROR_CODE SOURCE_BUSKEY
    BULK COLLECT
    INTO L_TEMP_CACHE
    FROM DIM_ERROR S;

  FOR J IN L_TEMP_CACHE.FIRST .. L_TEMP_CACHE.LAST LOOP
    L_CACHE_ERROR(L_TEMP_CACHE(J).SOURCE_BUSKEY) := L_TEMP_CACHE(J).ID;
  END LOOP;

  SELECT S.STORE_LOC_ID ID, S.SOURCE_BUSKEY SOURCE_BUSKEY
    BULK COLLECT
    INTO L_TEMP_CACHE
    FROM DIM_STORE_LOC S;

  FOR J IN L_TEMP_CACHE.FIRST .. L_TEMP_CACHE.LAST LOOP
    L_CACHE_STORE_LOC(L_TEMP_CACHE(J).SOURCE_BUSKEY) := L_TEMP_CACHE(J).ID;
  END LOOP;

  SELECT S.STYLE_COLOR_SIZE_ID ID, S.SOURCE_BUSKEY SOURCE_BUSKEY
    BULK COLLECT
    INTO L_TEMP_CACHE
    FROM DIM_STYLE_COLOR_SIZE S;

  FOR J IN L_TEMP_CACHE.FIRST .. L_TEMP_CACHE.LAST LOOP
    L_CACHE_STYLE_COLOR_SIZE(L_TEMP_CACHE(J).SOURCE_BUSKEY) := L_TEMP_CACHE(J).ID;
  END LOOP;

  SELECT S.STYLE_COLOR_ID ID, S.SOURCE_BUSKEY SOURCE_BUSKEY
    BULK COLLECT
    INTO L_TEMP_CACHE
    FROM DIM_STYLE_COLOR S;

  FOR J IN L_TEMP_CACHE.FIRST .. L_TEMP_CACHE.LAST LOOP
    L_CACHE_STYLE_COLOR(L_TEMP_CACHE(J).SOURCE_BUSKEY) := L_TEMP_CACHE(J).ID;
  END LOOP;

  SELECT S.STYLE_ID ID, S.SOURCE_BUSKEY SOURCE_BUSKEY
    BULK COLLECT
    INTO L_TEMP_CACHE
    FROM DIM_STYLE S;

  FOR J IN L_TEMP_CACHE.FIRST .. L_TEMP_CACHE.LAST LOOP
    L_CACHE_STYLE(L_TEMP_CACHE(J).SOURCE_BUSKEY) := L_TEMP_CACHE(J).ID;
  END LOOP;

  SELECT V.VENDOR_ID ID, V.SOURCE_BUSKEY
    BULK COLLECT
    INTO L_TEMP_CACHE
    FROM DIM_VENDOR V;

  FOR J IN L_TEMP_CACHE.FIRST .. L_TEMP_CACHE.LAST LOOP
    L_CACHE_VENDOR(L_TEMP_CACHE(J).SOURCE_BUSKEY) := L_TEMP_CACHE(J).ID;
  END LOOP;

  FOR J IN L_TEMP_CACHE.FIRST .. L_TEMP_CACHE.LAST LOOP
    L_CACHE_STYLE(L_TEMP_CACHE(J).SOURCE_BUSKEY) := L_TEMP_CACHE(J).ID;
  END LOOP;

  SELECT S.DATE_ID ID, TO_CHAR(S.DATE_ID) SOURCE_BUSKEY
    BULK COLLECT
    INTO L_TEMP_CACHE
    FROM DIM_DATE_DAY S;

  FOR J IN L_TEMP_CACHE.FIRST .. L_TEMP_CACHE.LAST LOOP
    L_CACHE_DATE(L_TEMP_CACHE(J).SOURCE_BUSKEY) := L_TEMP_CACHE(J).ID;
  END LOOP;

  SELECT S.SMONTH_ID ID, TO_CHAR(S.SMONTH_ID) SOURCE_BUSKEY
    BULK COLLECT
    INTO L_TEMP_CACHE
    FROM DIM_DATE_SMONTH S;

  FOR J IN L_TEMP_CACHE.FIRST .. L_TEMP_CACHE.LAST LOOP
    L_CACHE_MONTH(L_TEMP_CACHE(J).SOURCE_BUSKEY) := L_TEMP_CACHE(J).ID;
  END LOOP;

  SELECT S.SMYEAR_ID ID, TO_CHAR(S.SMYEAR_ID) SOURCE_BUSKEY
    BULK COLLECT
    INTO L_TEMP_CACHE
    FROM DIM_DATE_SMYEAR S;

  FOR J IN L_TEMP_CACHE.FIRST .. L_TEMP_CACHE.LAST LOOP
    L_CACHE_YEAR(L_TEMP_CACHE(J).SOURCE_BUSKEY) := L_TEMP_CACHE(J).ID;
  END LOOP;

  SELECT S.COMMON_ID ID, S.COMMON_VALUE SOURCE_BUSKEY
    BULK COLLECT
    INTO L_TEMP_CACHE
    FROM DIM_COMMON S
   WHERE S.COMMON_CODE IN
         ('CMMTRANSFER_TYPE');

  FOR J IN L_TEMP_CACHE.FIRST .. L_TEMP_CACHE.LAST LOOP
    L_CACHE_TYPE(L_TEMP_CACHE(J).SOURCE_BUSKEY) := L_TEMP_CACHE(J).ID;
  END LOOP;

END CMMTRANSFER_POPULATE_PACK;
/
