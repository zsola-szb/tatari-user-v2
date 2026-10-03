// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
// Generated file. Do not edit.
//

import PackageDescription

let package = Package(
    name: "FlutterGeneratedPluginSwiftPackage",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(name: "FlutterGeneratedPluginSwiftPackage", type: .static, targets: ["FlutterGeneratedPluginSwiftPackage"])
    ],
    dependencies: [
        .package(name: "app_links", path: "../.packages/app_links-7.2.1"),
        .package(name: "app_tracking_transparency", path: "../.packages/app_tracking_transparency-2.0.7"),
        .package(name: "connectivity_plus", path: "../.packages/connectivity_plus-7.3.1"),
        .package(name: "facebook_app_events", path: "../.packages/facebook_app_events-0.30.5"),
        .package(name: "file_picker_darwin", path: "../.packages/file_picker_darwin-1.1.0"),
        .package(name: "firebase_analytics", path: "../.packages/firebase_analytics-12.5.0"),
        .package(name: "firebase_auth", path: "../.packages/firebase_auth-6.6.1"),
        .package(name: "firebase_core", path: "../.packages/firebase_core-4.14.0"),
        .package(name: "firebase_messaging", path: "../.packages/firebase_messaging-16.6.0"),
        .package(name: "flutter_facebook_auth", path: "../.packages/flutter_facebook_auth-7.2.0"),
        .package(name: "flutter_local_notifications", path: "../.packages/flutter_local_notifications-22.3.0"),
        .package(name: "flutter_secure_storage_darwin", path: "../.packages/flutter_secure_storage_darwin-0.3.2"),
        .package(name: "fluttertoast", path: "../.packages/fluttertoast-10.0.0"),
        .package(name: "geolocator_apple", path: "../.packages/geolocator_apple-2.3.14"),
        .package(name: "google_sign_in_ios", path: "../.packages/google_sign_in_ios-6.3.0"),
        .package(name: "image_picker_ios", path: "../.packages/image_picker_ios-0.8.13+6"),
        .package(name: "package_info_plus", path: "../.packages/package_info_plus-10.2.1"),
        .package(name: "permission_handler_apple", path: "../.packages/permission_handler_apple-9.6.1"),
        .package(name: "share_plus", path: "../.packages/share_plus-13.3.0"),
        .package(name: "shared_preferences_foundation", path: "../.packages/shared_preferences_foundation-2.5.6"),
        .package(name: "sign_in_with_apple", path: "../.packages/sign_in_with_apple-8.2.0"),
        .package(name: "sqflite_darwin", path: "../.packages/sqflite_darwin-2.4.2"),
        .package(name: "tiktok_events_sdk", path: "../.packages/tiktok_events_sdk-1.3.0"),
        .package(name: "url_launcher_ios", path: "../.packages/url_launcher_ios-6.4.1"),
        .package(name: "video_player_avfoundation", path: "../.packages/video_player_avfoundation-2.11.0"),
        .package(name: "wakelock_plus", path: "../.packages/wakelock_plus-1.8.0"),
        .package(name: "webview_flutter_wkwebview", path: "../.packages/webview_flutter_wkwebview-3.25.1"),
        .package(name: "FlutterFramework", path: "../.packages/FlutterFramework")
    ],
    targets: [
        .target(
            name: "FlutterGeneratedPluginSwiftPackage",
            dependencies: [
                .product(name: "app-links", package: "app_links"),
                .product(name: "app-tracking-transparency", package: "app_tracking_transparency"),
                .product(name: "connectivity-plus", package: "connectivity_plus"),
                .product(name: "facebook-app-events", package: "facebook_app_events"),
                .product(name: "file-picker-darwin", package: "file_picker_darwin"),
                .product(name: "firebase-analytics", package: "firebase_analytics"),
                .product(name: "firebase-auth", package: "firebase_auth"),
                .product(name: "firebase-core", package: "firebase_core"),
                .product(name: "firebase-messaging", package: "firebase_messaging"),
                .product(name: "flutter-facebook-auth", package: "flutter_facebook_auth"),
                .product(name: "flutter-local-notifications", package: "flutter_local_notifications"),
                .product(name: "flutter-secure-storage-darwin", package: "flutter_secure_storage_darwin"),
                .product(name: "fluttertoast", package: "fluttertoast"),
                .product(name: "geolocator-apple", package: "geolocator_apple"),
                .product(name: "google-sign-in-ios", package: "google_sign_in_ios"),
                .product(name: "image-picker-ios", package: "image_picker_ios"),
                .product(name: "package-info-plus", package: "package_info_plus"),
                .product(name: "permission-handler-apple", package: "permission_handler_apple"),
                .product(name: "share-plus", package: "share_plus"),
                .product(name: "shared-preferences-foundation", package: "shared_preferences_foundation"),
                .product(name: "sign-in-with-apple", package: "sign_in_with_apple"),
                .product(name: "sqflite-darwin", package: "sqflite_darwin"),
                .product(name: "tiktok-events-sdk", package: "tiktok_events_sdk"),
                .product(name: "url-launcher-ios", package: "url_launcher_ios"),
                .product(name: "video-player-avfoundation", package: "video_player_avfoundation"),
                .product(name: "wakelock-plus", package: "wakelock_plus"),
                .product(name: "webview-flutter-wkwebview", package: "webview_flutter_wkwebview"),
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ]
        )
    ]
)
