import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie_suggestion/auth/model/kullanici.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? aktifKullaniciId;
  String fotoUrl =
      'https://firebasestorage.googleapis.com/v0/b/uludag-online-30c96.appspot.com/o/resimler%2FprofileDefault%2Fdefault_profile.png?alt=media&token=358d18e1-f9aa-448e-b3f6-5112989c5110';

  Kullanici? _kullaniciOlustur(User? kullanici) {
    return kullanici == null ? null : Kullanici.firebasedenUret(kullanici);
  }

  Stream<Kullanici?> get durumTakipcisi {
    return _firebaseAuth.authStateChanges().map(_kullaniciOlustur);
  }

  Future<Kullanici?> mailIleKayit(
      String eposta, String sifre, String adSoyad) async {
    var girisKarti = await _firebaseAuth.createUserWithEmailAndPassword(
        email: eposta, password: sifre);
    await _firebaseAuth.currentUser!.updateDisplayName(adSoyad);
    await _firebaseAuth.currentUser!.updatePhotoURL(fotoUrl);

    return _kullaniciOlustur(girisKarti.user);
  }

  Future<Kullanici?> mailIleGiris(String eposta, String sifre) async {
    var girisKarti = await _firebaseAuth.signInWithEmailAndPassword(
        email: eposta, password: sifre);
    return _kullaniciOlustur(girisKarti.user);
  }

  Future<Kullanici?> googleIleGiris() async {
    GoogleSignInAccount? googleHesabi;
    try {
      googleHesabi = await GoogleSignIn().signIn().catchError((hata) {
        debugPrint("hata: $hata");
      });
    } catch (hata) {
      debugPrint("hata");
      debugPrint(hata.hashCode.toString());
      debugPrint(hata.toString());
    }
    GoogleSignInAuthentication googleYetkiKartim =
        await googleHesabi!.authentication;
    AuthCredential sifresizGirisBelgesi = GoogleAuthProvider.credential(
        idToken: googleYetkiKartim.idToken,
        accessToken: googleYetkiKartim.accessToken);
    UserCredential girisKarti =
        await _firebaseAuth.signInWithCredential(sifresizGirisBelgesi);
    await _firebaseAuth.currentUser!.updatePhotoURL(girisKarti.user!.photoURL);
    await _firebaseAuth.currentUser!
        .updateDisplayName(girisKarti.user!.displayName);

    return _kullaniciOlustur(girisKarti.user);
  }

  Future<void> onayMailiGonder() async {
    await _firebaseAuth.currentUser!.sendEmailVerification();
  }

  Future<void> sifremiSifirla(String eposta) async {
    await _firebaseAuth.sendPasswordResetEmail(email: eposta);
  }

  Future<void> mailiOnayla() async {
    await _firebaseAuth.currentUser!.sendEmailVerification();
  }

  Future<void> cikisYap() {
    return _firebaseAuth.signOut();
  }
}
