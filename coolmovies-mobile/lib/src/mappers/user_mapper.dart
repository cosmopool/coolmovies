import "dart:convert";

import "../domain/user.dart";

abstract class UserMapper {
  static const kId = "id";
  static const kName = "name";
  static const kNodeId = "nodeId";

  static Map<String, dynamic> toMap(User user) {
    return <String, dynamic>{
      kId: user.id,
      kName: user.name,
    };
  }

  static fromMap(Map<String, dynamic> map) {
    return User(
      id: map[kId] as String,
      name: map[kName] as String,
    );
  }

  static String toJson(User user) => json.encode(toMap(user));

  static fromJson(String source) =>
      fromMap(json.decode(source) as Map<String, dynamic>);
}
