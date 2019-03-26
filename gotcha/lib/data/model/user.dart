class User {
  String _first;
  String _middle;
  String _last;
  String _street;
  String _city;
  String _state;
  String _zip;
  String _country;
 
  User(this._first, this._middle, this._last);
 
  User.map(dynamic obj) {
    this._first = obj['first'];
    this._middle = obj['middle'];
    this._last = obj['last'];
    this._street = obj['street'];
    this._city = obj['city'];
    this._state = obj['state'];
    this._zip = obj['zip'];
    this._country = obj['country'];
  }
 
  String get first => _first;
  String get middle => _middle;
  String get last => _last;
  String get street => _street;
  String get city =>_city;
  String get state =>_state;
  String get zip => _zip;
  String get country => _country;
 
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_first != null) {
      map['first'] = _first;
    }
    map['middle'] = _middle;
    map['last'] = _last;
    map['street'] = _street;
    map['city'] = _city;
    map['state'] = _state;
    map['zip'] = _zip;
    map['country'] = _country;

    return map;
  }
 
  User.fromMap(Map<String, dynamic> map) {
    this._first = map['first'];
    this._middle = map['middle'];
    this._last = map['last'];
    this._street = map['street'];
    this._city = map['city'];
    this._state = map['state'];
    this._zip = map['zip'];
    this._country = map['country'];
  }
}