class UserModel {
  String id;
  String type;
  String name;
  String user;
  String password;
  String createDate;
  String address;
  String phone;
  String gendel;
  String education;

  UserModel(
      {this.id,
      this.type,
      this.name,
      this.user,
      this.password,
      this.createDate,
      this.address,
      this.phone,
      this.gendel,
      this.education});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['Type'];
    name = json['Name'];
    user = json['User'];
    password = json['Password'];
    createDate = json['CreateDate'];
    address = json['Address'];
    phone = json['Phone'];
    gendel = json['Gendel'];
    education = json['Education'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Type'] = this.type;
    data['Name'] = this.name;
    data['User'] = this.user;
    data['Password'] = this.password;
    data['CreateDate'] = this.createDate;
    data['Address'] = this.address;
    data['Phone'] = this.phone;
    data['Gendel'] = this.gendel;
    data['Education'] = this.education;
    return data;
  }
}
