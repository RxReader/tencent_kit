import 'package:fake_tencent/src/tencent.dart';
import 'package:flutter/widgets.dart';

class TencentProvider extends InheritedWidget {
  TencentProvider({
    Key key,
    @required this.tencent,
    @required Widget child,
  }) : super(key: key, child: child);

  final Tencent tencent;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    TencentProvider oldProvider = oldWidget as TencentProvider;
    return tencent != oldProvider.tencent;
  }

  static TencentProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(TencentProvider)
        as TencentProvider;
  }
}
