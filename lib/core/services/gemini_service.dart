import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GeminiService {
  late final String _apiKey;
  GenerativeModel? _model;

  GeminiService() {
    _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  }

  // ── STEP 1: Cari nama model yang valid dulu ──────────────
  // Panggil method ini SEKALI dari controller untuk cek
  // model apa saja yang tersedia di akun kamu
  Future<void> listAvailableModels() async {
    try {
      print('=== LIST MODELS ===');
      final response = await http.get(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models?key=$_apiKey',
        ),
      );
      final data = jsonDecode(response.body);
      final models = data['models'] as List;
      for (final m in models) {
        // Cetak nama model dan method yang didukung
        final name = m['name'];
        final methods = m['supportedGenerationMethods'];
        print('MODEL: $name | methods: $methods');
      }
      print('=== END LIST ===');
    } catch (e) {
      print('Error list models: $e');
    }
  }

  // ── STEP 2: Inisialisasi model setelah tahu nama yang benar ──
  void initModel(String modelName) {
    _model = GenerativeModel(model: modelName, apiKey: _apiKey);
    print('Model diinisialisasi: $modelName');
  }

  // ── STEP 3: Scan struk ───────────────────────────────────
  Future<Map<String, dynamic>> scanStruk(File imageFile) async {
    // Kalau model belum diinisialisasi, pakai default dulu
    _model ??= GenerativeModel(model: 'gemini-2.5-flash', apiKey: _apiKey);
    try {
      final imageBytes = await imageFile.readAsBytes();
      final imagePart = DataPart('image/jpeg', imageBytes);

   final prompt = TextPart('''
Kamu adalah sistem OCR untuk struk belanja Indonesia.
Baca struk ini dan ekstrak semua informasi.

Balas HANYA dengan JSON ini, tanpa teks lain:
{
  "total": 39241,
  "toko": "Nama Toko",
  "tanggal": "23/12/2025",
  "kategori": "Shopping",
  "notes": "Snack, Wafer, Sprite, Mie instan"
}

Aturan:
- total: angka bulat tanpa titik/koma, jika tidak ada isi 0
- toko: nama toko di struk, jika tidak ada isi ""
- tanggal: format DD/MM/YYYY, jika tidak ada isi ""
- kategori: pilih SATU dari: Food, Transport, Shopping, Health, Entertaint, Transfer, Bill, Other
- notes: semua nama barang yang dibeli dipisah koma, jika tidak ada isi ""
''');

      final response = await _model!.generateContent([
        Content.multi([imagePart, prompt]),
      ]);

      final text = response.text ?? '';
      print('=== JAWABAN GEMINI ===');
      print(text);
      print('=== END ===');

      final cleanJson = text
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      return jsonDecode(cleanJson) as Map<String, dynamic>;
    } catch (e) {
      print('=== ERROR GEMINI ===');
      print(e.toString());
      print('=== END ERROR ===');
      return {'total': 0, 'toko': '', 'tanggal': '', 'error': e.toString()};
    }
  }
}
