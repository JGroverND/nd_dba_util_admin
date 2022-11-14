-- ---------------------------------------------------------------------
-- Profiles- Development systems
-- ---------------------------------------------------------------------
ALTER PROFILE DEFAULT LIMIT
  CONNECT_TIME                     15
  IDLE_TIME                        5
  SESSIONS_PER_USER                1
  FAILED_LOGIN_ATTEMPTS            3
  PASSWORD_GRACE_TIME              0
  PASSWORD_LOCK_TIME               .01
  COMPOSITE_LIMIT                  UNLIMITED
  CPU_PER_CALL                     UNLIMITED
  CPU_PER_SESSION                  UNLIMITED
  LOGICAL_READS_PER_CALL           UNLIMITED
  LOGICAL_READS_PER_SESSION        UNLIMITED
  PRIVATE_SGA                      UNLIMITED
  PASSWORD_LIFE_TIME               UNLIMITED
  PASSWORD_REUSE_MAX               UNLIMITED
  PASSWORD_REUSE_TIME              UNLIMITED
  PASSWORD_VERIFY_FUNCTION         NULL ;

-- ---------------------------------------------------------------------
ALTER PROFILE ND_TMP_UNLIMITED LIMIT
  CONNECT_TIME                     unlimited
  IDLE_TIME                        unlimited
  SESSIONS_PER_USER                unlimited
  FAILED_LOGIN_ATTEMPTS            unlimited
  PASSWORD_GRACE_TIME              unlimited
  PASSWORD_LOCK_TIME               unlimited
  COMPOSITE_LIMIT                  DEFAULT
  CPU_PER_CALL                     DEFAULT
  CPU_PER_SESSION                  DEFAULT
  LOGICAL_READS_PER_CALL           DEFAULT
  LOGICAL_READS_PER_SESSION        DEFAULT
  PRIVATE_SGA                      DEFAULT
  PASSWORD_LIFE_TIME               DEFAULT
  PASSWORD_REUSE_MAX               DEFAULT
  PASSWORD_REUSE_TIME              DEFAULT
  PASSWORD_VERIFY_FUNCTION         DEFAULT;

-- ---------------------------------------------------------------------
ALTER PROFILE ND_APP_OPEN_DEFAULT LIMIT
  CONNECT_TIME                     unlimited
  IDLE_TIME                        unlimited
  SESSIONS_PER_USER                unlimited
  FAILED_LOGIN_ATTEMPTS            DEFAULT
  PASSWORD_GRACE_TIME              DEFAULT
  PASSWORD_LOCK_TIME               DEFAULT
  COMPOSITE_LIMIT                  DEFAULT
  CPU_PER_CALL                     DEFAULT
  CPU_PER_SESSION                  DEFAULT
  LOGICAL_READS_PER_CALL           DEFAULT
  LOGICAL_READS_PER_SESSION        DEFAULT
  PRIVATE_SGA                      DEFAULT
  PASSWORD_LIFE_TIME               DEFAULT
  PASSWORD_REUSE_MAX               DEFAULT
  PASSWORD_REUSE_TIME              DEFAULT ;

-- ---------------------------------------------------------------------
ALTER PROFILE ND_LNK_OPEN_DEFAULT LIMIT
  CONNECT_TIME                     unlimited
  IDLE_TIME                        unlimited
  SESSIONS_PER_USER                unlimited
  FAILED_LOGIN_ATTEMPTS            1
  PASSWORD_GRACE_TIME              DEFAULT
  PASSWORD_LOCK_TIME               DEFAULT
  COMPOSITE_LIMIT                  DEFAULT
  CPU_PER_CALL                     DEFAULT
  CPU_PER_SESSION                  DEFAULT
  LOGICAL_READS_PER_CALL           DEFAULT
  LOGICAL_READS_PER_SESSION        DEFAULT
  PRIVATE_SGA                      DEFAULT
  PASSWORD_LIFE_TIME               DEFAULT
  PASSWORD_REUSE_MAX               DEFAULT
  PASSWORD_REUSE_TIME              DEFAULT ;

-- ---------------------------------------------------------------------
ALTER PROFILE ND_OWN_LOCK_DEFAULT LIMIT
  CONNECT_TIME                     720
  IDLE_TIME                        240
  SESSIONS_PER_USER                DEFAULT
  FAILED_LOGIN_ATTEMPTS            1
  PASSWORD_GRACE_TIME              DEFAULT
  PASSWORD_LOCK_TIME               DEFAULT
  COMPOSITE_LIMIT                  DEFAULT
  CPU_PER_CALL                     DEFAULT
  CPU_PER_SESSION                  DEFAULT
  LOGICAL_READS_PER_CALL           DEFAULT
  LOGICAL_READS_PER_SESSION        DEFAULT
  PRIVATE_SGA                      DEFAULT
  PASSWORD_LIFE_TIME               DEFAULT
  PASSWORD_REUSE_MAX               DEFAULT
  PASSWORD_REUSE_TIME              DEFAULT
  PASSWORD_VERIFY_FUNCTION         DEFAULT ;

