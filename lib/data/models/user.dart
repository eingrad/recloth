class UserData{
  final String firstname;
  final String lastname;
  final String username;
  final String uid;

  UserData({required this.firstname, required this.lastname, required this.username, required this.uid});

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstname,
      'lastName': lastname,
      'username': username,
      'uid': uid,
    };
  }

  // Method to create UserData from a Firestore document snapshot
  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      firstname: map['firstName'] as String,
      lastname: map['lastName'] as String,
      username: map['username'] as String,
      uid: map['uid'] as String,
    );
  }
}
