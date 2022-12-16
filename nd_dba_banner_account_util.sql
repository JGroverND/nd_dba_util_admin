create or replace package nd_dba_util_admin.nd_dba_banner_account_util as
-- -----------------------------------------------------------------------------
-- file: nd_dba_banner_account_util.sql
-- desc: 
--
-- audit trail
-- 17-Jun-2022 John W Grover
--  - Original Code
-- 16-dec-2022 John W Grover
--  - added netid_has_spriden
-- -----------------------------------------------------------------------------

    -- E X C E P T I O N S
    e_account_exists            exception; -- -20001
    e_invalid_account           exception; -- -20002
    e_class_exists              exception; -- -20003
    e_invalid_class             exception; -- -20004
    e_gobeacc_exists            exception; -- -20005
    e_gobeacc_does_not_exist    exception; -- -20006
    e_class_not_assigned        exception; -- -20007
    e_class_already_assigned    exception; -- -20008
    e_profile_not_found         exception; -- -20009

    -- C U R S O R S

    -- V A R I A B L E S

    -- F U N C T I O N S

    --
    -- Account type functions
    --
    --  function is_account             (p_netid in dba_users.username%type) return boolean;
    function is_person_acct             (p_netid in dba_users.username%type) return boolean;
    function is_sys_acct                (p_netid in dba_users.username%type) return boolean;
    function is_owner_acct              (p_netid in dba_users.username%type) return boolean;
    function is_link_acct               (p_netid in dba_users.username%type) return boolean;
    function is_qa_acct                 (p_netid in dba_users.username%type) return boolean;
    function is_banner_baseline_acct    (p_netid in dba_users.username%type) return boolean;
    function is_poweruser_acct          (p_netid in dba_users.username%type) return boolean;
    function is_banner_user_acct        (p_netid in dba_users.username%type) return boolean;
    function is_eprint_acct             (p_netid in dba_users.username%type) return boolean;
    function is_buynd_acct              (p_netid in dba_users.username%type) return boolean;
    function is_fin_fundorg_acct        (p_netid in dba_users.username%type) return boolean;
    function is_hr_fundorg_acct         (p_netid in dba_users.username%type) return boolean;

    function netid_has_spriden          (p_netid in dba_users.username%type) return boolean;
    --
    -- Banner specific functions
    --
    function ban_acct_exists            (p_netid in dba_users.username%type)                    return boolean;
    function ban_class_exists           (p_class in bansecr.gtvclas.gtvclas_class_code%type)    return boolean;
    function ban_netid_has_gobeacc      (p_netid in general.gobeacc.gobeacc_username%type)      return boolean;
    function ban_netid_has_banproxy     (p_netid in sys.proxy_users.client%type)                return boolean;
    function ban_netid_has_banjsproxy   (p_netid in sys.proxy_users.client%type)                return boolean;
    function ban_acct_has_class         (p_netid in bansecr.gurucls.gurucls_userid%type, 
                                         p_class in bansecr.gurucls.gurucls_class_code%type)    return boolean;
    function ban_acct_has_fundorg       (p_netid in fimsmgr.fobprof.fobprof_user_id%type)       return boolean;
    function ban_acct_has_hrfundorg     (p_netid in posnctl.nsrspsc.nsrspsc_user_code%type)     return boolean;
    function ban_acct_used_object       (p_netid  in bansecr.guraces.guraces_user_id%type,
                                         p_object in bansecr.guraces.guraces_object%type)       return boolean;
    function ban_user_orgn_code         (p_netid in sys.dba_users.username%type)                return fimsmgr.ftvorgn.ftvorgn_orgn_code%type;
    function ban_acct_suggest_profile   (p_netid in sys.dba_users.username%type)                return sys.dba_users.profile%type;

-- P R O C E D U R E S
    procedure ban_acct_grant_banproxy       (p_netid in sys.proxy_users.client%type);
    procedure ban_acct_grant_banjsproxy     (p_netid in sys.proxy_users.client%type);
    procedure ban_acct_grant_class          (p_netid IN dba_users.username%type, 
                                             p_class in bansecr.gtvclas.gtvclas_class_code%type);
    procedure ban_acct_grant_class_list     (p_netid IN dba_users.username%type, 
                                             p_class_list in varchar2);
    procedure ban_acct_create_gobeacc       (p_netid IN dba_users.username%type);
    procedure ban_acct_create_admin_pages   (p_netid IN dba_users.username%type);
    procedure ban_acct_create_inb_sreg_user (p_netid IN dba_users.username%type,
                                             p_class_list in varchar2);
    procedure ban_acct_create_buynd         (p_netid  IN sys.dba_users.username%type);
    procedure ban_acct_create_eprint        (p_netid  IN sys.dba_users.username%type,
                                             p_class_list in varchar2);
    procedure ban_acct_remove               (p_netid IN dba_users.username%type);
    procedure ban_acct_revoke_class         (p_netid IN dba_users.username%type, 
                                             p_class in bansecr.gtvclas.gtvclas_class_code%type);
    procedure ban_acct_revoke_all_classes   (p_netid IN dba_users.username%type);
    procedure ban_acct_revoke_class_list    (p_netid IN dba_users.username%type, 
                                             p_class_list in varchar2);
    procedure ban_acct_remove_gobeacc       (p_netid IN dba_users.username%TYPE);
    procedure ban_acct_remove_fundorg       (p_netid in dba_users.username%type);
    procedure ban_acct_remove_hrfundorg     (p_netid in dba_users.username%type);
--  procedure ban_acct_clone_acct       (acct, clone)

-- -----------------------------------------------------------------------------
--                                                   E N D   O F   P A C K A G E
-- -----------------------------------------------------------------------------
end nd_dba_banner_account_util;
