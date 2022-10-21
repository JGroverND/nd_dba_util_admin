create or replace PACKAGE BODY nd_dba_banner_account_util
as
-- -----------------------------------------------------------------------------
-- file: nd_dba_banner_account_util_body.sql
-- desc: 
--
-- audit trail
-- 17-Jun-2022 John W Grover
--  - Original Code
--
-- -----------------------------------------------------------------------------
-- F U N C T I O N S
-- -----------------------------------------------------------------------------
--
-- Account type functions
--
function is_person_acct (p_netid in dba_users.username%type) return boolean is
-- person account defined as having a spriden row with ntype_code of 'NI'
    p_count number := 0;
begin
    if not ban_acct_exists(p_netid)
    then
        raise e_account_does_not_exist;
    end if;

    select count(spriden_id) into p_count
      from saturn.spriden
     where spriden_id = upper(p_netid)
       and spriden_ntyp_code = 'NI';

    if p_count > 0 then
        return true;
    else
        return false;
    end if;

    exception
    when e_account_does_not_exist
    then
        raise_application_error(-20002, 'Account does not exist');

end is_person_acct;
-- -----------------------------------------------------------------------------

function is_sys_acct (p_netid in dba_users.username%type) return boolean is
-- system account sefined as being oracle maintained in dba_users
    p_count number := 0;
begin
    if not ban_acct_exists(p_netid)
    then
        raise e_account_does_not_exist;
    end if;

    select count(username) into p_count
      from dba_users
     where username = upper(p_netid)
       and oracle_maintained = 'Y';

    if p_count > 0 then
        return true;
    else
        return false;
    end if;

    exception
    when e_account_does_not_exist
    then
        raise_application_error(-20002, 'Account does not exist');

end is_sys_acct;
-- -----------------------------------------------------------------------------

function is_owner_acct (p_netid in dba_users.username%type) return boolean is
-- owner account defined as being owner of any database object
--  note: may need to refine by excluding certain object types
    p_count number := 0;
begin
    if not ban_acct_exists(p_netid)
    then
        raise e_account_does_not_exist;
    end if;

    select count(owner) into p_count
      from sys.dba_objects
     where owner = upper(p_netid)
     order by owner;

    if p_count > 0 then
        return true;
    else
        return false;
    end if;

    exception
    when e_account_does_not_exist
    then
        raise_application_error(-20002, 'Account does not exist');

end is_owner_acct;
-- -----------------------------------------------------------------------------

function is_link_acct (p_netid in dba_users.username%type) return boolean is
-- link account defines as already being defined as a link account.
--    it's circular, but the best we can do
    p_count number := 0;
begin
    if not ban_acct_exists(p_netid)
    then
        raise e_account_does_not_exist;
    end if;

    select count(username) into p_count
      from dba_users
     where username = upper(p_netid)
       and profile = 'ND_LNK_OPEN_DEFAULT';

    if p_count > 0 then
        return true;
    else
        return false;
    end if;

    exception
    when e_account_does_not_exist
    then
        raise_application_error(-20002, 'Account does not exist');

end is_link_acct;
-- -----------------------------------------------------------------------------

function is_qa_acct (p_netid in dba_users.username%type) return boolean is
-- qa account defined by username naming convention
    p_count number := 0;
begin
    if not ban_acct_exists(p_netid)
    then
        raise e_account_does_not_exist;
    end if;

    select count(0) into p_count
      from dual
     where upper(p_netid) like 'ESQA%'
        or upper(p_netid) like 'PSINSTR%'
        or upper(p_netid) like 'PSTRN%'
        or upper(p_netid) like 'PSUSER%';

    if p_count > 0 then
        return true;
    else
        return false;
    end if;

    exception
    when e_account_does_not_exist
    then
        raise_application_error(-20002, 'Account does not exist');

end is_qa_acct;
-- -----------------------------------------------------------------------------

