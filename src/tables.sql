-- MySQL Script generated by MySQL Workbench
-- Sat 17 Jun 2017 05:56:17 PM -03
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema asms
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema asms
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `asms` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `asms` ;

-- -----------------------------------------------------
-- Table `asms`.`nodos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `asms`.`nodos` (
  `idnodos` INT NOT NULL AUTO_INCREMENT,
  `ipaddr` VARCHAR(45) NOT NULL,
  `hostname` VARCHAR(45) NOT NULL,
  `descricao` VARCHAR(140) NULL,
  `ativo` TINYINT(1) NOT NULL,
  PRIMARY KEY (`idnodos`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `asms`.`celulares`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `asms`.`celulares` (
  `idcelulares` INT NOT NULL AUTO_INCREMENT,
  `numero` VARCHAR(45) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `nome` VARCHAR(100) NULL,
  `nivel` INT NOT NULL,
  `ativo` TINYINT(1) NOT NULL,
  PRIMARY KEY (`idcelulares`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
