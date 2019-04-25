class Account {
  String _first;
  String _middle;
  String _last;
  String _address_city;
  String _address_state;
  String _address_zip;
  String _email;
  String _username;
  String _password;
  String _phone_number;
  String _country;

  Account(this._first, this._middle, this._last);

  Account.map(dynamic obj) {
    this._first = obj['first'];
    this._middle = obj['middle'];
    this._last = obj['last'];
    this._address_city = obj['address_city'];
    this._address_state = obj['address_state'];
    this._address_zip = obj['address_zip'];
    this._email = obj['email'];
    this._username = obj['username'];
    this._password = obj['password'];
    this._phone_number = obj['phone_number'];
    this._country = obj['country'];
  }

  String get first => _first;
  String get middle => _middle;
  String get last => _last;
  String get address_city => _address_city;
  String get address_state => _address_state;
  String get address_zip => _address_zip;
  String get email => _email;
  String get username => _username;
  String get password =>_password;
  String get phoneNumber => _phone_number;
  String get country => _country;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_first != null) {
      map['first'] = _first;
    }
    map['middle'] = _middle;
    map['last'] = _last;
    map['address_city'] = _address_city;
    map['address_state'] = _address_state;
    map['address_zip'] = _address_zip;
    map['email'] = _email;
    map['username'] = _username;
    map['password'] = _password;
    map['phone_number'] = _phone_number;
    map['country'] = _country;

    return map;
  }

  Account.fromMap(Map<String, dynamic> map) {
    this._first = map['first'];
    this._middle = map['middle'];
    this._last = map['last'];
    this._address_city = map['address_city'];
    this._address_state = map['address_state'];
    this._address_zip = map['address_zip'];
    this._email = map['email'];
    this._username = map['username'];
    this._password = map['password'];
    this._phone_number = map['phone_number'];
    this._country = map['country'];
  }
}