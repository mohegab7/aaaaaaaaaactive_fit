// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env.dart';

// **************************************************************************
// EnviedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _Env {
  static const List<int> _enviedkeyfdcApiKey = <int>[
    1796456514,
    3453802658,
    1374872797,
    502728074,
    2097379000,
    457527950,
    3021840955,
    1388407944,
  ];

  static const List<int> _envieddatafdcApiKey = <int>[
    1796456475,
    3453802733,
    1374872712,
    502728152,
    2097379047,
    457528005,
    3021841022,
    1388408017,
  ];

  static final String fdcApiKey = String.fromCharCodes(List<int>.generate(
    _envieddatafdcApiKey.length,
    (int i) => i,
    growable: true,
  ).map((int i) => _envieddatafdcApiKey[i] ^ _enviedkeyfdcApiKey[i]));

  static const List<int> _enviedkeysentryDns = <int>[
    2043883548,
    634399264,
    1519046534,
    1828729671,
    3614065888,
    2768396767,
    3332749142,
  ];

  static const List<int> _envieddatasentryDns = <int>[
    2043883608,
    634399342,
    1519046613,
    1828729624,
    3614065845,
    2768396685,
    3332749082,
  ];

  static final String sentryDns = String.fromCharCodes(List<int>.generate(
    _envieddatasentryDns.length,
    (int i) => i,
    growable: false,
  ).map((int i) => _envieddatasentryDns[i] ^ _enviedkeysentryDns[i]));

  static const List<int> _enviedkeysupabaseProjectUrl = <int>[
    1825129406,
    1432012346,
    4246485301,
    2758889092,
    1022079339,
    2917189999,
    1607491067,
    4281500627,
    4033980666,
    3811669908,
    912050476,
  ];

  static const List<int> _envieddatasupabaseProjectUrl = <int>[
    1825129454,
    1432012392,
    4246485370,
    2758889166,
    1022079278,
    2917189932,
    1607490991,
    4281500556,
    4033980591,
    3811669958,
    912050528,
  ];

  static final String supabaseProjectUrl = String.fromCharCodes(
      List<int>.generate(
    _envieddatasupabaseProjectUrl.length,
    (int i) => i,
    growable: false,
  ).map((int i) =>
          _envieddatasupabaseProjectUrl[i] ^ _enviedkeysupabaseProjectUrl[i]));

  static const List<int> _enviedkeysupabaseProjectAnonKey = <int>[
    4285745747,
    2349022348,
    263113417,
    865270486,
    260723057,
    114583883,
    683342016,
    3569022822,
  ];

  static const List<int> _envieddatasupabaseProjectAnonKey = <int>[
    4285745682,
    2349022402,
    263113350,
    865270424,
    260722990,
    114583808,
    683341957,
    3569022783,
  ];

  static final String supabaseProjectAnonKey = String.fromCharCodes(
      List<int>.generate(
    _envieddatasupabaseProjectAnonKey.length,
    (int i) => i,
    growable: false,
  ).map((int i) =>
          _envieddatasupabaseProjectAnonKey[i] ^
          _enviedkeysupabaseProjectAnonKey[i]));
}
