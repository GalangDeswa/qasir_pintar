-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 13, 2023 at 03:22 PM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `rimspos-standar`
--

-- --------------------------------------------------------

--
-- Table structure for table `beban`
--

CREATE TABLE `beban` (
  `id` int(100) NOT NULL,
  `id_toko` int(11) DEFAULT 0,
  `id_ktr_beban` int(11) DEFAULT 0,
  `id_user` int(100) NOT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `keterangan` text DEFAULT NULL,
  `tgl` date DEFAULT NULL,
  `jumlah` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `beban`
--

INSERT INTO `beban` (`id`, `id_toko`, `id_ktr_beban`, `id_user`, `nama`, `keterangan`, `tgl`, `jumlah`) VALUES
(108, 1, 6, 63, 'listrik bulan ini v2', 'bayar listrik bulan ini', '2023-04-25', 150000),
(109, 1, 6, 63, 'be an baru db', 'DB baru', '2023-05-13', 25000);

-- --------------------------------------------------------

--
-- Table structure for table `beban_kategori`
--

CREATE TABLE `beban_kategori` (
  `id` int(100) NOT NULL,
  `id_toko` int(11) NOT NULL DEFAULT 0,
  `kategori` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `beban_kategori`
--

INSERT INTO `beban_kategori` (`id`, `id_toko`, `kategori`) VALUES
(6, 1, 'Umum'),
(7, 1, 'Listrik'),
(10, 1, 'Air'),
(11, 1, 'Wifi'),
(82, 1, 'Gaji v2'),
(83, 1, 'DB baru');

-- --------------------------------------------------------

--
-- Table structure for table `hutang`
--

CREATE TABLE `hutang` (
  `id` int(11) NOT NULL,
  `id_toko` int(11) NOT NULL,
  `id_pelanggan` int(11) NOT NULL DEFAULT 0,
  `hutang` int(11) DEFAULT 0,
  `tgl_hutang` datetime DEFAULT NULL,
  `status` tinyint(1) DEFAULT 2 COMMENT '1. lunas, 2. hutang'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hutang`
--

INSERT INTO `hutang` (`id`, `id_toko`, `id_pelanggan`, `hutang`, `tgl_hutang`, `status`) VALUES
(15, 1, 15, 0, '2023-05-02 15:29:37', 1),
(20, 1, 16, 80000, '2023-05-13 20:05:01', 2);

-- --------------------------------------------------------

--
-- Table structure for table `hutang_detail`
--

CREATE TABLE `hutang_detail` (
  `id` int(11) NOT NULL,
  `id_hutang` int(11) NOT NULL,
  `id_toko` int(11) NOT NULL,
  `id_pelanggan` int(11) NOT NULL,
  `bayar` int(11) DEFAULT 0,
  `sisa` int(11) DEFAULT 0,
  `tgl_hutang` datetime NOT NULL,
  `tgl_bayar` datetime DEFAULT NULL,
  `tgl_lunas` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hutang_detail`
--

INSERT INTO `hutang_detail` (`id`, `id_hutang`, `id_toko`, `id_pelanggan`, `bayar`, `sisa`, `tgl_hutang`, `tgl_bayar`, `tgl_lunas`) VALUES
(23, 15, 1, 15, 20000, 9000, '2023-05-02 15:29:37', '2023-05-02 15:30:20', NULL),
(24, 15, 1, 15, 9000, 0, '2023-05-02 15:29:37', '2023-05-02 15:30:45', '2023-05-02 15:30:45'),
(35, 20, 1, 16, 5000, 80000, '2023-05-13 20:05:01', '2023-05-13 20:10:39', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `keranjang`
--

CREATE TABLE `keranjang` (
  `id` int(11) NOT NULL,
  `id_toko` int(11) DEFAULT 0,
  `meja` int(11) DEFAULT 0,
  `id_produk` int(11) DEFAULT 0,
  `id_kategori` int(11) DEFAULT 0 COMMENT '1 barang, 2 Jasa, 3. Paket',
  `id_jenis_stock` int(11) DEFAULT 0,
  `id_user` int(11) DEFAULT 0,
  `nama_brg` varchar(255) DEFAULT NULL,
  `harga_brg` int(11) DEFAULT 0,
  `diskon_brg` int(11) DEFAULT 0,
  `diskon_kasir` int(11) DEFAULT 0,
  `qty` int(11) DEFAULT 0,
  `total` int(11) DEFAULT 0,
  `status` int(11) DEFAULT 0 COMMENT '0. Barang Keranjang, 1. selesai',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `konten`
--

CREATE TABLE `konten` (
  `id` int(11) NOT NULL,
  `tipe` int(11) DEFAULT 0 COMMENT '1. square, 2. banner',
  `judul` text DEFAULT NULL,
  `deskripsi` text DEFAULT NULL,
  `link` text DEFAULT NULL,
  `foto` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `konten`
--

INSERT INTO `konten` (`id`, `tipe`, `judul`, `deskripsi`, `link`, `foto`) VALUES
(15, 1, 'RIMS Kopsyah', 'APlikasi koperasi syariah digital dengan fitur-fitur lengkap dna dapat di akses di mana saja.', 'https://rims.co.id/rims_kopsyah', 'http://192.168.100.33/rimspos-standar/uploads/konten/square1.png'),
(16, 1, 'RIMS Simpeg', 'Sistem informasi payroll dan HRIS yang akan memudahkan management karyawan di berbagai tempat.', 'https://rims.co.id/rims_simpeg', 'http://192.168.100.33/rimspos-standar/uploads/konten/square2.png'),
(17, 1, 'RIMS Dental', 'Sistem informasi management kesehatan dental dan klinik lainnya', 'https://rims.co.id/rims_apotik', 'http://192.168.100.33/rimspos-standar/uploads/konten/square3.png'),
(18, 1, 'Notarims', 'Sistem aplikasi notaris digital yang akan memudahkan proses notaris', 'www.rims.co.id', 'http://192.168.100.33/rimspos-standar/uploads/konten/square4.png'),
(19, 1, 'RIMS Distro', 'Aplikasi management penjualan distro dan butik', 'www.rims.co.id', 'http://192.168.100.33/rimspos-standar/uploads/konten/square5.png'),
(20, 1, 'RIMS digital marketing', 'RIMS menyediakan solusi digital marketing terjangkau dan profesional', 'www.rims.co.id', 'http://192.168.100.33/rimspos-standar/uploads/konten/square6.png'),
(21, 1, 'RIMS social media management', 'RIMS menyediakan jasa management sosial media yang akan mempermudah prose promosi dan digital marketing', 'www.rims.co.id', 'http://192.168.100.33/rimspos-standar/uploads/konten/square7.png'),
(22, 1, 'RIMS web design', 'Jasa design dan pengembangan website', 'www.rims.co.id', 'http://192.168.100.33/rimspos-standar/uploads/konten/square8.png'),
(23, 1, 'RIMS online marketing', 'layanan promosi dan design marketing online', 'www.rims.co.id', 'http://192.168.100.33/rimspos-standar/uploads/konten/square9.png'),
(24, 1, 'RIMS digital signage', 'aplikasi papan iklan digital berbasis smart tv android', 'www.rims.co.id', 'http://192.168.100.33/rimspos-standar/uploads/konten/square10.png'),
(25, 1, 'Rims digital signage 1', 'aplikasi papan iklan digital berbasis smart tv android', 'www.rims.co.id', 'http://192.168.100.33/rimspos-standar/uploads/konten/square11.png'),
(26, 2, 'RIMS kopsyah', 'APlikasi koperasi syariah digital', 'www.rims.co.id/rims_kopsyah', 'http://192.168.100.33/rimspos-standar/uploads/konten/banner1.png'),
(27, 2, 'RIMS digital signage', 'Papan iklan digital', 'www.rims.co.id', 'http://192.168.100.33/rimspos-standar/uploads/konten/banner2.png'),
(28, 2, 'RIMS digital marketing', 'Jasa digital marketing rims', 'www.rims.co.id', 'http://192.168.100.33/rimspos-standar/uploads/konten/banner3.png'),
(29, 2, 'RIMS team', 'RIMS creative digital company', 'www.rims.co.id', 'http://192.168.100.33/rimspos-standar/uploads/konten/banner4.png');

-- --------------------------------------------------------

--
-- Table structure for table `laporan`
--

CREATE TABLE `laporan` (
  `id` int(11) NOT NULL,
  `nama` varchar(255) DEFAULT NULL,
  `link` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT 1 COMMENT '0.tdak aktif, 1.aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `laporan`
--

INSERT INTO `laporan` (`id`, `nama`, `link`, `status`) VALUES
(1, 'Laporan Umum', '#', 1),
(2, 'Laporan Penjualan', '#', 1),
(3, 'Laporan Beban', '#', 1),
(4, 'Laporan Reversal', '#', 1);

-- --------------------------------------------------------

--
-- Table structure for table `pelanggan`
--

CREATE TABLE `pelanggan` (
  `id` int(11) NOT NULL,
  `id_toko` int(11) NOT NULL,
  `nama_pelanggan` varchar(100) NOT NULL,
  `no_hp` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pelanggan`
--

INSERT INTO `pelanggan` (`id`, `id_toko`, `nama_pelanggan`, `no_hp`, `created_at`, `updated_at`) VALUES
(10, 1, 'bambang', '08123', '2023-04-12 03:28:16', '2023-04-12 03:28:16'),
(11, 1, 'no penjualan', '08123346', '2023-04-12 10:05:31', '2023-04-12 10:05:31'),
(14, 1, 'Micheal', '092292', '2023-04-19 14:06:20', '2023-04-19 14:06:20'),
(15, 1, 'John elden ring', '081393939', '2023-04-19 14:26:21', '2023-04-19 14:26:21'),
(16, 1, 'Micheal overwatch', '1212121212', '2023-05-05 03:36:58', '2023-05-05 03:36:58');

-- --------------------------------------------------------

--
-- Table structure for table `penjualan`
--

CREATE TABLE `penjualan` (
  `id` int(11) NOT NULL,
  `id_toko` int(11) DEFAULT 0,
  `id_pelanggan` int(11) DEFAULT 0,
  `meja` int(11) DEFAULT 0,
  `id_user` int(11) DEFAULT 0,
  `id_hutang` int(11) DEFAULT 0,
  `total_item` int(11) DEFAULT 0,
  `diskon_total` int(11) DEFAULT 0,
  `sub_total` int(11) DEFAULT 0,
  `total` int(11) DEFAULT 0,
  `bayar` int(11) DEFAULT 0,
  `kembalian` int(11) DEFAULT 0,
  `tgl_penjualan` datetime DEFAULT NULL,
  `metode_bayar` int(11) DEFAULT 1 COMMENT '1. cash,\r\n2. non-cash,\r\n3. hutang',
  `status` int(11) DEFAULT 0 COMMENT '1 Selesai, \r\n2 Hutang, \r\n3 Bayar nanti, \r\n4 transaksi batal (Reversal)',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `penjualan`
--

INSERT INTO `penjualan` (`id`, `id_toko`, `id_pelanggan`, `meja`, `id_user`, `id_hutang`, `total_item`, `diskon_total`, `sub_total`, `total`, `bayar`, `kembalian`, `tgl_penjualan`, `metode_bayar`, `status`, `created_at`, `updated_at`) VALUES
(128, 1, NULL, 1, 63, 15, 1, 15000, 100000, 85000, 100000, 15000, '2023-05-07 10:58:05', 1, 4, '2023-05-07 03:58:05', '2023-05-13 13:20:53'),
(129, 1, 16, 1, 63, 20, 1, 15000, 100000, 85000, 0, -85000, '2023-05-13 20:05:01', 3, 3, '2023-05-13 13:05:01', '2023-05-13 13:05:01');

-- --------------------------------------------------------

--
-- Table structure for table `penjualan_detail`
--

CREATE TABLE `penjualan_detail` (
  `id` int(100) NOT NULL,
  `id_penjualan` int(11) DEFAULT 0,
  `id_produk` int(11) DEFAULT 0,
  `id_kategori` int(11) DEFAULT 0,
  `id_user` int(11) DEFAULT 0,
  `id_jenis_stock` int(11) DEFAULT 0,
  `nama_brg` varchar(100) DEFAULT NULL,
  `harga_modal` int(11) DEFAULT 0,
  `harga_brg` int(11) DEFAULT 0,
  `qty` int(11) DEFAULT 0,
  `diskon_brg` int(11) DEFAULT 0,
  `total` int(11) DEFAULT 0,
  `tgl` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `penjualan_detail`
--

INSERT INTO `penjualan_detail` (`id`, `id_penjualan`, `id_produk`, `id_kategori`, `id_user`, `id_jenis_stock`, `nama_brg`, `harga_modal`, `harga_brg`, `qty`, `diskon_brg`, `total`, `tgl`, `created_at`, `updated_at`) VALUES
(179, 128, 346, 1, 63, 2, 'a no barcode edit', 90000, 100000, 1, 15000, 85000, '2023-05-07 10:58:05', '2023-05-07 03:58:05', '2023-05-07 03:58:05'),
(180, 129, 346, 1, 63, 2, 'a no barcode edit', 90000, 100000, 1, 15000, 85000, '2023-05-13 20:05:01', '2023-05-13 13:05:01', '2023-05-13 13:05:01');

-- --------------------------------------------------------

--
-- Table structure for table `produk`
--

CREATE TABLE `produk` (
  `id` int(11) NOT NULL,
  `barcode` text DEFAULT '-',
  `id_toko` int(11) DEFAULT 0,
  `id_user` int(11) DEFAULT 0,
  `id_jenis` int(11) DEFAULT 0,
  `id_kategori` int(1) DEFAULT 0 COMMENT '1 barang, 2 Jasa, 3. Paket',
  `id_jenis_stock` int(11) DEFAULT 0 COMMENT '1. Stock, 2. Non stock',
  `nama_produk` varchar(100) DEFAULT NULL,
  `deskripsi` text DEFAULT NULL,
  `qty` int(11) DEFAULT 0,
  `harga` int(11) DEFAULT 0,
  `harga_modal` int(11) NOT NULL DEFAULT 0,
  `diskon_barang` int(11) DEFAULT 0,
  `image` text DEFAULT NULL,
  `status` int(11) DEFAULT 1 COMMENT '1. aktif, 2. tidak aktif, 3. hapus',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `produk`
--

INSERT INTO `produk` (`id`, `barcode`, `id_toko`, `id_user`, `id_jenis`, `id_kategori`, `id_jenis_stock`, `nama_produk`, `deskripsi`, `qty`, `harga`, `harga_modal`, `diskon_barang`, `image`, `status`, `created_at`, `updated_at`, `deleted_at`) VALUES
(253, NULL, 1, 63, 21, 1, 1, 'diskon', '12', 4, 50000, 0, 0, NULL, 1, '2023-04-18 15:04:21', '2023-05-03 04:16:36', NULL),
(254, NULL, 1, 63, 21, 1, 2, 'no diskon edit', 'zxc', 0, 10000, 0, 0, 'uploads/produk/230419092859.jpg', 1, '2023-04-18 15:04:52', '2023-04-20 01:27:23', NULL),
(255, NULL, 1, 63, 22, 1, 1, 'Hot latte', 'hot latte', 97, 25000, 0, 0, 'uploads/produk/230423115049.jpg', 1, '2023-04-21 04:17:42', '2023-05-04 04:21:15', NULL),
(256, NULL, 1, 63, 62, 1, 2, 'snack', 'scnak', 0, 25000, 0, 20000, NULL, 1, '2023-04-21 04:30:21', '2023-04-21 04:30:21', NULL),
(257, '99999', 1, 63, 22, 1, 1, 'a postman edit barcode v2', 'api edit', 248, 0, 0, 0, 'uploads/produk/230425060349.png', 1, '2023-04-21 04:31:05', '2023-05-04 04:21:15', NULL),
(258, '12345', 1, 63, 21, 1, 1, 'makanan 1', '-', 13, 15000, 0, 0, NULL, 1, '2023-04-23 05:00:57', '2023-04-28 05:13:32', NULL),
(259, '8995177101112', 1, 63, 21, 1, 2, 'gulaku 1kg', '-', 0, 15000, 0, 1000, NULL, 1, '2023-04-23 05:01:26', '2023-04-23 05:01:26', NULL),
(260, '6925196003243', 1, 63, 21, 1, 1, 'herbal mata', '-', 8, 15000, 0, 0, NULL, 1, '2023-04-23 05:01:34', '2023-04-23 05:01:34', NULL),
(261, NULL, 1, 63, 21, 1, 2, 'makanan 4', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:01:44', '2023-04-23 05:01:44', NULL),
(262, NULL, 1, 63, 21, 1, 2, 'makanan 5', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:01:47', '2023-04-23 05:01:47', NULL),
(263, NULL, 1, 63, 21, 1, 2, 'makanan 6', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:01:50', '2023-04-23 05:01:50', NULL),
(264, NULL, 1, 63, 21, 1, 2, 'makanan 7', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:01:53', '2023-04-23 05:01:53', NULL),
(265, NULL, 1, 63, 21, 1, 2, 'makanan 8', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:01:57', '2023-04-23 05:01:57', NULL),
(266, NULL, 1, 63, 21, 1, 2, 'makanan 9', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:02:00', '2023-04-23 05:02:00', NULL),
(267, NULL, 1, 63, 21, 1, 2, 'makanan 10', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:02:04', '2023-04-23 05:02:04', NULL),
(268, NULL, 1, 63, 22, 1, 2, 'minuman 1', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:02:34', '2023-04-23 05:02:34', NULL),
(269, NULL, 1, 63, 22, 1, 2, 'minuman 2', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:02:37', '2023-04-23 05:02:37', NULL),
(270, NULL, 1, 63, 22, 1, 2, 'minuman 3', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:02:40', '2023-04-23 05:02:40', NULL),
(271, NULL, 1, 63, 22, 1, 2, 'minuman 4', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:02:43', '2023-04-23 05:02:43', NULL),
(272, NULL, 1, 63, 22, 1, 2, 'minuman 5', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:02:45', '2023-04-23 05:02:45', NULL),
(273, NULL, 1, 63, 22, 1, 2, 'minuman 6', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:02:48', '2023-04-23 05:02:48', NULL),
(274, NULL, 1, 63, 22, 1, 2, 'minuman 7', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:02:51', '2023-04-23 05:02:51', NULL),
(275, NULL, 1, 63, 22, 1, 2, 'minuman 8', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:02:53', '2023-04-23 05:02:53', NULL),
(276, NULL, 1, 63, 22, 1, 2, 'minuman 9', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:02:56', '2023-04-23 05:02:56', NULL),
(277, NULL, 1, 63, 22, 1, 2, 'minuman 10', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:02:59', '2023-04-23 05:02:59', NULL),
(278, NULL, 1, 63, 62, 1, 2, 'snack 1', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:03:19', '2023-04-23 05:03:19', NULL),
(279, NULL, 1, 63, 62, 1, 2, 'snack 2', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:03:22', '2023-04-23 05:03:22', NULL),
(280, NULL, 1, 63, 62, 1, 2, 'snack 3', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:03:24', '2023-04-23 05:03:24', NULL),
(281, NULL, 1, 63, 62, 1, 2, 'snack 4', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:03:26', '2023-04-23 05:03:26', NULL),
(282, NULL, 1, 63, 62, 1, 2, 'snack 5', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:03:29', '2023-04-23 05:03:29', NULL),
(283, NULL, 1, 63, 62, 1, 2, 'snack 6', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:03:31', '2023-04-23 05:03:31', NULL),
(284, NULL, 1, 63, 62, 1, 2, 'snack 7', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:03:34', '2023-04-23 05:03:34', NULL),
(285, NULL, 1, 63, 62, 1, 2, 'snack 8', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:03:36', '2023-04-23 05:03:36', NULL),
(286, NULL, 1, 63, 62, 1, 2, 'snack 9', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:03:40', '2023-04-23 05:03:40', NULL),
(287, NULL, 1, 63, 62, 1, 2, 'snack 10', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:03:42', '2023-04-23 05:03:42', NULL),
(288, NULL, 1, 63, 64, 1, 2, 'paket 1', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:04:04', '2023-04-23 05:04:04', NULL),
(289, NULL, 1, 63, 64, 1, 2, 'paket 2', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:04:07', '2023-04-23 05:04:07', NULL),
(290, NULL, 1, 63, 64, 1, 2, 'paket 3', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:04:09', '2023-04-23 05:04:09', NULL),
(291, NULL, 1, 63, 64, 1, 2, 'paket 4', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:04:12', '2023-04-23 05:04:12', NULL),
(292, NULL, 1, 63, 64, 1, 2, 'paket 5', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:04:14', '2023-04-23 05:04:14', NULL),
(293, NULL, 1, 63, 64, 1, 2, 'paket 6', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:04:17', '2023-04-23 05:04:17', NULL),
(294, NULL, 1, 63, 64, 1, 2, 'paket 7', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:04:19', '2023-04-23 05:04:19', NULL),
(295, NULL, 1, 63, 64, 1, 2, 'paket 8', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:04:23', '2023-04-23 05:04:23', NULL),
(296, NULL, 1, 63, 64, 1, 2, 'paket 9', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:04:26', '2023-04-23 05:04:26', NULL),
(297, NULL, 1, 63, 64, 1, 2, 'paket 10', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:04:29', '2023-04-23 05:04:29', NULL),
(298, NULL, 1, 63, 21, 1, 2, 'makanan 11', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:19:11', '2023-04-23 05:19:11', NULL),
(299, NULL, 1, 63, 21, 1, 2, 'makanan 12', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:19:14', '2023-04-23 05:19:14', NULL),
(300, NULL, 1, 63, 21, 1, 2, 'makanan 13', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:19:16', '2023-04-23 05:19:16', NULL),
(301, NULL, 1, 63, 21, 1, 2, 'makanan 14', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:19:19', '2023-04-23 05:19:19', NULL),
(302, NULL, 1, 63, 21, 1, 2, 'makanan 15', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:19:21', '2023-04-23 05:19:21', NULL),
(303, NULL, 1, 63, 21, 1, 2, 'makanan 16', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:19:23', '2023-04-23 05:19:23', NULL),
(304, NULL, 1, 63, 21, 1, 2, 'makanan 17', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:19:27', '2023-04-23 05:19:27', NULL),
(305, NULL, 1, 63, 21, 1, 2, 'makanan 18', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:19:29', '2023-04-23 05:19:29', NULL),
(306, NULL, 1, 63, 21, 1, 2, 'makanan 19', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:19:32', '2023-04-23 05:19:32', NULL),
(307, NULL, 1, 63, 21, 1, 2, 'makanan 20', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:19:35', '2023-04-23 05:19:35', NULL),
(308, NULL, 1, 63, 22, 1, 2, 'minuman 11', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:19:43', '2023-04-23 05:19:43', NULL),
(309, NULL, 1, 63, 22, 1, 2, 'minuman 12', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:19:45', '2023-04-23 05:19:45', NULL),
(310, NULL, 1, 63, 22, 1, 2, 'minuman 13', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:19:47', '2023-04-23 05:19:47', NULL),
(311, NULL, 1, 63, 22, 1, 2, 'minuman 14', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:19:49', '2023-04-23 05:19:49', NULL),
(312, NULL, 1, 63, 22, 1, 2, 'minuman 15', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:19:52', '2023-04-23 05:19:52', NULL),
(313, NULL, 1, 63, 22, 1, 2, 'minuman 16', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:19:54', '2023-04-23 05:19:54', NULL),
(314, NULL, 1, 63, 22, 1, 2, 'minuman 17', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:19:56', '2023-04-23 05:19:56', NULL),
(315, NULL, 1, 63, 22, 1, 2, 'minuman 18', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:19:59', '2023-04-23 05:19:59', NULL),
(316, NULL, 1, 63, 22, 1, 2, 'minuman 19', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:20:01', '2023-04-23 05:20:01', NULL),
(317, NULL, 1, 63, 22, 1, 2, 'minuman 20', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:20:06', '2023-04-23 05:20:06', NULL),
(318, NULL, 1, 63, 62, 1, 2, 'snack 11', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:20:15', '2023-04-23 05:20:15', NULL),
(319, NULL, 1, 63, 62, 1, 2, 'snack 12', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:20:17', '2023-04-23 05:20:17', NULL),
(320, NULL, 1, 63, 62, 1, 2, 'snack 13', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:20:19', '2023-04-23 05:20:19', NULL),
(321, NULL, 1, 63, 62, 1, 2, 'snack 14', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:20:22', '2023-04-23 05:20:22', NULL),
(322, NULL, 1, 63, 62, 1, 2, 'snack 15', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:20:24', '2023-04-23 05:20:24', NULL),
(323, NULL, 1, 63, 62, 1, 2, 'snack 16', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:20:26', '2023-04-23 05:20:26', NULL),
(324, NULL, 1, 63, 62, 1, 2, 'snack 17', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:20:28', '2023-04-23 05:20:28', NULL),
(325, NULL, 1, 63, 62, 1, 2, 'snack 18', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:20:31', '2023-04-23 05:20:31', NULL),
(326, NULL, 1, 63, 62, 1, 2, 'snack 19', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:20:33', '2023-04-23 05:20:33', NULL),
(327, NULL, 1, 63, 62, 1, 2, 'snack 20', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:20:36', '2023-04-23 05:20:36', NULL),
(328, NULL, 1, 63, 64, 1, 2, 'paket 11', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:20:45', '2023-04-23 05:20:45', NULL),
(329, NULL, 1, 63, 64, 1, 2, 'paket 12', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:20:47', '2023-04-23 05:20:47', NULL),
(330, NULL, 1, 63, 64, 1, 2, 'paket 13', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:20:49', '2023-04-23 05:20:49', NULL),
(331, NULL, 1, 63, 64, 1, 2, 'paket 14', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:20:52', '2023-04-23 05:20:52', NULL),
(332, NULL, 1, 63, 64, 1, 2, 'paket 15', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:20:54', '2023-04-23 05:20:54', NULL),
(333, NULL, 1, 63, 64, 1, 2, 'paket 16', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:20:56', '2023-04-23 05:20:56', NULL),
(334, NULL, 1, 63, 64, 1, 2, 'paket 17', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:20:59', '2023-04-23 05:20:59', NULL),
(335, NULL, 1, 63, 64, 1, 2, 'paket 18', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:21:01', '2023-04-23 05:21:01', NULL),
(336, NULL, 1, 63, 64, 1, 2, 'paket 19', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:21:04', '2023-04-23 05:21:04', NULL),
(337, NULL, 1, 63, 64, 1, 2, 'paket 20', '-', 0, 15000, 0, 0, NULL, 1, '2023-04-23 05:21:09', '2023-04-23 05:21:09', NULL),
(342, '123456', 1, 63, 21, 1, 1, 'a barcode', 'barcode', 100, 15000, 0, 10000, NULL, 3, '2023-04-25 07:55:23', '2023-04-25 07:59:40', NULL),
(343, '123456', 1, 63, 64, 1, 2, 'a no barcode', 'no barcode', 0, 50000, 0, 0, 'uploads/produk/230425025754.jpg', 3, '2023-04-25 07:57:54', '2023-04-25 07:58:08', NULL),
(344, '123456', 1, 63, 21, 1, 2, 'a no barcode', 'no barcode', 0, 100000, 0, 0, 'uploads/produk/230425025835.jpg', 3, '2023-04-25 07:58:35', '2023-04-25 07:59:37', NULL),
(345, '089686061123', 1, 63, 21, 1, 1, 'pop mie', 'qwe', 5, 50000, 0, 10000, NULL, 1, '2023-04-25 08:00:06', '2023-04-25 13:24:36', NULL),
(346, '5656566', 1, 63, 21, 1, 2, 'a no barcode edit', 'qw', 0, 100000, 90000, 85000, 'uploads/produk/230425043202.jpg', 1, '2023-04-25 08:00:35', '2023-05-03 05:20:27', NULL),
(347, '123', 1, 63, 21, 1, 2, 'aqwe', 'qwe', 0, 1230, 0, 0, NULL, 1, '2023-04-25 09:35:20', '2023-04-25 09:36:23', NULL),
(348, '-', 1, 63, 22, 1, 2, 'a postman edit barcode', 'api edit', 0, 0, 0, 0, 'uploads/produk/230425055930.png', 1, '2023-04-25 10:54:32', '2023-04-25 11:04:53', NULL),
(349, '-', 1, 63, 22, 1, 2, 'a postman edit barcode', 'api edit', 0, 123, 0, 1, 'uploads/produk/230425060021.png', 1, '2023-04-25 10:54:50', '2023-04-25 11:00:21', NULL),
(350, '12345', 1, 63, 21, 1, 1, 'test', 'qwe', 5, 50000, 0, 25000, NULL, 1, '2023-04-29 03:43:15', '2023-04-29 03:43:15', NULL),
(351, '-', 1, 63, 21, 1, 2, 'test diskon', 'qweqeqw', 0, 50000, 0, 25000, NULL, 1, '2023-05-03 04:42:30', '2023-05-03 04:42:30', NULL),
(352, '-', 1, 63, 21, 1, 2, 'a selisih', 'qwe', 0, 100000, 0, 0, NULL, 3, '2023-05-03 05:25:15', '2023-05-03 05:25:37', NULL),
(353, '-', 1, 63, 21, 1, 2, 'a selisih', 'qwe', 0, 100000, 0, 0, NULL, 1, '2023-05-03 05:32:53', '2023-05-05 03:45:09', NULL),
(354, '11111111', 1, 63, 21, 1, 2, 'qweqeqweqeq', 'qweqeqew', 0, 100000, 0, 85000, NULL, 1, '2023-05-03 05:44:08', '2023-05-03 05:44:08', NULL),
(355, '-', 1, 63, 64, 1, 2, 'ab out test', 'qwe', 0, 100000, 0, 80000, NULL, 3, '2023-05-03 06:11:47', '2023-05-13 07:33:13', NULL),
(356, '-', 1, 63, 22, 1, 2, 'harga modal', '-', 0, 15000, 10000, 0, NULL, 1, '2023-05-06 07:09:38', '2023-05-06 07:09:38', NULL),
(357, '000099', 1, 63, 21, 1, 1, 'Android harga modal', 'dengan harga modal', 88, 75000, 55000, 0, NULL, 1, '2023-05-06 07:32:07', '2023-05-06 08:28:38', NULL),
(358, '98888', 1, 63, 62, 1, 1, 'update db', 'db', 28, 15000, 10000, 8000, 'uploads/produk/230513022520.jpg', 1, '2023-05-13 07:25:20', '2023-05-13 07:25:20', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `produk_jenis`
--

CREATE TABLE `produk_jenis` (
  `id` int(100) NOT NULL,
  `id_toko` int(100) NOT NULL,
  `nama_jenis` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `produk_jenis`
--

INSERT INTO `produk_jenis` (`id`, `id_toko`, `nama_jenis`) VALUES
(21, 1, 'Makanan'),
(22, 1, 'Minuman'),
(62, 1, 'Snack'),
(64, 1, 'Paket'),
(68, 1, 'DB baru edit v2');

-- --------------------------------------------------------

--
-- Table structure for table `produk_kategori`
--

CREATE TABLE `produk_kategori` (
  `id` int(11) NOT NULL,
  `nama_kategori` varchar(100) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `produk_kategori`
--

INSERT INTO `produk_kategori` (`id`, `nama_kategori`) VALUES
(1, 'barang'),
(3, 'paket'),
(2, 'jasa');

-- --------------------------------------------------------

--
-- Table structure for table `toko`
--

CREATE TABLE `toko` (
  `id` int(100) NOT NULL,
  `id_user` int(11) DEFAULT 0,
  `jenisusaha` varchar(255) DEFAULT NULL,
  `nama_toko` varchar(100) DEFAULT NULL,
  `alamat` text DEFAULT NULL,
  `nohp` varchar(200) DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `logo` text DEFAULT NULL,
  `status` varchar(1) DEFAULT NULL COMMENT '0.tidak aktif,\r\n1. aktif,\r\n2. proses aktifasi,\r\n3. di hapus',
  `tgl_aktif` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `toko`
--

INSERT INTO `toko` (`id`, `id_user`, `jenisusaha`, `nama_toko`, `alamat`, `nohp`, `email`, `logo`, `status`, `tgl_aktif`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 63, 'Cafe', 'RIMS Cafe', 'Banda Aceh', NULL, 'Rims.co.id', 'https://rims.co.id/rimspos-standar/uploads/logo/default.png', '1', '2023-03-14 23:16:01', '2021-12-11 17:00:00', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(100) NOT NULL,
  `id_toko` int(100) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `hp` varchar(225) DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `role` int(11) DEFAULT NULL COMMENT '1. kasir\r\n2. admin',
  `status` int(11) DEFAULT 1 COMMENT '1. aktif\r\n2. tidak aktif',
  `created_by` int(11) DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `id_toko`, `name`, `email`, `hp`, `email_verified_at`, `password`, `avatar`, `role`, `status`, `created_by`, `remember_token`, `deleted_at`, `created_at`, `updated_at`) VALUES
(27, 1, 'galang', 'galang@galang.com', '08134234', NULL, '$2y$10$jVPuZvr1MAgWHDmH7iBKLeHLQXxgQSr/WtiJT3rmy7NhdqQDVji2y', NULL, 2, 1, 27, NULL, NULL, '2023-03-20 10:38:09', '2023-03-22 21:03:49'),
(48, 1, 'misbah', 'misbah@misbah.com', '04959696', NULL, '$2y$10$9T9cm3yAdW9njThnkzN68.orIfDLHhTbOF1uuYVdlL8mWiZvzjW0m', NULL, 2, 1, 27, NULL, NULL, '2023-03-22 21:03:36', '2023-03-22 21:03:36'),
(63, 1, 'localhost', 'local@host.com', '000001', NULL, '$2y$10$glim79prcSDbGwJGw2/qZeBoCDDd.fB5cTuUy49cvWjQ44kAOgl/W', NULL, 2, 1, 48, NULL, NULL, '2023-04-10 01:07:09', '2023-04-10 01:07:09');

-- --------------------------------------------------------

--
-- Table structure for table `versi_app`
--

CREATE TABLE `versi_app` (
  `id` int(11) NOT NULL,
  `app_version` varchar(100) NOT NULL,
  `link` text NOT NULL,
  `comment` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `versi_app`
--

INSERT INTO `versi_app` (`id`, `app_version`, `link`, `comment`) VALUES
(1, '1.0', '', '');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `beban`
--
ALTER TABLE `beban`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_ktr_beban` (`id_ktr_beban`),
  ADD KEY `id_toko` (`id_toko`),
  ADD KEY `id_user` (`id_user`);

--
-- Indexes for table `beban_kategori`
--
ALTER TABLE `beban_kategori`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hutang`
--
ALTER TABLE `hutang`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_toko` (`id_toko`),
  ADD KEY `id_pelanggan` (`id_pelanggan`);

--
-- Indexes for table `hutang_detail`
--
ALTER TABLE `hutang_detail`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_hutang` (`id_hutang`),
  ADD KEY `id_toko` (`id_toko`),
  ADD KEY `id_pelanggan` (`id_pelanggan`);

--
-- Indexes for table `keranjang`
--
ALTER TABLE `keranjang`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_toko` (`id_toko`),
  ADD KEY `id_produk` (`id_produk`),
  ADD KEY `id_kategori` (`id_kategori`),
  ADD KEY `id_jenis_stock` (`id_jenis_stock`),
  ADD KEY `id_user` (`id_user`);

--
-- Indexes for table `konten`
--
ALTER TABLE `konten`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `laporan`
--
ALTER TABLE `laporan`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pelanggan`
--
ALTER TABLE `pelanggan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_toko` (`id_toko`);

--
-- Indexes for table `penjualan`
--
ALTER TABLE `penjualan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_toko` (`id_toko`),
  ADD KEY `id_pelanggan` (`id_pelanggan`),
  ADD KEY `id_user` (`id_user`),
  ADD KEY `id_hutang` (`id_hutang`);

--
-- Indexes for table `penjualan_detail`
--
ALTER TABLE `penjualan_detail`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_penjualan` (`id_penjualan`),
  ADD KEY `id_produk` (`id_produk`),
  ADD KEY `id_kategori` (`id_kategori`),
  ADD KEY `id_user` (`id_user`),
  ADD KEY `id_jenis_stock` (`id_jenis_stock`);

--
-- Indexes for table `produk`
--
ALTER TABLE `produk`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_toko` (`id_toko`),
  ADD KEY `id_user` (`id_user`),
  ADD KEY `id_jenis` (`id_jenis`),
  ADD KEY `id_kategori` (`id_kategori`),
  ADD KEY `id_jenis_stock` (`id_jenis_stock`);

--
-- Indexes for table `produk_jenis`
--
ALTER TABLE `produk_jenis`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_toko` (`id_toko`);

--
-- Indexes for table `produk_kategori`
--
ALTER TABLE `produk_kategori`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `toko`
--
ALTER TABLE `toko`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_user` (`id_user`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD KEY `id_toko` (`id_toko`);

--
-- Indexes for table `versi_app`
--
ALTER TABLE `versi_app`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `beban`
--
ALTER TABLE `beban`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=110;

--
-- AUTO_INCREMENT for table `beban_kategori`
--
ALTER TABLE `beban_kategori`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=84;

--
-- AUTO_INCREMENT for table `hutang`
--
ALTER TABLE `hutang`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `hutang_detail`
--
ALTER TABLE `hutang_detail`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `keranjang`
--
ALTER TABLE `keranjang`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=375;

--
-- AUTO_INCREMENT for table `konten`
--
ALTER TABLE `konten`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `laporan`
--
ALTER TABLE `laporan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `pelanggan`
--
ALTER TABLE `pelanggan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `penjualan`
--
ALTER TABLE `penjualan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=130;

--
-- AUTO_INCREMENT for table `penjualan_detail`
--
ALTER TABLE `penjualan_detail`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=181;

--
-- AUTO_INCREMENT for table `produk`
--
ALTER TABLE `produk`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=359;

--
-- AUTO_INCREMENT for table `produk_jenis`
--
ALTER TABLE `produk_jenis`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=69;

--
-- AUTO_INCREMENT for table `produk_kategori`
--
ALTER TABLE `produk_kategori`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `toko`
--
ALTER TABLE `toko`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT for table `versi_app`
--
ALTER TABLE `versi_app`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `beban`
--
ALTER TABLE `beban`
  ADD CONSTRAINT `beban_ibfk_1` FOREIGN KEY (`id_ktr_beban`) REFERENCES `beban_kategori` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `beban_ibfk_2` FOREIGN KEY (`id_toko`) REFERENCES `toko` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `beban_ibfk_3` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `hutang`
--
ALTER TABLE `hutang`
  ADD CONSTRAINT `hutang_ibfk_1` FOREIGN KEY (`id_toko`) REFERENCES `toko` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `hutang_ibfk_2` FOREIGN KEY (`id_pelanggan`) REFERENCES `pelanggan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `hutang_detail`
--
ALTER TABLE `hutang_detail`
  ADD CONSTRAINT `hutang_detail_ibfk_1` FOREIGN KEY (`id_hutang`) REFERENCES `hutang` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `hutang_detail_ibfk_2` FOREIGN KEY (`id_toko`) REFERENCES `toko` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `hutang_detail_ibfk_3` FOREIGN KEY (`id_pelanggan`) REFERENCES `pelanggan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `keranjang`
--
ALTER TABLE `keranjang`
  ADD CONSTRAINT `keranjang_ibfk_1` FOREIGN KEY (`id_toko`) REFERENCES `toko` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `keranjang_ibfk_2` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `keranjang_ibfk_3` FOREIGN KEY (`id_jenis_stock`) REFERENCES `produk` (`id_jenis_stock`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `keranjang_ibfk_4` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `pelanggan`
--
ALTER TABLE `pelanggan`
  ADD CONSTRAINT `pelanggan_ibfk_1` FOREIGN KEY (`id_toko`) REFERENCES `toko` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `penjualan`
--
ALTER TABLE `penjualan`
  ADD CONSTRAINT `penjualan_ibfk_1` FOREIGN KEY (`id_toko`) REFERENCES `toko` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `penjualan_ibfk_2` FOREIGN KEY (`id_pelanggan`) REFERENCES `pelanggan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `penjualan_ibfk_3` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `penjualan_ibfk_4` FOREIGN KEY (`id_hutang`) REFERENCES `hutang` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `penjualan_detail`
--
ALTER TABLE `penjualan_detail`
  ADD CONSTRAINT `penjualan_detail_ibfk_1` FOREIGN KEY (`id_penjualan`) REFERENCES `penjualan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `penjualan_detail_ibfk_2` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `penjualan_detail_ibfk_3` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `penjualan_detail_ibfk_4` FOREIGN KEY (`id_jenis_stock`) REFERENCES `produk` (`id_jenis_stock`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `produk`
--
ALTER TABLE `produk`
  ADD CONSTRAINT `produk_ibfk_1` FOREIGN KEY (`id_toko`) REFERENCES `toko` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `produk_ibfk_2` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `produk_ibfk_3` FOREIGN KEY (`id_jenis`) REFERENCES `produk_jenis` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `produk_jenis`
--
ALTER TABLE `produk_jenis`
  ADD CONSTRAINT `id_toko` FOREIGN KEY (`id_toko`) REFERENCES `toko` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `toko`
--
ALTER TABLE `toko`
  ADD CONSTRAINT `id_user` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`id_toko`) REFERENCES `toko` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
