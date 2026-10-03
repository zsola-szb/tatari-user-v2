# CLAUDE.md

Guidance for Claude Code (and any contributor) working in this repository. Rules here reflect the conventions **already established in this codebase** — follow them for all new code rather than defaulting to generic Flutter patterns.

> **Hard rule — localization is not optional.** Any change that adds or edits a user-facing string in `en.json` must add the same key with a real translated value to `ar.json`, `bn.json`, and `hi.json` in the *same* change. A diff that touches `en.json` without touching the other three language files is incomplete — do not consider such a change done. See [Localization Rules](#localization-rules) for the full workflow.

## Project Overview

Tatarigigs User App — a Flutter service-marketplace app (booking, provider discovery, checkout, wallet, subscriptions, etc.).

**Tech stack:**
- **State management / DI:** GetX (`get: ^4.7.3`) — this is the *only* state management and dependency-injection mechanism in the app. There is no Provider, BLoC, Riverpod, or get_it/injectable anywhere in the codebase — don't introduce one.
- **Local storage:** `shared_preferences` (key-value), `drift` (SQLite, via `lib/api/local/`).
- **Networking:** a custom `ApiClient` (`lib/api/remote/client_api.dart`) with centralized error handling in `lib/api/remote/api_checker.dart`.
- **Firebase:** messaging, analytics, auth, plus Facebook/TikTok event tracking (`lib/helper/analytics/`).
- **Localization:** GetX's built-in `Translations` mechanism backed by JSON files (see below) — not `easy_localization`, not `.arb`/`AppLocalizations`.

## Project Structure

### Top-level `lib/` layout

| Folder | Purpose |
|---|---|
| `lib/api/local/` | Local cache/DB models (drift) |
| `lib/api/remote/` | HTTP client, API error handling |
| `lib/common/` | Cross-feature shared code: `enums/`, `models/`, `repo/`, `widgets/` |
| `lib/feature/<name>/` | One folder per feature (~30 features) — see below |
| `lib/helper/` | Stateless helper classes/functions: `route_helper.dart`, `price_converter.dart`, `get_di.dart`, `db_helper.dart`, `analytics/` |
| `lib/theme/` | `dark_theme.dart`, `light_theme.dart`, `custom_theme_colors.dart` |
| `lib/util/` | App-wide constants/tokens: `app_constants.dart`, `dimensions.dart`, `images.dart`, `styles.dart`, `initial_binding.dart`, `messages.dart`, `core_export.dart` |

Do not invent new top-level folders under `lib/` — fit new code into this structure.

### Feature folders are feature-first, split by type inside

Each `lib/feature/<name>/` contains only the subfolders it needs from:
`controller/`, `model/`, `repo/`, `view/`, `widget/`, `bindings/`.

Example — `lib/feature/review/` has all six:
```
feature/review/
├── binding/    (submit_review_binding.dart)
├── controller/ (submit_review_controller.dart)
├── model/      (booking_review_model.dart, review_body.dart)
├── repo/       (submit_review_repo.dart)
├── view/       (rate_review_screen.dart)
└── widgets/    (select_rating.dart)
```

Newer features skip `bindings/` entirely and register their controllers in
`lib/helper/get_di.dart`, wiring binding-less `GetPage`s — see `lib/feature/booking/`,
`lib/feature/checkout/` and `lib/feature/cart/`. Prefer that shape for new features.
`widget/` is the convention over `widgets/` (`review/` is an outlier).

Cross-feature/shared widgets, models, enums, or repos go in `lib/common/` instead — never duplicate something that already exists there.

### Naming conventions (snake_case files/folders throughout)

| Type | File suffix | Folder |
|---|---|---|
| Controller | `*_controller.dart` | `controller/` |
| Screen | `*_screen.dart` | `view/` |
| Widget | `*_widget.dart` or a descriptive name | `widget/` |
| Model | `*_model.dart` | `model/` |
| Repository | `*_repo.dart` | `repo/` |
| Binding | `*_bindings.dart` / `*_binding.dart` | `bindings/` / `binding/` |
| Helper | `*_helper.dart` | `lib/helper/` |

**Standardize on `repo/` (not `repository/`) for the folder name.** ~28 features already use `repo/`; only `feature/subscription/` uses `repository/` as an outlier — don't replicate it in new features.

### Barrel import file

`lib/util/core_export.dart` re-exports the large majority of commonly-used controllers, repos, models, widgets, screens, bindings, and third-party packages. Existing files import it directly:

```dart
import 'package:tatarigigs_user/util/core_export.dart';
```

When you add a new broadly-reusable file (a shared widget, model, controller, etc.), add a corresponding `export` line to `core_export.dart` so other files can pull it in through the barrel import instead of accumulating long individual import lists.

## Localization Rules

- **Every user-facing string must be localized — never hardcode English text in a widget.** One existing violation to *not* repeat: `lib/feature/subscription/widget/subscription_payment_dialog.dart:119` — `Text('Pay via Wallet', ...)` has no `.tr`.
- Strings are looked up with GetX's `.tr` extension directly on the string literal:
  ```dart
  Text('select_date_range'.tr)
  ```
  There is no `getTranslated(context, key)` wrapper or `AppLocalizations.of(context)` — don't introduce one.
- Translations are flat JSON key-value files in `assets/language/`: `en.json`, `ar.json`, `bn.json`, `hi.json`. Keys are snake_case.
- To add new UI text:
  1. Add the key to `assets/language/en.json` (required).
  2. Add the same key with an actual translated value to `ar.json`, `bn.json`, and `hi.json` **every time** — all four language files must be updated together in the same change. Never leave a key untranslated in one file or skip a file "for later."
- Loading/wiring lives in `lib/helper/get_di.dart` (`init()`, loads each JSON file into a `Map<String, String>`) and `lib/util/messages.dart` (`Messages extends Translations`), consumed by `GetMaterialApp(translations: Messages(...))` in `main.dart`. Don't reimplement this.
- Language switching and RTL handling already live in `LocalizationController` (`lib/feature/language/controller/localization_controller.dart`) — use it rather than adding new locale-switching logic elsewhere.

## Typography Rules

`lib/util/styles.dart` defines two generations of text style — use the newer `TextScale` system for all new code:

- **New (`TextScale`) — use this for new code.** Three families — `heading`, `subHeading`, `body` — each a fixed weight/line-height/tracking with a size scale accessed as getters: `.extraSmall`, `.small`, `.defaultSize`, `.large`, `.extraLarge`, `.overLarge`, `.extraOverLarge`. The bare top-level constants (`heading`, `subHeading`, `body`) carry no colour; prefer the theme-aware `BuildContext` extension versions instead, which resolve colour from the active theme automatically:
  ```dart
  Text('all_categories'.tr, style: context.heading.extraLarge)
  Text(category.name, style: context.body.small)
  ```
  - `context.heading` — titles/section headers, strong (700) weight.
  - `context.subHeading` — secondary titles/card headings, regular (400) weight.
  - `context.body` — body/descriptive copy, regular (400) weight, muted `hintColor`.
  - Override weight with `.regular` / `.medium` / `.semiBold` / `.strong` (from the `TextStyleWeight` extension), and colour/weight together with `.overrideWith(color: ..., fontWeight: ...)`:
    ```dart
    context.subHeading.extraLarge.overrideWith(color: context.customThemeColors.secondaryTextColor)
    ```
- **Old (`robotoRegular`/`robotoMedium`/`robotoSemiBold`/`robotoBold`) — marked `REMOVE OLD Data` in the file.** Still used throughout most of the existing codebase (font family + weight only, size/colour supplied per call site via `.copyWith(...)`). Don't rip these out of working files as a drive-by change, but don't reach for them in new widgets either — use `TextScale` instead.

## Dependency Injection Rules (GetX only)

This app uses GetX's service locator exclusively — `Get.lazyPut()` to register, `Get.find<T>()` to retrieve. Never add `get_it`, `provider`, `riverpod`, or `injectable`.

**Two registration sites:**
1. **App-wide/core dependencies** — registered in `lib/helper/get_di.dart`'s `init()` function, which runs once from `main.dart` before `runApp()`.
2. **Feature/route-scoped dependencies** — a `class XBinding extends Bindings` inside the feature's `bindings/` (or `binding/`) folder, overriding `dependencies()`, then wired into that route via the `binding:` parameter on `GetPage` in `lib/helper/route_helper.dart`:
   ```dart
   GetPage(binding: BookingBinding(), name: bookingDetailsScreen, page: () => ...)
   ```

**Registration pattern to follow:**
```dart
// Register the repo independently first...
Get.lazyPut(() => BannerRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
// ...then inject it into its controller via Get.find()
Get.lazyPut(() => BannerController(bannerRepo: Get.find()));
```
Avoid constructing a repo inline inside a controller's `lazyPut` (a pre-existing anti-pattern in a few spots in `get_di.dart`, e.g. `LocationController(locationRepo: LocationRepo(apiClient: Get.find(), ...))`) — always give the repo its own `Get.lazyPut` registration instead.

**Consuming dependencies in widgets:** drive reactive UI with `GetBuilder<XController>`, not manual `setState` tied to a held controller reference:
```dart
GetBuilder<CategoryController>(
  builder: (categoryController) => ...,
)
```

## Calling a controller from `initState` — use `shouldUpdate: false`

`initState` runs **inside the build phase**, so any `update()` a controller fires *synchronously* (before its first `await`) reaches every mounted `GetBuilder<T>` for that controller mid-build — including ones on the screen underneath. Flutter throws:

```
setState() or markNeedsBuild() called during build.
The widget on which setState() or markNeedsBuild() was called was:
  GetBuilder<ReviewRatingController>
The widget which was currently being built when the offending call was made was:
  Builder
```

It shows up when a screen kicks off a fetch in `initState` (directly, or from a `GetBuilder`'s `initState:` callback) while another screen holding the *same* controller is still mounted — e.g. tapping **View all** in `ServiceDetailsReview` to push `ReviewRatingScreen`.

**Fix — the `shouldUpdate` flag convention** (`CategoryController.getSubCategoryList`, `AuthController.toggleTerms`, `LocalizationController.filterLanguage`, `CartController.updatePreselectedProvider`, …): give the controller method a `bool shouldUpdate = true` parameter and guard only the **pre-await** `update()` with it. The post-await `update()` stays unconditional — it runs after the frame, so it is always safe.

```dart
// controller
Future<void> getCustomerReviews({required String id, required int offset, bool shouldUpdate = true}) async {
  _isLoading = true;
  _list.clear();
  if(shouldUpdate){
    update();          // skipped when called from initState
  }
  final Response response = await repo.getCustomerReviews(id: id, offset: offset);
  ...
  _isLoading = false;
  update();            // after the await — always safe
}

// screen
@override
void initState() {
  super.initState();
  Get.find<ReviewRatingController>().getCustomerReviews(id: widget.id, offset: 1, shouldUpdate: false);
}
```

Skipping that first `update()` costs nothing: the field mutations still happen before the first build, so the loading state renders correctly on the first frame.

Don't add ad-hoc `SchedulerPhase`/`addPostFrameCallback` wrappers inside controllers to work around this — `shouldUpdate` is the convention. (A few controllers do wrap `update()` in `WidgetsBinding.instance.addPostFrameCallback` — `booking_list_controller.dart`, `booking_details_controller.dart`, `checkout_controller.dart` — don't spread that pattern to new code.) `addPostFrameCallback` in a *screen's* `initState` is fine when the work genuinely must wait for the first frame (measuring layout, showing a dialog), e.g. `lib/feature/provider/view/provider_details_screen.dart:41`.

## Widget Rules — Class Widgets Only, No Method-Widgets

**Never write a function that returns a `Widget` inside another widget's class** — no `Widget _buildX(...)` or `Widget buildX(BuildContext context)` helpers, even if small or private. This pattern exists in some current files (e.g. `lib/feature/category/view/category_screen.dart:48`, `Widget _buildBody(...)`) — it is not a model to follow for new code.

Why: a method-widget shares its parent's `BuildContext`, can never be `const`, and forces Flutter to rebuild it every time the parent rebuilds. A class widget can be `const`, gets its own build context, and lets Flutter skip rebuilding it when nothing relevant changed.

**Instead, always extract a real widget class:**
```dart
class CustomButton extends StatelessWidget {
  const CustomButton({super.key, ...});
  @override
  Widget build(BuildContext context) => ...;
}
```
Use `StatelessWidget` by default, `StatefulWidget` only when the piece needs local state, and add a `const` constructor whenever possible. Follow the existing correct examples: `lib/common/widgets/custom_button.dart` (`CustomButton extends StatelessWidget`) and `lib/common/widgets/custom_text_field.dart` (`CustomTextField extends StatefulWidget`).

Place the new class in the feature's `widget/` folder if it's feature-specific, or in `lib/common/widgets/` if it's reused across features — and add it to `core_export.dart` if it needs to be broadly importable (see Structure rules above).

## Null Safety Rules

The codebase is fully null-safe (sound Dart null safety) — new and edited code must maintain that, not erode it.

- **Don't use the `!` (bang) operator to silence the analyzer.** If a value can genuinely never be null at that point, express it through control flow (an early return, an `if (x != null)` check/promotion, a guaranteed-non-null default) instead of force-unwrapping. Only reach for `!` when there is truly no other way and you can justify why it's safe at that call site.
- **Prefer `?`/nullable types honestly.** If a field, parameter, or return type can be absent, declare it nullable (`String?`) rather than giving it a fake non-null default just to avoid `?`. Don't declare something non-nullable and then force-unwrap it everywhere to make the type system happy.
- **Use null-aware operators over manual null checks** where they read more clearly: `?.`, `??`, `??=`, `...?` for spreads. Avoid patterns like `x != null ? x.y : null` when `x?.y` says the same thing.
- **Give models/API responses honest nullability.** Fields parsed from JSON that the backend may omit or send as `null` must be typed nullable in the model (`*_model.dart`) — don't assume a field is always present and force-unwrap it after `fromJson`.
- **New parameters/fields should default to non-nullable with a required or sensible default value**; only make something nullable when absence is a real, meaningful state (not just "I don't want to provide a default").
- When you do encounter an unavoidable `!`, keep it as close as possible to the point where null-safety was already established (e.g., right after an `if (x == null) return;` guard) rather than deep inside unrelated logic.
