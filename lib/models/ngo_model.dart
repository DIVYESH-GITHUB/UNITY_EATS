class NgoModel {
  String? name;
  String? email;
  String? phoneNumber;
  String? ngoType;
  String? address;
  String? country;
  String? state;
  String? city;
  bool? isEmailVerified;
  bool? isNgoVerified;

  NgoModel({
    this.name,
    this.email,
    this.phoneNumber,
    this.ngoType,
    this.address,
    this.country,
    this.state,
    this.city,
    this.isEmailVerified,
    this.isNgoVerified,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'ngoType': ngoType,
      'address': address,
      'country': country,
      'state': state,
      'city': city,
      'isEmailVerified': isEmailVerified,
      'isNgoVerified': isNgoVerified,
    };
  }

  static NgoModel fromMap(Map<String, dynamic> map) {
    return NgoModel(
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      ngoType: map['ngoType'],
      address: map['address'],
      country: map['country'],
      state: map['state'],
      city: map['city'],
      isEmailVerified: map['isEmailVerified'],
      isNgoVerified: map['isNgoVerified'],
    );
  }
}
