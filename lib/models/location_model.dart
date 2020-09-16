class LocationModel {
  String id;
  String name;
  String dateTime;
  String lat;
  String lng;

  LocationModel({this.id, this.name, this.dateTime, this.lat, this.lng});

  LocationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['Name'];
    dateTime = json['DateTime'];
    lat = json['Lat'];
    lng = json['Lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Name'] = this.name;
    data['DateTime'] = this.dateTime;
    data['Lat'] = this.lat;
    data['Lng'] = this.lng;
    return data;
  }
}
