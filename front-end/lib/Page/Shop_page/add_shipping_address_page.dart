

import 'package:appmanga/DatabaseHelper/Addresses_helper.dart';
import 'package:appmanga/Service/Shop_service/shipping_address_service.dart';
import 'package:flutter/material.dart';

class AddShippingAddressPage extends StatefulWidget {
  @override
  _AddShippingAddressPageState createState() => _AddShippingAddressPageState();
}

class _AddShippingAddressPageState extends State<AddShippingAddressPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedProvince;
  String? selectedDistrict;
  String? selectedWard;
  String? recipientName;
  String? phoneNumber;
  String? streetAddress;

  List<Map<String, dynamic>> provinces = [];
  List<Map<String, dynamic>> districts = [];
  List<Map<String, dynamic>> wards = [];

  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadProvinces();
  }

  Future<void> _loadProvinces() async {
    var result = await databaseHelper.getProvinces();
    setState(() {
      provinces = List<Map<String, dynamic>>.from(result);
    });
  }

  Future<void> _loadDistricts(String provinceCode) async {
    var result = await databaseHelper.getDistrictsByProvinceCode(provinceCode);
    setState(() {
      districts = List<Map<String, dynamic>>.from(result);
    });
  }

  Future<void> _loadWards(String districtCode) async {
    var result = await databaseHelper.getWardsByDistrictCode(districtCode);
    setState(() {
      wards = List<Map<String, dynamic>>.from(result);
    });
  }

  Future<void> _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final selectedProvinceFullName = provinces.firstWhere((element) => element['code'].toString() == selectedProvince)['full_name'];
      final selectedDistrictFullName = districts.firstWhere((element) => element['code'].toString() == selectedDistrict)['full_name'];
      final selectedWardFullName = wards.firstWhere((element) => element['code'].toString() == selectedWard)['full_name'];

      try {
        await ShippingAddressService().storeAddress(
          recipientName!,
          phoneNumber!,
          streetAddress!,
          selectedProvinceFullName,
          selectedDistrictFullName,
          selectedWardFullName,
        );
        Navigator.pop(context, true);
      } catch (e) {
        print(e);
        Navigator.pop(context, false);
      }
    }
  }

  Widget _buildDropdownButtonFormField({
    required String label,
    String? value,
    required List<Map<String, dynamic>> items,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        value: value,
        onChanged: onChanged,
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item['code'].toString(),
            child: Text(item['full_name']),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm địa chỉ nhận hàng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Tên người nhận',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên người nhận';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    recipientName = value;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Số điện thoại',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập số điện thoại';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    phoneNumber = value;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Đường/Tòa nhà',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập địa chỉ';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    streetAddress = value;
                  },
                ),
                _buildDropdownButtonFormField(
                  label: 'Thành phố (tỉnh)',
                  value: selectedProvince,
                  items: provinces,
                  onChanged: (value) async {
                    setState(() {
                      selectedProvince = value;
                      selectedDistrict = null;
                      selectedWard = null;
                      districts = [];
                      wards = [];
                    });
                    await _loadDistricts(value!);
                  },
                ),
                if (selectedProvince != null)
                  _buildDropdownButtonFormField(
                    label: 'Quận (huyện)',
                    value: selectedDistrict,
                    items: districts,
                    onChanged: (value) async {
                      setState(() {
                        selectedDistrict = value;
                        selectedWard = null;
                        wards = [];
                      });
                      await _loadWards(value!);
                    },
                  ),
                if (selectedDistrict != null)
                  _buildDropdownButtonFormField(
                    label: 'Phường (xã)',
                    value: selectedWard,
                    items: wards,
                    onChanged: (value) {
                      setState(() {
                        selectedWard = value;
                      });
                    },
                  ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _saveAddress,
                  child: Text('Lưu địa chỉ'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
