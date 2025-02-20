import 'package:flutter/cupertino.dart';
import 'curved_edges.dart';

class RCurvedEdgeWidgets extends StatelessWidget {
  const RCurvedEdgeWidgets({
    super.key, this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: RCustomCurvedEdges(),
      child: child,
    );
  }
}