-- ---------------------------------------------------------------------
ALTER PROFILE ND_OWN_OPEN_DEFAULT LIMIT
  CONNECT_TIME                     unlimited
  IDLE_TIME                        unlimited
  SESSIONS_PER_USER                unlimited
  FAILED_LOGIN_ATTEMPTS            DEFAULT
  PASSWORD_GRACE_TIME              DEFAULT
  PASSWORD_LOCK_TIME               DEFAULT
  COMPOSITE_LIMIT                  DEFAULT
  CPU_PER_CALL                     DEFAULT
  CPU_PER_SESSION                  DEFAULT
  LOGICAL_READS_PER_CALL           DEFAULT
  LOGICAL_READS_PER_SESSION        DEFAULT
  PRIVATE_SGA                      DEFAULT
  PASSWORD_LIFE_TIME               DEFAULT
  PASSWORD_REUSE_MAX               DEFAULT
  PASSWORD_REUSE_TIME              DEFAULT
  PASSWORD_VERIFY_FUNCTION         DEFAULT ;

-- ---------------------------------------------------------------------
-- CREATE PROFILE ND_OWN_OPEN_DEVELOPER LIMIT
--   CONNECT_TIME                     unlimited ;

ALTER PROFILE ND_OWN_OPEN_DEVELOPER LIMIT
  CONNECT_TIME                     unlimited
  IDLE_TIME                        unlimited
  SESSIONS_PER_USER                unlimited
  FAILED_LOGIN_ATTEMPTS            DEFAULT
  PASSWORD_GRACE_TIME              DEFAULT
  PASSWORD_LOCK_TIME               DEFAULT
  COMPOSITE_LIMIT                  DEFAULT
  CPU_PER_CALL                     DEFAULT
  CPU_PER_SESSION                  DEFAULT
  LOGICAL_READS_PER_CALL           DEFAULT
  LOGICAL_READS_PER_SESSION        DEFAULT
  PRIVATE_SGA                      DEFAULT
  PASSWORD_LIFE_TIME               DEFAULT
  PASSWORD_REUSE_MAX               DEFAULT
  PASSWORD_REUSE_TIME              DEFAULT
  PASSWORD_VERIFY_FUNCTION         DEFAULT ;

-- ---------------------------------------------------------------------
ALTER PROFILE ND_SYS_LOCK_ORACLE LIMIT
  CONNECT_TIME                     720
  IDLE_TIME                        240
  SESSIONS_PER_USER                2
  FAILED_LOGIN_ATTEMPTS            1
  PASSWORD_GRACE_TIME              DEFAULT
  PASSWORD_LOCK_TIME               DEFAULT
  COMPOSITE_LIMIT                  DEFAULT
  CPU_PER_CALL                     DEFAULT
  CPU_PER_SESSION                  DEFAULT
  LOGICAL_READS_PER_CALL           DEFAULT
  LOGICAL_READS_PER_SESSION        DEFAULT
  PRIVATE_SGA                      DEFAULT
  PASSWORD_LIFE_TIME               5
  PASSWORD_REUSE_MAX               DEFAULT
  PASSWORD_REUSE_TIME              DEFAULT
  PASSWORD_VERIFY_FUNCTION         DEFAULT ;

-- ---------------------------------------------------------------------
ALTER PROFILE ND_SYS_OPEN_ORACLE LIMIT
  CONNECT_TIME                     unlimited
  IDLE_TIME                        unlimited
  SESSIONS_PER_USER                2
  FAILED_LOGIN_ATTEMPTS            DEFAULT
  PASSWORD_GRACE_TIME              DEFAULT
  PASSWORD_LOCK_TIME               DEFAULT
  COMPOSITE_LIMIT                  DEFAULT
  CPU_PER_CALL                     DEFAULT
  CPU_PER_SESSION                  DEFAULT
  LOGICAL_READS_PER_CALL           DEFAULT
  LOGICAL_READS_PER_SESSION        DEFAULT
  PRIVATE_SGA                      DEFAULT
  PASSWORD_LIFE_TIME               DEFAULT
  PASSWORD_REUSE_MAX               DEFAULT
  PASSWORD_REUSE_TIME              DEFAULT
  PASSWORD_VERIFY_FUNCTION         DEFAULT ;

