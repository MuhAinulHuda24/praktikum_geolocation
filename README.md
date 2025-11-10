# praktikum_geolocation

saya telah mencobanya berkali kali hingga pada saat jam telah mepet saya masih tidak bisa membukanya lewat emulator saya, saya telah mencari soslusi ke AI dan mash tetap saja tidak bisa dengan keterangan error seperti ini :
 flutter run
Launching lib\main.dart on 23053RN02A in debug mode...

FAILURE: Build failed with an exception.

* Where:
Settings file 'D:\Mobile Dev\praktikum_geolocation\android\settings.gradle.kts' line: 20

* What went wrong:
Error resolving plugin [id: 'dev.flutter.flutter-plugin-loader', version: '1.0.0']
> A problem occurred configuring project ':gradle'.
   > Multiple build operations failed.
         Could not read workspace metadata from C:\Users\hp\.gradle\caches\8.12\transforms\de21c199aa80b9ecdde0e8d25653142c\metadata.bin
         Could not read workspace metadata from C:\Users\hp\.gradle\caches\8.12\transforms\867b0c9b1b844642cb0abbc22a1bc755\metadata.bin
         Could not read workspace metadata from C:\Users\hp\.gradle\caches\8.12\transforms\57f7cd823f335e5a07ba8760cf3fe105\metadata.bin
         Could not read workspace metadata from C:\Users\hp\.gradle\caches\8.12\transforms\575fcb8c5618c4ac9630ca8116076520\metadata.bin
         Could not read workspace metadata from C:\Users\hp\.gradle\caches\8.12\transforms\7edd50f96fbc571575219e03a93cba43\metadata.bin
         Could not read workspace metadata from C:\Users\hp\.gradle\caches\8.12\transforms\6132ff50e849b4328d7c81fa98b027d9\metadata.bin
         Could not read workspace metadata from C:\Users\hp\.gradle\caches\8.12\transforms\6e3ef1e9b5601aad3137bf6ac019d12a\metadata.bin
         Could not read workspace metadata from C:\Users\hp\.gradle\caches\8.12\transforms\cb0ed2cc9b7d760feeceebe504bedab6\metadata.bin
         Could not read workspace metadata from C:\Users\hp\.gradle\caches\8.12\transforms\bbc1909cd45f9382876520af324dd2df\metadata.bin
         Could not read workspace metadata from C:\Users\hp\.gradle\caches\8.12\transforms\b5964c4626a6ac2924bf9c9a9100adf4\metadata.bin
         ...and 2 more failures.
      > Could not read workspace metadata from C:\Users\hp\.gradle\caches\8.12\transforms\de21c199aa80b9ecdde0e8d25653142c\metadata.bin
      > Could not read workspace metadata from C:\Users\hp\.gradle\caches\8.12\transforms\867b0c9b1b844642cb0abbc22a1bc755\metadata.bin
      > Could not read workspace metadata from C:\Users\hp\.gradle\caches\8.12\transforms\57f7cd823f335e5a07ba8760cf3fe105\metadata.bin
      > Could not read workspace metadata from C:\Users\hp\.gradle\caches\8.12\transforms\575fcb8c5618c4ac9630ca8116076520\metadata.bin
      > Could not read workspace metadata from C:\Users\hp\.gradle\caches\8.12\transforms\7edd50f96fbc571575219e03a93cba43\metadata.bin
      > Could not read workspace metadata from C:\Users\hp\.gradle\caches\8.12\transforms\6132ff50e849b4328d7c81fa98b027d9\metadata.bin
      > Could not read workspace metadata from C:\Users\hp\.gradle\caches\8.12\transforms\6e3ef1e9b5601aad3137bf6ac019d12a\metadata.bin
      > Could not read workspace metadata from C:\Users\hp\.gradle\caches\8.12\transforms\cb0ed2cc9b7d760feeceebe504bedab6\metadata.bin
      > Could not read workspace metadata from C:\Users\hp\.gradle\caches\8.12\transforms\bbc1909cd45f9382876520af324dd2df\metadata.bin
      > Could not read workspace metadata from C:\Users\hp\.gradle\caches\8.12\transforms\b5964c4626a6ac2924bf9c9a9100adf4\metadata.bin
      > Could not read workspace metadata from C:\Users\hp\.gradle\caches\8.12\transforms\e22ac01f360a2f4982af98a193cdd390\metadata.bin
      > Could not read workspace metadata from C:\Users\hp\.gradle\caches\8.12\transforms\7190ed9035c2dee883e4569d6a79d6a7\metadata.bin

* Try:
> Run with --stacktrace option to get the stack trace.
> Run with --info or --debug option to get more log output.
> Run with --scan to get full insights.
> Get more help at https://help.gradle.org.

BUILD FAILED in 2m 12s
Running Gradle task 'assembleDebug'...                            132,6s
Error: Gradle task assembleDebug failed with exit code 1

# di jam 21.41 saya mencoba push tetapi sangat lama ( lemot ) 
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/f2b72bad-64dd-4b76-86a5-2c937ef49752" />

dijam 23.00 alhamdulliah setelah meghadpi error yang yang terjadi, akhirnya emulator saya bisa muncul dan hasilnya seperti ini 
![geocoding](https://github.com/user-attachments/assets/e5aa537a-734d-405c-b042-60d73820dad5)

## saya meminta maaf kepada bapak dosen , karena mengeclound setelah tenggat jam yang telah dilakukan, tetapi disini saya hanya ingin berusaha agar bisa dibuka di emulator saya 
adapun ketentuan ketentuan yang ada di tugas 1 inysallah telah saya selesaikan yaitu dengan 
1. sudah menambahkan paket geocoding di pubspec.yaml.
2. Import paketnya: import ’package:geocoding/geocoding.dart’;
3. Buat variabel String? currentAddress; di MyHomePageState.
4. Buat fungsi baru getAddressFromLatLng(Position position).
5.  Panggil fungsi getAddressFromLatLng( currentPosition!) di dalam getLocation
dan startTracking (di dalam .listen()) setelah setState untuk currentPosition.
6. Tampilkan currentAddress di UI Anda, di bawah Lat/Lng.




