import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../components/custom_address.dart';
import '../components/custom_text_field.dart';
import '../components/section_header.dart';
import '../components/pdf_preview_dialog.dart';

class CustomerDetailsScreen extends StatefulWidget {
  const CustomerDetailsScreen({Key? key}) : super(key: key);

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  // Address
  String _selectedDistrict = 'Select a district';
  //Nationality
  String _selectedCountry = 'Select your Country';

  void _showAddressDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CountryAddressDialog(
          onAddressSelected: (country, location) {
            setState(() {
              _selectedDistrict = location;
              _selectedCountry = country;
            });
            print('Selected: $country - $location');
          },
        );
      },
    );
  }

  final Map<String, TextEditingController> controllers = {
    'surname': TextEditingController(),
    'givenName': TextEditingController(),
    'email': TextEditingController(),
    'phone': TextEditingController(),
    'dob': TextEditingController(),
    'nationality': TextEditingController(),
    'idNumber': TextEditingController(),
    'occupation': TextEditingController(),
  };
  DateTime? _selectedDate;
  String _selectedGender = 'Male';
  // String _selectedDistrict = '' ;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 10),

            _buildPersonalInfo(),
            const SizedBox(height: 32),
            const SectionHeader(
              title: 'Contact Details',
              subtitle: 'How can we reach you?',
            ),
            _buildContactInfo(),
            const SizedBox(height: 32),
            const SectionHeader(
              title: 'Additional Information',
              subtitle: 'Please provide your KYC details',
            ),
            _buildKYCInfo(),
            const SizedBox(height: 40),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      // padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              CupertinoIcons.person_add,
              size: 20,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SectionHeader(
              //   title: 'Personal Information',
              //   subtitle: 'Please provide your basic information',
              // ),
              Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia',
                ),
              ),
              Text(
                'Fill in your information',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'Surname',
                icon: Icons.person_outline,
                controller: controllers['surname']!,
                validator:
                    (value) =>
                        value?.isEmpty ?? true ? 'Please enter surname' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                label: 'Given Name',
                icon: Icons.person_outline,
                controller: controllers['givenName']!,
                validator:
                    (value) =>
                        value?.isEmpty ?? true
                            ? 'Please enter given name'
                            : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildGenderSelection(),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Date of Birth',
          icon: Icons.calendar_today,
          controller: controllers['dob']!,
          readOnly: true,
          onTap: _showDatePicker,
          validator:
              (value) =>
                  value?.isEmpty ?? true ? 'Please select date of birth' : null,
        ),
      ],
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gender',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontFamily: 'Georgia',
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildGenderOption('Male', Icons.male),
            const SizedBox(width: 16),
            _buildGenderOption('Female', Icons.female),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderOption(String gender, IconData icon) {
    final isSelected = _selectedGender == gender;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedGender = gender),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade50 : Colors.grey.shade50,
            border: Border.all(
              color: isSelected ? Colors.blue.shade700 : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.blue.shade700 : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                gender,
                style: TextStyle(
                  color: isSelected ? Colors.blue.shade700 : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo() {
    return Column(
      children: [
        CustomTextField(
          label: 'Phone Number',
          icon: Icons.phone_outlined,
          controller: controllers['phone']!,
          keyboardType: TextInputType.phone,
          validator:
              (value) =>
                  value?.isEmpty ?? true ? 'Please enter phone number' : null,
        ),
        CustomTextField(
          label: 'Email Address',
          icon: Icons.email_outlined,
          controller: controllers['email']!,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Please enter email address';
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildKYCInfo() {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nationality',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontFamily: 'Georgia',
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 45,
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _showAddressDialog,
                icon: Icon(
                  Icons.location_on_outlined,
                  size: 20,
                  color: Colors.black,
                ),
                label: Text(
                  _selectedCountry,
                  style: TextStyle(
                    color:
                        _selectedDistrict == 'Select a district'
                            ? Colors.grey
                            : Colors.black87,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
        CustomTextField(
          label: 'ID Number',
          icon: Icons.badge_outlined,
          controller: controllers['idNumber']!,
          validator:
              (value) =>
                  value?.isEmpty ?? true ? 'Please enter ID number' : null,
        ),
        CustomTextField(
          label: 'Occupation',
          icon: Icons.work_outline,
          controller: controllers['occupation']!,
          validator:
              (value) =>
                  value?.isEmpty ?? true ? 'Please enter occupation' : null,
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Address',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontFamily: 'Georgia',
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 45,
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.location_on_outlined,
                  size: 20,
                  color: Colors.black,
                ),
                label: Text(
                  _selectedDistrict,
                  style: TextStyle(
                    color:
                        _selectedDistrict == 'Select a district'
                            ? Colors.grey
                            : Colors.black87,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(Icons.preview_outlined, size: 20),
            SizedBox(width: 8),
            Text(
              'Preview Details',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.bold,
                fontFamily: 'Georgia',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade700,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        controllers['dob']!.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      Map<String, String> userData = {};
      controllers.forEach((key, controller) {
        userData[key] = controller.text;
      });

      showDialog(
        context: context,
        builder:
            (context) => PDFPreviewDialog(
              selectedAddres: _selectedDistrict,
              userData: userData,
              selectedGender: _selectedGender,
              selectedCountry: _selectedCountry,
            ),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
