class Place {
  int? id;
  String? bannerImage;
  String? title;
  String? content;
  String? latitude;
  String? longitude;

  Place(
      {this.id,
      this.bannerImage,
      this.title,
      this.content,
      this.latitude,
      this.longitude});

  Place.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bannerImage = json['bannerImage'];
    title = json['title'];
    content = json['content'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bannerImage'] = this.bannerImage;
    data['title'] = this.title;
    data['content'] = this.content;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}