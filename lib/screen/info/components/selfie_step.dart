import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'image_preview_dialog.dart';

class SelfieStep extends StatefulWidget {
  final Function(File?) onCaptureSelfie;

  const SelfieStep({Key? key, required this.onCaptureSelfie}) : super(key: key);

  @override
  State<SelfieStep> createState() => _SelfieStepState();
}

class _SelfieStepState extends State<SelfieStep> {
  File? selfieImage;

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result != null) {
        File file = File(result.files.single.path!);

        // Check file size (5MB limit)
        int fileSize = await file.length();
        if (fileSize > 5 * 1024 * 1024) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File size must be less than 5MB'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        setState(() => selfieImage = file);
        widget.onCaptureSelfie(file);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selfie uploaded successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error picking selfie: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting selfie: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                selfieImage == null ? Colors.blue.shade50 : Colors.red.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  selfieImage == null
                      ? Colors.blue.shade200
                      : Colors.red.shade100,
            ),
          ),
          child:
              selfieImage != null
                  ? Row(
                    children: [
                      Icon(
                        CupertinoIcons.checkmark_seal,
                        color: Colors.red.shade500,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Make sure the image proper and clear, You can edit or replace the image if needed.',
                          style: TextStyle(
                            color: Colors.red.shade500,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  )
                  : Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'We need to verify that you are the owner of the document. Please upload a clear photo of your face.',
                          style: TextStyle(
                            color: Colors.blue.shade900,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
        ),
        const SizedBox(height: 24),
        InkWell(
          onTap: _pickImage,
          child: Container(
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade300),
              borderRadius: BorderRadius.circular(12),
              color: Colors.blue.shade50,
            ),
            child:
                selfieImage != null
                    ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(11),
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => ImagePreviewDialog(
                                      imageFile: selfieImage!,
                                      onImageUpdated: (File newFile) {
                                        setState(() => selfieImage = newFile);
                                        widget.onCaptureSelfie(newFile);
                                      },
                                    ),
                              );
                            },
                            child: Image.file(
                              selfieImage!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => ImagePreviewDialog(
                                            imageFile: selfieImage!,
                                            onImageUpdated: (File newFile) {
                                              setState(
                                                () => selfieImage = newFile,
                                              );
                                              widget.onCaptureSelfie(newFile);
                                            },
                                          ),
                                    );
                                  },
                                  padding: const EdgeInsets.all(8),
                                  constraints: const BoxConstraints(),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() => selfieImage = null);
                                    widget.onCaptureSelfie(null);
                                  },
                                  padding: const EdgeInsets.all(8),
                                  constraints: const BoxConstraints(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                    : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade500,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              CupertinoIcons.camera_viewfinder,
                              size: 50,
                              color: Colors.blue.shade50,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Click to upload selfie',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Georgia',
                              color: Colors.blue.shade500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'JPG or PNG format only',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                              fontFamily: 'Gerogia',
                            ),
                          ),
                        ],
                      ),
                    ),
          ),
        ),
        if (selfieImage != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green.shade700,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selfie uploaded successfully',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'You can edit or replace the image if needed',
                        style: TextStyle(
                          color: Colors.green.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.image,
                    color: Colors.blue.shade700,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'File Details',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        selfieImage?.path ?? '',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 24),
        selfieImage == null ? _buildGuidelinesCard() : const SizedBox(),
      ],
    );
  }

  Widget _buildGuidelinesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.red.shade50, Colors.orange.shade50],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.red.shade400,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Important Guidelines',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildGuidelineItem(
            CupertinoIcons.person_crop_circle,
            'Look directly at the camera',
          ),
          _buildGuidelineItem(
            Icons.wb_sunny_outlined,
            'Good lighting on your face',
          ),
          _buildGuidelineItem(
            Icons.remove_red_eye,
            'Keep eyes open and visible',
          ),
          _buildGuidelineItem(Icons.do_not_disturb, 'No sunglasses or hats'),
        ],
      ),
    );
  }

  Widget _buildGuidelineItem(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        // color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.red.shade700),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.red.shade700,
                fontWeight: FontWeight.w200,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
