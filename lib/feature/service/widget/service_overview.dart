import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';


class ServiceOverview extends StatelessWidget {
  final String? description;
  const ServiceOverview({super.key, required this.description}) ;

  @override
  Widget build(BuildContext context) {
    if(description == null || description!.trim().isEmpty){
      return const SizedBox.shrink();
    }
    return HtmlWidget(description!);
  }
}