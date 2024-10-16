import 'package:flutter/material.dart';

class PositionWidget extends StatefulWidget {
  final String initialText;
  final ValueChanged<String>? onSubmit;

  const PositionWidget({Key? key, required this.initialText, this.onSubmit}) : super(key: key);

  @override
  _PositionWidgetState createState() => _PositionWidgetState();
}

class _PositionWidgetState extends State<PositionWidget> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.initialText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Enter your position',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard when tapping outside
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    hintText: 'Enter your position',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final updatedText = _textEditingController.text;

                  // Call the onSubmit callback if provided
                  if (widget.onSubmit != null) {
                    widget.onSubmit!(updatedText);
                  }                 
                  Navigator.pop(context, updatedText); // Pass back the updated text
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
