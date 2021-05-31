import 'package:flutter/cupertino.dart';
import 'package:otp/otp.dart';
import 'package:recase/recase.dart';
import 'package:uuid/uuid.dart';

import '../enum/OTPType.dart';
import '../datamodel/SecretDataModel.dart';
import 'SimpleIconsGetter.dart';

class Utils {
  static OTPType parseOTPType(String type) {
    type = type.toLowerCase();
    switch (type) {
      case "otptype.totp":
      case "totp":
        return OTPType.TOTP;
        break;
      default:
        throw Exception("Unknown OTP type");
    }
  }

  static Algorithm parseOTPAlgorithm(String algorithm) {
    algorithm = algorithm.toLowerCase();
    switch (algorithm) {
      case 'otpalgorithm.sha1':
      case 'sha1':
        return Algorithm.SHA1;
        break;
      case 'otpalgorithm.sha256':
      case 'sha256':
        return Algorithm.SHA256;
        break;
      case 'otpalgorithm.sha512':
      case 'sha512':
        return Algorithm.SHA512;
        break;
      default:
        return Algorithm.SHA1;
        break;
    }
  }

  static List<String> parseTags(String tags) {
    if (tags == '[]')
      return [];
    else {
      List<String> result = [];

      tags = tags.replaceAll("[", '').replaceAll("]", '');
      result = tags.split(',');

      return result;
    }
  }

  static Secret parseUri(Uri uri) {
    if (uri.scheme.toLowerCase() != "otpauth")
      throw Exception("Invalid protocol");

    OTPType type = Utils.parseOTPType(uri.host.toLowerCase());

    String label = uri.path.toLowerCase().replaceAll('/', '') ?? "";

    var parameters = uri.queryParametersAll;

    dynamic secret = parameters["secret"];
    dynamic issuer = parameters["issuer"];
    dynamic counter = parameters["counter"];
    dynamic period = parameters["period"];
    dynamic digits = parameters["digits"];
    dynamic algorithm = parameters["algorithm"];
    List<String> tags = parameters["tags"];

    if (secret == null)
      throw Exception("Empty secret");
    else
      secret = (secret as List<String>).first;

    if (issuer != null) issuer = (issuer as List<String>).first;

    if (counter != null) {
      counter = int.parse((counter as List<String>).first);
    } else if (type == OTPType.HOTP) {
      throw Exception("Empty counter for HOTP");
    }

    if (period != null) {
      period = int.parse((period as List<String>).first);
    } else if (type == OTPType.TOTP || type == OTPType.STEAM) {
      period = 30;
    }

    if (digits != null)
      digits = int.parse((digits as List<String>).first);
    else
      digits = type == OTPType.STEAM ? 5 : 6;

    if (algorithm != null) {
      algorithm = Utils.parseOTPAlgorithm((algorithm as List<String>).first);
    } else {
      algorithm = Algorithm.SHA1;
    }

    if (tags == null) {
      tags = List.empty();
    }

    String id = Uuid().v4();
    return Secret(
      id: id,
      type: type,
      label: label,
      secret: (secret as String),
      issuer: (issuer as String),
      counter: (counter as int),
      period: (period as int),
      digits: (digits as int),
      algorithm: (algorithm as Algorithm),
      tags: tags,
    );
  }

  static IconData findIconByName(String name) {
    bool camelCase = false;

    name = name.replaceAll(' ', '');

    if (name.contains('.')) {
      name = name.replaceAll('.', 'dot');
      camelCase = true;
    }
    if (name.contains('-')) {
      name = name.replaceAll('-', '');
      camelCase = true;
    }
    var index = name.indexOf(RegExp(r'\d'));
    if (index != -1)
      name = name.substring(0, index) + 'n' + name.substring(index);

    if (camelCase) {
      name = ReCase(name).camelCase;
    } else {
      name = name.toLowerCase();
    }

    return SimpleIconsGetter.find(name);
  }
}
