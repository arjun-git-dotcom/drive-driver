class ValidationUtils {
  static String? validateName(String name) {
    if (name.isEmpty) return "Name cannot be empty.";
    if (name.length < 3) return "Name must be at least 3 characters.";
    return null;
  }

  static String? validateEmail(String email) {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (email.isEmpty) return "Email cannot be empty.";
    if (!emailRegex.hasMatch(email)) return "Invalid email format.";
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) return "Password cannot be empty.";
    if (password.length < 8) return "Password must be at least 8 characters.";
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return "Password must have at least one uppercase letter.";
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return "Password must have at least one lowercase letter.";
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return "Password must have at least one number.";
    }
    if (!RegExp(r'[!@#\$&*~]').hasMatch(password)) {
      return "Password must have at least one special character.";
    }
    return null;
  }

  static String? validatePhone(String phone) {
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    if (phone.isEmpty) return "Phone number cannot be empty.";
    if (!phoneRegex.hasMatch(phone)) return "Invalid phone number.";
    return null;
  }
}