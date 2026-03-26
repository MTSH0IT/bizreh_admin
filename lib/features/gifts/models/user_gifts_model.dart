class UserGiftsModel {
	int? id;
	int? userId;
	int? giftId;
	String? status;
	String? reason;
	DateTime? createdAt;
	String? giftTitle;
	String? giftArTitle;
	int? points;
	String? giftImage;
	String? firstName;
	String? lastName;
	String? email;
	String? phone;

	UserGiftsModel({
		this.id, 
		this.userId, 
		this.giftId, 
		this.status, 
		this.reason, 
		this.createdAt, 
		this.giftTitle, 
		this.giftArTitle, 
		this.points, 
		this.giftImage, 
		this.firstName, 
		this.lastName, 
		this.email, 
		this.phone, 
	});

	factory UserGiftsModel.fromJson(Map<String, dynamic> json) {
		return UserGiftsModel(
			id: json['id'] as int?,
			userId: json['user_id'] as int?,
			giftId: json['gift_id'] as int?,
			status: json['status'] as String?,
			reason: json['reason'] as String?,
			createdAt: json['created_at'] == null
						? null
						: DateTime.parse(json['created_at'] as String),
			giftTitle: json['gift_title'] as String?,
			giftArTitle: json['gift_ar_title'] as String?,
			points: json['points'] as int?,
			giftImage: json['gift_image'] as String?,
			firstName: json['first_name'] as String?,
			lastName: json['last_name'] as String?,
			email: json['email'] as String?,
			phone: json['phone'] as String?,
		);
	}



	Map<String, dynamic> toJson() => {
				'id': id,
				'user_id': userId,
				'gift_id': giftId,
				'status': status,
				'reason': reason,
				'created_at': createdAt?.toIso8601String(),
				'gift_title': giftTitle,
				'gift_ar_title': giftArTitle,
				'points': points,
				'gift_image': giftImage,
				'first_name': firstName,
				'last_name': lastName,
				'email': email,
				'phone': phone,
			};
}
