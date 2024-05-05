declare i64 @__hipsycl_sscp_get_group_id_x() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_local_size_x() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_local_id_x() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_num_groups_x() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_group_id_y() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_local_size_y() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_local_id_y() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_num_groups_y() local_unnamed_addr


declare void @__hipsycl_sscp_work_group_barrier(i32 noundef, i32 noundef) local_unnamed_addr


define  void @MatrixAddMultiplyKernel_with_intermediate(i32 %_224054, [256 x [256 x double]]* %A_223701, [0 x i32]* %_224064, i32 %_224069, i64 %_224074, [256 x [256 x double]]* %B_223726, [0 x i32]* %_224084, i32 %_224089, i64 %_224094, [256 x [256 x double]]* %C_223562, [0 x i32]* %_224104, i32 %_224109, i64 %_224114, [256 x [256 x double]]* %I_223801, [0 x i32]* %_224124, i32 %_224129, i64 %_224134, [256 x [256 x double]]* %R_223660, [0 x i32]* %_224144, i32 %_224149, i64 %_224154) {
MatrixAddMultiplyKernel_with_intermediate_223164:
    %_223653 = tail call i64 @__hipsycl_sscp_get_local_id_y()
    %_223654 = trunc i64 %_223653 to i32
    %_223642 = tail call i64 @__hipsycl_sscp_get_local_id_x()
    %_223643 = trunc i64 %_223642 to i32
    %_223269 = tail call i64 @__hipsycl_sscp_get_local_size_y()
    %_223270 = trunc i64 %_223269 to i32
    %_223309 = tail call i64 @__hipsycl_sscp_get_local_size_x()
    %_223310 = trunc i64 %_223309 to i32
    br label %head_223171

head_223171:
    %Inter_223538 = phi [256 x [256 x double]]* [ %I_223801, %MatrixAddMultiplyKernel_with_intermediate_223164 ], [ %_223682, %new_exit_223673 ]
    %_223184 = phi i32 [ %_223654, %MatrixAddMultiplyKernel_with_intermediate_223164 ], [ %_223678, %new_exit_223673 ]
    %_223190 = icmp ult i32 %_223184, 256
    br i1 %_223190, label %new_body_223663, label %new_exit_223192

new_body_223663:
    %_223702 = trunc i32 %_223184 to i8
    %_223708.zext = zext i8 %_223702 to i9 ; add one more bit for gep index as it is treated as signed value
    %_223708 = getelementptr inbounds [256 x [256 x double]], [256 x [256 x double]]* %A_223701, i64 0, i9 %_223708.zext
    %_223732.zext = zext i8 %_223702 to i9 ; add one more bit for gep index as it is treated as signed value
    %_223732 = getelementptr inbounds [256 x [256 x double]], [256 x [256 x double]]* %B_223726, i64 0, i9 %_223732.zext
    br label %head_223664

head_223664:
    %_223682 = phi [256 x [256 x double]]* [ %Inter_223538, %new_body_223663 ], [ %_223696, %new_yield_223686 ]
    %_223667 = phi i32 [ %_223643, %new_body_223663 ], [ %_223691, %new_yield_223686 ]
    %_223672 = icmp ult i32 %_223667, 256
    br i1 %_223672, label %new_body_223685, label %new_exit_223673

new_exit_223673:
    %_223678 = add nuw nsw i32 %_223184, %_223270
    br label %head_223171

new_body_223685:
    %_223709 = trunc i32 %_223667 to i8
    %_223715.zext = zext i8 %_223709 to i9 ; add one more bit for gep index as it is treated as signed value
    %_223715 = getelementptr inbounds [256 x double], [256 x double]* %_223708, i64 0, i9 %_223715.zext
    %_223721 = load double, double* %_223715
    %_223738.zext = zext i8 %_223709 to i9 ; add one more bit for gep index as it is treated as signed value
    %_223738 = getelementptr inbounds [256 x double], [256 x double]* %_223732, i64 0, i9 %_223738.zext
    %_223744 = load double, double* %_223738
    %_223752.zext = zext i8 %_223702 to i9 ; add one more bit for gep index as it is treated as signed value
    %_223752 = getelementptr inbounds [256 x [256 x double]], [256 x [256 x double]]* %_223682, i64 0, i9 %_223752.zext
    %_223758.zext = zext i8 %_223709 to i9 ; add one more bit for gep index as it is treated as signed value
    %_223758 = getelementptr inbounds [256 x double], [256 x double]* %_223752, i64 0, i9 %_223758.zext
    %_223779 = fadd double %_223721, %_223744
    store double %_223779, double* %_223758
    br label %new_yield_223686

new_yield_223686:
    %_223696 = phi [256 x [256 x double]]* [ %_223682, %new_body_223685 ]
    %_223691 = add nuw nsw i32 %_223310, %_223667
    br label %head_223664

new_exit_223192:
    tail call void @__hipsycl_sscp_work_group_barrier(i32 noundef 3, i32 noundef 4)
    br label %head_223193

head_223193:
    %_223645 = phi [256 x [256 x double]]* [ %R_223660, %new_exit_223192 ], [ %_223279, %new_exit_223224 ]
    %_223196 = phi i32 [ %_223654, %new_exit_223192 ], [ %_223275, %new_exit_223224 ]
    %_223201 = icmp ult i32 %_223196, 256
    br i1 %_223201, label %new_body_223214, label %new_exit_223202

new_exit_223202:
    br label %return_223203

return_223203:
    ret void

new_body_223214:
    %_223474 = trunc i32 %_223196 to i8
    %_223544.zext = zext i8 %_223474 to i9 ; add one more bit for gep index as it is treated as signed value
    %_223544 = getelementptr inbounds [256 x [256 x double]], [256 x [256 x double]]* %Inter_223538, i64 0, i9 %_223544.zext
    br label %head_223215

head_223215:
    %_223218 = phi i32 [ %_223643, %new_body_223214 ], [ %_223315, %new_yield_223305 ]
    %_223279 = phi [256 x [256 x double]]* [ %_223645, %new_body_223214 ], [ %_223320, %new_yield_223305 ]
    %_223223 = icmp ult i32 %_223218, 256
    br i1 %_223223, label %new_body_223282, label %new_exit_223224

new_exit_223224:
    %_223275 = add nuw nsw i32 %_223196, %_223270
    br label %head_223193

new_body_223282:
    %_223481 = trunc i32 %_223218 to i8
    br label %head_223289

head_223289:
    %_223292 = phi i32 [ 0, %new_body_223282 ], [ %_223511, %new_yield_223505 ]
    %acc_223489 = phi double [ 0x0000000000000000, %new_body_223282 ], [ %_223516, %new_yield_223505 ]
    %_223297 = icmp ult i32 %_223292, 256
    br i1 %_223297, label %new_body_223498, label %new_exit_223298

new_exit_223298:
    %_223480.zext = zext i8 %_223474 to i9 ; add one more bit for gep index as it is treated as signed value
    %_223480 = getelementptr inbounds [256 x [256 x double]], [256 x [256 x double]]* %_223279, i64 0, i9 %_223480.zext
    %_223487.zext = zext i8 %_223481 to i9 ; add one more bit for gep index as it is treated as signed value
    %_223487 = getelementptr inbounds [256 x double], [256 x double]* %_223480, i64 0, i9 %_223487.zext
    store double %acc_223489, double* %_223487
    br label %new_yield_223305

new_yield_223305:
    %_223320 = phi [256 x [256 x double]]* [ %_223279, %new_exit_223298 ]
    %_223315 = add nuw nsw i32 %_223218, %_223310
    br label %head_223215

new_body_223498:
    %_223545 = trunc i32 %_223292 to i8
    %_223551.zext = zext i8 %_223545 to i9 ; add one more bit for gep index as it is treated as signed value
    %_223551 = getelementptr inbounds [256 x double], [256 x double]* %_223544, i64 0, i9 %_223551.zext
    %_223557 = load double, double* %_223551
    %_223568.zext = zext i8 %_223545 to i9 ; add one more bit for gep index as it is treated as signed value
    %_223568 = getelementptr inbounds [256 x [256 x double]], [256 x [256 x double]]* %C_223562, i64 0, i9 %_223568.zext
    %_223574.zext = zext i8 %_223481 to i9 ; add one more bit for gep index as it is treated as signed value
    %_223574 = getelementptr inbounds [256 x double], [256 x double]* %_223568, i64 0, i9 %_223574.zext
    %_223580 = load double, double* %_223574
    %_223622 = fmul double %_223557, %_223580
    %_223627 = fadd double %acc_223489, %_223622
    br label %new_yield_223505

new_yield_223505:
    %_223516 = phi double [ %_223627, %new_body_223498 ]
    %_223511 = add nuw nsw i32 1, %_223292
    br label %head_223289

}

