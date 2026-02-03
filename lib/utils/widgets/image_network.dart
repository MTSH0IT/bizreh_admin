import 'package:bizreh_admin/utils/consts/const_key.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageNetwork extends StatelessWidget {
  const ImageNetwork({
    super.key,
    required this.image,
    this.icon = Icons.image_not_supported,
  });
  final String image;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: JsonKey.urlImageUploads + image,
      placeholder: (context, url) => const BuildProgressIndicator(),
      errorWidget: (context, url, error) =>
          Icon(icon, size: 40, color: Colors.black54),
      fit: BoxFit.contain,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
