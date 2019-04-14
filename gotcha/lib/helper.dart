import "package:flutter/widgets.dart";

// help me

Route buildOnboardingRoute(Widget page) {
  return new PageRouteBuilder(
      opaque: true,
      pageBuilder: (BuildContext context, _, __) {
        return page;
      });
}