define  void @MatrixFusedAddMultiplyKernel(i32 %_224280, [256 x [256 x double]]* %A_223921, [0 x i32]* %_224285, i32 %_224290, i64 %_224295, [256 x [256 x double]]* %B_223945, [0 x i32]* %_224305, i32 %_224310, i64 %_224315, [256 x [256 x double]]* %C_223968, [0 x i32]* %_224325, i32 %_224330, i64 %_224335, [256 x [256 x double]]* %R_224047, [0 x i32]* %_224345, i32 %_224350, i64 %_224355) {
MatrixFusedAddMultiplyKernel_223810:
    %_223653 = tail call i64 @__hipsycl_sscp_get_local_id_y()
    %_223654 = trunc i64 %_223653 to i32
    %_223642 = tail call i64 @__hipsycl_sscp_get_local_id_x()
    %_223643 = trunc i64 %_223642 to i32
    %_223309 = tail call i64 @__hipsycl_sscp_get_local_size_x()
    %_223310 = trunc i64 %_223309 to i32
    %_223269 = tail call i64 @__hipsycl_sscp_get_local_size_y()
    %_223270 = trunc i64 %_223269 to i32
    br label %head_223811

head_223811:
    %_224035 = phi [256 x [256 x double]]* [ %R_224047, %MatrixFusedAddMultiplyKernel_223810 ], [ %_223852, %new_exit_223843 ]
    %_223814 = phi i32 [ %_223654, %MatrixFusedAddMultiplyKernel_223810 ], [ %_223848, %new_exit_223843 ]
    %_223819 = icmp ult i32 %_223814, 256
    br i1 %_223819, label %new_body_223833, label %new_exit_223820

new_exit_223820:
    br label %return_223821

return_223821:
    ret void

new_body_223833:
    %_223881 = trunc i32 %_223814 to i8
    %_223927.zext = zext i8 %_223881 to i9 ; add one more bit for gep index as it is treated as signed value
    %_223927 = getelementptr inbounds [256 x [256 x double]], [256 x [256 x double]]* %A_223921, i64 0, i9 %_223927.zext
    %_223951.zext = zext i8 %_223881 to i9 ; add one more bit for gep index as it is treated as signed value
    %_223951 = getelementptr inbounds [256 x [256 x double]], [256 x [256 x double]]* %B_223945, i64 0, i9 %_223951.zext
    br label %head_223834

head_223834:
    %_223852 = phi [256 x [256 x double]]* [ %_224035, %new_body_223833 ], [ %_223876, %new_yield_223866 ]
    %_223837 = phi i32 [ %_223643, %new_body_223833 ], [ %_223871, %new_yield_223866 ]
    %_223842 = icmp ult i32 %_223837, 256
    br i1 %_223842, label %new_body_223855, label %new_exit_223843

new_body_223855:
    %_223888 = trunc i32 %_223837 to i8
    br label %head_223856

head_223856:
    %acc_223896 = phi double [ 0x0000000000000000, %new_body_223855 ], [ %_223916, %new_yield_223906 ]
    %_223859 = phi i32 [ 0, %new_body_223855 ], [ %_223911, %new_yield_223906 ]
    %_223864 = icmp ult i32 %_223859, 256
    br i1 %_223864, label %new_body_223905, label %new_exit_223865

new_body_223905:
    %_223928 = trunc i32 %_223859 to i8
    %_223934.zext = zext i8 %_223928 to i9 ; add one more bit for gep index as it is treated as signed value
    %_223934 = getelementptr inbounds [256 x double], [256 x double]* %_223927, i64 0, i9 %_223934.zext
    %_223940 = load double, double* %_223934
    %_223957.zext = zext i8 %_223928 to i9 ; add one more bit for gep index as it is treated as signed value
    %_223957 = getelementptr inbounds [256 x double], [256 x double]* %_223951, i64 0, i9 %_223957.zext
    %_223963 = load double, double* %_223957
    %_223974.zext = zext i8 %_223928 to i9 ; add one more bit for gep index as it is treated as signed value
    %_223974 = getelementptr inbounds [256 x [256 x double]], [256 x [256 x double]]* %C_223968, i64 0, i9 %_223974.zext
    %_223980.zext = zext i8 %_223888 to i9 ; add one more bit for gep index as it is treated as signed value
    %_223980 = getelementptr inbounds [256 x double], [256 x double]* %_223974, i64 0, i9 %_223980.zext
    %_223986 = load double, double* %_223980
    %_224011 = fadd double %_223940, %_223963
    %_224016 = fmul double %_223986, %_224011
    %_224021 = fadd double %acc_223896, %_224016
    br label %new_yield_223906

new_yield_223906:
    %_223916 = phi double [ %_224021, %new_body_223905 ]
    %_223911 = add nuw nsw i32 1, %_223859
    br label %head_223856

new_exit_223865:
    %_223887.zext = zext i8 %_223881 to i9 ; add one more bit for gep index as it is treated as signed value
    %_223887 = getelementptr inbounds [256 x [256 x double]], [256 x [256 x double]]* %_223852, i64 0, i9 %_223887.zext
    %_223894.zext = zext i8 %_223888 to i9 ; add one more bit for gep index as it is treated as signed value
    %_223894 = getelementptr inbounds [256 x double], [256 x double]* %_223887, i64 0, i9 %_223894.zext
    store double %acc_223896, double* %_223894
    br label %new_yield_223866

new_yield_223866:
    %_223876 = phi [256 x [256 x double]]* [ %_223852, %new_exit_223865 ]
    %_223871 = add nuw nsw i32 %_223310, %_223837
    br label %head_223834

new_exit_223843:
    %_223848 = add nuw nsw i32 %_223270, %_223814
    br label %head_223811

}


