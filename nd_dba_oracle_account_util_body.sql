create or replace package body nd_dba_util_admin.nd_dba_oracle_account_util
IS
-- -----------------------------------------------------------------------------
-- file: nd_dba_oracle_account_util_body.sql
-- desc: 
--
-- audit trail
-- October 2022 John W Grover
--  - Original Code
--
-- -----------------------------------------------------------------------------

-- C U R S O R S

-- V A R I A B L E S

-- F U N C T I O N S
 
-- -----------------------------------------------------------------------------
-- Binary functions. NOTE: Return of True guarantees objects exists and are of
--                         the type desired. A return of False DOES NOT indicate
--                         that the object indicated by a parameter exists
--                         (i.e. account, role, etc.). Existence should be 
--                         validated separately.
-- -----------------------------------------------------------------------------

function is_account (p_account in sys.dba_users.username%type) return boolean is
begin
declare
    v_count number := 0;
    begin
        select count(username) into v_count 
          from dba_users
         where username = upper(p_account);
        
        if v_count > 0 then
            return true;
        else
            return false;
        end if;
    end;
end is_account;
-- -----------------------------------------------------------------------------

function is_role (p_role in sys.dba_roles.role%type) return boolean is
begin
declare
    v_count number := 0;
    begin
        select count(role) into v_count 
          from dba_roles
         where role = upper(p_role);
        
        if v_count > 0 then
            return true;
        else
            return false;
        end if;
    end;
end is_role;
-- -----------------------------------------------------------------------------

function is_sys_priv(p_privilege in sys.system_privilege_map.name%type) return boolean is
begin
declare
    v_count number := 0;
    begin
        select count(name) into v_count 
          from sys.system_privilege_map
         where name = upper(p_privilege);

        if v_count > 0 then
            return true;
        else
            return false;
        end if;
    end;
end is_sys_priv;
-- -----------------------------------------------------------------------------

function is_object (p_owner in sys.dba_objects.owner%type
                   ,p_object_name in sys.dba_objects.object_name%type) return boolean is
begin
declare
    v_count number := 0;
    begin
        select count(object_name) into v_count 
          from sys.dba_objects
         where owner = upper(p_owner)
           and object_name = upper(p_object_name);

        if v_count > 0 then
            return true;
        else
            return false;
        end if;
    end;
end is_object;
-- -----------------------------------------------------------------------------

function is_profile (p_profile in sys.dba_profiles.profile%type) return boolean is
begin
declare
    v_count number := 0;
    begin
        select count(profile) into v_count 
          from sys.dba_profiles
         where profile = upper(p_profile);
        
        if v_count > 0 then
            return true;
        else
            return false;
        end if;
    end;
end is_profile;
-- -----------------------------------------------------------------------------

function is_tablespace (p_tablespace in sys.dba_tablespaces.tablespace_name%type) return boolean is
begin
declare
    v_count number := 0;
    begin
        select count(tablespace_name) into v_count 
          from sys.dba_tablespaces
         where upper(tablespace_name) = upper(p_tablespace);
        
        if v_count > 0 then
            return true;
        else
            return false;
        end if;
    end;
end is_tablespace;
-- -----------------------------------------------------------------------------

function is_person_acct (p_account in dba_users.username%type) return boolean is
-- person account defined as having a ND_USR% profile.
--   (nd_dba_banner_util has a more refined check for using in Banner databases)
begin
declare
    v_count number := 0;
    begin
        select count(username) into v_count
          from sys.dba_users
         where username = upper(p_account)
           and profile like 'ND_USR%';

        if v_count > 0 then
            return true;
        else
            return false;
        end if;
    end;
end is_person_acct;
-- -----------------------------------------------------------------------------

function is_sys_acct (p_account in dba_users.username%type) return boolean is
-- system account defined as being oracle maintained in dba_users
begin
declare
    v_count number := 0;
    begin
        select count(username) into v_count
          from dba_users
         where username = upper(p_account)
           and oracle_maintained = 'Y';

        if v_count > 0 then
            return true;
        else
            return false;
        end if;
    end;
