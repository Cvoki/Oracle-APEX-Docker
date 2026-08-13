-- ------------------------------------------------------------------
-- Pravljenje APEX radnog prostora nad šemom RAZVOJ.
-- Pokreće se RUČNO, kao SYS, tek kad je APEX instaliran:
--
--   docker exec -it oracle-db sqlplus / as sysdba @/tmp/apex-workspace.sql
-- ------------------------------------------------------------------
ALTER SESSION SET CONTAINER = FREEPDB1;

DECLARE
  l_workspace_id NUMBER;
BEGIN
  APEX_INSTANCE_ADMIN.ADD_WORKSPACE(
    p_workspace_id    => NULL,
    p_workspace       => 'RAZVOJ',
    p_primary_schema  => 'RAZVOJ',
    p_additional_schemas => NULL);

  APEX_UTIL.SET_WORKSPACE(p_workspace => 'RAZVOJ');

  APEX_UTIL.CREATE_USER(
    p_user_name                    => 'ADMIN',
    p_email_address                => 'admin@primer.local',
    p_web_password                 => 'Apex_2026!',
    p_developer_privs              => 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL',
    p_change_password_on_first_use => 'N');

  COMMIT;
END;
/

PROMPT Radni prostor RAZVOJ napravljen. Prijava: ADMIN / Apex_2026!
