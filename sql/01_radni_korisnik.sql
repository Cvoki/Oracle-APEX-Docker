-- ------------------------------------------------------------------
-- Radni korisnik za razvoj.
-- Pokreće se automatski pri PRVOM pravljenju baze.
-- ------------------------------------------------------------------
ALTER SESSION SET CONTAINER = FREEPDB1;

CREATE USER razvoj IDENTIFIED BY "Razvoj_2026"
  DEFAULT TABLESPACE users
  QUOTA UNLIMITED ON users;

GRANT CONNECT, RESOURCE TO razvoj;
GRANT CREATE VIEW, CREATE PROCEDURE, CREATE SEQUENCE, CREATE TRIGGER,
      CREATE MATERIALIZED VIEW, CREATE JOB, CREATE SYNONYM TO razvoj;

-- za rad sa mrežom (slanje mejlova, pozivanje REST servisa)
BEGIN
  DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
    host => '*',
    ace  => XS$ACE_TYPE(privilege_list => XS$NAME_LIST('connect','resolve'),
                        principal_name => 'RAZVOJ',
                        principal_type => XS_ACL.PTYPE_DB));
END;
/

PROMPT Korisnik RAZVOJ napravljen.
