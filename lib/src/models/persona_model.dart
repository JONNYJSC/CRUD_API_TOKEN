import 'dart:convert';

class PersonModel {
  List<Persona> data;
  int total;

  PersonModel({this.data, this.total});

  PersonModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Persona>();
      json['data'].forEach((v) {
        data.add(new Persona.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class Persona {
  Name name;
  String sId;
  String gender;
  String email;
  String cellphone;
  List<Pictures> pictures;
  String createdAt;
  String updatedAt;
  int iV;

  Persona(
      {this.name,
      this.sId,
      this.gender,
      this.email,
      this.cellphone,
      this.pictures,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Persona.fromJson(Map<String, dynamic> json) {
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    sId = json['_id'];
    gender = json['gender'];
    email = json['email'];
    cellphone = json['cellphone'];
    if (json['pictures'] != null) {
      pictures = new List<Pictures>();
      json['pictures'].forEach((v) {
        pictures.add(new Pictures.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    data['_id'] = this.sId;
    data['gender'] = this.gender;
    data['email'] = this.email;
    data['cellphone'] = this.cellphone;
    if (this.pictures != null) {
      data['pictures'] = this.pictures.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Name {
  String first;
  String last;

  Name({this.first, this.last});

  Name.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first'] = this.first;
    data['last'] = this.last;
    return data;
  }
}

class Pictures {
  String sId;
  String url;
  String date;

  Pictures({this.sId, this.url, this.date});

  Pictures.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    url = json['url'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['url'] = this.url;
    data['date'] = this.date;
    return data;
  }
}

String personaToJson(Persona data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}