-- ---------------------------------------------------------------------
ALTER PROFILE ND_SYS_OPEN_OPERATIONS LIMIT
  CONNECT_TIME                     unlimited
  IDLE_TIME                        unlimited
  SESSIONS_PER_USER                unlimited
  FAILED_LOGIN_ATTEMPTS            DEFAULT
  PASSWORD_GRACE_TIME              DEFAULT
  PASSWORD_LOCK_TIME               DEFAULT
  COMPOSITE_LIMIT                  DEFAULT
  CPU_PER_CALL                     DEFAULT
  CPU_PER_SESSION                  DEFAULT
  LOGICAL_READS_PER_CALL           DEFAULT
  LOGICAL_READS_PER_SESSION        DEFAULT
  PRIVATE_SGA                      DEFAULT
  PASSWORD_LIFE_TIME               DEFAULT
  PASSWORD_REUSE_MAX               DEFAULT
  PASSWORD_REUSE_TIME              DEFAULT
  PASSWORD_VERIFY_FUNCTION         DEFAULT ;
-- ---------------------------------------------------------------------

ALTER PROFILE ND_USR_OPEN_DEFAULT LIMIT
  CONNECT_TIME                     720
  IDLE_TIME                        240
  SESSIONS_PER_USER                DEFAULT
  FAILED_LOGIN_ATTEMPTS            DEFAULT
  PASSWORD_GRACE_TIME              DEFAULT
  PASSWORD_LOCK_TIME               DEFAULT
  COMPOSITE_LIMIT                  DEFAULT
  CPU_PER_CALL                     DEFAULT
  CPU_PER_SESSION                  DEFAULT
  LOGICAL_READS_PER_CALL           DEFAULT
  LOGICAL_READS_PER_SESSION        DEFAULT
  PRIVATE_SGA                      DEFAULT
  PASSWORD_LIFE_TIME               DEFAULT
  PASSWORD_REUSE_MAX               DEFAULT
  PASSWORD_REUSE_TIME              DEFAULT
  PASSWORD_VERIFY_FUNCTION         DEFAULT ;

-- ---------------------------------------------------------------------
ALTER PROFILE ND_USR_OPEN_DBA LIMIT
  CONNECT_TIME                     720
  IDLE_TIME                        240
  SESSIONS_PER_USER                3
  FAILED_LOGIN_ATTEMPTS            DEFAULT
  PASSWORD_GRACE_TIME              DEFAULT
  PASSWORD_LOCK_TIME               DEFAULT
  COMPOSITE_LIMIT                  DEFAULT
  CPU_PER_CALL                     DEFAULT
  CPU_PER_SESSION                  DEFAULT
  LOGICAL_READS_PER_CALL           DEFAULT
  LOGICAL_READS_PER_SESSION        DEFAULT
  PRIVATE_SGA                      DEFAULT
  PASSWORD_LIFE_TIME               DEFAULT
  PASSWORD_REUSE_MAX               DEFAULT
  PASSWORD_REUSE_TIME              DEFAULT
  PASSWORD_VERIFY_FUNCTION         DEFAULT ;

-- ---------------------------------------------------------------------
ALTER PROFILE ND_USR_OPEN_DEVELOPER LIMIT
  CONNECT_TIME                     720
  IDLE_TIME                        240
  SESSIONS_PER_USER                10
  FAILED_LOGIN_ATTEMPTS            DEFAULT
  PASSWORD_GRACE_TIME              DEFAULT
  PASSWORD_LOCK_TIME               DEFAULT
  COMPOSITE_LIMIT                  DEFAULT
  CPU_PER_CALL                     DEFAULT
  CPU_PER_SESSION                  DEFAULT
  LOGICAL_READS_PER_CALL           DEFAULT
  LOGICAL_READS_PER_SESSION        DEFAULT
  PRIVATE_SGA                      DEFAULT
  PASSWORD_LIFE_TIME               DEFAULT
  PASSWORD_REUSE_MAX               DEFAULT
  PASSWORD_REUSE_TIME              DEFAULT
  PASSWORD_VERIFY_FUNCTION         DEFAULT ;

