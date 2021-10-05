import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parkingapp/viewmodel/map_screen_viewmodel.dart';

final mainMapScreenProvider = ChangeNotifierProvider<MapScreenViewModel>((ref) {
  return MapScreenViewModel();
});
