import 'package:flutter/material.dart';

class PinInput extends StatefulWidget {
  final String pin;
  final void Function() onPassed;
  final void Function() onFailed;

  PinInput({@required this.pin, @required this.onPassed, this.onFailed});

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
    for (int i = 0; i < 4; i++) {
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
          4,
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
            if (_currentFocusNode == 3) {
              if (_pin.join() == widget.pin) {
                // Pass
                widget.onPassed();
              } else {
                // Failed
                for (int i = 0; i < 4; i++) {
                  _textControllers[i].clear();
                }
                _currentFocusNode = 0;
                FocusScope.of(context)
                    .requestFocus(_focusNodes[_currentFocusNode]);
                if (widget.onFailed != null) {
                  widget.onFailed();
                }
              }
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
