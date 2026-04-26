import 'package:get/get.dart';

String translateCategory(String? raw) {
  if (raw == null || raw.isEmpty) return '';
  switch (raw.trim().toLowerCase()) {
    case 'food':       return 'cat_food'.tr;
    case 'transport':  return 'cat_transport'.tr;
    case 'health':     return 'cat_health'.tr;
    case 'bill':       return 'cat_bill'.tr;
    case 'shopping':   return 'cat_shopping'.tr;
    case 'transfer':   return 'cat_transfer'.tr;
    case 'entertaint':
    case 'entertain':  return 'cat_entertain'.tr;
    case 'other':      return 'cat_other'.tr;
    case 'income':     return 'income'.tr;
    default:           return raw;
  }
}

// Map category → icon URL
String getCategoryIcon(String? raw) {
  switch (raw?.trim().toLowerCase()) {
    case 'food':
      return 'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774973824/mingcute--fork-spoon-fill_k44lpk.svg';
    case 'transport':
      return 'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774973824/mingcute--car-fill_oyvkvd.svg';
    case 'shopping':
      return 'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774973824/mingcute--shopping-cart-2-fill_dbgrgo.svg';
    case 'health':
      return 'https://res.cloudinary.com/dzfi5acyl/image/upload/v1775021799/mingcute--shield-fill_1_hbbsu5.svg';
    case 'entertaint':
    case 'entertain':
      return 'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774974432/mingcute--movie-fill_kps26w.svg';
    case 'transfer':
      return 'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774973824/mingcute--transfer-3-fill_vywadq.svg';
    case 'bill':
      return 'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774973824/mingcute--bill-fill_f1txbv.svg';
    default:
      return 'https://res.cloudinary.com/dzfi5acyl/image/upload/v1774974432/mingcute--more-4-fill_g3maa8.svg';
  }
}