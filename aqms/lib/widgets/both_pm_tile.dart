import 'package:aqms/widgets/pm_tile.dart';
import 'package:flutter/material.dart';

class BothPMTile extends StatelessWidget {
  final int pmTwoPointFiveValue, pmTenValue;

  const BothPMTile({
    super.key,
    required this.pmTwoPointFiveValue,
    required this.pmTenValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          PMTile(pmType: 2.5, pmValue: pmTwoPointFiveValue),
          PMTile(pmType: 10, pmValue: pmTenValue),
        ],
      ),
    );
  }
}
