--
-- Direct grants needed to create banner_remove_user and banner_lock_user procedures
-- 
create user nd_dba_util_admin account lock profile nd_own_lock_default;

grant alter user                to nd_dba_util_admin with admin option;
grant create table              to nd_dba_util_admin;
grant create user               to nd_dba_util_admin;
grant drop user                 to nd_dba_util_admin;
grant grant any role            to nd_dba_util_admin;
grant unlimited tablespace      to nd_dba_util_admin with admin option;

grant select, insert, update, delete on bansecr.gtvclas   to nd_dba_util_admin with grant option;
grant select, insert, update, delete on bansecr.guraobj   to nd_dba_util_admin with grant option;
grant select, insert, update, delete on bansecr.gurucls   to nd_dba_util_admin with grant option;
grant select, insert, update, delete on bansecr.guruobj   to nd_dba_util_admin with grant option;
grant select, insert, update, delete on fimsmgr.fobprof   to nd_dba_util_admin with grant option;
grant select, insert, update, delete on fimsmgr.forusfn   to nd_dba_util_admin with grant option;
grant select, insert, update, delete on fimsmgr.forusor   to nd_dba_util_admin with grant option;
grant select, insert, update, delete on general.gobeacc   to nd_dba_util_admin with grant option;
grant select, insert, update, delete on general.gubobjs   to nd_dba_util_admin with grant option;
grant select, insert, update, delete on ndfiadmin.fzbzfop to nd_dba_util_admin with grant option;
grant select, insert, update, delete on ndfiadmin.zownfop to nd_dba_util_admin with grant option;

grant select on sys.dba_tab_privs  to nd_dba_util_admin with grant option;
grant select on sys.dba_col_privs  to nd_dba_util_admin with grant option;
grant select on sys.dba_role_privs to nd_dba_util_admin with grant option;
grant select on sys.dba_sys_privs  to nd_dba_util_admin with grant option;
grant select on sys.dba_users      to nd_dba_util_admin with grant option;

--
-- 5/20/2021
--
-- Create roles with permissions needed for Banner and Oracle account management and auditing
-- Accounts granted the nd_dba_banner_acctmgmt_u_role and nd_dba_oracle_acctmgmt_s_role should
-- also be audited as a DBA (audit all by GRANTEE; )
--

--
-- Deploy to all Banner databases
--
create role nd_dba_banner_audit_q_role;
grant select on bansecr.gtvclas   	to nd_dba_banner_audit_q_role;
grant select on bansecr.guraces     to nd_dba_banner_audit_q_role;
grant select on bansecr.guraobj   	to nd_dba_banner_audit_q_role;
grant select on bansecr.gurucls   	to nd_dba_banner_audit_q_role;
grant select on bansecr.guruobj   	to nd_dba_banner_audit_q_role;
grant select on fimsmgr.fobprof     to nd_dba_banner_audit_q_role;
grant select on fimsmgr.forusfn     to nd_dba_banner_audit_q_role;
grant select on fimsmgr.forusor     to nd_dba_banner_audit_q_role;
grant select on fimsmgr.ftvorgn     to nd_dba_banner_audit_q_role;
grant select on general.gobeacc     to nd_dba_banner_audit_q_role;
grant select on general.gtvsysi     to nd_dba_banner_audit_q_role;
grant select on general.gubinst     to nd_dba_banner_audit_q_role;
grant select on general.gubobjs   	to nd_dba_banner_audit_q_role;
grant select on ndfiadmin.fzbzfop   to nd_dba_banner_audit_q_role;
grant select on ndfiadmin.zownfop   to nd_dba_banner_audit_q_role;
grant select on ndhrpyadmin.pzraeed to nd_dba_banner_audit_q_role;
grant select on ndhrpyadmin.pzraexp to nd_dba_banner_audit_q_role;
grant select on ndhrpyadmin.pzvmngr to nd_dba_banner_audit_q_role;
grant select on ndhrpyadmin.pzvrels to nd_dba_banner_audit_q_role;
grant select on payroll.pebempl     to nd_dba_banner_audit_q_role;
grant select on payroll.perehis     to nd_dba_banner_audit_q_role;
grant select on payroll.ptrecls     to nd_dba_banner_audit_q_role;
grant select on posnctl.nbrbjob     to nd_dba_banner_audit_q_role;
grant select on posnctl.nbrjobs     to nd_dba_banner_audit_q_role;
grant select on saturn.spriden      to nd_dba_banner_audit_q_role;
grant select on sys.dba_col_privs  	to nd_dba_banner_audit_q_role;
grant select on sys.dba_role_privs 	to nd_dba_banner_audit_q_role;
grant select on sys.dba_sys_privs  	to nd_dba_banner_audit_q_role;
grant select on sys.dba_tab_privs  	to nd_dba_banner_audit_q_role;
grant select on sys.dba_users      	to nd_dba_banner_audit_q_role;

