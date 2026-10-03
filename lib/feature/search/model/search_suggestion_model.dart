enum SearchSuggestionType {
  service('services'),
  category('categories'),
  provider('providers'),
  others('');

  final String value;
  const SearchSuggestionType(this.value);

  static SearchSuggestionType fromValue(String? value) {
    return SearchSuggestionType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => others,
    );
  }
}

class SearchSuggestionModel {
  String? responseCode;
  String? message;
  List<SearchSuggestion>? searchSuggestionContent;

  SearchSuggestionModel({this.responseCode, this.message, this.searchSuggestionContent});

  SearchSuggestionModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    if (json['data'] != null) {
      searchSuggestionContent = <SearchSuggestion>[];
      json['data'].forEach((v) {
        searchSuggestionContent!.add(SearchSuggestion.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response_code'] = responseCode;
    data['message'] = message;
    if (searchSuggestionContent != null) {
      data['data'] = searchSuggestionContent!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchSuggestion {
  String? name;
  String? id;
  String? slug;
  SearchSuggestionType type;

  SearchSuggestion({this.name, this.id, this.slug, this.type = SearchSuggestionType.others});

  SearchSuggestion.fromJson(Map<String, dynamic> json) : type = SearchSuggestionType.fromValue(json['type']) {
    name = json['name'];
    id = json['id'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['slug'] = slug;
    data['type'] = type.value;
    return data;
  }
}
