import 'package:get/get.dart';

class MyTranslate extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    // ── English ───────────────────────────────────────────────────
    'en_US': {
      // General
      'language': 'Language',
      'cancel': 'Cancel',
      'done': 'Done',
      'back': 'Back',
      'failed': 'Failed',
      'success': 'Success',
      'try_again': 'Try Again',
      'error': 'Error',
      'yes': 'Yes',

      // No connection
      'no_connection': 'No Connection Internet',
      'check_connection': 'Check your internet connection and try again.',

      // Bottom Navbar
      'home_label': 'Home',
      'profile_label': 'Profile',

      // Quick Actions
      'analytics': 'Analytics',
      'history': 'History',
      'split_bill': 'Scan Bill',

      // Content widgets
      'all_set': 'All set!',
      'add_to': 'Add',
      'to_your': 'to your',

      // Profile
      'profile': 'Profile',
      'theme': 'Theme',
      'logout': 'Logout',
      'edit_profile': 'Edit Profile',
      'logout_confirm': 'Are you sure want to logout?',
      'yes_logout': 'Yes, Logout',
      'dark_mode': 'Dark Mode',
      'light_mode': 'Light Mode',

      // Login
      'welcome': 'Welcome !',
      'login_subtitle': 'Here you log in securely',
      'enter_email': 'Enter email',
      'password': 'Password',
      'forgot_password': 'Forgot password?',
      'log_in': 'Log in',
      'sign_in_with': 'Sign in with',
      'no_account': "Don't have an account? ",
      'sign_in': 'Sign in',

      // Login snackbar
      'verify_email': 'Please verify your email check your inbox / spam',
      'login_failed': 'Login failed',
      'google_login_failed': 'Google login failed',

      // Register
      'hello_budies': 'Hello, budies!',
      'regis_subtitle': "Please sign up if you don't have an account",
      'full_name': 'Full Name',
      'email': 'Email',
      'confirm_password': 'Confirm Password',
      'sign_up': 'Sign up',
      'already_account': 'Already have account? ',

      // Register validation & snackbar
      'fields_required': 'All fields are required',
      'name_min': 'Name must be at least 3 characters',
      'email_invalid': 'Email is not valid',
      'pass_min': 'Password must be at least 6 characters',
      'pass_not_match': 'Password does not match',
      'regis_success': 'Registration successful',
      'regis_success_msg':
          'Please check your inbox / spam to verify your account',
      'regis_failed': 'Registration failed',
      'regis_failed_msg': 'Please check your internet connection',

      // Complete Balance
      'welcome_budgi': 'Welcome to Budgi! 👋',
      'balance_subtitle':
          'Start by adding your current balance. You can update it anytime as you record income or expenses.',
      'start_tracking': 'Start Tracking',
      'balance_required': 'Balance is required',
      'balance_min': 'Balance must be at least 5000',

      // Reset Password
      'forgot_password_title': 'Forgot Password',
      'reset_password': 'Reset Password',
      'reset_subtitle':
          'Enter your account email to receive a password reset link.',
      'email_hint': 'example@email.com',
      'send_reset_link': 'Send Reset Link',
      'reset_success': 'Success',
      'reset_success_msg': 'Password reset link has been sent to your email',
      'reset_failed': 'Failed to send reset password',
      'email_not_found': 'Email is not registered',
      'email_format_invalid': 'Invalid email format',
      'email_required': 'Email is required',

      // Home
      'good_morning': 'Good Morning!',
      'good_afternoon': 'Good Afternoon!',
      'good_evening': 'Good Evening!',
      'good_night': 'Good Night!',
      'data_empty': 'Data Is Empty',
      'balance': 'Balance',
      'recent_activity': 'Recent Activity',
      'no_transactions': 'No Transactions Yet',
      'no_transactions_sub': 'Your transactions will appear here',
      'expenses': 'Expenses',
      'income': 'Income',

      // Popup menu
      'view_details': 'View Details',
      'update': 'Update',
      'delete': 'Delete',

      // Delete snackbar
      'delete_success': 'Transaction deleted successfully',
      'delete_error': 'Transaction ID not found',

      // Transaksi — UI label
      'add_expense': 'Add Expense',
      'add_income': 'Add Income',
      'expense': 'Expense',
      'today': 'Today',
      'date': 'Date',
      'select_category': 'Select Category',
      'category_name': 'Category Name',
      'add_notes_here': 'Add your notes here',
      'input_your_expense': 'Input your expense',
      'input_your_income': 'Input your income',
      'save': 'Save',
      'add': 'Add',
      'confirm_transaction': 'Confirm Transaction',

      // Transaksi — error
      'invalid_amount': 'Invalid amount',
      'category_required': 'Category is required',
      'user_not_logged_in': 'User not logged in',
      'insufficient_balance': 'Not enough balance',
      'transaction_failed': 'Transaction failed, please try again',

      // Transaksi — success
      'expense_added': 'Expense added successfully',
      'income_added': 'Income added successfully',

      // Edit Profile — UI label
      'save_changes': 'Save Changes',
      'profile_photo': 'Profile Photo',
      'gallery': 'Gallery',
      'delete_image': 'Delete Image',
      'delete_photo_title': 'Delete?',
      'delete_photo_confirm':
          'Are you sure you want to delete your profile photo?',

      // Edit Profile — snackbar
      'profile_updated': 'Profile updated successfully',
      'update_profile_failed':
          'Failed to update profile, check your connection',
      'pick_image_failed': 'Failed to pick image',
      'upload_image_failed': 'Failed to upload image, check your connection',

      // Categories
      'cat_food': 'Food',
      'cat_transport': 'Transport',
      'cat_health': 'Health',
      'cat_bill': 'Bill',
      'cat_shopping': 'Shopping',
      'cat_transfer': 'Transfer',
      'cat_entertain': 'Entertain',
      'cat_other': 'Other',

      // Detail Transaction
      'details': 'Details',
      'category': 'Category',
      'amount': 'Amount',
      'notes': 'Notes',

      // Edit Transaction
      'edit_transaction': 'Edit Transaction',
      'notes_optional': 'Notes (optional)',
      'add_note_hint': 'Add your notes here',
      'select_date': 'Select date',
      'transaction_not_found': 'Transaction not found',
      'transaction_updated': 'Transaction updated successfully',
      'category_name_required': 'Category name is required',

      // Analytics & History
      'all_time': 'All Time',
      'all': 'All',
      'activity': 'Activity',
      'total_value': 'Total Value',
      'no_expense_found': 'No expenses found',
      'no_expense_on': 'No expenses on',
      'no_transactions_found': 'No transactions found',
      'search_here': 'Search here',
      'no_income_found': 'No income found',
      'no_income_on': 'No income on',
    },

    // ── Indonesia ─────────────────────────────────────────────────
    'id_ID': {
      // General
      'language': 'Bahasa',
      'cancel': 'Batal',
      'done': 'Selesai',
      'back': 'Kembali',
      'failed': 'Gagal',
      'success': 'Berhasil',
      'try_again': 'Coba Lagi',
      'error': 'Error',
      'yes': 'Ya',

      // No connection
      'no_connection': 'Tidak Ada Koneksi Internet',
      'check_connection': 'Periksa koneksi internetmu dan coba lagi.',

      // Bottom Navbar
      'home_label': 'Beranda',
      'profile_label': 'Profil',

      // Quick Actions
      'analytics': 'Analitik',
      'history': 'Riwayat',
      'split_bill': 'Pindai Tagihan',

      // Content widgets
      'all_set': 'Berhasil!',
      'add_to': 'Tambahkan',
      'to_your': 'ke',

      // Profile
      'profile': 'Profil',
      'theme': 'Tema',
      'logout': 'Keluar',
      'edit_profile': 'Edit Profil',
      'logout_confirm': 'Apakah kamu yakin ingin keluar?',
      'yes_logout': 'Ya, Keluar',
      'dark_mode': 'Mode Gelap',
      'light_mode': 'Mode Terang',

      // Login
      'welcome': 'Selamat Datang !',
      'login_subtitle': 'Masuk dengan aman di sini',
      'enter_email': 'Masukkan email',
      'password': 'Kata sandi',
      'forgot_password': 'Lupa kata sandi?',
      'log_in': 'Masuk',
      'sign_in_with': 'Masuk dengan',
      'no_account': 'Belum punya akun? ',
      'sign_in': 'Masuk',

      // Login snackbar
      'verify_email': 'Silakan verifikasi email kamu, cek inbox / spam',
      'login_failed': 'Login gagal',
      'google_login_failed': 'Login Google gagal',

      // Register
      'hello_budies': 'Halo, budies!',
      'regis_subtitle': 'Silakan daftar jika kamu belum punya akun',
      'full_name': 'Nama Lengkap',
      'email': 'Email',
      'confirm_password': 'Konfirmasi Kata Sandi',
      'sign_up': 'Daftar',
      'already_account': 'Sudah punya akun? ',

      // Register validation & snackbar
      'fields_required': 'Semua kolom wajib diisi',
      'name_min': 'Nama minimal 3 karakter',
      'email_invalid': 'Email tidak valid',
      'pass_min': 'Kata sandi minimal 6 karakter',
      'pass_not_match': 'Kata sandi tidak cocok',
      'regis_success': 'Pendaftaran berhasil',
      'regis_success_msg':
          'Silakan cek inbox / spam untuk verifikasi akun kamu',
      'regis_failed': 'Pendaftaran gagal',
      'regis_failed_msg': 'Periksa koneksi internetmu dan coba lagi',

      // Complete Balance
      'welcome_budgi': 'Selamat datang di Budgi! 👋',
      'balance_subtitle':
          'Mulai dengan menambahkan saldo kamu saat ini. Kamu bisa memperbaruinya kapan saja saat mencatat pemasukan atau pengeluaran.',
      'start_tracking': 'Mulai Lacak',
      'balance_required': 'Saldo wajib diisi',
      'balance_min': 'Saldo minimal 5000',

      // Reset Password
      'forgot_password_title': 'Lupa Kata Sandi',
      'reset_password': 'Reset Kata Sandi',
      'reset_subtitle':
          'Masukkan email akun kamu untuk menerima link reset kata sandi.',
      'email_hint': 'contoh@email.com',
      'send_reset_link': 'Kirim Link Reset',
      'reset_success': 'Berhasil',
      'reset_success_msg': 'Link reset kata sandi sudah dikirim ke email kamu',
      'reset_failed': 'Gagal mengirim reset kata sandi',
      'email_not_found': 'Email tidak terdaftar',
      'email_format_invalid': 'Format email tidak valid',
      'email_required': 'Email wajib diisi',

      // Home
      'good_morning': 'Selamat Pagi!',
      'good_afternoon': 'Selamat Siang!',
      'good_evening': 'Selamat Sore!',
      'good_night': 'Selamat Malam!',
      'data_empty': 'Data Kosong',
      'balance': 'Saldo',
      'recent_activity': 'Aktivitas Terbaru',
      'no_transactions': 'Belum Ada Transaksi',
      'no_transactions_sub': 'Transaksi kamu akan muncul di sini',
      'expenses': 'Pengeluaran',
      'income': 'Pemasukan',

      // Popup menu
      'view_details': 'Lihat Detail',
      'update': 'Perbarui',
      'delete': 'Hapus',

      // Delete snackbar
      'delete_success': 'Transaksi berhasil dihapus',
      'delete_error': 'ID transaksi tidak ditemukan',

      // Transaksi — UI label
      'add_expense': 'Tambah Pengeluaran',
      'add_income': 'Tambah Pemasukan',
      'expense': 'Pengeluaran',
      'today': 'Hari ini',
      'date': 'Tanggal',
      'select_category': 'Pilih Kategori',
      'category_name': 'Nama Kategori',
      'add_notes_here': 'Tambahkan catatan di sini',
      'input_your_expense': 'Masukkan pengeluaran kamu',
      'input_your_income': 'Masukkan pemasukan kamu',
      'save': 'Simpan',
      'add': 'Tambah',
      'confirm_transaction': 'Konfirmasi Transaksi',

      // Transaksi — error
      'invalid_amount': 'Nominal tidak valid',
      'category_required': 'Kategori wajib dipilih',
      'user_not_logged_in': 'Pengguna belum login',
      'insufficient_balance': 'Saldo tidak mencukupi',
      'transaction_failed': 'Transaksi gagal, coba lagi',

      // Transaksi — success
      'expense_added': 'Pengeluaran berhasil ditambahkan',
      'income_added': 'Pemasukan berhasil ditambahkan',

      // Edit Profile — UI label
      'save_changes': 'Simpan Perubahan',
      'profile_photo': 'Foto Profil',
      'gallery': 'Galeri',
      'delete_image': 'Hapus Foto',
      'delete_photo_title': 'Hapus?',
      'delete_photo_confirm': 'Apakah kamu yakin ingin menghapus foto profil?',

      // Edit Profile — snackbar
      'profile_updated': 'Profil berhasil diperbarui',
      'update_profile_failed': 'Gagal memperbarui profil, periksa koneksimu',
      'pick_image_failed': 'Gagal memilih gambar',
      'upload_image_failed': 'Gagal mengunggah gambar, periksa koneksimu',

      // Categories
      'cat_food': 'Makanan',
      'cat_transport': 'Transportasi',
      'cat_health': 'Kesehatan',
      'cat_bill': 'Tagihan',
      'cat_shopping': 'Belanja',
      'cat_transfer': 'Transfer',
      'cat_entertain': 'Hiburan',
      'cat_other': 'Lainnya',

      // Detail Transaction
      'details': 'Detail',
      'category': 'Kategori',
      'amount': 'Jumlah',
      'notes': 'Catatan',

      // Edit Transaction
      'edit_transaction': 'Edit Transaksi',
      'notes_optional': 'Catatan (opsional)',
      'add_note_hint': 'Tambahkan catatan kamu',
      'select_date': 'Pilih tanggal',
      'transaction_not_found': 'Transaksi tidak ditemukan',
      'transaction_updated': 'Transaksi berhasil diperbarui',
      'category_name_required': 'Nama kategori wajib diisi',

      // Analytics & History
      'all_time': 'Semua Waktu',
      'all': 'Semua',
      'activity': 'Aktivitas',
      'total_value': 'Total Nilai',
      'no_expense_found': 'Tidak ada pengeluaran',
      'no_expense_on': 'Tidak ada pengeluaran pada',
      'no_transactions_found': 'Tidak ada transaksi ditemukan',
      'search_here': 'Cari di sini',
      'no_income_found': 'Tidak ada pemasukan',
      'no_income_on': 'Tidak ada pemasukan pada',
    },

    // ── Español ───────────────────────────────────────────────────
    'es_ES': {
      // General
      'language': 'Idioma',
      'cancel': 'Cancelar',
      'done': 'Listo',
      'back': 'Volver',
      'failed': 'Fallido',
      'success': 'Éxito',
      'try_again': 'Intentar de nuevo',
      'error': 'Error',
      'yes': 'Sí',

      // No connection
      'no_connection': 'Sin conexión a Internet',
      'check_connection': 'Verifica tu conexión a internet e intenta de nuevo.',

      // Bottom Navbar
      'home_label': 'Inicio',
      'profile_label': 'Perfil',

      // Quick Actions
      'analytics': 'Análisis',
      'history': 'Historial',
      'split_bill': 'Escanear factura',

      // Content widgets
      'all_set': '¡Todo listo!',
      'add_to': 'Agregar',
      'to_your': 'a tu',

      // Profile
      'profile': 'Perfil',
      'theme': 'Tema',
      'logout': 'Cerrar sesión',
      'edit_profile': 'Editar perfil',
      'logout_confirm': '¿Estás seguro de que quieres cerrar sesión?',
      'yes_logout': 'Sí, cerrar sesión',
      'dark_mode': 'Modo oscuro',
      'light_mode': 'Modo claro',

      // Login
      'welcome': '¡Bienvenido !',
      'login_subtitle': 'Aquí inicias sesión de forma segura',
      'enter_email': 'Ingresa tu email',
      'password': 'Contraseña',
      'forgot_password': '¿Olvidaste tu contraseña?',
      'log_in': 'Iniciar sesión',
      'sign_in_with': 'Iniciar sesión con',
      'no_account': '¿No tienes una cuenta? ',
      'sign_in': 'Iniciar sesión',

      // Login snackbar
      'verify_email': 'Por favor verifica tu email, revisa tu bandeja / spam',
      'login_failed': 'Error al iniciar sesión',
      'google_login_failed': 'Error al iniciar sesión con Google',

      // Register
      'hello_budies': '¡Hola, budies!',
      'regis_subtitle': 'Por favor regístrate si no tienes una cuenta',
      'full_name': 'Nombre completo',
      'email': 'Correo electrónico',
      'confirm_password': 'Confirmar contraseña',
      'sign_up': 'Registrarse',
      'already_account': '¿Ya tienes cuenta? ',

      // Register validation & snackbar
      'fields_required': 'Todos los campos son obligatorios',
      'name_min': 'El nombre debe tener al menos 3 caracteres',
      'email_invalid': 'El correo no es válido',
      'pass_min': 'La contraseña debe tener al menos 6 caracteres',
      'pass_not_match': 'Las contraseñas no coinciden',
      'regis_success': 'Registro exitoso',
      'regis_success_msg':
          'Por favor revisa tu bandeja / spam para verificar tu cuenta',
      'regis_failed': 'Registro fallido',
      'regis_failed_msg': 'Por favor verifica tu conexión a internet',

      // Complete Balance
      'welcome_budgi': '¡Bienvenido a Budgi! 👋',
      'balance_subtitle':
          'Comienza agregando tu saldo actual. Puedes actualizarlo en cualquier momento al registrar ingresos o gastos.',
      'start_tracking': 'Comenzar seguimiento',
      'balance_required': 'El saldo es obligatorio',
      'balance_min': 'El saldo debe ser al menos 5000',

      // Reset Password
      'forgot_password_title': 'Olvidé mi contraseña',
      'reset_password': 'Restablecer contraseña',
      'reset_subtitle':
          'Ingresa el email de tu cuenta para recibir un enlace de restablecimiento.',
      'email_hint': 'ejemplo@email.com',
      'send_reset_link': 'Enviar enlace',
      'reset_success': 'Éxito',
      'reset_success_msg':
          'El enlace de restablecimiento fue enviado a tu email',
      'reset_failed': 'No se pudo enviar el restablecimiento',
      'email_not_found': 'El email no está registrado',
      'email_format_invalid': 'Formato de email inválido',
      'email_required': 'El email es obligatorio',

      // Home
      'good_morning': '¡Buenos días!',
      'good_afternoon': '¡Buenas tardes!',
      'good_evening': '¡Buenas tardes!',
      'good_night': '¡Buenas noches!',
      'data_empty': 'Sin datos',
      'balance': 'Saldo',
      'recent_activity': 'Actividad reciente',
      'no_transactions': 'Sin transacciones aún',
      'no_transactions_sub': 'Tus transacciones aparecerán aquí',
      'expenses': 'Gastos',
      'income': 'Ingresos',

      // Popup menu
      'view_details': 'Ver detalles',
      'update': 'Actualizar',
      'delete': 'Eliminar',

      // Delete snackbar
      'delete_success': 'Transacción eliminada correctamente',
      'delete_error': 'ID de transacción no encontrado',

      // Transaksi — UI label
      'add_expense': 'Agregar gasto',
      'add_income': 'Agregar ingreso',
      'expense': 'Gasto',
      'today': 'Hoy',
      'date': 'Fecha',
      'select_category': 'Seleccionar categoría',
      'category_name': 'Nombre de categoría',
      'add_notes_here': 'Agrega tus notas aquí',
      'input_your_expense': 'Ingresa tu gasto',
      'input_your_income': 'Ingresa tu ingreso',
      'save': 'Guardar',
      'add': 'Agregar',
      'confirm_transaction': 'Confirmar transacción',

      // Transaksi — error
      'invalid_amount': 'Monto no válido',
      'category_required': 'La categoría es obligatoria',
      'user_not_logged_in': 'Usuario no ha iniciado sesión',
      'insufficient_balance': 'Saldo insuficiente',
      'transaction_failed': 'Transacción fallida, intenta de nuevo',

      // Transaksi — success
      'expense_added': 'Gasto agregado correctamente',
      'income_added': 'Ingreso agregado correctamente',

      // Edit Profile — UI label
      'save_changes': 'Guardar cambios',
      'profile_photo': 'Foto de perfil',
      'gallery': 'Galería',
      'delete_image': 'Eliminar foto',
      'delete_photo_title': '¿Eliminar?',
      'delete_photo_confirm':
          '¿Estás seguro de que quieres eliminar tu foto de perfil?',

      // Edit Profile — snackbar
      'profile_updated': 'Perfil actualizado correctamente',
      'update_profile_failed':
          'Error al actualizar perfil, verifica tu conexión',
      'pick_image_failed': 'Error al seleccionar imagen',
      'upload_image_failed': 'Error al subir imagen, verifica tu conexión',

      // Categories
      'cat_food': 'Comida',
      'cat_transport': 'Transporte',
      'cat_health': 'Salud',
      'cat_bill': 'Facturas',
      'cat_shopping': 'Compras',
      'cat_transfer': 'Transferencia',
      'cat_entertain': 'Entretenimiento',
      'cat_other': 'Otro',

      // Detail Transaction
      'details': 'Detalles',
      'category': 'Categoría',
      'amount': 'Monto',
      'notes': 'Notas',

      // Edit Transaction
      'edit_transaction': 'Editar transacción',
      'notes_optional': 'Notas (opcional)',
      'add_note_hint': 'Agrega tus notas aquí',
      'select_date': 'Seleccionar fecha',
      'transaction_not_found': 'Transacción no encontrada',
      'transaction_updated': 'Transacción actualizada correctamente',
      'category_name_required': 'El nombre de la categoría es obligatorio',

      // Analytics & History
      'all_time': 'Todo el tiempo',
      'all': 'Todos',
      'activity': 'Actividad',
      'total_value': 'Valor total',
      'no_expense_found': 'No se encontraron gastos',
      'no_expense_on': 'Sin gastos el',
      'no_transactions_found': 'No se encontraron transacciones',
      'search_here': 'Buscar aquí',
      'no_income_found': 'No se encontraron ingresos',
      'no_income_on': 'Sin ingresos el',
    },

    // ── 中文 ──────────────────────────────────────────────────────
    'zh_CN': {
      // General
      'language': '语言',
      'cancel': '取消',
      'done': '完成',
      'back': '返回',
      'failed': '失败',
      'success': '成功',
      'try_again': '重试',
      'error': '错误',
      'yes': '是',

      // No connection
      'no_connection': '无网络连接',
      'check_connection': '请检查您的网络连接后重试。',

      // Bottom Navbar
      'home_label': '首页',
      'profile_label': '我的',

      // Quick Actions
      'analytics': '分析',
      'history': '历史记录',
      'split_bill': '扫描账单',

      // Content widgets
      'all_set': '设置完成！',
      'add_to': '添加',
      'to_your': '到你的',

      // Profile
      'profile': '个人资料',
      'theme': '主题',
      'logout': '退出登录',
      'edit_profile': '编辑资料',
      'logout_confirm': '您确定要退出登录吗？',
      'yes_logout': '是的，退出',
      'dark_mode': '深色模式',
      'light_mode': '浅色模式',

      // Login
      'welcome': '欢迎 !',
      'login_subtitle': '在这里安全登录',
      'enter_email': '输入邮箱',
      'password': '密码',
      'forgot_password': '忘记密码？',
      'log_in': '登录',
      'sign_in_with': '使用以下方式登录',
      'no_account': '没有账户？',
      'sign_in': '登录',

      // Login snackbar
      'verify_email': '请验证您的邮箱，检查收件箱或垃圾邮件',
      'login_failed': '登录失败',
      'google_login_failed': 'Google 登录失败',

      // Register
      'hello_budies': '你好，budies！',
      'regis_subtitle': '如果您没有账户，请注册',
      'full_name': '全名',
      'email': '电子邮件',
      'confirm_password': '确认密码',
      'sign_up': '注册',
      'already_account': '已有账户？',

      // Register validation & snackbar
      'fields_required': '所有字段均为必填项',
      'name_min': '姓名至少需要3个字符',
      'email_invalid': '邮箱格式不正确',
      'pass_min': '密码至少需要6个字符',
      'pass_not_match': '两次密码不一致',
      'regis_success': '注册成功',
      'regis_success_msg': '请检查您的收件箱/垃圾邮件以验证您的账户',
      'regis_failed': '注册失败',
      'regis_failed_msg': '请检查您的网络连接',

      // Complete Balance
      'welcome_budgi': '欢迎使用 Budgi！👋',
      'balance_subtitle': '请先输入您当前的余额。您可以在记录收入或支出时随时更新。',
      'start_tracking': '开始记账',
      'balance_required': '余额不能为空',
      'balance_min': '余额至少需要5000',

      // Reset Password
      'forgot_password_title': '忘记密码',
      'reset_password': '重置密码',
      'reset_subtitle': '请输入您的账户邮箱以接收密码重置链接。',
      'email_hint': '示例@email.com',
      'send_reset_link': '发送重置链接',
      'reset_success': '成功',
      'reset_success_msg': '密码重置链接已发送到您的邮箱',
      'reset_failed': '发送重置密码失败',
      'email_not_found': '该邮箱未注册',
      'email_format_invalid': '邮箱格式不正确',
      'email_required': '邮箱不能为空',

      // Home
      'good_morning': '早上好！',
      'good_afternoon': '下午好！',
      'good_evening': '晚上好！',
      'good_night': '晚安！',
      'data_empty': '暂无数据',
      'balance': '余额',
      'recent_activity': '最近活动',
      'no_transactions': '暂无交易记录',
      'no_transactions_sub': '您的交易记录将显示在这里',
      'expenses': '支出',
      'income': '收入',

      // Popup menu
      'view_details': '查看详情',
      'update': '更新',
      'delete': '删除',

      // Delete snackbar
      'delete_success': '交易删除成功',
      'delete_error': '未找到交易ID',

      // Transaksi — UI label
      'add_expense': '添加支出',
      'add_income': '添加收入',
      'expense': '支出',
      'today': '今天',
      'date': '日期',
      'select_category': '选择类别',
      'category_name': '类别名称',
      'add_notes_here': '在此添加备注',
      'input_your_expense': '输入您的支出',
      'input_your_income': '输入您的收入',
      'save': '保存',
      'add': '添加',
      'confirm_transaction': '确认交易',

      // Transaksi — error
      'invalid_amount': '金额无效',
      'category_required': '类别为必填项',
      'user_not_logged_in': '用户未登录',
      'insufficient_balance': '余额不足',
      'transaction_failed': '交易失败，请重试',

      // Transaksi — success
      'expense_added': '支出添加成功',
      'income_added': '收入添加成功',

      // Edit Profile — UI label
      'save_changes': '保存更改',
      'profile_photo': '头像',
      'gallery': '相册',
      'delete_image': '删除头像',
      'delete_photo_title': '删除？',
      'delete_photo_confirm': '您确定要删除头像吗？',

      // Edit Profile — snackbar
      'profile_updated': '资料更新成功',
      'update_profile_failed': '更新资料失败，请检查网络连接',
      'pick_image_failed': '选择图片失败',
      'upload_image_failed': '上传图片失败，请检查网络连接',

      // Categories
      'cat_food': '餐饮',
      'cat_transport': '交通',
      'cat_health': '健康',
      'cat_bill': '账单',
      'cat_shopping': '购物',
      'cat_transfer': '转账',
      'cat_entertain': '娱乐',
      'cat_other': '其他',

      // Detail Transaction
      'details': '详情',
      'category': '类别',
      'amount': '金额',
      'notes': '备注',

      // Edit Transaction
      'edit_transaction': '编辑交易',
      'notes_optional': '备注（可选）',
      'add_note_hint': '在此添加备注',
      'select_date': '选择日期',
      'transaction_not_found': '未找到交易记录',
      'transaction_updated': '交易更新成功',
      'category_name_required': '必须填写类别名称',

      // Analytics & History
      'all_time': '所有时间',
      'all': '全部',
      'activity': '活动',
      'total_value': '总金额',
      'no_expense_found': '未找到支出记录',
      'no_expense_on': '该日期无支出',
      'no_transactions_found': '未找到交易记录',
      'search_here': '在此搜索',
      'no_income_found': '未找到收入记录',
      'no_income_on': '该日期无收入',
    },
  };
}
