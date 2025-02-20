import 'package:flutter/cupertino.dart';
import '../../../constants/colors.dart';
import '../curvedEdges/curved_edges_widget.dart';
import 'circular_container.dart';

class HeaderContainer extends StatelessWidget {
  const HeaderContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RCurvedEdgeWidgets(
      child: Container(
        color: RColors.orange,
        padding: const EdgeInsets.all(0),
        child: SizedBox(
          height: 300,
          child: Stack(
            children: [
              Positioned(top: -150, right: -250, child: RCircularContainer()),
              Positioned(top: 100, right: -300, child: RCircularContainer()),
            ],
          ),
        ),
      ),
    );
  }
}