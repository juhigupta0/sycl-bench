declare i64 @__hipsycl_sscp_get_group_id_x() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_local_size_x() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_local_id_x() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_num_groups_x() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_group_id_y() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_local_size_y() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_local_id_y() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_num_groups_y() local_unnamed_addr




define  void @MeanSquareErrorKernel(i64 %matrix_size_215227, [512 x [512 x float]]* %alpha_215661, [0 x float]* %_215799, i64 %_215804, i64 %_215809, [512 x [512 x float]]* %in1_215713, [0 x float]* %_215819, i64 %_215824, i64 %_215829, [512 x [512 x float]]* %beta_215451, [0 x float]* %_215839, i64 %_215844, i64 %_215849, [512 x [512 x float]]* %in2_215502, [0 x float]* %_215859, i64 %_215864, i64 %_215869, [512 x [512 x float]]* %output_buf_215525, [0 x float]* %_215879, i64 %_215884, i64 %_215889) {
MeanSquareErrorKernel_215158:
    %_215206 = tail call i64 @__hipsycl_sscp_get_local_id_y()
    %_215210 = tail call i64 @__hipsycl_sscp_get_local_size_y()
    %_215212 = tail call i64 @__hipsycl_sscp_get_group_id_y()
    %_215217 = mul nsw i64 %_215210, %_215212
    %_215222 = add nsw i64 %_215206, %_215217
    %_215232 = icmp ult i64 %_215222, %matrix_size_215227
    %_215236 = tail call i64 @__hipsycl_sscp_get_local_id_x()
    %_215238 = tail call i64 @__hipsycl_sscp_get_local_size_x()
    %_215240 = tail call i64 @__hipsycl_sscp_get_group_id_x()
    %_215245 = mul nsw i64 %_215238, %_215240
    %_215250 = add nsw i64 %_215236, %_215245
    %_215255 = icmp ult i64 %_215250, %matrix_size_215227
    %_215266 = and i1 %_215232, %_215255
    %_215478 = trunc i64 %_215222 to i9
    %_215485 = trunc i64 %_215250 to i9
    br i1 %_215266, label %cond_enter_215274, label %return_215268

cond_enter_215274:
    %_215667.zext = zext i9 %_215478 to i10 ; add one more bit for gep index as it is treated as signed value
    %_215667 = getelementptr inbounds [512 x [512 x float]], [512 x [512 x float]]* %alpha_215661, i64 0, i10 %_215667.zext
    br label %head_215281

head_215281:
    %acc_215562 = phi float [ 0x0000000000000000, %cond_enter_215274 ], [ %_215755, %new_body_215636 ]
    %k_215294 = phi i32 [ 0, %cond_enter_215274 ], [ %_215658, %new_body_215636 ]
    %_215300 = icmp ult i32 %k_215294, 512
    br i1 %_215300, label %new_body_215636, label %new_exit_215301

new_exit_215301:
    %_215484.zext = zext i9 %_215478 to i10 ; add one more bit for gep index as it is treated as signed value
    %_215484 = getelementptr inbounds [512 x [512 x float]], [512 x [512 x float]]* %beta_215451, i64 0, i10 %_215484.zext
    %_215491.zext = zext i9 %_215485 to i10 ; add one more bit for gep index as it is treated as signed value
    %_215491 = getelementptr inbounds [512 x float], [512 x float]* %_215484, i64 0, i10 %_215491.zext
    %_215497 = load float, float* %_215491
    %_215508.zext = zext i9 %_215478 to i10 ; add one more bit for gep index as it is treated as signed value
    %_215508 = getelementptr inbounds [512 x [512 x float]], [512 x [512 x float]]* %in2_215502, i64 0, i10 %_215508.zext
    %_215514.zext = zext i9 %_215485 to i10 ; add one more bit for gep index as it is treated as signed value
    %_215514 = getelementptr inbounds [512 x float], [512 x float]* %_215508, i64 0, i10 %_215514.zext
    %_215520 = load float, float* %_215514
    %_215531.zext = zext i9 %_215478 to i10 ; add one more bit for gep index as it is treated as signed value
    %_215531 = getelementptr inbounds [512 x [512 x float]], [512 x [512 x float]]* %output_buf_215525, i64 0, i10 %_215531.zext
    %_215537.zext = zext i9 %_215485 to i10 ; add one more bit for gep index as it is treated as signed value
    %_215537 = getelementptr inbounds [512 x float], [512 x float]* %_215531, i64 0, i10 %_215537.zext
    %_215571 = fadd float %_215497, %acc_215562
    %_215578 = fsub float %_215571, %_215520
    %_215628 = fmul float %_215578, %_215578
    store float %_215628, float* %_215537
    br label %return_215268

new_body_215636:
    %_215658 = add nuw nsw i32 1, %k_215294
    %_215694 = trunc i32 %k_215294 to i9
    %_215700.zext = zext i9 %_215694 to i10 ; add one more bit for gep index as it is treated as signed value
    %_215700 = getelementptr inbounds [512 x float], [512 x float]* %_215667, i64 0, i10 %_215700.zext
    %_215706 = load float, float* %_215700
    %_215719.zext = zext i9 %_215694 to i10 ; add one more bit for gep index as it is treated as signed value
    %_215719 = getelementptr inbounds [512 x [512 x float]], [512 x [512 x float]]* %in1_215713, i64 0, i10 %_215719.zext
    %_215725.zext = zext i9 %_215485 to i10 ; add one more bit for gep index as it is treated as signed value
    %_215725 = getelementptr inbounds [512 x float], [512 x float]* %_215719, i64 0, i10 %_215725.zext
    %_215731 = load float, float* %_215725
    %_215750 = fmul float %_215706, %_215731
    %_215755 = fadd float %acc_215562, %_215750
    br label %head_215281

return_215268:
    ret void

}


