class Secret {
  final id;
  final secret;
  final name;

  Secret(this.id, this.secret, this.name);

  Map<String, dynamic> toMap() => {
        'id': id,
        'secret': secret,
        'name': name,
      };

  static Secret fromMap(Map<String, dynamic> map) => Secret(map['id'], map['secret'], map['name']);

  String toString() => "Secret(id: $id, secret: $secret, name: $name";
}
