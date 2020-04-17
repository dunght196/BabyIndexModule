
class Child {
  final String relativeId;
  final String guuId;
  final String name;
  final String gender;
  final String birthday;

  Child(this.relativeId, this.guuId, this.name, this.gender, this.birthday);

  Child.fromJson(Map<String, dynamic> json)
      : relativeId = json["relative_id"],
        guuId = json["guu_id"],
        name = json["name"],
        gender = json["gender"],
        birthday = json["birthday"];

}