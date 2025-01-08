import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart'
    hide PermissionStatus;

class LocationService {
  Location location = Location();

  Future<bool> getPermissions() async {
    try {
      final permit = await location.hasPermission();

      if (permit == PermissionStatus.granted ||
          permit == PermissionStatus.grantedLimited) {
        return true;
      } else if (permit == PermissionStatus.deniedForever) {
        await openAppSettings();

        final checkAgain = await location.hasPermission();
        return checkAgain == PermissionStatus.granted ||
            checkAgain == PermissionStatus.grantedLimited;
      } else {
        final request = await location.requestPermission();
        return request == PermissionStatus.granted ||
            request == PermissionStatus.grantedLimited;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkLocationAvailability() async {
    try {
      final isAvailable = await location.serviceEnabled();
      if (isAvailable) {
        return isAvailable;
      } else {
        final request = await location.requestService();
        if (request) {
          return request;
        }
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<LocationData?> getLocation() async {
    final hasLocation = await checkLocationAvailability();
    final hasPermission = await getPermissions();

    if (hasPermission && hasLocation) {
      try {
        final currentLocation = await location.getLocation();
        return currentLocation;
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
