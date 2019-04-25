class User {
  String _first;
  String _middle;
  String _last;
  String _notify;
  String _resident_status;
  String _unlock_option;
  String _account;
 
  User(this._first, this._middle, this._last);
 
  User.map(dynamic obj) {
    this._first = obj['first'];
    this._middle = obj['middle'];
    this._last = obj['last'];
    this._notify = obj['notify'];
    this._resident_status = obj['resident_status'];
    this._unlock_option = obj['unlock_option'];
    this._account = obj['account'];
  }
 
  String get first => _first;
  String get middle => _middle;
  String get last => _last;
  String get notify => _notify;
  String get resident_status => _resident_status;
  String get unlock_option => _unlock_option;
  String get account => _account;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_first != null) {
      map['first'] = _first;
    }
    map['middle'] = _middle;
    map['last'] = _last;
    map['notify'] = _notify;
    map['resident_status'] = _resident_status;
    map['unlock_options'] = _unlock_option;
    map['account'] = _account;

    return map;
  }
 
  User.fromMap(Map<String, dynamic> map) {
    this._first = map['first'];
    this._middle = map['middle'];
    this._last = map['last'];
    this._notify = map['notify'];
    this._resident_status = map['resident_status'];
    this._unlock_option = map['unlock_option'];
    this._account = map['account'];
  }
}