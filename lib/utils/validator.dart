extension Validator on String {

  bool isValidPhoneNumber() {
    const phonePattern = r'^\d{10}$';
    bool isStartingInvalid = startsWith("0") || startsWith("-") || startsWith("1") || startsWith("2") || startsWith("3") || startsWith("4") || startsWith("5");
    return RegExp(phonePattern).hasMatch(this) && !isStartingInvalid;
  }

  bool isValidEmail() {
    const emailPattern = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
    return RegExp(emailPattern).hasMatch(this);
  }

  bool isValidPassword() {
    return length >= 8;
  }

}
