class SalesModel {
  String id;
  String xvalue;
  String yvalue;

  SalesModel({this.id, this.xvalue, this.yvalue});

  SalesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    xvalue = json['xvalue'];
    yvalue = json['yvalue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['xvalue'] = this.xvalue;
    data['yvalue'] = this.yvalue;
    return data;
  }
}
