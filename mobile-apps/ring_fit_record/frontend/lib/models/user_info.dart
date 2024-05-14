class UserInfo {
  final String name;
  final String ringShape;
  final String material;
  final String size;
  final double width;
  final double thickness;
  final String dominantHand;
  final String ringFingerJoint;
  final String frequencyOfRemoval;
  final String sake;
  final String fitPreference;

  UserInfo({
    required this.name,
    required this.ringShape,
    required this.material,
    required this.size,
    required this.width,
    required this.thickness,
    required this.dominantHand,
    required this.ringFingerJoint,
    required this.frequencyOfRemoval,
    required this.sake,
    required this.fitPreference,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      name: json['name'],
      ringShape: json['ringShape'],
      material: json['material'],
      size: json['size'],
      width: json['width'],
      thickness: json['thickness'],
      dominantHand: json['dominantHand'],
      ringFingerJoint: json['ringFingerJoint'],
      frequencyOfRemoval: json['frequencyOfRemoval'],
      sake: json['sake'],
      fitPreference: json['fitPreference'],
    );
  }
}