end is_sys_acct;
-- -----------------------------------------------------------------------------

function is_owner_acct (p_account in dba_users.username%type) return boolean is
-- owner account defined as being owner of any database object
--  note: may need to refine by excluding certain object types
begin
declare
    v_count number := 0;
    begin
        select count(owner) into v_count
          from sys.dba_objects
         where owner = upper(p_account);

        if v_count > 0 then
            return true;
        else
            return false;
        end if;
    end;
end is_owner_acct;
-- -----------------------------------------------------------------------------

function is_link_acct (p_account in dba_users.username%type) return boolean is
-- link account defines as already being defined as a link account.
--    it's circular, but the best we can do
begin
declare
    v_count number := 0;
    begin
        select count(username) into v_count
          from dba_users
         where username = upper(p_account)
           and profile = 'ND_LNK_OPEN_DEFAULT';

        if v_count > 0 then
            return true;
        else
            return false;
        end if;
    end;
end is_link_acct;
-- -----------------------------------------------------------------------------

function ora_acct_has_role (p_account in sys.dba_users.username%type,
                            p_role in sys.dba_roles.role%type) return boolean is
begin
declare
    v_count number := 0;
    begin
        select count(granted_role) into v_count 
          from dba_role_privs
         where grantee = upper(p_account)
           and granted_role = upper(p_role);
        
        if v_count > 0 then
            return true;
        else
            return false;
        end if;
    end;
end ora_acct_has_role;
-- -----------------------------------------------------------------------------

function ora_acct_has_sys_priv  (p_account in sys.dba_users.username%type
                                ,p_privilege in sys.system_privilege_map.name%type) return boolean is
begin
declare
    v_count number := 0;
    begin
        select count(privilege) into v_count 
          from sys.dba_sys_privs
         where grantee = upper(p_account)
           and privilege = upper(p_privilege);

        if v_count > 0 then
            return true;
        else
            return false;
        end if;
    end;
end ora_acct_has_sys_priv;
-- -----------------------------------------------------------------------------

function ora_acct_has_object_priv (p_account in sys.dba_users.username%type
                                  ,p_owner in sys.dba_objects.owner%type
                                  ,p_object_name in sys.dba_objects.object_name%type
                                  ,p_object_privilege in sys.dba_tab_privs.privilege%type) return boolean is
begin
declare
    v_count number := 0;
    v_object_privilege sys.dba_tab_privs.privilege%type;
    begin
        select count(privilege) into v_count
          from sys.dba_tab_privs
         where grantee = upper(p_account)
           and owner = upper(p_owner)
           and table_name = upper(p_object_name)
           and privilege = upper(p_object_privilege);

        if v_count > 0 then
            return true;
        else
            return false;
        end if;
    end;
end ora_acct_has_object_priv;
-- -----------------------------------------------------------------------------
-- Non-binary functions
--   As opposed to the binary functions, non-binary functions validate the input
--   parameters and raise an Oracle error on failure.
-- -----------------------------------------------------------------------------

function ora_acct_status (p_account in sys.dba_users.username%type) return sys.dba_users.account_status%type is
begin
declare
    v_account_status sys.dba_users.account_status%type;
    begin
        if not is_account(p_account)
        then
            raise e_invalid_account;
        end if;

        select account_status into v_account_status
          from sys.dba_users
         where username = upper(p_account);
        
        return v_account_status;

        exception
        when e_invalid_account then
            raise_application_error(-20002, 'Account does not exist');
    end;
end ora_acct_status;
-- -----------------------------------------------------------------------------

function ora_acct_suggest_profile (p_account in sys.dba_users.username%type) return sys.dba_users.profile%type is

