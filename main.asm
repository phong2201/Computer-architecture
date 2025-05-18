.data
inputfile: .asciiz "input_matrix.txt"  
out: .asciiz "output_matrix.txt" 
data: .space 1024   
err : .asciiz " \n Error: size not match "                      
error_msg: .asciiz "Error: Could not open file.\n"  # Thông báo lỗi
neg_one:  .float -1.0   
matrix_img : .asciiz "\n  -> Matrix image :\n"
kernel : .asciiz "\n  -> Matrix kernal :\n"
image: .asciiz "\n  -> Matrix image_padding :\n"
c_100 :.float 100
result: .space 200
c_05: .float 0.5
N: .word -1                              
M: .word -1                              
p: .word -1                               
s: .word -1   
N_P: .word -1  
size: .word -1    
img : .word 0:49                     
img_pad : .word 0:225
kernal : .word 0:16
output: .word 0:196
space: .asciiz "   " 
newline: .asciiz"\n"  
c_0 : .float 0                
c_10 : .float 10
c_01 : .float 0.1
c_1 : .float 1
.text
main:
    # Bước 1: Mở file đầu vào
    li $v0, 13                   
    la $a0, inputfile            
    li $a1, 0                     # Chế độ đọc
    li $a2, 0                    
    syscall
    move $s0, $v0              
    blt $s0, 0, error          

    # Bước 2: Đọc 
    li $v0, 14                 
    move $a0, $s0               
    la $a1, data                  # Địa chỉ để lưu dữ liệu
    li $a2, 1024                  # Số byte để đọc
    syscall

    # Bước 3: Đóng 
    li $v0, 16                  
    move $a0, $s0               
    syscall

    # Bước 4: Xử lý 
    la $t0, data                  # Địa chỉ bắt đầu của bộ đệm
    li $t3, 0                     # Bộ đếm cho các biến N, M, p, s
    li $t4, 0                     
    li $t8, 0                     

convert_loop:
    lb $t1, 0($t0)               
    beq $t1, 0x0A, newline_check  
    # Bỏ qua khoảng trắng trong dữ liệu     
    beq $t1, 32, skip_space
    beq $t1, 13, store_d
    
    # Chuyển ký tự ASCII sang số nguyên
    sub $t1, $t1, 48           
	
    # Tích lũy số nhiều chữ số trong $t4
    mul $t4, $t4, 10              
    add $t4, $t4, $t1             

    # Kiểm tra nếu ký tự tiếp theo là khoảng trắng hoặc xuống dòng (kết thúc số)
    lb $t5, 1($t0)                # Xem ký tự tiếp theo
    li $t6, 32                    
    li $t7, 0x0A                  # Mã ASCII cho xuống dòng
    beq $t5, $t6, store_d 
    beq $t5, 46, skip_f

skip_space:
    addi $t0, $t0, 1            
    j  convert_loop             

skip_f:
    addi $t0 , $t0 , 3
    j store_d 
    
store_d:
    beq $t3, 0, check_N           
    beq $t3, 1, check_M         
    beq $t3, 2, check_p          
    beq $t3, 3, check_s           

check_N:
    lw $t9, N                     # Tải giá trị hiện tại của N
    bne $t9, -1, skip_assignment  # Nếu N đã được gán, bỏ qua
    blt $t4, 3 , er_value
    bgt $t4, 7 , er_value
    sw $t4, N                     # Gán giá trị vào N
    j increment_counter

check_M:
    lw $t9, M                     # Tải giá trị hiện tại của M
    bne $t9, -1, skip_assignment  # Nếu M đã được gán, bỏ qua
    blt $t4, 2 , er_value
    bgt $t4, 4 , er_value
    sw $t4, M                     # Gán giá trị vào M
    j increment_counter

check_p:
    lw $t9, p                     # Tải giá trị hiện tại của p
    bne $t9, -1, skip_assignment  # Nếu p đã được gán, bỏ qua
    blt $t4, 0 , er_value
    bgt $t4, 4 , er_value
    sw $t4, p                     # Gán giá trị vào p
    
    j increment_counter

