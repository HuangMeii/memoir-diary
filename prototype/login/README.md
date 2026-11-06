# Prototype — Trang đăng nhập Memoir (sách lật + nhánh cây)

Bản **tĩnh** (HTML/CSS/JS thuần, không build, không gọi API) của màn
`AUTH-01 · Đăng nhập`, dùng để chốt hiệu ứng trước khi port sang Flutter.

- `index.html` — markup + illustration SVG chia 3 layer.
- `login.css` — design tokens (copy từ `flutter_app/lib/src/ui/tokens.dart`) và animation.
- `login.js` — state machine focus/typing, toggle mật khẩu, đổi theme, nút xem lại.

## 1. Cách mở

Phải **serve từ root repo**, vì font tham chiếu tới `flutter_app/assets/fonts/`:

```bash
# tại d:\OldLapData\Memoir
python -m http.server 5500
# mở http://localhost:5500/prototype/login/
```

Mở trực tiếp `index.html` bằng `file://` sẽ mất font (Lora/Inter) nhưng hiệu ứng vẫn chạy.

## 2. Hiệu ứng

| Trạng thái | Kích hoạt | Điều gì xảy ra |
|---|---|---|
| `is-writing` | focus vào ô *Tên đăng nhập* / *Mật khẩu*, đang gõ, hoặc ô còn chữ | Trang phải của sách lật quanh gáy (`rotateY 0 → -172°`, xoay ở `x = 170` trong viewBox 340×300) và mờ dần khi đã nằm bên trái, để lộ **trang mới** bên dưới. Nhánh cây `translate(44px, -6px) rotate(8deg)` quanh gốc cành `(208, 208)`; 6 cụm lá đi theo với delay 60–260ms nên đọc như một nét cọ. Nền artwork mờ còn 0.45, card form nhích `-8px` và lên shadow. |
| trở về tĩnh | rời khỏi cả hai ô **và** cả hai đều rỗng | Mọi thứ chạy ngược lại thang thời gian tương ứng. |
| `is-demo` | nút **Xem lại hiệu ứng** | Cùng chuỗi animation nhưng không đụng vào nội dung ô nhập. |
| tự chạy | mở trang (sau 700 ms) | Chạy chuỗi `is-demo` một lần để thấy hiệu ứng ngay, không phải đoán là phải focus. |

- Thời lượng: trang `620ms` (`cubic-bezier(.22,.61,.36,1)`), cành `640ms`
  (`cubic-bezier(.34,1.16,.44,1)`), nền `520ms`, card `520ms`.
- Bóng đổ của trang khi đang lật là `@keyframes page-shade` (đỉnh ~0.5 ở 45%).
- `prefers-reduced-motion: reduce` → các biến `--duration-*` về `1ms` (trạng thái cuối vẫn
  đúng). Nút **Chuyển động: bật/tắt** ghi `html[data-motion]` để bật lại khi review.
- Artwork hiện ở **mọi bề rộng**: dưới 960 px nó nằm phía trên form nên hiệu ứng luôn
  nhìn thấy được (bản Flutter vẫn ẩn illustration ở mobile).

## 3. Chỉnh nhanh

| Muốn đổi | Sửa ở |
|---|---|
| Màu | block `:root` / `html[data-theme='dark']` trong `login.css` (tên biến khớp token) |
| Thời lượng, easing | các biến `--duration-*` (`page`/`sweep`/`soft`/`leaf`/`fade`) và `--ease-page`/`--ease-sweep` |
| Bật/tắt chuyển động | thuộc tính `data-motion` trên thẻ html (`force`/`off`) |
| Độ "gạt" của cành | rule `body:is(.is-writing, .is-demo) .branch` |
| Góc lật trang | rule `body:is(.is-writing, .is-demo) .page-flip` |
| Nội dung trang mới | group `#page-shape`-clipped `.page-under` trong `index.html` |

## 4. Ghi chú port sang Flutter (sau này)

1. Tách `illustration-login.svg` thành 3 asset: nền+bóng, sách (bìa/trang/gáy/kẻ
   chữ/bookmark), cành (stem + 6 cụm lá).
2. `LoginArtwork` (`flutter_app/lib/src/ui/auth/login_artwork.dart`):
   `AnimationController` 620ms + `CurvedAnimation`, `Transform` với
   `Matrix4..setEntry(3, 2, 0.0015)..rotateY()` cho trang, `Transform.translate` +
   `rotate` cho cành, `Interval` 60–260ms cho từng cụm lá.
3. Trang thái lấy từ `FocusNode` + `TextEditingController` của `LoginScreen`;
   mobile (< 900px) giữ `SvgPicture.asset(loginIllustrationAsset)` tĩnh.
4. `MediaQuery.of(context).disableAnimations` → `duration = Duration.zero`.
5. Màu dùng `MemoirColorsLight/Dark` sẵn có, không hard-code hex trong Dart.

## 5. Giới hạn đã biết

- Không có logic đăng nhập: submit chỉ hiện banner lỗi mẫu.
- Artwork hiện ở mọi bề rộng (dưới 960 px nằm trên form); bản Flutter vẫn ẩn illustration ở mobile như cũ.
- Mặt sau trang bị `opacity` che đi; nếu cần nhìn thấy "mặt sau giấy" thật thì phải
  vẽ thêm một lớp backface riêng.
