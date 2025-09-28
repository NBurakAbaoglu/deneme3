-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1
-- Üretim Zamanı: 29 Eyl 2025, 00:21:37
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

--
-- Tablo döküm verisi `coklu_beceri_etkinlikleri`
--

INSERT INTO `coklu_beceri_etkinlikleri` (`id`, `coklu_beceri_id`, `egitmen_adi`, `baslangic_tarihi`, `bitis_tarihi`, `olusturulma_tarihi`, `durum`) VALUES
(1, 1, 'faruk hikmet', '2025-10-01', '2025-10-04', '2025-09-28 16:39:12', 'aktif');

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

--
-- Tablo döküm verisi `egiticinin_egitimi_etkinlikleri`
--

INSERT INTO `egiticinin_egitimi_etkinlikleri` (`id`, `coklu_beceri_id`, `egitmen_adi`, `gozetmen_adi`, `baslangic_tarihi`, `bitis_tarihi`, `kontenjan`, `olusturulma_tarihi`, `durum`) VALUES
(1, 1, 'faruk hikmet', '', '2025-09-30', '2025-10-02', 1, '2025-09-28 21:52:11', 'aktif');

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
(1, 'deneme1', 4, '2025-09-17 05:51:59', '2025-09-28 21:29:29');

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
(1, 1, 'HAKAN KOR', 'pie (5).png', '2025-09-21 21:00:05', '2025-09-28 19:12:05'),
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
(1, 1, 1, 'medium', '2025-09-17 05:52:15', '2025-09-17 05:52:15');

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
  `etkinlik_id` int(11) DEFAULT NULL,
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

INSERT INTO `planned_multi_skill` (`id`, `person_id`, `organization_id`, `etkinlik_id`, `start_date`, `end_date`, `status`, `created_at`, `updated_at`, `success_status`) VALUES
(12, 1, 1, NULL, '2025-09-28', '2025-09-28', 'pending', '2025-09-28 17:41:13', '2025-09-28 19:12:05', 'tamamlandi');

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
(10, 1, 1, 1, 'ASELSAN', 'PERSONEL', '504657', 1, '2025-09-28', '2025-09-28', 'tamamlandi', '2025-09-28 17:12:28', '2025-09-28 17:40:55', 11, NULL, 'low', '', NULL, 'completed');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `planned_training_trainer`
--

