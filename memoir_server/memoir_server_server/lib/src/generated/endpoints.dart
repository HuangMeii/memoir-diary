/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import '../admin/admin_endpoint.dart' as _ido5l6pj;
import '../auth/auth_endpoint.dart' as _iiznyhpe;
import '../health/health_endpoint.dart' as _id9paj9q;
import '../journal/entries_endpoint.dart' as _i4r7i20a;
import '../journal/images_endpoint.dart' as _ivqwes0y;
import '../lookups/lookup_endpoint.dart' as _ir220yj4;
import '../notes/notes_endpoint.dart' as _i3f4yez7;
import '../planner/events_endpoint.dart' as _iom7ynue;
import '../planner/schedules_endpoint.dart' as _izarqe10;
import '../planner/todos_endpoint.dart' as _igh4w5sj;
import '../quotes/daily_quotes_endpoint.dart' as _iyiyze1d;
import '../quotes/quotes_endpoint.dart' as _i0kbgmpc;
import '../quotes/reflections_endpoint.dart' as _igito0lv;
import '../quotes/self_messages_endpoint.dart' as _ifxzgp8p;
import '../shared/seed_endpoint.dart' as _iaci3p0i;
import '../stats/stats_endpoint.dart' as _ibh8msu8;
import '../weather/weather_endpoint.dart' as _i8nd21di;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'admin': _ido5l6pj.AdminEndpoint()
        ..initialize(
          server,
          'admin',
          null,
        ),
      'auth': _iiznyhpe.AuthEndpoint()
        ..initialize(
          server,
          'auth',
          null,
        ),
      'health': _id9paj9q.HealthEndpoint()
        ..initialize(
          server,
          'health',
          null,
        ),
      'entries': _i4r7i20a.EntriesEndpoint()
        ..initialize(
          server,
          'entries',
          null,
        ),
      'images': _ivqwes0y.ImagesEndpoint()
        ..initialize(
          server,
          'images',
          null,
        ),
      'lookups': _ir220yj4.LookupsEndpoint()
        ..initialize(
          server,
          'lookups',
          null,
        ),
      'notes': _i3f4yez7.NotesEndpoint()
        ..initialize(
          server,
          'notes',
          null,
        ),
      'events': _iom7ynue.EventsEndpoint()
        ..initialize(
          server,
          'events',
          null,
        ),
      'schedules': _izarqe10.SchedulesEndpoint()
        ..initialize(
          server,
          'schedules',
          null,
        ),
      'todos': _igh4w5sj.TodosEndpoint()
        ..initialize(
          server,
          'todos',
          null,
        ),
      'dailyQuotes': _iyiyze1d.DailyQuotesEndpoint()
        ..initialize(
          server,
          'dailyQuotes',
          null,
        ),
      'quotes': _i0kbgmpc.QuotesEndpoint()
        ..initialize(
          server,
          'quotes',
          null,
        ),
      'reflections': _igito0lv.ReflectionsEndpoint()
        ..initialize(
          server,
          'reflections',
          null,
        ),
      'selfMessages': _ifxzgp8p.SelfMessagesEndpoint()
        ..initialize(
          server,
          'selfMessages',
          null,
        ),
      'seed': _iaci3p0i.SeedEndpoint()
        ..initialize(
          server,
          'seed',
          null,
        ),
      'stats': _ibh8msu8.StatsEndpoint()
        ..initialize(
          server,
          'stats',
          null,
        ),
      'weather': _i8nd21di.WeatherEndpoint()
        ..initialize(
          server,
          'weather',
          null,
        ),
    };
    connectors['admin'] = _is.EndpointConnector(
      name: 'admin',
      endpoint: endpoints['admin']!,
      methodConnectors: {
        'listUsers': _is.MethodConnector(
          name: 'listUsers',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _ido5l6pj.AdminEndpoint)
                  .listUsers(session),
        ),
        'setUserActive': _is.MethodConnector(
          name: 'setUserActive',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'isActive': _is.ParameterDescription(
              name: 'isActive',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _ido5l6pj.AdminEndpoint).setUserActive(
                    session,
                    id: params['id'],
                    isActive: params['isActive'],
                  ),
        ),
        'setUserRole': _is.MethodConnector(
          name: 'setUserRole',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'role': _is.ParameterDescription(
              name: 'role',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _ido5l6pj.AdminEndpoint).setUserRole(
                    session,
                    id: params['id'],
                    role: params['role'],
                  ),
        ),
        'systemQuotes': _is.MethodConnector(
          name: 'systemQuotes',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _ido5l6pj.AdminEndpoint)
                  .systemQuotes(session),
        ),
        'createSystemQuote': _is.MethodConnector(
          name: 'createSystemQuote',
          params: {
            'text': _is.ParameterDescription(
              name: 'text',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'author': _is.ParameterDescription(
              name: 'author',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'source': _is.ParameterDescription(
              name: 'source',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'category': _is.ParameterDescription(
              name: 'category',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _ido5l6pj.AdminEndpoint)
                  .createSystemQuote(
                    session,
                    text: params['text'],
                    author: params['author'],
                    source: params['source'],
                    category: params['category'],
                  ),
        ),
        'updateSystemQuote': _is.MethodConnector(
          name: 'updateSystemQuote',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'text': _is.ParameterDescription(
              name: 'text',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'author': _is.ParameterDescription(
              name: 'author',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'source': _is.ParameterDescription(
              name: 'source',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'category': _is.ParameterDescription(
              name: 'category',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'isActive': _is.ParameterDescription(
              name: 'isActive',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _ido5l6pj.AdminEndpoint)
                  .updateSystemQuote(
                    session,
                    id: params['id'],
                    text: params['text'],
                    author: params['author'],
                    source: params['source'],
                    category: params['category'],
                    isActive: params['isActive'],
                  ),
        ),
        'deleteSystemQuote': _is.MethodConnector(
          name: 'deleteSystemQuote',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _ido5l6pj.AdminEndpoint)
                  .deleteSystemQuote(
                    session,
                    params['id'],
                  ),
        ),
      },
    );
    connectors['auth'] = _is.EndpointConnector(
      name: 'auth',
      endpoint: endpoints['auth']!,
      methodConnectors: {
        'register': _is.MethodConnector(
          name: 'register',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'username': _is.ParameterDescription(
              name: 'username',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'displayName': _is.ParameterDescription(
              name: 'displayName',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _iiznyhpe.AuthEndpoint).register(
                session,
                email: params['email'],
                username: params['username'],
                password: params['password'],
                displayName: params['displayName'],
              ),
        ),
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'username': _is.ParameterDescription(
              name: 'username',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _iiznyhpe.AuthEndpoint).login(
                session,
                username: params['username'],
                password: params['password'],
              ),
        ),
        'me': _is.MethodConnector(
          name: 'me',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['auth'] as _iiznyhpe.AuthEndpoint).me(session),
        ),
        'logout': _is.MethodConnector(
          name: 'logout',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['auth'] as _iiznyhpe.AuthEndpoint).logout(session),
        ),
      },
    );
    connectors['health'] = _is.EndpointConnector(
      name: 'health',
      endpoint: endpoints['health']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'from': _is.ParameterDescription(
              name: 'from',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'to': _is.ParameterDescription(
              name: 'to',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['health'] as _id9paj9q.HealthEndpoint).list(
                session,
                from: params['from'],
                to: params['to'],
              ),
        ),
        'save': _is.MethodConnector(
          name: 'save',
          params: {
            'logDate': _is.ParameterDescription(
              name: 'logDate',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'steps': _is.ParameterDescription(
              name: 'steps',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'workoutMinutes': _is.ParameterDescription(
              name: 'workoutMinutes',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'waterMl': _is.ParameterDescription(
              name: 'waterMl',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'sleepHours': _is.ParameterDescription(
              name: 'sleepHours',
              type: _is.getType<double?>(),
              nullable: true,
            ),
            'weightKg': _is.ParameterDescription(
              name: 'weightKg',
              type: _is.getType<double?>(),
              nullable: true,
            ),
            'note': _is.ParameterDescription(
              name: 'note',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['health'] as _id9paj9q.HealthEndpoint).save(
                session,
                logDate: params['logDate'],
                steps: params['steps'],
                workoutMinutes: params['workoutMinutes'],
                waterMl: params['waterMl'],
                sleepHours: params['sleepHours'],
                weightKg: params['weightKg'],
                note: params['note'],
              ),
        ),
      },
    );
    connectors['entries'] = _is.EndpointConnector(
      name: 'entries',
      endpoint: endpoints['entries']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'month': _is.ParameterDescription(
              name: 'month',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'from': _is.ParameterDescription(
              name: 'from',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
            'to': _is.ParameterDescription(
              name: 'to',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['entries'] as _i4r7i20a.EntriesEndpoint).list(
                    session,
                    month: params['month'],
                    from: params['from'],
                    to: params['to'],
                  ),
        ),
        'byDate': _is.MethodConnector(
          name: 'byDate',
          params: {
            'isoDate': _is.ParameterDescription(
              name: 'isoDate',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['entries'] as _i4r7i20a.EntriesEndpoint).byDate(
                    session,
                    params['isoDate'],
                  ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'entryDate': _is.ParameterDescription(
              name: 'entryDate',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'moodId': _is.ParameterDescription(
              name: 'moodId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'weatherId': _is.ParameterDescription(
              name: 'weatherId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'diaryText': _is.ParameterDescription(
              name: 'diaryText',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'otherPerspective': _is.ParameterDescription(
              name: 'otherPerspective',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'futureMessage': _is.ParameterDescription(
              name: 'futureMessage',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'selfCare': _is.ParameterDescription(
              name: 'selfCare',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'tomorrowHope': _is.ParameterDescription(
              name: 'tomorrowHope',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'gratitude': _is.ParameterDescription(
              name: 'gratitude',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'dream': _is.ParameterDescription(
              name: 'dream',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['entries'] as _i4r7i20a.EntriesEndpoint).create(
                    session,
                    entryDate: params['entryDate'],
                    moodId: params['moodId'],
                    weatherId: params['weatherId'],
                    diaryText: params['diaryText'],
                    otherPerspective: params['otherPerspective'],
                    futureMessage: params['futureMessage'],
                    selfCare: params['selfCare'],
                    tomorrowHope: params['tomorrowHope'],
                    gratitude: params['gratitude'],
                    dream: params['dream'],
                  ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'moodId': _is.ParameterDescription(
              name: 'moodId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'weatherId': _is.ParameterDescription(
              name: 'weatherId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'diaryText': _is.ParameterDescription(
              name: 'diaryText',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'otherPerspective': _is.ParameterDescription(
              name: 'otherPerspective',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'futureMessage': _is.ParameterDescription(
              name: 'futureMessage',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'selfCare': _is.ParameterDescription(
              name: 'selfCare',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'tomorrowHope': _is.ParameterDescription(
              name: 'tomorrowHope',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'gratitude': _is.ParameterDescription(
              name: 'gratitude',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'dream': _is.ParameterDescription(
              name: 'dream',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['entries'] as _i4r7i20a.EntriesEndpoint).update(
                    session,
                    id: params['id'],
                    moodId: params['moodId'],
                    weatherId: params['weatherId'],
                    diaryText: params['diaryText'],
                    otherPerspective: params['otherPerspective'],
                    futureMessage: params['futureMessage'],
                    selfCare: params['selfCare'],
                    tomorrowHope: params['tomorrowHope'],
                    gratitude: params['gratitude'],
                    dream: params['dream'],
                  ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['entries'] as _i4r7i20a.EntriesEndpoint).delete(
                    session,
                    params['id'],
                  ),
        ),
      },
    );
    connectors['images'] = _is.EndpointConnector(
      name: 'images',
      endpoint: endpoints['images']!,
      methodConnectors: {
        'createUploadDescription': _is.MethodConnector(
          name: 'createUploadDescription',
          params: {
            'entryId': _is.ParameterDescription(
              name: 'entryId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'filename': _is.ParameterDescription(
              name: 'filename',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['images'] as _ivqwes0y.ImagesEndpoint)
                  .createUploadDescription(
                    session,
                    entryId: params['entryId'],
                    filename: params['filename'],
                  ),
        ),
        'confirmUpload': _is.MethodConnector(
          name: 'confirmUpload',
          params: {
            'entryId': _is.ParameterDescription(
              name: 'entryId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'objectKey': _is.ParameterDescription(
              name: 'objectKey',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'contentType': _is.ParameterDescription(
              name: 'contentType',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'sizeBytes': _is.ParameterDescription(
              name: 'sizeBytes',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'width': _is.ParameterDescription(
              name: 'width',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'height': _is.ParameterDescription(
              name: 'height',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'caption': _is.ParameterDescription(
              name: 'caption',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['images'] as _ivqwes0y.ImagesEndpoint)
                  .confirmUpload(
                    session,
                    entryId: params['entryId'],
                    objectKey: params['objectKey'],
                    contentType: params['contentType'],
                    sizeBytes: params['sizeBytes'],
                    width: params['width'],
                    height: params['height'],
                    caption: params['caption'],
                  ),
        ),
        'forEntry': _is.MethodConnector(
          name: 'forEntry',
          params: {
            'entryId': _is.ParameterDescription(
              name: 'entryId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['images'] as _ivqwes0y.ImagesEndpoint).forEntry(
                    session,
                    params['entryId'],
                  ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'imageId': _is.ParameterDescription(
              name: 'imageId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['images'] as _ivqwes0y.ImagesEndpoint).delete(
                    session,
                    params['imageId'],
                  ),
        ),
      },
    );
    connectors['lookups'] = _is.EndpointConnector(
      name: 'lookups',
      endpoint: endpoints['lookups']!,
      methodConnectors: {
        'moods': _is.MethodConnector(
          name: 'moods',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['lookups'] as _ir220yj4.LookupsEndpoint)
                  .moods(session),
        ),
        'weathers': _is.MethodConnector(
          name: 'weathers',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['lookups'] as _ir220yj4.LookupsEndpoint)
                  .weathers(session),
        ),
      },
    );
    connectors['notes'] = _is.EndpointConnector(
      name: 'notes',
      endpoint: endpoints['notes']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notes'] as _i3f4yez7.NotesEndpoint).list(session),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'content': _is.ParameterDescription(
              name: 'content',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'title': _is.ParameterDescription(
              name: 'title',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'color': _is.ParameterDescription(
              name: 'color',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'isPinned': _is.ParameterDescription(
              name: 'isPinned',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notes'] as _i3f4yez7.NotesEndpoint).create(
                session,
                content: params['content'],
                title: params['title'],
                color: params['color'],
                isPinned: params['isPinned'],
              ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'content': _is.ParameterDescription(
              name: 'content',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'color': _is.ParameterDescription(
              name: 'color',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'isPinned': _is.ParameterDescription(
              name: 'isPinned',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notes'] as _i3f4yez7.NotesEndpoint).update(
                session,
                id: params['id'],
                content: params['content'],
                color: params['color'],
                isPinned: params['isPinned'],
              ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notes'] as _i3f4yez7.NotesEndpoint).delete(
                session,
                params['id'],
              ),
        ),
      },
    );
    connectors['events'] = _is.EndpointConnector(
      name: 'events',
      endpoint: endpoints['events']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'from': _is.ParameterDescription(
              name: 'from',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
            'to': _is.ParameterDescription(
              name: 'to',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['events'] as _iom7ynue.EventsEndpoint).list(
                session,
                from: params['from'],
                to: params['to'],
              ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'title': _is.ParameterDescription(
              name: 'title',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'startAt': _is.ParameterDescription(
              name: 'startAt',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'description': _is.ParameterDescription(
              name: 'description',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'endAt': _is.ParameterDescription(
              name: 'endAt',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
            'location': _is.ParameterDescription(
              name: 'location',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'isAllDay': _is.ParameterDescription(
              name: 'isAllDay',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
            'reminderMinutes': _is.ParameterDescription(
              name: 'reminderMinutes',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['events'] as _iom7ynue.EventsEndpoint).create(
                    session,
                    title: params['title'],
                    startAt: params['startAt'],
                    description: params['description'],
                    endAt: params['endAt'],
                    location: params['location'],
                    isAllDay: params['isAllDay'],
                    reminderMinutes: params['reminderMinutes'],
                  ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'title': _is.ParameterDescription(
              name: 'title',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'description': _is.ParameterDescription(
              name: 'description',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'startAt': _is.ParameterDescription(
              name: 'startAt',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
            'endAt': _is.ParameterDescription(
              name: 'endAt',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
            'location': _is.ParameterDescription(
              name: 'location',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'isAllDay': _is.ParameterDescription(
              name: 'isAllDay',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
            'reminderMinutes': _is.ParameterDescription(
              name: 'reminderMinutes',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['events'] as _iom7ynue.EventsEndpoint).update(
                    session,
                    id: params['id'],
                    title: params['title'],
                    description: params['description'],
                    startAt: params['startAt'],
                    endAt: params['endAt'],
                    location: params['location'],
                    isAllDay: params['isAllDay'],
                    reminderMinutes: params['reminderMinutes'],
                  ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['events'] as _iom7ynue.EventsEndpoint).delete(
                    session,
                    params['id'],
                  ),
        ),
      },
    );
    connectors['schedules'] = _is.EndpointConnector(
      name: 'schedules',
      endpoint: endpoints['schedules']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['schedules'] as _izarqe10.SchedulesEndpoint)
                  .list(session),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'title': _is.ParameterDescription(
              name: 'title',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'startAt': _is.ParameterDescription(
              name: 'startAt',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'endAt': _is.ParameterDescription(
              name: 'endAt',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
            'recurrenceRule': _is.ParameterDescription(
              name: 'recurrenceRule',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'reminderMinutes': _is.ParameterDescription(
              name: 'reminderMinutes',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['schedules'] as _izarqe10.SchedulesEndpoint)
                  .create(
                    session,
                    title: params['title'],
                    startAt: params['startAt'],
                    endAt: params['endAt'],
                    recurrenceRule: params['recurrenceRule'],
                    reminderMinutes: params['reminderMinutes'],
                  ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'title': _is.ParameterDescription(
              name: 'title',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'startAt': _is.ParameterDescription(
              name: 'startAt',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
            'endAt': _is.ParameterDescription(
              name: 'endAt',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
            'recurrenceRule': _is.ParameterDescription(
              name: 'recurrenceRule',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'reminderMinutes': _is.ParameterDescription(
              name: 'reminderMinutes',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['schedules'] as _izarqe10.SchedulesEndpoint)
                  .update(
                    session,
                    id: params['id'],
                    title: params['title'],
                    startAt: params['startAt'],
                    endAt: params['endAt'],
                    recurrenceRule: params['recurrenceRule'],
                    reminderMinutes: params['reminderMinutes'],
                  ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['schedules'] as _izarqe10.SchedulesEndpoint)
                  .delete(
                    session,
                    params['id'],
                  ),
        ),
      },
    );
    connectors['todos'] = _is.EndpointConnector(
      name: 'todos',
      endpoint: endpoints['todos']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'weekLabel': _is.ParameterDescription(
              name: 'weekLabel',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['todos'] as _igh4w5sj.TodosEndpoint).list(
                session,
                weekLabel: params['weekLabel'],
              ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'title': _is.ParameterDescription(
              name: 'title',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'notes': _is.ParameterDescription(
              name: 'notes',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'dueDate': _is.ParameterDescription(
              name: 'dueDate',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
            'weekLabel': _is.ParameterDescription(
              name: 'weekLabel',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'priority': _is.ParameterDescription(
              name: 'priority',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['todos'] as _igh4w5sj.TodosEndpoint).create(
                session,
                title: params['title'],
                notes: params['notes'],
                dueDate: params['dueDate'],
                weekLabel: params['weekLabel'],
                priority: params['priority'],
              ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'title': _is.ParameterDescription(
              name: 'title',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'notes': _is.ParameterDescription(
              name: 'notes',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'dueDate': _is.ParameterDescription(
              name: 'dueDate',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
            'weekLabel': _is.ParameterDescription(
              name: 'weekLabel',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'priority': _is.ParameterDescription(
              name: 'priority',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'isDone': _is.ParameterDescription(
              name: 'isDone',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['todos'] as _igh4w5sj.TodosEndpoint).update(
                session,
                id: params['id'],
                title: params['title'],
                notes: params['notes'],
                dueDate: params['dueDate'],
                weekLabel: params['weekLabel'],
                priority: params['priority'],
                isDone: params['isDone'],
              ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['todos'] as _igh4w5sj.TodosEndpoint).delete(
                session,
                params['id'],
              ),
        ),
      },
    );
    connectors['dailyQuotes'] = _is.EndpointConnector(
      name: 'dailyQuotes',
      endpoint: endpoints['dailyQuotes']!,
      methodConnectors: {
        'today': _is.MethodConnector(
          name: 'today',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['dailyQuotes'] as _iyiyze1d.DailyQuotesEndpoint)
                      .today(session),
        ),
        'history': _is.MethodConnector(
          name: 'history',
          params: {
            'month': _is.ParameterDescription(
              name: 'month',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['dailyQuotes'] as _iyiyze1d.DailyQuotesEndpoint)
                      .history(
                        session,
                        month: params['month'],
                      ),
        ),
        'reshuffle': _is.MethodConnector(
          name: 'reshuffle',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['dailyQuotes'] as _iyiyze1d.DailyQuotesEndpoint)
                      .reshuffle(
                        session,
                        params['id'],
                      ),
        ),
      },
    );
    connectors['quotes'] = _is.EndpointConnector(
      name: 'quotes',
      endpoint: endpoints['quotes']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'category': _is.ParameterDescription(
              name: 'category',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['quotes'] as _i0kbgmpc.QuotesEndpoint).list(
                session,
                category: params['category'],
              ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'text': _is.ParameterDescription(
              name: 'text',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'author': _is.ParameterDescription(
              name: 'author',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'source': _is.ParameterDescription(
              name: 'source',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'category': _is.ParameterDescription(
              name: 'category',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['quotes'] as _i0kbgmpc.QuotesEndpoint).create(
                    session,
                    text: params['text'],
                    author: params['author'],
                    source: params['source'],
                    category: params['category'],
                  ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'text': _is.ParameterDescription(
              name: 'text',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'author': _is.ParameterDescription(
              name: 'author',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'source': _is.ParameterDescription(
              name: 'source',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'category': _is.ParameterDescription(
              name: 'category',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'isActive': _is.ParameterDescription(
              name: 'isActive',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['quotes'] as _i0kbgmpc.QuotesEndpoint).update(
                    session,
                    id: params['id'],
                    text: params['text'],
                    author: params['author'],
                    source: params['source'],
                    category: params['category'],
                    isActive: params['isActive'],
                  ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['quotes'] as _i0kbgmpc.QuotesEndpoint).delete(
                    session,
                    params['id'],
                  ),
        ),
      },
    );
    connectors['reflections'] = _is.EndpointConnector(
      name: 'reflections',
      endpoint: endpoints['reflections']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'entryId': _is.ParameterDescription(
              name: 'entryId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['reflections'] as _igito0lv.ReflectionsEndpoint)
                      .list(
                        session,
                        entryId: params['entryId'],
                      ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'thought': _is.ParameterDescription(
              name: 'thought',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'entryId': _is.ParameterDescription(
              name: 'entryId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'quoteId': _is.ParameterDescription(
              name: 'quoteId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'selfMessageId': _is.ParameterDescription(
              name: 'selfMessageId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['reflections'] as _igito0lv.ReflectionsEndpoint)
                      .create(
                        session,
                        thought: params['thought'],
                        entryId: params['entryId'],
                        quoteId: params['quoteId'],
                        selfMessageId: params['selfMessageId'],
                      ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'thought': _is.ParameterDescription(
              name: 'thought',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['reflections'] as _igito0lv.ReflectionsEndpoint)
                      .update(
                        session,
                        id: params['id'],
                        thought: params['thought'],
                      ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['reflections'] as _igito0lv.ReflectionsEndpoint)
                      .delete(
                        session,
                        params['id'],
                      ),
        ),
      },
    );
    connectors['selfMessages'] = _is.EndpointConnector(
      name: 'selfMessages',
      endpoint: endpoints['selfMessages']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['selfMessages'] as _ifxzgp8p.SelfMessagesEndpoint)
                      .list(session),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'content': _is.ParameterDescription(
              name: 'content',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'entryId': _is.ParameterDescription(
              name: 'entryId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['selfMessages'] as _ifxzgp8p.SelfMessagesEndpoint)
                      .create(
                        session,
                        content: params['content'],
                        entryId: params['entryId'],
                      ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'content': _is.ParameterDescription(
              name: 'content',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['selfMessages'] as _ifxzgp8p.SelfMessagesEndpoint)
                      .update(
                        session,
                        id: params['id'],
                        content: params['content'],
                      ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['selfMessages'] as _ifxzgp8p.SelfMessagesEndpoint)
                      .delete(
                        session,
                        params['id'],
                      ),
        ),
      },
    );
    connectors['seed'] = _is.EndpointConnector(
      name: 'seed',
      endpoint: endpoints['seed']!,
      methodConnectors: {
        'run': _is.MethodConnector(
          name: 'run',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['seed'] as _iaci3p0i.SeedEndpoint).run(session),
        ),
      },
    );
    connectors['stats'] = _is.EndpointConnector(
      name: 'stats',
      endpoint: endpoints['stats']!,
      methodConnectors: {
        'moodGrid': _is.MethodConnector(
          name: 'moodGrid',
          params: {
            'month': _is.ParameterDescription(
              name: 'month',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['stats'] as _ibh8msu8.StatsEndpoint).moodGrid(
                    session,
                    month: params['month'],
                  ),
        ),
        'weatherGrid': _is.MethodConnector(
          name: 'weatherGrid',
          params: {
            'month': _is.ParameterDescription(
              name: 'month',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['stats'] as _ibh8msu8.StatsEndpoint).weatherGrid(
                    session,
                    month: params['month'],
                  ),
        ),
        'summary': _is.MethodConnector(
          name: 'summary',
          params: {
            'month': _is.ParameterDescription(
              name: 'month',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['stats'] as _ibh8msu8.StatsEndpoint).summary(
                    session,
                    month: params['month'],
                  ),
        ),
      },
    );
    connectors['weather'] = _is.EndpointConnector(
      name: 'weather',
      endpoint: endpoints['weather']!,
      methodConnectors: {
        'current': _is.MethodConnector(
          name: 'current',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['weather'] as _i8nd21di.WeatherEndpoint)
                  .current(session),
        ),
        'daily': _is.MethodConnector(
          name: 'daily',
          params: {
            'date': _is.ParameterDescription(
              name: 'date',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['weather'] as _i8nd21di.WeatherEndpoint).daily(
                    session,
                    params['date'],
                  ),
        ),
        'history': _is.MethodConnector(
          name: 'history',
          params: {
            'from': _is.ParameterDescription(
              name: 'from',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
            'to': _is.ParameterDescription(
              name: 'to',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['weather'] as _i8nd21di.WeatherEndpoint).history(
                    session,
                    from: params['from'],
                    to: params['to'],
                  ),
        ),
        'setLocation': _is.MethodConnector(
          name: 'setLocation',
          params: {
            'lat': _is.ParameterDescription(
              name: 'lat',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'lon': _is.ParameterDescription(
              name: 'lon',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['weather'] as _i8nd21di.WeatherEndpoint)
                  .setLocation(
                    session,
                    lat: params['lat'],
                    lon: params['lon'],
                    name: params['name'],
                  ),
        ),
      },
    );
  }
}
