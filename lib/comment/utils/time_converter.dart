String convertTime(dateTime) {
  var parseTime = DateTime.now().difference(dateTime).inDays.toString();
  if (parseTime != '0') {
    return parseTime + ' days ago';
  }
  parseTime = DateTime.now().difference(dateTime).inHours.toString();
  if (parseTime != '0') {
    return parseTime + ' hr. ago';
  }
  parseTime = DateTime.now().difference(dateTime).inMinutes.toString();
  if (parseTime != '0') {
    return parseTime + ' min. ago';
  }
  return '0 min. ago';
}
