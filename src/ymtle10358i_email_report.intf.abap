INTERFACE ymtle10358i_email_report
  PUBLIC .
  METHODS: send_emails
    IMPORTING iv_status        TYPE ymtle10358de_status
    EXPORTING et_bapiret2      TYPE bapiret2_tt
    RETURNING VALUE(rt_result) TYPE bcsy_text
    RAISING   ycx_agco_globcore_exception.
  METHODS: bal_log
    IMPORTING it_msg      TYPE bcsy_text OPTIONAL
              it_bapiret2 TYPE bapiret2_tt OPTIONAL
    RAISING   ycx_agco_globcore_exception.
ENDINTERFACE.
