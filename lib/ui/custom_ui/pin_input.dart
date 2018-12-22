import 'package:flutter/material.dart';

class PinInput extends StatefulWidget {
  final void Function(String) onSubmited;
  final int length;

  PinInput({
    @required this.onSubmited,
    this.length = 4,
  });

  _PinInputState createState() => _PinInputState();
}

class _PinInputState extends State<PinInput> {
  // Variable
  List<String> _pin;
  List<FocusNode> _focusNodes;
  List<TextEditingController> _textControllers;
  int _currentFocusNode;

  // Business
  @override
  void initState() {
    _pin = List<String>();
    _focusNodes = List<FocusNode>();
    _textControllers = List<TextEditingController>();
    for (int i = 0; i < widget.length; i++) {
      _focusNodes.add(FocusNode());
      _textControllers.add(TextEditingController());
    }
    _currentFocusNode = 0;

    super.initState();
  }

  @override
  void dispose() {
    _textControllers.forEach((TextEditingController t) => t.dispose());
    super.dispose();
  }

  void clearTextField() {
    _textControllers.forEach((TextEditingController t) => t.clear());
    _pin.clear();
    _currentFocusNode = 0;
    FocusScope.of(context).requestFocus(_focusNodes[_currentFocusNode]);
  }

  // Layout
  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(_focusNodes[_currentFocusNode]);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          widget.length,
          (int index) {
            return _buildTextField(context, index);
          },
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      width: 50.0,
      child: TextField(
        controller: _textControllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        obscureText: true,
        focusNode: _focusNodes[index],
        autofocus: index == 0,
        onChanged: (String value) {
          if (value == null || value == '') {
            _pin.removeLast();
            _currentFocusNode = (index - 1) < 0 ? 0 : (index - 1);
            FocusScope.of(context).requestFocus(_focusNodes[_currentFocusNode]);
          } else {
            _pin.add(value);
            if (_currentFocusNode == widget.length - 1) {
              for (int i = 0; i < widget.length; i++) {
                _textControllers[i].clear();
              }
              _currentFocusNode = 0;
              FocusScope.of(context)
                  .requestFocus(_focusNodes[_currentFocusNode]);
              widget.onSubmited(_pin.join());
              _pin.clear();
            } else {
              _currentFocusNode += 1;
              FocusScope.of(context)
                  .requestFocus(_focusNodes[_currentFocusNode]);
            }
          }
        },
      ),
    );
  }
}
