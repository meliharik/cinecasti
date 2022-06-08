import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:movie_suggestion/auth/model/kullanici.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DateTime zaman = DateTime.now();
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> kullaniciOlustur(
      {id,
      email,
      adSoyad,
      token,
      fotoUrl =
          "https://firebasestorage.googleapis.com/v0/b/uludag-online-30c96.appspot.com/o/resimler%2FprofileDefault%2Fdefault_profile.png?alt=media&token=358d18e1-f9aa-448e-b3f6-5112989c5110",
      isVerified = "false",
      sifre = 'null'}) async {
    await _firestore.collection("users").doc(id).set({
      "id": id,
      "adSoyad": adSoyad,
      "email": email,
      "sifre": sifre,
      "fotoUrl": fotoUrl,
      "olusturulmaZamani": zaman,
      "isVerified": isVerified,
      "token": token
    });
  }

  Future<Kullanici?> kullaniciGetir(id) async {
    DocumentSnapshot doc = await _firestore.collection("users").doc(id).get();
    if (doc.exists) {
      Kullanici kullanici = Kullanici.dokumandanUret(doc);
      return kullanici;
    }
  }

  void kullaniciGuncelle(
      {String? kullaniciId, String? adSoyad, String fotoUrl = ""}) async {
    _firestore
        .collection("users")
        .doc(kullaniciId)
        .update({"adSoyad": adSoyad, "fotoUrl": fotoUrl});

    await _auth.currentUser!.updatePhotoURL(fotoUrl);
    await _auth.currentUser!.updateDisplayName(adSoyad);
  }

  void kullaniciTokenGuncelle(
      {required String kullaniciId, required String newToken}) async {
    _firestore.collection("users").doc(kullaniciId).update({"token": newToken});
  }

  void sifreGuncelle({String? kullaniciId, String? yeniSifre}) {
    _firestore
        .collection("users")
        .doc(kullaniciId)
        .update({'sifre': yeniSifre});
  }

  void dogrulamaGuncelle({String? kullaniciId, String? dogrulandiMi}) {
    _firestore
        .collection("users")
        .doc(kullaniciId)
        .update({"isVerified": dogrulandiMi});
  }
}
