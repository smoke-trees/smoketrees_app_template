
class AppUpdate {
  String? softUpdateMinimumVersionAndroid;
  String? softUpdateMinimumVersionIos;
  String? forceUpdateMinimumVersionAndroid;
  String? forceUpdateMinimumVersionIos;

  AppUpdate({
    this.softUpdateMinimumVersionAndroid,
    this.softUpdateMinimumVersionIos,
    this.forceUpdateMinimumVersionAndroid,
    this.forceUpdateMinimumVersionIos,
  });

  factory AppUpdate.fromJson(Map<String, dynamic> json) => AppUpdate(
    softUpdateMinimumVersionAndroid: json["softUpdateMinimumVersionAndroid"],
    softUpdateMinimumVersionIos: json["softUpdateMinimumVersionIos"],
    forceUpdateMinimumVersionAndroid: json["forceUpdateMinimumVersionAndroid"],
    forceUpdateMinimumVersionIos: json["forceUpdateMinimumVersionIos"],
  );

  Map<String, dynamic> toJson() => {
    "softUpdateMinimumVersionAndroid": softUpdateMinimumVersionAndroid,
    "softUpdateMinimumVersionIos": softUpdateMinimumVersionIos,
    "forceUpdateMinimumVersionAndroid": forceUpdateMinimumVersionAndroid,
    "forceUpdateMinimumVersionIos": forceUpdateMinimumVersionIos,
  };
}
