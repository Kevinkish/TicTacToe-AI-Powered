import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:tic_tac_toe/ui/views/maze/maze_page.dart';

import '../../ui/ui.dart';
import 'routes.dart';

GoRoute homeRoute = GoRoute(
  path: RoutesPaths.home,
  name: RoutesNames.home,
  builder: (context, state) {
    return HomePage();
  },
);
GoRoute mazeRoute = GoRoute(
  path: RoutesPaths.maze,
  name: RoutesNames.maze,
  builder: (context, state) {
    return MazePage();
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
  routes: [homeRoute, mazeRoute],
);
