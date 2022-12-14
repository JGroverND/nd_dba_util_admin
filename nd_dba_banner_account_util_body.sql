create or replace package body nd_dba_util_admin.nd_dba_banner_account_util as
-- -----------------------------------------------------------------------------
-- file: nd_dba_banner_account_util.sql
-- desc: 
--
-- audit trail
-- 17-Jun-2022 John W Grover
--  - Original Code
-- 16-dec-2022 John W Grover
--  - added netid_has_spriden
--  - formatting and standardization
-- -----------------------------------------------------------------------------
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
    if ban_acct_exists(p_netid) then
        select count(spriden_id) into p_count
        from saturn.spriden
        where spriden_id = upper(p_netid)
        and spriden_ntyp_code = 'NI';
     end if;

    if p_count > 0 then
        return true;
    else
        return false;
    end if;
   
end is_person_acct;
-- -----------------------------------------------------------------------------

function is_sys_acct (p_netid in dba_users.username%type) return boolean is
-- system account sefined as being oracle maintained in dba_users
    p_count number := 0;
begin
    if ban_acct_exists(p_netid) then
      select count(username) into p_count
      from dba_users
     where username = upper(p_netid)
       and oracle_maintained = 'Y';
    end if;

    if p_count > 0 then
        return true;
    else
        return false;
    end if;

end is_sys_acct;
-- -----------------------------------------------------------------------------

function is_owner_acct (p_netid in dba_users.username%type) return boolean is
-- owner account defined as being owner of any database object
--  note: may need to refine by excluding certain object types
    p_count number := 0;
begin
    if ban_acct_exists(p_netid) then
        select count(owner) into p_count
        from sys.dba_objects
        where owner = upper(p_netid)
        order by owner;
     end if;

    if p_count > 0 then
        return true;
    else
        return false;
    end if;

end is_owner_acct;
-- -----------------------------------------------------------------------------

function is_link_acct (p_netid in dba_users.username%type) return boolean is
-- link account defines as already being defined as a link account.
--    it's circular, but the best we can do
    p_count number := 0;
begin
    if ban_acct_exists(p_netid) then
      select count(username) into p_count
      from dba_users
     where username = upper(p_netid)
       and profile = 'ND_LNK_OPEN_DEFAULT';
       
    end if;

    if p_count > 0 then
        return true;
    else
        return false;
    end if;
    
end is_link_acct;
-- -----------------------------------------------------------------------------

function is_qa_acct (p_netid in dba_users.username%type) return boolean is
-- qa account defined by username naming convention
    p_count number := 0;
begin
    if ban_acct_exists(p_netid) then
      select count(0) into p_count
      from dual
     where upper(p_netid) like 'ESQA%'
        or upper(p_netid) like 'PSINSTR%'
        or upper(p_netid) like 'PSTRN%'
        or upper(p_netid) like 'PSUSER%';
    end if;

    if p_count > 0 then
        return true;
    else
        return false;
    end if;
    
end is_qa_acct;
-- -----------------------------------------------------------------------------

function is_banner_baseline_acct (p_netid in dba_users.username%type) return boolean is
-- banner basline accounts defined by being in a manually managed list of acounts
    p_count number := 0;
begin
    if ban_acct_exists(p_netid) then
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
    end if;

    if p_count > 0 then
        return true;
    else
        return false;
    end if;
    
end is_banner_baseline_acct;
-- -----------------------------------------------------------------------------

function is_poweruser_acct (p_netid in dba_users.username%type) return boolean is
-- poweruser accounts defined by having extra ND roles assigned
--   note: this may need to be refined to a specific list of roles
    p_count number := 0;
begin
    if ban_acct_exists(p_netid) then
     select count(grantee) into p_count
      from dba_role_privs
      join saturn.spriden on ((spriden_id = grantee) and (spriden_ntyp_code = 'NI'))
     where grantee = upper(p_netid)
       and granted_role like 'ND%'
       and granted_role not in ('ND_CONNECT_S_ROLE', 'ND_RESOURCE_S_ROLE');
    end if;
    
    if p_count > 0 then
        return true;
    else
        return false;
    end if;
    
