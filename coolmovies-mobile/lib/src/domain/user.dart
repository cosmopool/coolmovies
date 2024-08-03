import "package:equatable/equatable.dart";

class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.nodeId,
  });

  final String id;
  final String name;
  final String nodeId;

  @override
  List<Object> get props => [id, name, nodeId];

  User copyWith({
    String? id,
    String? name,
    String? nodeId,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      nodeId: nodeId ?? this.nodeId,
    );
  }

  @override
  bool get stringify => true;
}
