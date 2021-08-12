import 'package:amplitude_flutter/amplitude.dart';
import 'package:oppidums/app_config.dart';

class OppidumsAnalytics {
  static Amplitude analytics;

  static void setup() {
    analytics = Amplitude.getInstance(instanceName: "oppidums");
    
    analytics.init(AppConfig.amplitude);
    analytics.trackingSessionEvents(true);
    // Enable COPPA privacy guard. This is useful when you choose not to report sensitive user information.
    analytics.enableCoppaControl();

  }
}
