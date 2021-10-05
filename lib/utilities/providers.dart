import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parkingapp/viewmodel/addscreen_viewmodel.dart';
import 'package:parkingapp/viewmodel/map_screen_viewmodel.dart';
import 'package:parkingapp/viewmodel/select_location_viewmodel.dart';

final mainMapScreenProvider = ChangeNotifierProvider<MapScreenViewModel>((ref) {
  return MapScreenViewModel();
});
final addScreenProvider =
    ChangeNotifierProvider<AddParkingScreenViewModel>((ref) {
  return AddParkingScreenViewModel();
});
final selectScreenProvider =
    ChangeNotifierProvider<SelectLocationViewModel>((ref) {
  return SelectLocationViewModel();
});
