create or replace package nd_dba_util_admin.nd_dba_oracle_account_util
IS
-- -----------------------------------------------------------------------------
-- file: nd_dba_oracle_account_util.sql
-- desc: Functions and procedures for managing Oracle accounts
--
-- audit trail
-- October 2022 John W Grover
--  - Original Code
--  - See package body for detailed comments
--
-- -----------------------------------------------------------------------------

-- E X C E P T I O N S
   e_account_exists           exception; -- -20001
   e_invalid_account          exception; -- -20002
   e_role_exists              exception; -- -20003
   e_invalid_role             exception; -- -20004
   e_role_not_assigned        exception; -- -20007
   e_role_already_assigned    exception; -- -20008
   e_invalid_profile          exception; -- -20009
   e_invalid_tablespace       exception; -- -20010
   e_invalid_sys_priv         exception; -- -20011
   e_invalid_object_name      exception; -- -20012
   e_unsupported_obj_priv     exception; -- -20013

-- C U R S O R S

-- V A R I A B L E S
   v_authorization            nd_dba_util_admin.audit_log.authorization%type := 'none';
   v_sequence_nbr             nd_dba_util_admin.audit_log.sequence_nbr%type  := 0;

-- F U N C T I O N S
   function is_account                 (p_account in sys.dba_users.username%type) return boolean;
   function is_role                    (p_role in sys.dba_roles.role%type) return boolean;
   function is_sys_priv                (p_privilege in sys.system_privilege_map.name%type) return boolean;
   function is_object                  (p_owner in sys.dba_objects.owner%type
                                       ,p_object_name in sys.dba_objects.object_name%type) return boolean;
   function is_profile                 (p_profile in sys.dba_profiles.profile%type) return boolean;
   function is_tablespace              (p_tablespace in sys.dba_tablespaces.tablespace_name%type) return boolean;
   function is_person_acct             (p_account in dba_users.username%type) return boolean;
   function is_sys_acct                (p_account in dba_users.username%type) return boolean;
   function is_owner_acct              (p_account in dba_users.username%type) return boolean;
   function is_link_acct               (p_account in dba_users.username%type) return boolean;

   function ora_acct_has_role          (p_account in sys.dba_users.username%type
                                       ,p_role in sys.dba_roles.role%type) return boolean;
   function ora_acct_has_sys_priv      (p_account in sys.dba_users.username%type
                                       ,p_privilege in sys.system_privilege_map.name%type) return boolean;
   function ora_acct_has_object_priv   (p_account in sys.dba_users.username%type
                                       ,p_owner in sys.dba_objects.owner%type
                                       ,p_object_name in sys.dba_objects.object_name%type
                                       ,p_object_privilege in sys.dba_tab_privs.privilege%type) return boolean;
   function ora_acct_status            (p_account in sys.dba_users.username%type) return sys.dba_users.account_status%type;
   function ora_acct_suggest_profile   (p_account in sys.dba_users.username%type) return sys.dba_users.profile%type;
   function ora_object_type            (p_owner in sys.dba_objects.owner%type
                                       ,p_object_name in sys.dba_objects.object_name%type) return sys.dba_objects.object_type%type;
-- P R O C E D U R E S
   procedure ora_acct_create           (p_account in sys.dba_users.username%type
                                       ,p_default_tablespace in sys.dba_users.default_tablespace%type default 'USERS'
                                       ,p_temporary_tablespace in sys.dba_users.temporary_tablespace%type default 'TEMP'
                                       ,p_profile in sys.dba_users.profile%type default 'ND_USR_LOCK_DEFAULT');
   procedure ora_acct_lock             (p_account in sys.dba_users.username%type);
   procedure ora_acct_drop             (p_account in sys.dba_users.username%type);
   procedure ora_acct_change_profile   (p_account in sys.dba_users.username%type
                                       ,p_profile in sys.dba_users.profile%type);
   procedure ora_acct_change_tablespace(p_account in sys.dba_users.username%type
                                       ,p_default_tablespace in sys.dba_users.default_tablespace%type default 'USERS'
                                       ,p_temporary_tablespace in sys.dba_users.temporary_tablespace%type default 'TEMP');
   procedure ora_acct_grant_role      (p_account in sys.dba_users.username%type
                                       ,p_role  in sys.dba_roles.role%type);
   procedure ora_acct_grant_role_list (p_account in sys.dba_users.username%type
                                       ,p_role_list in VARCHAR2);
   procedure ora_acct_change_default_role (p_account in sys.dba_users.username%type
                                          ,p_role in sys.dba_roles.role%type);
   procedure ora_acct_revoke_role      (p_account in sys.dba_users.username%type
                                       ,p_role  in sys.dba_roles.role%type);
   procedure ora_acct_revoke_role_list (p_account in sys.dba_users.username%type
                                       ,p_role_list in varchar2);
   procedure ora_acct_grant_sys_priv   (p_account in sys.dba_users.username%type
                                       ,p_privilege in sys.system_privilege_map.name%type);
   procedure ora_acct_revoke_sys_priv  (p_account in sys.dba_users.username%type
                                       ,p_privilege in sys.system_privilege_map.name%type);
   procedure ora_acct_grant_object_priv(p_account in sys.dba_users.username%type
                                       ,p_owner in sys.dba_objects.owner%type
                                       ,p_object_name in sys.dba_objects.object_name%type
                                       ,p_object_privilege in sys.dba_tab_privs.privilege%type);
   procedure ora_acct_revoke_object_priv  (p_account in sys.dba_users.username%type
                                          ,p_owner in sys.dba_objects.owner%type
                                          ,p_object_name in sys.dba_objects.object_name%type
                                          ,p_object_privilege in sys.dba_tab_privs.privilege%type);
-- ora_acct_clone_acct(acct, clone)
   procedure ora_role_rename           (p_old_role in sys.dba_roles.role%type,
                                        P_new_role in sys.dba_roles.role%type);
-- -----------------------------------------------------------------------------
--                                                   E N D   O F   P A C K A G E
-- -----------------------------------------------------------------------------
end nd_dba_oracle_account_util;
