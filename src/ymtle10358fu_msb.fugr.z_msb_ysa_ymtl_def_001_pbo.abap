FUNCTION Z_MSB_YSA_YMTL_DEF_001_PBO.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_APPL) TYPE  /MOBISYS/MSB_APPL OPTIONAL
*"     VALUE(I_DEVICEID) TYPE  /MOBISYS/MSB_DEVICEID OPTIONAL
*"     REFERENCE(I_HELPER) TYPE REF TO  /MOBISYS/CL_MSB_RTS OPTIONAL
*"     VALUE(I_MASK) TYPE  /MOBISYS/MSB_MASKID OPTIONAL
*"     VALUE(I_MSGNO) TYPE  MSGNO OPTIONAL
*"     VALUE(I_MSGTXT) TYPE  MSGTX OPTIONAL
*"     VALUE(I_MSGTYP) TYPE  MSGTY OPTIONAL
*"     VALUE(I_SESSION) TYPE  /MOBISYS/MSB_SESSION OPTIONAL
*"     VALUE(I_TCODE) TYPE  /MOBISYS/MSB_TCODE OPTIONAL
*"     VALUE(I_USER) TYPE  SYST-UNAME OPTIONAL
*"  EXPORTING
*"     VALUE(E_MSGNO) TYPE  MSGNO
*"     VALUE(E_MSGTXT) TYPE  MSGTX
*"     VALUE(E_MSGTYP) TYPE  MSGTY
*"  TABLES
*"      COMPONENTS STRUCTURE  /MOBISYS/MSB_STR_COMPONENT OPTIONAL
*"      VALUES STRUCTURE  /MOBISYS/MSB_STR_VALUE_IN OPTIONAL
*"      VLIST STRUCTURE  /MOBISYS/MSBVLIS OPTIONAL
*"  CHANGING
*"     REFERENCE(C_APPDATA) TYPE  /MOBISYS/MSB_APPDATA OPTIONAL
*"--------------------------------------------------------------------
**** PBO- generated by MSB 28.11.2022 ***
**** DO NOT CHANGE / CHANGES WILL BE OVERWRITTEN ***
*
INCLUDE Z_MSB_YSA_YMTL_DEF_PBO_ENTRY .
e_msgtyp = i_msgtyp.
e_msgno  = i_msgno.
e_msgtxt = i_msgtxt.



* DATA EDT_LAGP_LGPLA TYPE LGPLA *.
* DATA EDT_MARA_MATNR TYPE MATNR *.
* DATA EDT_T301_LGTYP TYPE LGTYP *.
* DATA RBT_DAMGD_LABEL TYPE CHAR1 *.
* DATA RBT_DAMGD_RACK TYPE CHAR1 *.
* DATA RBT_INV_DISC TYPE CHAR1 *.


* >>> Begin of customer own coding >>>


* <<< End of customer own coding   <<<



**** PBO- generated by MSB 28.11.2022 ***
**** DO NOT CHANGE / CHANGES WILL BE OVERWRITTEN ***
*
INCLUDE Z_MSB_YSA_YMTL_DEF_PBO_EXIT .





ENDFUNCTION.
