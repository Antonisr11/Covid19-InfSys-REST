CREATE DATABASE  IF NOT EXISTS `vaccine` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `vaccine`;
-- MySQL dump 10.13  Distrib 8.0.28, for Win64 (x86_64)
--
-- Host: localhost    Database: vaccine
-- ------------------------------------------------------
-- Server version	8.0.28

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `appointments`
--

DROP TABLE IF EXISTS `appointments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointments` (
  `ID` int NOT NULL,
  `AMKA` varchar(11) NOT NULL,
  `Date` datetime NOT NULL,
  `isDone` varchar(1) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID_UNIQUE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointments`
--

LOCK TABLES `appointments` WRITE;
/*!40000 ALTER TABLE `appointments` DISABLE KEYS */;
INSERT INTO `appointments` VALUES (1,'10057514721','2022-02-09 10:18:00','1'),(2,'10057514721','2022-03-13 21:36:00','0'),(3,'17080481399','2022-02-10 21:04:00','0'),(4,'17080481399','2022-03-10 20:52:00','0'),(5,'17080481399','2022-04-08 12:18:00','0'),(6,'19088552025','2022-05-30 13:40:00','0'),(7,'23115817983','2022-02-09 21:48:00','0'),(8,'23115817983','2022-03-09 20:57:00','0'),(9,'23115817983','2022-04-07 14:42:00','0'),(11,'27048467867','2022-03-10 18:33:00','0'),(12,'27048467867','2022-04-12 20:36:00','0'),(14,'27088436900','2022-03-09 19:29:00','0'),(15,'27088436900','2022-04-08 16:13:00','0'),(16,'28057586361','2022-02-10 14:09:00','0'),(17,'28057586361','2022-03-10 19:37:00','0'),(18,'30016923446','2022-02-09 16:34:00','0');
/*!40000 ALTER TABLE `appointments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `availablevaccines`
--

DROP TABLE IF EXISTS `availablevaccines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `availablevaccines` (
  `date` date NOT NULL,
  `count` int NOT NULL,
  PRIMARY KEY (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `availablevaccines`
--

LOCK TABLES `availablevaccines` WRITE;
/*!40000 ALTER TABLE `availablevaccines` DISABLE KEYS */;
INSERT INTO `availablevaccines` VALUES ('2022-02-08',30),('2022-02-09',27),('2022-02-10',43),('2022-02-11',21),('2022-02-12',55),('2022-02-13',12),('2022-02-14',82),('2022-02-15',1),('2022-02-16',147),('2022-02-17',16),('2022-02-18',88),('2022-02-19',109),('2022-02-20',31),('2022-02-21',128),('2022-02-22',95),('2022-02-23',148),('2022-02-24',8),('2022-02-25',129),('2022-02-26',21),('2022-02-27',131),('2022-02-28',65),('2022-03-01',108),('2022-03-02',25),('2022-03-03',137),('2022-03-04',69),('2022-03-05',133),('2022-03-06',147),('2022-03-07',81),('2022-03-08',102),('2022-03-09',69),('2022-03-10',16),('2022-03-11',107),('2022-03-12',128),('2022-03-13',76),('2022-03-14',64),('2022-03-15',142),('2022-03-16',115),('2022-03-17',99),('2022-03-18',139),('2022-03-19',21),('2022-03-20',89),('2022-03-21',26),('2022-03-22',1),('2022-03-23',72),('2022-03-24',14),('2022-03-25',35),('2022-03-26',117),('2022-03-27',17),('2022-03-28',65),('2022-03-29',104),('2022-03-30',65),('2022-03-31',11),('2022-04-01',51),('2022-04-02',89),('2022-04-03',9),('2022-04-04',144),('2022-04-05',65),('2022-04-06',40),('2022-04-07',49),('2022-04-08',58),('2022-04-09',33),('2022-04-10',123),('2022-04-11',20),('2022-04-12',71),('2022-04-13',139),('2022-04-14',47),('2022-04-15',79),('2022-04-16',33),('2022-04-17',99),('2022-04-18',88),('2022-04-19',111),('2022-04-20',124),('2022-04-21',105),('2022-04-22',84),('2022-04-23',49),('2022-04-24',147),('2022-04-25',1),('2022-04-26',135),('2022-04-27',66),('2022-04-28',119),('2022-04-29',147),('2022-04-30',57),('2022-05-01',32),('2022-05-02',87),('2022-05-03',91),('2022-05-04',117),('2022-05-05',77),('2022-05-06',129),('2022-05-07',105),('2022-05-08',99),('2022-05-09',141),('2022-05-10',70),('2022-05-11',61),('2022-05-12',150),('2022-05-13',96),('2022-05-14',134),('2022-05-15',10),('2022-05-16',17),('2022-05-17',11),('2022-05-18',24),('2022-05-19',104),('2022-05-20',89),('2022-05-21',78),('2022-05-22',97),('2022-05-23',78),('2022-05-24',66),('2022-05-25',47),('2022-05-26',94),('2022-05-27',105),('2022-05-28',42),('2022-05-29',130),('2022-05-30',17),('2022-05-31',69),('2022-06-01',144),('2022-06-02',98),('2022-06-03',47),('2022-06-04',143),('2022-06-05',49),('2022-06-06',55),('2022-06-07',79),('2022-06-08',73),('2022-06-09',1),('2022-06-10',137),('2022-06-11',1),('2022-06-12',38),('2022-06-13',6),('2022-06-14',66),('2022-06-15',62),('2022-06-16',107),('2022-06-17',90),('2022-06-18',99),('2022-06-19',74),('2022-06-20',20),('2022-06-21',71),('2022-06-22',70),('2022-06-23',62),('2022-06-24',58),('2022-06-25',137),('2022-06-26',145),('2022-06-27',104),('2022-06-28',10),('2022-06-29',24),('2022-06-30',59);
/*!40000 ALTER TABLE `availablevaccines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `settings` (
  `ID` int NOT NULL,
  `minimum_age` int NOT NULL,
  `max_doses` int NOT NULL,
  `minimum_days_between_vaccinations` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
INSERT INTO `settings` VALUES (0,18,3,28);
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `AMKA` varchar(11) NOT NULL,
  `Name` varchar(100) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Password` varchar(100) NOT NULL,
  `isAdmin` varchar(1) NOT NULL,
  PRIMARY KEY (`AMKA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('10057514721','Meletis_Krokidis','krokidis@erpeto.com','1DDF837718044A9589958E2589080AA4','0'),('10080010010','Antonis','antonis@yahoo.gr','55901E1C9ECDAE055FA280B5541DBEF6','1'),('17080481399','Tonia','tonia@gmail.com','DDA53297E90FD9C93B45C8F74C9BD4EB','0'),('19088552025','Eleni_Marouda','marouda@police.gr','228325C284DA3F3829A35B57B233C944','0'),('20050963559','Pantelis_Sklavis','sklavis@police.gr','BBA8E8388636F5C0FD7513BB47A95153','0'),('21020729566','Gripas','gripas@erpeto.com','64C578435443B97B10C90A4E92F7ADDE','0'),('23115817983','Apostolos_Mparasopoulos','mparasopoulos@police.gr','0D031A1CF8DADE4674378522F7AE9938','0'),('27048467867','Dimitris_Lainis','dlainis@university.gr','6D199BF8BF5FAEE2FDDF7DABE049B884','0'),('27088436900','Aristotelis_Adamadinos','aadamadinos@univerity.gr','442D8E7FF403678482FB9AFBADE02DB5','0'),('28057586361','Xristina_Stergiou','stergiou@gmail.com','32857AB4285D8603D15E1BF088E64053','0'),('30016923446','Alkis_Masatos','masatos@erpeto.com','DC85FC3ABA9AD9ABD2BA32C471B88F8D','0'),('30058132434','Martha_Karra','karra@police.com','0D145054CBD338E344183B1C11EB4CF3','0');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-02-15 18:32:04
