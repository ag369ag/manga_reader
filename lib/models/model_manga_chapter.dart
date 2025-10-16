class ModelMangaChapter {
  final String chapterId;
  final String views;
  final String uploaded;
  final String timestamp;

  ModelMangaChapter({
    required this.chapterId,
    required this.views,
    required this.uploaded,
    required this.timestamp,
  });

  factory ModelMangaChapter.fromJson(Map<String, dynamic> json) {
    //String rawChapter = json['chapterId'].toString().replaceAll("-", ".");
    String rawChapter = json['chapterId'].toString();
    return ModelMangaChapter(
      chapterId: rawChapter,
      views: json['views'],
      uploaded: json['uploaded'],
      timestamp: json['timestamp'],
    );
  }
}
