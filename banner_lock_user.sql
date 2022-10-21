create or replace procedure                   banner_lock_user (
    p_netid varchar2,
    p_profile varchar2 := 'ND_USR_LOCK_DEFULT',
	p_mode  varchar2 := 'SAFE'
)
is
-- ----------------------------------------------------------
-- FILE: banner_lock_user.sql
-- DESC: With a provided NetID and profile create sql to lock
--       and profile the user account
--
-- audit trail
-- 2021-05-20 JGROVER - original code based on previous plsql developer logic
-- ----------------------------------------------------------
begin
    declare

    v_netid   sys.dba_users.username%type := upper(p_netid);
    v_profile sys.dba_users.profile%type  := upper(p_profile);
    v_mode    varchar2(4)                 := upper(p_mode);

    cursor c1 is
        select 'ALTER USER ' || username || 
               ' identified by '|| f_gen_password(30) || 
               ' profile ' || v_profile ||
               ' account lock password expire' as sql_cmd
          from sys.dba_users
         where username = v_netid;
        
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
            dbms_output.put_line( '-- auto mode enabled, user altered' );
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

end banner_lock_user;