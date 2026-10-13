# 03 — Mapping FastAPI sang Flutter

> Transport: FastAPI = reference trong migration; đích cuối = Serverpod/Dart
> (xem `07-serverpod-migration-roadmap.md`).

## 1. Nguyên tắc mapping

Mỗi endpoint FastAPI phải có repository method, model response và test parity.
Không thay thế API bằng các lệnh rải rác trong widget.

## 2. Bảng mapping

| API cũ | Flutter target |
|---|---|
| `/auth/register`, `/auth/login`, `/auth/refresh`, `/auth/me` | `AuthRepository`, `FastApiAuthDataSource`, `SessionController` |
| `/moods`, `/weathers` | `LookupRepository` |
| `/entries`, `/entries/by-date` | `EntryRepository` + `EntryController` |
| `/entries/{id}/images`, `/images/{id}/url` | `EntryImageRepository` + Storage gateway |
| `/quotes` | `QuoteRepository`; system quote qua admin function |
| `/daily-quotes/today` | `DailyQuoteRepository.getToday()` function/transaction |
| `/daily-quotes` | `DailyQuoteRepository.history(month)` |
| `/self-messages` | `SelfMessageRepository` |
| `/reflections` | `ReflectionRepository` |
| `/notes` | `NoteRepository` |
| `/todos` | `TodoRepository` |
| `/events` | `EventRepository` |
| `/schedule-items` | `ScheduleRepository` hoặc Calendar repository sau khi gộp |
| `/health-logs` | `HealthRepository` |
| `/stats/*` | `StatsRepository`, view/RPC/function |
| `/weather/*` | `WeatherRepository`, function nếu cần cache |
| `/admin/*` | `AdminRepository`, admin-only FastAPI dependency |

## 3. Chuẩn hóa response/error

Tạo các type dùng chung:

- `AppFailure`: unauthorized, forbidden, validation, conflict, notFound,
  network, server, unknown.
- `Result<T>` hoặc AsyncValue chuẩn trong Riverpod.
- `Page<T>` nếu endpoint có pagination.
- `DateOnly`/ISO date helper để không lệch timezone.

Không dùng `Map<String, dynamic>` xuyên suốt feature mới; chuyển dần sang typed
model và request DTO.

## 4. Chuyển đổi ApiClient

1. Giữ `ApiClient` làm transport chung.
2. Tạo `FastApi*DataSource` theo từng domain.
3. Repository gọi datasource thay vì gọi Dio trong widget/provider.
4. Chuẩn hóa request/response DTO và `ApiException`.
5. Chỉ thay đổi route khi có API versioning và contract test.
