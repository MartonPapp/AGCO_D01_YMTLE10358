*----------------------------------------------------------------------*
* Author: Marton Papp
* Date:   2022.03.02.
* RICEFW OBJECT: MTL.E.10358
* CR/IN: CHG0083294 - HES project
*----------------------------------------------------------------------*
* Short description:
* Maintenance for e-mail lists
*----------------------------------------------------------------------*
* Changes
* Index Name         Date        Short description
*----------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECT-OPTIONS: s_wh FOR ymtlt_email_lst-lgnum,
                s_srty FOR ymtlt_email_lst-lgtyp,
                s_defcat FOR ymtlt_email_lst-defcat.
SELECTION-SCREEN END OF BLOCK b1.
