import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CountryAddressDialog extends StatefulWidget {
  final Function(String, String) onAddressSelected;

  const CountryAddressDialog({super.key, required this.onAddressSelected});

  @override
  _CountryAddressDialogState createState() => _CountryAddressDialogState();
}

class _CountryAddressDialogState extends State<CountryAddressDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCountry = 'Uganda'; // Default selected country
  bool _showCountrySelection = true;

  // Lists of districts/regions by country
  final Map<String, List<String>> _locationsByCountry = {
    'Uganda': [
      'Kampala',
      'Wakiso',
      'Mukono',
      'Jinja',
      'Mbale',
      'Mbarara',
      'Arua',
      'Gulu',
      'Lira',
      'Masaka',
      'Kabale',
      'Soroti',
      'Hoima',
      'Masindi',
      'Kasese',
      'Fort Portal',
      'Tororo',
      'Iganga',
      'Busia',
      'Mityana',
      'Entebbe',
      'Kayunga',
      'Ntungamo',
      'Kamuli',
      'Rukungiri',
      'Bushenyi',
      'Moyo',
      'Kitgum',
      'Moroto',
      'Kabarole',
    ],
    'Kenya': [
      'Nairobi',
      'Mombasa',
      'Kisumu',
      'Nakuru',
      'Eldoret',
      'Nyeri',
      'Machakos',
      'Malindi',
      'Kitale',
      'Garissa',
      'Kakamega',
      'Thika',
      'Bungoma',
      'Kisii',
      'Kericho',
      'Naivasha',
      'Meru',
      'Embu',
      'Voi',
      'Lodwar',
      'Isiolo',
      'Lamu',
      'Nanyuki',
      'Kilifi',
      'Homa Bay',
    ],
    'Rwanda': [
      'Kigali',
      'Butare',
      'Gitarama',
      'Ruhengeri',
      'Gisenyi',
      'Cyangugu',
      'Kibuye',
      'Kibungo',
      'Byumba',
      'Gikongoro',
      'Nyanza',
      'Rwamagana',
      'Kayonza',
      'Muhanga',
      'Musanze',
      'Huye',
      'Rubavu',
      'Rusizi',
      'Karongi',
      'Ngoma',
    ],
    'Burundi': ['Bujumbura', 'Gitega', 'Ngozi', 'Rumonge', 'Muyinga'],
    'Tanzania': ['Dar es Salaam', 'Dodoma', 'Arusha', 'Mwanza', 'Zanzibar'],
  };

  // Country flag emojis
  final Map<String, String> _countryFlags = {
    'Uganda': '🇺🇬',
    'Kenya': '🇰🇪',
    'Tanzania': '🇹🇿',
    'Rwanda': '🇷🇼',
    'Burundi': '🇧🇮',
  };

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  void _selectCountry(String country) {
    setState(() {
      _selectedCountry = country;
      _showCountrySelection = false;
      _searchController.clear();
      _searchQuery = '';
    });
  }

  void _goBackToCountrySelection() {
    setState(() {
      _showCountrySelection = true;
      _searchController.clear();
      _searchQuery = '';
    });
  }

  List<String> get _filteredLocations {
    final locations = _locationsByCountry[_selectedCountry] ?? [];
    if (_searchQuery.isEmpty) {
      return locations;
    }
    return locations
        .where((location) => location.toLowerCase().contains(_searchQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_showCountrySelection) ...[
              // Country selection view
              const Text(
                'Select Country',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Gerogia',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: _countryFlags.length,
                  itemBuilder: (context, index) {
                    final country = _countryFlags.keys.elementAt(index);
                    final flag = _countryFlags[country];
                    return GestureDetector(
                      onTap: () => _selectCountry(country),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.blue[100]!,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(flag!, style: const TextStyle(fontSize: 18)),
                              const SizedBox(width: 8),
                              Text(
                                country,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ] else ...[
              // District/region selection view
              Row(
                children: [
                  GestureDetector(
                    onTap: _goBackToCountrySelection,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(CupertinoIcons.back, size: 18),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Select $_selectedCountry Location',
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Gerogia',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    _countryFlags[_selectedCountry] ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                cursorColor: Colors.black54,
                cursorHeight: 14,
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search locations...',
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Gerogia',
                  ),
                  prefixIcon: const Icon(CupertinoIcons.location_north),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child:
                    _filteredLocations.isEmpty
                        ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Icon(CupertinoIcons.location),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'No locations found',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontFamily: 'Gerogia',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        : GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 2.5,
                              ),
                          itemCount: _filteredLocations.length,
                          itemBuilder: (context, index) {
                            final location = _filteredLocations[index];
                            return GestureDetector(
                              onTap: () {
                                widget.onAddressSelected(
                                  _selectedCountry,
                                  location,
                                );
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.blue[200]!,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    location,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}

// Example usage in a page
class AddressPickerPage extends StatefulWidget {
  const AddressPickerPage({Key? key}) : super(key: key);

  @override
  _AddressPickerPageState createState() => _AddressPickerPageState();
}

class _AddressPickerPageState extends State<AddressPickerPage> {
  String _selectedCountry = '';
  String _selectedLocation = '';

  void _showAddressDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CountryAddressDialog(
          onAddressSelected: (country, location) {
            setState(() {
              _selectedCountry = country;
              _selectedLocation = location;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Address Picker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_selectedCountry.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _selectedCountry == 'Uganda'
                        ? '🇺🇬'
                        : _selectedCountry == 'Kenya'
                        ? '🇰🇪'
                        : '🇷🇼',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Country: $_selectedCountry',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Location: $_selectedLocation',
                style: const TextStyle(fontSize: 16),
              ),
            ] else ...[
              const Text(
                'No location selected',
                style: TextStyle(fontSize: 16),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _showAddressDialog,
              icon: const Icon(CupertinoIcons.location),
              label: const Text('Select Address'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