-- Oracle Profiles Naming Convention:
-- The naming convention for Oracle profiles is intended to indicate at a glance what 
-- privileges an account can be expected to have and how it is allowed to be used. 
-- Accounts should be one of five types; system, owner, application, link or user, 
-- and have a default state of locked or unlocked. The named will be comprised 
-- of “nodes” separated by underbars.
--
-- The first node will always be ND
-- The second node will indicate the account type (SYS, OWN, APP, LNK, USR)
-- The third node will indicate the default lock state (LOCK, OPEN)
-- The last node will be a brief description identifying the profile
--
-- nd_dba_banner_util has a more refined profile suggestion
begin
declare
    v_account_prefix            varchar2(32);
    v_account_state             varchar2(32);
    v_account_type              varchar2(32);
    v_account_status            varchar2(32);

    v_is_sys_acct               boolean := is_sys_acct(p_account);
    v_is_link_acct              boolean := is_link_acct(p_account);
    v_is_owner_acct             boolean := is_owner_acct(p_account);
    v_is_person_acct            boolean := is_person_acct(p_account);
    begin
        if not is_account(p_account)
        then
            raise e_invalid_account;
        end if;

        --
        -- choose the prefix
        --
        if v_is_sys_acct then
            v_account_prefix := 'SYS';
        else
            if v_is_link_acct then
                v_account_prefix := 'LNK';
            else 
                if v_is_owner_acct then
                    v_account_prefix := 'OWN';
                else
                    if v_is_person_acct then
                        v_account_prefix := 'USR';
                    else
                        v_account_prefix := 'APP';
                    end if;
                end if;
            end if;
        end if;

        -- choose account status
        select account_status into v_account_status 
        from sys.dba_users 
        where username = upper(p_account);

        -- default to LOCK state
        v_account_state := 'LOCK';

        -- these accounts are open by default
        if (v_is_sys_acct and v_account_status like '%OPEN%')   -- open oracle built-in accounts set as open
        or v_is_link_acct                                       -- open link accounts
        or v_account_prefix in ('APP', 'USR')
        then 
            v_account_state := 'OPEN';
        end if;

        -- Choose account type
        v_account_type := 'DEFAULT';

        if (v_is_sys_acct)
        then 
            v_account_type := 'ORACLE';
        end if;

        -- put all the pieces together
        return 'ND_' || v_account_prefix || '_' || v_account_state || '_' || v_account_type;

        exception
        when e_invalid_account
        then
            raise_application_error(-20002, 'Account does not exist');
    end;
end ora_acct_suggest_profile;
-- -----------------------------------------------------------------------------

function ora_object_type (p_owner in sys.dba_objects.owner%type
                         ,p_object_name in sys.dba_objects.object_name%type) return sys.dba_objects.object_type%type is
begin
declare
    v_object_type sys.dba_objects.object_type%type;
    begin
        if not is_object(p_owner, p_object_name)
        then
            raise e_invalid_object_name;
        end if;

        -- eliminate object types with multiple owner/name rows
        select a.object_type into v_object_type
          from sys.dba_objects a
         where a.owner = upper(p_owner)
           and a.object_name = upper(p_object_name)
           and object_type not in('TABLE PARTITION', 'TABLE SUBPARTITION', 'INDEX PARTITION', 'LOB PARTITION', 'PACKAGE BODY', 'TYPE');

        return v_object_type;

        exception
        when e_invalid_object_name then
            raise_application_error(-20012, 'Object does not exist');
    end;
end ora_object_type;
-- -----------------------------------------------------------------------------
-- P R O C E D U R E S
-- -----------------------------------------------------------------------------

procedure ora_acct_create   (p_account in sys.dba_users.username%type
                            ,p_default_tablespace in sys.dba_users.default_tablespace%type default 'USERS'
                            ,p_temporary_tablespace in sys.dba_users.temporary_tablespace%type default 'TEMP'
                            ,p_profile in sys.dba_users.profile%type default 'ND_USR_LOCK_DEFAULT') IS
begin

    if is_account(p_account)
    then
        raise e_account_exists;
    end if;

    if not is_tablespace(p_default_tablespace)
    then
        raise e_invalid_tablespace;
    end if;

    if not is_tablespace(p_temporary_tablespace)
    then
        raise e_invalid_tablespace;
    end if;

    if not is_profile(p_profile)
    then
        raise e_invalid_profile;
    end if;

    execute immediate 'create user ' || 
                      p_account || 
                      ' identified by ' || 
                      f_gen_password() || 
                      ' default tablespace ' || 
                      p_default_tablespace ||
                      ' temporary tablespace ' ||
                      p_temporary_tablespace;

    exception
    when e_account_exists then
        raise_application_error(-20001, 'Account already exists');
    when e_invalid_tablespace then
        raise_application_error(-20010, 'Invalid tablespace');
    when e_invalid_profile then
        raise_application_error(-20009, 'Invalid profile');

