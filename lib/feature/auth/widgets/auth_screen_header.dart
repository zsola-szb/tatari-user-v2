import 'package:tatarigigs_user/util/core_export.dart';

class AuthScreenHeader extends StatelessWidget {
  final bool exitFromApp;
  const AuthScreenHeader({super.key, required this.exitFromApp});

  @override
  Widget build(BuildContext context) {
    if(exitFromApp){
      return const SizedBox(height: Dimensions.padding10);
    }
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.padding10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios_new, size: 20, color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.close, size: 22, color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
        ],
      ),
    );
  }
}
