# H3-S6 · Card cầu nối nhật ký + “Lời nhắc dịu dàng”

**Epic:** H3 · **Ước lượng:** 1 pt · **Phụ thuộc:** H3-S1
**Nguồn thiết kế:** `ui-figma/suckhoe/memoir_c_p_nh_t_th_ng_s_c_nh_n_bmi/code.html`
dòng 450–452 (card “Kết nối sức khoẻ với Memoir Diary”) và 507–521 (card “Lời nhắc
dịu dàng” — “Cơ thể bạn là ngôi đền duy nhất bạn có suốt cuộc đời…” + “Trích Memoir
Mindful Journal”)

## Mục tiêu

Dựng hai khối tĩnh còn lại của cột phải: card mời viết nhật ký và card “Lời nhắc dịu
dàng” (câu động viên).

## Phạm vi

- **Tạo mới:** `flutter_app/lib/src/ui/health/health_quote_card.dart`.
- **KHÔNG sửa:** `ui/widgets/app_header.dart`; **không** dựng lại footer biên tập của
  thiết kế (dòng 522–541) — app đã bỏ `AppFooterBar` (commit `471bb22`, `42bbc39`).

## Việc cần làm

- [ ] `HealthJournalBridgeCard({required VoidCallback onOpenJournal})` — nền
      `palette.surfaceBrandSubtle`, icon `Icons.menu_book`, câu dẫn của thiết kế,
      `TextButton` “Mở nhật ký hôm nay” ⇒ `Navigator.push` màn nhật ký hiện có
      (`ui/screens/entry_editor.dart`) cho ngày đang chọn.
- [ ] `HealthGentleReminderCard({String? text, String? source})` — khung quote biên tập:
      chữ `serifFamily` + `MemoirType.headingEditorial`, dấu ngoặc kép, dòng nguồn
      nghiêng `Trích Memoir Mindful Journal`; nền `backgroundPage` +
      viền `borderDefault`, icon `Icons.spa`.
- [ ] Nội dung mặc định **nguyên văn** thiết kế khi chưa có nguồn động:
      “Cơ thể bạn là ngôi đền duy nhất bạn có suốt cuộc đời. Đừng quá khắt khe với những
      ngày chưa chạm đến mục tiêu, chỉ cần lắng nghe và tiếp tục bước đi.”
- [ ] (Tuỳ chọn, nếu rẻ) lấy câu theo ngày từ kho câu sẵn có (`daily_quotes` /
      `quoteRepositoryProvider`) và truyền vào `text/source`; không dựng thêm bảng mới.
- [ ] `flutter analyze`.

## Acceptance Criteria

1. *Given* màn Sức khoẻ đang mở ngày 17/10/2026, *when* bấm “Mở nhật ký hôm nay”, *then*
   mở trình soạn nhật ký **của ngày 17/10/2026** (không phải hôm nay).
2. *Given* không truyền `text`, *then* card nhắc hiển thị đúng câu mặc định ở trên và
   dòng “Trích Memoir Mindful Journal”.
3. *Given* có câu từ kho câu, *then* card hiển thị câu đó kèm nguồn tương ứng (không
   còn dùng câu mặc định).
4. *Then* **không** có footer biên tập/quyền riêng tư nào được thêm vào màn (app đã bỏ
   footer dùng chung — đừng dựng lại cục bộ).
5. *Then* câu nhắc dùng `serifFamily`; `flutter analyze` sạch.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
flutter run -d chrome --web-port 8080   # so 2 card với code.html 450–452 và 507–521
```

## Rủi ro / ghi chú

- Card cầu nối phải gọi API nhật ký **sau** khi người dùng bấm (không prefetch), tránh
  thêm request nặng cho màn Sức khoẻ.
- Nếu chọn lấy câu từ kho câu: dùng đúng provider sẵn có, **không** gọi HTTP trực tiếp
  trong widget (quy ước provider ở `00-conventions.md` §6).
- Đây là task nhỏ (1 điểm): đừng nới phạm vi sang footer, breadcrumb hay utilities.
