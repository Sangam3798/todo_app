

class UserModel{
   String? fullName;
   String? email;
   String? userId;
   String? profilePic;
  UserModel({this.fullName, this.email, this.userId, this.profilePic});

  UserModel.fromJson(Map<String, dynamic>? json){
    fullName = json?['fullName'];
    email = json?['email'];
    userId = json?['userId'];
    profilePic = json?['profilePic'];
  }

 Map<String,dynamic> toJson() => {
    'fullName':fullName,
    'email':email,
    'userId':userId,
    'profilePic':profilePic
   };
}