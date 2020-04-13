class Validator {
  static String numberValidator(String value) {
    if (value == null) {
      return null;
    }
    if (value.isEmpty) {
      return 'Please provide value';
    }
    final n = num.tryParse(value);
    if (n == null) {
      return '"$value" is not a valid number';
    }
    return null;
  }
}
