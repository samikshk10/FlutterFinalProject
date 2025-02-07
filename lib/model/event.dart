class Event {
  final String eventId,
      imagePath,
      title,
      description,
      location,
      duration,
      punchLine1,
      date,
      punchLine2;
  final double longitude, latitude;
  final List categoryIds, galleryImages;

  Event(
      {required this.imagePath,
      required this.title,
      required this.eventId,
      required this.description,
      required this.location,
      required this.duration,
      required this.punchLine1,
      required this.punchLine2,
      required this.categoryIds,
      required this.galleryImages,
      required this.date,
      required this.longitude,
      required this.latitude});
}

final fiveKmRunEvent = Event(
    eventId: "1",
    imagePath: "assets/event_images/5_km_downtown_run.jpeg",
    title: "5 Kilometer Downtown Run",
    description: "",
    location: "Pleasant Park",
    duration: "3h",
    punchLine1: "Marathon!",
    punchLine2: "The latest fad in foodology, get the inside scoup.",
    galleryImages: [],
    categoryIds: [0, 1],
    date: "12 Apr, 2021",
    longitude: 12.2,
    latitude: 12.5);

final cookingEvent = Event(
    eventId: "2",
    imagePath: "assets/event_images/granite_cooking_class.jpeg",
    title: "Granite Cooking Class",
    description:
        "Guest list fill up fast so be sure to apply before handto secure a spot.",
    location: "Food Court Avenue",
    duration: "4h",
    punchLine1: "Granite Cooking",
    punchLine2: "The latest fad in foodology, get the inside scoup.",
    categoryIds: [0, 2],
    galleryImages: [
      "assets/event_images/cooking_1.jpeg",
      "assets/event_images/cooking_2.jpeg",
      "assets/event_images/cooking_3.jpeg"
    ],
    date: "12 Apr, 2021",
    longitude: 123.5,
    latitude: 123.5);

final musicConcert = Event(
    eventId: "3",
    imagePath: "assets/event_images/music_concert.jpeg",
    title: "Arijit Music Concert",
    description: "Listen to Arijit's latest compositions.",
    location: "D.Y. Patil Stadium, Mumbai",
    duration: "5h",
    punchLine1: "Music Lovers!",
    punchLine2: "The latest fad in foodology, get the inside scoup.",
    galleryImages: [
      "assets/event_images/cooking_1.jpeg",
      "assets/event_images/cooking_2.jpeg",
      "assets/event_images/cooking_3.jpeg"
    ],
    categoryIds: [0, 1],
    date: "12 Apr, 2021",
    longitude: 123.5,
    latitude: 123.5);

final golfCompetition = Event(
    eventId: "4",
    imagePath: "assets/event_images/golf_competition.jpeg",
    title: "Season 2 Golf Estate",
    description: "",
    location: "NSIC Ground, Okhla",
    duration: "1d",
    punchLine1: "Golf!",
    punchLine2: "The latest fad in foodology, get the inside scoup.",
    galleryImages: [
      "assets/event_images/cooking_1.jpeg",
      "assets/event_images/cooking_2.jpeg",
      "assets/event_images/cooking_3.jpeg"
    ],
    categoryIds: [0, 3],
    date: "12 Apr, 2021",
    longitude: 123.5,
    latitude: 123.5);

final events = [
  fiveKmRunEvent,
  cookingEvent,
  musicConcert,
  golfCompetition,
];
