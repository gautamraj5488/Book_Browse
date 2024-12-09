import 'package:book_browse/models/book.dart';
import 'package:book_browse/utils/colors.dart';
import 'package:book_browse/utils/shake_detection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShakeManager extends StatefulWidget {
  final Widget child;

  const ShakeManager({required this.child, Key? key}) : super(key: key);

  @override
  _ShakeManagerState createState() => _ShakeManagerState();
}

class _ShakeManagerState extends State<ShakeManager> {
  late ShakeDetector _shakeDetector;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize shake detector
    _shakeDetector = ShakeDetector(onShake: _onShakeDetected);
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _shakeDetector.stop(); // Stop shake detection when widget is disposed
    _controller.dispose(); // Dispose text controller to avoid memory leaks
    super.dispose();
  }

  final sampleBook = Book(
    title: "The Great Gatsby",
    id: 69,
    authors: ["F", "Scott", "Fitzgerald"],
    translators: [],
    subjects: [],
    bookshelves: [],
    languages: [],
    copyright: false,
    mediaType: '',
    formats: {},
    downloadCount: 123,
  );

  void _onShakeDetected() async {
    // print("Shake detected!");

    if (Navigator.canPop(context)) {
      Navigator.pop(context);  // Close any open modal if present
    }
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    // Show modal bottom sheet
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Is there a problem?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Would you like to report an issue?",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Close the modal
                        _showReportIssueDialog();
                      },
                      child: const Text("Yes",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.errorColor),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Close the modal
                      },
                      child: const Text(
                        "No",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showReportIssueDialog() {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.5, color: SMAColors.white),
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: SMAColors.dark,
        title: const Text(
          "Report Issue",
          style: TextStyle(fontWeight: FontWeight.bold, color: SMAColors.white),
        ),
        content: TextField(
          controller: _controller,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Describe the issue...",
            hintStyle: const TextStyle(color: SMAColors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: SMAColors.info),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close dialog
            child: Text(
              "Cancel",
              style: TextStyle(color: AppColors.errorColor),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.successColor,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              // Check if the text is empty
              if (_controller.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: SMAColors.dark,
                    content: Text(
                      "Write your issue!",
                      style: TextStyle(color: AppColors.errorColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: SMAColors.dark,
                    content: Text(
                      "Thank you for your submission!\nWe sincerely apologize for the inconvenience. Rest assured, we will look into the issue as soon as possible.",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
                _controller.clear();
              }
            },
            child: const Text("Submit", style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
