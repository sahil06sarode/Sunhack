import 'package:flutter/material.dart';

import 'package:conflictsense/screens/ai_research/models/research_models.dart';

const List<String> kSmartPrompts = [
  'Summarize topic',
  'Compare technologies',
  'Generate ideas',
  'Explain simply',
  'Predict future trends',
];

const List<MiniToolData> kMiniTools = [
  MiniToolData(
    label: 'Brainstorm',
    icon: Icons.lightbulb_outline_rounded,
    seedPrompt: 'Brainstorm advanced research ideas about ',
  ),
  MiniToolData(
    label: 'Summarize',
    icon: Icons.short_text_rounded,
    seedPrompt: 'Summarize key findings for ',
  ),
  MiniToolData(
    label: 'Simulate (What If)',
    icon: Icons.timeline_rounded,
    seedPrompt: 'Run a what-if simulation for ',
  ),
  MiniToolData(
    label: 'Analyze',
    icon: Icons.analytics_outlined,
    seedPrompt: 'Analyze trade-offs for ',
  ),
];

const List<String> kSavedResearchTopics = [
  'Conflict Forecasting Models',
  'AI Governance and Safety',
  'Multimodal Reasoning Pipelines',
  'Emerging Cybersecurity Threats',
  'Startup Innovation Signals',
];

const List<ResearchFeedItem> kSuggestedResearchFeed = [
  ResearchFeedItem(
    image: 'https://picsum.photos/seed/research-01/1200/720',
    headline: 'AI agents are moving from chat answers to autonomous workflows',
    preview:
        'New orchestration patterns show how agents coordinate retrieval, tools, and validation.',
    content:
        'Research teams are documenting a shift from isolated chat responses to full autonomous workflows. The latest studies show stronger results when planners, executors, and verifiers operate as independent but coordinated layers.\n\nThis architecture improves reliability and creates better audit trails in research-heavy environments.',
    category: 'AI Systems',
  ),
  ResearchFeedItem(
    image: 'https://picsum.photos/seed/research-02/1200/720',
    headline:
        'Hybrid RAG stacks outperform pure vector retrieval in dense domains',
    preview:
        'Benchmarks indicate measurable gains when lexical and semantic retrieval are combined.',
    content:
        'Recent evaluations across legal, policy, and biomedical corpora found that hybrid retrieval consistently improves precision for long-context questions.\n\nTeams adopting hybrid retrieval are also reducing hallucinations in citation-heavy responses.',
    category: 'Research',
  ),
  ResearchFeedItem(
    image: 'https://picsum.photos/seed/research-03/1200/720',
    headline:
        'Scenario simulation tools are becoming standard in decision intelligence',
    preview:
        'Organizations use what-if engines to test operational and policy outcomes before launch.',
    content:
        'What-if simulation is now central in decision intelligence. Teams test strategic assumptions, compare constraints, and pre-evaluate outcomes before committing to execution plans.\n\nThis approach helps reduce costly reversals in volatile environments.',
    category: 'Simulation',
  ),
  ResearchFeedItem(
    image: 'https://picsum.photos/seed/research-04/1200/720',
    headline:
        'Open-source model eval frameworks simplify continuous quality monitoring',
    preview:
        'Evaluation-as-code workflows are enabling reproducible regression checks.',
    content:
        'Open evaluation frameworks now support reproducible checks across latency, factuality, and reasoning depth.\n\nTeams embedding these checks into CI pipelines are detecting regressions earlier and shipping with higher confidence.',
    category: 'Model Ops',
  ),
  ResearchFeedItem(
    image: 'https://picsum.photos/seed/research-05/1200/720',
    headline:
        'Cross-modal reasoning still struggles with long-form visual evidence',
    preview:
        'Studies reveal persistent gaps in linking images, charts, and textual claims over long context.',
    content:
        'Although multimodal systems improve rapidly, long-form visual grounding remains a challenge. Performance declines when systems must align many diagrams and narratives in one answer.\n\nResearchers suggest structured intermediate representations to close this gap.',
    category: 'Multimodal',
  ),
  ResearchFeedItem(
    image: 'https://picsum.photos/seed/research-06/1200/720',
    headline:
        'Policy labs publish methods to measure model uncertainty in production',
    preview:
        'Uncertainty-aware outputs are now used to gate downstream automation steps.',
    content:
        'A growing body of work focuses on practical uncertainty scoring for production AI systems. Teams now use confidence ranges to decide when to defer to human review.\n\nThis pattern is improving both reliability and user trust.',
    category: 'AI Safety',
  ),
  ResearchFeedItem(
    image: 'https://picsum.photos/seed/research-07/1200/720',
    headline:
        'Data-centric tuning beats brute-force model scaling in niche tasks',
    preview:
        'Curated datasets and labeling standards often produce bigger quality gains than larger models.',
    content:
        'Organizations are reporting that targeted dataset quality improvements can outperform broad model scaling for domain-specific tasks.\n\nThe strongest gains come from better label consistency and coverage of edge cases.',
    category: 'Data Strategy',
  ),
  ResearchFeedItem(
    image: 'https://picsum.photos/seed/research-08/1200/720',
    headline:
        'Startup intelligence platforms map weak signals earlier with AI clustering',
    preview:
        'AI clustering detects emerging sectors before mainstream trend visibility.',
    content:
        'Trend intelligence teams are using clustering pipelines to identify weak startup signals across funding, hiring, and product launches.\n\nEarlier detection improves strategic positioning for investors and ecosystem builders.',
    category: 'Innovation',
  ),
];
