class FeedItem {
  const FeedItem({
    required this.image,
    required this.title,
    required this.description,
    required this.content,
    required this.category,
    this.source,
    this.timeAgo,
  });

  final String image;
  final String title;
  final String description;
  final String content;
  final String category;
  final String? source;
  final String? timeAgo;

  bool matchesQuery(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return true;
    }

    return title.toLowerCase().contains(normalized) ||
        description.toLowerCase().contains(normalized) ||
        content.toLowerCase().contains(normalized) ||
        category.toLowerCase().contains(normalized) ||
        (source ?? '').toLowerCase().contains(normalized);
  }
}
