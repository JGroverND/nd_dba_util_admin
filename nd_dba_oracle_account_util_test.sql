-- -----------------------------------------------------------------------------
-- file: nd_dba_oracle_account_util_test.sql
-- desc: test suite for nd_dba_oracle_account_util
--
-- audit trail
-- 15-Oct-2022 John W Grover
--  - Original Code
--
-- -----------------------------------------------------------------------------

begin
declare
    v_pass_fail                 varchar2(6);
    v_account_status            sys.dba_users.account_status%type;
    v_profile                   sys.dba_users.profile%type;
    v_object_type               sys.dba_objects.object_type%type;

    -- v_good_account should also be a person account
    v_good_account              sys.dba_users.account_status%type := 'JGROVER';
    v_bad_account               sys.dba_users.account_status%type := 'XYZZY';

    v_good_role                 sys.dba_roles.role%type := 'ND_CONNECT_S_ROLE';
    v_bad_role                  sys.dba_roles.role%type := 'XYZZY';

    v_good_sys_priv             sys.dba_sys_privs%privilege%type := 'CREATE SESSION';
    v_bad_sys_priv              sys.dba_sys_privs%privilege%type := 'XYZZY';

    v_good_object_owner         sys.dba_objects.owner%type := 'JGROVER';
    v_good_object_name          sys.dba_objects.object_name%type := 'TABLE1';
    v_bad_object_owner          sys.dba_objects.owner%type := 'PLUGH';
    v_bad_object_name           sys.dba_objects.object_name%type := 'XYZZY';

    v_good_profile              sys.dba_profiles.profile%type := 'ND_USR_OPEN_DEFAULT';
    v_bad_profile               sys.dba_profiles.profile%type := 'XYZZY';

    v_good_tablespace_name      sys.dba_tablespaces.tablespace_name%type := 'USERS';
    v_bad_tablespace_name       sys.dba_tablespaces.tablespace_name%type := 'XYZZY';

    v_good_system_account       sys.dba_users.account_status%type := 'SYSTEM';
    v_bad_system_account        sys.dba_users.account_status%type := 'PLUGH';

    v_good_owner_account        sys.dba_users.account_status%type := 'JGROVER';
    v_bad_owner_account         sys.dba_users.account_status%type := 'PLUGH';

    v_good_link_account         sys.dba_users.account_status%type := 'ND_ODS_ADMIN_LINK';
    v_bad_link_account          sys.dba_users.account_status%type := 'PLUGH';

    v_good_object_permission    sys.dba_tab_privs.privilege%type := 'SELECT';
    v_bad_object_permission    sys.dba_tab_privs.privilege%type := 'XYZZY';



begin
-- -----------------------------------------------------------------------------
-- F U N C T I O N S
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Binary functions
-- Oct 2022 JWG - Test all input parameter permutations valid/invalid values
--                Assumes: 
--                - v_bad_account, though magical, is an invalid input for 
--                  any parameter
--                - JGROVER is a valid person account 
--                  and owns ND_DBA_ORACLE_ACCOUNT_UTIL
--                  and has ND_CONNECT_S_ROLE role assigned
--                  and has UNLIMITED TABLESPACE granted directly
--                  and has select on saturn.spriden granted directly
--                - USERS is a valid tablespace
--                - ND_ABSSOLUTE_NDFIADMIN_LINK is a valid link account
-- -----------------------------------------------------------------------------

