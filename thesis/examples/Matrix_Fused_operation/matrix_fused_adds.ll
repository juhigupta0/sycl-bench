declare i64 @__hipsycl_sscp_get_group_id_x() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_local_size_x() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_local_id_x() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_num_groups_x() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_group_id_y() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_local_size_y() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_local_id_y() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_num_groups_y() local_unnamed_addr




define  void @MatrixAddAddKernel_with_intermediate(i32 %_233669, [1024 x [1024 x double]]* %A_233359, [0 x i32]* %_233679, i32 %_233684, i64 %_233689, [1024 x [1024 x double]]* %B_233384, [0 x i32]* %_233699, i32 %_233704, i64 %_233709, [1024 x [1024 x double]]* %C_233218, [0 x i32]* %_233719, i32 %_233724, i64 %_233729, [1024 x [1024 x double]]* %I_233459, [0 x i32]* %_233739, i32 %_233744, i64 %_233749, [1024 x [1024 x double]]* %R_233318, [0 x i32]* %_233759, i32 %_233764, i64 %_233769) {
MatrixAddAddKernel_with_intermediate_232878:
    %_233312 = tail call i64 @__hipsycl_sscp_get_local_id_y()
    %_233313 = trunc i64 %_233312 to i32
    %_233301 = tail call i64 @__hipsycl_sscp_get_local_id_x()
    %_233302 = trunc i64 %_233301 to i32
    %_232983 = tail call i64 @__hipsycl_sscp_get_local_size_y()
    %_232984 = trunc i64 %_232983 to i32
    %_233007 = tail call i64 @__hipsycl_sscp_get_local_size_x()
    %_233008 = trunc i64 %_233007 to i32
    br label %head_232885

head_232885:
    %Inter_233167 = phi [1024 x [1024 x double]]* [ %I_233459, %MatrixAddAddKernel_with_intermediate_232878 ], [ %_233340, %new_exit_233331 ]
    %_232898 = phi i32 [ %_233313, %MatrixAddAddKernel_with_intermediate_232878 ], [ %_233336, %new_exit_233331 ]
    %_232904 = icmp ult i32 %_232898, 1024
    br i1 %_232904, label %new_body_233321, label %new_exit_232906

new_body_233321:
    %_233360 = trunc i32 %_232898 to i10
    %_233366.zext = zext i10 %_233360 to i11 ; add one more bit for gep index as it is treated as signed value
    %_233366 = getelementptr inbounds [1024 x [1024 x double]], [1024 x [1024 x double]]* %A_233359, i64 0, i11 %_233366.zext
    %_233390.zext = zext i10 %_233360 to i11 ; add one more bit for gep index as it is treated as signed value
    %_233390 = getelementptr inbounds [1024 x [1024 x double]], [1024 x [1024 x double]]* %B_233384, i64 0, i11 %_233390.zext
    br label %head_233322

head_233322:
    %_233325 = phi i32 [ %_233302, %new_body_233321 ], [ %_233349, %new_yield_233344 ]
    %_233340 = phi [1024 x [1024 x double]]* [ %Inter_233167, %new_body_233321 ], [ %_233354, %new_yield_233344 ]
    %_233330 = icmp ult i32 %_233325, 1024
    br i1 %_233330, label %new_body_233343, label %new_exit_233331

new_exit_233331:
    %_233336 = add nuw nsw i32 %_232898, %_232984
    br label %head_232885

new_body_233343:
    %_233367 = trunc i32 %_233325 to i10
    %_233373.zext = zext i10 %_233367 to i11 ; add one more bit for gep index as it is treated as signed value
    %_233373 = getelementptr inbounds [1024 x double], [1024 x double]* %_233366, i64 0, i11 %_233373.zext
    %_233379 = load double, double* %_233373
    %_233396.zext = zext i10 %_233367 to i11 ; add one more bit for gep index as it is treated as signed value
    %_233396 = getelementptr inbounds [1024 x double], [1024 x double]* %_233390, i64 0, i11 %_233396.zext
    %_233402 = load double, double* %_233396
    %_233410.zext = zext i10 %_233360 to i11 ; add one more bit for gep index as it is treated as signed value
    %_233410 = getelementptr inbounds [1024 x [1024 x double]], [1024 x [1024 x double]]* %_233340, i64 0, i11 %_233410.zext
    %_233416.zext = zext i10 %_233367 to i11 ; add one more bit for gep index as it is treated as signed value
    %_233416 = getelementptr inbounds [1024 x double], [1024 x double]* %_233410, i64 0, i11 %_233416.zext
    %_233437 = fadd double %_233379, %_233402
    store double %_233437, double* %_233416
    br label %new_yield_233344

new_yield_233344:
    %_233354 = phi [1024 x [1024 x double]]* [ %_233340, %new_body_233343 ]
    %_233349 = add nuw nsw i32 %_233008, %_233325
    br label %head_233322

new_exit_232906:
    br label %head_232907

head_232907:
    %_233304 = phi [1024 x [1024 x double]]* [ %R_233318, %new_exit_232906 ], [ %_232993, %new_exit_232938 ]
    %_232910 = phi i32 [ %_233313, %new_exit_232906 ], [ %_232989, %new_exit_232938 ]
    %_232915 = icmp ult i32 %_232910, 1024
    br i1 %_232915, label %new_body_232928, label %new_exit_232916

new_body_232928:
    %_233194 = trunc i32 %_232910 to i10
    %_233200.zext = zext i10 %_233194 to i11 ; add one more bit for gep index as it is treated as signed value
    %_233200 = getelementptr inbounds [1024 x [1024 x double]], [1024 x [1024 x double]]* %Inter_233167, i64 0, i11 %_233200.zext
    %_233224.zext = zext i10 %_233194 to i11 ; add one more bit for gep index as it is treated as signed value
    %_233224 = getelementptr inbounds [1024 x [1024 x double]], [1024 x [1024 x double]]* %C_233218, i64 0, i11 %_233224.zext
    br label %head_232929

head_232929:
    %_232993 = phi [1024 x [1024 x double]]* [ %_233304, %new_body_232928 ], [ %_233018, %new_yield_233003 ]
    %_232932 = phi i32 [ %_233302, %new_body_232928 ], [ %_233013, %new_yield_233003 ]
    %_232937 = icmp ult i32 %_232932, 1024
    br i1 %_232937, label %new_body_232996, label %new_exit_232938

new_exit_232938:
    %_232989 = add nuw nsw i32 %_232910, %_232984
    br label %head_232907

new_body_232996:
    %_233201 = trunc i32 %_232932 to i10
    %_233207.zext = zext i10 %_233201 to i11 ; add one more bit for gep index as it is treated as signed value
    %_233207 = getelementptr inbounds [1024 x double], [1024 x double]* %_233200, i64 0, i11 %_233207.zext
    %_233213 = load double, double* %_233207
    %_233230.zext = zext i10 %_233201 to i11 ; add one more bit for gep index as it is treated as signed value
    %_233230 = getelementptr inbounds [1024 x double], [1024 x double]* %_233224, i64 0, i11 %_233230.zext
    %_233236 = load double, double* %_233230
    %_233244.zext = zext i10 %_233194 to i11 ; add one more bit for gep index as it is treated as signed value
    %_233244 = getelementptr inbounds [1024 x [1024 x double]], [1024 x [1024 x double]]* %_232993, i64 0, i11 %_233244.zext
    %_233250.zext = zext i10 %_233201 to i11 ; add one more bit for gep index as it is treated as signed value
    %_233250 = getelementptr inbounds [1024 x double], [1024 x double]* %_233244, i64 0, i11 %_233250.zext
    %_233288 = fadd double %_233213, %_233236
    store double %_233288, double* %_233250
    br label %new_yield_233003

new_yield_233003:
    %_233018 = phi [1024 x [1024 x double]]* [ %_232993, %new_body_232996 ]
    %_233013 = add nuw nsw i32 %_232932, %_233008
    br label %head_232929

new_exit_232916:
    br label %return_232917

return_232917:
    ret void

}

