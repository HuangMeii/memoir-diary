# 03 — User Flows và Prototype Connections

## FLOW-01 — Đăng nhập vào Home

```text
AUTH-01
  ├─ submit hợp lệ → AUTH-03 → HOME-01
  ├─ sai thông tin → AUTH-01 / error state
  └─ chưa có tài khoản → AUTH-02
AUTH-02
  ├─ đăng ký thành công → HOME-01
  └─ username/email đã tồn tại → AUTH-02 / inline error
```

## FLOW-02 — Ghi nhanh hôm nay

```text
HOME-01
  ├─ chọn mood → lưu ngay → HOME-01 / toast thành công
  ├─ chọn weather → lưu ngay → HOME-01 / toast thành công
  └─ Viết nhật ký → JOURNAL-02
JOURNAL-02
  ├─ chọn ảnh trước khi lưu → nhắc "Lưu nhật ký trước"
  ├─ Lưu → JOURNAL-03 hoặc quay về HOME-01
  └─ quay lại khi có thay đổi → confirm bỏ thay đổi
```

## FLOW-03 — Nhìn lại một tháng

```text
HOME-01 → JOURNAL-01
JOURNAL-01
  ├─ tháng trước / sau → reload grid
  ├─ tap ngày có dữ liệu → JOURNAL-02
  └─ xem summary → HEALTH-02 hoặc HEALTH-01
```

## FLOW-04 — Quote và phản tư

```text
HOME-01 → HOME-02
HOME-02
  ├─ đổi câu → loading card → pair mới
  ├─ lưu lời nhắn → cập nhật kho self-message
  ├─ lưu phản tư → toast thành công
  └─ Lịch sử → LIB-02
```

## FLOW-05 — Lập kế hoạch

```text
HOME-01 → PLAN-01
PLAN-01
  ├─ Mục tiêu → thêm inline → tick hoàn thành
  ├─ Sự kiện → mở PLAN-03 → lưu → list
  └─ Lịch biểu → mở PLAN-04 → lưu → list
```

## FLOW-06 — Xử lý lỗi dùng chung

- 401: hiển thị session hết hạn, đưa về AUTH-01 sau khi người dùng xác nhận.
- 5xx / mất mạng: giữ dữ liệu người dùng đang nhập, hiển thị retry rõ ràng.
- Xóa dữ liệu: dùng dialog xác nhận, nêu rõ hành động không hoàn tác.
- Empty state luôn có một CTA tiếp theo, không chỉ hiển thị “chưa có dữ liệu”.

