class UserInfo {
  final String name;
  final String ringShape;
  final String material;
  final String size;
  final String width;
  final String thickness;
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
      name: json['Name'],
      ringShape: json['RingShape'],
      material: json['Material'],
      size: json['Size'],
      width: json['Width'],
      thickness: json['Thickness'],
      dominantHand: json['DominantHand'],
      ringFingerJoint: json['RingFingerJoint'],
      frequencyOfRemoval: json['FrequencyOfRemoval'],
      sake: json['Sake'],
      fitPreference: json['FitPreference'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ringShape': ringShape,
      'material': material,
      'size': size,
      'width': width,
      'thickness': thickness,
      'dominantHand': dominantHand,
      'ringFingerJoint': ringFingerJoint,
      'frequencyOfRemoval': frequencyOfRemoval,
      'sake': sake,
      'fitPreference': fitPreference,
    };
  }
}
