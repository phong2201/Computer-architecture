# Assignment: Convolution Operation  
**Course:** Computer Architecture Lab (CO2008)  
**University:** Ho Chi Minh City University of Technology  
**Faculty:** Computer Science and Engineering  
**Academic Year:** 2024 – 2025  

## 📌 Outcomes

Sau khi hoàn thành bài tập này, sinh viên có thể:

- Thành thạo sử dụng trình giả lập **MARS MIPS**.
- Áp dụng được các lệnh **số học**, **truyền dữ liệu**, **rẽ nhánh có điều kiện** và **nhảy không điều kiện**.
- Viết và sử dụng **procedures** trong MIPS Assembly.

---

## 🧠 Introduction

Trong thời đại hiện nay, **trí tuệ nhân tạo (AI)**, đặc biệt là **machine learning** và **deep learning**, đang phát triển mạnh mẽ, yêu cầu lượng lớn tính toán. Một trong những thành phần quan trọng nhất của deep learning là **Convolutional Neural Network (CNN)**.

CNN sử dụng **phép tích chập (convolution)** để phát hiện các đặc trưng trong ảnh như biên, hoa văn, v.v... Phép tích chập là quá trình trượt một **ma trận nhỏ (kernel)** trên toàn bộ **ma trận ảnh (image)** và tính toán **dot product** tại từng vị trí.

### Ví dụ tích chập:

<img src="https://github.com/phong2201/Computer-architecture/blob/main/image/b.png" alt="Convolution Example" width="400"/>

*(Hình ảnh minh họa: Tích chập với ma trận 5x5 và kernel 2x2)*

Một vấn đề trong quá trình tích chập là mất dữ liệu ở biên ma trận. Để khắc phục, ta thêm **padding** – thường là giá trị 0 – vào xung quanh ảnh:

### Ví dụ padding:

<img src="https://github.com/phong2201/Computer-architecture/blob/main/image/a.png" alt="Zero Padding" width="250"/>

*(Hình ảnh minh họa: Padding 1 vào ma trận 3x3 thành 5x5)*

---

## ✅ Requirements

### 3.1 Input

- Tên file: `input matrix.txt`  
- Dữ liệu gồm 3 dòng:
  1. **4 giá trị**:  
     - `N`: Kích thước ảnh đầu vào (3 ≤ N ≤ 7)  
     - `M`: Kích thước kernel (2 ≤ M ≤ 4)  
     - `p`: Padding (0 ≤ p ≤ 4)  
     - `s`: Stride (1 ≤ s ≤ 3)  
  2. Dòng thứ 2: Ma trận ảnh (N×N)  
  3. Dòng thứ 3: Ma trận kernel (M×M)

> Lưu ý: Tất cả số đều là **float** có 1 chữ số sau dấu thập phân.

### 3.2 Output

- Tên file: `output matrix.txt`
- Nội dung là **ma trận kết quả sau tích chập**, cách nhau bằng dấu cách.
- Nếu kernel không vừa với ảnh sau padding:  

Error: size not match


### 3.3 Pre-defined Variables

Bạn **phải khai báo** các biến trong MIPS như sau:

- `image`: chứa ma trận ảnh
- `kernel`: chứa ma trận kernel
- `out`: chứa ma trận đầu ra

### 3.4 Test Cases

- File bài tập đi kèm có các test case mẫu.
- Kết quả không được cung cấp => cần viết chương trình kiểm thử phụ (ví dụ bằng Python, C...).

### 3.5 Report

- Báo cáo cần bao gồm:
- Tên, MSSV, lớp, môn học.
- Ảnh test run, mô tả logic, biểu đồ hoặc flowchart.
- **Không chèn code vào báo cáo**. Trình bày thuật toán và ý tưởng thực hiện.

---

## 📤 Submission

- Nộp file `.asm` và báo cáo qua hệ thống **BK E-learning (LMS)** sau buổi lab cuối.
- Làm bài **cá nhân**.
- **Không nộp đúng hạn = 0 điểm**.

---

## ⚠️ Plagiarism Policy

- Mã nguồn tương tự >30% giữa các sinh viên = 0 điểm.
- Hệ thống kiểm tra đạo văn: [MOSS](https://theory.stanford.edu/~aiken/moss/)

---

## 🧮 Evaluation Rubric

- Điểm dựa trên số lượng test case đúng.
- Không nộp hoặc nộp thiếu code/báo cáo = **0 điểm**.

---


