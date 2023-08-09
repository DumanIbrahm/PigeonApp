class ExceptionHandler {
  static String getErrorMessage(String errorCode) {
    switch (errorCode) {
      case "ERROR_INVALID_EMAIL":
        return "Your email address appears to be malformed.";
      case "email-already-in-use":
        return "The email address is already in use by another account.";
      case "Email or password is incorrect.":
        return "Email or password is incorrect.";
      default:
        return "An undefined Error happened.";
    }
  }
}