--    function is_account                 (p_account in sys.dba_users.username%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_account  (v_good_account)
    and not nd_dba_oracle_account_util.is_account               (v_bad_account)
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE('is_account ' || v_pass_fail);

--    function is_role                    (p_role in sys.dba_roles.role%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_role     (v_good_role)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_role(v_bad_role)
    then
         v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE('is_role ' || v_pass_fail);
    
--    function is_sys_priv                (p_privilege in sys.system_privilege_map.name%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_sys_priv     (v_good_sys_priv)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_sys_priv(v_bad_sys_priv)
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE('is_sys_priv ' || v_pass_fail);
    
--    function is_object                  (p_owner in sys.dba_objects.owner%type
--                                        ,p_object_name in sys.dba_objects.object_name%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_object       (v_good_object_owner,   v_good_object_name)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_object  (v_bad_object_owner,    v_bad_object_name)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_object  (v_good_object_owner,   v_bad_object_name)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_object  (v_bad_object_owner,    v_good_object_name)
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE('is_object ' || v_pass_fail);
    
--    function is_profile                 (p_profile in sys.dba_profiles.profile%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_profile      (v_good_profile)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_profile (v_bad_profile)
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE('is_profile ' || v_pass_fail);
    
--    function is_tablespace              (p_tablespace in sys.dba_tablespaces.tablespace_name%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_tablespace       (v_good_tablespace_name)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_tablespace  (v_bad_tablespace_name)
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE('is_tablespace ' || v_pass_fail);
    
--    function is_person_acct             (p_account in dba_users.username%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_person_acct  (v_good_account)
    and not     nd_dba_util_admin.nd_dba_oracle_account_util.is_person_acct  (v_bad_account)
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE('is_person_acct ' || v_pass_fail);
    
--    function is_sys_acct                (p_account in dba_users.username%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_sys_acct     (v_good_system_account)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_sys_acct(v_bad_system_account)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_sys_acct(v_bad_account)
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE('is_sys_acct ' || v_pass_fail);
    
--    function is_owner_acct              (p_account in dba_users.username%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_owner_acct       (v_good_owner_account)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_owner_acct  (v_bad_owner_account)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_owner_acct  (v_bad_account)
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE('is_owner_acct ' || v_pass_fail);
    
--    function is_link_acct               (p_account in dba_users.username%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_link_acct        (v_good_link_account)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_link_acct   (v_bad_link_account)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_link_acct   (v_bad_account)
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE('is_link_acct ' || v_pass_fail);
    
--    function ora_acct_has_role          (p_account in sys.dba_users.username%type
--                                        ,p_role in sys.dba_roles.role%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_role       (v_good_account,    v_good_role)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_role  (v_bad_account,     v_good_role)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_role  (v_good_account,    v_bad_role)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_role  (v_bad_account,     v_bad_role)
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE('ora_acct_has_role ' || v_pass_fail);
    
--    function ora_acct_has_sys_priv      (p_account in sys.dba_users.username%type
--                                        ,p_privilege in sys.system_privilege_map.name%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_sys_priv       (v_good_account,    v_good_sys_priv)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_sys_priv  (v_bad_account,     v_good_sys_priv)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_sys_priv  (v_good_account,    v_bad_sys_priv)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_sys_priv  (v_bad_account,     v_bad_sys_priv)
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE('ora_acct_has_sys_priv ' || v_pass_fail);
    
--    function ora_acct_has_object_priv   (p_account in sys.dba_users.username%type
--                                        ,p_owner in sys.dba_objects.owner%type
--                                        ,p_object_name in sys.dba_objects.object_name%type
--                                        ,p_object_privilege in sys.dba_tab_privs.privilege%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv     (v_good_account,   v_good_object_owner,   v_good_object_name,  v_good_object_permission)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv(v_bad_account,    v_good_object_owner,   v_good_object_name,  v_good_object_permission)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv(v_good_account,   v_bad_object_owner,    v_good_object_name,  v_good_object_permission)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv(v_bad_account,    v_bad_object_owner,    v_good_object_name,  v_good_object_permission)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv(v_good_account,   v_good_object_owner,   v_bad_object_name,   v_good_object_permission)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv(v_bad_account,    v_good_object_owner,   v_bad_object_name,   v_good_object_permission)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv(v_good_account,   v_bad_object_owner,    v_bad_object_name,   v_good_object_permission)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv(v_bad_account,    v_bad_object_owner,    v_bad_object_name,   v_good_object_permission)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv(v_good_account,   v_good_object_owner,   v_good_object_name,  v_bad_object_permission)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv(v_bad_account,    v_good_object_owner,   v_good_object_name,  v_bad_object_permission)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv(v_good_account,   v_bad_object_owner,    v_good_object_name,  v_bad_object_permission)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv(v_bad_account,    v_bad_object_owner,    v_good_object_name,  v_bad_object_permission)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv(v_good_account,   v_good_object_owner,   v_bad_object_name,   v_bad_object_permission)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv(v_bad_account,    v_good_object_owner,   v_bad_object_name,   v_bad_object_permission)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv(v_good_account,   v_bad_object_owner,    v_bad_object_name,   v_bad_object_permission)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv(v_bad_account,    v_bad_object_owner,    v_bad_object_name,   v_bad_object_permission)
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE('ora_acct_has_object_priv ' || v_pass_fail);
    
-- -----------------------------------------------------------------------------
-- Non-binary functions
-- Oct 2022 JWG - Test all input parameter permutations valid/invalid values
--                against known valid output sets
-- -----------------------------------------------------------------------------
--
--    function ora_acct_status            (p_account in sys.dba_users.username%type) return sys.dba_users.account_status%type;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_account(v_good_account)
    then
        select nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_status(v_good_account) into v_account_status
          from dual;

        if v_account_status is not null
        then
            v_pass_fail := 'passed';
        end if;
    end if;
    DBMS_OUTPUT.PUT_LINE('ora_acct_status ' || v_pass_fail);

--    function ora_acct_suggest_profile   (p_account in sys.dba_users.username%type) return sys.dba_users.profile%type;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_account(v_good_account)
    then
        select nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_suggest_profile(v_good_account) into v_profile
          from dual;

        if v_account_status is not null
        then
            v_pass_fail := 'passed';
        end if;
    end if;
    DBMS_OUTPUT.PUT_LINE('ora_acct_suggest_profile ' || v_pass_fail);

--    function ora_object_type            (p_owner in sys.dba_objects.owner%type
--                                        ,p_object_name in sys.dba_objects.object_name%type) return sys.dba_objects.object_type%type;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_object(v_good_owner_account, v_good_object_name)
    then
        select nd_dba_util_admin.nd_dba_oracle_account_util.ora_object_type(v_good_owner_account, v_good_object_name) into v_object_type
          from dual;

        if v_object_type is not null
        then
            v_pass_fail := 'passed';
        end if;
    end if;
    DBMS_OUTPUT.PUT_LINE('ora_object_type ' || v_pass_fail);

-- -----------------------------------------------------------------------------
--    -- P R O C E D U R E S
-- -----------------------------------------------------------------------------

--    procedure ora_acct_create           (p_account in sys.dba_users.username%type
--                                        ,p_default_tablespace in sys.dba_users.default_tablespace%type default 'USERS'
--                                        ,p_temporary_tablespace in sys.dba_users.temporary_tablespace%type default 'TEMP'
--                                        ,p_profile in sys.dba_users.profile%type default 'ND_USR_LOCK_DEFAULT');
--    procedure ora_acct_lock             (p_account in sys.dba_users.username%type);
--    procedure ora_acct_drop             (p_account in sys.dba_users.username%type);
--    procedure ora_acct_change_profile   (p_account in sys.dba_users.username%type
--                                        ,p_profile in sys.dba_users.profile%type);
--    procedure ora_acct_change_tablespace(p_account in sys.dba_users.username%type
--                                        ,p_default_tablespace in sys.dba_users.default_tablespace%type default 'USERS'
--                                        ,p_temporary_tablespace in sys.dba_users.temporary_tablespace%type default 'TEMP');
--    procedure ora_acct_grant_role      (p_account in sys.dba_users.username%type
--                                        ,p_role  in sys.dba_roles.role%type);
--    procedure ora_acct_grant_role_list (p_account in sys.dba_users.username%type
--                                        ,p_role_list in VARCHAR2);
--    procedure ora_acct_change_default_role (p_account in sys.dba_users.username%type
--                                           ,p_role in sys.dba_roles.role%type);
--    procedure ora_acct_revoke_role      (p_account in sys.dba_users.username%type
--                                        ,p_role  in sys.dba_roles.role%type);
--    procedure ora_acct_revoke_role_list (p_account in sys.dba_users.username%type
--                                        ,p_role_list in varchar2);
--    procedure ora_acct_grant_sys_priv   (p_account in sys.dba_users.username%type
--                                        ,p_privilege in sys.system_privilege_map.name%type);
--    procedure ora_acct_revoke_sys_priv  (p_account in sys.dba_users.username%type
--                                        ,p_privilege in sys.system_privilege_map.name%type);
--    procedure ora_acct_grant_object_priv(p_account in sys.dba_users.username%type
--                                        ,p_owner in sys.dba_objects.owner%type
--                                        ,p_object_name in sys.dba_objects.object_name%type
--                                        ,p_object_privilege in sys.dba_tab_privs.privilege%type);
--    procedure ora_acct_revoke_object_priv  (p_account in sys.dba_users.username%type
--                                           ,p_owner in sys.dba_objects.owner%type
--                                           ,p_object_name in sys.dba_objects.object_name%type
--                                           ,p_object_privilege in sys.dba_tab_privs.privilege%type);

end;
end;
