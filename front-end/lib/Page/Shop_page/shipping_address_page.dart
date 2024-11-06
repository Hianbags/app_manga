import 'package:appmanga/Model/Shop_Model/shipping_address_model.dart';
import 'package:appmanga/Page/Shop_page/add_shipping_address_page.dart';
import 'package:appmanga/Service/Shop_service/shipping_address_service.dart';
import 'package:flutter/material.dart';

class ShippingAddressPage extends StatefulWidget {
  @override
  _ShippingAddressPageState createState() => _ShippingAddressPageState();
}

class _ShippingAddressPageState extends State<ShippingAddressPage> {
  late Future<List<ShippingAddress>> futureShippingAddresses;

  @override
  void initState() {
    super.initState();
    _loadShippingAddresses();
  }

  void _loadShippingAddresses() {
    futureShippingAddresses = ShippingAddressService().fetchShippingAddresses();
  }

  Future<void> _refreshAddresses() async {
    setState(() {
      _loadShippingAddresses();
    });
  }

  Future<void> _addNewAddress() async {
    final addressAdded = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddShippingAddressPage()),
    );

    if (addressAdded == true) {
      await _refreshAddresses();
    }
  }

  void _selectAddress(ShippingAddress address) {
    Navigator.pop(context, address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn địa chỉ giao hàng', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.white,
        child: FutureBuilder<List<ShippingAddress>>(
          future: futureShippingAddresses,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: Colors.blue));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.black)));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Không tìm thấy địa chỉ giao hàng nào.', style: TextStyle(color: Colors.black)),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _addNewAddress,
                      child: Text('Thêm địa chỉ mới'),
                    ),
                  ],
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: _refreshAddresses,
                child: ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: snapshot.data!.length + 1,
                  itemBuilder: (context, index) {
                    if (index == snapshot.data!.length) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          color: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.add, color: Colors.black),
                            title: Text('Thêm địa chỉ mới', style: TextStyle(color: Colors.black)),
                            onTap: _addNewAddress,
                          ),
                        ),
                      );
                    } else {
                      ShippingAddress address = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          color: Colors.grey[100],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: ListTile(
                            title: Text(address.recipientName, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                '${address.streetAddress}, ${address.ward}, ${address.district}, ${address.province}',
                                style: TextStyle(color: Colors.black54)),
                            trailing: Text(address.phoneNumber, style: TextStyle(color: Colors.black)),
                            onTap: () => _selectAddress(address),
                          ),
                        ),
                      );
                    }
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