end ora_acct_create;
-- -----------------------------------------------------------------------------

procedure ora_acct_lock (p_account in sys.dba_users.username%type) is
begin
    if not is_account(p_account)
    then
        raise e_invalid_account;
    end if;

    execute immediate 'alter user ' || p_account || ' account lock password expire';

    exception
        when e_invalid_account then
            raise_application_error(-20001, 'Account does not exist');

end ora_acct_lock;
-- -----------------------------------------------------------------------------

procedure ora_acct_drop (p_account in sys.dba_users.username%type) is
begin
    if not is_account(p_account)
    then
        raise e_invalid_account;
    end if;

    execute immediate 'drop user ' || p_account || ' cascade';

    exception
    when e_invalid_account then
        raise_application_error(-20001, 'Account does not exist');

end ora_acct_drop;
-- -----------------------------------------------------------------------------

procedure ora_acct_change_profile   (p_account in sys.dba_users.username%type
                                    ,p_profile in sys.dba_users.profile%type) is
begin
    if not is_account(p_account)
    then
        raise e_invalid_account;
    end if;

    if not is_profile(p_profile)
    then
        raise e_invalid_profile;
    end if;

    execute immediate 'alter user ' ||
                      p_account ||
                      ' profile ' ||
                      p_profile;

    exception
    when e_invalid_account then
        raise_application_error(-20002, 'Account does not exist');
    when e_invalid_profile then
        raise_application_error(-20009, 'Invalid profile');

end ora_acct_change_profile;
-- -----------------------------------------------------------------------------

procedure ora_acct_change_tablespace(p_account in sys.dba_users.username%type
                                    ,p_default_tablespace in sys.dba_users.default_tablespace%type default 'USERS'
                                    ,p_temporary_tablespace in sys.dba_users.temporary_tablespace%type default 'TEMP') is
begin
    if not is_account(p_account)
    then
        raise e_invalid_account;
    end if;

    if not is_tablespace(p_default_tablespace)
    then
        raise e_invalid_tablespace;
    end if;

    if not is_tablespace(p_temporary_tablespace)
    then
        raise e_invalid_tablespace;
    end if;

    execute immediate 'alter user ' ||
                      p_account ||
                      ' default tablespace ' ||
                      p_default_tablespace ||
                      ' temporary tablespace ' ||
                      p_temporary_tablespace;

    exception
    when e_invalid_account then
        raise_application_error(-20002, 'Invalid account');
    when e_invalid_tablespace then
        raise_application_error(-20010, 'Invalid tablespace');

end ora_acct_change_tablespace;
-- -----------------------------------------------------------------------------

procedure ora_acct_grant_role (p_account in sys.dba_users.username%type, 
                               p_role  in sys.dba_roles.role%type) IS
begin
    if not is_account(p_account)
    then
        raise e_invalid_account;
    end if;

    if not is_role(p_role)
    then
        raise e_invalid_role;
    end if;

    execute immediate 'grant ' || 
                      p_role || 
                      ' to ' || 
                      p_account;

    exception
    when e_invalid_account then
        raise_application_error(-20001, 'Account does not exist');
    when e_invalid_role then
        raise_application_error(-20002, 'Role does not exist');

end ora_acct_grant_role;
-- -----------------------------------------------------------------------------

procedure ora_acct_grant_role_list  (p_account in sys.dba_users.username%type, 
                                     p_role_list in varchar2) IS
  v_roles varchar2(1000) := upper(p_role_list);

  cursor c1 is
    select regexp_substr(v_roles, '[^,]+', 1, level) role_name
      from dual
   connect by regexp_substr(v_roles, '[^,]+', 1, level) is not null;

  c1_rec c1%rowtype;
  
