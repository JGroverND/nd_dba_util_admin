CREATE or replace
procedure tmp_copy_role ( 
  p_old_role varchar2, 
  p_new_role varchar2 ) as
BEGIN
DECLARE
-- -------------------------------------
-- ROLE: Copy Existing Role
-- -------------------------------------
  cursor priv_cursor is 
  SELECT 'CREATE role ' || upper(p_new_role) sqlcmd
    FROM DUAL
-- ------------------------------------
  UNION
  SELECT 'grant ' || granted_role || ' to ' || upper(p_new_role) || decode(admin_option, 'YES', ' with admin option' ,'')
    FROM dba_role_privs
   WHERE grantee = upper(p_old_role)
-- -------------------------------------
  UNION
  SELECT 'grant ' || PRIVILEGE || ' to ' || upper(p_new_role) || decode(admin_option, 'YES', ' with admin option' ,'')
    FROM dba_sys_privs
   WHERE grantee = upper(p_old_role)
-- -------------------------------------
  UNION
  SELECT 'grant ' || PRIVILEGE || ' on ' || owner || '.' || table_name || ' to '  || upper(p_new_role) || decode(grantable, 'YES', ' with grant option', '')
    FROM dba_tab_privs
   WHERE grantee = upper(p_old_role)
-- -------------------------------------
  UNION
  SELECT 'grant ' || PRIVILEGE || '(' || column_name || ')' || ' on ' || owner || '.' || table_name || ' to ' || upper(p_new_role) || decode(grantable, 'YES', ' with grant option', '')
    FROM dba_col_privs
   WHERE grantee = upper(p_old_role) ;
   
  cursor grant_cursor is
  select 'grant ' || upper(p_new_role) || ' to ' || grantee || decode(admin_option, 'YES', ' with admin option', '') sqlcmd
    from dba_role_privs,
         dba_users
   where granted_role = upper(p_old_role) 
     and username = grantee
     and profile not like 'ND_SYS%';
   
  cursor revoke_cursor is
  select 'revoke ' || upper(p_old_role) || ' from ' || grantee sqlcmd
    from dba_role_privs,
         dba_users
   where granted_role = upper(p_old_role) 
     and username = grantee
     and profile not like 'ND_SYS%';
   
   
  BEGIN
    dbms_output.enable(10000000);
    
    for my_cursor_rec in priv_cursor
    loop
      -- dbms_output.put_line (my_cursor_rec.sqlcmd);
      execute immediate my_cursor_rec.sqlcmd ;
    end loop;

    for my_cursor_rec in grant_cursor
    loop
      --dbms_output.put_line (my_cursor_rec.sqlcmd);
      execute immediate my_cursor_rec.sqlcmd ;
    end loop;

    for my_cursor_rec in revoke_cursor
    loop
      --dbms_output.put_line (my_cursor_rec.sqlcmd);
      execute immediate my_cursor_rec.sqlcmd ;
    end loop;  
  END;
END tmp_copy_role ;
/

begin
  tmp_copy_role ('dba', 'nd_dba_s_role');
end;
/

drop procedure tmp_copy_role ;
exit ;
