*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: YMTLV_DEFECT....................................*
TABLES: YMTLV_DEFECT, *YMTLV_DEFECT. "view work areas
CONTROLS: TCTRL_YMTLV_DEFECT
TYPE TABLEVIEW USING SCREEN '0100'.
DATA: BEGIN OF STATUS_YMTLV_DEFECT. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_YMTLV_DEFECT.
* Table for entries selected to show on screen
DATA: BEGIN OF YMTLV_DEFECT_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE YMTLV_DEFECT.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YMTLV_DEFECT_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF YMTLV_DEFECT_TOTAL OCCURS 0010.
INCLUDE STRUCTURE YMTLV_DEFECT.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YMTLV_DEFECT_TOTAL.

*.........table declarations:.................................*
TABLES: YMTLT_DEFECT                   .
