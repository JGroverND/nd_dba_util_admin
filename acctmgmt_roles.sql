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
GRANT SELECT ON bansecr.guraces     TO nd_dba_banner_audit_q_role;
GRANT SELECT ON fimsmgr.fobprof     TO nd_dba_banner_audit_q_role;
GRANT SELECT ON fimsmgr.forusfn     TO nd_dba_banner_audit_q_role;
GRANT SELECT ON fimsmgr.forusor     TO nd_dba_banner_audit_q_role;
GRANT SELECT ON fimsmgr.ftvorgn     TO nd_dba_banner_audit_q_role;
GRANT SELECT ON general.gobeacc     TO nd_dba_banner_audit_q_role;
GRANT SELECT ON general.gtvsysi     TO nd_dba_banner_audit_q_role;
GRANT SELECT ON general.gubinst     TO nd_dba_banner_audit_q_role;
GRANT SELECT ON ndfiadmin.fzbzfop   TO nd_dba_banner_audit_q_role;
GRANT SELECT ON ndfiadmin.zownfop   TO nd_dba_banner_audit_q_role;
GRANT SELECT ON ndhrpyadmin.pzraeed TO nd_dba_banner_audit_q_role;
GRANT SELECT ON ndhrpyadmin.pzraexp TO nd_dba_banner_audit_q_role;
GRANT SELECT ON ndhrpyadmin.pzvmngr TO nd_dba_banner_audit_q_role;
GRANT SELECT ON ndhrpyadmin.pzvrels TO nd_dba_banner_audit_q_role;
GRANT SELECT ON payroll.pebempl     TO nd_dba_banner_audit_q_role;
GRANT SELECT ON payroll.perehis     TO nd_dba_banner_audit_q_role;
GRANT SELECT ON payroll.ptrecls     TO nd_dba_banner_audit_q_role;
GRANT SELECT ON posnctl.nbrbjob     TO nd_dba_banner_audit_q_role;
GRANT SELECT ON posnctl.nbrjobs     TO nd_dba_banner_audit_q_role;
GRANT SELECT ON saturn.spriden      TO nd_dba_banner_audit_q_role;

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
GRANT ALTER USER            TO nd_dba_oracle_acctmgmt_s_role;
GRANT CREATE ROLE           TO nd_dba_oracle_acctmgmt_s_role;
GRANT GRANT ANY ROLE        TO nd_dba_oracle_acctmgmt_s_role;
GRANT SELECT ANY DICTIONARY TO nd_dba_oracle_acctmgmt_s_role;
