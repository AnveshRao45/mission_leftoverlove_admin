// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String name;
  final String phonenum;
  final String email;
  final String token;
  final String uid;
  final String photoUrl;
  final int? moneySaved;
  final int? coSaved;
  UserModel({
    required this.name,
    required this.phonenum,
    required this.email,
    required this.token,
    required this.uid,
    required this.photoUrl,
    required this.moneySaved,
    required this.coSaved,
  });

  UserModel copyWith({
    String? name,
    String? phonenum,
    String? email,
    String? token,
    String? uid,
    String? photoUrl,
    int? moneySaved,
    int? coSaved,
  }) {
    return UserModel(
      name: name ?? this.name,
      phonenum: phonenum ?? this.phonenum,
      email: email ?? this.email,
      token: token ?? this.token,
      uid: uid ?? this.uid,
      photoUrl: photoUrl ?? this.photoUrl,
      moneySaved: moneySaved ?? this.moneySaved,
      coSaved: coSaved ?? this.coSaved,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'phonenum': phonenum,
      'email': email,
      'token': token,
      'uid': uid,
      'photoUrl': photoUrl,
      'moneySaved': moneySaved,
      'coSaved': coSaved,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      phonenum: map['phonenum'] as String,
      email: map['email'] as String,
      token: map['token'] as String,
      uid: map['uid'] as String,
      photoUrl: map['photoUrl'] as String,
      moneySaved: map['moneySaved'] != null ? map['moneySaved'] as int : null,
      coSaved: map['coSaved'] != null ? map['coSaved'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(name: $name, phonenum: $phonenum, email: $email, token: $token, uid: $uid, photoUrl: $photoUrl, moneySaved: $moneySaved, coSaved: $coSaved)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.phonenum == phonenum &&
        other.email == email &&
        other.token == token &&
        other.uid == uid &&
        other.photoUrl == photoUrl &&
        other.moneySaved == moneySaved &&
        other.coSaved == coSaved;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        phonenum.hashCode ^
        email.hashCode ^
        token.hashCode ^
        uid.hashCode ^
        photoUrl.hashCode ^
        moneySaved.hashCode ^
        coSaved.hashCode;
  }
}
