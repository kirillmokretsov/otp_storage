import 'package:flutter/material.dart';
import 'package:otp/otp.dart';

import '../enum/OTPType.dart';
import '../utils/Utils.dart';

class Secret {
  final String id;
  final OTPType type;
  final String label;
  final String secret;
  final String issuer;
  final int counter;
  final int period;
  final int digits;
  final Algorithm algorithm;
  List<String> tags;
  IconData icon;

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
    this.icon,
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
        'icon': Utils.toJsonString(icon),
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
        tags: Utils.parseTags(map['tags']),
        icon: Utils.fromJsonString(map['icon']),
      );

  String toString() =>
      "Secret(id $id, type $type, label $label, secret $secret, issuer $issuer, counter $counter, period $period, digits $digits, tags $tags";
}
