class Validators {
  static bool validateAmount(
      double amount,
      ) {
    return amount > 0;
  }

  static bool validateText(
      String value,
      ) {
    return value.trim().isNotEmpty;
  }
}