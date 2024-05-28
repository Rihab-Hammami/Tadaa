import 'package:flutter/material.dart';

class InfoWidget extends StatefulWidget {
  final String initialText;
  final Function(String) onSubmit;

  const InfoWidget({Key? key, required this.initialText, required this.onSubmit}) : super(key: key);

  @override
  _InfoWidgetState createState() => _InfoWidgetState();
}

class _InfoWidgetState extends State<InfoWidget> {
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
        title: Text('Info Widget'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: TextFormField(
                controller: _textEditingController,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: 'Enter your information',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Pass the entered text back to the caller
                widget.onSubmit(_textEditingController.text);
                Navigator.pop(context); // Close the InfoWidget
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
