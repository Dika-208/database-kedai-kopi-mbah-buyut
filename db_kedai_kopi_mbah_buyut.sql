-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 06, 2026 at 06:49 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_kedai_kopi_mbah_buyut`
--

-- --------------------------------------------------------

--
-- Table structure for table `detail_pesanan`
--

CREATE TABLE `detail_pesanan` (
  `id_detail` int(11) NOT NULL,
  `id_pesanan` int(11) NOT NULL,
  `id_menu` int(11) NOT NULL,
  `id_varian` int(11) DEFAULT NULL,
  `jumlah` int(11) NOT NULL DEFAULT 1,
  `harga_satuan` decimal(10,2) NOT NULL,
  `subtotal` decimal(12,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jam_operasional`
--

CREATE TABLE `jam_operasional` (
  `id_jam` int(11) NOT NULL,
  `hari` enum('Senin','Selasa','Rabu','Kamis','Jumat','Sabtu','Minggu') NOT NULL,
  `jam_buka` time NOT NULL,
  `jam_tutup` time NOT NULL,
  `status_buka` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `kategori_menu`
--

CREATE TABLE `kategori_menu` (
  `id_kategori` int(11) NOT NULL,
  `nama_kategori` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `meja`
--

CREATE TABLE `meja` (
  `id_meja` int(11) NOT NULL,
  `nomor_meja` varchar(10) NOT NULL,
  `kode_qr` varchar(100) NOT NULL,
  `status` enum('tersedia','terpakai') NOT NULL DEFAULT 'tersedia'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `menu`
--

CREATE TABLE `menu` (
  `id_menu` int(11) NOT NULL,
  `id_kategori` int(11) NOT NULL,
  `nama_menu` varchar(100) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `harga` decimal(10,2) NOT NULL,
  `gambar` varchar(255) DEFAULT NULL,
  `tersedia` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pembayaran`
--

CREATE TABLE `pembayaran` (
  `id_pembayaran` int(11) NOT NULL,
  `id_pesanan` int(11) NOT NULL,
  `metode` enum('tunai','qris','transfer','e_wallet') NOT NULL,
  `jumlah_bayar` decimal(12,2) NOT NULL,
  `kembalian` decimal(12,2) NOT NULL DEFAULT 0.00,
  `status_bayar` enum('pending','lunas','gagal') NOT NULL DEFAULT 'pending',
  `referensi` varchar(100) DEFAULT NULL,
  `waktu_bayar` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pengaturan_coin`
--

CREATE TABLE `pengaturan_coin` (
  `id_pengaturan` int(11) NOT NULL,
  `rupiah_per_coin` int(11) NOT NULL DEFAULT 10000,
  `nilai_tukar_coin` int(11) NOT NULL DEFAULT 1000,
  `maks_coin_per_transaksi` int(11) NOT NULL DEFAULT 50
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pesanan`
--

CREATE TABLE `pesanan` (
  `id_pesanan` int(11) NOT NULL,
  `kode_pesanan` varchar(30) NOT NULL,
  `id_pelanggan` int(11) DEFAULT NULL,
  `nama_pelanggan` varchar(100) DEFAULT NULL,
  `id_kasir` int(11) DEFAULT NULL,
  `id_meja` int(11) DEFAULT NULL,
  `sumber_pesanan` enum('qr','manual') NOT NULL DEFAULT 'qr',
  `jenis_pesanan` enum('dine_in','take_away') NOT NULL DEFAULT 'dine_in',
  `catatan` text DEFAULT NULL,
  `subtotal` decimal(12,2) NOT NULL DEFAULT 0.00,
  `coin_dipakai` int(11) NOT NULL DEFAULT 0,
  `potongan_coin` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total_bayar` decimal(12,2) NOT NULL DEFAULT 0.00,
  `coin_didapat` int(11) NOT NULL DEFAULT 0,
  `status_pesanan` enum('menunggu','dikonfirmasi','diproses','selesai','ditolak') NOT NULL DEFAULT 'menunggu',
  `alasan_tolak` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `riwayat_coin`
--

CREATE TABLE `riwayat_coin` (
  `id_coin` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `id_pesanan` int(11) DEFAULT NULL,
  `jenis` enum('masuk','keluar','penyesuaian') NOT NULL,
  `jumlah` int(11) NOT NULL,
  `keterangan` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id_user` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `no_hp` varchar(20) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','kasir','pelanggan') NOT NULL DEFAULT 'pelanggan',
  `saldo_coin` int(11) NOT NULL DEFAULT 0,
  `status` enum('aktif','nonaktif') NOT NULL DEFAULT 'aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `varian_menu`
--

CREATE TABLE `varian_menu` (
  `id_varian` int(11) NOT NULL,
  `id_menu` int(11) NOT NULL,
  `nama_varian` varchar(50) NOT NULL,
  `tambahan_harga` decimal(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `detail_pesanan`
--
ALTER TABLE `detail_pesanan`
  ADD PRIMARY KEY (`id_detail`),
  ADD KEY `fk_detail_pesanan` (`id_pesanan`),
  ADD KEY `fk_detail_menu` (`id_menu`),
  ADD KEY `fk_detail_varian` (`id_varian`);

--
-- Indexes for table `jam_operasional`
--
ALTER TABLE `jam_operasional`
  ADD PRIMARY KEY (`id_jam`),
  ADD UNIQUE KEY `hari` (`hari`);

--
-- Indexes for table `kategori_menu`
--
ALTER TABLE `kategori_menu`
  ADD PRIMARY KEY (`id_kategori`),
  ADD UNIQUE KEY `nama_kategori` (`nama_kategori`);

--
-- Indexes for table `meja`
--
ALTER TABLE `meja`
  ADD PRIMARY KEY (`id_meja`),
  ADD UNIQUE KEY `nomor_meja` (`nomor_meja`),
  ADD UNIQUE KEY `kode_qr` (`kode_qr`);

--
-- Indexes for table `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`id_menu`),
  ADD KEY `fk_menu_kategori` (`id_kategori`);

--
-- Indexes for table `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD PRIMARY KEY (`id_pembayaran`),
  ADD UNIQUE KEY `id_pesanan` (`id_pesanan`);

--
-- Indexes for table `pengaturan_coin`
--
ALTER TABLE `pengaturan_coin`
  ADD PRIMARY KEY (`id_pengaturan`);

--
-- Indexes for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD PRIMARY KEY (`id_pesanan`),
  ADD UNIQUE KEY `kode_pesanan` (`kode_pesanan`),
  ADD KEY `fk_pesanan_kasir` (`id_kasir`),
  ADD KEY `fk_pesanan_meja` (`id_meja`),
  ADD KEY `idx_pesanan_tanggal` (`created_at`),
  ADD KEY `idx_pesanan_status` (`status_pesanan`),
  ADD KEY `idx_pesanan_pelanggan` (`id_pelanggan`);

--
-- Indexes for table `riwayat_coin`
--
ALTER TABLE `riwayat_coin`
  ADD PRIMARY KEY (`id_coin`),
  ADD KEY `fk_coin_user` (`id_user`),
  ADD KEY `fk_coin_pesanan` (`id_pesanan`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id_user`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `varian_menu`
--
ALTER TABLE `varian_menu`
  ADD PRIMARY KEY (`id_varian`),
  ADD KEY `fk_varian_menu` (`id_menu`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `detail_pesanan`
--
ALTER TABLE `detail_pesanan`
  MODIFY `id_detail` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jam_operasional`
--
ALTER TABLE `jam_operasional`
  MODIFY `id_jam` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `kategori_menu`
--
ALTER TABLE `kategori_menu`
  MODIFY `id_kategori` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `meja`
--
ALTER TABLE `meja`
  MODIFY `id_meja` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `menu`
--
ALTER TABLE `menu`
  MODIFY `id_menu` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pembayaran`
--
ALTER TABLE `pembayaran`
  MODIFY `id_pembayaran` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pengaturan_coin`
--
ALTER TABLE `pengaturan_coin`
  MODIFY `id_pengaturan` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pesanan`
--
ALTER TABLE `pesanan`
  MODIFY `id_pesanan` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `riwayat_coin`
--
ALTER TABLE `riwayat_coin`
  MODIFY `id_coin` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id_user` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `varian_menu`
--
ALTER TABLE `varian_menu`
  MODIFY `id_varian` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `detail_pesanan`
--
ALTER TABLE `detail_pesanan`
  ADD CONSTRAINT `fk_detail_menu` FOREIGN KEY (`id_menu`) REFERENCES `menu` (`id_menu`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_pesanan` FOREIGN KEY (`id_pesanan`) REFERENCES `pesanan` (`id_pesanan`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_varian` FOREIGN KEY (`id_varian`) REFERENCES `varian_menu` (`id_varian`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `menu`
--
ALTER TABLE `menu`
  ADD CONSTRAINT `fk_menu_kategori` FOREIGN KEY (`id_kategori`) REFERENCES `kategori_menu` (`id_kategori`) ON UPDATE CASCADE;

--
-- Constraints for table `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD CONSTRAINT `fk_bayar_pesanan` FOREIGN KEY (`id_pesanan`) REFERENCES `pesanan` (`id_pesanan`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD CONSTRAINT `fk_pesanan_kasir` FOREIGN KEY (`id_kasir`) REFERENCES `users` (`id_user`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pesanan_meja` FOREIGN KEY (`id_meja`) REFERENCES `meja` (`id_meja`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pesanan_pelanggan` FOREIGN KEY (`id_pelanggan`) REFERENCES `users` (`id_user`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `riwayat_coin`
--
ALTER TABLE `riwayat_coin`
  ADD CONSTRAINT `fk_coin_pesanan` FOREIGN KEY (`id_pesanan`) REFERENCES `pesanan` (`id_pesanan`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_coin_user` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `varian_menu`
--
ALTER TABLE `varian_menu`
  ADD CONSTRAINT `fk_varian_menu` FOREIGN KEY (`id_menu`) REFERENCES `menu` (`id_menu`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
