import 'package:flutter/material.dart';
import '../core/pipeline/pipeline_service.dart';

class QueryScreen extends StatefulWidget {
  const QueryScreen({super.key});

  @override
  State<QueryScreen> createState() => _QueryScreenState();
}

class _QueryScreenState extends State<QueryScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [
    {
      "role": "ai",
      "text": "I am the Conflict Prediction System. Ask me about real-time risks, recent events, or run a 'what-if' simulation."
    }
  ];
  bool _isLoading = false;

  Future<void> _sendMessage() async {
    final queryText = _controller.text.trim();
    if (queryText.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "text": queryText});
      _isLoading = true;
    });
    
    _controller.clear();

    try {
      // Direct pipeline query invocation locally mapping via frontend.
      final String aiAnswer = await IntelligencePipelineService.askIntelligenceSystem(queryText);

      setState(() {
        _messages.add({"role": "ai", "text": aiAnswer});
      });
    } catch (e) {
      debugPrint("Agent Interaction Error: $e");
      setState(() {
        _messages.add({"role": "ai", "text": "Pipeline Execution Error:\n$e\n\nPlease ensure your E:\\Project\\Sunhack\\.env file is completely correct and that you have fully stopped and restarted the app to load the new config bundles."});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final msg = _messages[index];
              final isAi = msg['role'] == 'ai';
              return Align(
                alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.85,
                  ),
                  decoration: BoxDecoration(
                    color: isAi ? const Color(0xFF2C2C2C) : const Color(0xFF007AFF),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Text(
                    msg['text'] ?? "",
                    style: const TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
              );
            },
          ),
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white38, strokeWidth: 2)),
                SizedBox(width: 8),
                Text("Analyzing stream OSINT context...", style: TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: const BoxDecoration(
            color: Color(0xFF1E1E1E),
            border: Border(top: BorderSide(color: Colors.white10)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    hintText: "Query the intelligence system...",
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: const Color(0xFF2C2C2C),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8.0),
              GestureDetector(
                onTap: _isLoading ? null : _sendMessage,
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: _isLoading ? Colors.grey : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_upward, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
