import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wapp/firebase_options.dart';
import 'package:wapp/sign_up.dart';
import 'package:wapp/weather.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _checkUserLoginStatus();
  }

  Future<void> _checkUserLoginStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const WeatherPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FirebaseAuth auth;
  late TextEditingController epostaController;
  late TextEditingController sifreController;

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    epostaController = TextEditingController();
    sifreController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery ile ekran boyutlarını al
    final size = MediaQuery.of(context).size;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05)
            .copyWith(top: size.height * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Coredinat",
              style: TextStyle(
                fontSize: 50,
                fontStyle: FontStyle.italic,
              ),
            ),
            Padding(
              // E-posta giriş
              padding: EdgeInsets.only(top: size.height * 0.06),
              child: textFieldEmail("Telefon, kullanıcı adı  veya eposta",
                  const Icon(Icons.person), epostaController, false),
            ),
            Padding(
              // Şifre TextBox
              padding: EdgeInsets.only(top: size.height * 0.02),
              child: textFieldEmail(
                  "Şifre", const Icon(Icons.key), sifreController, true),
            ),
            Padding(
              // Şifremi unuttum
              padding: EdgeInsets.only(
                  right: size.width * 0.05, top: size.height * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text("Şifreni mi Unuttun"),
                  )
                ],
              ),
            ),
            SizedBox(
              // Giriş Yap Button
              width: size.width * 0.9,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await auth.signInWithEmailAndPassword(
                      email: epostaController.text,
                      password: sifreController.text,
                    );
                    showErrorSnackBar(context, "Giriş Başarılı");
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (contexta) => const WeatherPage()));
                  } on FirebaseAuthException catch (e) {
                    String errorMessage;
                    switch (e.code) {
                      case 'user-not-found':
                        errorMessage =
                            'Girilen e-posta adresine ait bir kullanıcı bulunamadı.';
                        break;
                      case 'wrong-password':
                        errorMessage = 'Girilen şifre yanlış.';
                        break;
                      case 'invalid-email':
                        errorMessage = 'Girilen e-posta adresi geçersiz.';
                        break;
                      case 'user-disabled':
                        errorMessage = 'Bu hesap devre dışı bırakılmış.';
                        break;
                      default:
                        errorMessage = 'Giriş başarısız';
                        break;
                    }
                    showErrorSnackBar(context, errorMessage);
                  }
                },
                child: const Text("Giriş Yap"),
              ),
            ),
            Padding(
              // Ya da and Divider
              padding: EdgeInsets.only(top: size.height * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(left: size.width * 0.05),
                      child: const Divider(color: Colors.black),
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: Center(child: Text(" Ya Da ")),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(right: size.width * 0.05),
                      child: const Divider(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              // Hesabım Yok? Kaydol
              padding: EdgeInsets.only(top: size.height * 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Hesabın mı yok?"),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (contexta) => const SignUpPage()));
                    },
                    child: const Text("Kaydol"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textFieldEmail(String title, Icon icon,
      TextEditingController controller, bool ispassword) {
    return Container(
      alignment: Alignment.center,
      child: TextField(
        obscureText: ispassword,
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade100,
          label: Text(title),
          icon: icon,
        ),
      ),
    );
  }

  void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2), // Mesajın ekranda kalma süresi
      ),
    );
  }
}
