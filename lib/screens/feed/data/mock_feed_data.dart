import 'package:conflictsense/screens/feed/models/feed_item.dart';

const List<FeedItem> mockFeedItems = [
  FeedItem(
    image:
        'https://images.unsplash.com/photo-1677442136019-21780ecad995?auto=format&fit=crop&w=1200&q=80',
    title: 'Open AI models are now running reliably on edge devices',
    description:
        'Teams are shipping lightweight model runtimes to phones and low-power hardware.',
    content:
        'Recent tooling updates make it practical to deploy compact AI models directly on edge devices. This shift improves response time and gives product teams stronger privacy guarantees because less data needs to leave the device.\n\nFor startups, this means AI features can be integrated into everyday workflows without forcing users to depend on constant high-bandwidth connectivity. Experts expect this to unlock a new wave of on-device assistants and adaptive interfaces in 2026.',
    category: 'AI',
    source: 'AI Weekly',
    timeAgo: '2h ago',
  ),
  FeedItem(
    image:
        'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1200&q=80',
    title: 'Chip makers push power-efficient compute for mobile AI workloads',
    description:
        'New architectures target sustained performance for local reasoning and multimodal tasks.',
    content:
        'Semiconductor companies are introducing generation-over-generation gains in efficiency, with specialized AI acceleration paths tuned for inference under thermal limits.\n\nThis trend is important for consumer apps and enterprise mobility scenarios where battery life remains a hard requirement. Product teams building mobile-first intelligence apps can now target richer local interactions while preserving smooth user experience.',
    category: 'Technology',
    source: 'Tech Dispatch',
    timeAgo: '4h ago',
  ),
  FeedItem(
    image:
        'https://images.unsplash.com/photo-1559526324-593bc073d938?auto=format&fit=crop&w=1200&q=80',
    title: 'B2B startup funding rebounds around vertical AI copilots',
    description:
        'Investors are favoring products with clear deployment paths and measurable workflow impact.',
    content:
        'Funding activity is rising again for startups that can demonstrate practical adoption in domains like legal operations, logistics, and compliance. Rather than broad platforms, investors are rewarding focused products that reduce task time in measurable ways.\n\nFounders report faster design-partner cycles when they bring prebuilt integrations and explicit trust controls from day one. This changes how early teams define product milestones and go-to-market sequencing.',
    category: 'Startups',
    source: 'Venture Lens',
    timeAgo: '6h ago',
  ),
  FeedItem(
    image:
        'https://images.unsplash.com/photo-1532012197267-da84d127e765?auto=format&fit=crop&w=1200&q=80',
    title:
        'New benchmark compares retrieval strategies for long-context reasoning',
    description:
        'Research highlights when hybrid retrieval beats purely vector-based pipelines.',
    content:
        'A newly published benchmark evaluates retrieval quality across multilingual and domain-specific corpora. Findings suggest that hybrid retrieval approaches improve precision in scenarios where terminology is dense and context windows are saturated.\n\nThe study also proposes standardized evaluation prompts that make it easier for product teams to compare systems over time. This can help organizations avoid regressions during model and embedding upgrades.',
    category: 'Research',
    source: 'Paper Radar',
    timeAgo: '8h ago',
  ),
  FeedItem(
    image:
        'https://images.unsplash.com/photo-1569025690938-a00729c9e1d1?auto=format&fit=crop&w=1200&q=80',
    title: 'AI-driven risk tooling expands in treasury and market operations',
    description:
        'Financial teams are blending real-time signals with scenario engines for forecasting.',
    content:
        'Finance organizations are accelerating adoption of AI tooling in cash forecasting, liquidity planning, and market monitoring. Better data connectors and explainability dashboards have lowered adoption friction across risk-sensitive teams.\n\nAnalysts note that the most successful rollouts focus on decision support first, then automate narrow steps only after controls and audit visibility are proven in production.',
    category: 'Finance',
    source: 'FinOps Journal',
    timeAgo: '10h ago',
  ),
  FeedItem(
    image:
        'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?auto=format&fit=crop&w=1200&q=80',
    title: 'Cybersecurity teams adopt AI triage for high-volume alert streams',
    description:
        'SOC analysts report faster investigations with context-ranked incident summaries.',
    content:
        'Security teams are using AI triage layers to reduce analyst fatigue and speed up incident prioritization. Instead of reviewing every alert with equal depth, responders receive grouped events and concise risk summaries with evidence links.\n\nLeaders emphasize that these systems work best when playbooks and escalation policies are codified alongside model outputs. Human review remains central, especially for high-impact incidents.',
    category: 'Cybersecurity',
    source: 'SecureOps Daily',
    timeAgo: '12h ago',
  ),
  FeedItem(
    image:
        'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?auto=format&fit=crop&w=1200&q=80',
    title:
        'Multimodal assistants gain reliability with task-grounded prompting',
    description:
        'Teams are reducing hallucinations by anchoring prompts to structured workflow context.',
    content:
        'Product engineers are reporting better completion quality from multimodal assistants when prompts are explicitly grounded in task schemas, source references, and expected output formats.\n\nThis pattern is especially useful in enterprise settings where mistakes have operational cost. The approach improves confidence for human-in-the-loop review while preserving speed in repetitive processes.',
    category: 'AI',
    source: 'Model Notes',
    timeAgo: '1d ago',
  ),
  FeedItem(
    image:
        'https://images.unsplash.com/photo-1509228468518-180dd4864904?auto=format&fit=crop&w=1200&q=80',
    title: 'University labs publish open dataset for policy trend analysis',
    description:
        'The release supports long-horizon analysis of public technology narratives.',
    content:
        'A group of university labs released a curated dataset designed for policy trend analysis across technology, economics, and public discourse. The dataset includes metadata standards intended to support reproducible research.\n\nResearchers say this should improve the quality of longitudinal studies and reduce effort spent on cleaning fragmented source archives. Several civic-tech groups have already begun prototyping public dashboards on top of the release.',
    category: 'Research',
    source: 'Research Wire',
    timeAgo: '1d ago',
  ),
  FeedItem(
    image: 'https://picsum.photos/seed/feed09/1200/720',
    title:
        'Enterprise copilots are improving first-response quality in support teams',
    description:
        'Operations teams report faster ticket triage with human validation loops.',
    content:
        'Support organizations are deploying AI copilots to summarize customer context before agents respond. This has reduced handoff friction and improved consistency across regional teams.\n\nTeams that combine AI suggestions with approval workflows are seeing the strongest results, especially in high-volume product lines.',
    category: 'AI',
    source: 'Ops Monitor',
    timeAgo: '1d ago',
  ),
  FeedItem(
    image: 'https://picsum.photos/seed/feed10/1200/720',
    title:
        'Battery-aware chip scheduling is extending mobile AI session length',
    description:
        'New runtime strategies keep local inference smooth under thermal constraints.',
    content:
        'Device platform teams are introducing smarter workload schedulers for AI tasks. Instead of maximizing short bursts, systems now prioritize sustained efficiency under real user behavior.\n\nThis approach is helping apps deliver stable experiences on mid-tier hardware where energy budgets are tighter.',
    category: 'Technology',
    source: 'Compute Trends',
    timeAgo: '1d ago',
  ),
  FeedItem(
    image: 'https://picsum.photos/seed/feed11/1200/720',
    title:
        'Seed rounds are favoring startups with compliance-ready AI workflows',
    description:
        'Investors prioritize products that show governance from day one.',
    content:
        'Early-stage investors are shifting attention to startups that can ship AI safely in regulated environments. Founders with clear audit paths and role-based controls are closing rounds faster.\n\nThis trend is pushing teams to treat trust architecture as a product feature rather than a post-launch task.',
    category: 'Startups',
    source: 'Venture Ledger',
    timeAgo: '1d ago',
  ),
  FeedItem(
    image: 'https://picsum.photos/seed/feed12/1200/720',
    title: 'Multimodal benchmark updates reveal gaps in long-form reasoning',
    description:
        'Researchers identify failure patterns across chart and text combinations.',
    content:
        'A new benchmark suite tested multimodal systems on long-context research tasks. Results show that performance can drop when diagrams, tables, and text must be linked over long sequences.\n\nThe paper recommends stronger retrieval constraints and structured output checks to improve reliability.',
    category: 'Research',
    source: 'Lab Notes',
    timeAgo: '2d ago',
  ),
  FeedItem(
    image: 'https://picsum.photos/seed/feed13/1200/720',
    title: 'Treasury teams adopt scenario AI for weekly liquidity planning',
    description:
        'Forecasting tools are moving from monthly to rolling weekly models.',
    content:
        'Financial operations teams are increasing the frequency of scenario simulation using AI-assisted modeling. This helps decision-makers react faster to volatility across payment and settlement windows.\n\nLeaders report better planning confidence when scenario assumptions and data sources are visible to reviewers.',
    category: 'Finance',
    source: 'CFO Brief',
    timeAgo: '2d ago',
  ),
  FeedItem(
    image: 'https://picsum.photos/seed/feed14/1200/720',
    title: 'Security programs scale phishing triage with context-aware models',
    description:
        'SOC teams reduce noise by ranking incidents with source confidence.',
    content:
        'Cybersecurity teams are using context-aware classifiers to prioritize phishing investigations. Signals from user behavior, domain history, and attachment patterns are fused into a clearer risk ranking.\n\nAnalysts still lead final action decisions, but triage latency has dropped across large organizations.',
    category: 'Cybersecurity',
    source: 'Threat Daily',
    timeAgo: '2d ago',
  ),
  FeedItem(
    image: 'https://picsum.photos/seed/feed15/1200/720',
    title:
        'Lightweight translation models are improving global product onboarding',
    description:
        'Teams localize help flows faster with constrained domain vocabulary.',
    content:
        'Product teams are using compact translation models trained on domain-specific lexicons to improve onboarding clarity. This reduces friction for users in markets where support resources are limited.\n\nOrganizations report higher completion rates when translated flows include quality checks for regulated terms.',
    category: 'AI',
    source: 'Global UX Report',
    timeAgo: '2d ago',
  ),
  FeedItem(
    image: 'https://picsum.photos/seed/feed16/1200/720',
    title: 'Browser inference runtimes now support persistent session context',
    description:
        'Web teams are shipping richer AI interactions without native installs.',
    content:
        'Web platform updates are making client-side inference more practical for long sessions. Developers can retain compact state between interactions to reduce repetitive context loading.\n\nThis supports faster experiences for users who move between research, drafting, and analysis tasks in one flow.',
    category: 'Technology',
    source: 'Web Stack Weekly',
    timeAgo: '2d ago',
  ),
  FeedItem(
    image: 'https://picsum.photos/seed/feed17/1200/720',
    title:
        'Health analytics startups win pilots with narrow workflow automation',
    description:
        'Buyers prefer targeted tools that integrate with existing systems.',
    content:
        'Startups in health analytics are finding traction by solving one high-value workflow at a time. Hospital and clinic buyers are prioritizing integrations that preserve current review and escalation practices.\n\nThis focused strategy shortens procurement cycles and improves deployment confidence.',
    category: 'Startups',
    source: 'Startup Health Pulse',
    timeAgo: '2d ago',
  ),
  FeedItem(
    image: 'https://picsum.photos/seed/feed18/1200/720',
    title:
        'Open evaluation set improves comparisons of retrieval-augmented systems',
    description:
        'Researchers release cross-domain prompts with reproducible scoring.',
    content:
        'A collaborative research group released an open evaluation set for retrieval-augmented generation. It includes domain-balanced prompts and scoring scripts for consistent experimentation.\n\nTeams can now compare pipeline changes over time without rebuilding internal benchmarks from scratch.',
    category: 'Research',
    source: 'Evaluation Hub',
    timeAgo: '2d ago',
  ),
  FeedItem(
    image: 'https://picsum.photos/seed/feed19/1200/720',
    title:
        'Compliance automation cuts review cycles in financial reporting teams',
    description:
        'Rule-aware assistants draft baseline disclosures for analyst review.',
    content:
        'Finance departments are deploying rule-aware assistants to prepare initial reporting drafts. Human reviewers then validate assumptions and finalize policy language before publication.\n\nThe combined process is reducing manual repetition while preserving accountability controls.',
    category: 'Finance',
    source: 'RegOps Journal',
    timeAgo: '3d ago',
  ),
  FeedItem(
    image: 'https://picsum.photos/seed/feed20/1200/720',
    title: 'Zero-trust programs expand with adaptive policy engines',
    description:
        'Identity checks become risk-aware across endpoint and network layers.',
    content:
        'Security teams are modernizing zero-trust rollouts with adaptive policy engines that consider contextual risk. Access controls are increasingly tied to device posture and behavioral indicators in real time.\n\nThis model lowers over-permission risks while keeping legitimate workflows usable.',
    category: 'Cybersecurity',
    source: 'Identity Review',
    timeAgo: '3d ago',
  ),
  FeedItem(
    image: 'https://picsum.photos/seed/feed21/1200/720',
    title:
        'Agent memory frameworks improve task continuity in enterprise tools',
    description:
        'Teams are reducing repeated prompts across multi-step operations.',
    content:
        'Enterprise product teams are introducing structured memory layers for agent workflows. These layers track user intent and task history to avoid redundant interactions.\n\nBetter context continuity is increasing completion rates in complex operational tasks.',
    category: 'AI',
    source: 'Agent Systems',
    timeAgo: '3d ago',
  ),
  FeedItem(
    image: 'https://picsum.photos/seed/feed22/1200/720',
    title:
        'Edge caching patterns are reducing inference latency for mobile apps',
    description:
        'Hybrid delivery models keep model assets close to active users.',
    content:
        'Platform teams are combining edge caching with selective local execution to improve perceived AI speed. Model artifacts and embeddings are placed near user regions for faster warm starts.\n\nThis architecture is particularly useful for global products with bursty interaction patterns.',
    category: 'Technology',
    source: 'Mobile Infra Today',
    timeAgo: '3d ago',
  ),
  FeedItem(
    image: 'https://picsum.photos/seed/feed23/1200/720',
    title: 'Climate-risk startups gain traction with insurer data partnerships',
    description:
        'New ventures blend public data with carrier-specific loss signals.',
    content:
        'Founders building climate-risk intelligence products are securing growth through insurer partnerships. Domain-specific datasets are helping teams produce actionable risk segmentation for underwriting decisions.\n\nInvestors view these partnerships as a durability signal for long-term adoption.',
    category: 'Startups',
    source: 'Climate Venture Watch',
    timeAgo: '3d ago',
  ),
  FeedItem(
    image: 'https://picsum.photos/seed/feed24/1200/720',
    title: 'Causal inference toolkit simplifies policy impact experiments',
    description:
        'Researchers can now run robust what-if tests with cleaner defaults.',
    content:
        'A newly released toolkit lowers the barrier for causal inference experiments in policy and economics research. It standardizes preprocessing and diagnostics for common observational scenarios.\n\nTeams report faster iteration when combining the toolkit with reproducible data pipelines.',
    category: 'Research',
    source: 'Policy Science Update',
    timeAgo: '3d ago',
  ),
  FeedItem(
    image: 'https://picsum.photos/seed/feed25/1200/720',
    title: 'Real-time fraud scoring models are improving checkout protection',
    description: 'Finance and risk teams tune thresholds using feedback loops.',
    content:
        'Digital payment teams are refining real-time fraud models with tighter feedback from chargeback outcomes. This allows faster threshold calibration without disrupting legitimate customer activity.\n\nCross-functional review remains critical to balance risk controls and conversion rates.',
    category: 'Finance',
    source: 'Payments Briefing',
    timeAgo: '4d ago',
  ),
  FeedItem(
    image: 'https://picsum.photos/seed/feed26/1200/720',
    title: 'Identity threat analytics now map account takeover paths earlier',
    description:
        'Security teams detect chained signals before major incidents escalate.',
    content:
        'Modern identity analytics platforms are linking low-severity events into higher-confidence takeover narratives. This gives defenders earlier intervention windows during active campaigns.\n\nOrganizations with consolidated telemetry are seeing the largest performance gains.',
    category: 'Cybersecurity',
    source: 'Blue Team Notes',
    timeAgo: '4d ago',
  ),
  FeedItem(
    image: 'https://picsum.photos/seed/feed27/1200/720',
    title: 'Healthcare search tools use multimodal AI to speed chart reviews',
    description:
        'Clinical teams test systems that combine imaging and notes context.',
    content:
        'Healthcare software providers are piloting multimodal search experiences to support chart review workflows. Systems combine clinical notes, structured records, and image metadata for quicker retrieval.\n\nHuman oversight stays central, but early pilots report meaningful time savings in preparation stages.',
    category: 'AI',
    source: 'MedTech Insider',
    timeAgo: '4d ago',
  ),
  FeedItem(
    image: 'https://picsum.photos/seed/feed28/1200/720',
    title: 'Modern app stacks add quantum-safe libraries to long-term roadmaps',
    description:
        'Platform teams start phased migration plans for cryptography updates.',
    content:
        'Security and platform engineering groups are preparing application stacks for future quantum-safe standards. Most organizations are beginning with inventory, compatibility checks, and staged deployment plans.\n\nExperts recommend gradual rollout with observability controls before broad enforcement.',
    category: 'Technology',
    source: 'Platform Security Review',
    timeAgo: '4d ago',
  ),
];
