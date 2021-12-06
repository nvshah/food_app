///AppLink is your navigation state object.
/// Applink obj store the route information

class AppLink {
  // 1 All Urls Path
  static const String homePath = '/home';
  static const String onboardingPath = '/onboarding';
  static const String loginPath = '/login';
  static const String profilePath = '/profile';
  static const String itemPath = '/item';

  // 2 All Query Parameters
  static const String tabParam = 'tab';
  static const String idParam = 'id';

  // 3
  String? location;

  // 4
  int? currentTab;

  // 5
  String? itemId;

  // 6
  AppLink({
    this.location,
    this.currentTab,
    this.itemId,
  });

  // TODO: Add fromLocation
  /// Transforms a simple string into Applink
  static AppLink fromLocation(String? location) {
    // 1 URLs are often percent-encoded. For example, you’d decode %E4%B8%8A%E6%B5%B7 to 上海
    location = Uri.decodeFull(location ?? '');
    // 2 Parse the URI for query parameter keys and key-value pairs.
    final uri = Uri.parse(location);
    final params = uri.queryParameters;

    // 3
    final currentTab = int.tryParse(params[AppLink.tabParam] ?? '');
    // 4
    final itemId = params[AppLink.idParam];
    // 5
    final link = AppLink(
      location: uri.path,
      currentTab: currentTab,
      itemId: itemId,
    );
    // 6
    return link;
  }

// TODO: Add toLocation
  ///Convert AppLink to String path
  String toLocation() {
    // 1
    String addKeyValPair({
      required String key,
      String? value,
    }) =>
        value == null ? '' : '${key}=$value&';
    // 2
    switch (location) {
      // 3
      case loginPath:
        return loginPath;
      // 4
      case onboardingPath:
        return onboardingPath;
      // 5
      case profilePath:
        return profilePath;
      // If there are any query param then append them as well
      case itemPath:
        var loc = '$itemPath?';
        loc += addKeyValPair(
          key: idParam,
          value: itemId,
        );
        return Uri.encodeFull(loc);
      // if the user selected a tab, append ?tab=${tabIndex}.
      default:
        var loc = '$homePath?';
        loc += addKeyValPair(
          key: tabParam,
          value: currentTab.toString(),
        );
        return Uri.encodeFull(loc);
    }
  }
}
