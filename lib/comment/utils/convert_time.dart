// Checking the form of the datetime to promote standardization
String convertTime(dateTime) {
  var formattedTime = DateTime.now().difference(dateTime).inDays.toString();
  if (formattedTime != '0') {
    return formattedTime + ' days ago';
  }
  formattedTime = DateTime.now().difference(dateTime).inHours.toString();
  if (formattedTime != '0') {
    return formattedTime + ' hr. ago';
  }
  formattedTime = DateTime.now().difference(dateTime).inMinutes.toString();
  if (formattedTime != '0') {
    return formattedTime + ' min. ago';
  }
  return '0 min. ago';
}
