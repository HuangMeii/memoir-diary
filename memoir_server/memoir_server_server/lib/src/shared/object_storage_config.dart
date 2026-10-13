import 'dart:io';

/// Neon Object Storage (S3-compatible) settings for the entry-image bucket.
///
/// The endpoint, region and bucket are not secrets, so they live in code and
/// can be overridden through the environment. The access key and secret stay
/// out of source: they come from `config/passwords.yaml` (`s3AccessKey` /
/// `s3SecretKey`) or the matching `SERVERPOD_PASSWORD_s3AccessKey` /
/// `SERVERPOD_PASSWORD_s3SecretKey` environment variables.
class ObjectStorageConfig {
  const ObjectStorageConfig({
    required this.endpoint,
    required this.region,
    required this.bucket,
  });

  /// Base endpoint of the S3-compatible service, e.g.
  /// `https://br-xxx.storage.c-4.ap-southeast-1.aws.neon.tech`.
  final String endpoint;

  /// Storage region, e.g. `ap-southeast-1`.
  final String region;

  /// Name of the bucket that holds entry images.
  final String bucket;

  /// Storage endpoint of the current Neon project.
  static const defaultEndpoint =
      'https://br-tiny-wind-b3lojw7g.storage.c-4.ap-southeast-1.aws.neon.tech';
  static const defaultRegion = 'ap-southeast-1';
  static const defaultBucket = 'diary-images';

  /// Builds the configuration from the environment, falling back to the
  /// values for the current Neon project.
  factory ObjectStorageConfig.fromEnvironment([
    Map<String, String>? environment,
  ]) {
    final env = environment ?? Platform.environment;
    return ObjectStorageConfig(
      endpoint:
          _firstNonEmpty([
            env['S3_ENDPOINT_URL'],
            env['AWS_ENDPOINT_URL_S3'],
          ]) ??
          defaultEndpoint,
      region:
          _firstNonEmpty([env['S3_REGION'], env['AWS_REGION']]) ??
          defaultRegion,
      bucket: _firstNonEmpty([env['S3_BUCKET']]) ?? defaultBucket,
    );
  }

  static String? _firstNonEmpty(List<String?> values) {
    for (final value in values) {
      final trimmed = value?.trim();
      if (trimmed != null && trimmed.isNotEmpty) return trimmed;
    }
    return null;
  }
}
