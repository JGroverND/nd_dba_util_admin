with
-- *************************************
-- PEOPLE have a spriden row
-- -------------------------------------
people as (
select spriden_id netid
  from saturn.spriden
 where spriden_ntyp_code = 'NI'
 order by spriden_id
),
-- *************************************
-- Oracle SYS users are identifed in dba_users
-- -------------------------------------
sys_users as (
select username acct
  from dba_users
 where oracle_maintained = 'Y'
),
-- *************************************
-- OWNERS own objects
-- -------------------------------------
owners as (
select distinct owner acct
  from dba_objects
 order by owner
),
-- *************************************
-- LINK users are only identified by profile (receive a DB Link)
-- -------------------------------------
link_users as (
select username acct
  from dba_users
 where profile = 'ND_LNK_OPEN_DEFAULT'
),
-- *************************************
-- QA users are named as such with a number
-- -------------------------------------
qa_users as (
select username netid
  from dba_users
 where username like 'ESQA%'
    or username like 'PSINSTR%'
    or username like 'PSTRN%'
    or username like 'PSUSER%'
),
-- *************************************
-- Banner BASELINE users are defined in this list and locked by default except for the accounts listed
-- -------------------------------------
baseline_users as (
select username acct
      ,case when username in
                   ( -- Banner baseline open accounts
'BAN_SS_USER','BANJSPROXY','BANPROXY','CASCADEU','EPRINT','FLEXUSR','INTEGMGR',
'JASPERUSR','NOSLEEP','ODSMGR','OTGMGR','SSOMGR','SSPBMGR','WFAUTO','WFEVENT',
'WFQUERY','WWW2_USER','UPGRADE2','UPGRADE3','UPGRADE4','UPGRADE5','BAN_ETHOS_BULK',
'BANGUIDGEN','BANINST1_SS9','JASPERSERVER','ODSSTG','ORDS_USER','WFBANNER','WFSSO',
'WORKFLOW','BAN_EXTENSIONS'
                   )
            then 'OPEN'
            else null
       end status
  from dba_users
 where username in
		( -- Banner baseline accounts
'ADISDAT',   'ADISPRD',      'ADISUSR',    'ALUMNI',  'APPGENMGR',    'BAN_SS_USER', 'BANIMGR',
'BANINST1',  'BANJSPROXY',   'BANPROXY',   'BANSECR', 'BANSSO',       'BASELINE',    'BITMUSR',
'BPISMGR',   'BPISPRD',      'BPISUSR',    'BSACMGR', 'BSACUSR',      'BWAMGR',      'BWFMGR',   'BWGMGR',
'BWLMGR',    'BWPMGR',       'BWRMGR',     'BWSMGR',  'CASCADEU',     'CIMSMGR',     'CIMSPRD',  'CIMSUSR',
'COMMHRMGR', 'COMMMGR',      'DBEU_OWNER', 'DCRSMGR', 'DCRSPRD',      'DCRSUSR',     'EPRINT',
'EWQSMGR',   'EWQSUSR',      'FAISDAT',    'FAISMGR', 'FAISPRD',      'FAISUSR',     'FIMSARC',  'FIMSDAT',
'FIMSMGR',   'FIMSPRD',      'FIMSUSR',    'FLEXREG', 'FLEXREG_USER', 'FLEXUSR',     'FTAEUSR',
'GENERAL',   'GENLPRD',      'HRISDAT',    'HRISPRD', 'HRISUSR',      'ICMGR',       'INFMGR',   'INFMGR',
'INTEGMGR',  'JASPERUSR',    'LCBMGR',     'LIMSARC', 'LIMSMGR',      'LIMSPRD',     'LIMSUSR',  'MICROFA',
'MICRPRD',   'MODSMGR',      'MUTREP',     'NLSUSR',  'NOSLEEP',      'ODSMGR',      'OTGMGR',   'PAYROLL',
'POSNCTL',   'POSNPRD',      'PRGNREP',    'SAISDAT', 'SAISPRD',      'SAISUSR',     'SATURN',   'SSOMGR',
'SSPBMGR',   'STREAMSADMIN', 'TAISMGR',    'TAISPRD', 'UENTMGR',      'UIMSMGR',     'UIMSPRD',
'UIMSUSR',   'VRSMGR',       'WFAUTO',     'WFEVENT', 'WFQUERY',      'WTAILOR',     'WWW2_USER', 'XPBMGR',
'XRISMGR',   'XRISPRD',      'XRISUSR', 'UPGRADE2', 'UPGRADE3',   'UPGRADE4',   'UPGRADE5',    
'BAN_ETHOS_BULK','BANGUIDGEN','BANINST1_SS9','JASPERSERVER','ODSSTG','ORDS_USER','WFBANNER','WFSSO','WORKFLOW',
'BAN_EXTENSIONS','WFOBJECTS','NLSUSER','INTRCONFIG'
		)
),
-- *************************************
-- Powerusers have ""extra"" roles assigned
-- -------------------------------------
powerusers as (
select distinct grantee netid
  from dba_role_privs
  join saturn.spriden on ((spriden_id = grantee) and (spriden_ntyp_code = 'NI'))
 where granted_role like 'ND%'
   and granted_role not in ('ND_CONNECT_S_ROLE', 'ND_RESOURCE_S_ROLE')
),
-- *************************************
-- INB users have GGN_ALL_USERS_C
-- -------------------------------------
banner_users as (
select c.gurucls_userid netid
      ,c.gurucls_class_code banner_class
  from bansecr.gurucls c
  where c.gurucls_class_code = 'GGN_ALL_USERS_C'
),
-- *************************************
-- EPRINT users have EPRINT classes
-- -------------------------------------
eprint_users as (
select distinct gurucls_userid netid
  from bansecr.gurucls
 where gurucls_class_code like '%EPRINT%'
),
-- *************************************
-- BUYND users have GGN_ALL_BUY_ND_ONLY_C
-- -------------------------------------
buynd_users as (
select distinct gurucls_userid netid
  from bansecr.gurucls
 where gurucls_class_code = 'GGN_ALL_BUY_ND_ONLY_C'
),
-- *************************************
-- FIN Org users
-- -------------------------------------
finfo_users as (
select distinct fobprof_user_id netid 
  from fimsmgr.fobprof
),
-- *************************************
-- HR Org users
-- -------------------------------------
hrfo_users as (
select distinct nsrspsc_user_code netid 
  from POSNCTL.nsrspsc
),
-- *************************************
-- User information by netid and pidm
-- -------------------------------------
user_info AS
 (SELECT s.spriden_pidm pidm,
         s.spriden_id netid,
         s.spriden_last_name last_name,
         s.spriden_first_name first_name,
         CASE
             WHEN (p.pebempl_empl_status = 'A') THEN
              CASE
                  WHEN (n.nbrbjob_posn IS NOT NULL AND n.nbrbjob_posn LIKE 'R%') THEN
                   'Retiree' -- TODO: has temp job?
                  ELSE
                   'Active'
              END
             WHEN (p.pebempl_empl_status = 'T') THEN
              CASE
                  WHEN SYSDATE BETWEEN affil.affil_start_date AND affil.affil_end_date THEN
                   'Terminated, but a Current Affiliate'
                  ELSE
                   'Terminated'
              END
             WHEN trunc(SYSDATE) BETWEEN affil.affil_start_date AND
                  affil.affil_end_date THEN
              'Current Affiliate'
             WHEN trunc(SYSDATE) >= affil.affil_end_date THEN
              'Former Affiliate'
             ELSE
              'Unknown'
         END emp_status,
         nvl(e.ptrecls_long_desc, 'No Employee Class') emp_class,
         to_char(p.pebempl_activity_date, 'MM-DD-YYYY') hr_activity_date,
         to_char(p.pebempl_term_date, 'MM-DD-YYYY') hr_termination_date,
         g.ftvorgn_orgn_code AS current_org_code,
         CASE
             WHEN g.ftvorgn_orgn_code IS NULL THEN
              NULL
             ELSE
              g.ftvorgn_orgn_code || ' - ' || g.ftvorgn_title
         END current_org_code_name,
         m.mgr_last_name manager_last_name,
         m.mgr_first_name manager_first_name
    FROM saturn.spriden s
    LEFT JOIN payroll.pebempl p
      ON p.pebempl_pidm = s.spriden_pidm
    LEFT JOIN payroll.ptrecls e
      ON e.ptrecls_code = p.pebempl_ecls_code
    LEFT JOIN ftvorgn g
      ON g.ftvorgn_coas_code = p.pebempl_coas_code_home
     AND g.ftvorgn_orgn_code = p.pebempl_orgn_code_home
     AND g.ftvorgn_eff_date <= SYSDATE
     AND g.ftvorgn_nchg_date > SYSDATE
    LEFT JOIN ndhrpyadmin.pzvmngr m
      ON m.emp_spriden_pidm = s.spriden_pidm
     AND m.pzrmngr_distance_num = 1
    LEFT JOIN posnctl.nbrbjob n
      ON n.nbrbjob_pidm = p.pebempl_pidm
     AND n.nbrbjob_begin_date <= SYSDATE
     AND (n.nbrbjob_end_date IS NULL OR n.nbrbjob_end_date > SYSDATE)
     AND n.nbrbjob_posn LIKE 'R%'
     AND decode(n.nbrbjob_contract_type, 'P', 1, 'S', 2, 'O', 3) =
         (SELECT MIN(decode(nbr.nbrbjob_contract_type, 'P', 1, 'S', 2, 'O', 3))
            FROM posnctl.nbrbjob nbr
           WHERE nbr.nbrbjob_pidm = n.nbrbjob_pidm
             AND nbr.nbrbjob_begin_date <= SYSDATE
             AND (nbr.nbrbjob_end_date IS NULL OR nbr.nbrbjob_end_date > SYSDATE)
             AND nbr.nbrbjob_posn LIKE 'R%')
    LEFT JOIN (SELECT *
                FROM (SELECT pzraexp_pidm AS pidm,
                             pzraexp_rels_code AS rel_code,
                             r.pzvrels_desc AS rel_desc,
                             b.pzraeed_effective_date AS affil_start_date,
                             d.pzraeed_effective_date AS affil_end_date,
                             rank() over(PARTITION BY pzraexp_pidm ORDER BY nvl(d.pzraeed_effective_date, nd_data_gov_admin.end_of_time) DESC, d.pzraeed_aexp_seqno DESC) AS end_date_rank
                        FROM pzraexp a
                        JOIN pzraeed b
                          ON a.pzraexp_pidm = b.pzraeed_pidm
                         AND a.pzraexp_seqno = b.pzraeed_aexp_seqno
                         AND b.pzraeed_status = 'A'
                         AND b.pzraeed_effective_date =
                             (SELECT MAX(c.pzraeed_effective_date)
                                FROM pzraeed c
                               WHERE c.pzraeed_status = 'A'
                                 AND c.pzraeed_pidm = b.pzraeed_pidm
                                 AND c.pzraeed_aexp_seqno = b.pzraeed_aexp_seqno
                                 AND c.pzraeed_effective_date <= trunc(SYSDATE))
                        JOIN pzraeed d
                          ON a.pzraexp_pidm = d.pzraeed_pidm
                         AND a.pzraexp_seqno = d.pzraeed_aexp_seqno
                         AND d.pzraeed_status = 'I'
                         AND d.pzraeed_effective_date =
                             (SELECT MIN(c.pzraeed_effective_date)
                                FROM pzraeed c
                               WHERE c.pzraeed_effective_date >
                                     b.pzraeed_effective_date
                                 AND c.pzraeed_pidm = d.pzraeed_pidm
                                 AND c.pzraeed_aexp_seqno = d.pzraeed_aexp_seqno)
                        JOIN ndhrpyadmin.pzvrels r
                          ON r.pzvrels_code = a.pzraexp_rels_code
                       WHERE a.pzraexp_excp_code = 'NETID') x
               WHERE x.end_date_rank = 1) affil
      ON affil.pidm = s.spriden_pidm
   WHERE s.spriden_ntyp_code = 'NI'
)
-- -------------------------------------
-- end user_info
-- *************************************
-- =============================================================================
-- MAIN query body
-- =============================================================================
select ' ' action
      ,to_char(sysdate, 'YYYY-MM-DD') report_date
      ,username
      ,password_versions
      ,nvl(to_char(created, 'YYYY-MM-DD'), ' ') created
      ,nvl(to_char(last_login, 'YYYY-MM-DD'), ' ') last_login
      --,nvl(round(sysdate - cast(last_login as date),2), 0) days_ago
      ,nvl(user_info.emp_status, ' ') emp_status
      ,' ' profile_change
      ,
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> --
-- rule-base profile determination: copy me to the WHERE clause if you change me!
-- -----------------------------------------------------------------------------
'ND_' ||                                                                      -- ----- PREFIX
--                                                                            -- ----- TYPE (SYS, USR, LNK, OWN, APP)
case when (sys_users.acct is not null)     then 'SYS_' else                   -- account is an Oracle account
  case when (link_users.acct is not null)  then 'LNK_' else                   -- account receives a DB Link
    case when (owners.acct is not null)    then 'OWN_' else                   -- account owns objects
      case when (people.netid is not null) then 'USR_' else  'APP_'           -- account is a person. Fall thru to APP
