-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Mar 27, 2024 at 06:03 PM
-- Server version: 10.5.20-MariaDB
-- PHP Version: 7.3.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `id21872248_noteswapdb`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `admin_id` int(11) NOT NULL,
  `admin_name` varchar(50) NOT NULL,
  `image` varchar(50) NOT NULL,
  `email_id` varchar(50) NOT NULL,
  `password` varchar(15) NOT NULL,
  `contact_no` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`admin_id`, `admin_name`, `image`, `email_id`, `password`, `contact_no`) VALUES
(1, 'admin', '15.png', 'admin@gmail.com', 'Dig@2002', '');

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`category_id`, `category_name`) VALUES
(2, 'Vintage items'),
(3, 'Currency notes');

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `product_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `product_image` varchar(255) NOT NULL,
  `category` varchar(50) NOT NULL,
  `price` double NOT NULL,
  `description` longtext NOT NULL,
  `location` varchar(255) NOT NULL,
  `postdate` date NOT NULL DEFAULT current_timestamp(),
  `seller_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`product_id`, `title`, `product_image`, `category`, `price`, `description`, `location`, `postdate`, `seller_id`) VALUES
(1, 'fan', 'eAttend-logo-dark.jpg,eAttend-logo-white.jpg', 'Currency notes', 12001, 'good fan', 'Ahmedabad', '2023-11-22', 1),
(8, 'Set of vintage items', '2-fancy-number-notes.jpg,images (1).jpg,images.jpg', 'Vintage items', 360, 'Introducing the WidgetPro X1000 - Your Ultimate Tech Companion!The WidgetPro X1000 is a cutting-edge gadget designed to elevate your tech experience. Packed with innovative features and sleek design, this device is a must-have for tech enthusiasts. Key Features: Lightning-Fast Performance: Powered by the latest Quad-Core Processor, the WidgetPro X1000 ensures seamless multitasking and rapid response times. Say gmrgmrmgmre;lm;glmer;rlgm;lerg;leg eregrerkjiowjefiowjefw efwebbriudwehruhewr rjnwejrhrioewhroiwehroew rwejruwehriouhweouihrouiewhroiuhweoiurhoiuweuhoirhoiwehroihweoihrwe rkjwerjwehrioewhiorhweoihroiwheoir werkjnwejhriowehroihweoirhwe jkwehroiwehrioewr wejrhoiwehriohewf wehrfbujewbfuewbf wehfhbwejf', 'ahmedabad', '2024-03-04', 1),
(10, '10 rupees note', '2-fancy-number-notes.jpg,images (1).jpg,images.jpg', 'Currency notes', 250, 'Introducing the WidgetPro X1000 - Your Ultimate Tech Companion!The WidgetPro X1000 is a cutting-edgfefewfweffwefwefwef reqwrf', 'ahmdebad', '2024-03-04', 1),
(34, 'first product', '65fc8943b3298.jpg,65fc8943b336f.jpg,65fc8943b3409.jpg', 'Vintage items', 199, 'first description ', 'botad', '2024-03-21', 67),
(35, 'second ', '65fc891a39568.jpg,65fc891a39669.jpg,65fc891a3970b.jpg', 'Currency notes', 299, 'second description ', 'botad', '2024-03-21', 67);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `user_id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL DEFAULT '',
  `email_id` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `profile_picture` varchar(100) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `contact` varchar(15) NOT NULL,
  `feedback` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `username`, `email_id`, `password`, `profile_picture`, `location`, `contact`, `feedback`) VALUES
(1, 'digvijay', 'pateldigvijay1511@gmail.com', 'dddd', '65f596ebc29c9.jpeg', 'sss', '9714641515', 'dfewfew'),
(56, 'jignesh', 'admin@gmail.com', 'ewffewf', '65f57e516f744.jpg', 'keshod', '9924942069', 'aaa'),
(61, 'sandip jakhaniya', 'Sandipjakhaniya@gmail.com', 'sandip@123', '65f58732cd82a.jpg', 'surat', '9016476158', ''),
(67, 'viral ', 'viral@gmail.com', 'viral@123', '65fabbee0400b.jpeg', 'botad', '9664679783', NULL),
(68, 'Vishv patel', 'vishvpatel1351@gmail.com', 'vishv1351@', 'picture_profile.jpeg', '', '8401042837', NULL),
(69, 'patel', 'patel1351@gmail.com', '70941351', 'picture_profile.jpeg', '', '9537266059', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`category_id`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`product_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
