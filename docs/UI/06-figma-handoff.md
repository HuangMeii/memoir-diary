# 06 — Figma Handoff

## 1. Cấu trúc Figma file

```text
Memoir UI
├── 00 Cover & Changelog
├── 01 Foundations
├── 02 Components
├── 03 Auth
├── 04 Home
├── 05 Journal
├── 06 Library
├── 07 Planner
├── 08 Health
├── 09 Account
├── 10 Roadmap
└── 99 Archive
```

Mỗi page nên có các section `Mobile`, `Tablet`, `Web`, sau đó là section
`States` cho loading/empty/error/success.

## 2. Quy ước đặt tên frame

```text
[ID] / [Tên] / [Platform] / [State]

Ví dụ:
HOME-01 / Hôm nay / Mobile / Default
JOURNAL-02 / Editor / Web / Unsaved
PLAN-01 / Kế hoạch / Tablet / Empty
```

## 3. Quy ước component

```text
Component / Category / Name
Variant: State=Default, Size=Medium, Platform=Mobile
```

Không tạo component trùng chỉ vì khác nội dung. Dùng variant cho state và
property cho label/icon.

## 4. Checklist trước khi bàn giao

- [ ] Có mobile và web cho tất cả màn hình thuộc MVP.
- [ ] Có loading, empty, error, success và disabled.
- [ ] Có flow prototype cho 6 flow trong
  [03-user-flows.md](03-user-flows.md).
- [ ] Tất cả CTA có trạng thái pressed/disabled.
- [ ] Nội dung tiếng Việt dài đã được kiểm tra overflow.
- [ ] Touch target tối thiểu 44×44 px.
- [ ] Màu không phải kênh thông tin duy nhất.
- [ ] Các frame có ID trùng với screen inventory.
- [ ] Các trường form map được với API/backend hiện có.
- [ ] Những frame `[ROADMAP]` không trộn vào luồng MVP.

## 5. Thứ tự dựng Figma đề xuất

1. Foundations và app shell.
2. AUTH-01/02 và HOME-01.
3. JOURNAL-01/02/03 — luồng giá trị cốt lõi.
4. PLAN-01 và HEALTH-01.
5. LIB-01/02/03.
6. Account và toàn bộ error/empty states.
7. Roadmap sau khi MVP được duyệt.

