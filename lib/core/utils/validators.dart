class Validators {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Enter your name";
    }

    if (value.length < 2) {
      return "Name too short";
    }

    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter phone number";
    }

    if (value.length != 10) {
      return "Enter valid phone number";
    }

    return null;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter price";
    }

    final number = double.tryParse(value);

    if (number == null || number <= 0) {
      return "Enter valid price";
    }

    return null;
  }

  static String? validateModel(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter model";
    }

    return null;
  }
}
