*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: YMTLV_EMAIL_LST.................................*
TABLES: YMTLV_EMAIL_LST, *YMTLV_EMAIL_LST. "view work areas
CONTROLS: TCTRL_YMTLV_EMAIL_LST
TYPE TABLEVIEW USING SCREEN '0100'.
DATA: BEGIN OF STATUS_YMTLV_EMAIL_LST. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_YMTLV_EMAIL_LST.
* Table for entries selected to show on screen
DATA: BEGIN OF YMTLV_EMAIL_LST_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE YMTLV_EMAIL_LST.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YMTLV_EMAIL_LST_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF YMTLV_EMAIL_LST_TOTAL OCCURS 0010.
INCLUDE STRUCTURE YMTLV_EMAIL_LST.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YMTLV_EMAIL_LST_TOTAL.

*.........table declarations:.................................*
TABLES: YMTLT_EMAIL_LST                .
