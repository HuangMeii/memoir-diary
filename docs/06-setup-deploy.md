# 06 — Setup & Deploy

## 1. Yêu cầu hệ thống

| Thành phần | Phiên bản đề nghị | Ghi chú |
|---|---|---|
| Python | 3.12 (khuyến nghị) | Tránh 3.14 để đủ wheel psycopg/pydantic-core |
| FastAPI / Uvicorn | mới nhất | |
| PostgreSQL | Neon serverless | Cloud, không cần cài local |
| Neon Object Storage | — | S3-compatible, cần bật trong Neon project |
| Flutter SDK | 3.22+ | Bắt buộc để build app/web |
| Git | 2.40+ | |

> ⚠️ Trên máy hiện tại **chưa có Flutter SDK**. Cài bằng `winget install --id Google.Flutter` hoặc tải zip Flutter ổn định và thêm `flutter\bin` vào PATH.

---

## 2. Cài Backend (FastAPI)

```powershell
cd backend
# Khuyến nghị dùng conda env Python 3.12 nếu máy đang chạy 3.14
conda create -n memoir python=3.12 -y
conda activate memoir

python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

`requirements.txt` (dự kiến):
```
fastapi
uvicorn[standard]
sqlalchemy>=2.0
alembic
psycopg[binary]
pydantic>=2
pydantic-settings
python-jose[cryptography]
passlib[bcrypt]
python-multipart
boto3
python-dotenv
```

---

## 3. Cấu hình `.env`

Tạo `backend/.env` từ `backend/.env.example`:

```env
# --- Database (Neon PostgreSQL) ---
DATABASE_URL=postgresql+psycopg://USER:PASSWORD@ep-xxx.aws-us-east-1.aws.neon.tech/memoir?sslmode=require

# --- Neon Object Storage (S3-compatible) ---
S3_ENDPOINT_URL=https://<branch-endpoint>.neon.tech
S3_REGION=aws-us-east-1
S3_ACCESS_KEY_ID=nak_live_xxxxxxxx     # = token_id
S3_SECRET_ACCESS_KEY=nsk_live_xxxxxxxx # = s3_secret_access_key
S3_BUCKET=diary-images

# --- Auth ---
JWT_SECRET=change-me-to-a-long-random-string
JWT_ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=60

# --- App ---
CORS_ORIGINS=http://localhost:8080,http://127.0.0.1:8080
```

> **Lưu ý Neon Object Storage**: chỉ hỗ trợ **path-style + SigV4** → boto3 phải đặt `endpoint_url` và `config=Config(s3={'addressing_style':'path'})`. Không hỗ trợ `PutBucketAcl`/`PutBucketPolicy`; đặt access level (`private`/`public_read`) qua Neon Console/API.

---

## 4. Migrate & Seed

```powershell
# Tạo migration đầu tiên
alembic revision --autogenerate -m "init schema"
alembic upgrade head

# Seed moods, weathers, 100 quotes
python -m app.seed.seed
```

---

## 5. Chạy backend (dev)

```powershell
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

- Swagger UI: http://127.0.0.1:8000/docs
- Health: http://127.0.0.1:8000/health

---

## 6. Cài & chạy Flutter

```powershell
cd flutter_app
flutter pub get
```

**Web (dev)**:
```powershell
flutter run -d chrome --dart-define=API_BASE_URL=http://127.0.0.1:8000
```

**App (dev, có thiết bị/emulator)**:
```powershell
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000   # Android emulator
```

**Build phát hành**:
```powershell
flutter build web --release --dart-define=API_BASE_URL=https://api.example.com
flutter build apk --release --dart-define=API_BASE_URL=https://api.example.com
# iOS (cần macOS): flutter build ios --release
```

---

## 7. Triển khai (production)

### Backend
- Chạy `gunicorn -k uvicorn.workers.UvicornWorker app.main:app` (Render/Fly/VPS).
- Đặt biến môi trường giống `.env` trên nền tảng host.
- Bật HTTPS, cấu hình `CORS_ORIGINS` = domain web thật.

### Web
- `flutter build web --release` → upload thư mục `build/web` lên Netlify/Vercel/Firebase Hosting.

### App
- Ký và phát hành qua Google Play / App Store.

---

## 8. Checklist Go-live

- [ ] `.env` đã điền đủ DATABASE_URL, S3_*, JWT_SECRET
- [ ] Bucket `diary-images` đã tạo, access level đúng
- [ ] `alembic upgrade head` thành công
- [ ] Seed xong 5 moods, 5 weathers, 100 quotes
- [ ] `/health` trả `ok`
- [ ] Đăng ký/đăng nhập/upload ảnh smoke test OK
- [ ] Web build chạy, gọi được API (CORS đúng)
