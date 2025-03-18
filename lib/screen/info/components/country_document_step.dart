import 'package:flutter/material.dart';

class CountryDocumentStep extends StatelessWidget {
  final String selectedCountry;
  final String selectedDocumentType;
  final List<String> countries;
  final Map<String, List<String>> documentTypes;
  final Function(String) onCountryChanged;
  final Function(String) onDocumentTypeChanged;

  final Map<String, Color> countryColors = {
    'Uganda': Colors.red.shade50,
    'Kenya': Colors.green.shade100,
    'Tanzania': Color(0xFFF3E5F5),
    'Rwanda': Colors.blue.shade50,
    'Burundi': Color(0xFFFFF3E0),
  };

  final Map<String, Color> documentColors = {
    'Passport': Color(0xFFE8F5E9),
    'Driver`s License': Color(0xFFF3E5F5),
    'National ID': Color(0xFFE3F2FD),
    'Voter`s Card': Color(0xFFFFF3E0),
    // Add more document types with their colors
  };

  CountryDocumentStep({
    Key? key,
    required this.selectedCountry,
    required this.selectedDocumentType,
    required this.countries,
    required this.documentTypes,
    required this.onCountryChanged,
    required this.onDocumentTypeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select your country of residence',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Georgia',
            ),
          ),
          const SizedBox(height: 16),
          _buildCountryGrid(),
          const SizedBox(height: 32),
          const Text(
            'Select ID document type',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Georgia',
            ),
          ),
          const SizedBox(height: 16),
          _buildDocumentTypeGrid(),
          const SizedBox(height: 32),
          _buildRequirementsCard(),
        ],
      ),
    );
  }

  Widget _buildCountryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: countries.length,
      itemBuilder: (context, index) {
        final country = countries[index];
        final isSelected = country == selectedCountry;
        return _buildSelectableContainer(
          title: country,
          isSelected: isSelected,
          onTap: () => onCountryChanged(country),
          icon: Icons.flag_outlined,
        );
      },
    );
  }

  Widget _buildDocumentTypeGrid() {
    final documents = documentTypes[selectedCountry] ?? [];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final document = documents[index];
        final isSelected = document == selectedDocumentType;
        return _buildSelectableContainer(
          title: document,
          isSelected: isSelected,
          onTap: () => onDocumentTypeChanged(document),
          icon: Icons.document_scanner_outlined,
        );
      },
    );
  }

  Widget _buildSelectableContainer({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    Color getBackgroundColor() {
      if (isSelected) {
        return Colors.blue.shade50;
      }
      if (countryColors.containsKey(title)) {
        return countryColors[title]!;
      }
      if (documentColors.containsKey(title)) {
        return documentColors[title]!;
      }
      return Colors.white;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: getBackgroundColor(),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blue : Colors.grey.shade700,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.blue : Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (countryColors.containsKey(title))
                    Text(
                      'EA',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Text(
                'Document Requirements',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '• Document must be original and valid\n'
            '• All text must be clearly visible\n'
            '• No glare or shadows on the document\n'
            '• All corners of the document must be visible\n'
            '• Photos must be in color',
            style: TextStyle(color: Colors.blue.shade900, height: 1.5),
          ),
        ],
      ),
    );
  }
}
