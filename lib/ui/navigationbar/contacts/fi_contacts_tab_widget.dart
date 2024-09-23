import 'package:flutter/material.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';
import '../../base/fi_base_widget.dart';
import '../../../utils/fi_display.dart';
import '../../base/fi_base_state.dart';
import 'fi_contacts_tab_model.dart';

enum FiContactPageType { current, private, divider, addingToGroup }

class FiContactsTabWidget extends FiBaseWidget {
  const FiContactsTabWidget({super.key});

  @override
  State<StatefulWidget> createState() => _FiContactsTabState();
}

class _FiContactsTabState extends FiBaseState<FiContactsTabWidget> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    contacts.setState(this);
  }

  @override
  void dispose() {
    contacts.setState(null);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget get content => ConstraintLayout(
    width: matchParent,
    height: matchParent,
    children: [
      Column(children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: contacts.pageCount,
            itemBuilder: (BuildContext context, int index) {
              return contacts.pageAtIndex(index);
            },
            onPageChanged: (index) {
              setState(() {
                display.closeKeyboard();
                contacts.currentPageIndex = index;
                _selectedIndex = index;
              });
            },
          ),
        )
      ]).applyConstraint(
          left: parent.left,
          right: parent.right,
          top: parent.top,
          bottom: parent.bottom,
          width: matchConstraint,
          height: matchConstraint),
    ],
  );
}