begin
    open c1;
    loop
        fetch c1 into c1_rec;
        exit when c1%notfound;
        ora_acct_grant_role(p_account, c1_rec.role_name);
    end loop;
    close c1;
    
end ora_acct_grant_role_list;
-- -----------------------------------------------------------------------------

procedure ora_acct_change_default_role (p_account in sys.dba_users.username%type,
                                        p_role in sys.dba_roles.role%type) is
begin
    if not is_account(p_account)
    then
        raise e_invalid_account;
    end if;

    if not is_role(p_role)
    then
        raise e_invalid_role;
    end if;

    if not ora_acct_has_role(p_account, p_role)
    then
        ora_acct_grant_role(p_account, p_role);
    end if;

    execute immediate 'alter user ' ||
                      p_account ||
                      ' default role ' ||
                      p_role;

    exception
    when e_invalid_account then
        raise_application_error(-20001, 'Account does not exist');
    when e_invalid_role then
        raise_application_error(-20002, 'Role does not exist');

end ora_acct_change_default_role;
-- -----------------------------------------------------------------------------

procedure ora_acct_revoke_role (p_account in sys.dba_users.username%type, 
                               p_role  in sys.dba_roles.role%type) IS
begin
    if not is_account(p_account)
    then
        raise e_invalid_account;
    end if;

    if not is_role(p_role)
    then
        raise e_invalid_role;
    end if;

    if ora_acct_has_role(p_account, p_role)
    then
        execute immediate 'revoke ' || 
                        p_role || 
                        ' from ' || 
                        p_account;
    end if;

    exception
    when e_invalid_account then
        raise_application_error(-20001, 'Account does not exist');
    when e_invalid_role then
        raise_application_error(-20002, 'Role does not exist');

end ora_acct_revoke_role;
-- -----------------------------------------------------------------------------

procedure ora_acct_revoke_role_list  (p_account in sys.dba_users.username%type, 
                                     p_role_list in varchar2) IS
  v_roles varchar2(1000) := upper(p_role_list);

  cursor c1 is
    select regexp_substr(v_roles, '[^,]+', 1, level) role_name
      from dual
   connect by regexp_substr(v_roles, '[^,]+', 1, level) is not null;

  c1_rec c1%rowtype;
  
begin
  open c1;
  loop
    fetch c1 into c1_rec;
    exit when c1%notfound;
    ora_acct_revoke_role(p_account, c1_rec.role_name);
  end loop;
  close c1;
    
end ora_acct_revoke_role_list;
-- -----------------------------------------------------------------------------

procedure ora_acct_grant_sys_priv   (p_account in sys.dba_users.username%type
                                    ,p_privilege in sys.system_privilege_map.name%type) is
begin
    if not is_account(p_account)
    then
        raise e_invalid_account;
    end if;

    if not is_sys_priv(p_privilege)
    then
        raise e_invalid_sys_priv;
    end if;

    if not ora_acct_has_sys_priv(p_account, p_privilege)
    then
        execute immediate 'grant ' || 
                        p_privilege || 
                        ' to ' || 
                        p_account;
    end if;

    exception
    when e_invalid_account then
        raise_application_error(-20001, 'Account does not exist');
    when e_invalid_sys_priv then
        raise_application_error(-20011, 'System privilege does not exist');

end ora_acct_grant_sys_priv;
-- -----------------------------------------------------------------------------

procedure ora_acct_revoke_sys_priv  (p_account in sys.dba_users.username%type
                                    ,p_privilege in sys.system_privilege_map.name%type) is
begin
    if not is_account(p_account)
    then
        raise e_invalid_account;
    end if;

    if not is_sys_priv(p_privilege)
    then
        raise e_invalid_sys_priv;
    end if;

    if ora_acct_has_sys_priv(p_account, p_privilege)
    then
        execute immediate 'revoke ' || 
                        p_privilege || 
                        ' from ' || 
                        p_account;
    end if;

    exception
    when e_invalid_account then
        raise_application_error(-20001, 'Account does not exist');
    when e_invalid_sys_priv then
        raise_application_error(-20011, 'System privilege does not exist');

