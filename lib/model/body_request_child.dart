
class BodyChild {
  final String access_token;
  final String relationship;

  BodyChild(this.access_token, this.relationship);

  Map<String, dynamic> toJson() =>
      {
        'access_token': access_token,
        'relationship': relationship,
      };
}