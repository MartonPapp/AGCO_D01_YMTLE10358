*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: YMTLV_EMAIL_REC.................................*
TABLES: YMTLV_EMAIL_REC, *YMTLV_EMAIL_REC. "view work areas
CONTROLS: TCTRL_YMTLV_EMAIL_REC
TYPE TABLEVIEW USING SCREEN '0100'.
DATA: BEGIN OF STATUS_YMTLV_EMAIL_REC. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_YMTLV_EMAIL_REC.
* Table for entries selected to show on screen
DATA: BEGIN OF YMTLV_EMAIL_REC_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE YMTLV_EMAIL_REC.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YMTLV_EMAIL_REC_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF YMTLV_EMAIL_REC_TOTAL OCCURS 0010.
INCLUDE STRUCTURE YMTLV_EMAIL_REC.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YMTLV_EMAIL_REC_TOTAL.

*.........table declarations:.................................*
TABLES: YMTLT_EMAIL_REC                .