end end end end ||                                                            --
--                                                                            -- ----- STATUS (OPEN, LOCK)
case when ((sys_users.acct is not null) and                                   -- open oracle built-in accounts set as open
           (decode(account_status, 'OPEN', 'OPEN', 'LOCK') = 'OPEN'))         --
       or (link_users.acct is not null)                                       -- open link accounts
       or ((baseline_users.acct is not null) and                              -- open banner baseline
           (baseline_users.status is not null))                               --   with exceptions
       or (banner_users.netid is not null)                                    -- open banner users
       or (eprint_users.netid is not null)                                    -- open eprint users
       or (powerusers.netid is not null)                                      -- open poweruser users
       or (qa_users.netid is not null)                                        -- open QA users
     then 'OPEN_'                                                             --
     when (sys_users.acct is null)                                            -- not SYS, LINK, OWNER, or PERSON
      and (link_users.acct is null)                                           -- indicates an APP account
      and (owners.acct is null)                                               --
      and (people.netid is null)                                              --
    then 'OPEN_'                                                              -- APP accounts are OPEN
     when buynd_users.netid is NULL                                           -- After the above and weeding out non-auth
      and finfo_users.netid is NULL                                           -- users we should be left with APP users
      and hrfo_users.netid is NULL                                            -- so we open them
      and owners.acct is null                                                 --
     then 'OPEN_'                                                             --
     else 'LOCK_'                                                             -- everything else is locked (Owners and non-auth users)
