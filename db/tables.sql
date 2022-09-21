-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema moddb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema moddb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `moddb` DEFAULT CHARACTER SET utf8 ;
USE `moddb` ;

-- -----------------------------------------------------
-- Table `moddb`.`asset`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `moddb`.`asset` (
  `assetid` INT NOT NULL AUTO_INCREMENT,
  `createdbyuserid` INT NULL,
  `editedbyuserid` INT NULL,
  `statusid` INT NULL,
  `assettypeid` INT NULL,
  `code` VARCHAR(255) NULL,
  `name` VARCHAR(255) NULL,
  `text` TEXT NULL,
  `tagscached` TEXT NULL,
  `created` DATETIME NULL,
  `lastmodified` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `numsaved` INT NULL,
  PRIMARY KEY (`assetid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `moddb`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `moddb`.`user` (
  `userid` INT NOT NULL AUTO_INCREMENT,
  `roleid` INT NULL DEFAULT 3,
  `uid` VARCHAR(255) NULL,
  `name` VARCHAR(255) NULL,
  `password` VARCHAR(255) NULL,
  `email` VARCHAR(255) NULL,
  `actiontoken` VARCHAR(255) NULL,
  `sessiontoken` VARCHAR(255) NULL,
  `sessiontokenvaliduntil` DATETIME NULL,
  `timezone` VARCHAR(255) NULL,
  `created` DATETIME NULL,
  `lastmodified` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `lastonline` DATETIME NULL,
  PRIMARY KEY (`userid`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  INDEX `uid` (`uid` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `moddb`.`file`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `moddb`.`file` (
  `fileid` INT NOT NULL AUTO_INCREMENT,
  `assetid` INT NULL,
  `assettypeid` INT NULL COMMENT 'Required for assets that don\'t exist yet, otherwise we cannot verify if the right assettypeid was passed on during asset creation',
  `userid` INT NULL,
  `downloads` INT NULL DEFAULT 0,
  `filename` VARCHAR(255) NULL,
  `thumbnailfilename` VARCHAR(255) NULL,
  `type` ENUM('portrait', 'asset', 'shape', 'texture', 'sound') NULL,
  `created` DATETIME NULL,
  `lastmodified` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`fileid`),
  INDEX `assetid` (`assetid` ASC) VISIBLE,
  INDEX `tempuploadtoken` (`userid` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `moddb`.`status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `moddb`.`status` (
  `statusid` INT NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(255) NULL,
  `name` VARCHAR(255) NULL,
  `created` DATETIME NULL DEFAULT NULL,
  `sortorder` INT NULL,
  `lastmodified` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`statusid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `moddb`.`comment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `moddb`.`comment` (
  `commentid` INT NOT NULL AUTO_INCREMENT,
  `assetid` INT NULL,
  `userid` INT NULL,
  `text` TEXT NULL,
  `created` DATETIME NULL,
  `modifieddate` DATETIME NULL,
  `lastmodified` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`commentid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `moddb`.`assettype`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `moddb`.`assettype` (
  `assettypeid` INT NOT NULL AUTO_INCREMENT,
  `maxfiles` TINYINT NULL DEFAULT 10,
  `maxfilesizekb` INT NULL DEFAULT 2000,
  `allowedfiletypes` VARCHAR(255) NULL DEFAULT 'png|jpg|gif',
  `code` VARCHAR(255) NULL,
  `name` VARCHAR(255) NULL,
  PRIMARY KEY (`assettypeid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `moddb`.`release`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `moddb`.`release` (
  `releaseid` INT NOT NULL AUTO_INCREMENT,
  `assetid` INT NULL,
  `modid` INT NULL,
  `modidstr` VARCHAR(255) NULL,
  `modversion` VARCHAR(50) NULL,
  `detectedmodidstr` VARCHAR(255) NULL,
  `releasedate` VARCHAR(255) NULL,
  `inprogress` TINYINT NULL,
  `detailtext` TEXT NULL,
  `releaseorder` INT NULL,
  `created` DATETIME NULL,
  `lastmodified` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`releaseid`),
  UNIQUE INDEX `modidstr` (`modidstr` ASC, `modversion` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `moddb`.`changelog`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `moddb`.`changelog` (
  `changelogid` INT NOT NULL AUTO_INCREMENT,
  `assetid` INT NULL,
  `userid` INT NULL,
  `text` TEXT NULL,
  `created` DATETIME NULL,
  `lastmodified` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`changelogid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `moddb`.`tag`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `moddb`.`tag` (
  `tagid` INT NOT NULL AUTO_INCREMENT,
  `assettypeid` INT NULL,
  `tagtypeid` INT NULL,
  `name` VARCHAR(255) NULL,
  `text` TEXT NULL,
  `color` VARCHAR(255) NULL,
  `created` DATETIME NULL,
  `lastmodified` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`tagid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `moddb`.`assettag`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `moddb`.`assettag` (
  `assettagid` INT NOT NULL AUTO_INCREMENT,
  `assetid` INT NULL,
  `tagid` INT NULL,
  `created` DATETIME NULL,
  `lastmodified` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`assettagid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `moddb`.`mod`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `moddb`.`mod` (
  `modid` INT NOT NULL AUTO_INCREMENT,
  `assetid` INT NULL,
  `urlalias` VARCHAR(45) NULL,
  `logofileid` INT NULL,
  `logofilename` VARCHAR(255) NULL,
  `homepageurl` VARCHAR(255) NULL,
  `sourcecodeurl` VARCHAR(255) NULL,
  `trailervideourl` VARCHAR(255) NULL,
  `issuetrackerurl` VARCHAR(255) NULL,
  `wikiurl` VARCHAR(255) NULL,
  `downloads` INT NULL DEFAULT 0,
  `follows` INT NULL DEFAULT 0,
  `trendingpoints` INT NOT NULL DEFAULT 0,
  `comments` INT NULL,
  `side` ENUM('client', 'server', 'both') NULL,
  `type` ENUM('mod', 'externaltool', 'other') NULL DEFAULT 'mod',
  `created` DATETIME NULL,
  `lastmodified` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `lastreleased` DATETIME NULL,
  `supportedversions` TEXT NULL,
  PRIMARY KEY (`modid`),
  FULLTEXT INDEX `supportedversions` (`supportedversions`) VISIBLE,
  INDEX `urlalias` (`urlalias` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `moddb`.`language`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `moddb`.`language` (
  `languageid` INT NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(255) NULL,
  `name` VARCHAR(255) NULL,
  PRIMARY KEY (`languageid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `moddb`.`tagtype`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `moddb`.`tagtype` (
  `tagtypeid` INT NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(255) NULL,
  `name` VARCHAR(255) NULL,
  `text` TEXT NULL,
  `created` DATETIME NULL,
  `lastmodified` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`tagtypeid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `moddb`.`role`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `moddb`.`role` (
  `roleid` INT NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(255) NULL,
  `name` VARCHAR(255) NULL,
  `created` DATETIME NULL DEFAULT NULL,
  `sortorder` INT NULL,
  `lastmodified` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`roleid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `moddb`.`downloadip`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `moddb`.`downloadip` (
  `ipaddress` VARCHAR(255) NOT NULL,
  `fileid` INT NOT NULL,
  `date` DATETIME NULL,
  PRIMARY KEY (`ipaddress`, `fileid`),
  INDEX `ipaddress` (`ipaddress` ASC) VISIBLE,
  INDEX `fileid` (`fileid` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `moddb`.`modversioncached`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `moddb`.`modversioncached` (
  `tagid` INT NULL,
  `modid` INT NULL,
  INDEX `modid` (`modid` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `moddb`.`notification`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `moddb`.`notification` (
  `notificationid` INT NOT NULL AUTO_INCREMENT,
  `read` TINYINT NOT NULL DEFAULT 0,
  `userid` VARCHAR(255) NULL,
  `type` ENUM('newcomment', 'mentioncomment', 'newrelease') NULL,
  `recordid` INT NULL,
  `created` DATETIME NULL,
  PRIMARY KEY (`notificationid`),
  INDEX `userid` (`userid` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `moddb`.`majormodversioncached`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `moddb`.`majormodversioncached` (
  `majorversionid` INT NULL,
  `modid` INT NULL,
  INDEX `modid` (`modid` ASC) VISIBLE,
  INDEX `majorversionid` (`majorversionid` ASC) VISIBLE,
  UNIQUE INDEX `index` (`majorversionid` ASC, `modid` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `moddb`.`majorversion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `moddb`.`majorversion` (
  `majorversionid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NULL,
  INDEX `modid` (`name` ASC) VISIBLE,
  PRIMARY KEY (`majorversionid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `moddb`.`follow`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `moddb`.`follow` (
  `modid` INT NULL,
  `userid` INT NULL,
  UNIQUE INDEX `modiduserid` (`modid` ASC, `userid` ASC) VISIBLE,
  INDEX `userid` (`userid` ASC) VISIBLE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `moddb`.`status`
-- -----------------------------------------------------
START TRANSACTION;
USE `moddb`;
INSERT INTO `moddb`.`status` (`statusid`, `code`, `name`, `created`, `sortorder`, `lastmodified`) VALUES (1, 'draft', 'Draft', NULL, 1, NULL);
INSERT INTO `moddb`.`status` (`statusid`, `code`, `name`, `created`, `sortorder`, `lastmodified`) VALUES (2, 'published', 'Published', NULL, 2, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `moddb`.`assettype`
-- -----------------------------------------------------
START TRANSACTION;
USE `moddb`;
INSERT INTO `moddb`.`assettype` (`assettypeid`, `maxfiles`, `maxfilesizekb`, `allowedfiletypes`, `code`, `name`) VALUES (1, 10, 2000, 'png|jpg|gif', 'mod', 'Mod');
INSERT INTO `moddb`.`assettype` (`assettypeid`, `maxfiles`, `maxfilesizekb`, `allowedfiletypes`, `code`, `name`) VALUES (2, 1, 40000, 'dll|zip|cs', 'release', 'Release');

COMMIT;


-- -----------------------------------------------------
-- Data for table `moddb`.`language`
-- -----------------------------------------------------
START TRANSACTION;
USE `moddb`;
INSERT INTO `moddb`.`language` (`languageid`, `code`, `name`) VALUES (1, 'en', 'English');
INSERT INTO `moddb`.`language` (`languageid`, `code`, `name`) VALUES (2, 'ar', 'Arabic');
INSERT INTO `moddb`.`language` (`languageid`, `code`, `name`) VALUES (3, 'nl', 'Dutch');

COMMIT;


-- -----------------------------------------------------
-- Data for table `moddb`.`tagtype`
-- -----------------------------------------------------
START TRANSACTION;
USE `moddb`;
INSERT INTO `moddb`.`tagtype` (`tagtypeid`, `code`, `name`, `text`, `created`, `lastmodified`) VALUES (1, 'gameversion', 'Game version', NULL, NULL, NULL);
INSERT INTO `moddb`.`tagtype` (`tagtypeid`, `code`, `name`, `text`, `created`, `lastmodified`) VALUES (2, 'category', 'Category', NULL, NULL, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `moddb`.`role`
-- -----------------------------------------------------
START TRANSACTION;
USE `moddb`;
INSERT INTO `moddb`.`role` (`roleid`, `code`, `name`, `created`, `sortorder`, `lastmodified`) VALUES (1, 'admin', 'Admin', NULL, NULL, NULL);
INSERT INTO `moddb`.`role` (`roleid`, `code`, `name`, `created`, `sortorder`, `lastmodified`) VALUES (2, 'moderator', 'Moderator', NULL, NULL, NULL);
INSERT INTO `moddb`.`role` (`roleid`, `code`, `name`, `created`, `sortorder`, `lastmodified`) VALUES (3, 'player', 'Player', NULL, NULL, NULL);
INSERT INTO `moddb`.`role` (`roleid`, `code`, `name`, `created`, `sortorder`, `lastmodified`) VALUES (4, 'player_nc', 'Player (commenting disabled)', NULL, NULL, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `moddb`.`tag`
-- -----------------------------------------------------
START TRANSACTION;
USE `moddb`;
INSERT INTO `moddb`.`tag` (assettypeid, tagtypeid, name, text, color, created) VALUES (2, 1, 'v1.17.4', NULL, '#C9C9C9', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `moddb`.`user`
-- -----------------------------------------------------
START TRANSACTION;
USE `moddb`;
INSERT INTO `moddb`.`user` (roleid, uid, name, password, email, actiontoken, sessiontoken, sessiontokenvaliduntil, timezone, created, lastmodified, lastonline) VALUES (3, NULL, 'Example User', NULL, 'example.user@example.com', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `moddb`.`mod`
-- -----------------------------------------------------
START TRANSACTION;
USE `moddb`;
INSERT INTO `moddb`.`mod` (assetid, urlalias, logofileid, logofilename, homepageurl, sourcecodeurl, trailervideourl, issuetrackerurl, wikiurl, comments, side, created, lastreleased, supportedversions) VALUES (1, 'examplemodone', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 'both', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL);
INSERT INTO `moddb`.`mod` (assetid, urlalias, logofileid, logofilename, homepageurl, sourcecodeurl, trailervideourl, issuetrackerurl, wikiurl, comments, side, created, lastreleased, supportedversions) VALUES (2, 'examplemodtwo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 'both', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL);
INSERT INTO `moddb`.`mod` (assetid, urlalias, logofileid, logofilename, homepageurl, sourcecodeurl, trailervideourl, issuetrackerurl, wikiurl, comments, side, created, lastreleased, supportedversions) VALUES (3, 'examplemodthree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 'both', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL);
INSERT INTO `moddb`.`mod` (assetid, urlalias, logofileid, logofilename, homepageurl, sourcecodeurl, trailervideourl, issuetrackerurl, wikiurl, comments, side, created, lastreleased, supportedversions) VALUES (4, 'examplemodfour', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 'both', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL);
INSERT INTO `moddb`.`mod` (assetid, urlalias, logofileid, logofilename, homepageurl, sourcecodeurl, trailervideourl, issuetrackerurl, wikiurl, comments, side, created, lastreleased, supportedversions) VALUES (5, 'examplemodfive', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 'both', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL);
INSERT INTO `moddb`.`mod` (assetid, urlalias, logofileid, logofilename, homepageurl, sourcecodeurl, trailervideourl, issuetrackerurl, wikiurl, comments, side, created, lastreleased, supportedversions) VALUES (6, 'examplemodsix', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 'both', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL);
INSERT INTO `moddb`.`mod` (assetid, urlalias, logofileid, logofilename, homepageurl, sourcecodeurl, trailervideourl, issuetrackerurl, wikiurl, comments, side, created, lastreleased, supportedversions) VALUES (7, 'examplemodseven', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 'both', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL);
INSERT INTO `moddb`.`mod` (assetid, urlalias, logofileid, logofilename, homepageurl, sourcecodeurl, trailervideourl, issuetrackerurl, wikiurl, comments, side, created, lastreleased, supportedversions) VALUES (8, 'examplemodeight', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 'both', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL);
INSERT INTO `moddb`.`mod` (assetid, urlalias, logofileid, logofilename, homepageurl, sourcecodeurl, trailervideourl, issuetrackerurl, wikiurl, comments, side, created, lastreleased, supportedversions) VALUES (9, 'examplemodnine', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 'both', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL);
INSERT INTO `moddb`.`mod` (assetid, urlalias, logofileid, logofilename, homepageurl, sourcecodeurl, trailervideourl, issuetrackerurl, wikiurl, comments, side, created, lastreleased, supportedversions) VALUES (10, 'examplemodten', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 'both', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `moddb`.`asset`
-- -----------------------------------------------------
START TRANSACTION;
USE `moddb`;
INSERT INTO `moddb`.`asset` (createdbyuserid, editedbyuserid, statusid, assettypeid, code, name, text, tagscached, created, lastmodified, numsaved) VALUES (1,1,2,1,NULL,'Example Mod 1', '<p style="text-align: center;">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque leo sem, ultrices vel enim vel, pretium fringilla nisi. Nunc ac massa hendrerit, semper est sed, blandit eros. Sed at placerat lorem, viverra lacinia nibh. Mauris eu nunc a augue rhoncus pharetra ac eu nulla. Fusce elementum sapien sit amet sapien pellentesque, eget porttitor quam eleifend. Maecenas imperdiet justo dolor, id bibendum purus ornare vel. Morbi commodo porttitor nisi, sed finibus eros blandit eget. Nulla quis rhoncus urna.</p>', '', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1);
INSERT INTO `moddb`.`asset` (createdbyuserid, editedbyuserid, statusid, assettypeid, code, name, text, tagscached, created, lastmodified, numsaved) VALUES (1,1,2,1,NULL,'Example Mod 2', '<p style="text-align: center;">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque leo sem, ultrices vel enim vel, pretium fringilla nisi. Nunc ac massa hendrerit, semper est sed, blandit eros. Sed at placerat lorem, viverra lacinia nibh. Mauris eu nunc a augue rhoncus pharetra ac eu nulla. Fusce elementum sapien sit amet sapien pellentesque, eget porttitor quam eleifend. Maecenas imperdiet justo dolor, id bibendum purus ornare vel. Morbi commodo porttitor nisi, sed finibus eros blandit eget. Nulla quis rhoncus urna.</p>', '', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1);
INSERT INTO `moddb`.`asset` (createdbyuserid, editedbyuserid, statusid, assettypeid, code, name, text, tagscached, created, lastmodified, numsaved) VALUES (1,1,2,1,NULL,'Example Mod 3', '<p style="text-align: center;">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque leo sem, ultrices vel enim vel, pretium fringilla nisi. Nunc ac massa hendrerit, semper est sed, blandit eros. Sed at placerat lorem, viverra lacinia nibh. Mauris eu nunc a augue rhoncus pharetra ac eu nulla. Fusce elementum sapien sit amet sapien pellentesque, eget porttitor quam eleifend. Maecenas imperdiet justo dolor, id bibendum purus ornare vel. Morbi commodo porttitor nisi, sed finibus eros blandit eget. Nulla quis rhoncus urna.</p>', '', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1);
INSERT INTO `moddb`.`asset` (createdbyuserid, editedbyuserid, statusid, assettypeid, code, name, text, tagscached, created, lastmodified, numsaved) VALUES (1,1,2,1,NULL,'Example Mod 4', '<p style="text-align: center;">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque leo sem, ultrices vel enim vel, pretium fringilla nisi. Nunc ac massa hendrerit, semper est sed, blandit eros. Sed at placerat lorem, viverra lacinia nibh. Mauris eu nunc a augue rhoncus pharetra ac eu nulla. Fusce elementum sapien sit amet sapien pellentesque, eget porttitor quam eleifend. Maecenas imperdiet justo dolor, id bibendum purus ornare vel. Morbi commodo porttitor nisi, sed finibus eros blandit eget. Nulla quis rhoncus urna.</p>', '', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1);
INSERT INTO `moddb`.`asset` (createdbyuserid, editedbyuserid, statusid, assettypeid, code, name, text, tagscached, created, lastmodified, numsaved) VALUES (1,1,2,1,NULL,'Example Mod 5', '<p style="text-align: center;">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque leo sem, ultrices vel enim vel, pretium fringilla nisi. Nunc ac massa hendrerit, semper est sed, blandit eros. Sed at placerat lorem, viverra lacinia nibh. Mauris eu nunc a augue rhoncus pharetra ac eu nulla. Fusce elementum sapien sit amet sapien pellentesque, eget porttitor quam eleifend. Maecenas imperdiet justo dolor, id bibendum purus ornare vel. Morbi commodo porttitor nisi, sed finibus eros blandit eget. Nulla quis rhoncus urna.</p>', '', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1);
INSERT INTO `moddb`.`asset` (createdbyuserid, editedbyuserid, statusid, assettypeid, code, name, text, tagscached, created, lastmodified, numsaved) VALUES (1,1,2,1,NULL,'Example Mod 6', '<p style="text-align: center;">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque leo sem, ultrices vel enim vel, pretium fringilla nisi. Nunc ac massa hendrerit, semper est sed, blandit eros. Sed at placerat lorem, viverra lacinia nibh. Mauris eu nunc a augue rhoncus pharetra ac eu nulla. Fusce elementum sapien sit amet sapien pellentesque, eget porttitor quam eleifend. Maecenas imperdiet justo dolor, id bibendum purus ornare vel. Morbi commodo porttitor nisi, sed finibus eros blandit eget. Nulla quis rhoncus urna.</p>', '', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1);
INSERT INTO `moddb`.`asset` (createdbyuserid, editedbyuserid, statusid, assettypeid, code, name, text, tagscached, created, lastmodified, numsaved) VALUES (1,1,2,1,NULL,'Example Mod 7', '<p style="text-align: center;">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque leo sem, ultrices vel enim vel, pretium fringilla nisi. Nunc ac massa hendrerit, semper est sed, blandit eros. Sed at placerat lorem, viverra lacinia nibh. Mauris eu nunc a augue rhoncus pharetra ac eu nulla. Fusce elementum sapien sit amet sapien pellentesque, eget porttitor quam eleifend. Maecenas imperdiet justo dolor, id bibendum purus ornare vel. Morbi commodo porttitor nisi, sed finibus eros blandit eget. Nulla quis rhoncus urna.</p>', '', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1);
INSERT INTO `moddb`.`asset` (createdbyuserid, editedbyuserid, statusid, assettypeid, code, name, text, tagscached, created, lastmodified, numsaved) VALUES (1,1,2,1,NULL,'Example Mod 8', '<p style="text-align: center;">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque leo sem, ultrices vel enim vel, pretium fringilla nisi. Nunc ac massa hendrerit, semper est sed, blandit eros. Sed at placerat lorem, viverra lacinia nibh. Mauris eu nunc a augue rhoncus pharetra ac eu nulla. Fusce elementum sapien sit amet sapien pellentesque, eget porttitor quam eleifend. Maecenas imperdiet justo dolor, id bibendum purus ornare vel. Morbi commodo porttitor nisi, sed finibus eros blandit eget. Nulla quis rhoncus urna.</p>', '', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1);
INSERT INTO `moddb`.`asset` (createdbyuserid, editedbyuserid, statusid, assettypeid, code, name, text, tagscached, created, lastmodified, numsaved) VALUES (1,1,2,1,NULL,'Example Mod 9', '<p style="text-align: center;">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque leo sem, ultrices vel enim vel, pretium fringilla nisi. Nunc ac massa hendrerit, semper est sed, blandit eros. Sed at placerat lorem, viverra lacinia nibh. Mauris eu nunc a augue rhoncus pharetra ac eu nulla. Fusce elementum sapien sit amet sapien pellentesque, eget porttitor quam eleifend. Maecenas imperdiet justo dolor, id bibendum purus ornare vel. Morbi commodo porttitor nisi, sed finibus eros blandit eget. Nulla quis rhoncus urna.</p>', '', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1);
INSERT INTO `moddb`.`asset` (createdbyuserid, editedbyuserid, statusid, assettypeid, code, name, text, tagscached, created, lastmodified, numsaved) VALUES (1,1,2,1,NULL,'Example Mod 10', '<p style="text-align: center;">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque leo sem, ultrices vel enim vel, pretium fringilla nisi. Nunc ac massa hendrerit, semper est sed, blandit eros. Sed at placerat lorem, viverra lacinia nibh. Mauris eu nunc a augue rhoncus pharetra ac eu nulla. Fusce elementum sapien sit amet sapien pellentesque, eget porttitor quam eleifend. Maecenas imperdiet justo dolor, id bibendum purus ornare vel. Morbi commodo porttitor nisi, sed finibus eros blandit eget. Nulla quis rhoncus urna.</p>', '', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1);

COMMIT;
