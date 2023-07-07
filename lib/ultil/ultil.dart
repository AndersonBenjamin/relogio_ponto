class util {
  // Nao utilizado. Apagar depois
  String formatDate() {
    String formattedDifference = '00:19:20';
    DateTime startDateTime = DateTime.parse('2023-01-22 09:00:00');
    DateTime endDateTime = DateTime.parse('2023-01-23 18:21:00');

    Duration difference = endDateTime.difference(startDateTime);
    formattedDifference = formatDuration(difference);

    print('Difference: $formattedDifference');
    return formattedDifference;
  }

  // Nao utilizado. Apagar depois
  String formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));

    return "$hours:$minutes:$seconds";
  }
}
