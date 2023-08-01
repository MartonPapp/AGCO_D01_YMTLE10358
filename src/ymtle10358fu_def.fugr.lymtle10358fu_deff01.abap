*----------------------------------------------------------------------*
***INCLUDE LYMTLE10358FU_DEFF01.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* Author: Marton Papp
* Date:   2022.02.22.
* CR/IN: CHG0083294 - HES project
*----------------------------------------------------------------------*
* Short description:
* Non-material defect creation
*----------------------------------------------------------------------*
* Changes
* Index Name         Date        Short description
*----------------------------------------------------------------------*
form Y_UPDATE.
  data: lo_defcat type ref to ymtle10358i_defect_category.
  data: lo_defect_dao type ref to ymtle10358i_defect_dao.
  data: ls_defect type ymtle10358s_defect,
        lt_recipients type BCSY_SMTPA.
  data: lt_bapiret2 type bapiret2_tt.

  lo_defcat = new ymtle10358cl_defect_category( ).
  lo_defect_dao = new ymtle10358cl_defect_dao( ).
  field-symbols: <ls_field> type any.
  loop at total.
    assign component 'STATUS' of structure <vim_total_struc> to <ls_field>.
    if sy-subrc eq 0.
      if <ls_field> eq 'CLOSED'.
        assign component 'CLOSEDBY' of structure <vim_total_struc> to <ls_field>.
        if sy-subrc eq 0.
          <ls_field> = sy-uname.
        endif.
        assign component 'CLOSED_DATE' of structure <vim_total_struc> to <ls_field>.
        if sy-subrc eq 0.
          <ls_field> = sy-datum.
        endif.
        assign component 'CLOSED_TIME' of structure <vim_total_struc> to <ls_field>.
        if sy-subrc eq 0.
          <ls_field> = sy-uzeit.
        endif.
        assign component 'EMAIL_CLOSED' of structure <vim_total_struc> to <ls_field>.
        if sy-subrc eq 0.
          <ls_field> = abap_true.
        endif.
      endif.
    endif.
    read table extract with key <vim_xtotal_key>.
    if sy-subrc eq 0.
      extract = total.
      modify extract index sy-tabix.
    endif.
    if total is not initial.
      modify total.
    endif.

    if <action> eq AENDERN.

        ls_defect = corresponding #( total ).

*   Any defect gets closed e-mail notification should be sent
        if ls_defect-defcat eq 'D'        "Inventory Discrepancy
        or ls_defect-status eq 'CLOSED' .
          try.
            data(ls_parameters) = corresponding ymtle10358s_param( ls_defect mapping uname = ernam  ).
            lt_recipients = lo_defect_dao->get_recipients( ls_parameters ).
*       If status is closed e-mail notification to the user, who created the defect
            if ls_defect-status eq 'CLOSED'.
              data(lt_recipients_user) = lo_defect_dao->user_get_addsmtp( ls_defect-ernam ).
              if lt_recipients_user is not initial.
                lt_recipients = value #( base lt_recipients
                                          for ls_recip in lt_recipients_user
                                          ( ls_recip ) ).
              else.
                 lt_bapiret2 = value #( base lt_bapiret2
                  ( type = 'W' id = 'YMTLE10358' number = '014' message_v1 = sy-uname message_v2 = '' message_v3 = '' message_v4 = '' ) ).
              endif.
            endif.
            lo_defcat->email_notification( exporting is_defect     = ls_defect
                                                     it_recipients = lt_recipients ).
          catch ycx_agco_globcore_exception.
            lt_bapiret2 = value #( base lt_bapiret2
                ( type = 'W' id = sy-msgid number = sy-msgno message_v1 = sy-msgv1 message_v2 = sy-msgv2 message_v3 = sy-msgv3 message_v4 = sy-msgv4 ) ).
          endtry.
        endif.
    endif.
  endloop.
  if lt_bapiret2 is not initial.
    try.
      append value #( type = 'S' id = 'YMTLE10358' number = '013' message_v1 = '' message_v2 = '' message_v3 = ''  message_v4 = '' )  to lt_bapiret2.
      new ymtle10358cl_email_report( )->bal_log( exporting it_bapiret2 = lt_bapiret2 ).
    catch ycx_agco_globcore_exception.
       MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endtry.
  endif.
endform.