--
-- Deploy to all Banner databases
--
CREATE ROLE nd_dba_banner_acctmgmt_u_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON bansecr.gtvclas TO nd_dba_banner_acctmgmt_u_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON bansecr.guraobj TO nd_dba_banner_acctmgmt_u_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON bansecr.gurucls TO nd_dba_banner_acctmgmt_u_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON bansecr.guruobj TO nd_dba_banner_acctmgmt_u_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON fimsmgr.fobprof TO nd_dba_banner_acctmgmt_u_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON fimsmgr.forusfn TO nd_dba_banner_acctmgmt_u_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON fimsmgr.forusor TO nd_dba_banner_acctmgmt_u_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON general.gobeacc TO nd_dba_banner_acctmgmt_u_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON general.gubobjs TO nd_dba_banner_acctmgmt_u_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON ndfiadmin.fzbzfop TO nd_dba_banner_acctmgmt_u_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON ndfiadmin.zownfop TO nd_dba_banner_acctmgmt_u_role;

--
-- Deploy to all Banner databases
--
CREATE ROLE nd_dba_banner_acctmgmt_x_role;
grant execcute on nd_dba_util_admin.f_gen_password     to nd_dba_banner_acctmgmt_x_role;
grant execcute on nd_dba_util_admin.banner_remove_user to nd_dba_banner_acctmgmt_x_role;
grant execcute on nd_dba_util_admin.banner_lock_user   to nd_dba_banner_acctmgmt_x_role;

--
-- Deploy to all Oracle databases
--
CREATE ROLE nd_dba_oracle_acctmgmt_s_role;
GRANT ALTER USER                TO nd_dba_oracle_acctmgmt_s_role;
GRANT CREATE ROLE               TO nd_dba_oracle_acctmgmt_s_role;
GRANT GRANT ANY ROLE            TO nd_dba_oracle_acctmgmt_s_role;
GRANT SELECT ANY DICTIONARY     TO nd_dba_oracle_acctmgmt_s_role;
GRANT CREATE MATERIALIZED VIEW  TO nd_dba_oracle_acctmgmt_s_role;
GRANT CREATE SESSION            TO nd_dba_oracle_acctmgmt_s_role;
GRANT CREATE TABLE              TO nd_dba_oracle_acctmgmt_s_role;
GRANT CREATE USER               TO nd_dba_oracle_acctmgmt_s_role;
GRANT DROP USER                 TO nd_dba_oracle_acctmgmt_s_role;
GRANT GRANT ANY ROLE            TO nd_dba_oracle_acctmgmt_s_role;
GRANT UNLIMITED TABLESPACE      TO nd_dba_oracle_acctmgmt_s_role with admin option;

--
-- ND_DBA_UTIL_ADMIN backup/audit log table
--
  CREATE TABLE "ND_DBA_UTIL_ADMIN"."LOG" 
   ("RFC"           VARCHAR2(40 BYTE)   NOT NULL ENABLE, 
    "DATE"          DATE                DEFAULT sysdate NOT NULL ENABLE, 	
    "LINE"          NUMBER              DEFAULT 0 NOT NULL ENABLE, 
	"OPERATION"     VARCHAR2(500 BYTE)  NOT NULL ENABLE, 
    "USERNAME"      VARCHAR2(50 BYTE)   NOT NULL ENABLE, 
	 CONSTRAINT "PK_LOG" PRIMARY KEY ("RFC", "LINE"),
     TABLESPACE "USERS"
   ) TABLESPACE "USERS" ;

   COMMENT ON COLUMN "ND_AUTODEPLOY_USER"."AUTODEPLOY_LOG"."RFC" IS 'RFC Number';
   COMMENT ON COLUMN "ND_AUTODEPLOY_USER"."AUTODEPLOY_LOG"."DATE" IS 'date/time of deployment';
   COMMENT ON COLUMN "ND_AUTODEPLOY_USER"."AUTODEPLOY_LOG"."LINE" IS 'keep operations in order';
   COMMENT ON COLUMN "ND_AUTODEPLOY_USER"."AUTODEPLOY_LOG"."OPERATION" IS 'information needed to undo';
   COMMENT ON COLUMN "ND_AUTODEPLOY_USER"."AUTODEPLOY_LOG"."USERNAME" IS 'who did it';
   