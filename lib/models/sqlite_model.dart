class SqliteModel {
  int id;
  String idShop;
  String nameShop;
  String idProduct;
  String nameProduct;
  String price;
  String amountString;
  String sumString;

  SqliteModel(
      {this.id,
      this.idShop,
      this.nameShop,
      this.idProduct,
      this.nameProduct,
      this.price,
      this.amountString,
      this.sumString});

  SqliteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idShop = json['idShop'];
    nameShop = json['nameShop'];
    idProduct = json['idProduct'];
    nameProduct = json['nameProduct'];
    price = json['price'];
    amountString = json['amountString'];
    sumString = json['sumString'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idShop'] = this.idShop;
    data['nameShop'] = this.nameShop;
    data['idProduct'] = this.idProduct;
    data['nameProduct'] = this.nameProduct;
    data['price'] = this.price;
    data['amountString'] = this.amountString;
    data['sumString'] = this.sumString;
    return data;
  }
}
