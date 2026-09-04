import '../../l10n/app_localizations.dart';
import 'failures.dart';

String localizeFailure(AppLocalizations l10n, Object error) {
  return switch (error) {
    NetworkFailure() => l10n.errorNetwork,
    LocationPermissionDeniedFailure() => l10n.errorLocationPermission,
    CityNotFoundFailure() => l10n.errorCityNotFound,
    _ => l10n.errorUnknown,
  };
}
