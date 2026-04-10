import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiveFeedScreen extends StatelessWidget {
  const LiveFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4F6F8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "CENTRAL COMMAND: LIVE OSINT FEED",
                  style: TextStyle(
                    color: Color(0xFF0F4C81),
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Real-Time Risk Detection & Multi-Source Intelligence",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('intelligence_reports')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF0F4C81)));
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      "SYSTEM ERROR: Unable to synchronize classified datastreams.",
                      style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shield, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        const Text(
                          "ALL ZONES SECURE",
                          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                        ),
                        const Text(
                          "No critical event chains detected globally.",
                          style: TextStyle(color: Colors.black45),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    final analysis = data['analysis'] as Map<String, dynamic>? ?? {};
                    
                    final level = analysis['riskLevel'] ?? 'UNKNOWN';
                    final location = analysis['primaryLocation'] ?? 'Unknown Region';
                    
                    final eventsMap = analysis['eventTypes'] as Map<String, dynamic>? ?? {};
                    final eventList = eventsMap.keys.toList();
                    final eventStr = eventList.isNotEmpty ? eventList.join(' / ') : 'Anomalous Activity';
                    
                    final riskScoreRaw = analysis['riskScore'] ?? 0;
                    final confidenceRaw = analysis['confidence'] ?? 0.0;
                    final totalAnalyzed = analysis['totalAnalyzed'] ?? 0;
                    
                    final summary = data['summary'] ?? "No summary available.";
                    final simulation = data['simulation'] ?? "Simulation models offline.";
                    
                    final explainabilityRaw = data['explainability'];
                    final List<String> explainability = explainabilityRaw is List 
                        ? explainabilityRaw.map((e) => e.toString()).toList() 
                        : ["Threat vector unspecified."];
                        
                    final sourcesRaw = data['sources'];
                    final List<String> sources = sourcesRaw is List 
                        ? sourcesRaw.map((e) => e.toString()).toList() 
                        : [];

                    final timestamp = data['timestamp'] as String?;
                    final DateTime? parsedTime = timestamp != null ? DateTime.tryParse(timestamp) : null;
                    String timeLabel = "LIVE";
                    if (parsedTime != null) {
                      final diff = DateTime.now().difference(parsedTime);
                      if (diff.inMinutes < 60) timeLabel = "T-${diff.inMinutes} MINS";
                      else if (diff.inHours < 24) timeLabel = "T-${diff.inHours} HRS";
                    }

                    Color levelColor = Colors.grey;
                    if (level == 'CRITICAL') levelColor = const Color(0xFFD32F2F);
                    else if (level == 'HIGH') levelColor = const Color(0xFFE64A19);
                    else if (level == 'MEDIUM') levelColor = const Color(0xFFF57C00);
                    else if (level == 'LOW') levelColor = const Color(0xFF388E3C);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: _buildCommanderReportCard(
                        level: level,
                        color: levelColor,
                        location: location,
                        event: eventStr.toUpperCase(),
                        confidence: confidenceRaw.toDouble(),
                        riskScore: riskScoreRaw.toDouble(),
                        totalAnalyzed: totalAnalyzed,
                        summary: summary,
                        simulation: simulation,
                        explainability: explainability,
                        sources: sources,
                        time: timeLabel,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommanderReportCard({
    required String level,
    required Color color,
    required String location,
    required String event,
    required double confidence,
    required double riskScore,
    required int totalAnalyzed,
    required String summary,
    required String simulation,
    required List<String> explainability,
    required List<String> sources,
    required String time,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER: RISK BAR
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TOP METADATA ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(color: color.withOpacity(0.3)),
                      ),
                      child: Text(
                        "THREAT LEVEL: $level",
                        style: TextStyle(color: color, fontSize: 11.0, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(color: Colors.red[900], fontSize: 12.0, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16.0),
                
                // LOCATION AND EVENT
                Text(
                  location.toUpperCase(),
                  style: const TextStyle(color: Colors.black87, fontSize: 22.0, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4.0),
                Text(
                  "PRIMARY VECTOR: $event",
                  style: TextStyle(color: Colors.grey[700], fontSize: 13.0, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                ),

                const SizedBox(height: 20.0),

                // METRICS GRID
                Container(
                  padding: const EdgeInsets.all(12.0),
                  color: const Color(0xFFF8F9FA),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetricNode("RISK INDEX", "${riskScore.toInt()}/100", color),
                      _buildMetricNode("CONFIDENCE", "${(confidence * 100).toInt()}%", Colors.black87),
                      _buildMetricNode("DATA NODES", "$totalAnalyzed Articles", Colors.black87),
                    ],
                  ),
                ),

                const SizedBox(height: 20.0),

                // EXECUTIVE SUMMARY
                const Text("EXECUTIVE SUMMARY (AI-GENERATED)", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F4C81), letterSpacing: 1.0)),
                const SizedBox(height: 6),
                Text(summary, style: const TextStyle(color: Colors.black87, fontSize: 14.0, height: 1.5)),

                const SizedBox(height: 20.0),
                const Divider(height: 1),
                const SizedBox(height: 20.0),

                // EXPLAINABLE AI (XAI) LOGIC
                const Text("EXPLAINABLE AI: DETECTION FACTORS", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F4C81), letterSpacing: 1.0)),
                const SizedBox(height: 8),
                ...explainability.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 4.0, right: 8.0),
                        child: Icon(Icons.arrow_right, size: 16, color: Color(0xFF0F4C81)),
                      ),
                      Expanded(child: Text(f, style: TextStyle(color: Colors.grey[800], fontSize: 13))),
                    ],
                  ),
                )),

                const SizedBox(height: 20.0),
                
                // SIMULATION ENGINE
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0), // Warning Orange wash
                    border: Border(left: BorderSide(color: Colors.orange.shade700, width: 4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("24-48HR ESCALATION SIMULATION", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.orange.shade900, letterSpacing: 1.0)),
                      const SizedBox(height: 6),
                      Text(simulation, style: const TextStyle(color: Colors.black87, fontSize: 13.0, height: 1.5, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),

                const SizedBox(height: 20.0),

                // SOURCE GRAPH
                if (sources.isNotEmpty) ...[
                  const Text("VERIFIED OSINT DATALINKS", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F4C81), letterSpacing: 1.0)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: sources.take(3).map((url) {
                      String domain = "unknown domain";
                      try { domain = Uri.parse(url).host.replaceFirst('www.', ''); } catch (_) {}
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.link, size: 12, color: Colors.black54),
                            const SizedBox(width: 4),
                            Text(domain, style: const TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  if (sources.length > 3)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text("+ ${sources.length - 3} additional encrypted sources tracked by pipeline.", style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                    )
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricNode(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
      ],
    );
  }
}