class OrderModel {
  String id;
  String idUser;
  String nameUser;
  String dateTimeOrder;
  String idShop;
  String nameShop;
  String idProduct;
  String nameProduct;
  String price;
  String amount;
  String sum;

  OrderModel(
      {this.id,
      this.idUser,
      this.nameUser,
      this.dateTimeOrder,
      this.idShop,
      this.nameShop,
      this.idProduct,
      this.nameProduct,
      this.price,
      this.amount,
      this.sum});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idUser = json['idUser'];
    nameUser = json['nameUser'];
    dateTimeOrder = json['dateTimeOrder'];
    idShop = json['idShop'];
    nameShop = json['nameShop'];
    idProduct = json['idProduct'];
    nameProduct = json['nameProduct'];
    price = json['price'];
    amount = json['amount'];
    sum = json['sum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idUser'] = this.idUser;
    data['nameUser'] = this.nameUser;
    data['dateTimeOrder'] = this.dateTimeOrder;
    data['idShop'] = this.idShop;
    data['nameShop'] = this.nameShop;
    data['idProduct'] = this.idProduct;
    data['nameProduct'] = this.nameProduct;
    data['price'] = this.price;
    data['amount'] = this.amount;
    data['sum'] = this.sum;
    return data;
  }
}
