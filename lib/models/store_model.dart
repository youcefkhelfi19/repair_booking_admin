class Store {
   String name;
   String facebook;
   String phone;
   String location;

  Store( {required this.name, required this.facebook, required this.phone, required this.location});

  factory Store.fromJson(Map<String, dynamic> json) => Store(
    name: json["name"],
    facebook: json["facebook"],
    phone: json["phone"],
    location: json["location"],

  );
  Map<String, dynamic> toJson() => {
    "name": name,
    "facebook": facebook,
    "phone": phone,
    "location": location,
  };
}
