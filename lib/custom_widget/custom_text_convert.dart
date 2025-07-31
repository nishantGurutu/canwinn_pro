class CustomTextConvert {
  String getNameChar(String name) {
    String initials = '';

    if (name.isNotEmpty) {
      List<String> words = name.trim().split(' ');

      for (String word in words) {
        if (word.isNotEmpty) {
          initials += word[0].toUpperCase();
        }
      }
    }

    return initials;
  }
}
