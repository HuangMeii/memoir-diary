# 01 — Information Architecture

## 1. Mục tiêu trải nghiệm

Memoir phải giúp người dùng hoàn thành ba việc trong vài giây:

1. Ghi lại trạng thái hiện tại: cảm xúc, thời tiết và một vài dòng nhật ký.
2. Nhìn lại: mở một ngày cũ hoặc quan sát xu hướng theo tháng.
3. Sắp xếp ngày mai: mục tiêu, sự kiện, lịch biểu và chăm sóc sức khỏe.

## 2. Sitemap người dùng

```text
AUTH
└── Đăng nhập / Đăng ký

APP
├── Hôm nay (Home)
│   ├── Chọn cảm xúc nhanh
│   ├── Chọn thời tiết nhanh
│   ├── Câu nói hôm nay + phản tư
│   └── Viết nhật ký hôm nay
├── Nhật ký
│   ├── Lưới tháng cảm xúc / thời tiết
│   ├── Nhật ký theo ngày
│   └── Trình soạn nhật ký + ảnh
├── Kho lưu giữ
│   ├── Ghi chú nhanh
│   ├── Lịch sử câu nói
│   └── Lời nhắn cho bản thân
├── Kế hoạch
│   ├── Mục tiêu tuần
│   ├── Sự kiện
│   └── Lịch biểu
├── Sức khỏe
│   ├── Nhập dữ liệu theo ngày
│   └── Xu hướng 30 ngày
└── Tài khoản
    ├── Thông tin cá nhân
    ├── Giao diện sáng / tối
    └── Đăng xuất
```

## 3. Điều hướng theo nền tảng

### Mobile

- Dùng `NavigationBar` 4 mục: **Hôm nay**, **Nhật ký**, **Kế hoạch**, **Tài khoản**.
- Nút hành động nổi hoặc nút chính trong Home: **Viết nhật ký**.
- Các chức năng phụ (Ghi chú, Sức khỏe, Lịch sử câu nói) mở từ lưới shortcut
  hoặc bottom sheet “Tất cả”.
- Màn hình con có AppBar và nút quay lại rõ ràng.

### Web / desktop

- Sidebar cố định rộng 240–280 px gồm logo, điều hướng chính và tài khoản.
- Vùng nội dung giới hạn khoảng 1200 px, dùng grid 12 cột.
- Home dùng 2 cột: nội dung hôm nay bên trái, tóm tắt/thao tác nhanh bên phải.
- Editor dùng 2 cột: nội dung chính bên trái, metadata và ảnh bên phải.

## 4. Phân quyền

| Vai trò | Phạm vi UI |
|---|---|
| User | Chỉ xem/sửa dữ liệu cá nhân và nội dung chung ở chế độ đọc |
| Admin | Thêm khu Admin để quản lý kho câu chung, tài khoản và thống kê hệ thống |

Không hiển thị khu Admin trong điều hướng của user thường.