end is_poweruser_acct;
-- -----------------------------------------------------------------------------

function is_banner_user_acct (p_netid in dba_users.username%type) return boolean is
-- banner user (admin pages) accounts defined as being granted the GGN_ALL_USERS_C class
--   note: some cleanup required to make this entirely valid.
    p_count number := 0;
begin
    if ban_acct_exists(p_netid) then
      select count(gurucls_userid) into p_count
      from bansecr.gurucls
     where gurucls_userid = upper(p_netid)
       and gurucls_class_code = 'GGN_ALL_USERS_C';
    end if;

    if p_count > 0 then
        return true;
    else
        return false;
    end if;
    
end is_banner_user_acct;
-- -----------------------------------------------------------------------------

function is_eprint_acct (p_netid in dba_users.username%type) return boolean is
-- eprint accounts defined as being granted any eprint class
    p_count number := 0;
begin
    if ban_acct_exists(p_netid) then
      select count(gurucls_userid) into p_count
      from bansecr.gurucls
     where gurucls_userid = upper(p_netid)
       and gurucls_class_code like '%EPRINT%';
    end if;

    if p_count > 0 then
        return true;
    else
        return false;
    end if;

  end is_eprint_acct;
-- -----------------------------------------------------------------------------

function is_buynd_acct (p_netid in dba_users.username%type) return boolean is
-- buynd account defined as being granted the GGN_ALL_BUY_ND_ONLY_C class
    p_count number := 0;
begin
    if ban_acct_exists(p_netid) then
        select count(gurucls_userid) into p_count
        from bansecr.gurucls
        where gurucls_userid = upper(p_netid)
        and gurucls_class_code = 'GGN_ALL_BUY_ND_ONLY_C';
    end if;

    if p_count > 0 then
        return true;
    else
        return false;
    end if;
   
end is_buynd_acct;
-- -----------------------------------------------------------------------------

function is_fin_fundorg_acct (p_netid in dba_users.username%type) return boolean is
-- fin fundorg account defined as having a fomprof row
    p_count number := 0;
begin
    if ban_acct_exists(p_netid) then
        select count(fobprof_user_id) into p_count
        from fimsmgr.fobprof
        where fobprof_user_id = upper(p_netid);
    end if;

    if p_count > 0 then
        return true;
    else
        return false;
    end if;

end is_fin_fundorg_acct;
-- -----------------------------------------------------------------------------

function is_hr_fundorg_acct (p_netid in dba_users.username%type) return boolean is
-- hr fundorg account defined as having a nsrspsc row
    p_count number := 0;
begin
    if ban_acct_exists(p_netid) then
        select count(nsrspsc_user_code) into p_count 
          from posnctl.nsrspsc
         where nsrspsc_user_code = upper(p_netid);
    end if;

    if p_count > 0 then
        return true;
    else
        return false;
    end if;

end is_hr_fundorg_acct;
-- -----------------------------------------------------------------------------

function netid_has_spriden (p_netid in dba_users.username%type) return boolean is
-- person account defined as having a spriden row with ntype_code of 'NI'
-- sometimes we need to check for a person before an account is created
    p_count number := 0;
begin
    select count(spriden_id) into p_count
      from saturn.spriden
     where spriden_id = upper(p_netid)
       and spriden_ntyp_code = 'NI';

    if p_count > 0 then
        return true;
    else
        return false;
    end if;
end netid_has_spriden;

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
    if ban_acct_exists(p_netid) then
        select count(0) into p_count 
        from general.gobeacc 
        where upper(gobeacc_username) = upper(p_netid);
    end if;

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
    if ban_acct_exists(p_netid) then
        select count(0) into p_count 
        from sys.proxy_users 
        where upper(client) = upper(p_netid)
        and proxy = 'BANPROXY';
    end if;

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
    if ban_acct_exists(p_netid) then
        select count(0) into p_count 
        from sys.proxy_users 
        where upper(client) = upper(p_netid)
        and proxy = 'BANJSPROXY';
    end if;

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
    if  ban_acct_exists(p_netid)
    and ban_class_exists(p_class) then
        select count(0) into p_count
        from bansecr.gurucls 
        where upper(gurucls_userid) = upper(p_netid)
        and upper(gurucls_class_code) = upper(p_class);
    end if;

    if p_count > 0 then
        return true;
    else
        return false;
    end if;

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

