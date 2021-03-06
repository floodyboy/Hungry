/// Google API

/// Holds each restaurant and stores its information.
class Restaurant {
  double lat, lon;
  num rating;
  String address,
      id,
      placeID,
      icon,
      name,
      googleMapsLink,
      photoReference,
      website,
      phoneNumber;
  bool open_now;
  int price_level;
  List<dynamic> openingHours;
  Map<String, double> preferences;
  List<String> cuisine = [];

  Restaurant.fromJson(Map<String, dynamic> json) {
    this.name = json['name'];
    this.lat = json['geometry']['location']['lat'];
    this.lon = json['geometry']['location']['lng'];
    this.rating = json['rating'];
    this.address = json['vicinity'];
    this.id = json['id'];
    this.icon = json['icon'];
    try {
      this.googleMapsLink = json['photos'][0]['html_attributions'][0].substring(
          json['photos'][0]['html_attributions'][0].indexOf("\"") + 1,
          json['photos'][0]['html_attributions'][0].lastIndexOf("\""));
      this.photoReference = json['photos'][0]['photo_reference'];
      this.open_now = json['opening_hours']['open_now'];
    } catch (e) {
      print(e);
    }
    this.placeID = json['place_id'];
    //this.price_level = json['price_level'];
  }

  setPlaceDetails(
      List<dynamic> openingHours, String phoneNumber, String website) {
    this.openingHours = openingHours;
    this.website = website;
    this.phoneNumber = phoneNumber;
  }
}
