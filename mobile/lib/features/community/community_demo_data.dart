/// Demo community feed items (step 49 — no backend).
class CommunityReview {
  const CommunityReview({
    required this.author,
    required this.place,
    required this.rating,
    required this.excerpt,
    required this.daysAgo,
  });

  final String author;
  final String place;
  final int rating;
  final String excerpt;
  final int daysAgo;
}

class CommunityEvent {
  const CommunityEvent({
    required this.title,
    required this.location,
    required this.dateLabel,
  });

  final String title;
  final String location;
  final String dateLabel;
}

const kDemoCommunityReviews = <CommunityReview>[
  CommunityReview(
    author: 'Marina K.',
    place: 'Göcek D-Marin',
    rating: 5,
    excerpt: 'Quiet nights, good holding in the outer bay. Showers ashore.',
    daysAgo: 3,
  ),
  CommunityReview(
    author: 'Jean-Pierre',
    place: 'Fethiye Ece Marina',
    rating: 4,
    excerpt: 'Busy in August but helpful staff. Fuel dock until 20:00.',
    daysAgo: 11,
  ),
];

const kDemoCommunityEvents = <CommunityEvent>[
  CommunityEvent(
    title: 'Cruisers\' sundowner',
    location: 'Fethiye, Club Marina pier',
    dateLabel: 'Fri 18:00',
  ),
  CommunityEvent(
    title: 'Safety at sea clinic',
    location: 'Marmaris yacht club',
    dateLabel: 'Next Sat 10:00',
  ),
];
