import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'AIzaSyC7Kn9V9sjssfnq0ftiaBLIalLXyBpvEWU',
      appId: '1:972068784993:android:d3265cdfc8ac8ebbea5320',
      messagingSenderId: '972068784993',
      projectId: 'cravesave-885eb',
      storageBucket: 'cravesave-885eb.firebasestorage.app',
    );
  }
}