check_s:
    lw $t9, s                     # Tải giá trị hiện tại của s
    bne $t9, -1, skip_assignment  # Nếu s đã được gán, bỏ qua
    blt $t4, 1 , er_value
    bgt $t4, 3 , er_value
    lw $a0 , N
    lw $a1 , M
    lw $a2 , p
    add $a0, $a0 , $a2
    add $a0, $a0 , $a2
    sub $a0, $a0 , $a1    
    blt $a0, 0 , er_value
    sw $t4, s                     # Gán giá trị vào s

increment_counter:
    li $t4, 0                     # Đặt lại bộ tích lũy cho số tiếp theo
    addi $t3, $t3, 1             
skip_assignment:
    j skip_space

newline_check:
    addi $t8, $t8, 1              # Tăng bộ đếm cho ký tự xuống dòng
    beq  $t8, 1 ,check_valid_convolution
cal:
    addi $t0 , $t0 , 1
    beq $t8, 1, ig          # Nếu chưa đủ 3 lần xuống dòng, tiếp tục
    beq $t8, 2, ker
    j check_valid_convolution     # Nếu đủ 3 lần, kết thúc xử lý

# Hằng số lưu trong bộ nhớ
check_valid_convolution:
    li $v0 , 4
    la $a0, newline
    syscall 
    
    
    li $v0, 1                   
    lw $a0, N                     
    move $t4 , $a0
    syscall
    
    mul $t4, $t4, $t4
    
    li $v0, 4                
    la $a0, space
    syscall

    li $v0, 1                 
    lw $a0, M                 
    move $t2 , $a0
    syscall

    mul $t2, $t2, $t2
    
    li $v0, 4                  
    la $a0, space
    syscall

    li $v0, 1                     
    lw $a0, p                   
    move $t2 , $a0
    syscall
      
    li $v0, 4                 
    la $a0, space
    syscall

    li $v0, 1                     
    lw $a0, s                 
    move $t2 , $a0
    syscall
    
    li $v0, 4                  
    la $a0, newline
    syscall        

    j cal


ig:   
    la $t3, img               # Đặt con trỏ vào đầu mảng để lưu kết quả

    # Chuyển đổi và lưu từng chuỗi float vào mảng
    jal convert_and_store         # Chuyển đổi và lưu vào mảng
   
    # In các giá trị trong mảng
    la $t3, img 
      
    lw $a0, N                     
    move $t2 , $a0
        
    li $v0, 4
    la $a0, matrix_img
    syscall
    
    li $v0 , 4
    la $a0, newline
    syscall 
    
    j print_array

ker:
    li $v0, 4
    la $a0, newline
    syscall
    
    la $t3, kernal                # Đặt con trỏ vào đầu mảng để lưu kết quả
    addi $t0, $t0, 2
    
    lw $a0, M                    
    move $t4 , $a0
    mul $t4, $t4, $t4
    # Chuyển đổi và lưu từng chuỗi float vào mảng
    jal convert_and_store         # Chuyển đổi và lưu vào mảng
   
    # In các giá trị trong mảng
    la $t3, kernal 
    
    lw $a0, M                   
    move $t2 , $a0      
    li $v0, 4
    la $a0, kernel
    syscall
    
    li $v0 , 4
    la $a0, newline
    syscall 
    
    j print_array

print_array:
    lwc1 $f12, 0($t3)             
    li $v0, 2                    
    syscall
    
    # In dấu xuống dòng sau mỗi giá trị
    li $v0, 4                    
    la $a0, space
    syscall

    addi $t3, $t3, 4             
    subi $t4, $t4, 1              # Giảm số đếm phần tử
    div  $t4, $t2
    mfhi $t5
    beqz $t5, new_l
comeback:
    bgtz $t4, print_array         # Lặp lại nếu còn phần tử
 
    beq $t8, 2, ker
    j pad

