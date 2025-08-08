import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../ui/ui.dart';
import 'routes.dart';

GoRoute homeRoute = GoRoute(
  path: RoutesPaths.home,
  name: RoutesNames.home,
  builder: (context, state) {
    return HomePage();
  },
);

GoRouter goRouter = GoRouter(
  initialLocation: RoutesPaths.home,
  errorBuilder: (context, state) {
    return Text("");
  },
  redirect: (context, state) async {
    return null;
  },
  routes: [homeRoute],
);