function is_banner_baseline_acct (p_netid in dba_users.username%type) return boolean is
-- banner basline accounts defined by being in a manually managed list of acounts
    p_count number := 0;
begin
    if not ban_acct_exists(p_netid)
    then
        raise e_account_does_not_exist;
    end if;

    select count(0) into p_count
      from dual
     where upper(p_netid) in (
-- normally open accounts
'BAN_SS_USER','BANJSPROXY','BANPROXY','CASCADEU','EPRINT','FLEXUSR','INTEGMGR',
'JASPERUSR','NOSLEEP','ODSMGR','OTGMGR','SSOMGR','SSPBMGR','WFAUTO','WFEVENT',
'WFQUERY','WWW2_USER','UPGRADE2','UPGRADE3','UPGRADE4','UPGRADE5','BAN_ETHOS_BULK',
'BANGUIDGEN','BANINST1_SS9','JASPERSERVER','ODSSTG','ORDS_USER','WFBANNER','WFSSO',
'WORKFLOW','BAN_EXTENSIONS',
-- normally locked accounts
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
'BAN_EXTENSIONS','WFOBJECTS','NLSUSER','INTRCONFIG');

    if p_count > 0 then
        return true;
    else
        return false;
    end if;

    exception
    when e_account_does_not_exist
    then
        raise_application_error(-20002, 'Account does not exist');

end is_banner_baseline_acct;
-- -----------------------------------------------------------------------------

function is_poweruser_acct (p_netid in dba_users.username%type) return boolean is
-- poweruser accounts defined by having extra ND roles assigned
--   note: this may need to be refined to a specific list of roles
    p_count number := 0;
begin
    if not ban_acct_exists(p_netid)
    then
        raise e_account_does_not_exist;
    end if;

    select count(grantee) into p_count
      from dba_role_privs
      join saturn.spriden on ((spriden_id = grantee) and (spriden_ntyp_code = 'NI'))
     where grantee = upper(p_netid)
       and granted_role like 'ND%'
       and granted_role not in ('ND_CONNECT_S_ROLE', 'ND_RESOURCE_S_ROLE');

    if p_count > 0 then
        return true;
    else
        return false;
    end if;

    exception
    when e_account_does_not_exist
    then
        raise_application_error(-20002, 'Account does not exist');

end is_poweruser_acct;
-- -----------------------------------------------------------------------------

function is_banner_user_acct (p_netid in dba_users.username%type) return boolean is
-- banner user (admin pages) accounts defined as being granted the GGN_ALL_USERS_C class
--   note: some cleanup required to make this entirely valid.
    p_count number := 0;
begin
    if not ban_acct_exists(p_netid)
    then
        raise e_account_does_not_exist;
    end if;

    select count(gurucls_userid) into p_count
      from bansecr.gurucls
     where gurucls_userid = upper(p_netid)
       and gurucls_class_code = 'GGN_ALL_USERS_C';

    if p_count > 0 then
        return true;
    else
        return false;
    end if;

    exception
    when e_account_does_not_exist
    then
        raise_application_error(-20002, 'Account does not exist');

end is_banner_user_acct;
-- -----------------------------------------------------------------------------

function is_eprint_acct (p_netid in dba_users.username%type) return boolean is
-- eprint accounts defined as being granted any eprint class
    p_count number := 0;
begin
    if not ban_acct_exists(p_netid)
    then
        raise e_account_does_not_exist;
    end if;

    select count(gurucls_userid) into p_count
      from bansecr.gurucls
     where gurucls_userid = upper(p_netid)
       and gurucls_class_code like '%EPRINT%';

    if p_count > 0 then
        return true;
    else
        return false;
    end if;

    exception
    when e_account_does_not_exist
    then
        raise_application_error(-20002, 'Account does not exist');

end is_eprint_acct;
-- -----------------------------------------------------------------------------