end ora_acct_revoke_sys_priv;
-- -----------------------------------------------------------------------------

procedure ora_acct_grant_object_priv(p_account in sys.dba_users.username%type
                                    ,p_owner in sys.dba_objects.owner%type
                                    ,p_object_name in sys.dba_objects.object_name%type
                                    ,p_object_privilege in sys.dba_tab_privs.privilege%type) is
    v_object_type sys.dba_objects.object_type%type;
begin
    if not is_account(p_account)
    then
        raise e_invalid_account;
    end if;

    if not is_object (p_owner, p_object_name)
    then
        raise e_invalid_object_name;
    end if;

    v_object_type := ora_object_type(p_owner, p_object_name);

    -- package supports limited object types and privileges
    if v_object_type not in ('DIRECTORY', 'FUNCTION', 'PROCEDURE', 'PACKAGE', 'SEQUENCE', 'TABLE', 'VIEW')
    then
        raise e_unsupported_obj_priv;
    end if;

    if v_object_type = 'DIRECTORY'
    and upper(p_object_privilege) not in ('READ', 'WRITE', 'EXECUTE')
    then
        raise e_unsupported_obj_priv;
    end if;

    if v_object_type in ('FUNCTION', 'PROCEDURE', 'PACKAGE')
    and upper(p_object_privilege) not in ('DEBUG', 'EXECUTE')
    then
        raise e_unsupported_obj_priv;
    end if;

    if v_object_type = 'SEQUENCE'
    and upper(p_object_privilege) not in ('ALTER', 'SELECT')
    then
        raise e_unsupported_obj_priv;
    end if;

    if v_object_type = 'TABLE'
    and upper(p_object_privilege) not in ('ALTER', 'DELETE', 'INSERT', 'REFERENCES', 'SELECT', 'UPDATE')
    then
        raise e_unsupported_obj_priv;
    end if;

    if v_object_type = 'VIEW'
    and upper(p_object_privilege) not in ('DEBUG', 'REFERENCES', 'SELECT')
    then
        raise e_unsupported_obj_priv;
    end if;

    execute immediate 'grant ' ||
                      p_object_privilege ||
                      ' on ' ||
                      p_owner ||
                      '.' ||
                      p_object_name ||
                      ' to ' ||
                      p_account;

    exception
    when e_invalid_account then
        raise_application_error(-20001, 'Account does not exist');
    when e_invalid_object_name then
        raise_application_error(-20012, 'Invalid object name');
    when e_unsupported_obj_priv then
        raise_application_error(-20013, 'Unsupported object/privilege');

end ora_acct_grant_object_priv;
-- -----------------------------------------------------------------------------

procedure ora_acct_revoke_object_priv (p_account in sys.dba_users.username%type
                                      ,p_owner in sys.dba_objects.owner%type
                                      ,p_object_name in sys.dba_objects.object_name%type
                                      ,p_object_privilege in sys.dba_tab_privs.privilege%type) is
    v_object_type sys.dba_objects.object_type%type;
begin
    if not is_account(p_account)
    then
        raise e_invalid_account;
    end if;

    if not is_object (p_owner, p_object_name)
    then
        raise e_invalid_object_name;
    end if;

    v_object_type := ora_object_type(p_owner, p_object_name);

    if ora_acct_has_object_priv (p_account, p_owner, p_object_name, p_object_privilege)
    then
        execute immediate 'revoke ' ||
                        p_object_privilege ||
                        ' on ' ||
                        p_owner ||
                        '.' ||
                        p_object_name ||
                        ' from ' ||
                        p_account;
    end if;

    exception
    when e_invalid_account then
        raise_application_error(-20001, 'Account does not exist');
    when e_invalid_object_name then
        raise_application_error(-20012, 'Invalid object name');

end ora_acct_revoke_object_priv;
-- -----------------------------------------------------------------------------

-- ora_acct_clone_acct(acct, clone)
-- -----------------------------------------------------------------------------
--                                                   E N D   O F   P A C K A G E
-- -----------------------------------------------------------------------------
end nd_dba_oracle_account_util;
