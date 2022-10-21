create or replace procedure nd_dba_util_admin.banner_remove_user (
    p_netid varchar2,
    --p_authorization varchar2,
	p_mode  varchar2 := 'SAFE'
)
is
-- ----------------------------------------------------------
-- FILE: banner_remove_user.sql
-- DESC: With a provided NetID create sql to remove user from banner
--       along with all assocated fund/org and Banner security data
--
-- audit trail
-- 2020-08-06 JGROVER - original code based on previous plsql developer logic
-- 2021-04-23 JGROVER - created as procedure rather than anonymous block
--                    - added auto/safe mode logic (defaults to safe ode)
--                    - added sorting column so sql comes out in the right order
-- 2022-06-17 JGROVER - fixed error where some revokes fail in auto mode
--                    - added back out script creation / audit table
-- ----------------------------------------------------------
begin
    declare

    v_netid         sys.dba_users.username%type := upper(p_netid);
    v_mode          varchar2(4)                 := upper(p_mode) ;
    --v_authorization varchar2(4)                 := upper(p_authorization) ;

--
-- Handle Banner privileges
-- ----------------------------------------------------------
--
-- 
--

    cursor c1 is
        with banner_privs as (
        select 10 sorter
              ,'delete from bansecr.gurucls where gurucls_userid = ''' || v_netid || '''' as sql_cmd
          from dual
         where exists (select 1 from bansecr.gurucls where gurucls_userid=v_netid)
        union
        select 10 sorter
              ,'delete from bansecr.guruobj where guruobj_userid = ''' || v_netid || '''' as sql_cmd
          from dual
         where exists (select 1 from bansecr.guruobj where guruobj_userid=v_netid)
        ),
--
-- Handle Fund/Org security
-- ----------------------------------------------------------
        fund_org_privs as (
        select 20 sorter 
              ,'delete from fimsmgr.fobprof where fobprof_user_id = ''' || v_netid || '''' as sql_cmd
          from dual
         where exists (select 1 from fimsmgr.fobprof where fobprof_user_id = v_netid) 
        union		 
        select 20 sorter 
              ,'delete from fimsmgr.forusfn where forusfn_user_id_entered = ''' || v_netid || '''' as sql_cmd
          from dual
         where exists (select 1 from fimsmgr.forusfn where forusfn_user_id_entered = v_netid) 
        union		 
        select 20 sorter 
              ,'delete from fimsmgr.forusor where forusor_user_id_entered = ''' || v_netid || '''' as sql_cmd
          from dual
         where exists (select 1 from fimsmgr.forusor where forusor_user_id_entered = v_netid) 
        union		 
        select 20 sorter 
              ,'delete from ndfiadmin.fzbzfop where fzbzfop_net_id = ''' || v_netid || '''' as sql_cmd
          from dual
         where exists (select 1 from ndfiadmin.fzbzfop where fzbzfop_net_id = v_netid) 
        union		 
        select 20 sorter 
              ,'delete from ndfiadmin.zownfop where zownfop_net_id = ''' || v_netid || '''' as sql_cmd
          from dual
         where exists (select 1 from ndfiadmin.zownfop where zownfop_net_id = v_netid) 
        ),
--
-- Handle Oracle privileges 
--   Redundant, drop cascade will do this.
--   Keeping for documentation.
-- ----------------------------------------------------------
        oracle_privs as (
        select 60 sorter
              ,'revoke ' || privilege || ' on ' || owner || '.' ||  table_name || '.' || column_name || ' from ' || grantee sql_cmd
          from sys.dba_col_privs
         where grantee = v_netid
        union
        select 40 sorter
              ,'revoke ' || granted_role || ' from ' || grantee
          from sys.dba_role_privs
         where grantee = v_netid
         union
        select 30 sorter
              ,'revoke ' || privilege || ' from ' || grantee
          from sys.dba_sys_privs
         where grantee = v_netid
        union
        select 50 sorter
              ,'revoke ' || privilege || ' on ' || owner || '.' ||  table_name || ' from ' || grantee
          from sys.dba_tab_privs
         where grantee = v_netid
        union
        select 99 sorter
              ,'drop user ' || username || ' cascade'
          from sys.dba_users
         where username = v_netid
        )
        select sorter, sql_cmd from banner_privs
        union
        select sorter, sql_cmd from fund_org_privs
        union
        select sorter, sql_cmd from oracle_privs
        order by sorter;

    begin
        dbms_output.enable();

        for r1 in c1 loop
--
-- Show sql commands created
-- ----------------------------------------------------------
            dbms_output.put_line(r1.sql_cmd || ';');

--
-- Execute sql commands created if mode is AUTO
-- ----------------------------------------------------------
            if  upper(p_mode) = 'AUTO'
            and not regexp_like(r1.sql_cmd, '^--') then
                execute immediate r1.sql_cmd ;
            end if ;

        end loop;

--
-- Commit the transaction if mode is AUTO
-- ----------------------------------------------------------
        if  upper(p_mode) = 'AUTO'
        then
            dbms_output.put_line( '-- auto mode enabled, committing work' );
            commit;
        else
             dbms_output.put_line( '-- auto mode disabled, no changes made' );
        end if;
	end;

--
-- NOTE: revokes and drop user are NOT rolled back.
-- ----------------------------------------------------------
exception
    when others then
    rollback;
    dbms_output.put_line( SQLERRM );

end banner_remove_user;
