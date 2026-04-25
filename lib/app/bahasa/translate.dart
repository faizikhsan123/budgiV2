import 'package:get/get.dart';

class MyTranslate extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    // ── Inggris ──────────────────────────────────────
    'en_US': {
      'language':     'Language',
      'profile':      'Profile',
      'theme':        'Theme',
      'logout':       'Logout',
      'edit_profile': 'Edit Profile',
      'logout_confirm': 'Are you sure want to logout?',
      'cancel':       'Cancel',
      'yes_logout':   'Yes, Logout',
      'dark_mode':    'Dark Mode',
      'light_mode':   'Light Mode',
    },

    // ── Indonesia ─────────────────────────────────────
    'id_ID': {
      'language':     'Bahasa',
      'profile':      'Profil',
      'theme':        'Tema',
      'logout':       'Keluar',
      'edit_profile': 'Edit Profil',
      'logout_confirm': 'Apakah kamu yakin ingin keluar?',
      'cancel':       'Batal',
      'yes_logout':   'Ya, Keluar',
      'dark_mode':    'Mode Gelap',
      'light_mode':   'Mode Terang',
    },

    // ── Spanyol ───────────────────────────────────────
    'es_ES': {
      'language':     'Idioma',
      'profile':      'Perfil',
      'theme':        'Tema',
      'logout':       'Cerrar sesión',
      'edit_profile': 'Editar perfil',
      'logout_confirm': '¿Estás seguro de que quieres cerrar sesión?',
      'cancel':       'Cancelar',
      'yes_logout':   'Sí, cerrar sesión',
      'dark_mode':    'Modo oscuro',
      'light_mode':   'Modo claro',
    },

    // ── Mandarin ──────────────────────────────────────
    'zh_CN': {
      'language':     '语言',
      'profile':      '个人资料',
      'theme':        '主题',
      'logout':       '退出登录',
      'edit_profile': '编辑资料',
      'logout_confirm': '您确定要退出登录吗？',
      'cancel':       '取消',
      'yes_logout':   '是的，退出',
      'dark_mode':    '深色模式',
      'light_mode':   '浅色模式',
    },
  };
}