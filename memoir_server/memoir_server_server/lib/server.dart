import 'package:serverpod_cloud_storage/serverpod_cloud_storage.dart';
import 'package:serverpod_cloud_storage_s3_compat/serverpod_cloud_storage_s3_compat.dart';

import 'src/auth/auth_utils.dart';
import 'src/generated/serverpod.dart';
import 'src/shared/object_storage_config.dart';

/// The starting point of the Serverpod server.
void run(List<String> args) async {
  // Initialize Serverpod. The generated Serverpod class is already connected
  // with your project's generated code.
  final pod = Serverpod(
    args,
    authenticationHandler: authenticationHandler,
  );

  // Configure cloud storage. Private entry images go to Neon Object Storage
  // (S3-compatible) as soon as its credentials are available; otherwise they
  // stay in the database, which is what local development uses.
  final accessKey = pod.getPassword('s3AccessKey');
  final secretKey = pod.getPassword('s3SecretKey');
  if (accessKey != null && secretKey != null) {
    final config = ObjectStorageConfig.fromEnvironment();
    pod.addCloudStorage(
      S3CompatCloudStorage(
        storageId: 'private',
        accessKey: accessKey,
        secretKey: secretKey,
        bucket: config.bucket,
        region: config.region,
        public: false,
        endpoints: CustomEndpointConfig(
          baseUri: Uri.parse(config.endpoint),
          serviceName: 'Neon Object Storage',
        ),
        uploadStrategy: PresignedPutUploadStrategy(),
      ),
    );
  } else {
    pod.addCloudStorage(DatabaseCloudStorage('private'));
  }

  pod.addCloudStorage(
    await ServerpodCloudProvider.public(
      fallback: () => DatabaseCloudStorage('public'),
    ),
  );

  // Start the server.
  await pod.start();
}