# Hàm chuyển đổi chuỗi float và lưu vào mảng
convert_and_store:
    li $t5, 1                    
    li $t2, 0                    # Cờ đánh dấu số âm (0: dương, 1: âm)

    # Khởi tạo các thanh ghi tích lũy
    l.s $f4, c_10                # Tải hằng số 10.0 vào $f4
    mtc1 $zero, $f0            
    cvt.s.w $f0, $f0             # Chuyển $f0 thành số thực
    li $t6, 0                   
    li $t7, 0                   

float_convert_loop:
    
    lb $t1, 0($t0)               # Tải từng ký tự từ chuỗi
    beq $t1, 13, save_number      # Kết thúc nếu gặp null 
    beq $t1, 0, save_number
               # ASCII ' ' (dấu cách) là 32
    beq $t1, 32, save_number    

                  # ASCII '-' là 45
    beq $t1, 45, set_negative_flag

                # ASCII '.' là 46
    beq $t1, 46, switch_to_fraction
                 # ASCII '0' là 48
    sub $t1, $t1, 48        
    beq $t5, 1, accumulate_integer_part

accumulate_fraction_part:
    mul $t7, $t7, 10
    add $t7, $t7, $t1
    addi $t6, $t6, 1
    addi $t0, $t0, 1
    j float_convert_loop

accumulate_integer_part:
    mtc1 $t1, $f1
    cvt.s.w $f1, $f1
    mul.s $f0, $f0, $f4
    add.s $f0, $f0, $f1
    addi $t0, $t0, 1
    j float_convert_loop

switch_to_fraction:
    li $t5, 0
    addi $t0, $t0, 1
    j float_convert_loop

set_negative_flag:
    li $t2, 1                    # Đặt cờ âm
    addi $t0, $t0, 1             # Bỏ qua dấu '-' để đọc số tiếp theo
    j float_convert_loop

save_number:
    # Xử lý phần thập phân nếu có
    mtc1 $t7, $f1
    cvt.s.w $f1, $f1
    li $t9, 1
    li $a0, 0

fraction_division:
    bge $a0, $t6, apply_fraction
    mul $t9, $t9, 10
    addi $a0, $a0, 1

    j fraction_division

apply_fraction:
    mtc1 $t9, $f3
    cvt.s.w $f3, $f3
    div.s $f1, $f1, $f3
    add.s $f0, $f0, $f1

    # Nếu cờ âm được bật, nhân kết quả với -1
    beq $t2, 0, store_result    # Nếu không phải số âm, bỏ qua
    l.s $f2, neg_one            # Lấy giá trị -1.0 từ bộ nhớ
    mul.s $f0, $f0, $f2         # Nhân với -1.0

store_result:
    # Lưu giá trị float vào vị trí mảng hiện tại
    swc1 $f0, 0($t3)            # Lưu giá trị float vào vị trí hiện tại của $t3
    addiu $t3, $t3, 4           # Tăng con trỏ mảng
    # Reset thanh ghi cho số tiếp theo
    li $t5, 1
    mtc1 $zero, $f0
    cvt.s.w $f0, $f0
    li $t7, 0
    li $t6, 0
    li $t2, 0                   # Reset cờ âm
    beq $t1, 13, finish_conversion
    beq $t1, 0, finish_conversion
    addi $t0, $t0, 1
    
    j float_convert_loop

finish_conversion:
    addi $t8, $t8, 1
    jr $ra
    
new_l:
    li $v0, 4 
    la $a0, newline
    syscall
    
    j comeback
    
pad:
        # Load kích thước ma trận gốc và padding
    la $t0, N         
    lw $t1, 0($t0)    
    la $t0, p         
    lw $t2, 0($t0)    

    # Tính kích thước mới của ma trận (n + 2P)
    add $t3, $t1, $t2    
    move $s0, $t3
    add $t3, $t3, $t2    
    sw $t3, N_P
    
    # Đặt các địa chỉ
    la $a0, img            
    la $a1, img_pad         

    # Vòng lặp: Tạo ma trận Ms (kể cả padding)
    li $t4, 0          
outer_loop:
    bge $t4, $t3, print_matrix    

    li $t5, 0           
