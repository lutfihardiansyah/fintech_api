// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, avoid_print, depend_on_referenced_packages

import 'package:fintech_api/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'dart:convert'; // Untuk JSON decoding
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(TopindokuApp());
}

class TopindokuApp extends StatelessWidget {
  const TopindokuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

// Navbar
class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;

  @override
  void initState() {
    super.initState();
    _handleSignIn();
  }

  Future<void> _handleSignIn() async {
    try {
      final user = await _googleSignIn.signIn();
      setState(() {
        _user = user;
      });
    } catch (error) {
      print('Error signing in: $error');
    }
  }

  Future<void> _handleSignOut() async {
    try {
      await _googleSignIn.signOut(); // Logout pengguna
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MyApp(), // Halaman login setelah logout
        ),
      );
    } catch (error) {
      print('Error signing out: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeContent(), // Halaman Beranda
      ProfilePage(user: _user, onLogout: _handleSignOut), // Halaman Profil
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Topindoku',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Home
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  Future<List<Map<String, dynamic>>> fetchPromotions() async {
    final url = Uri.parse('https://fakestoreapi.com/products');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((product) {
        return {
          'title': product['title'] ?? 'No Title',
          'image': product['image'] ?? 'https://via.placeholder.com/150',
          'price': product['price'] ?? 0,
          'description': product['description'] ?? 'No Description',
        };
      }).toList();
    } else {
      throw Exception('Failed to load promotions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saldo',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Rp 5.000',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Card Isi Saldo
                      GestureDetector(
                        onTap: () {
                          // Aksi ketika "Isi Saldo" ditekan
                          print("Isi Saldo Ditekan");
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.account_balance_wallet,
                                  size: 32,
                                  color: Colors.green,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Isi Saldo",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 12), // Jarak antar Card

                      // Card Kirim Uang
                      GestureDetector(
                        onTap: () {
                          // Aksi ketika "Kirim" ditekan
                          print("Kirim Ditekan");
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Icon(Icons.send, size: 32, color: Colors.green),
                                SizedBox(height: 8),
                                Text(
                                  "Kirim",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
            children: [
              _menuItem(Icons.flash_on, 'PLN Token'),
              _menuItem(Icons.water_damage, 'PDAM'),
              _menuItem(
                Icons.phone_iphone,
                'Pulsa',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PulsaPage()),
                  );
                },
                color: Colors.blue,
              ),
              _menuItem(Icons.data_usage, 'Paket Data'),
              _menuItem(Icons.credit_card, 'E-Money'),
              _menuItem(Icons.gamepad, 'G-Voucher'),
              _menuItem(Icons.movie, 'Netflix'),
              _menuItem(Icons.more_horiz, 'More'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Today's Promotions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 200,
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchPromotions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text(
                        'Failed to load promotions or no internet connection!'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No promotions available'));
              } else {
                final promotions = snapshot.data!;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: promotions.length,
                  itemBuilder: (context, index) {
                    final promo = promotions[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailPage(product: promo),
                          ),
                        );
                      },
                      child: Container(
                        width: 150,
                        margin: EdgeInsets.all(2),
                        child: Card(
                          child: Column(
                            children: [
                              Image.network(
                                promo['image'],
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  promo['title'],
                                  style: TextStyle(fontSize: 14),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                'Rp ${promo['price']}',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _menuItem(IconData icon, String label,
      {VoidCallback? onTap, Color? color}) {
    return GestureDetector(
      onTap: onTap, // Tambahkan onTap di sini
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              color: color ?? Colors.green, size: 30), // Warna default: Biru
          SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// Product detail
class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product['title'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                product['image'],
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Text(
              product['title'],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Rp ${product['price']}',
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
            SizedBox(height: 16),
            Text(
              product['description'] ?? "No description available",
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Berhasil ditambahkan ke keranjang!")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                "Beli Sekarang !",
                style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Pulsa
class PulsaPage extends StatefulWidget {
  const PulsaPage({super.key});

  @override
  _PulsaPageState createState() => _PulsaPageState();
}

class _PulsaPageState extends State<PulsaPage> {
  final TextEditingController _phoneController = TextEditingController();
  List<Map<String, dynamic>> pulsaList = [];
  bool isLoading = false;

  // Simulasi Fetch Paket Pulsa
  Future<void> fetchPulsaPackages() async {
    if (_phoneController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Masukkan nomor yang valid')),
      );
      return;
    }

    setState(() => isLoading = true);

    final url = Uri.parse('https://fakestoreapi.com/products'); // Simulasi API
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      setState(() {
        pulsaList = data
            .take(5)
            .map((item) => {
                  'name': item['title'],
                  'price': item['price'],
                })
            .toList();
      });
    } else {
      setState(() {
        pulsaList = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat paket pulsa')),
      );
    }

    setState(() => isLoading = false);
  }

  void showPaymentConfirmation(
      BuildContext context, String phone, String package, double price) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.5, // Setengah layar
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text("Konfirmasi Pembayaran",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.phone_android, color: Colors.green, size: 40),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(phone,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          SizedBox(height: 4),
                          Text(
                            "Paket: $package",
                            style: TextStyle(color: Colors.grey[600]),
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(thickness: 1, height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Pembayaran:", style: TextStyle(fontSize: 16)),
                    Text("Rp $price",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup overlay pertama
                    showPaymentSuccess(context, phone, package, price);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text("Bayar Sekarang",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showPaymentSuccess(
      BuildContext context, String phone, String package, double price) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.all(20),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 80),
                SizedBox(height: 10),
                Text("Pembayaran Berhasil!",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text("Pulsa telah berhasil dibeli.",
                    textAlign: TextAlign.center),
                Divider(height: 30, thickness: 1),
                infoRow("Nomor HP:", phone),
                infoRow("Paket:", package),
                infoRow("Harga:", "Rp $price", isPrice: true),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => HomePage()), // Balik ke home
                      (Route<dynamic> route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text("Kembali ke Home",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// Fungsi bantu untuk menampilkan info row yang rapi
  Widget infoRow(String title, String value, {bool isPrice = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[600])),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isPrice ? Colors.green : Colors.black,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Beli Pulsa')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input Nomor HP
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Masukkan Nomor HP',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            SizedBox(height: 12),

            // Tombol Cek Paket Pulsa
            ElevatedButton(
              onPressed: fetchPulsaPackages,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text(
                'Cek Paket Pulsa',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),

            // Loader saat loading data
            if (isLoading) CircularProgressIndicator(),

            // List Paket Pulsa
            if (pulsaList.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: pulsaList.length,
                  itemBuilder: (context, index) {
                    final pulsa = pulsaList[index];
                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.attach_money, color: Colors.green),
                        title: Text(pulsa['name']),
                        subtitle: Text('Harga: Rp ${pulsa['price']}'),
                        onTap: () {
                          showPaymentConfirmation(
                            context,
                            _phoneController
                                .text, // Nomor HP yang dimasukkan user
                            pulsa['name'], // Nama paket pulsa
                            double.parse(pulsa['price']
                                .toString()), // Harga pulsa (pastikan jadi double)
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Profile page
class ProfilePage extends StatelessWidget {
  final GoogleSignInAccount? user;

  final VoidCallback onLogout; // Tambahkan parameter fungsi logout

  const ProfilePage({super.key, required this.user, required this.onLogout});

  // ProfilePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.green,
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(user?.photoUrl ??
                    'https://via.placeholder.com/150'), // Foto pengguna
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.displayName ?? 'User Name', // Nama pengguna
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    user?.email ?? 'useremail@gmail.com', // Email pengguna
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Konfirmasi Logout"),
                    content: Text("Apakah Anda yakin ingin logout?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Tutup dialog
                        },
                        child: Text("Batal"),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop(); // Tutup dialog
                          await FirebaseAuth.instance.signOut(); // Logout
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child:
                            Text("Logout", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: Size(double.infinity, 50),
            ),
            child: Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
