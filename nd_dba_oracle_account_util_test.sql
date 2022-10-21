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
    v_pass_fail         varchar2(6);
    v_account_status    sys.dba_users.account_status%type;
    v_profile           sys.dba_users.profile%type;
    v_object_type       sys.dba_objects.object_type%type;
begin
-- -----------------------------------------------------------------------------
-- F U N C T I O N S
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Binary functions
-- Oct 2022 JWG - Test all input parameter permutations valid/invalid values
--                Assumes: 
--                - 'XYZZY', though magical, is an invalid input for 
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
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_account  ('JGROVER')
    and not nd_dba_oracle_account_util.is_account               ('XYZZY')
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE('is_account ' || v_pass_fail);

--    function is_role                    (p_role in sys.dba_roles.role%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_role     ('ND_CONNECT_S_ROLE')
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_role('XYZZY')
    then
         v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE('is_role ' || v_pass_fail);
    
--    function is_sys_priv                (p_privilege in sys.system_privilege_map.name%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_sys_priv     ('ALTER USER')
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_sys_priv('XYZZY')
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE('is_sys_priv ' || v_pass_fail);
    
--    function is_object                  (p_owner in sys.dba_objects.owner%type
--                                        ,p_object_name in sys.dba_objects.object_name%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_object       ('JGROVER', 'ND_DBA_ORACLE_ACCOUNT_UTIL')
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_object  ('XYZZY',   'ND_DBA_ORACLE_ACCOUNT_UTIL')
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_object  ('JGROVER', 'XYZZY')
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_object  ('XYZZY',   'XYZZY')
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE('is_object ' || v_pass_fail);
    
--    function is_profile                 (p_profile in sys.dba_profiles.profile%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_profile      ('DEFAULT')
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_profile ('XYZZY')
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE('is_profile ' || v_pass_fail);
    
--    function is_tablespace              (p_tablespace in sys.dba_tablespaces.tablespace_name%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_tablespace       ('USERS')
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_tablespace  ('XYZZY')
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE('is_tablespace ' || v_pass_fail);
    
--    function is_person_acct             (p_account in dba_users.username%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_person_acct  ('JGROVER')
    and not     nd_dba_util_admin.nd_dba_oracle_account_util.is_person_acct  ('XYZZY')
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE('is_person_acct ' || v_pass_fail);
    
--    function is_sys_acct                (p_account in dba_users.username%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_sys_acct     ('SYSTEM')
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_sys_acct('XYZZY')
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE('is_sys_acct ' || v_pass_fail);
    
--    function is_owner_acct              (p_account in dba_users.username%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_owner_acct       ('JGROVER')
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_owner_acct  ('XYZZY')
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE('is_owner_acct ' || v_pass_fail);
    
--    function is_link_acct               (p_account in dba_users.username%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_link_acct        ('ND_ABSSOLUTE_NDFIADMIN_LINK')
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_link_acct   ('XYZZY')
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE('is_link_acct ' || v_pass_fail);
    
--    function ora_acct_has_role          (p_account in sys.dba_users.username%type
--                                        ,p_role in sys.dba_roles.role%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_role       ('JGROVER', 'ND_CONNECT_S_ROLE')
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_role  ('XYZZY',   'ND_CONNECT_S_ROLE')
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_role  ('JGROVER', 'XYZZY')
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_role  ('XYZZY',   'XYZZY')
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE('ora_acct_has_role ' || v_pass_fail);
    
--    function ora_acct_has_sys_priv      (p_account in sys.dba_users.username%type
--                                        ,p_privilege in sys.system_privilege_map.name%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_sys_priv       ('JGROVER', 'UNLIMITED TABLESPACE')
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_sys_priv  ('XYZZY',   'UNLIMITED TABLESPACE')
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_sys_priv  ('JGROVER', 'XYZZY')
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_sys_priv  ('XYZZY',   'XYZZY')
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE('ora_acct_has_sys_priv ' || v_pass_fail);
    
--    function ora_acct_has_object_priv   (p_account in sys.dba_users.username%type
--                                        ,p_owner in sys.dba_objects.owner%type
--                                        ,p_object_name in sys.dba_objects.object_name%type
--                                        ,p_object_privilege in sys.dba_tab_privs.privilege%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv     ('JGROVER',    'SATURN',   'SPRIDEN',  'SELECT')
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv('XYZZY',      'SATURN',   'SPRIDEN',  'SELECT')
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv('JGROVER',    'XYZZY',    'SPRIDEN',  'SELECT')
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv('XYZZY',      'XYZZY',    'SPRIDEN',  'SELECT')
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv('JGROVER',    'SATURN',   'XYZZY',    'SELECT')
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv('XYZZY',      'SATURN',   'XYZZY',    'SELECT')
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv('JGROVER',    'XYZZY',    'XYZZY',    'SELECT')
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv('XYZZY',      'XYZZY',    'XYZZY',    'SELECT')
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv('JGROVER',    'SATURN',   'SPRIDEN',  'XYZZY')
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv('XYZZY',      'SATURN',   'SPRIDEN',  'XYZZY')
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv('JGROVER',    'XYZZY',    'SPRIDEN',  'XYZZY')
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv('XYZZY',      'XYZZY',    'SPRIDEN',  'XYZZY')
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv('JGROVER',    'SATURN',   'XYZZY',    'XYZZY')
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv('XYZZY',      'SATURN',   'XYZZY',    'XYZZY')
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv('JGROVER',    'XYZZY',    'XYZZY',    'XYZZY')
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv('XYZZY',      'XYZZY',    'XYZZY',    'XYZZY')
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
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_account('JGROVER')
    then
        select nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_status('JGROVER') into v_account_status
          from dual;

        if v_account_status is not null
        then
            v_pass_fail := 'passed';
        end if;
    end if;
    DBMS_OUTPUT.PUT_LINE('ora_acct_status ' || v_pass_fail);

--    function ora_acct_suggest_profile   (p_account in sys.dba_users.username%type) return sys.dba_users.profile%type;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_account('JGROVER')
    then
        select nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_suggest_profile('JGROVER') into v_profile
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
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_object('JGROVER', 'ND_DBA_ORACLE_ACCOUNT_UTIL')
    then
        select nd_dba_util_admin.nd_dba_oracle_account_util.ora_object_type('JGROVER', 'ND_DBA_ORACLE_ACCOUNT_UTIL') into v_object_type
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