function ban_acct_used_object(p_netid in bansecr.guraces.guraces_user_id%type,
                              p_object in bansecr.guraces.guraces_object%type) return boolean is
p_count number :=0;
begin
    if ban_acct_exists(p_netid) then
        select count(0) into p_count 
          from bansecr.guraces 
         where upper(guraces_user_id) = upper(p_netid)
           and upper(guraces_object) = upper(p_object);
    end if;

    if p_count > 0 then
        return true;
    else
        return false;
    end if;

end ban_acct_used_object;
-- -----------------------------------------------------------------------------

function ban_user_orgn_code(p_netid in sys.dba_users.username%type) return fimsmgr.ftvorgn.ftvorgn_orgn_code%type is
    v_orgn_code fimsmgr.ftvorgn.ftvorgn_orgn_code%type := 'XXXXXX';
begin
    if ban_acct_exists(p_netid) then
        select ftvorgn_orgn_code into v_orgn_code
        from saturn.spriden
        join payroll.pebempl on  pebempl_pidm = spriden_pidm
        join fimsmgr.ftvorgn on ftvorgn_coas_code = pebempl_coas_code_home
                            and ftvorgn_orgn_code = pebempl_orgn_code_home
                            and ftvorgn_eff_date <= SYSDATE
                            and ftvorgn_nchg_date > SYSDATE
        where spriden_id = upper(p_netid)
        and spriden_ntyp_code = 'NI';
    end if;

    return v_orgn_code;

end ban_user_orgn_code;
-- -----------------------------------------------------------------------------

function ban_acct_suggest_profile(p_netid in sys.dba_users.username%type) return sys.dba_users.profile%type is

-- Oracle Profiles Naming Convention:
-- The naming convention for Oracle profiles is intended to indicate at a glance what 
-- privileges an account can be expected to have and how it is allowed to be used. 
-- Accounts should be one of five types; system, owner, application, link or user, 
-- and have a default state of locked or unlocked. The named will be comprised 
-- of ???nodes??? separated by underbars.
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
    when e_invalid_account
    then
        raise_application_error(-20002, 'Account does not exist');

end ban_acct_suggest_profile;

-- -----------------------------------------------------------------------------
-- P R O C E D U R E S
-- -----------------------------------------------------------------------------

procedure ban_acct_grant_banproxy(p_netid in sys.proxy_users.client%type) is
    p_count  number := 0;
    sql_cmd  varchar(1000) := '';
    sql_undo varchar(1000) := '';
begin
    if not ban_netid_has_banproxy(p_netid) then
        sql_cmd  := 'alter user ' ||p_netid|| ' grant connect through banproxy';
        sql_undo := 'alter user ' ||p_netid|| ' revoke connect through banproxy';
        execute immediate sql_cmd;
    end if;

end ban_acct_grant_banproxy;
--------------------------------------------------------------------------------

procedure ban_acct_grant_banjsproxy(p_netid in sys.proxy_users.client%type) is
    p_count number := 0;
    sql_cmd  varchar(1000) := '';
    sql_undo varchar(1000) := '';
begin
    if not ban_netid_has_banjsproxy(p_netid) then
        sql_cmd  := 'alter user ' ||p_netid|| ' grant connect through banjsproxy';
        sql_undo := 'alter user ' ||p_netid|| ' revoke connect through banjsproxy';
        execute immediate sql_cmd;
    end if;

end ban_acct_grant_banjsproxy;
-- -----------------------------------------------------------------------------
--procedure that grant list of classes to Banner account
--------------------------------------------------------------------------------

