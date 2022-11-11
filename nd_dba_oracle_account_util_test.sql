-- -----------------------------------------------------------------------------
-- file: nd_dba_oracle_account_util_test.sql
-- desc: test suite for nd_dba_oracle_account_util
--
-- audit trail
-- 15-Oct-2022 John W Grover
--  - Original Code
-- 04-Nov-2022 John W Grover
--  - Variablized test inputs
/*
create user plugh
    identified by R1GR2DJQ9MVITXJH1LB7ISPHNBD1M6
    default tablespace users
    temporary tablespace temp;

grant create session to plugh;
grant select on jgrover.table1 to plugh;
grant ND_CONNECT_S_ROLE to plugh;
grant ND_RESOURCE_S_ROLE to plugh;
alter user plugh default role ND_CONNECT_S_ROLE;

begin
declare 
    i number        := 0;
    c varchar2(200) := null;
    begin
        for i in 1..9 loop
            c := 'DROP USER XYZZY' || i || ' CASCADE';
            execute immediate c;
        end loop;
    end;
end;
*/
-- -----------------------------------------------------------------------------

begin
declare
    i                           number := 0;
    c                           varchar2(200) := null;

    v_pass_fail                 varchar2(6);
    v_account_status            sys.dba_users.account_status%type;
    v_profile                   sys.dba_users.profile%type;
    v_object_type               sys.dba_objects.object_type%type;

    -- v_good_account should also be a person account
    v_good_account              sys.dba_users.username%type := 'JGROVER';
    v_bad_account               sys.dba_users.username%type := 'XYZZY';

    v_good_role                 sys.dba_roles.role%type := 'ND_CONNECT_S_ROLE';
    v_bad_role                  sys.dba_roles.role%type := 'XYZZY';

    v_good_sys_priv_acct        sys.dba_users.username%type := 'PLUGH';
    v_bad_sys_priv_acct         sys.dba_users.username%type := 'XYZZY';
    v_good_sys_priv             sys.dba_sys_privs.privilege%type := 'CREATE SESSION';
    v_bad_sys_priv              sys.dba_sys_privs.privilege%type := 'XYZZY';

    v_good_obj_priv_acct        sys.dba_users.username%type := 'PLUGH';
    v_bad_obj_priv_acct         sys.dba_users.username%type := 'XYZZY';
    v_good_object_owner         sys.dba_objects.owner%type := 'JGROVER';
    v_good_object_name          sys.dba_objects.object_name%type := 'TABLE1';
    v_bad_object_owner          sys.dba_objects.owner%type := 'PLUGH';
    v_bad_object_name           sys.dba_objects.object_name%type := 'XYZZY';

    v_good_profile              sys.dba_profiles.profile%type := 'ND_USR_OPEN_DEFAULT';
    v_bad_profile               sys.dba_profiles.profile%type := 'XYZZY';

    v_good_tablespace_name      sys.dba_tablespaces.tablespace_name%type := 'USERS';
    v_bad_tablespace_name       sys.dba_tablespaces.tablespace_name%type := 'XYZZY';

    v_good_system_account       sys.dba_users.username%type := 'SYSTEM';
    v_bad_system_account        sys.dba_users.username%type := 'PLUGH';

    v_good_owner_account        sys.dba_users.username%type := 'JGROVER';
    v_bad_owner_account         sys.dba_users.username%type := 'PLUGH';

    v_good_link_account         sys.dba_users.username%type := 'ND_ODS_ADMIN_LINK';
    v_bad_link_account          sys.dba_users.username%type := 'PLUGH';

    v_good_object_permission    sys.dba_tab_privs.privilege%type := 'SELECT';
    v_bad_object_permission     sys.dba_tab_privs.privilege%type := 'XYZZY';

    v_test_user                 sys.dba_users.username%type;
    v_ts                        sys.dba_tablespaces.tablespace_name%type;
    v_tts                       sys.dba_tablespaces.tablespace_name%type;
    v_error_count               number := 0;

    v_yes_no                    varchar2(30);

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
    dbms_output.put_line('cleanup');

    for i in 1..9 loop
        if nd_dba_util_admin.nd_dba_oracle_account_util.is_account('XYZZY' || i)
        then
            c := 'DROP USER XYZZY' || i || ' CASCADE';
            dbms_output.put_line(c);
            execute immediate c;
        end if;
    end loop;

