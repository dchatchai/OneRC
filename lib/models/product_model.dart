class ProductModel {
  String id;
  String idShop;
  String nameShop;
  String name;
  String price;
  String detail;
  String pathImage;
  String code;

  ProductModel(
      {this.id,
      this.idShop,
      this.nameShop,
      this.name,
      this.price,
      this.detail,
      this.pathImage,
      this.code});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idShop = json['IdShop'];
    nameShop = json['NameShop'];
    name = json['Name'];
    price = json['Price'];
    detail = json['Detail'];
    pathImage = json['PathImage'];
    code = json['Code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['IdShop'] = this.idShop;
    data['NameShop'] = this.nameShop;
    data['Name'] = this.name;
    data['Price'] = this.price;
    data['Detail'] = this.detail;
    data['PathImage'] = this.pathImage;
    data['Code'] = this.code;
    return data;
  }
}