procedure ban_acct_grant_class (p_netid IN dba_users.username%type, 
                                p_class in bansecr.gtvclas.gtvclas_class_code%type) is
    sql_cmd  varchar(1000) := '';
    sql_undo varchar(1000) := '';
begin
    if not ban_acct_exists(p_netid)
    then
        raise e_invalid_account;
    end if;

    if not ban_class_exists(p_class)
    then
        raise e_invalid_class;
    end if;

    sql_cmd := 'insert into bansecr.gurucls (GURUCLS_USERID,GURUCLS_CLASS_CODE,GURUCLS_ACTIVITY_DATE) '
            || 'values ('''
            || upper(p_netid)
            || ''', '''
            || upper(p_class) 
            || ''', sysdate)';
    sql_undo := 'delete from bansecr.gurucls where gurucls_userid = '''
            || upper(p_netid)
            || ''' and gurucls_class_code = '''
            || upper(p_class);

    execute immediate sql_cmd;

exception
    when e_invalid_account then
        raise_application_error(-20002, 'Account does not exist');
    when e_invalid_class then
        raise_application_error(-20004, 'class does not exist');
    when e_class_already_assigned then
        raise_application_error(-20008, 'class already assigned');

end ban_acct_grant_class;
--------------------------------------------------------------------------------
--procedure that list classes that need to be granted to an account
--------------------------------------------------------------------------------

procedure ban_acct_grant_class_list (p_netid IN dba_users.username%type, 
                                     p_class_list in varchar2) is
    v_classes varchar2(1000) := upper(p_class_list);
    cursor c1 is
    select regexp_substr(v_classes, '[^,]+', 1, level) class_name
        from dual
    connect by regexp_substr(v_classes, '[^,]+', 1, level) is not null;
    c1_rec c1%rowtype;
begin
    open c1;
    loop
        fetch c1 into c1_rec;
        exit when c1%notfound;
        ban_acct_grant_class(p_netid, c1_rec.class_name);
    end loop;
    close c1;

end ban_acct_grant_class_list;
--------------------------------------------------------------------------------
-- procedure that grants gobeacc to an account
--------------------------------------------------------------------------------

procedure ban_acct_create_gobeacc(p_netid IN dba_users.username%TYPE) is
    spriden_pidm  number;
    spriden_id varchar2(100);
    p_count number := 0;
    sql_cmd  varchar(1000) := '';
    sql_undo varchar(1000) := '';