function is_buynd_acct (p_netid in dba_users.username%type) return boolean is
-- buynd account defined as being granted the GGN_ALL_BUY_ND_ONLY_C class
    p_count number := 0;
begin
    if not ban_acct_exists(p_netid)
    then
        raise e_account_does_not_exist;
    end if;

    select count(gurucls_userid) into p_count
      from bansecr.gurucls
     where gurucls_userid = upper(p_netid)
       and gurucls_class_code = 'GGN_ALL_BUY_ND_ONLY_C';

    if p_count > 0 then
        return true;
    else
        return false;
    end if;

    exception
    when e_account_does_not_exist
    then
        raise_application_error(-20002, 'Account does not exist');

end is_buynd_acct;
-- -----------------------------------------------------------------------------

function is_fin_fundorg_acct (p_netid in dba_users.username%type) return boolean is
-- fin fundorg account defined as having a fomprof row
    p_count number := 0;
begin
    if not ban_acct_exists(p_netid)
    then
        raise e_account_does_not_exist;
    end if;

    select count(fobprof_user_id) into p_count
      from fimsmgr.fobprof
     where fobprof_user_id = upper(p_netid);

    if p_count > 0 then
        return true;
    else
        return false;
    end if;

    exception
    when e_account_does_not_exist
    then
        raise_application_error(-20002, 'Account does not exist');

end is_fin_fundorg_acct;
-- -----------------------------------------------------------------------------

function is_hr_fundorg_acct (p_netid in dba_users.username%type) return boolean is
-- hr fundorg account defined as having a nsrspsc row
    p_count number := 0;
begin
    if not ban_acct_exists(p_netid)
    then
        raise e_account_does_not_exist;
    end if;

    select count(nsrspsc_user_code) into p_count 
      from posnctl.nsrspsc
     where nsrspsc_user_code = upper(p_netid);

    if p_count > 0 then
        return true;
    else
        return false;
    end if;

    exception
    when e_account_does_not_exist
    then
        raise_application_error(-20002, 'Account does not exist');

end is_hr_fundorg_acct;
-- -----------------------------------------------------------------------------

--
-- Banner specific functions
--
function ban_acct_exists (p_netid in dba_users.username%type) return boolean is
begin
    if nd_dba_util_admin.nd_dba_oracle_account_util.is_account(p_netid)
    then
        return true;
    else
        return false;
    end if;
END ban_acct_exists;
-- -----------------------------------------------------------------------------

function ban_class_exists (p_class in bansecr.gtvclas.gtvclas_class_code%type) return boolean is
    p_count number :=0;
begin
    select count(0) into p_count 
      from bansecr.gtvclas 
     where upper(gtvclas_class_code) = upper(p_class);

    if p_count > 0 then
        return true;
    else
        return false;
    end if;
end ban_class_exists;
-- -----------------------------------------------------------------------------

function ban_netid_has_gobeacc (p_netid in general.gobeacc.gobeacc_username%type) return boolean is
    p_count number :=0;
begin
    select count(0) into p_count 
      from general.gobeacc 
     where upper(gobeacc_username) = upper(p_netid);

    if p_count > 0 then
        return true;
    else
        return false;
    end if;

end ban_netid_has_gobeacc;
-- -----------------------------------------------------------------------------

function ban_netid_has_banproxy(p_netid in sys.proxy_users.client%type) return boolean is
    p_count number :=0;
begin
    select count(0) into p_count 
      from sys.proxy_users 
     where upper(client) = upper(p_netid)
       and proxy = 'BANPROXY';

    if p_count > 0 then
        return true;
    else
        return false;
    end if;
end ban_netid_has_banproxy;
-- -----------------------------------------------------------------------------

function ban_netid_has_banjsproxy(p_netid in sys.proxy_users.client%type) return boolean is
    p_count number :=0;
