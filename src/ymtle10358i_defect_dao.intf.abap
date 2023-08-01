INTERFACE ymtle10358i_defect_dao
  PUBLIC .


  CONSTANTS gc_defcat_damaged_rack TYPE ymtle10358de_defectcategory VALUE 'R' ##NO_TEXT.
  CONSTANTS gc_defcat_damaged_label TYPE ymtle10358de_defectcategory VALUE 'L' ##NO_TEXT.
  CONSTANTS gc_defcat_inv_discrepancy TYPE ymtle10358de_defectcategory VALUE 'D' ##NO_TEXT.

  METHODS user_data_get
    IMPORTING
      !iv_uname       TYPE xubname
    RETURNING
      VALUE(rt_xuser) TYPE lrf_wkqu_t1
    RAISING
      ycx_agco_globcore_exception .
  METHODS enqueue_number_range
    IMPORTING
      !iv_object TYPE nrobj
    RAISING
      ycx_agco_globcore_exception .
  METHODS dequeue_number_range
    IMPORTING
      !iv_object TYPE nrobj
    RAISING
      ycx_agco_globcore_exception .
  METHODS get_defect_id
    IMPORTING
      !iv_object          TYPE nrobj
      !iv_range_nr        TYPE nrnr
    RETURNING
      VALUE(rv_defect_id) TYPE ymtle10358de_defectnumber
    RAISING
      ycx_agco_globcore_exception .
  METHODS save_defect
    IMPORTING
      !is_defect TYPE ymtle10358s_defect
    RAISING
      ycx_agco_globcore_exception .
  METHODS save_defects_from_table
    IMPORTING
      !it_defects TYPE ymtle10358tt_defect
    RAISING
      ycx_agco_globcore_exception .
  METHODS get_defect_by_id
    IMPORTING
      !iv_defect_nr    TYPE ymtle10358de_defectnumber
    RETURNING
      VALUE(rs_defect) TYPE ymtle10358s_defect
    RAISING
      ycx_agco_globcore_exception .
  METHODS get_defects_by_category
    IMPORTING
      !iv_defcat        TYPE ymtle10358de_defectcategory
    RETURNING
      VALUE(rt_defects) TYPE ymtle10358tt_defect
    RAISING
      ycx_agco_globcore_exception .
  METHODS get_defects_by_status
    IMPORTING
      !iv_status        TYPE ymtle10358de_status
    RETURNING
      VALUE(rt_defects) TYPE ymtle10358tt_defect
    RAISING
      ycx_agco_globcore_exception .
  METHODS get_email_lst
    IMPORTING
      !it_lgnum           TYPE shp_lgnum_range_t
      !it_lgtyp           TYPE ymtlr4503tt_lgtyp_rng
      !it_defcat          TYPE ymtle10358tt_defcat_rng
    RETURNING
      VALUE(rt_email_lst) TYPE ymtle10358tt_email_lst
    RAISING
      ycx_agco_globcore_exception .
  METHODS get_recipients
    IMPORTING
      !is_parameters       TYPE ymtle10358s_param
    RETURNING
      VALUE(rt_recipients) TYPE bcsy_smtpa
    RAISING
      ycx_agco_globcore_exception .
  METHODS get_recipients_by_id
    IMPORTING
      !iv_email_list_id    TYPE ymtle10358de_email_list_id
    RETURNING
      VALUE(rt_recipients) TYPE bcsy_smtpa
    RAISING
      ycx_agco_globcore_exception .
  METHODS user_get_addsmtp
    IMPORTING
      iv_username          TYPE xubname
    RETURNING
      VALUE(rt_recipients) TYPE bcsy_smtpa
    RAISING
      ycx_agco_globcore_exception.
  METHODS bal_log_create
    IMPORTING
      is_bal_s_log  TYPE bal_s_log
    EXPORTING
      ev_log_handle TYPE balloghndl
    RAISING
      ycx_agco_globcore_exception.
  METHODS bal_log_msg_add
    IMPORTING
      iv_log_handle     TYPE balloghndl
      is_s_msg          TYPE bal_s_msg
    EXPORTING
      ev_msg_was_logged TYPE boolean
    RAISING
      ycx_agco_globcore_exception.
  METHODS bal_log_msg_add_free_text
    IMPORTING
      iv_log_handle     TYPE balloghndl
      iv_msgty          TYPE symsgty
      iv_text           TYPE c
    EXPORTING
      ev_msg_was_logged TYPE boolean
    RAISING
      ycx_agco_globcore_exception.
  METHODS bal_dsp_profile_no_tree_get
    EXPORTING
      es_display_profile TYPE bal_s_prof.
  METHODS bal_dsp_log_textform
    IMPORTING
      iv_log_handle   TYPE balloghndl OPTIONAL
      it_log_handle   TYPE bal_t_logh OPTIONAL
    EXPORTING
      ev_spool_number TYPE syspono
    RAISING
      ycx_agco_globcore_exception.
  METHODS bal_dsp_log_display
    IMPORTING
      is_display_profile TYPE bal_s_prof
      it_log_handle      TYPE bal_t_logh
    RAISING
      ycx_agco_globcore_exception.
  METHODS get_domain_value
    IMPORTING iv_domname       TYPE domname
              iv_domvalue      TYPE domvalue_l
    RETURNING VALUE(rv_ddtext) TYPE val_text
    RAISING   ycx_agco_globcore_exception.
ENDINTERFACE.
