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

DATA: ls_stat TYPE ymtle10358de_status.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
SELECT-OPTIONS: s_stat FOR ls_stat NO INTERVALS.
SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.
  lcl_report=>initialization( ).
