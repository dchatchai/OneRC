class BannerModel {
  String id;
  String name;
  String detail;
  String url;

  BannerModel({this.id, this.name, this.detail, this.url});

  BannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['Name'];
    detail = json['Detail'];
    url = json['Url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Name'] = this.name;
    data['Detail'] = this.detail;
    data['Url'] = this.url;
    return data;
  }
}
