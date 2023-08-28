define i32 @main() #0 {
%1 = alloca i32, align 4
%2 = alloca i32, align 4
%3 = alloca i32, align 4
store i32 0, i32* %1, align 4
store i32 6, i32* %2, align 4
store i32 7, i32* %3, align 4
%4 = load i32, i32* %2, align 4
%5 = load i32, i32* %3, align 4
%6 = icmp sgt i32 %4, %5
br i1 %6, label %11, label %7
1

; <label>:7: ; preds = %0
%8 = load i32, i32* %3, align 4
%9 = load i32, i32* %2, align 4
%10 = icmp sgt i32 %8, %9
br i1 %10, label %11, label %14
; <label>:11: ; preds = %7, %0
%12 = load i32, i32* %2, align 4
%13 = add nsw i32 %12, 1
store i32 %13, i32* %2, align 4
br label %17
; <label>:14: ; preds = %7
%15 = load i32, i32* %2, align 4
%16 = sub nsw i32 %15, 1
store i32 %16, i32* %2, align 4
br label %17
; <label>:17: ; preds = %14, %11
%18 = load i32, i32* %2, align 4
%19 = add nsw i32 %18, 5
store i32 %19, i32* %2, align 4
%20 = load i32, i32* %1, align 4
ret i32 %20
}