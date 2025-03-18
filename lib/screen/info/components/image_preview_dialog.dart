// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ImagePreviewDialog extends StatefulWidget {
  final File imageFile;
  final Function(File) onImageUpdated;

  const ImagePreviewDialog({
    Key? key,
    required this.imageFile,
    required this.onImageUpdated,
  }) : super(key: key);

  @override
  State<ImagePreviewDialog> createState() => _ImagePreviewDialogState();
}

class _ImagePreviewDialogState extends State<ImagePreviewDialog>
    with SingleTickerProviderStateMixin {
  late PhotoViewController _controller;
  double _rotation = 0;
  double _brightness = 0;
  double _contrast = 1;
  bool _isProcessing = false;
  String? _qualityAssessment;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _controller =
        PhotoViewController()..outputStateStream.listen(_onViewerState);
    _tabController = TabController(length: 3, vsync: this);
    _assessImageQuality();
  }

  void _onViewerState(PhotoViewControllerValue value) {
    setState(() {
      _rotation = value.rotation;
    });
  }

  Future<void> _assessImageQuality() async {
    setState(() => _isProcessing = true);

    try {
      final bytes = await widget.imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        setState(() => _qualityAssessment = 'Unable to analyze image');
        return;
      }

      // Basic quality checks
      final resolution = image.width * image.height;
      final aspectRatio = image.width / image.height;
      final fileSize = await widget.imageFile.length();

      String quality = 'Good';
      List<String> issues = [];

      if (resolution < 1000000) issues.add('Low resolution');
      if (fileSize < 50000) issues.add('Low file size');
      if (aspectRatio < 0.5 || aspectRatio > 2)
        issues.add('Unusual aspect ratio');

      if (issues.isNotEmpty) {
        quality = 'Fair';
        if (issues.length > 1) quality = 'Poor';
      }

      setState(() => _qualityAssessment = '$quality - ${issues.join(', ')}');
    } catch (e) {
      setState(() => _qualityAssessment = 'Error analyzing image');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _saveProcessedImage() async {
    setState(() => _isProcessing = true);

    try {
      final bytes = await widget.imageFile.readAsBytes();
      var image = img.decodeImage(bytes);

      if (image == null) return;

      // Apply rotation if needed
      if (_rotation != 0) {
        final rotationDegrees = (_rotation * 180 / 3.14159).round();
        if (rotationDegrees != 0) {
          image = img.copyRotate(image, angle: rotationDegrees);
        }
      }

      // Apply brightness and contrast adjustments
      if (_brightness != 0 || _contrast != 1) {
        image = img.adjustColor(
          image,
          brightness: _brightness,
          contrast: _contrast,
        );
      }

      // Maintain quality unless file is too large
      final quality =
          await widget.imageFile.length() > 2 * 1024 * 1024 ? 85 : 95;

      // Encode with proper orientation
      final processed = img.encodeJpg(image, quality: quality);

      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
        '${tempDir.path}/processed_${DateTime.now().millisecondsSinceEpoch}.png',
      );

      await tempFile.writeAsBytes(processed);

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Image saved successfully'),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );

      widget.onImageUpdated(tempFile);
      Navigator.of(context).pop();
    } catch (e) {
      print('Error processing image: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to process image'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  _buildHeaderButton(
                    Icons.close_rounded,
                    Colors.grey.shade200,
                    Colors.grey.shade700,
                    () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Image Retouch',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Gerogia',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  _buildHeaderButton(
                    CupertinoIcons.checkmark_seal,
                    Colors.blue.shade500,
                    Colors.white,
                    _isProcessing ? null : _saveProcessedImage,
                  ),
                ],
              ),
            ),

            // Image Preview Area
            Flexible(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      PhotoView(
                        controller: _controller,
                        imageProvider: FileImage(widget.imageFile),
                        backgroundDecoration: BoxDecoration(
                          color: Colors.grey.shade50,
                        ),
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.covered * 2,
                      ),
                      if (_qualityAssessment != null)
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _getQualityColor().withOpacity(0.95),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getQualityIcon(),
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _qualityAssessment!.split(' - ')[0],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (_isProcessing)
                        Container(
                          color: Colors.black26,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue.shade400,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Saving changes...',
                                    style: TextStyle(
                                      color: Colors.grey.shade800,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Controls Panel
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildControlSlider(
                    icon: Icons.rotate_right_rounded,
                    label: 'Rotation',
                    value: _rotation,
                    min: -3.14159,
                    max: 3.14159,
                    onChanged: (value) {
                      _controller.rotation = value;
                      setState(() => _rotation = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildControlSlider(
                    icon: Icons.brightness_6_rounded,
                    label: 'Brightness',
                    value: _brightness,
                    min: -1,
                    max: 1,
                    onChanged: (value) => setState(() => _brightness = value),
                  ),
                  const SizedBox(height: 16),
                  _buildControlSlider(
                    icon: Icons.contrast_rounded,
                    label: 'Contrast',
                    value: _contrast,
                    min: 0.5,
                    max: 1.5,
                    onChanged: (value) => setState(() => _contrast = value),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderButton(
    IconData icon,
    Color backgroundColor,
    Color iconColor,
    VoidCallback? onPressed,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, color: iconColor, size: 20),
        onPressed: onPressed,
        padding: const EdgeInsets.all(10),
        constraints: const BoxConstraints(minHeight: 36, minWidth: 36),
      ),
    );
  }

  Widget _buildControlSlider({
    required IconData icon,
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey.shade700),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: Colors.blue.shade400,
            inactiveTrackColor: Colors.grey.shade200,
            thumbColor: Colors.white,
            overlayColor: Colors.blue.shade200.withOpacity(0.2),
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 8,
              elevation: 2,
            ),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: Slider(value: value, min: min, max: max, onChanged: onChanged),
        ),
      ],
    );
  }

  Color _getQualityColor() {
    if (_qualityAssessment?.startsWith('Good') ?? false) return Colors.green;
    if (_qualityAssessment?.startsWith('Fair') ?? false) return Colors.orange;
    return Colors.red;
  }

  IconData _getQualityIcon() {
    if (_qualityAssessment?.startsWith('Good') ?? false) {
      return Icons.check_circle_rounded;
    }
    if (_qualityAssessment?.startsWith('Fair') ?? false) {
      return Icons.info_rounded;
    }
    return Icons.warning_rounded;
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose();
    super.dispose();
  }
}
