import 'package:tatarigigs_user/feature/search/model/search_suggestion_model.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SuggestionTypeIcon extends StatelessWidget {
  final SearchSuggestionType type;
  final double size;
  const SuggestionTypeIcon({super.key, required this.type, this.size = 16});

  @override
  Widget build(BuildContext context) {
    switch(type){
      case SearchSuggestionType.service:
        return SvgPicture.asset(Images.service, width: size, height: size);
      case SearchSuggestionType.category:
        return SvgPicture.asset(Images.category, width: size, height: size);
      case SearchSuggestionType.provider:
        return SvgPicture.asset(Images.provider, width: size, height: size);
      case SearchSuggestionType.others:
        return Image.asset(Images.searchIcon, color: Theme.of(context).hintColor, width: size, height: size);
    }
  }
}
