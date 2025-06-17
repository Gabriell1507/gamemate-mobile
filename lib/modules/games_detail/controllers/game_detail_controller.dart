import 'package:gamemate/modules/games/data/models/games_model.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';
import 'package:intl/intl.dart';

class GameDetailController extends GetxController {
  final IGDBGame game;
  final RxString translatedSummary = ''.obs;

  GameDetailController(this.game);

  @override
  void onInit() {
    super.onInit();
    _translateSummary();
  }

  String formatReleaseDate(int unixTimestampSeconds) {
    final date =
        DateTime.fromMillisecondsSinceEpoch(unixTimestampSeconds * 1000);
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Future<void> _translateSummary() async {
    if (game.summary.isEmpty) return;
    final translator = GoogleTranslator();
    final translation =
        await translator.translate(game.summary, from: 'en', to: 'pt');
    translatedSummary.value = translation.text;
  }
}
