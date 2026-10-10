import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../shared/session_utils.dart';

/// Entry image upload and gallery, mirroring FastAPI `/entries/{id}/images`.
///
/// Flow: [createUploadDescription] -> client uploads to that URL ->
/// [confirmUpload] verifies and stores the metadata row.
class ImagesEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<ImageUploadTicket> createUploadDescription(
    Session session, {
    required UuidValue entryId,
    required String filename,
  }) async {
    await _ownedEntry(session, entryId);
    // The path is derived server-side so a client cannot choose its location.
    final objectKey = _objectKey(entryId, filename);
    final uploadUrl = await session.storage.createUploadDescription(
      storageId: 'private',
      path: objectKey,
    );
    return ImageUploadTicket(uploadUrl: uploadUrl, objectKey: objectKey);
  }

  Future<EntryImage> confirmUpload(
    Session session, {
    required UuidValue entryId,
    required String objectKey,
    String? contentType,
    int? sizeBytes,
    int? width,
    int? height,
    String? caption,
  }) async {
    await _ownedEntry(session, entryId);
    final verified = await session.storage.verifyUpload(
      storageId: 'private',
      path: objectKey,
    );
    if (!verified) {
      throw ApiException(message: 'Upload not found', code: 'notFound');
    }
    return EntryImage.db.insertRow(
      session,
      EntryImage(
        entryId: entryId,
        objectKey: objectKey,
        contentType: contentType ?? 'image/jpeg',
        sizeBytes: sizeBytes,
        width: width,
        height: height,
        caption: caption,
      ),
    );
  }

  /// Returns the entry's images each with a short-lived download URL. A
  /// missing object does not hide the rest of the gallery.
  Future<List<EntryImageView>> forEntry(
    Session session,
    UuidValue entryId,
  ) async {
    await _ownedEntry(session, entryId);
    final images = await EntryImage.db.find(
      session,
      where: (t) => t.entryId.equals(entryId),
      orderBy: (t) => t.createdAt,
    );
    final views = <EntryImageView>[];
    for (final image in images) {
      try {
        final url = await session.storage.temporaryDownloadUrl(
          storageId: 'private',
          path: image.objectKey,
        );
        views.add(EntryImageView(image: image, url: url.toString()));
      } catch (_) {
        // Skip an image whose object is missing or expired.
      }
    }
    return views;
  }

  Future<void> delete(Session session, UuidValue imageId) async {
    final image = await EntryImage.db.findById(session, imageId);
    ensureOwned(
      image != null && await _ownsEntry(session, image.entryId),
    );
    try {
      await session.storage.deleteFile(
        storageId: 'private',
        path: image!.objectKey,
      );
    } catch (_) {
      // Deleting the metadata row is what matters; a leftover object is inert.
    }
    await EntryImage.db.deleteRow(session, image!);
  }

  String _objectKey(UuidValue entryId, String filename) {
    final dot = filename.lastIndexOf('.');
    final ext = dot >= 0 ? filename.substring(dot).toLowerCase() : '.jpg';
    return 'entries/$entryId/${randomHex()}$ext';
  }

  Future<DiaryEntry> _ownedEntry(Session session, UuidValue entryId) async {
    final entry = await DiaryEntry.db.findById(session, entryId);
    ensureOwned(entry != null && entry.userId == currentUserId(session));
    return entry!;
  }

  Future<bool> _ownsEntry(Session session, UuidValue entryId) async {
    final entry = await DiaryEntry.db.findById(session, entryId);
    return entry != null && entry.userId == currentUserId(session);
  }
}
