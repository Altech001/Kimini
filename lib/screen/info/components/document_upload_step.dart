// ignore_for_file: use_build_context_synchronously, deprecated_member_use, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:image/image.dart' as img;
// import 'package:path_provider/path_provider.dart';

import 'image_preview_dialog.dart';

class DocumentUploadStep extends StatefulWidget {
  final String documentType;
  final Function(File?) onCaptureFront;
  final Function(File?) onCaptureBack;

  const DocumentUploadStep({
    super.key,
    required this.documentType,
    required this.onCaptureFront,
    required this.onCaptureBack,
  });

  @override
  State<DocumentUploadStep> createState() => _DocumentUploadStepState();
}

class _DocumentUploadStepState extends State<DocumentUploadStep> {
  File? frontImage;
  File? backImage;
  bool isFront = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Postion Your ${widget.documentType}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Gerogia',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Please upload clear, high-quality images of your document',
          style: TextStyle(color: Colors.grey.shade600, fontFamily: 'Gerogia'),
        ),
        const SizedBox(height: 16),
        _buildDocumentCard(
          'Front Side',
          'Click to upload front side\nAccepted formats: JPG, PNG, PDF',
          CupertinoIcons.camera,
          frontImage,
          (file) {
            setState(() => frontImage = file);
            widget.onCaptureFront(file);
          },
        ),
        const SizedBox(height: 16),
        _buildDocumentCard(
          'Back Side',
          'Click to upload back side\nAccepted formats: JPG, PNG, PDF',
          CupertinoIcons.camera_rotate,
          backImage,
          (file) {
            setState(() => backImage = file);
            widget.onCaptureBack(file);
          },
        ),
        const SizedBox(height: 20),
        _buildTipsCard(),
      ],
    );
  }

  Widget _buildDocumentCard(
    String title,
    String description,
    IconData icon,
    File? selectedFile,
    Function(File?) onFilePicked,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),

        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade50, Colors.white],
        ),
        border: Border.all(color: Colors.blue.shade400),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade50.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            try {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
                allowMultiple: false,
              );

              if (result != null) {
                File file = File(result.files.single.path!);
                // File file = File(result.files.single.path!);

                // Check file size (5MB limit)
                int fileSize = await file.length();
                if (fileSize > 5 * 1024 * 1024) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('File size must be less than 5MB'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Check if it's an image file
                bool isImage = [
                  'jpg',
                  'jpeg',
                  'png',
                ].contains(result.files.single.extension?.toLowerCase());

                if (!isImage &&
                    !result.files.single.path!.toLowerCase().endsWith('.pdf')) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a valid image or PDF file'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                onFilePicked(file);

                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$title Uploaded. $file.path'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } catch (e) {
              print('Error picking file: $e');
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error selecting file: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: Colors.blue.shade700),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Max file size: 5MB',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (selectedFile != null)
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => onFilePicked(null),
                        color: Colors.red,
                      ),
                  ],
                ),
                if (selectedFile != null) ...[
                  const SizedBox(height: 12),
                  if (selectedFile.path.toLowerCase().endsWith('.pdf'))
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade400),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.doc_chart,
                            size: 50,
                            color: Colors.red.shade400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'PDF ID',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              selectedFile.path.split('/').last,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => ImagePreviewDialog(
                                      imageFile: selectedFile,
                                      onImageUpdated: (File newFile) {
                                        onFilePicked(newFile);
                                      },
                                    ),
                              );
                            },
                            child: Image.file(
                              selectedFile,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.photo,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      selectedFile.path.split('/').last,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
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
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => ImagePreviewDialog(
                                            imageFile: selectedFile,
                                            onImageUpdated: (File newFile) {
                                              onFilePicked(newFile);
                                            },
                                          ),
                                    );
                                  },
                                  padding: const EdgeInsets.all(8),
                                  constraints: const BoxConstraints(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ] else ...[
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 12,
                      fontFamily: 'Gerogia',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Max 5MB',
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 12,
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTipsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tips_and_updates, color: Colors.amber.shade800),
              const SizedBox(width: 8),
              Text(
                'Tips for better photos',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.amber.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTipItem('Use good lighting'),
          _buildTipItem('Place on a dark background'),
          _buildTipItem('Ensure all corners are visible'),
          _buildTipItem('Avoid glare and shadows'),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.amber.shade700, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: TextStyle(color: Colors.amber.shade800)),
          ),
        ],
      ),
    );
  }
}
