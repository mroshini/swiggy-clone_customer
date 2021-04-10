class DeliveryAddressSharedPrefModel {
  String addressId;
  String latitude;
  String longitude;
  String address;
  String state;
  String city;
  String building;
  String landmark;
  String addressType;
  String distance;
  String durationText;

  DeliveryAddressSharedPrefModel({
    this.addressId,
    this.latitude,
    this.longitude,
    this.building,
    this.landmark,
    this.address,
    this.state,
    this.addressType,
    this.city,
    this.distance,
    this.durationText,
  });

  DeliveryAddressSharedPrefModel.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'] == null ? null : json['latitude'];
    longitude = json['longitude'] == null ? null : json['longitude'];
    building = json['building'] == null ? null : json['building'];
    landmark = json['landmark'] == null ? null : json['landmark'];
    address = json['address'] == null ? null : json['address'];
    state = json['state'] == null ? null : json['state'];
    addressType = json['addressType'] == null ? null : json['addressType'];
    city = json['city'] == null ? null : json['city'];
    distance = json['distance'] == null ? null : json['distance'];
    addressId = json['addressId'] == null ? null : json['addressId'];
    durationText = json['durationText'] == null ? null : json['durationText'];
  }

  Map<String, dynamic> toJson() => {
        'latitude': latitude == null ? null : latitude,
        'longitude': longitude == null ? null : longitude,
        'building': building == null ? null : building,
        'landmark': landmark == null ? null : landmark,
        'address': address == null ? null : address,
        'state': state == null ? null : state,
        'addressType': addressType == null ? null : addressType,
        'city': city == null ? null : city,
        'distance': distance == null ? null : distance,
        'addressId': addressId == null ? null : addressId,
        'durationText': durationText == null ? null : durationText,
      };
}