end ||                                                                        --
--                                                                            -- ----- USER_TYPE (ORACLE,QA,BASELINE,POWERUSER,INB,EPRINT,BUYND,DEFAULT)
case when (sys_users.acct is not null) then 'ORACLE' else                     -- account is an Oracle account
 case when (qa_users.netid is not null) then 'QA' else                        -- account is a QA or testing account
  case when (baseline_users.acct is not null) then 'BANNER' else              -- account is BASELINE
   case when ((powerusers.netid is not null)  
         and (user_info.current_org_code in ('29015','29030','29032'))) 
        then 'DEVELOPER' else                                                 -- account is DEVELOPER
    case when (powerusers.netid is not null) then 'POWERUSER' else            -- account is a POWERUSER
      case when (banner_users.netid is not null) then 'INBUSER' else          -- account is an INB user
        case when (eprint_users.netid is not null) then 'EPRINT' else         -- account is an EPRINT user (deprecated?)
         case when (buynd_users.netid is not null) then 'BUYND' else          -- account is a BUYND user
          case when (finfo_users.netid is not null) then 'FFUNDORG' else      -- account is Finance Fund-org security user
           case when (hrfo_users.netid is not null) then 'PEOPLE_EZ' else     -- account is an HR fund-org security user
          'DEFAULT'                                                           -- account is DEFAULT type
