import 'dart:convert';

Meun meunFromJson(String str) => Meun.fromJson(json.decode(str));

String meunToJson(Meun data) => json.encode(data.toJson());

List<Meun> meunListFromJson(String str) =>
    List<Meun>.from(json.decode(str).map((x) => Meun.fromJson(x)));

String meunListToJson(List<Meun> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Meun {
  String ud15Key1;
  String ud15Character01;
  String ud15Number01;
  bool ud15CheckBox01;
  String rowIdent;

  Meun({
    required this.ud15Key1,
    required this.ud15Character01,
    required this.ud15Number01,
    required this.ud15CheckBox01,
    required this.rowIdent,
  });

  factory Meun.fromJson(Map<String, dynamic> json) => Meun(
        ud15Key1: json["UD15_Key1"],
        ud15Character01: json["UD15_Character01"],
        ud15Number01: json["UD15_Number01"],
        ud15CheckBox01: json["UD15_CheckBox01"],
        rowIdent: json["RowIdent"],
      );

  Map<String, dynamic> toJson() => {
        "UD15_Key1": ud15Key1,
        "UD15_Character01": ud15Character01,
        "UD15_Number01": ud15Number01,
        "UD15_CheckBox01": ud15CheckBox01,
        "RowIdent": rowIdent,
      };
}
