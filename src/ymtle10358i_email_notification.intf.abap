INTERFACE ymtle10358i_email_notification
  PUBLIC .
  METHODS handle_email_event
    IMPORTING it_defects       TYPE ymtle10358tt_defect
              it_recipients    TYPE bcsy_smtpa
    RETURNING VALUE(rt_result) TYPE bcsy_text
    RAISING   ycx_agco_globcore_exception.
ENDINTERFACE.
