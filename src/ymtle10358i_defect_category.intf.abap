INTERFACE ymtle10358i_defect_category
  PUBLIC .
  METHODS check_radiobutton IMPORTING is_parameters TYPE ymtle10358s_def_cat_param
                            RETURNING VALUE(rv_res) TYPE abap_bool.
  METHODS create_defect IMPORTING is_parameters    TYPE ymtle10358s_def_cat_param
                                  it_values        TYPE  /mobisys/msb_str_value_in_t
                        RETURNING VALUE(rs_defect) TYPE ymtle10358s_defect
                        RAISING   ycx_agco_globcore_exception.
  METHODS email_notification IMPORTING is_defect     TYPE ymtle10358s_defect
                                       it_recipients TYPE bcsy_smtpa
                             RETURNING VALUE(rv_res) TYPE abap_bool
                             RAISING   ycx_agco_globcore_exception.
  METHODS set_putaway_block_status IMPORTING is_parameters TYPE ymtle10358s_def_cat_param
                                             it_values     TYPE  /mobisys/msb_str_value_in_t
                                   RETURNING VALUE(rv_res) TYPE abap_bool
                                   RAISING   ycx_agco_globcore_exception.
ENDINTERFACE.
