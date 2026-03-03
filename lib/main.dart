import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(const NightQRApp());
}

class NightQRApp extends StatelessWidget {
  const NightQRApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Night QR',
      theme: ThemeData(
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.black,
        brightness: Brightness.dark,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const HomePage(),
    );
  }
}

// ================== ГЛАВНАЯ СТРАНИЦА ==================
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Night QR'),
        backgroundColor: Colors.red[800],
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegistrationPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[800],
            minimumSize: const Size(200, 50),
          ),
          child: const Text('Регистрация', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}

// ================== СТРАНИЦА РЕГИСТРАЦИИ ==================
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isOver18 = false;
  File? _idFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickId() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _idFile = File(pickedFile.path);
      });
    }
  }

  void _completeRegistration() {
    if (_isOver18 && _idFile != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ClubsPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Подтвердите возраст и прикрепите удостоверение')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Регистрация'), backgroundColor: Colors.red[800]),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _isOver18,
                    onChanged: (value) {
                      setState(() {
                        _isOver18 = value ?? false;
                      });
                    },
                    activeColor: Colors.red,
                  ),
                  const Expanded(child: Text('Мне есть 18 лет', style: TextStyle(color: Colors.white))),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _pickId,
                icon: const Icon(Icons.upload_file, color: Colors.white),
                label: Text(
                  _idFile == null ? 'Прикрепить удостоверение' : 'Файл выбран',
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[800],
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _completeRegistration,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[900],
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Завершить регистрацию', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================== СТРАНИЦА СПИСКА КЛУБОВ ==================
class ClubsPage extends StatelessWidget {
  const ClubsPage({super.key});

  void _openClubDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ClubDetailPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Клубы'), backgroundColor: Colors.red[800]),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // QR код по центру
            GestureDetector(
              onTap: () {
                // откроет камеру
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('QR Camera opened (simulated)')),
                );
              },
              child: Container(
                height: 200,
                width: 200,
                color: Colors.red[800],
                child: const Center(
                  child: Text('QR', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Карточка клуба
            GestureDetector(
              onTap: () => _openClubDetail(context),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red[900],
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://redtable.kz/upload/club/bhb-astana.jpg',
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('BHB Астана',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('Шоссе Коргалжын, 2а', style: TextStyle(fontSize: 16)),
                          SizedBox(height: 4),
                          Text('Пт–Сб 22:00–05:00', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================== ДЕТАЛЬНАЯ СТРАНИЦА КЛУБА ==================
class ClubDetailPage extends StatelessWidget {
  const ClubDetailPage({super.key});

  final String clubImage = 'https://redtable.kz/upload/club/bhb-astana.jpg';
  final String address = 'Шоссе Коргалжын, 2а, Астана';
  final String hours = 'Пт–Сб 22:00–05:00';
  final String dressCode = 'Стильная одежда, без шорт/сланцев';
  final String deposit = 'Возможен при бронировании столика';
  final String description = 'Содружество баров с танцполом и живой музыкой';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BHB Астана'), backgroundColor: Colors.red[800]),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(clubImage, height: 200, width: double.infinity, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text('Адрес: $address', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Время работы: $hours', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Дресс-код: $dressCode', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Депозит: $deposit', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Описание: $description', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // открыть камеру для QR
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('QR Camera opened (simulated)')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[800],
                  minimumSize: const Size(200, 50),
                ),
                child: const Text('Сканировать QR', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}