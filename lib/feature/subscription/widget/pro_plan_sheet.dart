import 'package:tatarigigs_user/common/widgets/base_bottomsheet.dart';
import 'package:tatarigigs_user/common/widgets/custom_button.dart';
import 'package:tatarigigs_user/common/widgets/custom_loader.dart';
import 'package:tatarigigs_user/feature/cart/controller/cart_controller.dart';
import 'package:tatarigigs_user/feature/profile/controller/user_controller.dart';
import 'package:tatarigigs_user/feature/subscription/controller/subscription_controller.dart';
import 'package:tatarigigs_user/feature/subscription/model/subscription_model.dart';
import 'package:tatarigigs_user/feature/subscription/widget/plan_faq_list.dart';
import 'package:tatarigigs_user/feature/subscription/widget/plan_package_selector.dart';
import 'package:tatarigigs_user/feature/subscription/widget/plan_summary_card.dart';
import 'package:tatarigigs_user/feature/subscription/widget/plan_terms_link.dart';
import 'package:tatarigigs_user/feature/subscription/widget/subscription_payment_dialog.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/helper/subscription_helper.dart';
import 'package:tatarigigs_user/util/dimensions.dart';
import 'package:tatarigigs_user/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> openProPlanSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) => const ProPlanSheet(),
  );
}

class ProPlanSheet extends StatefulWidget {
  const ProPlanSheet({super.key});

  @override
  State<ProPlanSheet> createState() => _ProPlanSheetState();
}

class _ProPlanSheetState extends State<ProPlanSheet> {
  static const double _minSheetSize = 0.5;
  static const double _maxSheetSize = 0.95;

  final DraggableScrollableController _sheetController = DraggableScrollableController();
  final GlobalKey _sheetKey = GlobalKey();
  final GlobalKey _subscribeButtonKey = GlobalKey();

  double _availableHeight = 0;
  bool _hasSnappedToPeek = false;

  @override
  void initState() {
    super.initState();

    final SubscriptionController subscriptionController = Get.find<SubscriptionController>();
    subscriptionController.setPlanIndex(0, isUpdate: false);
    subscriptionController.getSubscriptionList();
    subscriptionController.getSubscriptionTerms();
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  void _snapToPeekHeight() {
    if (!mounted || _availableHeight <= 0 || !_sheetController.isAttached) {
      return;
    }

    final RenderObject? sheet = _sheetKey.currentContext?.findRenderObject();
    final RenderObject? subscribeButton = _subscribeButtonKey.currentContext?.findRenderObject();
    if (sheet is! RenderBox || subscribeButton is! RenderBox || !sheet.hasSize || !subscribeButton.hasSize) {
      return;
    }

    final double buttonBottom = subscribeButton
        .localToGlobal(Offset(0, subscribeButton.size.height), ancestor: sheet).dy;

    _hasSnappedToPeek = true;
    _sheetController.jumpTo(
      ((buttonBottom + Dimensions.padding20) / _availableHeight).clamp(_minSheetSize, _maxSheetSize),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        _availableHeight = constraints.maxHeight;

        return DraggableScrollableSheet(
          controller: _sheetController,
          expand: false,
          initialChildSize: _maxSheetSize,
          minChildSize: _minSheetSize,
          maxChildSize: _maxSheetSize,
          builder: (BuildContext context, ScrollController scrollController) => BaseBottomSheet(
            key: _sheetKey,
            showDragHandle: true,
            scrollController: scrollController,
            child: GetBuilder<SubscriptionController>(
              builder: (SubscriptionController subscriptionController) {
                final Plans? selectedPlan = subscriptionController.selectedPlan;

                if (subscriptionController.subscriptionModel == null) {
                  return SizedBox(height: _availableHeight * 0.6, child: const Center(child: CustomLoader()));
                }

                if (selectedPlan == null) {
                  return SizedBox(
                    height: _availableHeight * 0.6,
                    child: Center(child: Text('no_data_found'.tr, style: context.body.small)),
                  );
                }

                if (!_hasSnappedToPeek) {
                  WidgetsBinding.instance.addPostFrameCallback((_) => _snapToPeekHeight());
                }

                return _ProPlanSheetBody(
                  subscriptionController: subscriptionController,
                  selectedPlan: selectedPlan,
                  subscribeButtonKey: _subscribeButtonKey,
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _ProPlanSheetBody extends StatelessWidget {
  final SubscriptionController subscriptionController;
  final Plans selectedPlan;
  final Key subscribeButtonKey;

  const _ProPlanSheetBody({required this.subscriptionController, required this.selectedPlan, required this.subscribeButtonKey});

  @override
  Widget build(BuildContext context) {
    final List<Plans> plans = subscriptionController.subscriptionModel?.content?.plans ?? <Plans>[];
    final List<Faqs> faqs = subscriptionController.subscriptionModel?.content?.faqs ?? <Faqs>[];

    return Padding(
      padding: const EdgeInsets.fromLTRB(Dimensions.padding16, 0, Dimensions.padding16, Dimensions.padding20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('choose_your_pro_plan'.tr, textAlign: TextAlign.center, style: context.heading.extraLarge),
                const SizedBox(height: Dimensions.padding6),

                Text('unlock_exclusive_benefits'.tr, textAlign: TextAlign.center,
                    style: context.subHeading.defaultSize.overrideWith(color: context.customThemeColors.secondaryTextColor, fontWeight: AppWeight.regular)),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.padding36),

          PlanPackageSelector(
            plans: plans,
            selectedIndex: subscriptionController.selectedPlanIndex,
            onSelected: subscriptionController.setPlanIndex,
          ),
          const SizedBox(height: Dimensions.padding16),

          PlanSummaryCard(plan: selectedPlan, benefitText: subscriptionController.benefitSummaryText),
          const SizedBox(height: Dimensions.padding20),

          CustomButton(
            key: subscribeButtonKey,
            width: Get.width * 0.6,
            radius: Dimensions.radius8,
            isLoading: subscriptionController.isLoading,
            buttonText: subscriptionController.subscribeButtonLabel,
            onPressed: (selectedPlan.isActive ?? false) ? () => _onSubscribePressed(selectedPlan) : null,
          ),
          const SizedBox(height: Dimensions.padding24),

          if (faqs.isNotEmpty) ...<Widget>[
            PlanFaqList(faqs: faqs),
            const SizedBox(height: Dimensions.padding16),
          ],

          const Center(child: PlanTermsLink()),
        ],
      ),
    );
  }

  void _onSubscribePressed(Plans plan) {
    subscriptionController.setTabIndex(subscriptionController.selectedPlanIndex);

    if (plan.type == 'paid') {
      Get.back();
      showModalBottomSheet<void>(
        context: Get.context!,
        useRootNavigator: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) => SubscriptionPaymentDialog(plan: plan),
      );
      return;
    }

    subscriptionController.paySubscriptionAmount(plan.id ?? '', '', '', '').then((Response response) {
      if (response.statusCode != 200) {
        return;
      }

      Get.back();
      SubscriptionHelper().showSuccessDialog();
      Get.find<UserController>().getUserInfo(reload: false);
      Get.find<CartController>().refreshCart();
    });
  }
}
