import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb, TargetPlatform, defaultTargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError('Belum dikonfigurasi untuk platform ini.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAHrhKKE2EW36JLgmMTePrXAJd9kdF3rXA',
    appId: '1:4953187423:web:74e2cff4aadbe5fe4ba7ea',
    messagingSenderId: '4953187423',
    projectId: 'pengajuan-9ed91',
    authDomain: 'pengajuan-9ed91.firebaseapp.com',
    storageBucket: 'pengajuan-9ed91.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAHrhKKE2EW36JLgmMTePrXAJd9kdF3rXA',
    appId: '1:4953187423:web:74e2cff4aadbe5fe4ba7ea',
    messagingSenderId: '4953187423',
    projectId: 'pengajuan-9ed91',
    storageBucket: 'pengajuan-9ed91.firebasestorage.app',
  );
}
