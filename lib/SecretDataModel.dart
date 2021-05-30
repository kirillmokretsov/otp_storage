import 'package:otp_storage/main.dart';

import 'Utils.dart';

class Secret {
  final String id;
  final OTPType type;
  final String label;
  final String secret;
  final String issuer;
  final int counter;
  final int period;
  final int digits;
  final OTPAlgorithm algorithm;
  final List<String> tags;

  Secret({
    this.id,
    this.type,
    this.label,
    this.secret,
    this.issuer,
    this.counter,
    this.period,
    this.digits,
    this.algorithm,
    this.tags,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type.toString(),
        'label': label,
        'secret': secret,
        'issuer': issuer,
        'counter': counter,
        'period': period,
        'digits': digits,
        'algorithm': algorithm.toString(),
        'tags': tags.toString(),
      };

  static Secret fromMap(Map<String, dynamic> map) => Secret(
        id: map['id'],
        type: Utils.parseOTPType(map['type']),
        label: map['label'],
        secret: map['secret'],
        issuer: map['issuer'],
        counter: map['counter'],
        period: map['period'],
        digits: map['digits'],
        algorithm: Utils.parseOTPAlgorithm(map['algorithm']),
        // TODO: fill tags normally
        tags: [map['tags']],
      );

  String toString() =>
      "Secret(id $id, type $type, label $label, secret $secret, issuer $issuer, counter $counter, period $period, digits $digits, tags $tags";
}
