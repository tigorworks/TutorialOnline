-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.1.41 - Source distribution
-- Server OS:                    Win32
-- HeidiSQL version:             7.0.0.4151
-- Date/time:                    2012-06-12 15:04:28
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET FOREIGN_KEY_CHECKS=0 */;

-- Dumping database structure for plearning
DROP DATABASE IF EXISTS `plearning`;
CREATE DATABASE IF NOT EXISTS `plearning` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `plearning`;


-- Dumping structure for table plearning.kendaraan
DROP TABLE IF EXISTS `kendaraan`;
CREATE TABLE IF NOT EXISTS `kendaraan` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nama` varchar(35) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Dumping data for table plearning.kendaraan: 3 rows
/*!40000 ALTER TABLE `kendaraan` DISABLE KEYS */;
REPLACE INTO `kendaraan` (`id`, `nama`) VALUES
	(1, 'sepeda'),
	(2, 'motor'),
	(3, 'mobil');
/*!40000 ALTER TABLE `kendaraan` ENABLE KEYS */;


-- Dumping structure for table plearning.merk
DROP TABLE IF EXISTS `merk`;
CREATE TABLE IF NOT EXISTS `merk` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nama` varchar(35) NOT NULL,
  `model_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;

-- Dumping data for table plearning.merk: 17 rows
/*!40000 ALTER TABLE `merk` DISABLE KEYS */;
REPLACE INTO `merk` (`id`, `nama`, `model_id`) VALUES
	(1, 'x-Trada 5', 1),
	(2, 'Helios 700 ', 1),
	(3, 'Helios 300', 1),
	(4, 'Helios 500', 1),
	(5, 'Top Gun', 2),
	(6, 'Supra', 4),
	(7, 'Beat', 4),
	(8, 'Scoopy', 4),
	(9, 'Shogun', 5),
	(10, 'Smash', 5),
	(11, 'Mio', 6),
	(13, 'Ninja', 7),
	(14, 'Jazz', 8),
	(15, 'Ceria', 9),
	(16, 'Alphard', 10),
	(17, 'Avanza', 10),
	(18, 'Livina', 12);
/*!40000 ALTER TABLE `merk` ENABLE KEYS */;


-- Dumping structure for table plearning.model
DROP TABLE IF EXISTS `model`;
CREATE TABLE IF NOT EXISTS `model` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nama` varchar(35) NOT NULL,
  `kendaraan_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;

-- Dumping data for table plearning.model: 12 rows
/*!40000 ALTER TABLE `model` DISABLE KEYS */;
REPLACE INTO `model` (`id`, `nama`, `kendaraan_id`) VALUES
	(1, 'Polygon', 1),
	(2, 'Win cycle', 1),
	(3, 'Commuter', 1),
	(4, 'Honda', 2),
	(5, 'Suzuki', 2),
	(6, 'Yamaha', 2),
	(7, 'Kawasaki', 2),
	(8, 'Honda', 3),
	(9, 'Suzuki', 3),
	(10, 'Toyota', 3),
	(11, 'Mitsubishi', 3),
	(12, 'Nissan', 3);
/*!40000 ALTER TABLE `model` ENABLE KEYS */;
/*!40014 SET FOREIGN_KEY_CHECKS=1 */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