inner_loop:
    bge $t5, $t3, next_row  
    # Xử lý giá trị padding trên/trái
    blt $t4, $t2, set_padding   
    blt $t5, $t2, set_padding   
    bge $t4, $s0, set_padding   
    bge $t5, $s0, set_padding   

    # Sao chép giá trị từ ma trận gốc
    sub $t6, $t4, $t2     
    sub $t7, $t5, $t2      
    mul $t8, $t6, $t1       
    add $t8, $t8, $t7       # Offset cột: (i - P) * N + (j - P)
    mul $t8, $t8, 4         
    add $t9, $a0, $t8       # Địa chỉ phần tử trong ma trận gốc

    lwc1 $f0, 0($t9)        # Lấy giá trị từ M
    swc1 $f0, 0($a1)        # Lưu giá trị vào Ms
    addi $a1, $a1, 4        
    addi $t5, $t5, 1        
    j inner_loop

set_padding:
    lwc1 $f0, c_0   
    swc1 $f0, 0($a1)  
    addi $a1, $a1, 4   
    addi $t5, $t5, 1   
    j inner_loop

next_row:
    addi $t4, $t4, 1   # Tăng dòng
    j outer_loop

# In ma trận Ms
print_matrix:
    la $a1, img_pad         # Đặt lại con trỏ Ms
    li $t4, 0          # i = 0 (dòng)
    
    li $v0, 4
    la $a0, image
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
print_outer_loop:
    bge $t4, $t3, proceduce  

    li $t5, 0         
print_inner_loop:
    bge $t5, $t3, print_newline   

    lwc1 $f0, 0($a1)   # Lấy giá trị float từ Ms
    mov.s $f12, $f0   
    li $v0, 2          
    syscall

    # In khoảng trắng giữa các số
    li $v0, 4         
    la $a0, space      
    syscall

    addi $a1, $a1, 4   # Di chuyển con trỏ Ms
    addi $t5, $t5, 1   
    j print_inner_loop

print_newline:
    # Xuống dòng sau khi in xong một hàng
    li $v0, 4          
    la $a0, newline    
    syscall

    addi $t4, $t4, 1   
    j print_outer_loop

proceduce:
    # Load kích thước và stride
    lw $t0, N_P   # m: Kích thước ma trận gốc
    
    lw $t1, M   # k: Kích thước kernel
    lw $t2, s       # stride

    # Tính kích thước kết quả
    sub $t3, $t0, $t1
    div $t3, $t3, $t2
    add $t3, $t3, 1
    move $s7, $t3         # s7 = kích thước hàng/cột của kết quả
    sw $s7, size
    
    # Địa chỉ ma trận
    la $s0, img_pad
    la $s1, kernal
    la $s2, output

    # Vòng lặp qua từng hàng của kết quả
    li $s3, 0
rows_loop:
    mul $t4, $s3, $t2
    add $t5, $t4, $t1
    bgt $t5, $t0, print_result

    li $s4, 0
cols_loop:
    la $s1 , kernal
    mul $t6, $s4, $t2
    add $t7, $t6, $t1
    bgt $t7, $t0, next_row1

    # Tính toán tích chập
    mov.s $f8, $f0       # Reset tổng tạm thời về 0.0
    li $t3 , 0
    mul $s5, $t2, $s3
kernel_rows_loop:
    bge $t3, $t1, kernel_done
    li $s6, 0
kernel_cols_loop:
    bge $s6, $t1, next_kernel_row

    # Lấy giá trị từ ma trận gốc và kernel
    mul $t9, $s5, $t0
    add $t9, $t9, $s6
    add $t9, $t9, $t6
    sll $t9, $t9, 2
    add $t9, $t9, $s0
    lwc1 $f4, 0($t9)      # Lấy phần tử matrix

    
    lwc1 $f5, 0($s1)      # Lấy phần tử kernel
    addiu $s1 , $s1 ,4

    # Nhân và cộng tổng
    mul.s $f6, $f4, $f5
    add.s $f8, $f8, $f6

    addi $s6, $s6, 1
    j kernel_cols_loop

