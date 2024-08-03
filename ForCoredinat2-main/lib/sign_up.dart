import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:wapp/main.dart";

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white24,
        elevation: 0,
      ),
      body: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late TextEditingController epostaController;
  late TextEditingController adiController;
  late TextEditingController klncadiController;
  late TextEditingController sifreController;
  late bool checkBoxState;
  late FirebaseAuth auth;
  @override
  void initState() {
    super.initState();
    epostaController = TextEditingController();
    adiController = TextEditingController();
    klncadiController = TextEditingController();
    sifreController = TextEditingController();
    debugPrint("ChechBox state trued atandı");
    checkBoxState = true;
    auth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            //Instagram yazisi
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              "Coredinat",
              style: TextStyle(
                fontSize: 50,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          textFieldCreate(
              "Telefon numarası veya eposta", epostaController, false), //Eposta
          textFieldCreate("Adı Soyadı", adiController, false), //Ad Soyad
          textFieldCreate(
              "Kullanıcı Adı", klncadiController, false), //Kullanici Adi
          textFieldCreate("Sifre", sifreController, true), //Sifre
          Row(
            //CheckBox  ve "Sözleşmeyi kabul ediyorum"
            children: [
              //CheckBox (Okudum onaylıyorum)
              Checkbox(
                value: checkBoxState,
                onChanged: (value) {
                  setState(() {
                    checkBoxState = value!;
                  });
                },
              ),
              const Text("Sözleşmeyi kabul ediyorum"),
            ],
          ),
          buttonCreate(context, "Kayıt Ol"), //kayit ol button func
          TextButton(
              onPressed: () {
                //Zaten hesabım var
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context2) => const MyApp()));
              },
              child: const Text("Zaten hesabım var"))
        ],
      ),
    );
  }

  Container buttonCreate(BuildContext context, String title) {
    return Container(
      width: MediaQuery.of(context).size.width - 45,
      child: ElevatedButton(
        onPressed: () async {
          final String email = epostaController.text;
          final String sifre = sifreController.text;
          String errorMessage = "";
          try {
            var userCredential = await auth.createUserWithEmailAndPassword(
              email: email,
              password: sifre,
            );

            // E-posta doğrulaması için:
            await userCredential.user?.sendEmailVerification();

            debugPrint(userCredential.toString());
            showErrorSnackBar(context,
                'Kullanıcı başarıyla oluşturuldu. E-posta doğrulaması gönderildi.');
            Navigator.of(context).pop();
          } catch (e) {
            if (e is FirebaseAuthException) {
              if (e.code == 'email-already-in-use') {
                errorMessage = 'Bu e-posta adresi zaten kullanılıyor.';
              } else if (e.code == 'weak-password') {
                errorMessage =
                    'Şifreniz çok zayıf. Daha güçlü bir şifre kullanın.';
              } else if (e.code == 'invalid-email') {
                errorMessage = 'Geçersiz e-posta adresi.';
              } else {
                errorMessage = 'Bir hata oluştu: ${e.message}';
              }
            } else {
              errorMessage = 'Bir hata oluştu: ${e.toString()}';
            }
            showErrorSnackBar(context, errorMessage);
          }
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: Text(title),
      ),
    );
  }

  Widget textFieldCreate(
      String title, TextEditingController controller, bool ispassword) {
    //TextField oluşturma
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TextField(
        obscureText: ispassword,
        controller: controller,
        decoration: InputDecoration(
            filled: true, fillColor: Colors.grey.shade100, label: Text(title)),
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
