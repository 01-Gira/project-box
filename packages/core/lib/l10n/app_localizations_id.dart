// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get finishedProjects => 'Proyek Selesai';

  @override
  String get productiveDay => 'Hari Produktif';

  @override
  String get finishedTasks => 'Tugas Selesai';

  @override
  String get recentProjects => 'Proyek Terakhir';

  @override
  String get seeAll => 'Lihat Semua';

  @override
  String get nextTask => 'Tugas Berikutnya';

  @override
  String get ad => 'Iklan';

  @override
  String get goodMorning => 'Selamat Pagi,';

  @override
  String get goodAfternoon => 'Selamat Siang,';

  @override
  String get goodEvening => 'Selamat Sore,';

  @override
  String get goodNight => 'Selamat Malam,';

  @override
  String get homeTagline => 'Mari Berkarya!';

  @override
  String failedToLoadProjects(String error) {
    return 'Gagal memuat proyek: $error';
  }

  @override
  String fromProject(String projectName) {
    return 'dari: $projectName';
  }

  @override
  String get task => 'Tugas';

  @override
  String get log => 'Log';

  @override
  String get info => 'Info';

  @override
  String get createProjectTitle => 'Buat Proyek Baru';

  @override
  String get createProjectHeadline => 'Mulai Sesuatu yang Hebat';

  @override
  String get addCoverImage => 'Tambah Gambar Sampul';

  @override
  String failedToPickImage(String error) {
    return 'Gagal memilih gambar: $error';
  }

  @override
  String get projectNameLabel => 'Nama Proyek*';

  @override
  String get projectNameHint => 'Contoh: Rak Buku Jati Belanda';

  @override
  String get projectNameValidationError => 'Nama proyek tidak boleh kosong';

  @override
  String get projectDescriptionLabel => 'Deskripsi (Opsional)';

  @override
  String get projectDescriptionHint =>
      'Jelaskan sedikit tentang proyek Anda...';

  @override
  String get projectStatusLabel => 'Status Proyek';

  @override
  String get completionDateLabel => 'Tanggal Selesai (Opsional)';

  @override
  String get completionDateHint => 'Pilih Tanggal';

  @override
  String get saveProjectButton => 'Simpan Proyek';

  @override
  String get projectSavedSuccess => 'Proyek berhasil disimpan!';

  @override
  String get allProject => 'Semua Proyek';

  @override
  String get deleteProject => 'Hapus Proyek';

  @override
  String get projectDeleteConfirmation =>
      'Apakah anda yakin ingin menghapus proyek ini?';

  @override
  String get projectDeletedSuccess => 'Proyek berhasil dihapus!';

  @override
  String get dataDeletedSuccess => 'Data berhasil dihapus!';

  @override
  String get dataUpdatedSuccess => 'Data berhasil diubah!';

  @override
  String get search => 'Cari';

  @override
  String get projectNotFound => 'Proyek tidak ditemukan!';

  @override
  String get projectDescription => 'Deskripsi Proyek';

  @override
  String get createdDate => 'Tanggal Dibuat';

  @override
  String get editProject => 'Edit Proyek';

  @override
  String get taskTitleLabel => 'Judul Tugas';

  @override
  String get addTask => 'Tambah Tugas';

  @override
  String get taskAddedSuccess => 'Tugas berhasil ditambahkan!';

  @override
  String get emptyTask => 'Belum ada tugas untuk proyek ini';

  @override
  String get choosePicture => 'Pilih Gambar';

  @override
  String get changePicture => 'Ganti Gambar';

  @override
  String get logNoteLabel => 'Catatan (Opsional)';

  @override
  String get addLog => 'Tambah Log';

  @override
  String get emptyLog => 'Belum ada log untuk proyek ini';

  @override
  String get logAddedSuccess => 'Log berhasil ditambahkan!';

  @override
  String get tryAgain => 'Coba Lagi';

  @override
  String get somethingWentWrong => 'Ada Sesuatu Yang Salah!';

  @override
  String get save => 'Simpan';

  @override
  String get edit => 'Ubah';

  @override
  String get cancel => 'Batal';

  @override
  String get delete => 'Delete';

  @override
  String get confirmDelete => 'Konfirmasi Hapus';

  @override
  String get confirmationDelete => 'Apakah anda yakin ingin menghapus ini?';

  @override
  String get changeStatus => 'Ubah Status';
}
