import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBEnRI2w3NnplQ_r39gWKRsFG7geb5VAXc',
    appId: '1:738703111241:android:8fe4c3ce477a4dbfeabb98',
    messagingSenderId: '738703111241',
    projectId: 'local-guider-dr',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBEnRI2w3NnplQ_r39gWKRsFG7geb5VAXc',
    appId: '1:738703111241:android:8fe4c3ce477a4dbfeabb98',
    messagingSenderId: '738703111241',
    projectId: 'local-guider-dr',
  );

  static const FirebaseOptions web = FirebaseOptions(
      apiKey: "AIzaSyBF_Kt7JYNhjQPPYebrN-lQOUOlExsMzRs",
      authDomain: "local-guider-dr.firebaseapp.com",
      projectId: "local-guider-dr",
      storageBucket: "local-guider-dr.appspot.com",
      messagingSenderId: "738703111241",
      appId: "1:738703111241:web:6d49e4b9e28b4c00eabb98",
      measurementId: "G-J0VYW49977"
  );


}