end end end end end end end end end end                                       --
-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< --
       as proposed_profile
      ,profile current_profile
      ,account_status
	    ,user_info.last_name
	    ,user_info.first_name
	    ,user_info.hr_termination_date
	    ,user_info.current_org_code
	    ,user_info.current_org_code_name
      -- classifiers for checking account types
      ,case when (sys_users.acct is null)       then null else 'Y' end sys
      ,case when (owners.acct is null)          then null else 'Y' end own
      ,case when (people.netid is null)         then null else 'Y' end usr
      ,case when (link_users.acct is null)      then null else 'Y' end lnk
      ,case when (baseline_users.acct is null)  then null else 'Y' end bln
      ,case when (qa_users.netid is null)       then null else 'Y' end qas
      ,case when (powerusers.netid is null)     then null else 'Y' end dev
      ,case when (banner_users.netid is null)   then null else 'Y' end ban
      ,case when (eprint_users.netid  is null)  then null else 'Y' end epr
      ,case when (buynd_users.netid is null)    then null else 'Y' end buy
      ,case when (finfo_users.netid is null)    then null else 'Y' end ffo
      ,case when (hrfo_users.netid is null)     then null else 'Y' end hfo
  from dba_users
  left outer join user_info         on (user_info.netid      = dba_users.username)
  left outer join sys_users         on (sys_users.acct       = dba_users.username)
  left outer join owners            on (owners.acct          = dba_users.username)
  left outer join link_users        on (link_users.acct      = dba_users.username)
  left outer join people            on (people.netid         = dba_users.username)
  left outer join qa_users          on (qa_users.netid       = dba_users.username)
  left outer join powerusers        on (powerusers.netid     = dba_users.username)
  left outer join baseline_users    on (baseline_users.acct  = dba_users.username)
  left outer join banner_users      on (banner_users.netid   = dba_users.username)
  left outer join eprint_users      on (eprint_users.netid   = dba_users.username)
  left outer join buynd_users       on (buynd_users.netid    = dba_users.username)
  left outer join finfo_users       on (finfo_users.netid    = dba_users.username)
  left outer join hrfo_users        on (hrfo_users.netid     = dba_users.username)
-- -----------------------------------------------------------------------------
-- WHERE clause filters
-- -----------------------------------------------------------------------------
;
