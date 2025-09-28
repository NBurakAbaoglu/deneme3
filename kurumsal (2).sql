-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1
-- Üretim Zamanı: 23 Eyl 2025, 23:49:28
-- Sunucu sürümü: 10.4.32-MariaDB
-- PHP Sürümü: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `kurumsal`
--

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `coklu_beceri_etkinlikleri`
--

CREATE TABLE `coklu_beceri_etkinlikleri` (
  `id` int(11) NOT NULL,
  `coklu_beceri_id` int(11) NOT NULL,
  `egitmen_adi` varchar(255) NOT NULL,
  `baslangic_tarihi` date NOT NULL,
  `bitis_tarihi` date NOT NULL,
  `olusturulma_tarihi` timestamp NOT NULL DEFAULT current_timestamp(),
  `durum` enum('aktif','tamamlandi','iptal') DEFAULT 'aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `egiticinin_egitimi_etkinlikleri`
--

CREATE TABLE `egiticinin_egitimi_etkinlikleri` (
  `id` int(11) NOT NULL,
  `coklu_beceri_id` int(11) NOT NULL,
  `egitmen_adi` varchar(255) NOT NULL,
  `gozetmen_adi` varchar(255) DEFAULT NULL,
  `baslangic_tarihi` date NOT NULL,
  `bitis_tarihi` date NOT NULL,
  `kontenjan` int(11) NOT NULL,
  `olusturulma_tarihi` timestamp NOT NULL DEFAULT current_timestamp(),
  `durum` enum('aktif','tamamlandi','iptal') DEFAULT 'aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `organizations`
--

CREATE TABLE `organizations` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `column_position` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `organizations`
--

INSERT INTO `organizations` (`id`, `name`, `column_position`, `created_at`, `updated_at`) VALUES
(1, 'deneme1', 4, '2025-09-17 05:51:59', '2025-09-17 05:51:59'),
(2, 'deneme2', 5, '2025-09-17 05:53:44', '2025-09-17 05:53:44'),
(5, 'deneme3', 6, '2025-09-17 06:16:00', '2025-09-17 06:16:00'),
(6, 'deneme4', 7, '2025-09-17 10:57:07', '2025-09-17 10:57:07'),
(7, 'deneme5', 8, '2025-09-18 04:39:25', '2025-09-18 04:39:25'),
(8, 'deneme6', 9, '2025-09-20 19:49:30', '2025-09-20 19:49:30');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `organization_images`
--

CREATE TABLE `organization_images` (
  `id` int(11) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `row_name` varchar(255) NOT NULL,
  `image_name` varchar(255) NOT NULL DEFAULT 'pie (2).png',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `organization_images`
--

INSERT INTO `organization_images` (`id`, `organization_id`, `row_name`, `image_name`, `created_at`, `updated_at`) VALUES
(1, 1, 'HAKAN KOR', 'pie (3).png', '2025-09-21 21:00:05', '2025-09-21 21:00:05'),
(2, 2, 'HAKAN KOR', 'pie (5).png', '2025-09-21 21:06:02', '2025-09-21 21:07:26');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `organization_skills`
--

CREATE TABLE `organization_skills` (
  `id` int(11) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `skill_id` int(11) NOT NULL,
  `priority` enum('low','medium','high') DEFAULT 'medium',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `organization_skills`
--

INSERT INTO `organization_skills` (`id`, `organization_id`, `skill_id`, `priority`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 'medium', '2025-09-17 05:52:15', '2025-09-17 05:52:15'),
(2, 2, 1, 'medium', '2025-09-17 05:53:52', '2025-09-17 05:53:52'),
(4, 5, 3, 'medium', '2025-09-17 06:16:05', '2025-09-17 06:16:05'),
(5, 6, 4, 'medium', '2025-09-17 10:57:17', '2025-09-17 10:57:17'),
(6, 7, 2, 'medium', '2025-09-18 04:39:34', '2025-09-18 04:39:34'),
(7, 8, 5, 'medium', '2025-09-20 19:49:40', '2025-09-20 19:49:40');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `organization_skills_backup`
--

CREATE TABLE `organization_skills_backup` (
  `id` int(11) NOT NULL DEFAULT 0,
  `organization_id` int(11) NOT NULL,
  `skill_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `skill_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `persons`
--

CREATE TABLE `persons` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `company_name` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `registration_no` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `persons`
--

INSERT INTO `persons` (`id`, `name`, `company_name`, `title`, `registration_no`, `created_at`, `updated_at`) VALUES
(1, 'HAKAN KOR', 'ASELSAN', 'PERSONEL', '504657', '2025-09-17 05:52:53', '2025-09-18 04:54:50'),
(2, 'FERDİ TAYFUR', NULL, NULL, NULL, '2025-09-17 06:13:09', '2025-09-21 09:51:04');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `person_organization_images`
--

CREATE TABLE `person_organization_images` (
  `id` int(11) NOT NULL,
  `person_id` int(11) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `image_name` varchar(255) NOT NULL DEFAULT 'pie (2).png',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `planned_multi_skill`
--

CREATE TABLE `planned_multi_skill` (
  `id` int(11) NOT NULL,
  `person_id` int(11) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `teacher_id` int(11) DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` varchar(50) DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `success_status` enum('istek_gonderildi','planlandi','tamamlandi','iptal') DEFAULT 'istek_gonderildi'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `planned_multi_skill`
--

INSERT INTO `planned_multi_skill` (`id`, `person_id`, `organization_id`, `teacher_id`, `start_date`, `end_date`, `status`, `created_at`, `updated_at`, `success_status`) VALUES
(11, 1, 2, 3, '2025-09-21', '2025-09-21', 'pending', '2025-09-21 10:49:20', '2025-09-21 21:07:26', 'tamamlandi');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `planned_skills`
--

CREATE TABLE `planned_skills` (
  `id` int(11) NOT NULL,
  `person_id` int(11) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `skill_id` int(11) NOT NULL,
  `company_name` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `registration_no` varchar(100) DEFAULT NULL,
  `target_level` int(11) DEFAULT 3,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `status` enum('istek_gonderildi','planlandi','tamamlandi','iptal') DEFAULT 'istek_gonderildi',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `teacher_id` int(11) DEFAULT NULL,
  `event_id` int(11) DEFAULT NULL,
  `priority` enum('low','medium','high') DEFAULT 'medium',
  `notes` text DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `success_status` enum('pending','completed') DEFAULT 'pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `planned_skills`
--

INSERT INTO `planned_skills` (`id`, `person_id`, `organization_id`, `skill_id`, `company_name`, `title`, `registration_no`, `target_level`, `start_date`, `end_date`, `status`, `created_at`, `updated_at`, `teacher_id`, `event_id`, `priority`, `notes`, `created_by`, `success_status`) VALUES
(1, 1, 1, 1, NULL, NULL, NULL, 1, '2025-09-21', '2025-09-21', 'tamamlandi', '2025-09-17 06:04:51', '2025-09-21 10:16:32', 3, NULL, 'low', '', '1', 'completed'),
(3, 2, 5, 4, NULL, NULL, NULL, 1, '2025-09-21', '2025-09-21', 'tamamlandi', '2025-09-17 06:16:47', '2025-09-21 10:32:00', 10, NULL, 'low', '', NULL, 'completed'),
(4, 1, 5, 4, NULL, NULL, NULL, 1, '2025-09-21', '2025-09-21', 'tamamlandi', '2025-09-17 11:10:03', '2025-09-21 10:31:17', 10, NULL, 'low', '', NULL, 'completed'),
(5, 1, 6, 5, NULL, NULL, NULL, 3, NULL, NULL, 'istek_gonderildi', '2025-09-17 11:12:20', '2025-09-17 11:12:20', NULL, NULL, 'medium', NULL, NULL, 'pending'),
(6, 2, 6, 5, NULL, NULL, NULL, 3, NULL, NULL, 'istek_gonderildi', '2025-09-18 12:01:38', '2025-09-18 12:01:38', NULL, NULL, 'medium', NULL, NULL, 'pending'),
(7, 2, 8, 7, NULL, NULL, NULL, 3, NULL, NULL, 'istek_gonderildi', '2025-09-20 19:49:51', '2025-09-20 19:49:51', NULL, NULL, 'medium', NULL, NULL, 'pending'),
(8, 1, 2, 2, NULL, NULL, NULL, 1, '2025-09-21', '2025-09-21', 'tamamlandi', '2025-09-18 05:45:49', '2025-09-21 10:16:32', 9, NULL, 'low', '', NULL, 'completed'),
(9, 2, 7, 6, NULL, NULL, NULL, 3, NULL, NULL, 'istek_gonderildi', '2025-09-21 08:18:43', '2025-09-21 08:18:43', NULL, NULL, 'medium', NULL, NULL, '');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `skills`
--

CREATE TABLE `skills` (
  `id` int(11) NOT NULL,
  `skill_name` varchar(255) NOT NULL,
  `skill_description` text DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `skills`
--

INSERT INTO `skills` (`id`, `skill_name`, `skill_description`, `category`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'DERS2', 'ders1', 'Temel Beceri', 1, '2025-09-17 05:52:15', '2025-09-17 05:53:57'),
(2, 'DERS3', 'ders3', 'Temel Beceri', 1, '2025-09-17 06:14:19', '2025-09-17 06:14:19'),
(3, 'DERS4', 'ders4', 'Temel Beceri', 1, '2025-09-17 06:16:05', '2025-09-17 06:16:05'),
(4, 'MURAT', 'murat', 'Temel Beceri', 1, '2025-09-17 10:57:17', '2025-09-17 10:57:17'),
(5, 'DERS5', 'ders5', 'Temel Beceri', 1, '2025-09-20 19:49:40', '2025-09-20 19:49:40');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `teachers`
--

CREATE TABLE `teachers` (
  `id` int(11) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `specialization` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `teachers`
--

INSERT INTO `teachers` (`id`, `first_name`, `last_name`, `specialization`, `created_at`, `updated_at`) VALUES
(2, 'fatih', 'bey', 'Kalite Kontrol', '2025-09-17 06:04:29', '2025-09-17 06:04:29'),
(3, 'eda', 'hanım', 'Yazılım geliştirme', '2025-09-17 06:14:59', '2025-09-17 06:14:59'),
(4, 'yıldız', 'tilbe', 'dertli başım', '2025-09-17 06:15:26', '2025-09-17 06:15:26'),
(5, 'müslüm', 'gürses', 'sen ağlama', '2025-09-17 06:16:39', '2025-09-17 06:16:39'),
(6, 'hüseyin', 'yılmaz', 'proje yönetimi', '2025-09-17 11:46:49', '2025-09-17 11:46:49'),
(7, 'SABRİ', 'GÜNVER', 'KONTROL', '2025-09-18 12:02:10', '2025-09-18 12:02:10'),
(8, 'ŞÜKRÜ', 'SARAÇOĞLU', 'FUTBOL', '2025-09-18 12:03:04', '2025-09-18 12:03:04'),
(9, 'ALİ SAMİ', 'YEN', 'Futbol', '2025-09-18 12:03:41', '2025-09-18 12:03:41'),
(10, 'yiğit', 'tabaklı', 'yazılım', '2025-09-21 08:04:48', '2025-09-21 08:04:48');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `temel_beceri_etkinlikleri`
--

CREATE TABLE `temel_beceri_etkinlikleri` (
  `id` int(11) NOT NULL,
  `coklu_beceri_id` int(11) NOT NULL,
  `temel_beceri_adi` varchar(255) NOT NULL,
  `egitmen_adi` varchar(255) NOT NULL,
  `baslangic_tarihi` date NOT NULL,
  `bitis_tarihi` date NOT NULL,
  `kontenjan` int(11) NOT NULL,
  `olusturulma_tarihi` timestamp NOT NULL DEFAULT current_timestamp(),
  `durum` enum('aktif','tamamlandi','iptal') DEFAULT 'aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `tep_teachers`
--

CREATE TABLE `tep_teachers` (
  `id` int(11) NOT NULL,
  `person_name` varchar(255) NOT NULL,
  `organization_name` varchar(255) NOT NULL,
  `skill_name` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `tep_teachers`
--

INSERT INTO `tep_teachers` (`id`, `person_name`, `organization_name`, `skill_name`, `created_at`, `updated_at`) VALUES
(2, 'fatih bey', 'deneme1', 'DERS2', '2025-09-17 06:04:29', '2025-09-17 06:04:29'),
(3, 'eda hanım', 'deneme2', 'DERS2', '2025-09-17 06:14:59', '2025-09-17 06:14:59'),
(4, 'yıldız tilbe', 'deneme1', 'DERS3', '2025-09-17 06:15:26', '2025-09-17 06:15:26'),
(5, 'yıldız tilbe', 'deneme1', 'DERS2', '2025-09-17 06:15:26', '2025-09-17 06:15:26'),
(6, 'müslüm gürses', 'deneme3', 'DERS4', '2025-09-17 06:16:39', '2025-09-17 06:16:39'),
(7, 'hüseyin yılmaz', 'deneme4', 'MURAT', '2025-09-17 11:46:49', '2025-09-17 11:46:49'),
(8, 'SABRİ GÜNVER', 'deneme4', 'MURAT', '2025-09-18 12:02:10', '2025-09-18 12:02:10'),
(9, 'ŞÜKRÜ SARAÇOĞLU', 'deneme5', 'DERS3', '2025-09-18 12:03:04', '2025-09-18 12:03:04'),
(10, 'ŞÜKRÜ SARAÇOĞLU', 'deneme5', 'DERS3', '2025-09-18 12:03:04', '2025-09-18 12:03:04'),
(11, 'ALİ SAMİ YEN', 'deneme4', 'DERS4', '2025-09-18 12:03:41', '2025-09-18 12:03:41'),
(12, 'ALİ SAMİ YEN', 'deneme4', 'MURAT', '2025-09-18 12:03:41', '2025-09-18 12:03:41'),
(13, 'yiğit tabaklı', 'deneme3', 'DERS4', '2025-09-21 08:04:48', '2025-09-21 08:04:48');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `trainer_training_status`
--

CREATE TABLE `trainer_training_status` (
  `id` int(11) NOT NULL,
  `planned_multi_skill_id` int(11) NOT NULL,
  `person_id` int(11) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `training_status` enum('tamamlanmadı','tamamlandı') DEFAULT 'tamamlanmadı',
  `completion_date` date DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `coklu_beceri_etkinlikleri`
--
ALTER TABLE `coklu_beceri_etkinlikleri`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_coklu_beceri` (`coklu_beceri_id`),
  ADD KEY `idx_egitmen` (`egitmen_adi`),
  ADD KEY `idx_tarih` (`baslangic_tarihi`,`bitis_tarihi`);

--
-- Tablo için indeksler `egiticinin_egitimi_etkinlikleri`
--
ALTER TABLE `egiticinin_egitimi_etkinlikleri`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_coklu_beceri` (`coklu_beceri_id`),
  ADD KEY `idx_egitmen` (`egitmen_adi`),
  ADD KEY `idx_gozetmen` (`gozetmen_adi`),
  ADD KEY `idx_tarih` (`baslangic_tarihi`,`bitis_tarihi`);

--
-- Tablo için indeksler `organizations`
--
ALTER TABLE `organizations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `idx_column_position` (`column_position`),
  ADD KEY `idx_organizations_name` (`name`);

--
-- Tablo için indeksler `organization_images`
--
ALTER TABLE `organization_images`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_org_row` (`organization_id`,`row_name`),
  ADD KEY `idx_organization_id` (`organization_id`),
  ADD KEY `idx_row_name` (`row_name`);

--
-- Tablo için indeksler `organization_skills`
--
ALTER TABLE `organization_skills`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_org_skill` (`organization_id`,`skill_id`),
  ADD KEY `idx_organization_id` (`organization_id`),
  ADD KEY `idx_skill_id` (`skill_id`),
  ADD KEY `idx_priority` (`priority`);

--
-- Tablo için indeksler `persons`
--
ALTER TABLE `persons`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_name` (`name`),
  ADD KEY `idx_registration_no` (`registration_no`),
  ADD KEY `idx_persons_company` (`company_name`);

--
-- Tablo için indeksler `person_organization_images`
--
ALTER TABLE `person_organization_images`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_person_org_image` (`person_id`,`organization_id`),
  ADD KEY `idx_person_id` (`person_id`),
  ADD KEY `idx_organization_id` (`organization_id`);

--
-- Tablo için indeksler `planned_multi_skill`
--
ALTER TABLE `planned_multi_skill`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_person_org` (`person_id`,`organization_id`);

--
-- Tablo için indeksler `planned_skills`
--
ALTER TABLE `planned_skills`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_person_org_skill` (`person_id`,`organization_id`,`skill_id`),
  ADD KEY `idx_person_id` (`person_id`),
  ADD KEY `idx_organization_id` (`organization_id`),
  ADD KEY `idx_skill_id` (`skill_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_planned_skills_dates` (`start_date`,`end_date`);

--
-- Tablo için indeksler `skills`
--
ALTER TABLE `skills`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_skill_name` (`skill_name`),
  ADD KEY `idx_skill_name` (`skill_name`),
  ADD KEY `idx_category` (`category`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Tablo için indeksler `teachers`
--
ALTER TABLE `teachers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_name` (`first_name`,`last_name`);

--
-- Tablo için indeksler `temel_beceri_etkinlikleri`
--
ALTER TABLE `temel_beceri_etkinlikleri`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_coklu_beceri` (`coklu_beceri_id`),
  ADD KEY `idx_egitmen` (`egitmen_adi`),
  ADD KEY `idx_tarih` (`baslangic_tarihi`,`bitis_tarihi`);

--
-- Tablo için indeksler `tep_teachers`
--
ALTER TABLE `tep_teachers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_person_name` (`person_name`),
  ADD KEY `idx_organization_name` (`organization_name`),
  ADD KEY `idx_skill_name` (`skill_name`);

--
-- Tablo için indeksler `trainer_training_status`
--
ALTER TABLE `trainer_training_status`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_multi_skill` (`planned_multi_skill_id`),
  ADD KEY `idx_person_id` (`person_id`),
  ADD KEY `idx_organization_id` (`organization_id`),
  ADD KEY `idx_training_status` (`training_status`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `coklu_beceri_etkinlikleri`
--
ALTER TABLE `coklu_beceri_etkinlikleri`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Tablo için AUTO_INCREMENT değeri `egiticinin_egitimi_etkinlikleri`
--
ALTER TABLE `egiticinin_egitimi_etkinlikleri`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Tablo için AUTO_INCREMENT değeri `organizations`
--
ALTER TABLE `organizations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Tablo için AUTO_INCREMENT değeri `organization_images`
--
ALTER TABLE `organization_images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Tablo için AUTO_INCREMENT değeri `organization_skills`
--
ALTER TABLE `organization_skills`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Tablo için AUTO_INCREMENT değeri `persons`
--
ALTER TABLE `persons`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Tablo için AUTO_INCREMENT değeri `person_organization_images`
--
ALTER TABLE `person_organization_images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Tablo için AUTO_INCREMENT değeri `planned_multi_skill`
--
ALTER TABLE `planned_multi_skill`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Tablo için AUTO_INCREMENT değeri `planned_skills`
--
ALTER TABLE `planned_skills`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Tablo için AUTO_INCREMENT değeri `skills`
--
ALTER TABLE `skills`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Tablo için AUTO_INCREMENT değeri `teachers`
--
ALTER TABLE `teachers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Tablo için AUTO_INCREMENT değeri `temel_beceri_etkinlikleri`
--
ALTER TABLE `temel_beceri_etkinlikleri`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Tablo için AUTO_INCREMENT değeri `tep_teachers`
--
ALTER TABLE `tep_teachers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- Tablo için AUTO_INCREMENT değeri `trainer_training_status`
--
ALTER TABLE `trainer_training_status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Dökümü yapılmış tablolar için kısıtlamalar
--

--
-- Tablo kısıtlamaları `organization_skills`
--
ALTER TABLE `organization_skills`
  ADD CONSTRAINT `organization_skills_ibfk_1` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `organization_skills_ibfk_2` FOREIGN KEY (`skill_id`) REFERENCES `skills` (`id`) ON DELETE CASCADE;

--
-- Tablo kısıtlamaları `person_organization_images`
--
ALTER TABLE `person_organization_images`
  ADD CONSTRAINT `person_organization_images_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `person_organization_images_ibfk_2` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`) ON DELETE CASCADE;

--
-- Tablo kısıtlamaları `planned_skills`
--
ALTER TABLE `planned_skills`
  ADD CONSTRAINT `planned_skills_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `planned_skills_ibfk_2` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `planned_skills_ibfk_3` FOREIGN KEY (`skill_id`) REFERENCES `organization_skills` (`id`) ON DELETE CASCADE;

--
-- Tablo kısıtlamaları `trainer_training_status`
--
ALTER TABLE `trainer_training_status`
  ADD CONSTRAINT `trainer_training_ibfk_1` FOREIGN KEY (`planned_multi_skill_id`) REFERENCES `planned_multi_skill` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `trainer_training_ibfk_2` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `trainer_training_ibfk_3` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
