INTERFACE ymtle10358i_bcs_reduced
  PUBLIC .
  METHODS add_recipient IMPORTING io_recipient TYPE REF TO if_recipient_bcs
                        RAISING   cx_send_req_bcs.
  METHODS set_document IMPORTING io_document TYPE REF TO if_document_bcs
                       RAISING   cx_send_req_bcs.
  METHODS send RETURNING VALUE(rv_result) TYPE os_boolean
               RAISING   cx_send_req_bcs.
ENDINTERFACE.
