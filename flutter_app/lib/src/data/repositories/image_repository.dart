import '../../core/api_client.dart';
import '../datasources/fastapi_data_source.dart';
import '../models.dart';

class ImageRepository {
  const ImageRepository(this._source);

  final FastApiDataSource _source;

  Future<List<EntryImageView>> forEntry(String entryId) async {
    final data = await _source.get('/entries/$entryId/images');
    final images = (data as List)
        .map((item) => EntryImage.fromJson(item as Map<String, dynamic>))
        .toList();
    final views = <EntryImageView>[];
    for (final image in images) {
      try {
        final response =
            await _source.get('/images/${image.id}/url') as Map<String, dynamic>;
        final url = response['url'] as String?;
        if (url != null && url.isNotEmpty) {
          views.add(EntryImageView(image: image, url: url));
        }
      } on ApiException {
        // A missing or expired object should not hide other gallery images.
      }
    }
    return views;
  }

  Future<void> upload(String entryId, String filePath) =>
      _source.uploadImage('/entries/$entryId/images', filePath);

  Future<void> delete(String imageId) => _source.delete('/images/$imageId');
}
