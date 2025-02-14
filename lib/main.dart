// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'package:fintech_api/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

// splash
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkIfLoggedIn();
  }

  // Cek apakah pengguna sudah login
  void checkIfLoggedIn() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // Jika sudah login, langsung ke halaman Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TopindokuApp()),
        );
      } else {
        // Jika belum login, tampilkan halaman onboarding setelah delay
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OnboardingScreen()),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih
      body: Center(
        child: CircleAvatar(
            radius: 80, // Ukuran lingkaran
            backgroundColor: Colors.green, // Warna lingkaran hijau
            child: Icon(
              Icons.data_exploration_rounded,
              size: 80,
              color: Colors.white,
            )),
      ),
    );
  }
}

// onboarding
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  List<Map<String, String>> onboardingData = [
    {'title': 'Selamat Datang', 'desc': 'Aplikasi terbaik untuk Anda'},
    {'title': 'Fitur Unggulan', 'desc': 'Nikmati berbagai fitur menarik'},
    {'title': 'Mulai Sekarang', 'desc': 'Ayo gunakan aplikasi ini'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: onboardingData.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.data_exploration_rounded,
                        size: 100, color: const Color.fromARGB(255, 0, 0, 0)),
                    SizedBox(height: 20),
                    Text(
                      onboardingData[index]['title']!,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      onboardingData[index]['desc']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              onboardingData.length,
              (index) => Container(
                margin: EdgeInsets.all(4),
                width: _currentIndex == index ? 12 : 8,
                height: _currentIndex == index ? 12 : 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index ? Colors.blue : Colors.grey,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_currentIndex == onboardingData.length - 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              } else {
                _controller.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // Warna tombol hijau
              foregroundColor: Colors.white, // Warna teks putih
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    8), // Supaya agak kotak (tidak terlalu bulat)
              ),
              padding: EdgeInsets.symmetric(
                  vertical: 16, horizontal: 24), // Ukuran padding
            ),
            child: Text(
              _currentIndex == onboardingData.length - 1 ? 'Mulai' : 'Next',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}

// Login
Future<UserCredential?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      print("Login dibatalkan oleh pengguna");
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print("Login sukses: ${userCredential.user?.displayName}");
    return userCredential;
  } catch (e) {
    print("Error saat login: $e");
    return null;
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_circle, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              "Login dengan Google",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                UserCredential? user = await signInWithGoogle();
                if (user != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TopindokuApp()), // Ganti dengan halaman utama setelah login
                  );
                } else {
                  print("Login gagal atau dibatalkan");
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    MaterialCommunityIcons.google, // Icon Google
                    size: 30,
                    // color: Colors.red,
                  ),
                  SizedBox(width: 10),
                  Text("Login dengan Google"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