begin
    select count(0) into p_count 
      from sys.proxy_users 
     where upper(client) = upper(p_netid)
       and proxy = 'BANJSPROXY';

    if p_count > 0 then
        return true;
    else
        return false;
    end if;
end ban_netid_has_banjsproxy;
-- -----------------------------------------------------------------------------

function ban_acct_has_class(p_netid in bansecr.gurucls.gurucls_userid%type, 
                            p_class in bansecr.gurucls.gurucls_class_code%type) return boolean is
p_count number :=0;
begin
    if not ban_acct_exists(p_netid)
    then
        raise e_invalid_account;
    end if;

    if not ban_class_exists(p_class)
    then
        raise e_invalid_class;
    end if;

    select count(0) into p_count
      from bansecr.gurucls 
     where upper(gurucls_userid) = upper(p_netid)
       and upper(gurucls_class_code) = upper(p_class);

    if p_count > 0 then
        return true;
    else
        return false;
    end if;

    exception
    when e_invalid_account
    then
        raise_application_error(-20002, 'Invalid account');
    when e_invalid_class
    then
        raise_application_error(-20004, 'Invalid class');

end ban_acct_has_class;
-- -----------------------------------------------------------------------------

function ban_acct_has_fundorg(p_netid in fimsmgr.fobprof.fobprof_user_id%type) return boolean is
-- kind of redundant, but created for naming compatibility
begin
    if is_fin_fundorg_acct(p_netid) then
        return true;
    else
        return false;
    end if;
end ban_acct_has_fundorg;
-- -----------------------------------------------------------------------------

function ban_acct_has_hrfundorg(p_netid in posnctl.nsrspsc.nsrspsc_user_code%type) return boolean is
-- kind of redundant, but created for naming compatibility
    begin
        if is_hr_fundorg_acct(p_netid) then
            return true;
        else
            return false;
        end if;
end ban_acct_has_hrfundorg;
-- -----------------------------------------------------------------------------

function ban_acct_used_object(p_netid in bansecr.guraces.guraces_userid%type,
                                  p_object in bansecr.guraces.guraces_object%type) return boolean is
p_count number :=0;
begin
    if not ban_acct_exists(p_netid)
    then
        raise e_account_does_not_exist;
    end if;

    select count(0) into p_count 
        from bansecr.guraces 
        where upper(guraces_userid) = upper(p_netid)
        and upper(guraces_object) = upper(p_object);

    if p_count > 0 then
        return true;
    else
        return false;
    end if;

    exception
    when e_account_does_not_exist
    then
        raise_application_error(-20002, 'Account does not exist');

end ban_acct_used_object;
-- -----------------------------------------------------------------------------

function ban_user_orgn_code(p_netid in sys.dba_users.username%type) return fimsmgr.ftvorgn.ftvorgn_orgn_code%type is
    v_orgn_code fimsmgr.ftvorgn.ftvorgn_orgn_code%type;
begin
    if not ban_acct_exists(p_netid)
    then
        raise e_account_does_not_exist;
    end if;

    select ftvorgn_orgn_code into v_orgn_code
      from saturn.spriden
      join payroll.pebempl on  pebempl_pidm = spriden_pidm
      join fimsmgr.ftvorgn on ftvorgn_coas_code = pebempl_coas_code_home
                          and ftvorgn_orgn_code = pebempl_orgn_code_home
                          and ftvorgn_eff_date <= SYSDATE
                          and ftvorgn_nchg_date > SYSDATE
     where spriden_id = upper(p_netid)
       and spriden_ntyp_code = 'NI';

    return v_orgn_code;

    exception
    when e_account_does_not_exist
    then
        raise_application_error(-20002, 'Account does not exist');

end ban_user_orgn_code;
-- -----------------------------------------------------------------------------

