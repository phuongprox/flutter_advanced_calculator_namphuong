## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# 📱 flutter_calculator_namphuong
## Ứng Dụng Máy Tính Cơ Bản với Giao Diện Dark Mode (Flutter/Dart)

Dự án này là một ứng dụng máy tính di động được phát triển bằng Flutter và Dart, nổi bật với giao diện tối (Dark Mode) được thiết kế để mô phỏng chính xác giao diện của một ứng dụng máy tính hiện đại trên thiết bị di động.

## 📸 Ảnh Chụp Màn Hình Ứng Dụng

| Giao diện chính |
| :---: |
| <img src="monitor_main.png" alt="Ảnh chụp màn hình của ứng dụng máy tính với giao diện tối" width="300"/> |

**Ghi chú:** *Hãy thay thế `screenshot.png` bằng tên file ảnh chụp màn hình thực tế của bạn và đảm bảo file ảnh đó nằm trong thư mục gốc của dự án.*

---

## ⚙️ Hướng Dẫn Cách Chạy Dự Án

Để khởi chạy dự án này trên máy tính của bạn, bạn cần cài đặt Flutter SDK.

### Yêu Cầu Tiên Quyết

* **Flutter SDK:** Phiên bản ổn định mới nhất.
* **Thiết bị/Trình giả lập:** Thiết bị Android, iOS, hoặc trình duyệt web (Web) đã được cấu hình.
* **IDE:** Visual Studio Code (VS Code) hoặc Android Studio.

### Các Bước Thực Hiện

1.  **Clone Repository:** Tải dự án về máy tính của bạn bằng cách sử dụng Git.
    ```bash
    git clone [https://github.com/](https://github.com/)[your-username]/flutter_caculator_namphuong.git
    ```
    *(Thay thế `[your-username]` bằng tên người dùng GitHub của bạn)*

2.  **Di chuyển vào thư mục dự án:**
    ```bash
    cd flutter_caculator_namphuong
    ```

3.  **Tải các gói dependencies:**
    ```bash
    flutter pub get
    ```

4.  **Chạy ứng dụng:** Khởi chạy ứng dụng trên thiết bị hoặc trình giả lập đã kết nối.
    ```bash
    flutter run
    ```
    *Hoặc sử dụng tùy chọn **Run/Debug** trong IDE của bạn (VS Code/Android Studio).*

---

## ✨ Các Tính Năng Đã Thêm

Dự án được phát triển với trọng tâm là mô phỏng giao diện người dùng chính xác, đồng thời tích hợp đầy đủ các chức năng của một máy tính tiêu chuẩn.

### Tính Năng Giao Diện (UI)

* **Dark Mode Chuẩn:** Thiết kế giao diện tối với tông màu xám đậm và đen, mô phỏng chính xác hình ảnh mẫu.
* **Bố cục 4x5:** Sử dụng bố cục lưới `GridView` để đảm bảo các nút được căn chỉnh hoàn hảo.
* **Thiết kế Nút Độc Đáo:**
    * Nút **'C'** (Clear) màu Đỏ Nâu.
    * Các nút Toán tử cơ bản màu Xanh Rêu Đậm.
    * Nút **'='** (Equals) màu Xanh Lá Cây nổi bật.

### Tính Năng Chức Năng (Logic)

* **Các Phép Tính Cơ Bản:** Hỗ trợ Cộng (`+`), Trừ (`-`), Nhân (`×`), Chia (`÷`).
* **Chức năng Xóa:** Nút `C` (Clear) để xóa toàn bộ biểu thức.
* **Chức năng Nâng Cao:** Hỗ trợ tính **Phần trăm** (`%`), **Đổi dấu** (`+/-`), và sử dụng **Dấu ngoặc đơn** (`()`).
