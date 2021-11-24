import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String firstName;
  final String lastName;

  const User(this.id, this.firstName, this.lastName);

  @override
  List<Object> get props => [id, firstName, lastName];

  static const empty = User('-', '', '');
}