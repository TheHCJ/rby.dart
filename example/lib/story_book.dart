import 'package:flutter/material.dart';
import 'package:rby_widgets/rby_widgets.dart';

class StorybookEntry {
  const StorybookEntry({
    required this.label,
    required this.builder,
  }) : assert(label.length > 0);

  final String label;
  final WidgetBuilder builder;
}

/// A storybook-like scaffold for building example entries.
class Storybook extends StatefulWidget {
  const Storybook({
    required this.title,
    required this.entries,
  });

  final Widget title;
  final List<StorybookEntry> entries;

  @override
  State<Storybook> createState() => _StorybookState();
}

class _StorybookState extends State<Storybook> {
  final _controller = PageController();

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: widget.title),
      body: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _NavigationRail(
            controller: _controller,
            entries: widget.entries,
          ),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.entries.length,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => Padding(
                padding: theme.edgeInsets.copyWith(start: 0),
                child: Center(
                  child: widget.entries[index].builder(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationRail extends StatelessWidget {
  const _NavigationRail({
    required this.controller,
    required this.entries,
  });

  final PageController controller;
  final List<StorybookEntry> entries;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: theme.edgeInsets,
      constraints: const BoxConstraints(maxWidth: 256),
      child: Material(
        color: theme.colorScheme.primary,
        borderRadius: theme.borderRadius,
        clipBehavior: Clip.antiAlias,
        child: ListView.builder(
          itemCount: entries.length,
          itemBuilder: (_, index) => ListTile(
            title: FittedBox(
              fit: BoxFit.scaleDown,
              child: AnimatedBuilder(
                animation: controller,
                builder: (_, __) => Text(
                  entries[index].label,
                  style: TextStyle(
                    color: Color.lerp(
                      theme.colorScheme.onPrimary,
                      theme.colorScheme.onPrimary.withOpacity(.5),
                      ((controller.page ?? 0) - index).abs().clamp(0, 1),
                    ),
                  ),
                ),
              ),
            ),
            onTap: () => controller.animateToPage(
              index,
              duration: kShortAnimationDuration,
              curve: Curves.easeOutCubic,
            ),
          ),
        ),
      ),
    );
  }
}