CREATE TABLE `planned_training_trainer` (
  `id` int(11) NOT NULL,
  `person_id` int(11) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `etkinlik_id` int(11) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` varchar(50) DEFAULT 'planlandi',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `success_status` varchar(50) DEFAULT 'beklemede',
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `planned_training_trainer`
--

INSERT INTO `planned_training_trainer` (`id`, `person_id`, `organization_id`, `etkinlik_id`, `start_date`, `end_date`, `status`, `created_at`, `updated_at`, `success_status`, `description`) VALUES
(2, 1, 1, 1, '2025-09-28', '2025-10-05', 'planlandi', '2025-09-28 21:44:26', '2025-09-28 22:03:55', 'başarılı', 'Eğiticinin eğitimi isteği');

--
-- Tetikleyiciler `planned_training_trainer`
--
DELIMITER $$
CREATE TRIGGER `after_planned_training_trainer_update` AFTER UPDATE ON `planned_training_trainer` FOR EACH ROW BEGIN
    IF NEW.success_status = 'başarılı' AND (OLD.success_status IS NULL OR OLD.success_status != 'başarılı') THEN
        INSERT IGNORE INTO successful_trainers (
            person_id, 
            organization_id, 
            etkinlik_id, 
            start_date, 
            end_date
        ) VALUES (
            NEW.person_id,
            NEW.organization_id,
            NEW.etkinlik_id,
            NEW.start_date,
            NEW.end_date
        );
    END IF;
END
$$
DELIMITER ;

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
-- Tablo için tablo yapısı `successful_trainers`
--

CREATE TABLE `successful_trainers` (
  `id` int(11) NOT NULL,
  `person_id` int(11) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `etkinlik_id` int(11) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `success_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `successful_trainers`
--

INSERT INTO `successful_trainers` (`id`, `person_id`, `organization_id`, `etkinlik_id`, `start_date`, `end_date`, `success_date`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, '2025-09-28', '2025-10-05', '2025-09-28 22:03:55', '2025-09-28 22:03:55', '2025-09-28 22:03:55'),
(2, 2, 1, 1, '2025-10-01', '2025-10-03', '2025-09-28 22:10:15', '2025-09-28 22:10:15', '2025-09-28 22:10:15');

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
(10, 'yiğit', 'tabaklı', 'yazılım', '2025-09-21 08:04:48', '2025-09-21 08:04:48'),
(11, 'faruk', 'hikmet', 'yazılım geliştirme', '2025-09-28 16:31:04', '2025-09-28 16:31:04');

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

--
-- Tablo döküm verisi `temel_beceri_etkinlikleri`
--

INSERT INTO `temel_beceri_etkinlikleri` (`id`, `coklu_beceri_id`, `temel_beceri_adi`, `egitmen_adi`, `baslangic_tarihi`, `bitis_tarihi`, `kontenjan`, `olusturulma_tarihi`, `durum`) VALUES
(1, 1, 'DERS2', 'faruk hikmet', '2025-09-29', '2025-10-01', 1, '2025-09-28 16:37:47', 'aktif');

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
(13, 'yiğit tabaklı', 'deneme3', 'DERS4', '2025-09-21 08:04:48', '2025-09-21 08:04:48'),
(14, 'faruk hikmet', 'deneme1', 'DERS2', '2025-09-28 16:31:04', '2025-09-28 16:31:04');

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
  ADD UNIQUE KEY `unique_person_org` (`person_id`,`organization_id`),
  ADD KEY `fk_planned_multi_skill_etkinlik` (`etkinlik_id`);

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
-- Tablo için indeksler `planned_training_trainer`
--
ALTER TABLE `planned_training_trainer`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_person_id` (`person_id`),
  ADD KEY `idx_organization_id` (`organization_id`),
  ADD KEY `idx_etkinlik_id` (`etkinlik_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_created_at` (`created_at`);

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
-- Tablo için indeksler `successful_trainers`
--
ALTER TABLE `successful_trainers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_person_etkinlik` (`person_id`,`etkinlik_id`);

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
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `coklu_beceri_etkinlikleri`
--
ALTER TABLE `coklu_beceri_etkinlikleri`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Tablo için AUTO_INCREMENT değeri `egiticinin_egitimi_etkinlikleri`
--
ALTER TABLE `egiticinin_egitimi_etkinlikleri`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Tablo için AUTO_INCREMENT değeri `planned_skills`
--
ALTER TABLE `planned_skills`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Tablo için AUTO_INCREMENT değeri `planned_training_trainer`
--
ALTER TABLE `planned_training_trainer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Tablo için AUTO_INCREMENT değeri `skills`
--
ALTER TABLE `skills`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Tablo için AUTO_INCREMENT değeri `successful_trainers`
--
ALTER TABLE `successful_trainers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Tablo için AUTO_INCREMENT değeri `teachers`
--
ALTER TABLE `teachers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Tablo için AUTO_INCREMENT değeri `temel_beceri_etkinlikleri`
--
ALTER TABLE `temel_beceri_etkinlikleri`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Tablo için AUTO_INCREMENT değeri `tep_teachers`
--
ALTER TABLE `tep_teachers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

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
-- Tablo kısıtlamaları `planned_multi_skill`
--
ALTER TABLE `planned_multi_skill`
  ADD CONSTRAINT `fk_planned_multi_skill_etkinlik` FOREIGN KEY (`etkinlik_id`) REFERENCES `coklu_beceri_etkinlikleri` (`id`);

--
-- Tablo kısıtlamaları `planned_skills`
--
ALTER TABLE `planned_skills`
  ADD CONSTRAINT `planned_skills_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `planned_skills_ibfk_2` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `planned_skills_ibfk_3` FOREIGN KEY (`skill_id`) REFERENCES `organization_skills` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
