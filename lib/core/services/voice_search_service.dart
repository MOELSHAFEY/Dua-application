import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class VoiceSearchService {
  final SpeechToText _speechToText;
  bool _isInitialized = false;

  VoiceSearchService(this._speechToText);

  Future<bool> initialize() async {
    if (_isInitialized) return true;
    _isInitialized = await _speechToText.initialize(
      onError: (errorNotification) => print('Error: $errorNotification'),
      onStatus: (status) => print('Status: $status'),
    );
    return _isInitialized;
  }

  Future<void> startListening({
    required Function(String) onResult,
    required Function(bool) onListeningStateChanged,
  }) async {
    bool available = await initialize();
    if (available) {
      onListeningStateChanged(true);
      await _speechToText.listen(
        onResult: (SpeechRecognitionResult result) {
          if (result.finalResult) {
            onResult(result.recognizedWords);
            onListeningStateChanged(false);
          }
        },
        localeId: 'ar_EG', // Focus on Arabic as per app context
      );
    } else {
      onListeningStateChanged(false);
    }
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
  }

  bool get isListening => _speechToText.isListening;
  bool get isAvailable => _isInitialized;
}
