import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences.dart';

class AddressStep extends StatelessWidget {
  final VoidCallback onUploadDocument;

  const AddressStep({super.key, required this.onUploadDocument});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          'Upload a document that proves your current address. The document should be less than 3 months old.',
          style: TextStyle(color: Colors.grey.shade700, fontFamily: 'Georgia'),
        ),
        const SizedBox(height: 24),
        _buildAcceptedDocumentsCard(),
        const SizedBox(height: 24),
        InkWell(
          onTap: onUploadDocument,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade400),
              borderRadius: BorderRadius.circular(12),
              color: Colors.blue.shade50,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                    shape: BoxShape.rectangle,
                  ),
                  child: Icon(
                    CupertinoIcons.arrow_up_doc,
                    size: 40,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Upload Document',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Georgia',
                    fontWeight: FontWeight.w500,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'JPG, PNG or PDF format ',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                        fontFamily: 'Georgia',
                      ),
                    ),
                    Text(
                      '(Max 5MB)',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildRequirementsCard(),
      ],
    );
  }

  Widget _buildAcceptedDocumentsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade400),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.label_important, color: Colors.green.shade800),
              const SizedBox(width: 8),
              Text(
                'Acceptable documents include:',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildDocumentItem('Utility bill (water, electricity, gas)'),
          _buildDocumentItem('Bank statement'),
          _buildDocumentItem('Tax statement'),
          _buildDocumentItem('Rental agreement'),
          _buildDocumentItem('Insurance policy'),
        ],
      ),
    );
  }

  Widget _buildDocumentItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 18, color: Colors.green.shade400),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Georgia',
                color: Colors.green.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.amber.shade800),
              const SizedBox(width: 8),
              Text(
                'Important Notes',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildRequirementItem('Document must be less than 3 months old'),
          _buildRequirementItem('Address must match your current residence'),
          _buildRequirementItem(
            'Document must be in English or officially translated',
          ),
          _buildRequirementItem('Digital copies must be clear and complete'),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.arrow_right, size: 20, color: Colors.amber.shade800),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.amber.shade900,
                fontFamily: 'Georgia',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Future<void> _saveAddressData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   // await prefs.setString('address', addressController.text);
  //   // await prefs.setString('city', cityController.text);
  //   // Add other fields as needed
  // }

  // void _handleSubmit() async {
  //   // if (_formKey.currentState!.validate()) {
  //   //   await _saveAddressData();
  //   //   // ... existing submit code ...
  //   // }
  // }
}
