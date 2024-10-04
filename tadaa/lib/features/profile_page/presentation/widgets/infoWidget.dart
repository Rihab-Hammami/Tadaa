import 'package:flutter/material.dart';

class InfoWidget extends StatefulWidget {
  final String initialText;
  final ValueChanged<String>? onSubmit;

  const InfoWidget({Key? key, required this.initialText, this.onSubmit}) : super(key: key);

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
        title: Text('Edit Info'),
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
                  // Call the onSubmit callback if it's provided
                  if (widget.onSubmit != null) {
                    widget.onSubmit!(_textEditingController.text);
                  }
                  
                  // Pass the entered text back to the parent widget
                  Navigator.pop(context, _textEditingController.text);
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
