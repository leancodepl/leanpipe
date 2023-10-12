// ignore_for_file: use_design_system_item_AppTextStyle, use_design_system_item_AppTextSpan, use_design_system_item_AppWidgetSpan, use_design_system_item_AppDefaultTextStyle
import 'package:app/design_system/styleguide/colors.dart';
import 'package:app/design_system/styleguide/typography.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

sealed class AppInlineSpan {
  const AppInlineSpan();

  @mustCallSuper
  void init() {}

  @mustCallSuper
  void dispose() {}

  InlineSpan buildSpan(AppTextTransform textTransform);
}

final class AppWidgetSpan extends AppInlineSpan {
  AppWidgetSpan({
    required this.child,
    this.alignment = PlaceholderAlignment.bottom,
    this.baseline,
    this.style,
  });

  final Widget child;
  final PlaceholderAlignment alignment;
  final TextBaseline? baseline;
  final AppTextStyle? style;

  @override
  WidgetSpan buildSpan(AppTextTransform textTransform) {
    return WidgetSpan(
      child: child,
      alignment: alignment,
      baseline: baseline,
      style: style,
    );
  }
}

final class AppTextSpan extends AppInlineSpan {
  AppTextSpan({
    this.text,
    VoidCallback? onTap,
    this.style,
    this.color,
    this.children = const [],
  }) : _onTap = onTap;

  final String? text;
  final VoidCallback? _onTap;
  final AppTextStyle? style;
  final AppColor? color;
  final List<AppInlineSpan> children;

  TapGestureRecognizer? tapRecognizer;

  @override
  void init() {
    super.init();
    if (_onTap == null) {
      return;
    }
    tapRecognizer = TapGestureRecognizer()..onTap = _onTap;
  }

  @override
  void dispose() {
    tapRecognizer?.dispose();
    super.dispose();
  }

  @override
  TextSpan buildSpan(AppTextTransform textTransform) {
    final effectiveTextTrasform = style?.textTransform ?? textTransform;
    return TextSpan(
      text: switch (text) {
        final text? => effectiveTextTrasform.transform(text),
        _ => null,
      },
      recognizer: tapRecognizer,
      style: (style ?? const TextStyle()).copyWith(color: color),
      children: children
          .map((span) => span.buildSpan(effectiveTextTrasform))
          .toList(),
    );
  }
}

class AppText extends StatefulWidget {
  const AppText(
    String this.text, {
    super.key,
    required this.style,
    this.color,
    this.textAlign,
    this.maxLines,
  }) : data = const [];

  const AppText.rich(
    this.data, {
    super.key,
    required this.style,
    this.color,
    this.textAlign,
    this.maxLines,
  }) : text = null;

  final String? text;
  final List<AppInlineSpan> data;
  final AppTextStyle style;
  final AppColor? color;
  final TextAlign? textAlign;
  final int? maxLines;

  @override
  _AppTextState createState() => _AppTextState();
}

class _AppTextState extends State<AppText> {
  @override
  void initState() {
    super.initState();
    for (final span in widget.data) {
      span.init();
    }
  }

  @override
  void didUpdateWidget(AppText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      for (final span in oldWidget.data) {
        span.dispose();
      }
      for (final span in widget.data) {
        span.init();
      }
    }
  }

  @override
  void dispose() {
    for (final span in widget.data) {
      span.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = DefaultTextStyle.of(context);
    final span = _mapToStandardTree(context);
    final effectiveMaxLines = widget.maxLines ?? defaultTextStyle.maxLines;

    // ignore: use_design_system_item_AppText
    return Text.rich(
      span,
      textAlign: widget.textAlign,
      maxLines: effectiveMaxLines,
      overflow: effectiveMaxLines != null ? TextOverflow.ellipsis : null,
    );
  }

  InlineSpan _mapToStandardTree(BuildContext context) {
    final defaultTextStyle = DefaultTextStyle.of(context);
    final effectiveTextStyle = defaultTextStyle.style.merge(widget.style);

    final children = widget.data
        .map((span) => span.buildSpan(widget.style.textTransform))
        .toList();

    return TextSpan(
      text: switch (widget.text) {
        final text? => widget.style.textTransform.transform(text),
        _ => null,
      },
      style: effectiveTextStyle.copyWith(color: widget.color),
      children: switch (children.length) {
        > 0 => children,
        _ => null,
      },
    );
  }
}

class AppDefaultTextStyle extends StatelessWidget {
  const AppDefaultTextStyle({
    super.key,
    required this.child,
    this.style,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final Widget child;
  final AppTextStyle? style;
  final AppColor? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = DefaultTextStyle.of(context);
    final effectiveTextStyle = defaultTextStyle.style.merge(style);

    return DefaultTextStyle.merge(
      style: effectiveTextStyle.copyWith(color: color),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      child: child,
    );
  }
}
