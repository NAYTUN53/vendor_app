import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_app/models/vendor.dart';

class VendorProvider extends StateNotifier<Vendor?> {
  VendorProvider()
      : super(Vendor(
            id: '',
            fullName: '',
            email: '',
            state: '',
            city: '',
            locality: '',
            role: '',
            password: ''));

  Vendor? get vendor => state;

  void setVendor(String vendorJson) {
    state = Vendor.fromJson(vendorJson);
  }

  void signOut() {
    state = null;
  }
}

final vendorProvider = StateNotifierProvider<VendorProvider, Vendor?>((ref) {
  return VendorProvider();
});
