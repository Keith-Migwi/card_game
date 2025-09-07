import 'package:flutter/material.dart';

class SnapPhysics extends BouncingScrollPhysics {
  const SnapPhysics({super.parent});

  @override
  SnapPhysics applyTo(ScrollPhysics? ancestor) {
    return SnapPhysics(parent: buildParent(ancestor));
  }

  @override
  double get minFlingVelocity => 50.0;

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    final sim = super.createBallisticSimulation(position, velocity);

    // Snap left when at start
    if (position.pixels <= position.minScrollExtent &&
        velocity.abs() < 200) {
      return ScrollSpringSimulation(
        spring,
        position.pixels,
        position.minScrollExtent,
        velocity,
        tolerance: tolerance,
      );
    }

    // Snap right when at end
    if (position.pixels >= position.maxScrollExtent &&
        velocity.abs() < 200) {
      return ScrollSpringSimulation(
        spring,
        position.pixels,
        position.maxScrollExtent,
        velocity,
        tolerance: tolerance,
      );
    }

    return sim;
  }
}
