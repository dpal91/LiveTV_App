class Channel {
  final String title;
  final String description;
  final String studio;
  final String videoUrl;
  final String cardImageUrl;
  final String backgroundImageUrl;

  Channel({
    required this.title,
    required this.description,
    required this.studio,
    required this.videoUrl,
    required this.cardImageUrl,
    required this.backgroundImageUrl,
  });
}

class Categories {
  final String name;
  final List<Channel> channels;

  Categories({
    required this.name,
    required this.channels,
  });
}

Channel buildChannel({
  required String title,
  required String description,
  required String studio,
  required String videoUrl,
  required String cardImageUrl,
  required String backgroundImageUrl,
}) {
  return Channel(
    title: title,
    description: description,
    studio: studio,
    videoUrl: videoUrl,
    cardImageUrl: cardImageUrl,
    backgroundImageUrl: backgroundImageUrl,
  );
}
