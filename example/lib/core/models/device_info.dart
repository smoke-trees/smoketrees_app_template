class DeviceInfo {
  final String? id;
  final String? userId;
  final String? fcmToken;
  final String? deviceId;
  final String? os;
  final String? currentUserVersion;
  final String? currentUserBuildNumber;

  DeviceInfo({
    this.id,
    this.userId,
    this.fcmToken,
    this.deviceId,
    this.os,
    this.currentUserVersion,
    this.currentUserBuildNumber,
  });

  DeviceInfo copyWith({
    String? id,
    String? userId,
    String? fcmToken,
    String? deviceId,
    String? os,
    String? currentUserVersion,
    String? currentUserBuildNumber,
  }) => DeviceInfo(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    fcmToken: fcmToken ?? this.fcmToken,
    deviceId: deviceId ?? this.deviceId,
    os: os ?? this.os,
    currentUserVersion: currentUserVersion ?? this.currentUserVersion,
    currentUserBuildNumber:
        currentUserBuildNumber ?? this.currentUserBuildNumber,
  );

  // Convert a DeviceInfo object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'fcmToken': fcmToken,
      'deviceId': deviceId,
      'os': os,
      'currentUserVersion': currentUserVersion,
      'currentUserBuildNumber': currentUserBuildNumber,
    };
  }

  // Create a DeviceInfo object from a JSON map
  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      id: json['id'],
      userId: json['userId'],
      fcmToken: json['fcmToken'],
      deviceId: json['deviceId'],
      os: json['os'],
      currentUserVersion: json['currentUserVersion'],
      currentUserBuildNumber: json['currentUserBuildNumber'],
    );
  }
}
