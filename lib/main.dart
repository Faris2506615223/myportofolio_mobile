import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  runApp(MyApp(apiClient: ApiClient()));
}
