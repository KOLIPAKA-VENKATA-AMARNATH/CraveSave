class OnboardingContent {
  final String title;
  final String description;
  final String image;
  final bool isLottie;  // Add this to distinguish between image types

  OnboardingContent({
    required this.title,
    required this.description,
    required this.image,
    this.isLottie = false,  // Default to false for regular images
  });
}

final List<OnboardingContent> onboardingPages = [
  OnboardingContent(
    title: 'Every Meal Matters',
    description: 'Every day, tons of edible food from restaurants, events, and homes go to waste — while millions go to bed hungry.\n\nLet\'s change that, one meal at a time.',
    image: 'assets/images/donate_food.png',
  ),
  OnboardingContent(
    title: 'From Donors to the Needy',
    description: 'CraveSave connects food donors with trusted NGOs and volunteers in real time.\n\nYou donate. We coordinate. Someone eats.',
    image: 'assets/images/helping_others.png',
  ),
  OnboardingContent(
    title: 'Join the Movement for Zero Hunger',
    description: 'Whether you\'re a donor, volunteer, or NGO — your role matters.\n\nLet\'s reduce food waste, feed lives, and build a sustainable future.\n\n🌱 SDG 2 – Zero Hunger starts with YOU.',
    image: 'assets/animations/map_location.json',
    isLottie: true,
  ),
];