begin
    if not ban_acct_exists(p_netid)
    then
        raise e_invalid_account;
    end if;

    if not ban_netid_has_gobeacc(p_netid) then
        select ' insert into general.gobeacc (GOBEACC_PIDM, GOBEACC_USERNAME, GOBEACC_USER_ID, GOBEACC_ACTIVITY_DATE) '
            || 'values ('
            || spriden_pidm
            || ', '''
            || spriden_id
            || ''', '''
            || user
            || ''', sysdate)' into sql_cmd
        from saturn.spriden
        where spriden_id = UPPER (p_netid);

        execute immediate sql_cmd;
    end if;

exception
    when e_invalid_account then
        raise_application_error(-20001, 'Account does not exist' ||p_netid||'');
    when e_gobeacc_exists then
        raise_application_error(-20005, 'Account has gobeacc ' ||p_netid||'');

end ban_acct_create_gobeacc;
--------------------------------------------------------------------------------
--  procedure ban_acct_create_inb_user (acct, type)
--------------------------------------------------------------------------------

procedure ban_acct_create_admin_pages (p_netid IN dba_users.username%type) is
    p_count number := 0;
begin
    if not ban_acct_exists(p_netid) then
        if netid_has_spriden(p_netid) then
            nd_dba_oracle_account_util.ora_acct_create(p_netid);
        else
            raise e_invalid_account;
        end if;

        ban_acct_grant_banproxy(p_netid);
        ban_acct_grant_banjsproxy(p_netid);
        ban_acct_create_gobeacc(p_netid);
        nd_dba_oracle_account_util.ora_acct_grant_role_list(p_netid, 'ND_CONNECT_S_ROLE,BAN_DEFAULT_Q,BAN_DEFAULT_M,BAN_DEFAULT_CONNECT');
        nd_dba_oracle_account_util.ora_acct_change_profile(p_netid, 'nd_usr_open_inbuser');
    end if;

exception
    when e_account_exists then
        raise_application_error(-20001, 'Account already exist');
    when e_invalid_account then
        raise_application_error(-20002, 'Invalid account');

end ban_acct_create_admin_pages;
--------------------------------------------------------------------------------
-- procedure to create inb sreg user
--------------------------------------------------------------------------------

procedure ban_acct_create_inb_sreg_user (p_netid IN dba_users.username%type, 
                                         p_class_list in varchar2) is
    p_count number := 0;
begin
    if not ban_acct_exists(p_netid) then
        if netid_has_spriden(p_netid) then
            ban_acct_create_admin_pages(p_netid);
            ban_acct_grant_class_list(p_netid,p_class_list);
        else
            raise e_invalid_account;
        end if;
    end if;

exception
    when e_account_exists then
        raise_application_error(-20001, 'Account already exist');
    when e_invalid_account then
        raise_application_error(-20002, 'Invalid account');

end ban_acct_create_inb_sreg_user;

--------------------------------------------------------------------------------
--procedure create BuyND account
--------------------------------------------------------------------------------
procedure ban_acct_create_buynd(p_netid in sys.dba_users.username%type) is
    p_count number := 0;
begin

    if not ban_class_exists('GGN_ALL_BUY_ND_ONLY_C') then
        raise e_invalid_class;
    end if;

    if not ban_acct_exists(p_netid) then
        if netid_has_spriden(p_netid) then
            ban_acct_create_admin_pages(p_netid);
        else
            raise e_invalid_account;
        end if;
    end if;

    if not ban_acct_has_class(p_netid, 'GGN_ALL_BUY_ND_ONLY_C') then
        ban_acct_grant_class(p_netid, 'GGN_ALL_BUY_ND_ONLY_C');
    end if;

    -- check the account profile and update is needed

end ban_acct_create_buynd;
-- -----------------------------------------------------------------------------

procedure ban_acct_create_eprint(p_netid  IN sys.dba_users.username%type,
                                 p_class_list in varchar2) is
    p_count number := 0;
begin
    if not ban_acct_exists(p_netid) then
        if netid_has_spriden(p_netid) then
            ban_acct_create_admin_pages(p_netid);
        else
            raise e_invalid_account;
        end if;
    end if;
    ban_acct_grant_class_list(upper(p_netid),p_class_list);

    -- check the account profile and update is needed

exception
    when e_invalid_account then
        raise_application_error(-20002, 'Invalid Account '||p_netid||'');  

end ban_acct_create_eprint;
-- -----------------------------------------------------------------------------
-- procedure to remove Banner account, objects and grants.
--------------------------------------------------------------------------------

procedure ban_acct_remove (p_netid IN dba_users.username%type) is
begin

    if ban_acct_exists(p_netid) then
        ban_acct_revoke_all_classes(p_netid);
        ban_acct_remove_gobeacc(p_netid);
        nd_dba_util_admin.nd_dba_oracle_account_util.ora_acct_drop(p_netid);
        ban_acct_remove_fundorg(p_netid);
        ban_acct_remove_hrfundorg (p_netid);
    else 
        raise e_invalid_account;
    end if;

exception
    when e_invalid_account then
            raise_application_error(-20002, 'Invalid Account '||p_netid||'');  

end ban_acct_remove;

--------------------------------------------------------------------------------
-- procedure to revoke class/classes from a user
--------------------------------------------------------------------------------
procedure ban_acct_revoke_class (p_netid IN dba_users.username%type, 
                                 p_class in bansecr.gtvclas.gtvclas_class_code%type) is
    sql_cmd  varchar(1000) := '';
    sql_undo varchar(1000) := '';
begin
    if not ban_acct_exists(p_netid) then
        raise e_invalid_account;
    end if;

    if not ban_class_exists(p_class) then
        raise e_invalid_class;
    end if;

    if ban_acct_has_class(p_netid, p_class) then
        sql_cmd := ' delete from bansecr.gurucls where gurucls_userid = ''' 
                || upper(p_netid)
                || ''' and gurucls_class_code = ''' 
                || upper(p_class)
                || '''' ;

        sql_undo := 'ban_acct_grant_class(''' || p_netid || ''',''' || p_class;
        execute immediate sql_cmd;
    end if;

    exception
    when e_invalid_account then
        raise_application_error(-20001, 'Account does not exist');
    when e_invalid_class then
        raise_application_error(-20002, 'Class does not exist');

