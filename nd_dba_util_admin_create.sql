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
create role nd_dba_banner_acctmgmt_u_role;
grant select, insert, update, delete on bansecr.gtvclas to nd_dba_banner_acctmgmt_u_role;
grant select, insert, update, delete on bansecr.guraobj to nd_dba_banner_acctmgmt_u_role;
grant select, insert, update, delete on bansecr.gurucls to nd_dba_banner_acctmgmt_u_role;
grant select, insert, update, delete on bansecr.guruobj to nd_dba_banner_acctmgmt_u_role;
grant select, insert, update, delete on fimsmgr.fobprof to nd_dba_banner_acctmgmt_u_role;
grant select, insert, update, delete on fimsmgr.forusfn to nd_dba_banner_acctmgmt_u_role;
grant select, insert, update, delete on fimsmgr.forusor to nd_dba_banner_acctmgmt_u_role;
grant select, insert, update, delete on general.gobeacc to nd_dba_banner_acctmgmt_u_role;
grant select, insert, update, delete on general.gubobjs to nd_dba_banner_acctmgmt_u_role;
grant select, insert, update, delete on ndfiadmin.fzbzfop to nd_dba_banner_acctmgmt_u_role;
grant select, insert, update, delete on ndfiadmin.zownfop to nd_dba_banner_acctmgmt_u_role;

--
-- Deploy to all Banner databases
--
create role nd_dba_banner_acctmgmt_x_role;
grant execcute on nd_dba_util_admin.f_gen_password     to nd_dba_banner_acctmgmt_x_role;
grant execcute on nd_dba_util_admin.banner_remove_user to nd_dba_banner_acctmgmt_x_role;
grant execcute on nd_dba_util_admin.banner_lock_user   to nd_dba_banner_acctmgmt_x_role;

--
-- Deploy to all Oracle databases
--
create role nd_dba_oracle_acctmgmt_s_role;
grant alter user                to nd_dba_oracle_acctmgmt_s_role;
grant create role               to nd_dba_oracle_acctmgmt_s_role;
grant grant any role            to nd_dba_oracle_acctmgmt_s_role;
grant select any role           to nd_dba_oracle_acctmgmt_s_role;
grant create materialized view  to nd_dba_oracle_acctmgmt_s_role;
grant create session            to nd_dba_oracle_acctmgmt_s_role;
grant create table              to nd_dba_oracle_acctmgmt_s_role;
grant create user               to nd_dba_oracle_acctmgmt_s_role;
grant drop user                 to nd_dba_oracle_acctmgmt_s_role;
grant unlimited tablespace      to nd_dba_oracle_acctmgmt_s_role with admin option;

--
-- ND_DBA_UTIL_ADMIN backup/audit log table
--
create table nd_dba_util_admin.audit_log
(
    authorization varchar2(40)  not null enable, 
    activity_date date          default sysdate not null enable, 	
    username      varchar2(50)  not null enable, 
    sequence_nbr  number        default 0 not null enable, 
    sql_cmd       varchar2(500) not null enable, 
    undo_cmd      varchar2(500) not null enable, 
    constraint    pk_audit_log  
      unique (authorization, sequence_nbr)
      using index
      tablespace users
      enable
) 
tablespace users ;

comment on column nd_dba_util_admin.audit_log.authorization  is 'RFC Number';
comment on column nd_dba_util_admin.audit_log.activity_date  is 'date/time of deployment';
comment on column nd_dba_util_admin.audit_log.username       is 'who did it';
comment on column nd_dba_util_admin.audit_log.sequence_nbr   is 'keep operations in order';
comment on column nd_dba_util_admin.audit_log.sql_cmd        is 'code that was executed';
comment on column nd_dba_util_admin.audit_log.undo_cmd       is 'information needed to undo';
