*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
types: tty_email_lst type standard table of YMTLT_EMAIL_LST with key lgnum lgtyp defcat email_list_id,
       tty_email_rec type standard table of ymtlt_email_rec with key email_list_id smtp_addr.