next_kernel_row:
    addi $s5, $s5, 1
    addi $t3, $t3, 1
    j kernel_rows_loop

kernel_done:
    swc1 $f8, 0($s2)
    addiu $s2, $s2, 4

    addi $s4, $s4, 1
    j cols_loop

next_row1:
    addi $s3, $s3, 1
    j rows_loop

# In ma trận kết quả
print_result:
    li $s3, 0
    
    li $v0 , 4
    la $a0 , newline
    syscall
    
    la $s2, output
print_rows:
    bge $s3, $s7, file_opened
    li $s4, 0
print_cols:
    bge $s4, $s7, next_print_row

    lwc1 $f4, 0($s2)
   

    # Làm tròn số thành 1 chữ số thập phân
    l.s $f1, c_10      # Hệ số nhân
    mul.s $f4, $f4, $f1    # Nhân giá trị với 10
    l.s $f22 , c_05
    l.s $f23 , c_0
    c.lt.s $f23 , $f4 
    bc1t nex
    sub.s $f4, $f4, $f22
    j con
nex:
    add.s $f4 , $f4 , $f22 
    j con

con:
   trunc.w.s $f6, $f4    
    cvt.s.w $f4, $f6       # Chuyển đổi lại thành số thực
    div.s $f4, $f4, $f1    # Chia ngược lại cho 10 để có 1 chữ số thập phân
 
    swc1 $f4, 0($s2)
    addiu $s2, $s2, 4
    # In giá trị
    li $v0, 2              # syscall: print_float
    mov.s $f12, $f4
    syscall

    li $v0, 4
    la $a0, space
    syscall

    addi $s4, $s4, 1
    j print_cols
next_print_row:

    addi $s3, $s3, 1
    j print_rows

file_opened:
    li $v0, 13                                  
    la $a0, out                              
    li $a1, 1                                  
    li $a2, 0                                    
    syscall
    move $s1, $v0                               
    bgtz $s1, main1                               # Nếu mở file thành công, chuyển đến main1
    j exit                               # Nếu thất bại, thoát chương trình

main1:
    # Load địa chỉ của mảng float vào $t0 và kích thước mảng vào $t7
    la $t0, output
    lw $t7, size                          # Số phần tử của mảng
    mul $t7, $t7, $t7
    li $t8, 0                                    # Chỉ số hiện tại trong mảng

array_loop:
    beq $t8, $t7, close_file                     # Nếu đã duyệt hết mảng, đóng file

    # Load phần tử thứ $t8 của mảng float vào $f12
    mul $t9, $t8, 4                            
    add $t1, $t0, $t9                            
    lwc1 $f12, 0($t1)                           

    # Nhân float với 100.0
    l.s $f2, c_100                              
    mul.s $f12, $f12, $f2                        
    round.w.s $f0, $f12                          
    mfc1 $t1, $f0                                
    
    # Kiểm tra dấu âm và ghi trực tiếp vào chuỗi
    la $a0, result                               # Đảm bảo $a0 trỏ đến vùng nhớ result
    bltz $t1, handle_negative                    # Nếu số âm, xử lý số âm

handle_positive:
    j process_integer_part                       # Xử lý phần nguyên nếu số dương

handle_negative:
    li $t5, 45                                
    sb $t5, 0($a0)                             
    addiu $a0, $a0, 1                            
    negu $t1, $t1                                
    j process_integer_part

process_integer_part:
    # Tách phần nguyên và phần thập phân
    div $t2, $t1, 100                            # Lấy phần nguyên
    mflo $t2                                     # Lưu kết quả phần nguyên
    mul $t4, $t2, 100                            # Phần nguyên nhân lại 100
    sub $t3, $t1, $t4                            # Phần thập phân: t3 = t1 - (phần nguyên * 100)
    
    
    j write_integer_part                        

write_integer_part:
    # Nếu phần nguyên là 0, ghi trực tiếp '0'
    beqz $t2, write_zero_integer
    li $t6, 1                                    # Biến dùng để xác định chữ số có giá trị

