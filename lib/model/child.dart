
class Child {
  final String relative_id;
  final String guu_id;
  final String name;
  final String gender;
  final String birthday;

  Child(this.relative_id, this.guu_id, this.name, this.gender, this.birthday);

  Child.fromJson(Map<String, dynamic> json)
      : relative_id = json["relative_id"],
        guu_id = json["guu_id"],
        name = json["name"],
        gender = json["gender"],
        birthday = json["gender"];

}