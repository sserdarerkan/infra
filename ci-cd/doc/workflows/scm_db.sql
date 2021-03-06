-- MySQL Script generated by MySQL Workbench
-- Cts 18 Nis 2020 02:13:15 +03
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema scm_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema scm_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `scm_db` DEFAULT CHARACTER SET utf8 ;
-- -----------------------------------------------------
-- Schema scm_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema scm_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `scm_db` DEFAULT CHARACTER SET latin1 ;
USE `scm_db` ;

-- -----------------------------------------------------
-- Table `scm_db`.`projects`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `scm_db`.`projects` ;

CREATE TABLE IF NOT EXISTS `scm_db`.`projects` (
  `project_name` VARCHAR(256) NOT NULL,
  PRIMARY KEY (`project_name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `scm_db`.`platforms`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `scm_db`.`platforms` ;

CREATE TABLE IF NOT EXISTS `scm_db`.`platforms` (
  `plarform_name` VARCHAR(256) NOT NULL,
  PRIMARY KEY (`plarform_name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `scm_db`.`os`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `scm_db`.`os` ;

CREATE TABLE IF NOT EXISTS `scm_db`.`os` (
  `os_name` VARCHAR(256) NOT NULL,
  PRIMARY KEY (`os_name`))
ENGINE = InnoDB;

USE `scm_db` ;

-- -----------------------------------------------------
-- Table `scm_db`.`dev_org`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `scm_db`.`dev_org` ;

CREATE TABLE IF NOT EXISTS `scm_db`.`dev_org` (
  `dev_org_name` VARCHAR(256) NOT NULL,
  PRIMARY KEY (`dev_org_name`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `scm_db`.`pkg_types`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `scm_db`.`pkg_types` ;

CREATE TABLE IF NOT EXISTS `scm_db`.`pkg_types` (
  `pkg_type` VARCHAR(256) NOT NULL,
  PRIMARY KEY (`pkg_type`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `scm_db`.`pkg_info`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `scm_db`.`pkg_info` ;

CREATE TABLE IF NOT EXISTS `scm_db`.`pkg_info` (
  `pkg_name` VARCHAR(256) NOT NULL,
  `dev_org_name` VARCHAR(256) NOT NULL,
  `pkg_type` VARCHAR(256) NOT NULL,
  `svn_trunk_url` VARCHAR(2048) NULL DEFAULT NULL,
  `svn_tag_url` VARCHAR(2048) NULL DEFAULT NULL,
  `git_url` VARCHAR(2048) NULL DEFAULT NULL,
  INDEX `pkg_type` (`pkg_type` ASC),
  INDEX `dev_org_name` (`dev_org_name` ASC),
  PRIMARY KEY (`pkg_name`),
  CONSTRAINT `pkg_info_ibfk_1`
    FOREIGN KEY (`pkg_type`)
    REFERENCES `scm_db`.`pkg_types` (`pkg_type`),
  CONSTRAINT `pkg_info_ibfk_2`
    FOREIGN KEY (`dev_org_name`)
    REFERENCES `scm_db`.`dev_org` (`dev_org_name`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `scm_db`.`platform_info`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `scm_db`.`platform_info` ;

CREATE TABLE IF NOT EXISTS `scm_db`.`platform_info` (
  `id` INT NOT NULL,
  `project` VARCHAR(256) NULL,
  `platform` VARCHAR(256) NULL,
  `os` VARCHAR(256) NULL,
  UNIQUE INDEX `platform_UNIQUE` (`project` ASC, `platform` ASC, `os` ASC),
  PRIMARY KEY (`id`),
  INDEX `fk_platform_info_1_idx` (`platform` ASC),
  INDEX `fk_platform_info_2_idx` (`os` ASC),
  CONSTRAINT `platform_ibfk_1`
    FOREIGN KEY (`project`)
    REFERENCES `scm_db`.`projects` (`project_name`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_platform_info_1`
    FOREIGN KEY (`platform`)
    REFERENCES `scm_db`.`platforms` (`plarform_name`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_platform_info_2`
    FOREIGN KEY (`os`)
    REFERENCES `scm_db`.`os` (`os_name`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `scm_db`.`platform_pkg_info`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `scm_db`.`platform_pkg_info` ;

CREATE TABLE IF NOT EXISTS `scm_db`.`platform_pkg_info` (
  `pkg_name` VARCHAR(256) NOT NULL,
  `platform_id` INT NOT NULL,
  PRIMARY KEY (`pkg_name`, `platform_id`),
  INDEX `platform_pkg_conf_ibfk_2_idx` (`platform_id` ASC),
  CONSTRAINT `platform_pkg_conf_ibfk_1`
    FOREIGN KEY (`pkg_name`)
    REFERENCES `scm_db`.`pkg_info` (`pkg_name`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `platform_pkg_conf_ibfk_2`
    FOREIGN KEY (`platform_id`)
    REFERENCES `scm_db`.`platform_info` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `scm_db`.`platform_status`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `scm_db`.`platform_status` ;

CREATE TABLE IF NOT EXISTS `scm_db`.`platform_status` (
  `platform_status_id` INT NOT NULL,
  `platform_id` INT NOT NULL,
  `current_version` VARCHAR(32) NOT NULL,
  `previous_version` VARCHAR(32) NOT NULL,
  `ptimestamp` TIMESTAMP(20) NOT NULL,
  `changelog` LONGTEXT NOT NULL,
  `stage` ENUM('FAT') NULL,
  `pkgset_status` ENUM('DEFINED', 'BUILT', 'UPDATED', 'UPDATE_BUILT', 'DEPLOYED','TESTED') NULL,
  `test_env_name` VARCHAR(256) NULL,
  INDEX `project_platform_changelog_ibfk_1_idx` (`platform_id` ASC),
  PRIMARY KEY (`platform_status_id`),
  UNIQUE INDEX `platform_UNIQUE` (`platform_id` ASC, `current_version` ASC),
  INDEX `fk_platform_status_1_idx` (`test_env_name` ASC),
  CONSTRAINT `project_platform_changelog_ibfk_1`
    FOREIGN KEY (`platform_id`)
    REFERENCES `scm_db0`.`platform_info` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_platform_status_1`
    FOREIGN KEY (`test_env_name`)
    REFERENCES `scm_db`.`test_environments` (`test_env_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `scm_db`.`platform_software_conf`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `scm_db`.`platform_software_conf` ;

CREATE TABLE IF NOT EXISTS `scm_db`.`platform_software_conf` (
  `platform_status_id` INT NOT NULL,
  `pkg_name` VARCHAR(256) NOT NULL,
  `pkg_version` VARCHAR(64) NOT NULL,
  `pkg_revision` VARCHAR(256) NOT NULL,
  `ptimestamp` TIMESTAMP(10) NOT NULL,
  PRIMARY KEY (`platform_status_id`, `pkg_name`),
  CONSTRAINT `fk_platform_pkg_status_1`
    FOREIGN KEY (`pkg_name`)
    REFERENCES `scm_db`.`pkg_info` (`pkg_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `scm_db`.`platform_software_conf_history`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `scm_db`.`platform_software_conf_history` ;

CREATE TABLE IF NOT EXISTS `scm_db`.`platform_software_conf_history` (
  `platform_status_id` VARCHAR(256) NOT NULL,
  `pkg_name` VARCHAR(256) NOT NULL,
  `pkg_version` VARCHAR(256) NOT NULL,
  `pkg_revision` VARCHAR(256) NOT NULL,
  `ptimestamp` TIMESTAMP(10) NOT NULL
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;



DROP TABLE IF EXISTS `scm_db`.`test_environments` ;

CREATE TABLE IF NOT EXISTS `scm_db`.`test_environments` (
  `test_env_name` VARCHAR(256) NOT NULL,
  `project` VARCHAR(256) NOT NULL,
  `gateway` VARCHAR(256) NULL,
  `site` ENUM('ARM', 'HVL') NOT NULL,
  `status` ENUM('FREE', 'PROTECTED') NOT NULL DEFAULT 'FREE',
  `protection_reason` VARCHAR(256) NULL,
  PRIMARY KEY (`test_env_name`, `site`, `project`),
  INDEX `fk_test_environments_1_idx` (`project` ASC),
  CONSTRAINT `fk_test_environments_1`
    FOREIGN KEY (`project`)
    REFERENCES `scm_db`.`projects` (`project_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
USE `scm_db`;

DELIMITER $$

USE `scm_db`$$
DROP TRIGGER IF EXISTS `scm_db`.`platform_software_conf_AFTER_UPDATE` $$
USE `scm_db`$$
CREATE DEFINER = CURRENT_USER TRIGGER `scm_db`.`platform_software_conf_AFTER_UPDATE` AFTER UPDATE ON `platform_software_conf` FOR EACH ROW
BEGIN
insert into platform_software_conf_history (platform_status_id, pkg_name,pkg_version,pkg_revision,ptimestamp,pkgset_status) values (new.platform_status_id, new.pkg_name,new.pkg_version,new.pkg_revision,new.ptimestamp,new.pkgset_status);
END$$


DELIMITER ;