function ban_acct_suggest_profile(p_netid in sys.dba_users.username%type) return sys.dba_users.profile%type is

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

    v_account_prefix            varchar2(32);
    v_account_state             varchar2(32);
    v_account_type              varchar2(32);
    v_account_status            varchar2(32);

    v_is_sys_acct               boolean := is_sys_acct(p_netid);
    v_is_link_acct              boolean := is_link_acct(p_netid);
    v_is_owner_acct             boolean := is_owner_acct(p_netid);
    v_is_person_acct            boolean := is_person_acct(p_netid);
    v_is_banner_baseline_acct   boolean := is_banner_baseline_acct(p_netid);
    v_is_banner_user_acct       boolean := is_banner_user_acct(p_netid);
    v_is_eprint_acct            boolean := is_eprint_acct(p_netid);
    v_is_poweruser_acct         boolean := is_poweruser_acct(p_netid);
    v_is_qa_acct                boolean := is_qa_acct(p_netid);
    v_is_buynd_acct             boolean := is_buynd_acct(p_netid);
    v_is_fin_fundorg_acct       boolean := is_fin_fundorg_acct(p_netid);
    v_is_hr_fundorg_acct        boolean := is_hr_fundorg_acct(p_netid);

begin
    if not ban_acct_exists(p_netid)
    then
        raise e_account_does_not_exist;
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
     where username = upper(p_netid);

    -- default to LOCK state
    v_account_state := 'LOCK';

    -- these accounts are open by default
    -- these accounts are open by default
    if (v_is_sys_acct and v_account_status like '%OPEN%')   -- open oracle built-in accounts set as open
    or v_is_link_acct                                       -- open link accounts
    or (v_is_banner_baseline_acct and                       -- open only some banner baseline
        upper(p_netid) in (
            'BAN_SS_USER','BANJSPROXY','BANPROXY','CASCADEU','EPRINT','FLEXUSR','INTEGMGR',
            'JASPERUSR','NOSLEEP','ODSMGR','OTGMGR','SSOMGR','SSPBMGR','WFAUTO','WFEVENT',
            'WFQUERY','WWW2_USER','UPGRADE2','UPGRADE3','UPGRADE4','UPGRADE5','BAN_ETHOS_BULK',
            'BANGUIDGEN','BANINST1_SS9','JASPERSERVER','ODSSTG','ORDS_USER','WFBANNER','WFSSO',
            'WORKFLOW','BAN_EXTENSIONS'))
    or v_is_banner_user_acct                                -- open banner users
    or v_is_eprint_acct                                     -- open eprint users
    or v_is_poweruser_acct                                  -- open poweruser users
    or v_is_qa_acct                                         -- open QA users
    then 
        v_account_state := 'OPEN';
    end if;

-- Choose account type
    v_account_type := 'DEFAULT';

    if (v_is_sys_acct)
    then 
        v_account_type := 'ORACLE';
    elsif (v_is_qa_acct) 
    then 
        v_account_type := 'QA';
    elsif (v_is_banner_baseline_acct) 
    then 
        v_account_type := 'BANNER';
    elsif v_is_poweruser_acct
      and ban_user_orgn_code(p_netid) in ('29015','29030','29032')
    then 
        v_account_type := 'DEVELOPER';
    elsif (v_is_poweruser_acct) 
    then 
        v_account_type := 'POWERUSER';
    elsif (v_is_banner_user_acct) 
    then 
        v_account_type := 'INBUSER';
    elsif (v_is_eprint_acct) 
    then 
        v_account_type := 'EPRINT';
    elsif (v_is_buynd_acct) 
    then 
        v_account_type := 'BUYND';
    elsif (v_is_fin_fundorg_acct) 
    then 
        v_account_type := 'FFUNDORG';
    elsif (v_is_hr_fundorg_acct) 
    then 
        v_account_type := 'PEOPLE_EZ';
    end if;

    -- put all the pieces together
    return 'ND_' || v_account_prefix || '_' || v_account_state || '_' || v_account_type;


    exception
    when e_account_does_not_exist
    then
        raise_application_error(-20002, 'Account does not exist');

