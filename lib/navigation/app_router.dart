import 'package:flutter/material.dart';
import 'package:food_app/screens/grocery_item_screen.dart';
import 'package:food_app/screens/home.dart';
import 'package:food_app/screens/login_screen.dart';
import 'package:food_app/screens/onboarding_screen.dart';
import 'package:food_app/screens/profile_screen.dart';
import 'package:food_app/screens/splash_screen.dart';
import 'package:food_app/screens/webview_screen.dart';

import '../models/models.dart';

// Widget = ChangeNotifier
// The system will tell the router to build and configure a navigator widget.
class AppRouter extends RouterDelegate
      with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final AppStateManager appStateManager;
  final GroceryManager groceryManager;
  final ProfileManager profileManager;

  AppRouter({
    required this.appStateManager,
    required this.groceryManager,
    required this.profileManager,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    //When the state changes, the router will reconfigure the navigator with a new set of pages.
    appStateManager.addListener(notifyListeners);
    groceryManager.addListener(notifyListeners);
    profileManager.addListener(notifyListeners);
  }

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    groceryManager.removeListener(notifyListeners);
    profileManager.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 7
    return Navigator(
      // 8
      key: navigatorKey,
      onPopPage: _handlePopPage,
      // 9
      pages: [
        if (!appStateManager.isInitialized) SplashScreen.page(),
        if (appStateManager.isInitialized && !appStateManager.isLoggedIn)
          LoginScreen.page(),
        if (appStateManager.isLoggedIn && !appStateManager.isOnboardingComplete)
          OnboardingScreen.page(),
        if (appStateManager.isOnboardingComplete)
          Home.page(appStateManager.getSelectedTab),
        //Creating new item
        if (groceryManager.isCreatingNewItem)
          GroceryItemScreen.page(
            onCreate: (item) {
              groceryManager.addItem(item);
            },
            onUpdate: (item, index) {
              // 4 No update
            },
          ),
        // Update existing item
        if (groceryManager.selectedIndex != -1)
          GroceryItemScreen.page(
              item: groceryManager.selectedGroceryItem,
              index: groceryManager.selectedIndex,
              onUpdate: (item, index) {
                // 3
                groceryManager.updateItem(item, index);
              },
              onCreate: (_) {
                // 4 No create
              }),

        // TODO: Add Profile Screen
        if (profileManager.didSelectUser)
          ProfileScreen.page(profileManager.getUser),

        // TODO: Add WebView Screen
        if (profileManager.didTapOnRaywenderlich)
          WebViewScreen.page(),

      ],
    );
  }

  // TODO: Add _handlePopPage
  bool _handlePopPage(Route<dynamic> route, result) {
    // check if route pop succeed
    if (!route.didPop(result)) {
      return false;
    }
    // 5
    // TODO: Handle Onboarding and splash
    if (route.settings.name == FooderlichPages.onboardingPath) {
      // if user tap back button w.o completing onboarding
      // So user has to login again
      appStateManager.logout();
    }
    // TODO: Handle state when user closes grocery item screen
    if (route.settings.name == FooderlichPages.groceryItemDetails) {
      groceryManager.groceryItemTapped(-1);
    }
    // TODO: Handle state when user closes profile screen
    if (route.settings.name == FooderlichPages.profilePath) {
      profileManager.tapOnProfile(false);
    }

    // TODO: Handle state when user closes WebView screen
    if (route.settings.name == FooderlichPages.raywenderlich) {
      profileManager.tapOnRaywenderlich(false);
    }

    // 6
    return true;
  }

  // 10
  @override
  Future<void> setNewRoutePath(configuration) async => null;
}
