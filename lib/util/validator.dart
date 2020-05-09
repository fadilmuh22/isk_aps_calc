class Validator {
  static String number(String value) {
    if (value == null || value.isEmpty) {
      return 'Silahkan isi dengan nilai yang sesuai';
    }
    final n = num.tryParse(value);
    if (n == null) {
      return '"$value" is not a valid number';
    }
    return null;
  }
}
