-- -------------------------------------
-- USER: Clone User
-- -------------------------------------
SELECT SQL from(
	SELECT 0 as seq,
		   'CREATE user '
		   || upper(:NEW_USER) 
		   || ' identified by '
		   || f_gen_password()
		   || ' ;' as SQL
	  FROM DUAL
	 WHERE ( NOT EXISTS (SELECT 1
						   FROM sys.dba_users
						  WHERE username = upper(:NEW_USER)))
	   AND ( EXISTS (SELECT 1
					   FROM saturn.spriden
					  WHERE spriden_id = UPPER (:NEW_USER)))
					  
-- -------------------------------------
UNION
	SELECT 5,
		   'alter user ' 
		   || upper(:NEW_USER)
		   || ' default tablespace '
		   || default_tablespace
		   || ' temporary tablespace '
		   || temporary_tablespace
		   || ' profile '
		   || PROFILE
		   || ' account unlock ;'
	  FROM sys.dba_users
	 WHERE username = UPPER(:OLD_USER)

-- -------------------------------------
UNION
	SELECT 10,
		   'grant ' 
		   || granted_role 
		   || ' to ' 
		   || upper(:NEW_USER) 
		   || ' ;'
	  FROM sys.dba_role_privs
	 WHERE grantee = UPPER(:OLD_USER)
	 
-- -------------------------------------
UNION
	SELECT 10,
		   'grant ' 
		   || PRIVILEGE 
		   || ' to ' 
		   || upper(:NEW_USER) 
		   || ' ;'
	  FROM sys.dba_sys_privs
	 WHERE grantee = UPPER(:OLD_USER)
	 
-- -------------------------------------
UNION
	SELECT 10,
		   'grant '
		   || PRIVILEGE
		   || ' on '
           || case when PRIVILEGE in ('READ', 'WRITE') then 'directory ' else null end
		   || owner
		   || '.'
		   || table_name
		   || ' to ' 
		   || upper(:NEW_USER) 
		   || ' ;'
	  FROM sys.dba_tab_privs
	 WHERE grantee = UPPER(:OLD_USER)
	 
-- -------------------------------------
UNION
	SELECT 10,
		   'grant '
		   || PRIVILEGE
		   || '('
		   || column_name
		   || ')'
		   || ' on '
		   || owner
		   || '.'
		   || table_name
		   || ' to ' 
		   || upper(:NEW_USER) 
		   || ' ;'
	  FROM sys.dba_col_privs
	 WHERE grantee = UPPER(:OLD_USER)

-- -------------------------------------
UNION
	SELECT 15,
		   'ALTER USER '
		   || UPPER(:NEW_USER)
		   || ' DEFAULT ROLE ALL EXCEPT ban_default_q, ban_default_m ;'
	  from dual

-- -------------------------------------
UNION
	SELECT 15,
		   'ALTER USER '
		   || UPPER(:NEW_USER)
		   || ' grant connect through banproxy ;'
	  from dual

-- -------------------------------------
UNION
	SELECT 15,
		   'ALTER USER '
		   || UPPER(:NEW_USER)
		   || ' grant connect through banjsproxy ;'
	  from dual

-- -------------------------------------
UNION
	SELECT 20,
		   'insert into general.gobeacc (GOBEACC_PIDM, GOBEACC_USERNAME, GOBEACC_USER_ID, GOBEACC_ACTIVITY_DATE) values ('''
		   || s.spriden_pidm
		   || ''','''
		   || UPPER (:NEW_USER)
		   || ''', '''
		   || user
		   || ''', SYSDATE);  --'
		   || s.spriden_last_name
		   || ', '
		   || s.spriden_first_name
	  FROM saturn.spriden s, dual
	 WHERE s.spriden_id = UPPER(:NEW_USER)
	   AND NOT EXISTS (SELECT 1
						 FROM general.gobeacc
						WHERE gobeacc_pidm = s.spriden_pidm)
 
-- -------------------------------------
UNION
	SELECT 25,
		   'insert into bansecr.gurucls (GURUCLS_USERID,GURUCLS_CLASS_CODE,GURUCLS_ACTIVITY_DATE) values ('''
		   || UPPER (:NEW_USER)
		   || ''', '''
		   || gurucls_class_code
		   || ''', sysdate ) ;'
	  FROM bansecr.gurucls, dual
	 WHERE gurucls_userid = UPPER(:OLD_USER)

-- -------------------------------------
UNION
	SELECT 30,
		   'insert into bansecr.guruobj values ('''
		   || guruobj_object
		   || ''','''
		   || guruobj_role
		   || ''','''
		   || UPPER (:NEW_USER)
		   || ''',sysdate, '''
		   || user
		   || ''', null, null) ;'
	  FROM bansecr.guruobj, dual
	 WHERE guruobj_userid = UPPER(:OLD_USER)

-- -------------------------------------
--UNION
--	select 35, 
--		   '-- Finance Security - DBAs must apply on recreate'
--	from dual
--
---- ----------------------------------------
--UNION
--	SELECT 40,
--		   'insert into ndfiadmin.zownfop (ZOWNFOP_NET_ID,ZOWNFOP_FUND_CODE,ZOWNFOP_ORGN_CODE,ZOWNFOP_ACCESS_CODE,ZOWNFOP_RSPA_NAME,ZOWNFOP_ACTIVITY_DATE,ZOWNFOP_ACCOUNT_CODE,ZOWNFOP_PROG_CODE,ZOWNFOP_PROTECTED,ZOWNFOP_RTYP_CODE)values ('''
--		   || upper(:NEW_USER)
--		   || ''', '''
--			 || z.ZOWNFOP_FUND_CODE
--		   || ''', '''
--			 || z.ZOWNFOP_ORGN_CODE
--		   || ''', '''
--			 || z.ZOWNFOP_ACCESS_CODE
--		   || ''', '''
--			 || z.ZOWNFOP_RSPA_NAME
--		   || ''', '''
--			 || z.ZOWNFOP_ACTIVITY_DATE
--		   || ''', '''
--			 || z.ZOWNFOP_ACCOUNT_CODE
--		   || ''', '''
--			 || z.ZOWNFOP_PROG_CODE
--		   || ''', '''
--			 || z.ZOWNFOP_PROTECTED
--		   || ''', '''
--			 || z.ZOWNFOP_RTYP_CODE 
--		   || ''');' 
--	  FROM ndfiadmin.zownfop z
--	 WHERE z.ZOWNFOP_NET_ID = UPPER(:OLD_USER)
--
---- ----------------------------------------
--UNION
--	SELECT 42,
--		   'insert into ndfiadmin.fzbzfop (FZBZFOP_NET_ID,FZBZFOP_FUND_CODE,FZBZFOP_ORGN_CODE,FZBZFOP_ACCESS_CODE,FZBZFOP_RSPA_NAME,FZBZFOP_ACTIVITY_DATE,FZBZFOP_ACCOUNT_CODE,FZBZFOP_PROG_CODE,FZBZFOP_PROTECTED,FZBZFOP_RTYP_CODE) values ('''
--		   || upper(:NEW_USER)
--		   || ''', '''
--		   || q.FZBZFOP_FUND_CODE
--		   || ''', '''
--		   || q.FZBZFOP_ORGN_CODE
--		   || ''', '''
--		   || q.FZBZFOP_ACCESS_CODE
--		   || ''', '''
--		   || q.FZBZFOP_RSPA_NAME
--		   || ''', '''
--		   || q.FZBZFOP_ACTIVITY_DATE
--		   || ''', '''
--		   || q.FZBZFOP_ACCOUNT_CODE
--		   || ''', '''
--		   || q.FZBZFOP_PROG_CODE
--		   || ''', '''
--		   || q.FZBZFOP_PROTECTED
--		   || ''', '''
--		   || q.FZBZFOP_RTYP_CODE
--		   || '''); '
--	  FROM ndfiadmin.fzbzfop q
--	 WHERE q.FZBZFOP_NET_ID = UPPER(:OLD_USER)
--
---- ----------------------------------------
--UNION
--	SELECT 44,
--		   'insert into fimsmgr.FORUSOR (FORUSOR_USER_ID_ENTERED,FORUSOR_COAS_CODE,FORUSOR_ORGN_CODE,FORUSOR_ACCESS_IND,FORUSOR_ACTIVITY_DATE,FORUSOR_USER_ID,FORUSOR_WBUD_ACCESS_IND)values ('''
--		   || upper(:NEW_USER)
--		   || ''', '''
--		   || w.FORUSOR_COAS_CODE
--		   || ''', '''
--		   || w.FORUSOR_ORGN_CODE
--		   || ''', '''
--		   || w.FORUSOR_ACCESS_IND
--		   || ''', '''
--		   || w.FORUSOR_ACTIVITY_DATE
--		   || ''', '''
--		   || w.FORUSOR_USER_ID
--		   || ''', '''
--		   || w.FORUSOR_WBUD_ACCESS_IND
--		   || '''); '
--	  FROM fimsmgr.FORUSOR w
--	 WHERE w.FORUSOR_USER_ID_ENTERED = UPPER(:OLD_USER)
--
-- -- ----------------------------------------
--UNION
--	SELECT 46,
--		   'insert into fimsmgr.FORUSFN (FORUSFN_USER_ID_ENTERED,FORUSFN_COAS_CODE,FORUSFN_FTYP_CODE,FORUSFN_FUND_CODE,FORUSFN_ACCESS_IND,FORUSFN_ACTIVITY_DATE,FORUSFN_USER_ID,FORUSFN_WBUD_ACCESS_IND)values ('''
--		   || upper(:NEW_USER)
--		   || ''', '''
--		   || e.FORUSFN_COAS_CODE
--		   || ''', '''
--		   || e.FORUSFN_FTYP_CODE
--		   || ''', '''
--		   || e.FORUSFN_FUND_CODE
--		   || ''', '''
--		   || e.FORUSFN_ACCESS_IND
--		   || ''', '''
--		   || e.FORUSFN_ACTIVITY_DATE
--		   || ''', '''
--		   || e.FORUSFN_USER_ID
--		   || ''', '''
--		   || e.FORUSFN_WBUD_ACCESS_IND
--		   || '''); '
--	  FROM fimsmgr.FORUSFN e
--	 WHERE e.FORUSFN_USER_ID_ENTERED = UPPER(:OLD_USER)
--
---- ----------------------------------------
--UNION
--	SELECT 48,
--		   'insert into fimsmgr.FOBPROF (r.FOBPROF_USER_ID,  FOBPROF_ACTIVITY_DATE,  FOBPROF_USER_NAME,  FOBPROF_COAS_CODE,  FOBPROF_SECG_CODE,  FOBPROF_NSF_OVERRIDE,  FOBPROF_TOLERANCE,  FOBPROF_BUD_ID,  FOBPROF_PIDM,  FOBPROF_MASTER_FUND_IND,  FOBPROF_MASTER_ORGN_IND,  FOBPROF_MAX_TOLERANCE_AMT,  FOBPROF_RCVD_OVERRIDE_IND,  FOBPROF_RCVD_TOLERANCE_PCT,  FOBPROF_TOL_OVERRIDE_IND,  FOBPROF_DST_SPD_OVERRIDE_IND,  FOBPROF_SPD_OVERRIDE_IND,  FOBPROF_INT_RATE_OVERRIDE_IND,  FOBPROF_USER_INV_PRIV,  FOBPROF_EXP_END_POST_AUTH_IND,  FOBPROF_ACCRUAL_POST_AUTH_IND,  FOBPROF_REQUESTER_ORGN_CODE,  FOBPROF_RCVD_TOLERANCE_QTY,  FOBPROF_RCVD_TOLERANCE_AMT,  FOBPROF_RCVD_TOLERANCE_AMT_PCT,  FOBPROF_REQUESTOR_EMAIL_ADDR,  FOBPROF_REQUESTOR_FAX_AREA,  FOBPROF_REQUESTOR_FAX_NUMBER,  FOBPROF_REQUESTOR_FAX_EXT,  FOBPROF_REQUESTOR_PHONE_AREA,  FOBPROF_REQUESTOR_PHONE_NUMBER,  FOBPROF_REQUESTOR_PHONE_EXT,  FOBPROF_REQUESTOR_SHIP_CODE,  FOBPROF_EDI_OVERRIDE_IND,  FOBPROF_ACH_OVERRIDE_IND,  FOBPROF_CARD_OVERRIDE_IND,  FOBPROF_REQ_MATCH_OVRRD_IND,  FOBPROF_PO_MATCH_OVRRD_IND,  FOBPROF_INV_MATCH_OVRRD_IND,  FOBPROF_WEB_ACCESS_IND,  FOBPROF_WBUD_ACCESS_IND,  FOBPROF_WBUD_MSTR_FUND_IND,  FOBPROF_WBUD_MSTR_ORGN_IND,  FOBPROF_CTRY_CODE_REQ_PHONE, FOBPROF_CTRY_CODE_REQ_FAX) values ('''
--		   || upper(:NEW_USER)
--		   || ''', '''
--		   ||  r.FOBPROF_ACTIVITY_DATE
--		   || ''', '''
--		   ||  r.FOBPROF_USER_NAME
--		   || ''', '''
--		   ||  r.FOBPROF_COAS_CODE
--		   || ''', '''
--		   ||  r.FOBPROF_SECG_CODE
--		   || ''', '''
--		   ||  r.FOBPROF_NSF_OVERRIDE
--		   || ''', '''
--		   ||  r.FOBPROF_TOLERANCE
--		   || ''', '''
--		   ||  r.FOBPROF_BUD_ID
--		   || ''', '''
--		   ||  r.FOBPROF_PIDM
--		   || ''', '''
--		   ||  r.FOBPROF_MASTER_FUND_IND
--		   || ''', '''
--		   ||  r.FOBPROF_MASTER_ORGN_IND
--		   || ''', '''
--		   ||  r.FOBPROF_MAX_TOLERANCE_AMT
--		   || ''', '''
--		   ||  r.FOBPROF_RCVD_OVERRIDE_IND
--		   || ''', '''
--		   ||  r.FOBPROF_RCVD_TOLERANCE_PCT
--		   || ''', '''
--		   ||  r.FOBPROF_TOL_OVERRIDE_IND
--		   || ''', '''
--		   ||  r.FOBPROF_DST_SPD_OVERRIDE_IND
--		   || ''', '''
--		   ||  r.FOBPROF_SPD_OVERRIDE_IND
--		   || ''', '''
--		   ||  r.FOBPROF_INT_RATE_OVERRIDE_IND
--		   || ''', '''
--		   ||  r.FOBPROF_USER_INV_PRIV
--		   || ''', '''
--		   ||  r.FOBPROF_EXP_END_POST_AUTH_IND
--		   || ''', '''
--		   ||  r.FOBPROF_ACCRUAL_POST_AUTH_IND
--		   || ''', '''
--		   ||  r.FOBPROF_REQUESTER_ORGN_CODE
--		   || ''', '''
--		   ||  r.FOBPROF_RCVD_TOLERANCE_QTY
--		   || ''', '''
--		   ||  r.FOBPROF_RCVD_TOLERANCE_AMT
--		   || ''', '''
--		   ||  r.FOBPROF_RCVD_TOLERANCE_AMT_PCT
--		   || ''', '''
--		   ||  r.FOBPROF_REQUESTOR_EMAIL_ADDR
--		   || ''', '''
--		   ||  r.FOBPROF_REQUESTOR_FAX_AREA
--		   || ''', '''
--		   ||  r.FOBPROF_REQUESTOR_FAX_NUMBER
--		   || ''', '''
--		   ||  r.FOBPROF_REQUESTOR_FAX_EXT
--		   || ''', '''
--		   ||  r.FOBPROF_REQUESTOR_PHONE_AREA
--		   || ''', '''
--		   ||  r.FOBPROF_REQUESTOR_PHONE_NUMBER
--		   || ''', '''
--		   ||  r.FOBPROF_REQUESTOR_PHONE_EXT
--		   || ''', '''
--		   ||  r.FOBPROF_REQUESTOR_SHIP_CODE
--		   || ''', '''
--		   ||  r.FOBPROF_EDI_OVERRIDE_IND
--		   || ''', '''
--		   ||  r.FOBPROF_ACH_OVERRIDE_IND
--		   || ''', '''
--		   ||  r.FOBPROF_CARD_OVERRIDE_IND
--		   || ''', '''
--		   ||  r.FOBPROF_REQ_MATCH_OVRRD_IND
--		   || ''', '''
--		   ||  r.FOBPROF_PO_MATCH_OVRRD_IND
--		   || ''', '''
--		   ||  r.FOBPROF_INV_MATCH_OVRRD_IND
--		   || ''', '''
--		   ||  r.FOBPROF_WEB_ACCESS_IND
--		   || ''', '''
--		   ||  r.FOBPROF_WBUD_ACCESS_IND
--		   || ''', '''
--		   ||  r.FOBPROF_WBUD_MSTR_FUND_IND
--		   || ''', '''
--		   ||  r.FOBPROF_WBUD_MSTR_ORGN_IND
--		   || ''', '''
--		   ||  r.FOBPROF_CTRY_CODE_REQ_PHONE	   
--		   || ''', '''
--		   ||  r.FOBPROF_CTRY_CODE_REQ_FAX 
--		   || '''); '
--	  FROM fimsmgr.FOBPROF r
--	 WHERE r.FOBPROF_USER_ID = UPPER(:OLD_USER)

-- ----------------------------------------
UNION
	SELECT 99,
		   'commit;'
	  FROM dual)
ORDER BY seq
-- End