check_integer_digits:
    div $t5, $t2, $t6                            # Kiểm tra bậc của chữ số
    bnez $t5, next_digit                         # Nếu còn chữ số, tiếp tục
    j write_integer_digits                       # Nếu hết, ghi phần nguyên

next_digit:
    mul $t6, $t6, 10                             
    j check_integer_digits

write_integer_digits:
    div $t6, $t6, 10                            

write_digit:
    div $t5, $t2, $t6                            
    mflo $t5
    addi $t5, $t5, 48                            
    sb $t5, 0($a0)                               # Lưu vào chuỗi
    addiu $a0, $a0, 1                            # Dịch con trỏ chuỗi
    rem $t2, $t2, $t6                          
    div $t6, $t6, 10                             # Lùi về bậc tiếp theo
    bnez $t6, write_digit                        # Tiếp tục nếu còn chữ số
    j write_decimal_part                         

write_zero_integer:
    li $t5, 48                                   # ASCII của '0'
    sb $t5, 0($a0)                              
    addiu $a0, $a0, 1                            # Dịch con trỏ chuỗi
    j write_decimal_part                         # Chuyển sang xử lý phần thập phân

write_decimal_part:
    # Thêm dấu '.' sau phần nguyên
    li $t5, 46                                   # Dấu '.'
    sb $t5, 0($a0)                               
    addiu $a0, $a0, 1                            # Dịch con trỏ chuỗi

    # Nếu phần thập phân là 0, ghi trực tiếp '0'
    beqz $t3, write_zero_decimal

    # Xử lý phần thập phân
    div $t3, $t3, 10                             # Lấy chữ số đầu tiên sau dấu '.'
    mflo $t5                                     # Lưu kết quả vào $t5
    addi $t5, $t5, 48                            
    sb $t5, 0($a0)                               
    addiu $a0, $a0, 1                            # Dịch con trỏ chuỗi
    j end_write_result                        

write_zero_decimal:
    li $t5, 48                                   # ASCII của '0'
    sb $t5, 0($a0)                              
    addiu $a0, $a0, 1                            # Dịch con trỏ chuỗi

end_write_result:
    # Kết thúc chuỗi
    li $t6, 0                                   
    sb $t6, 0($a0)                             
    j count_bytes                                

count_bytes:
    la $t9, result                            
    li $t5, 0                                   

count_loop:
    lb $t6, 0($t9)                               
    beqz $t6, write_to_file                     
    addiu $t9, $t9, 1                            
    addiu $t5, $t5, 1                           
    j count_loop                                

write_to_file:
    # Ghi chuỗi vào file
    li $v0, 15                                   # Syscall 15: ghi file
    move $a0, $s1                               
    la $a1, result                             
    move $a2, $t5                               
    syscall

    addi $a0 , $t8 , 1
    beq $a0, $t7 , close_file 
    # Ghi xuống dòng vào file
    li $v0, 15                                   
    move $a0, $s1                                
    la $a1, space                           
    li $a2, 1                                
    syscall

    # Tăng chỉ số mảng và lặp lại
    addiu $t8, $t8, 1
    j array_loop

close_file:
    # Đóng file
    li $v0, 16                                   # Syscall 16: đóng file
    move $a0, $s1
    syscall

    j exit
error:
    li $v0, 4              
    la $a0, error_msg          
    syscall
    j exit
    
er_value:
    li $v0, 4              
    la $a0, err         
    syscall
    
    li   $v0, 13
    la   $a0, out
    li   $a1, 1
    li   $a2, 0
    syscall
    move $s1, $v0
    bgtz $s1, proceed
    j exit

proceed:
    li $v0, 9
    li $a0, 73
    syscall
    move $s0, $v0

    li $v0, 15
    move $a0, $s1
    la $a1, err
    li $a2, 24
    syscall
    

    li $v0, 16
    move $a0, $s1
    syscall


exit:
    li $v0, 10                   
    syscall
    
    
    
    