end ban_acct_revoke_class;

--------------------------------------------------------------------------------
-- procedure that list class to revoke from user
--------------------------------------------------------------------------------
procedure ban_acct_revoke_class_list(p_netid IN dba_users.username%type, 
                                     p_class_list in varchar2) is

  cursor c1 is
    select regexp_substr(p_class_list, '[^,]+', 1, level) class_name
      from dual
   connect by regexp_substr(p_class_list, '[^,]+', 1, level) is not null;
  c1_rec c1%rowtype;
begin
    open c1;
    loop
        fetch c1 into c1_rec;
        exit when c1%notfound;
        ban_acct_revoke_class(p_netid, c1_rec.class_name);
    end loop;
    close c1;

end ban_acct_revoke_class_list;

-------------------------------------------------------------------------------
procedure ban_acct_revoke_all_classes(p_netid IN dba_users.username%type) is
  cursor c1 is
    select gurucls_class_code
      from bansecr.gurucls
     where gurucls_userid = p_netid;
  c1_rec c1%rowtype;
begin

    if ban_acct_exists(p_netid) then
        open c1;
        loop
            fetch c1 into c1_rec;
            exit when c1%notfound;
            ban_acct_revoke_class(p_netid, c1_rec.gurucls_class_code);
        end loop;
        close c1;
    end if;

end ban_acct_revoke_all_classes;

--------------------------------------------------------------------------------
--  procedure ban_acct_remove_hrfundorg (acct)
--------------------------------------------------------------------------------
procedure ban_acct_remove_hrfundorg (p_netid in dba_users.username%type) is
begin 

    if ban_acct_has_hrfundorg(p_netid) then
        execute immediate 'delete from posnctl.nsrspsc where nsrspsc_user_code = '''
            || p_netid
            || '''' ;
    end if;

end ban_acct_remove_hrfundorg;
-------------------------------------------------------------------------------
procedure ban_acct_remove_fundorg   (p_netid in dba_users.username%type) is
begin

    if ban_acct_has_fundorg(p_netid) then
        execute immediate 'delete from fimsmgr.fobprof where fobprof_user_id = '''
            || p_netid
            || '''' ;

        execute immediate 'delete from fimsmgr.forusfn where forusfn_user_id_entered = '''
            || p_netid
            || '''' ;
        execute immediate 'delete from fimsmgr.forusor where forusor_user_id_entered = '''
            || p_netid
            || '''' ;
        execute immediate 'delete from ndfiadmin.fzbzfop where fzbzfop_net_id = '''
            || p_netid
            || '''' ;

        execute immediate 'delete from ndfiadmin.zownfop where zownfop_net_id = '''
            || p_netid
            || '''' ;
    end if;

end ban_acct_remove_fundorg;

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  procedure ban_acct_remove_gobeacc   (acct)
--------------------------------------------------------------------------------
procedure ban_acct_remove_gobeacc(p_netid IN dba_users.username%TYPE) is
    spriden_pidm number;
    spriden_id varchar2(20); 
    p_count number := 0;
begin
    if  ban_netid_has_gobeacc(p_netid) then
        execute immediate 'delete from general.gobeacc where GOBEACC_USERNAME = '''
                ||upper(p_netid)
                ||'''';
    end if;

end ban_acct_remove_gobeacc;

--------------------------------------------------------------------------------
--  procedure ban_acct_clone_acct       (acct, clone)
-- -----------------------------------------------------------------------------

end nd_dba_banner_account_util;
