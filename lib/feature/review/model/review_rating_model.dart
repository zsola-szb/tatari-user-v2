import 'package:tatarigigs_user/util/core_export.dart';

class ReviewRatingModel {
  final List<CustomerReview> reviews;
  final Rating? rating;
  final int? totalSize;
  final int? limit;
  final int? offset;

  const ReviewRatingModel({
    this.reviews = const <CustomerReview>[],
    this.rating,
    this.totalSize,
    this.limit,
    this.offset,
  });

  factory ReviewRatingModel.fromJson(Map<String, dynamic> json) {
    final dynamic reviews = json['data'];
    final dynamic rating = json['rating'];

    return ReviewRatingModel(
      reviews: reviews is List
          ? reviews.whereType<Map<String, dynamic>>().map(CustomerReview.fromJson).toList()
          : const <CustomerReview>[],
      rating: rating is Map<String, dynamic> ? Rating.fromJson(rating) : null,
      totalSize: int.tryParse('${json['total_size']}'),
      limit: int.tryParse('${json['limit']}'),
      offset: int.tryParse('${json['offset']}'),
    );
  }
}

class CustomerReview {
  final String id;
  final int? readableId;
  final double reviewRating;
  final String reviewComment;
  final List<String> reviewImages;
  final ReviewCustomer? customer;
  final String? createdAt;
  final String? updatedAt;
  final ReviewReply? reviewReply;

  const CustomerReview({
    this.id = '',
    this.readableId,
    this.reviewRating = 0,
    this.reviewComment = '',
    this.reviewImages = const <String>[],
    this.customer,
    this.createdAt,
    this.updatedAt,
    this.reviewReply,
  });

  static ReviewReply? _parseReply(dynamic reply) {
    if(reply is Map<String, dynamic>){
      return ReviewReply.fromJson(reply);
    }

    final String replyText = reply?.toString().trim() ?? '';
    return replyText.isEmpty ? null : ReviewReply(reply: replyText);
  }

  factory CustomerReview.fromJson(Map<String, dynamic> json) {
    final dynamic customer = json['customer'];
    final dynamic reviewImages = json['review_images'];

    return CustomerReview(
      id: json['id']?.toString() ?? '',
      readableId: int.tryParse('${json['readable_id']}'),
      reviewRating: double.tryParse('${json['review_rating']}') ?? 0,
      reviewComment: json['review_comment']?.toString() ?? '',
      reviewImages: reviewImages is List ? reviewImages.whereType<String>().toList() : const <String>[],
      customer: customer is Map<String, dynamic> ? ReviewCustomer.fromJson(customer) : null,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      reviewReply: _parseReply(json['review_reply']),
    );
  }

  String get ratingLabel => reviewRating == reviewRating.roundToDouble()
      ? reviewRating.toStringAsFixed(0) : reviewRating.toStringAsFixed(1);

  bool get hasReply => (reviewReply?.reply ?? '').isNotEmpty;
}

class ReviewCustomer {
  final String firstName;
  final String imageFullUrl;

  const ReviewCustomer({this.firstName = '', this.imageFullUrl = ''});

  factory ReviewCustomer.fromJson(Map<String, dynamic> json) => ReviewCustomer(
        firstName: json['f_name']?.toString() ?? '',
        imageFullUrl: json['image_full_url']?.toString() ?? '',
      );
}
