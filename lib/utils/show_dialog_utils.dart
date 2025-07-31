class ShowDialogUtils {
  static void showDialog(
    String title,
    String message,
    Function onConfirm,
    Function onCancel, {
    String confirmText = 'OK',
    String cancelText = 'Cancel',
  }) {
    onConfirm();
  }
}
