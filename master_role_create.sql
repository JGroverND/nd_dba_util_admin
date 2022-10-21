-- ---------------------------------------------------------------------
-- File: sql/master_role_create.sql
-- Desc: Create all master roles for schema
--
-- Audit Trail:
-- dd-mon-yyyy  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
set serveroutput on
set linesize 512
set trimout on
BEGIN
DECLARE
  TYPE t_sql_code IS TABLE OF varchar2(256) INDEX BY BINARY_INTEGER ;

  t_execute  t_sql_code ;
  p_mode     varchar2(30)  := null ;
  p_schema   varchar2(30)  := null ;
  z_idx      number        := 0 ;
  z_schema   varchar2(30)  := null ;
  
  cursor s_cur is
  select owner c1, object_name c2
    from dba_objects
   where owner = p_schema
     and (object_type = 'TABLE'
      or object_type = 'VIEW'
      or object_type = 'SEQUENCE')
   order by 1,2 ;

  cursor u_cur is
  select owner c1, object_name c2
    from dba_objects
   where owner = p_schema
     and (object_type = 'TABLE'
      or object_type = 'VIEW' )
   order by 1,2 ;

  cursor x_cur is
  select owner c1, object_name c2
    from dba_objects
   where owner = p_schema
     and object_type in ('PACKAGE', 'PROCEDURE', 'FUNCTION')
   order by 1,2 ;

BEGIN
  dbms_output.enable(1000000) ;
  
  p_schema := upper('&1') ;
  p_mode := upper('&2') ;

  if regexp_like ( p_schema, '^ND_') then
    z_schema := substr(p_schema, 4, 16) ;
  else
    z_schema := substr(p_schema, 1, 16) ;
  end if;

  t_execute(1) := 'create role ' || 'nd_' || z_schema || '_all_q_role' ;
  t_execute(2) := 'create role ' || 'nd_' || z_schema || '_all_u_role' ;
  t_execute(3) := 'create role ' || 'nd_' || z_schema || '_all_x_role' ;

  for s_rec in s_cur
  LOOP
    z_idx := NVL (t_execute.LAST, 0) + 1 ;
    t_execute(z_idx) := 'grant select on ' || s_rec.c1 || '.' || s_rec.c2 || ' to nd_' || z_schema || '_all_q_role' ;
  END LOOP ;
  
  for u_rec in u_cur
  LOOP
    z_idx := NVL (t_execute.LAST, 0) + 1 ;
    t_execute(z_idx) := 'grant select, update, insert, delete on ' || u_rec.c1 || '.' || u_rec.c2 || ' to nd_' || z_schema || '_all_u_role' ;
  END LOOP ;
  
  for x_rec in x_cur
  LOOP
    z_idx := NVL (t_execute.LAST, 0) + 1 ;
    t_execute(z_idx) := 'grant execute on ' || x_rec.c1 || '.' || x_rec.c2 || ' to nd_' || z_schema || '_all_x_role';
  END LOOP ;
  
  for z_idx in t_execute.FIRST .. t_execute.LAST loop
    if t_execute.EXISTS(z_idx) then
      if p_mode = 'AUTO' then
        execute immediate t_execute(z_idx) ;
      end if;
      
      dbms_output.put_line( t_execute(z_idx) || ' ;' );
    end if;
  end loop;
  
  dbms_output.put_line('-- processed ' || t_execute.LAST || ' grants for ' || p_schema || ' in ' || p_mode || ' mode' ) ;
END ;
END ;
--
--
--