-- -----------------------------------------------------------------------------
--    function is_account                 (p_account in sys.dba_users.username%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_account      (v_good_account)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_account (v_bad_account)
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE(v_pass_fail || ' is_account ');

-- -----------------------------------------------------------------------------
--    function is_role                    (p_role in sys.dba_roles.role%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_role     (v_good_role)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_role(v_bad_role)
    then
         v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE(v_pass_fail || ' is_role ');
    
-- -----------------------------------------------------------------------------
--    function is_sys_priv                (p_privilege in sys.system_privilege_map.name%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_sys_priv     (v_good_sys_priv)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_sys_priv(v_bad_sys_priv)
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE(v_pass_fail || ' is_sys_priv ');
    
-- -----------------------------------------------------------------------------
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
    DBMS_OUTPUT.PUT_LINE(v_pass_fail || ' is_object ');
    
-- -----------------------------------------------------------------------------
--    function is_profile                 (p_profile in sys.dba_profiles.profile%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_profile      (v_good_profile)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_profile (v_bad_profile)
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE(v_pass_fail || ' is_profile ');
    
-- -----------------------------------------------------------------------------
--    function is_tablespace              (p_tablespace in sys.dba_tablespaces.tablespace_name%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_tablespace       (v_good_tablespace_name)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_tablespace  (v_bad_tablespace_name)
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE(v_pass_fail || ' is_tablespace ');
    
-- -----------------------------------------------------------------------------
--    function is_person_acct             (p_account in dba_users.username%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_person_acct  (v_good_account)
    and not     nd_dba_util_admin.nd_dba_oracle_account_util.is_person_acct  (v_bad_account)
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE(v_pass_fail || ' is_person_acct ');
    
-- -----------------------------------------------------------------------------
--    function is_sys_acct                (p_account in dba_users.username%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_sys_acct     (v_good_system_account)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_sys_acct(v_bad_system_account)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_sys_acct(v_bad_account)
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE(v_pass_fail || ' is_sys_acct ');
    
-- -----------------------------------------------------------------------------
--    function is_owner_acct              (p_account in dba_users.username%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_owner_acct       (v_good_owner_account)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_owner_acct  (v_bad_owner_account)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_owner_acct  (v_bad_account)
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE(v_pass_fail || ' is_owner_acct ');
    
-- -----------------------------------------------------------------------------
--    function is_link_acct               (p_account in dba_users.username%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_link_acct        (v_good_link_account)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_link_acct   (v_bad_link_account)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.is_link_acct   (v_bad_account)
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE(v_pass_fail || ' is_link_acct ');
    
-- -----------------------------------------------------------------------------
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
    DBMS_OUTPUT.PUT_LINE(v_pass_fail || ' ora_acct_has_role ');
    
-- -----------------------------------------------------------------------------
--    function ora_acct_has_sys_priv      (p_account in sys.dba_users.username%type
--                                        ,p_privilege in sys.system_privilege_map.name%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_sys_priv       (v_good_sys_priv_acct,   v_good_sys_priv)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_sys_priv  (v_bad_sys_priv_acct,    v_good_sys_priv)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_sys_priv  (v_good_sys_priv_acct,   v_bad_sys_priv)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_sys_priv  (v_bad_sys_priv_acct,    v_bad_sys_priv)
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE(v_pass_fail || ' ora_acct_has_sys_priv ');
    
-- -----------------------------------------------------------------------------
--    function ora_acct_has_object_priv   (p_account in sys.dba_users.username%type
--                                        ,p_owner in sys.dba_objects.owner%type
--                                        ,p_object_name in sys.dba_objects.object_name%type
--                                        ,p_object_privilege in sys.dba_tab_privs.privilege%type) return boolean;
    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv     (v_good_obj_priv_acct,   v_good_object_owner,   v_good_object_name,  v_good_object_permission)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv(v_bad_obj_priv_acct,    v_good_object_owner,   v_good_object_name,  v_good_object_permission)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv(v_good_obj_priv_acct,   v_bad_object_owner,    v_good_object_name,  v_good_object_permission)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv(v_bad_obj_priv_acct,    v_bad_object_owner,    v_good_object_name,  v_good_object_permission)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv(v_good_obj_priv_acct,   v_good_object_owner,   v_bad_object_name,   v_good_object_permission)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv(v_bad_obj_priv_acct,    v_good_object_owner,   v_bad_object_name,   v_good_object_permission)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv(v_good_obj_priv_acct,   v_bad_object_owner,    v_bad_object_name,   v_good_object_permission)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv(v_bad_obj_priv_acct,    v_bad_object_owner,    v_bad_object_name,   v_good_object_permission)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv(v_good_obj_priv_acct,   v_good_object_owner,   v_good_object_name,  v_bad_object_permission)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv(v_bad_obj_priv_acct,    v_good_object_owner,   v_good_object_name,  v_bad_object_permission)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv(v_good_obj_priv_acct,   v_bad_object_owner,    v_good_object_name,  v_bad_object_permission)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv(v_bad_obj_priv_acct,    v_bad_object_owner,    v_good_object_name,  v_bad_object_permission)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv(v_good_obj_priv_acct,   v_good_object_owner,   v_bad_object_name,   v_bad_object_permission)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv(v_bad_obj_priv_acct,    v_good_object_owner,   v_bad_object_name,   v_bad_object_permission)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv(v_good_obj_priv_acct,   v_bad_object_owner,    v_bad_object_name,   v_bad_object_permission)
    and not nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_object_priv(v_bad_obj_priv_acct,    v_bad_object_owner,    v_bad_object_name,   v_bad_object_permission)
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE(v_pass_fail || ' ora_acct_has_object_priv ');
    
-- -----------------------------------------------------------------------------
-- Non-binary functions
-- Oct 2022 JWG - Test all input parameter permutations valid/invalid values
--                against known valid output sets
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
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
    DBMS_OUTPUT.PUT_LINE(v_pass_fail || ' ora_acct_status ');

-- -----------------------------------------------------------------------------
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
    DBMS_OUTPUT.PUT_LINE(v_pass_fail || ' ora_acct_suggest_profile ');

-- -----------------------------------------------------------------------------
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
    DBMS_OUTPUT.PUT_LINE(v_pass_fail || ' ora_object_type ');

-- -----------------------------------------------------------------------------
--    -- P R O C E D U R E S
-- -----------------------------------------------------------------------------

--    procedure ora_acct_create           (p_account in sys.dba_users.username%type
--                                        ,p_default_tablespace in sys.dba_users.default_tablespace%type default 'USERS'
--                                        ,p_temporary_tablespace in sys.dba_users.temporary_tablespace%type default 'TEMP'
--                                        ,p_profile in sys.dba_users.profile%type default 'ND_USR_LOCK_DEFAULT');
    v_error_count := 0;
    v_pass_fail := 'failed';

    nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_create(p_account => 'XYZZY1');
    nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_create(p_account => 'XYZZY2', 
                                                                 p_default_tablespace => 'TOOLS');
    nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_create(p_account => 'XYZZY3', 
                                                                 p_temporary_tablespace => 'TEMP');
    nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_create(p_account => 'XYZZY4', 
                                                                 p_default_tablespace => 'TOOLS',
                                                                 p_temporary_tablespace => 'TEMP');
    nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_create(p_account => 'XYZZY5',
                                                                 p_profile => 'ND_USR_OPEN_DEFAULT');
    nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_create(p_account => 'XYZZY6',
                                                                 p_default_tablespace => 'TOOLS',
                                                                 p_profile => 'ND_USR_OPEN_DEFAULT');
    nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_create(p_account => 'XYZZY7', 
                                                                 p_profile => 'ND_USR_OPEN_DEFAULT');
    nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_create(p_account => 'XYZZY8',
                                                                 p_temporary_tablespace => 'TEMP',
                                                                 p_profile => 'ND_USR_OPEN_DEFAULT');
    nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_create(p_account => 'XYZZY9',
                                                                 p_default_tablespace => 'TOOLS',
                                                                 p_temporary_tablespace => 'TEMP',
                                                                 p_profile => 'ND_USR_OPEN_DEFAULT');

    -- failed to create any of the accounts
    if not nd_dba_util_admin.nd_dba_oracle_account_util.is_account('XYZZY1')
    or not nd_dba_util_admin.nd_dba_oracle_account_util.is_account('XYZZY2')
    or not nd_dba_util_admin.nd_dba_oracle_account_util.is_account('XYZZY3')
    or not nd_dba_util_admin.nd_dba_oracle_account_util.is_account('XYZZY4')
    or not nd_dba_util_admin.nd_dba_oracle_account_util.is_account('XYZZY5')
    or not nd_dba_util_admin.nd_dba_oracle_account_util.is_account('XYZZY6')
    or not nd_dba_util_admin.nd_dba_oracle_account_util.is_account('XYZZY7')
    or not nd_dba_util_admin.nd_dba_oracle_account_util.is_account('XYZZY8')
    or not nd_dba_util_admin.nd_dba_oracle_account_util.is_account('XYZZY9')
    then
        v_error_count := v_error_count + 1;
    end if;

    -- test proper ts, tts, profile on accounts
    -- ---------------------------------
    v_test_user := 'XYZZY1';
    select default_tablespace into v_ts
      from dba_users 
     where username = v_test_user;

    select temporary_tablespace into v_tts
      from dba_users 
     where username = v_test_user;

    select profile into v_profile
      from dba_users 
     where username = v_test_user;

    if v_ts != 'USERS' 
    or v_tts != 'TEMP'
    or v_profile != 'ND_USR_LOCK_DEFAULT' then
        v_error_count := v_error_count + 2;
    end if;

    -- ---------------------------------
    v_test_user := 'XYZZY2';
    select default_tablespace into v_ts
      from dba_users 
     where username = v_test_user;

    select temporary_tablespace into v_tts
      from dba_users 
     where username = v_test_user;

    select profile into v_profile
      from dba_users 
     where username = v_test_user;

    if v_ts != 'TOOLS' 
    or v_tts != 'TEMP'
    or v_profile != 'ND_USR_LOCK_DEFAULT' then
        v_error_count := v_error_count + 4;
    end if;

    -- ---------------------------------
    v_test_user := 'XYZZY3';
    select default_tablespace into v_ts
      from dba_users 
     where username = v_test_user;

    select temporary_tablespace into v_tts
      from dba_users 
     where username = v_test_user;

    select profile into v_profile
      from dba_users 
     where username = v_test_user;

    if v_ts != 'USERS' 
    or v_tts != 'TEMP'
    or v_profile != 'ND_USR_LOCK_DEFAULT' then
        v_error_count := v_error_count + 8;
    end if;
    
    -- ---------------------------------
    v_test_user := 'XYZZY4';
    select default_tablespace into v_ts
      from dba_users 
     where username = v_test_user;

    select temporary_tablespace into v_tts
      from dba_users 
     where username = v_test_user;

    select profile into v_profile
      from dba_users 
     where username = v_test_user;

    if v_ts != 'TOOLS' 
    or v_tts != 'TEMP'
    or v_profile != 'ND_USR_LOCK_DEFAULT' then
        v_error_count := v_error_count + 16;
    end if;

    -- ---------------------------------
    v_test_user := 'XYZZY5';
    select default_tablespace into v_ts
      from dba_users 
     where username = v_test_user;

    select temporary_tablespace into v_tts
      from dba_users 
     where username = v_test_user;

    select profile into v_profile
      from dba_users 
     where username = v_test_user;

    if v_ts != 'USERS' 
    or v_tts != 'TEMP'
    or v_profile != 'ND_USR_OPEN_DEFAULT' then
        v_error_count := v_error_count + 32;
    end if;

    -- ---------------------------------
    v_test_user := 'XYZZY6';
    select default_tablespace into v_ts
      from dba_users 
     where username = v_test_user;

    select temporary_tablespace into v_tts
      from dba_users 
     where username = v_test_user;

    select profile into v_profile
      from dba_users 
     where username = v_test_user;

    if v_ts != 'TOOLS' 
    or v_tts != 'TEMP'
    or v_profile != 'ND_USR_OPEN_DEFAULT' then
        v_error_count := v_error_count + 64;
    end if;

    -- ---------------------------------
    v_test_user := 'XYZZY7';
    select default_tablespace into v_ts
      from dba_users 
     where username = v_test_user;

    select temporary_tablespace into v_tts
      from dba_users 
     where username = v_test_user;

    select profile into v_profile
      from dba_users 
     where username = v_test_user;

    if v_ts != 'USERS' 
    or v_tts != 'TEMP'
    or v_profile != 'ND_USR_OPEN_DEFAULT' then
        v_error_count := v_error_count + 128;
    end if;

    -- ---------------------------------
    v_test_user := 'XYZZY8';
    select default_tablespace into v_ts
      from dba_users 
     where username = v_test_user;

    select temporary_tablespace into v_tts
      from dba_users 
     where username = v_test_user;

    select profile into v_profile
      from dba_users 
     where username = v_test_user;

    if v_ts != 'USERS' 
    or v_tts != 'TEMP'
    or v_profile != 'ND_USR_OPEN_DEFAULT' then
        v_error_count := v_error_count + 256;
    end if;

    -- ---------------------------------
    v_test_user := 'XYZZY9';
    select default_tablespace into v_ts
      from dba_users 
     where username = v_test_user;

    select temporary_tablespace into v_tts
      from dba_users 
     where username = v_test_user;

    select profile into v_profile
      from dba_users 
     where username = v_test_user;

     if v_ts != 'TOOLS'
     or v_tts != 'TEMP'
     or v_profile != 'ND_USR_OPEN_DEFAULT' then
        v_error_count := v_error_count + 512;
    end if;

    if v_error_count = 0
    then
        v_pass_fail := 'passed';
    end if;

    DBMS_OUTPUT.PUT_LINE(v_pass_fail || ' ora_acct_create ' || ' code: ' || to_char(v_error_count));

-- -----------------------------------------------------------------------------
--    procedure ora_acct_lock             (p_account in sys.dba_users.username%type);
    nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_lock(p_account => 'XYZZY1');

    v_pass_fail := 'failed';
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_account('XYZZY1')
    then
        select nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_status('XYZZY1') into v_account_status
          from dual;

        if v_account_status like '%LOCKED%'
        then
            v_pass_fail := 'passed';
        end if;
    end if;
    DBMS_OUTPUT.PUT_LINE(v_pass_fail || ' ora_acct_lock ');

-- -----------------------------------------------------------------------------
--    procedure ora_acct_drop             (p_account in sys.dba_users.username%type);
    nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_drop(p_account => 'XYZZY2');

    v_pass_fail := 'failed';
    if not nd_dba_util_admin.nd_dba_oracle_account_util.is_account('XYZZY2')
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE(v_pass_fail || ' ora_acct_drop ');

-- -----------------------------------------------------------------------------
--    procedure ora_acct_change_profile   (p_account in sys.dba_users.username%type
--                                        ,p_profile in sys.dba_users.profile%type);
    nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_change_profile(p_account => 'XYZZY3',
                                                                         p_profile => 'DEFAULT');
    v_pass_fail := 'failed';
    select profile into v_profile 
      from dba_users 
     where username = 'XYZZY3';

    if v_profile = 'DEFAULT'
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE(v_pass_fail || ' ora_acct_change_profile ');

-- -----------------------------------------------------------------------------
--    procedure ora_acct_change_tablespace(p_account in sys.dba_users.username%type
--                                        ,p_default_tablespace in sys.dba_users.default_tablespace%type default 'USERS'
--                                        ,p_temporary_tablespace in sys.dba_users.temporary_tablespace%type default 'TEMP');
    nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_change_tablespace('XYZZY3', 'TOOLS', 'TEMP');
    v_pass_fail := 'failed';

    v_test_user := 'XYZZY3';
    select default_tablespace into v_ts
      from dba_users 
     where username = v_test_user;

    select temporary_tablespace into v_tts
      from dba_users 
     where username = v_test_user;

     if  v_ts = 'TOOLS'
     and v_tts = 'TEMP' then
        v_pass_fail := 'passed';
    end if;

    DBMS_OUTPUT.PUT_LINE(v_pass_fail || ' ora_acct_change_tablespace ');

-- -----------------------------------------------------------------------------
--    procedure ora_acct_grant_role      (p_account in sys.dba_users.username%type
--                                        ,p_role  in sys.dba_roles.role%type);
    nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_grant_role('XYZZY4', 'ND_CONNECT_S_ROLE');
    v_pass_fail := 'failed';

    if nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_role('XYZZY4', 'ND_CONNECT_S_ROLE')
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE(v_pass_fail || ' ora_acct_grant_role');

-- -----------------------------------------------------------------------------
--    procedure ora_acct_grant_role_list (p_account in sys.dba_users.username%type
--                                        ,p_role_list in VARCHAR2);
    nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_grant_role_list('XYZZY5', 'ND_CONNECT_S_ROLE,ND_RESOURCE_S_ROLE');
    v_pass_fail := 'failed';

    if  nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_role('XYZZY5', 'ND_CONNECT_S_ROLE')
    and nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_has_role('XYZZY5', 'ND_RESOURCE_S_ROLE')
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE(v_pass_fail || ' ora_acct_grant_role_list');


-- -----------------------------------------------------------------------------
--    procedure ora_acct_change_default_role (p_account in sys.dba_users.username%type
--                                           ,p_role in sys.dba_roles.role%type);
    nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_change_default_role('XYZZY6', 'ND_RESOURCE_S_ROLE');
    v_pass_fail := 'failed';

    select default_role into v_yes_no
      from dba_role_privs 
     where grantee = 'XYZZY6'
       and granted_role = 'ND_RESOURCE_S_ROLE';

    if v_yes_no = 'YES'
    then
        v_pass_fail := 'passed';
    end if;
    DBMS_OUTPUT.PUT_LINE(v_pass_fail || ' ora_acct_change_default_role');

-- -----------------------------------------------------------------------------
--    procedure ora_acct_revoke_role      (p_account in sys.dba_users.username%type
--                                        ,p_role  in sys.dba_roles.role%type);

-- -----------------------------------------------------------------------------
--    procedure ora_acct_revoke_role_list (p_account in sys.dba_users.username%type
--                                        ,p_role_list in varchar2);

-- -----------------------------------------------------------------------------
--    procedure ora_acct_grant_sys_priv   (p_account in sys.dba_users.username%type
--                                        ,p_privilege in sys.system_privilege_map.name%type);

-- -----------------------------------------------------------------------------
--    procedure ora_acct_revoke_sys_priv  (p_account in sys.dba_users.username%type
--                                        ,p_privilege in sys.system_privilege_map.name%type);

-- -----------------------------------------------------------------------------
--    procedure ora_acct_grant_object_priv(p_account in sys.dba_users.username%type
--                                        ,p_owner in sys.dba_objects.owner%type
--                                        ,p_object_name in sys.dba_objects.object_name%type
--                                        ,p_object_privilege in sys.dba_tab_privs.privilege%type);

-- -----------------------------------------------------------------------------
--    procedure ora_acct_revoke_object_priv  (p_account in sys.dba_users.username%type
--                                           ,p_owner in sys.dba_objects.owner%type
--                                           ,p_object_name in sys.dba_objects.object_name%type
--                                           ,p_object_privilege in sys.dba_tab_privs.privilege%type);

end;
end;

