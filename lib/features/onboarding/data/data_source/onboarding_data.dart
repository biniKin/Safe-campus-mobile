import 'package:safe_campus/core/constants/images_string/images_string.dart';
import 'package:safe_campus/features/onboarding/data/model/onboarding_model.dart';

final List<OnboardingModel> onboardingData = [
  OnboardingModel(
    image: ImagesString.onboarding1,
    title: 'Your safety, one tap away.',
    description:
        'Report accidents and emergencies inside the campus and get help fast.',
  ),
  OnboardingModel(
    image: ImagesString.onboarding2,
    title: 'Report Emergencies instantly ',
    description:
        'When you face an accident or danger send an altert with your live location to campus security.',
  ),
  OnboardingModel(
    image: ImagesString.onboarding3,
    title: 'See Danger Zones on the Map',
    description:
        'View risky areas around campus and stay alert whenever you go',
  ),
];
