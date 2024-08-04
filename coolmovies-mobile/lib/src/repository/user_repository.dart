import "package:graphql_flutter/graphql_flutter.dart";

import "../domain/user.dart";
import "../mappers/user_mapper.dart";

class UserRepository {
  UserRepository(this._client);

  final GraphQLClient _client;

  Future<List<User>> fetchAll() async {
    final result = await _client.query(
      QueryOptions(
        document: gql("""
          query AllUsers {
            allUsers {
            	nodes {
            		id
            		name
            	}
            }
          }
        """),
      ),
    );

    if (result.hasException) throw result.exception!;
    if (result.data == null) return [];

    final users = <User>[];
    final userJson = result.data!["allUsers"]["nodes"] as List;
    for (var json in userJson) {
      if (json == null) continue;
      users.add(UserMapper.fromMap(json));
    }
    return users;
  }
}
