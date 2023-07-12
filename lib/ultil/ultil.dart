class util {
  String diffDateHhMmSs(DateTime startDate, DateTime endTime) {
    Duration difference = endTime.difference(startDate);

    String formattedDifference = formatDuration(difference);

    print('Difference: $formattedDifference');
    return formattedDifference;
  }

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

  String balance() {
    return '';
  }
}
