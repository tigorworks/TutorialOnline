-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.6.12 - MySQL Community Server (GPL)
-- Server OS:                    Win64
-- HeidiSQL Version:             8.3.0.4694
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping database structure for da1
DROP DATABASE IF EXISTS `da1`;
CREATE DATABASE IF NOT EXISTS `da1` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `da1`;


-- Dumping structure for table da1.dataimport
DROP TABLE IF EXISTS `dataimport`;
CREATE TABLE IF NOT EXISTS `dataimport` (
  `idreg` varchar(20) NOT NULL,
  `p` varchar(10) NOT NULL,
  `name` varchar(50) NOT NULL,
  `gp` varchar(10) NOT NULL,
  `prabowo` int(11) NOT NULL DEFAULT '0',
  `jokowi` int(11) NOT NULL DEFAULT '0',
  `inputdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idreg`,`p`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for view da1.vw_realcount
DROP VIEW IF EXISTS `vw_realcount`;
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `vw_realcount` (
	`prabowo` DECIMAL(32,0) NULL,
	`jokowi` DECIMAL(32,0) NULL,
	`prabowopr` VARCHAR(40) NOT NULL COLLATE 'utf8_general_ci',
	`jokowipr` VARCHAR(40) NOT NULL COLLATE 'utf8_general_ci'
) ENGINE=MyISAM;


-- Dumping structure for view da1.vw_realcount
DROP VIEW IF EXISTS `vw_realcount`;
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `vw_realcount`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` VIEW `vw_realcount` AS select sum(a.prabowo) prabowo,sum(a.jokowi) jokowi,ifnull(round((sum(a.prabowo)/(sum(a.prabowo)+sum(a.jokowi)))*100,2),'0') as prabowopr,
ifnull(round((sum(a.jokowi)/(sum(a.prabowo)+sum(a.jokowi)))*100,2),'0') as jokowipr
from dataimport a ;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
