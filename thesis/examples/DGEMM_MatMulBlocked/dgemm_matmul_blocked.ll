declare i64 @__hipsycl_sscp_get_group_id_x() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_local_size_x() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_local_id_x() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_num_groups_x() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_group_id_y() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_local_size_y() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_local_id_y() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_num_groups_y() local_unnamed_addr


declare ptr addrspace(3) @__hipsycl_sscp_get_dynamic_local_memory() local_unnamed_addr


define  void @DGEMM_MatMulBlocked(i64 %Awrk_236459, i64 %_236958, i64 %_236963, [256 x [256 x double]]* %a_236820, [0 x double]* %_236973, i64 %_236978, i64 %_236983, i64 %Bwrk_236535, i64 %_236993, i64 %_236998, [256 x [256 x double]]* %b_236865, [0 x double]* %_237008, i64 %_237013, i64 %_237018, [256 x [256 x double]]* %c_236689, [0 x double]* %_237028, i64 %_237033, i64 %_237038) {
DGEMM_MatMulBlocked_236144:
    %_236503 = tail call i64 @__hipsycl_sscp_get_local_id_y()
    %_236504 = trunc i64 %_236503 to i8
    %_236710 = tail call i64 @__hipsycl_sscp_get_group_id_y()
    %_236822 = trunc i64 %_236710 to i8
    %_236827 = mul nuw nsw i8 16, %_236822
    %_236832 = add nuw nsw i8 %_236504, %_236827
    %_236838.zext = zext i8 %_236832 to i9 ; add one more bit for gep index as it is treated as signed value
    %_236838 = getelementptr inbounds [256 x [256 x double]], [256 x [256 x double]]* %a_236820, i64 0, i9 %_236838.zext
    %_236551 = tail call i64 @__hipsycl_sscp_get_local_id_x()
    %_236552 = trunc i64 %_236551 to i8
    %_236731 = tail call i64 @__hipsycl_sscp_get_group_id_x()
    %_236877 = trunc i64 %_236731 to i8
    %_236882 = mul nuw nsw i8 16, %_236877
    %_236887 = add nuw nsw i8 %_236552, %_236882
    %_236456 = tail call ptr addrspace(3) @__hipsycl_sscp_get_dynamic_local_memory()
    %_236468.cast = addrspacecast ptr addrspace(3) %_236456 to ptr
    %_236468 = getelementptr inbounds [0 x i8], [0 x i8]* %_236468.cast, i64 0, i64 %Awrk_236459
    %_236471 = bitcast [0 x i8]* %_236468 to [0 x double]*
    %_236509 = mul nsw i8 16, %_236504
    %_236906 = add nsw i8 %_236509, %_236552
    %_236916.zext = zext i8 %_236906 to i9 ; add one more bit for gep index as it is treated as signed value
    %_236916 = getelementptr inbounds [0 x double], [0 x double]* %_236471, i64 0, i9 %_236916.zext
    %_236544.cast = addrspacecast ptr addrspace(3) %_236456 to ptr
    %_236544 = getelementptr inbounds [0 x i8], [0 x i8]* %_236544.cast, i64 0, i64 %Bwrk_236535
    %_236547 = bitcast [0 x i8]* %_236544 to [0 x double]*
    %_236934.zext = zext i8 %_236906 to i9 ; add one more bit for gep index as it is treated as signed value
    %_236934 = getelementptr inbounds [0 x double], [0 x double]* %_236547, i64 0, i9 %_236934.zext
    %_236712 = tail call i64 @__hipsycl_sscp_get_local_size_y()
    %_236717 = mul nsw i64 %_236710, %_236712
    %_236722 = add nsw i64 %_236503, %_236717
    %_236723 = trunc i64 %_236722 to i8
    %_236729.zext = zext i8 %_236723 to i9 ; add one more bit for gep index as it is treated as signed value
    %_236729 = getelementptr inbounds [256 x [256 x double]], [256 x [256 x double]]* %c_236689, i64 0, i9 %_236729.zext
    %_236733 = tail call i64 @__hipsycl_sscp_get_local_size_x()
    %_236738 = mul nsw i64 %_236731, %_236733
    %_236743 = add nsw i64 %_236551, %_236738
    %_236744 = trunc i64 %_236743 to i8
    %_236750.zext = zext i8 %_236744 to i9 ; add one more bit for gep index as it is treated as signed value
    %_236750 = getelementptr inbounds [256 x double], [256 x double]* %_236729, i64 0, i9 %_236750.zext
    br label %head_236151

head_236151:
    %Kblk_236165 = phi i8 [ 0, %DGEMM_MatMulBlocked_236144 ], [ %_236218, %new_exit_236196 ]
    %_236171 = icmp ult i8 %Kblk_236165, 16
    br i1 %_236171, label %new_body_236186, label %new_exit_236173

new_exit_236173:
    br label %return_236174

return_236174:
    ret void

new_body_236186:
    %_236843 = mul nuw nsw i8 16, %Kblk_236165
    %_236848 = add nuw nsw i8 %_236552, %_236843
    %_236854.zext = zext i8 %_236848 to i9 ; add one more bit for gep index as it is treated as signed value
    %_236854 = getelementptr inbounds [256 x double], [256 x double]* %_236838, i64 0, i9 %_236854.zext
    %_236860 = load double, double* %_236854
    %_236870 = add nuw nsw i8 %_236504, %_236843
    %_236876.zext = zext i8 %_236870 to i9 ; add one more bit for gep index as it is treated as signed value
    %_236876 = getelementptr inbounds [256 x [256 x double]], [256 x [256 x double]]* %b_236865, i64 0, i9 %_236876.zext
    %_236893.zext = zext i8 %_236887 to i9 ; add one more bit for gep index as it is treated as signed value
    %_236893 = getelementptr inbounds [256 x double], [256 x double]* %_236876, i64 0, i9 %_236893.zext
    %_236899 = load double, double* %_236893
    store double %_236860, double* %_236916
    store double %_236899, double* %_236934
    br label %head_236187

head_236187:
    %kloc_236190 = phi i8 [ 0, %new_body_236186 ], [ %_236228, %new_body_236223 ]
    %_236195 = icmp ult i8 %kloc_236190, 16
    br i1 %_236195, label %new_body_236223, label %new_exit_236196

new_exit_236196:
    %_236218 = add nuw nsw i8 1, %Kblk_236165
    br label %head_236151

new_body_236223:
    %_236228 = add nuw nsw i8 1, %kloc_236190
    %_236514 = add nsw i8 %kloc_236190, %_236509
    %_236524.zext = zext i8 %_236514 to i9 ; add one more bit for gep index as it is treated as signed value
    %_236524 = getelementptr inbounds [0 x double], [0 x double]* %_236471, i64 0, i9 %_236524.zext
    %_236530 = load double, double* %_236524
    %_236557 = mul nsw i8 16, %kloc_236190
    %_236562 = add nsw i8 %_236552, %_236557
    %_236572.zext = zext i8 %_236562 to i9 ; add one more bit for gep index as it is treated as signed value
    %_236572 = getelementptr inbounds [0 x double], [0 x double]* %_236547, i64 0, i9 %_236572.zext
    %_236578 = load double, double* %_236572
    %_236756 = load double, double* %_236750
    %_236800 = fmul double %_236530, %_236578
    %_236805 = fadd double %_236756, %_236800
    store double %_236805, double* %_236750
    br label %head_236187

}


