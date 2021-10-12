class NoInternetException implements Exception {
  String message;
  NoInternetException(this.message);
}

class NoServerResponseException implements Exception {
  String title;
  String message;
  NoServerResponseException(this.title, this.message);
}

class JsonCastingException implements Exception {
  String title;
  String message;
  JsonCastingException(this.title, this.message);
}


class FOFNotFoundException implements Exception {
  String title;
  String message;
  FOFNotFoundException(this.title, this.message);
}

class GeneralServerException implements Exception {
  String title;
  String message;
  GeneralServerException(this.title, this.message);
}