# 04 — Wireframes

Các wireframe dưới đây dùng để dựng low-fidelity frame trước khi làm visual
design. Kích thước tham chiếu: mobile 390×844, web 1440×1024.

## 1. App shell

```text
Mobile
┌──────────────────────────────┐
│ AppBar: logo / title / action│
├──────────────────────────────┤
│                              │
│          Content             │
│                              │
├──────────────────────────────┤
│ Hôm nay | Nhật ký | Kế hoạch│
│             | Tài khoản      │
└──────────────────────────────┘
```

```text
Web
┌──────────────┬─────────────────────────────────────┐
│ Memoir       │ Header: breadcrumb / date / profile │
│ Hôm nay      ├─────────────────────────────────────┤
│ Nhật ký      │                                     │
│ Kho lưu giữ  │              Content                │
│ Kế hoạch     │                                     │
│ Sức khỏe     │                                     │
│ Tài khoản    │                                     │
└──────────────┴─────────────────────────────────────┘
```

## 2. HOME-01 — Hôm nay

```text
┌────────────────────────────────┐
│ Xin chào, [tên]        [avatar]│
│ Hôm nay, 10/10/2026            │
├────────────────────────────────┤
│ THỜI TIẾT       CẢM XÚC        │
│ [☀][⛅][🌧][⛈][?] [😀][😢]...   │
├────────────────────────────────┤
│ CÂU HÔM NAY                    │
│ “Câu từ kho...”                │
│ “Lời nhắn của bạn...”          │
│ [Viết suy nghĩ................]│
│ [Lưu phản tư] [Đổi câu]        │
├────────────────────────────────┤
│ [Viết nhật ký hôm nay]         │
├──────────┬──────────┬──────────┤
│ Lưới tháng│ Ghi chú │ Kế hoạch │
│ Sức khỏe  │ Lịch sử │ ...      │
└──────────┴──────────┴──────────┘
```

## 3. JOURNAL-01 / JOURNAL-02

- Lưới tháng: header tháng + 2 card grid + legend + summary.
- Editor mobile: một cột, các section card xếp dọc.
- Editor web: cột chính 2/3 cho text, cột phụ 1/3 cho mood/weather,
  ảnh và nút lưu sticky.
- Khi editor có thay đổi chưa lưu, nút lưu phải luôn nhìn thấy trên web và
  nằm ở AppBar/bottom action trên mobile.

## 4. PLAN-01

- Header: tên “Kế hoạch”, chọn tuần/ngày.
- Tab ngang trên mobile; segmented control hoặc tab trên web.
- Mỗi item có checkbox/trạng thái, thời gian, menu “Sửa/Xóa”.
- Thêm nhanh là input cuối danh sách; form chi tiết dùng bottom sheet mobile,
  side panel hoặc dialog web.

## 5. HEALTH-01 / HEALTH-02

- Health-01 ưu tiên nhập nhanh bằng các field số lớn, nhóm 2 cột trên web.
- Health-02 đặt summary cards phía trên biểu đồ; luôn có nhãn trục và đơn vị,
  không dùng màu làm thông tin duy nhất.

## 6. Trạng thái bắt buộc trong Figma

Mỗi màn hình dữ liệu cần tối thiểu 6 variant: `default`, `loading`, `empty`,
`error`, `success`, `disabled`. Với form thêm `validation` và `unsaved`.

