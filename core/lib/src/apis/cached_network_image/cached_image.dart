import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String? url;
  // final XFile? file;

  final double? size;

  final Color? color;

  const CachedImage(
    String this.url, {
    super.key,
    this.color,
    this.size,
  });

  // const CachedImage.xFile(
  //   XFile this.file, {
  //   super.key,
  //   this.color,
  //   this.size,
  // }) : url = null;

  Widget _buildSafe(Widget child) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: AlignmentDirectional.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }

  Widget _buildLoading(BuildContext context, String url, DownloadProgress progress) {
    return _buildSafe(CircularProgressIndicator(
      value: progress.progress,
    ));
  }

  Widget _buildError(BuildContext context, String url, Object? error) {
    return _buildSafe(const Icon(Icons.error_outline));
  }

  Widget _buildByUrl(BuildContext context, String url) {
    return CachedNetworkImage(
      imageUrl: url,
      color: color,
      progressIndicatorBuilder: _buildLoading,
      errorWidget: _buildError,
      height: size,
      width: size,
    );
  }

  // Widget _buildByXFile(BuildContext context, XFile file) {
  //   if (file.path.startsWith('https://')) {
  //     return _buildByUrl(context, file.path);
  //   } else {
  //     return Image(
  //       image: XFileImage(file),
  //       color: color,
  //       height: size,
  //       width: size,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (url != null) return _buildByUrl(context, url!);
    // if (file != null) return _buildByXFile(context, file!);
    throw StateError('Missing url and file.');
  }
}