define  void @MatrixFusedAddKernel(i32 %_233873, [1024 x [1024 x double]]* %A_233529, [0 x i32]* %_233878, i32 %_233883, i64 %_233888, [1024 x [1024 x double]]* %B_233554, [0 x i32]* %_233898, i32 %_233903, i64 %_233908, [1024 x [1024 x double]]* %C_233577, [0 x i32]* %_233918, i32 %_233923, i64 %_233928, [1024 x [1024 x double]]* %R_233662, [0 x i32]* %_233938, i32 %_233943, i64 %_233948) {
MatrixFusedAddKernel_233468:
    %_233312 = tail call i64 @__hipsycl_sscp_get_local_id_y()
    %_233313 = trunc i64 %_233312 to i32
    %_233301 = tail call i64 @__hipsycl_sscp_get_local_id_x()
    %_233302 = trunc i64 %_233301 to i32
    %_232983 = tail call i64 @__hipsycl_sscp_get_local_size_y()
    %_232984 = trunc i64 %_232983 to i32
    %_233007 = tail call i64 @__hipsycl_sscp_get_local_size_x()
    %_233008 = trunc i64 %_233007 to i32
    br label %head_233469

head_233469:
    %_233650 = phi [1024 x [1024 x double]]* [ %R_233662, %MatrixFusedAddKernel_233468 ], [ %_233510, %new_exit_233501 ]
    %_233472 = phi i32 [ %_233313, %MatrixFusedAddKernel_233468 ], [ %_233506, %new_exit_233501 ]
    %_233477 = icmp ult i32 %_233472, 1024
    br i1 %_233477, label %new_body_233491, label %new_exit_233478

new_exit_233478:
    br label %return_233479

return_233479:
    ret void

new_body_233491:
    %_233530 = trunc i32 %_233472 to i10
    %_233536.zext = zext i10 %_233530 to i11 ; add one more bit for gep index as it is treated as signed value
    %_233536 = getelementptr inbounds [1024 x [1024 x double]], [1024 x [1024 x double]]* %A_233529, i64 0, i11 %_233536.zext
    %_233560.zext = zext i10 %_233530 to i11 ; add one more bit for gep index as it is treated as signed value
    %_233560 = getelementptr inbounds [1024 x [1024 x double]], [1024 x [1024 x double]]* %B_233554, i64 0, i11 %_233560.zext
    %_233583.zext = zext i10 %_233530 to i11 ; add one more bit for gep index as it is treated as signed value
    %_233583 = getelementptr inbounds [1024 x [1024 x double]], [1024 x [1024 x double]]* %C_233577, i64 0, i11 %_233583.zext
    br label %head_233492

head_233492:
    %_233510 = phi [1024 x [1024 x double]]* [ %_233650, %new_body_233491 ], [ %_233524, %new_yield_233514 ]
    %_233495 = phi i32 [ %_233302, %new_body_233491 ], [ %_233519, %new_yield_233514 ]
    %_233500 = icmp ult i32 %_233495, 1024
    br i1 %_233500, label %new_body_233513, label %new_exit_233501

new_exit_233501:
    %_233506 = add nuw nsw i32 %_232984, %_233472
    br label %head_233469

new_body_233513:
    %_233537 = trunc i32 %_233495 to i10
    %_233543.zext = zext i10 %_233537 to i11 ; add one more bit for gep index as it is treated as signed value
    %_233543 = getelementptr inbounds [1024 x double], [1024 x double]* %_233536, i64 0, i11 %_233543.zext
    %_233549 = load double, double* %_233543
    %_233566.zext = zext i10 %_233537 to i11 ; add one more bit for gep index as it is treated as signed value
    %_233566 = getelementptr inbounds [1024 x double], [1024 x double]* %_233560, i64 0, i11 %_233566.zext
    %_233572 = load double, double* %_233566
    %_233589.zext = zext i10 %_233537 to i11 ; add one more bit for gep index as it is treated as signed value
    %_233589 = getelementptr inbounds [1024 x double], [1024 x double]* %_233583, i64 0, i11 %_233589.zext
    %_233595 = load double, double* %_233589
    %_233603.zext = zext i10 %_233530 to i11 ; add one more bit for gep index as it is treated as signed value
    %_233603 = getelementptr inbounds [1024 x [1024 x double]], [1024 x [1024 x double]]* %_233510, i64 0, i11 %_233603.zext
    %_233609.zext = zext i10 %_233537 to i11 ; add one more bit for gep index as it is treated as signed value
    %_233609 = getelementptr inbounds [1024 x double], [1024 x double]* %_233603, i64 0, i11 %_233609.zext
    %_233632 = fadd double %_233549, %_233572
    %_233637 = fadd double %_233595, %_233632
    store double %_233637, double* %_233609
    br label %new_yield_233514

new_yield_233514:
    %_233524 = phi [1024 x [1024 x double]]* [ %_233510, %new_body_233513 ]
    %_233519 = add nuw nsw i32 %_233008, %_233495
    br label %head_233492

}