end ban_acct_suggest_profile;

-- -----------------------------------------------------------------------------
-- P R O C E D U R E S
-- -----------------------------------------------------------------------------

procedure ban_acct_grant_banproxy(p_netid in sys.proxy_users.client%type) IS
p_count number := 0;

BEGIN

if not ban_netid_has_banproxy(p_netid)

THEN

 execute immediate '   ALTER USER ' ||p_netid|| ' grant connect through banproxy';

end if;

end ban_acct_grant_banproxy;
--------------------------------------------------------------------------------

procedure ban_acct_grant_banjsproxy(p_netid in sys.proxy_users.client%type) IS

p_count number := 0;

BEGIN

if not ban_netid_has_banjsproxy(p_netid)

THEN

  execute immediate '   ALTER USER ' ||p_netid|| '  grant connect through banjsproxy '; 

end if;

end ban_acct_grant_banjsproxy;
-- -----------------------------------------------------------------------------

--  procedure ban_acct_grant_class      (p_netid IN dba_users.username%type, p_class in bansecr.gtvclas.gtvclas_class_code%type);
--  procedure ban_acct_grant_class_list (p_netid IN dba_users.username%type, p_class_list in varchar2);
--  procedure ban_acct_create_gobeacc   (p_netid IN dba_users.username%type);

--  procedure ban_acct_create_admin_pages   (acct)

procedure ban_acct_create_buynd(p_netid  IN sys.dba_users.username%type) is
    p_count number := 0;
    v_new_profile sys.dba_profiles.prfile%type;
begin

    if not ban_class_exists('GGN_ALL_BUY_ND_ONLY_C')
    then
        raise e_invalid_class;
    end if;

    if not ban_acct_exists(p_netid)
    then
        nd_dba_oracle_account_util.ora_acct_create(upper(p_netid), 'USERS', 'TEMP', 'ND_USR_LOCK_BUYND');
    end if;

    if not ban_acct_has_class(p_netid, 'GGN_ALL_BUY_ND_ONLY_C')
    then
        ban_account_grant_class('GGN_ALL_BUY_ND_ONLY_C');
    end if;

    v_new_profile = ban_suggest_profile(p_netid);
    ora_dba_account_util.ora_acct_change_profile(p_netid, v_new_profile);

    exception
    when e_invalid_class then
        raise_appication_error(-20004, 'Invalid class');

end ban_acct_create_buynd;
-- -----------------------------------------------------------------------------

procedure ban_acct_create_eprint(p_netid  IN sys.dba_users.username%type, p_class_list in varchar2) is
p_count number := 0;

BEGIN
if is_person_acct(p_netid)
THEN
   dbms_output.put_line('Valid Netid ' ||p_netid);

--    if not nd_dba_oracle_account_util.is_account(p_netid) 
--    then
--        nd_dba_oracle_account_util.ora_acct_create(upper(p_netid)....);
--    end if;

--        ban_acct_grant_banproxy(UPPER(p_netid));
--        ban_acct_grant_banjsproxy(upper(P_netid));
--        ora_dba_account_util.ora_acct_grant_roles(p_netid, 'a,b,c,d');
--        ban_acct_grant_classes(p_netid, p_class_list);
--
--    end if;

else   
   dbms_output.put_line('Invalid Netid ' ||p_netid);


end if;

end ban_acct_create_eprint;

--  procedure ban_acct_remove           (acct)
--  procedure ban_acct_revoke_class     (acct, class)
--  procedure ban_acct_remove_fundorg   (acct)
--  procedure ban_acct_remove_hrfundorg (acct)
--  procedure ban_acct_remove_gobeacc   (acct)
--  procedure ban_acct_clone_acct       (acct, clone)
-- -----------------------------------------------------------------------------
-- E N D   P A C K A G E
-- -----------------------------------------------------------------------------
end nd_dba_banner_account_util;
