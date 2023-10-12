import 'package:app/common/util/colors_context_extension.dart';
import 'package:app/design_system_old/app_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppPinCodeInputController extends ChangeNotifier {
  void clear() {
    notifyListeners();
  }
}

class AppPinCodeInput extends StatefulWidget {
  const AppPinCodeInput({
    super.key,
    required this.fieldsCount,
    required this.title,
    required this.onComplete,
    required this.controller,
  });
  final int fieldsCount;
  final String title;
  final ValueChanged<String> onComplete;
  final AppPinCodeInputController controller;

  @override
  _PinCodeTextFieldState createState() => _PinCodeTextFieldState();
}

class _PinCodeTextFieldState extends State<AppPinCodeInput> {
  final _focusNode = FocusNode();
  final _textEditingController = TextEditingController();

  List<String> get _inputList => _textEditingController.text.split('');
  int get _selectedIndex => _textEditingController.text.length;

  @override
  void initState() {
    _textEditingController.addListener(_textEditingControllerListener);
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController
      ..removeListener(_textEditingControllerListener)
      ..dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText(
          widget.title,
          style: AppTextStyle.subtitle,
        ),
        const SizedBox(
          height: 16,
        ),
        SizedBox(
          height: 40,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              AbsorbPointer(
                child: TextFormField(
                  focusNode: _focusNode,
                  controller: _textEditingController,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(widget.fieldsCount),
                  ],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  showCursor: false,
                  style: TextStyle(
                    color: colors.transparent,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _onFocus,
                  child: ListenableBuilder(
                    listenable: _textEditingController,
                    builder: (context, _) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _generateFields(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _textEditingControllerListener() {
    final currentText = _textEditingController.text;
    if (currentText.length >= widget.fieldsCount) {
      Future.delayed(
        const Duration(milliseconds: 300),
        () => widget.onComplete(currentText),
      );
    }
  }

  void _onFocus() {
    _focusNode.requestFocus();
  }

  List<Widget> _generateFields() {
    final colors = context.colors;

    final result = <Widget>[];
    for (var i = 0; i < widget.fieldsCount; i++) {
      final currentField = (i == _selectedIndex);
      result.add(
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(
              color: currentField
                  ? colors.bgInfoPrimaryPressed
                  : colors.bgInfoSecondary,
              width: 2,
            ),
            color: currentField
                ? colors.fgDefaultPrimary
                : colors.fgDefaultSecondary,
          ),
          child: buildChild(i),
        ),
      );
    }
    return result;
  }

  Widget buildChild(int index) {
    return _renderPinField(index: index);
  }

  Widget _renderPinField({
    required int index,
  }) {
    final text = _inputList.elementAtOrNull(index) ?? '';
    return Center(
      child: AppText(
        text,
        style: AppTextStyle.button,
        key: ValueKey(text),
      ),
    );
  }
}
