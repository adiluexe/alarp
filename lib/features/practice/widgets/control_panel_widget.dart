// control_panel_widget.dart
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import '../../../core/theme/app_theme.dart';
import 'position_controls_widget.dart';
import 'collimation_controls_widget.dart';
import 'guide_content_widget.dart';

class ControlPanelWidget extends StatefulWidget {
  const ControlPanelWidget({Key? key}) : super(key: key);

  @override
  State<ControlPanelWidget> createState() => _ControlPanelWidgetState();
}

class _ControlPanelWidgetState extends State<ControlPanelWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab bar
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: Colors.grey,
            indicator: MaterialIndicator(
              height: 3,
              topLeftRadius: 0,
              topRightRadius: 0,
              bottomLeftRadius: 5,
              bottomRightRadius: 5,
              color: AppTheme.primaryColor,
            ),
            tabs: const [
              Tab(icon: Icon(Icons.rotate_90_degrees_cw), text: 'Positioning'),
              Tab(icon: Icon(Icons.crop_free), text: 'Collimation'),
              Tab(icon: Icon(Icons.help_outline), text: 'Guide'),
            ],
          ),
        ),

        // Tab content
        SizedBox(
          height: 300,
          child: TabBarView(
            controller: _tabController,
            children: const [
              PositionControlsWidget(),
              CollimationControlsWidget(),
              GuideContentWidget(),
            ],
          ),
        ),
      ],
    );
  }
}
