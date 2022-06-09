import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final Reference _storage = FirebaseStorage.instance.ref();
  String? resimId;
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  Future<String> profilResmiYukle(File resimDosyasi) async {
    resimId = const Uuid().v4();
    UploadTask yuklemeYoneticisi = _storage
        .child(
            "resimler/profil/${_currentUser!.displayName}/profil_$resimId.jpg")
        .putFile(resimDosyasi);
    TaskSnapshot snapshot = await yuklemeYoneticisi;
    String yuklenenResimUrl = await snapshot.ref.getDownloadURL();
    return yuklenenResimUrl;
  }
}
