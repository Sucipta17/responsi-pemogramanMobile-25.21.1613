CARA PAKAI
1. flutter create responsi_profil_mahasiswa
2. Salin folder lib/ (timpa), file .env, .gitignore ke root proyek.
3. Gabungkan isi pubspec_tambahan.yaml ke pubspec.yaml, lalu: flutter pub get
4. Android:
   - android/app/src/main/AndroidManifest.xml:
       <uses-permission android:name="android.permission.INTERNET"/>
       dan pada <application ...> tambahkan android:allowBackup="false"
   - android/app/build.gradle(.kts): minSdk = 23 (wajib untuk flutter_secure_storage)
5. flutter run
