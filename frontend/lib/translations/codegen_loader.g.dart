// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> en = {
  "appbars": {
    "titles": {
      "login": "Login",
      "register": "Register",
      "note_generation": "Note Generation"
    }
  },
  "buttons": {
    "browse_files_audio": "Browse Files to Import Audio",
    "record_audio": "Record Audio",
    "generate_flashcards": "Generate Flashcards",
    "generate_note": "Generate Note!",
    "yes": "Yes",
    "no": "No"
  },
  "labels": {
    "selected_file_name": "Selected File Name: ",
    "no_file_selected": "No file selected",
    "or": "-OR-"
  },
  "dialogs": {
    "info_dialogs": {},
    "success_dialogs": {
      "file_pick_success": {
        "title": "File Picked Successfully",
        "description": "File {} picked successfully."
      },
      "note_generation_success": {
        "title": "Note Generation Successful!",
        "description": "Note generated successfully."
      },
      "login_success": {
        "title": "Login Successful!",
        "description": "Successfully logged in."
      },
      "change_password_success": {
        "title": "Password Changed!",
        "description": "Your password is successfully changed."
      },
      "register_success": {
        "title": "Registration Successful!",
        "description": "Successfully registered. Let's start generating notes!"
      },
      "forgot_password_success": {
        "title": "Password Reset Successful!",
        "description": "Your password is successfully reset. Your new password is sent to your email."
      }
    },
    "confirm_dialogs": {},
    "error_dialogs": {
      "file_pick_error": {
        "title": "File Picking Failed!",
        "description": "You did not select an appropriate file. Please try again."
      },
      "note_generation_error": {
        "title": "Note Generation Failed!",
        "description": "Note generation failed. Please try again."
      },
      "login_error": {
        "title": "Login Failed!",
        "description": "Your username or password is incorrect. Please try again."
      },
      "change_password_error": {
        "title": "Change Password Failed!",
        "description": "We could not change your password. Please try again later."
      },
      "register_error": {
        "title": "Registration Failed!",
        "description": "Registration failed. Please try again."
      },
      "forgot_password_error": {
        "title": "Password Reset Failed!",
        "description": "We could not reset your password. Please try again later."
      }
    }
  },
  "text_fields": {
    "labels": {
      "note_name": "Note Name"
    },
    "hints": {
      "note_name": "Enter Note Name"
    }
  },
  "onboarding": {},
  "validators": {
    "required": "{} is required"
  }
};
static const Map<String,dynamic> tr = {
  "appbars": {
    "titles": {
      "login": "Giriş Yap",
      "register": "Kayıt Ol",
      "note_generation": "Not Oluşturma"
    }
  },
  "buttons": {
    "browse_files_audio": "Ses Dosyası Seç",
    "record_audio": "Ses Kaydet",
    "generate_flashcards": "Flashcard Oluştur",
    "generate_note": "Not Oluştur!",
    "yes": "Evet",
    "no": "Hayır"
  },
  "labels": {
    "selected_file_name": "Seçilen Dosya: ",
    "no_file_selected": "Dosya seçilmedi",
    "or": "-VEYA-"
  },
  "dialogs": {
    "info_dialogs": {},
    "success_dialogs": {
      "file_pick_success": {
        "title": "Dosya Seçme Başarılı!",
        "description": "{} adlı dosya başarıyla seçildi."
      },
      "note_generation_success": {
        "title": "Not Oluşturma Başarılı!",
        "description": "Not başarıyla oluşturuldu."
      },
      "login_success": {
        "title": "Giriş Başarılı!",
        "description": "Giriş başarıyla gerçekleşti."
      },
      "change_password_success": {
        "title": "Şifre Değiştirme Başarılı!",
        "description": "Şifreniz başarıyla değiştirildi."
      },
      "register_success": {
        "title": "Kayıt Başarılı!",
        "description": "Kayıt başarıyla gerçekleşti. Haydi not oluşturmaya başlayalım!"
      },
      "forgot_password_success": {
        "title": "Şifre Sıfırlama Başarılı!",
        "description": "Şifreniz başarıyla sıfırlandı. Yeni şifreniz e-posta adresinize gönderildi."
      }
    },
    "confirm_dialogs": {},
    "error_dialogs": {
      "file_pick_error": {
        "title": "Dosya Seçme Başarısız!",
        "description": "Uygun bir dosya seçilmedi. Lütfen tekrar deneyin."
      },
      "note_generation_error": {
        "title": "Not Oluşturma Başarısız!",
        "description": "Not oluşturulurken bir hata oluştu. Lütfen tekrar deneyin."
      },
      "login_error": {
        "title": "Giriş Başarısız!",
        "description": "Kullanıcı adı veya şifre hatalı. Lütfen tekrar deneyin."
      },
      "change_password_error": {
        "title": "Şifre Değiştirme Başarısız!",
        "description": "Şifre değiştirilirken bir hata oluştu. Lütfen tekrar deneyin."
      },
      "register_error": {
        "title": "Kayıt Başarısız!",
        "description": "Kayıt olurken bir hata oluştu. Lütfen tekrar deneyin."
      },
      "forgot_password_error": {
        "title": "Şifre Sıfırlama Başarısız!",
        "description": "Şifre sıfırlanırken bir hata oluştu. Lütfen tekrar deneyin."
      }
    }
  },
  "text_fields": {
    "labels": {
      "note_name": "Not Adı"
    },
    "hints": {
      "note_name": "Not Adı Giriniz"
    }
  },
  "onboarding": {},
  "validators": {
    "required": "{} boş bırakılamaz"
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": en, "tr": tr};
}