-- ---------------------------------------------------------------------
ALTER PROFILE ND_USR_OPEN_POWERUSER LIMIT
  CONNECT_TIME                     720
  IDLE_TIME                        240
  SESSIONS_PER_USER                6
  FAILED_LOGIN_ATTEMPTS            DEFAULT
  PASSWORD_GRACE_TIME              DEFAULT
  PASSWORD_LOCK_TIME               DEFAULT
  COMPOSITE_LIMIT                  DEFAULT
  CPU_PER_CALL                     DEFAULT
  CPU_PER_SESSION                  DEFAULT
  LOGICAL_READS_PER_CALL           DEFAULT
  LOGICAL_READS_PER_SESSION        DEFAULT
  PRIVATE_SGA                      DEFAULT
  PASSWORD_LIFE_TIME               DEFAULT
  PASSWORD_REUSE_MAX               DEFAULT
  PASSWORD_REUSE_TIME              DEFAULT
  PASSWORD_VERIFY_FUNCTION         DEFAULT ;

-- ---------------------------------------------------------------------
ALTER PROFILE ND_USR_LOCK_DEFAULT LIMIT
  CONNECT_TIME                     720
  IDLE_TIME                        240
  SESSIONS_PER_USER                DEFAULT
  FAILED_LOGIN_ATTEMPTS            DEFAULT
  PASSWORD_GRACE_TIME              DEFAULT
  PASSWORD_LOCK_TIME               DEFAULT
  COMPOSITE_LIMIT                  DEFAULT
  CPU_PER_CALL                     DEFAULT
  CPU_PER_SESSION                  DEFAULT
  LOGICAL_READS_PER_CALL           DEFAULT
  LOGICAL_READS_PER_SESSION        DEFAULT
  PRIVATE_SGA                      DEFAULT
  PASSWORD_LIFE_TIME               DEFAULT
  PASSWORD_REUSE_MAX               DEFAULT
  PASSWORD_REUSE_TIME              DEFAULT

-- ---------------------------------------------------------------------
ALTER PROFILE ND_USR_OPEN_DBA LIMIT
  CONNECT_TIME                     720
  IDLE_TIME                        240
  SESSIONS_PER_USER                3
  FAILED_LOGIN_ATTEMPTS            DEFAULT
  PASSWORD_GRACE_TIME              DEFAULT
  PASSWORD_LOCK_TIME               DEFAULT
  COMPOSITE_LIMIT                  DEFAULT
  CPU_PER_CALL                     DEFAULT
  CPU_PER_SESSION                  DEFAULT
  LOGICAL_READS_PER_CALL           DEFAULT
  LOGICAL_READS_PER_SESSION        DEFAULT
  PRIVATE_SGA                      DEFAULT
  PASSWORD_LIFE_TIME               DEFAULT
  PASSWORD_REUSE_MAX               DEFAULT
  PASSWORD_REUSE_TIME              DEFAULT
  PASSWORD_VERIFY_FUNCTION         DEFAULT ;

-- ---------------------------------------------------------------------
ALTER PROFILE ND_USR_LOCK_AUTHONLY LIMIT
  CONNECT_TIME                     DEFAULT
  IDLE_TIME                        DEFAULT
  SESSIONS_PER_USER                DEFAULT
  FAILED_LOGIN_ATTEMPTS            DEFAULT
  PASSWORD_GRACE_TIME              DEFAULT
  PASSWORD_LOCK_TIME               DEFAULT
  COMPOSITE_LIMIT                  DEFAULT
  CPU_PER_CALL                     DEFAULT
  CPU_PER_SESSION                  DEFAULT
  LOGICAL_READS_PER_CALL           DEFAULT
  LOGICAL_READS_PER_SESSION        DEFAULT
  PRIVATE_SGA                      DEFAULT
  PASSWORD_LIFE_TIME               DEFAULT
  PASSWORD_REUSE_MAX               DEFAULT
  PASSWORD_REUSE_TIME              DEFAULT
  PASSWORD_VERIFY_FUNCTION         DEFAULT ;

-- ---------------------------------------------------------------------
CREATE PROFILE ND_USR_LOCK_FFUNDORG LIMIT
  CONNECT_TIME                     720
  IDLE_TIME                        240
  SESSIONS_PER_USER                DEFAULT
  FAILED_LOGIN_ATTEMPTS            DEFAULT
  PASSWORD_GRACE_TIME              DEFAULT
  PASSWORD_LOCK_TIME               DEFAULT
  COMPOSITE_LIMIT                  DEFAULT
  CPU_PER_CALL                     DEFAULT
  CPU_PER_SESSION                  DEFAULT
  LOGICAL_READS_PER_CALL           DEFAULT
  LOGICAL_READS_PER_SESSION        DEFAULT
  PRIVATE_SGA                      DEFAULT
  PASSWORD_LIFE_TIME               DEFAULT
  PASSWORD_REUSE_MAX               DEFAULT
  PASSWORD_REUSE_TIME              DEFAULT
;


-- ---------------------------------------------------------------------
-- Fin
-- ---------------------------------------------------------------------

