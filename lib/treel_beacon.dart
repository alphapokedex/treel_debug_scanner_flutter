class TreelBeacon {
  String _macID;
  final int _minor;

  static TreelBeacon copyDefault(
    TreelBeacon treelBeacon,
    String str,
    int i,
    int i2,
    Object obj,
  ) {
    if ((i2 & 1) != 0) str = treelBeacon._macID;
    if ((i2 & 2) != 0) i = treelBeacon._minor;
    return TreelBeacon(str, i);
  }

  bool equals(Object obj) {
    if (this == obj) return true;
    if (obj is! TreelBeacon) return false;
    TreelBeacon treelBeacon = obj;
    return _macID == treelBeacon._macID && _minor == treelBeacon._minor;
  }

  @override
  String toString() {
    return "TreelBeacon(macID=${_macID}, minor=${_minor.toString()})";
  }

  TreelBeacon(this._macID, this._minor);

  String getMacID() => _macID;

  int getMinor() => _minor;

  void setMacID(String str) {
    _macID = str;
  }
}
