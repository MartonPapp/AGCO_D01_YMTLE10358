*----------------------------------------------------------------------*
* Author: Marton Papp
* Date:   2022.03.02.
* RICEFW OBJECT: MTL.E.10358
* CR/IN: CHG0083294 - HES project
*----------------------------------------------------------------------*
* Short description:
* Background job for e-mail sending
*----------------------------------------------------------------------*
* Changes
* Index Name         Date        Short description
*----------------------------------------------------------------------*
REPORT ymtle10358r_email_notif.
TYPE-POOLS sscr.

INCLUDE ymtle10358r_email_notif_cl.
INCLUDE ymtle10358r_email_notif_sel.

START-OF-SELECTION.
  NEW lcl_report( s_stat[] )->start_of_selection( ).
