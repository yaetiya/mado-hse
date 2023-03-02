class StringTools {
  static isMadoUrl(String url) {
    return url.startsWith('https://mado.one');
  }

  static getFileType(String url) {
    if (url.endsWith('mp4')) return 'video/mp4';
    print('image/' + url.split('.').last);
    return 'image/' + url.split('.').last;
  }
}
