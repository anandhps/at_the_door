class ResponseModel1 {
  bool _isSuccess;
  String _message;
  String _token;
  ResponseModel1(this._isSuccess, this._message, this._token);

  String get token => _token;
  String get message => _message;
  bool get isSuccess => _isSuccess;
}
