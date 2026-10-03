import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class LoginMediumTabs extends StatelessWidget {
  final bool isNumberLogin;
  final ValueChanged<bool> onChanged;
  const LoginMediumTabs({super.key, required this.isNumberLogin, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _LoginMediumTabItem(
          label: 'email'.tr, selected: !isNumberLogin,
          onTap: (){
            if(!isNumberLogin) return;
            onChanged(false);
          },
        )),
        Expanded(child: _LoginMediumTabItem(
          label: 'phone'.tr, selected: isNumberLogin,
          onTap: (){
            if(isNumberLogin) return;
            onChanged(true);
          },
        )),
      ],
    );
  }
}

class _LoginMediumTabItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _LoginMediumTabItem({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).colorScheme.primary;
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.padding10),
            child: Text(label, textAlign: TextAlign.center,
              style: context.subHeading.defaultSize.overrideWith(
                fontWeight: selected ? AppWeight.medium : AppWeight.regular,
                color: selected ? activeColor : Theme.of(context).hintColor,
              ),
            ),
          ),
          Container(height: 2, color: selected ? activeColor : Colors.transparent),
        ],
      ),
    );
  }
}
