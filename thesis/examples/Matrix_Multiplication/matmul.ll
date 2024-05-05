declare i64 @__hipsycl_sscp_get_group_id_x() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_local_size_x() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_local_id_x() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_num_groups_x() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_group_id_y() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_local_size_y() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_local_id_y() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_num_groups_y() local_unnamed_addr




define  void @MatMul_double(i32 %_242315, [256 x [256 x double]]* %A_241354, [0 x i32]* %_242320, i32 %_242325, i64 %_242330, [256 x [256 x double]]* %B_241406, [0 x i32]* %_242340, i32 %_242345, i64 %_242350, [256 x [256 x double]]* %C_241185, [0 x i32]* %_242360, i32 %_242365, i64 %_242370) {
MatMul_double_241017:
    %_241231 = tail call i64 @__hipsycl_sscp_get_local_id_y()
    %_241235 = tail call i64 @__hipsycl_sscp_get_local_size_y()
    %_241237 = tail call i64 @__hipsycl_sscp_get_group_id_y()
    %_241242 = mul nsw i64 %_241235, %_241237
    %_241247 = add nsw i64 %_241231, %_241242
    %_241248 = trunc i64 %_241247 to i8
    %_241258 = tail call i64 @__hipsycl_sscp_get_local_id_x()
    %_241260 = tail call i64 @__hipsycl_sscp_get_local_size_x()
    %_241262 = tail call i64 @__hipsycl_sscp_get_group_id_x()
    %_241267 = mul nsw i64 %_241260, %_241262
    %_241272 = add nsw i64 %_241258, %_241267
    %_241273 = trunc i64 %_241272 to i8
    %_241360.zext = zext i8 %_241248 to i9 ; add one more bit for gep index as it is treated as signed value
    %_241360 = getelementptr inbounds [256 x [256 x double]], [256 x [256 x double]]* %A_241354, i64 0, i9 %_241360.zext
    br label %head_241024

head_241024:
    %acc_241281 = phi double [ 0x0000000000000000, %MatMul_double_241017 ], [ %_241448, %new_body_241289 ]
    %k_241037 = phi i32 [ 0, %MatMul_double_241017 ], [ %_241311, %new_body_241289 ]
    %_241043 = icmp ult i32 %k_241037, 256
    br i1 %_241043, label %new_body_241289, label %new_exit_241048

new_exit_241048:
    %_241254.zext = zext i8 %_241248 to i9 ; add one more bit for gep index as it is treated as signed value
    %_241254 = getelementptr inbounds [256 x [256 x double]], [256 x [256 x double]]* %C_241185, i64 0, i9 %_241254.zext
    %_241279.zext = zext i8 %_241273 to i9 ; add one more bit for gep index as it is treated as signed value
    %_241279 = getelementptr inbounds [256 x double], [256 x double]* %_241254, i64 0, i9 %_241279.zext
    store double %acc_241281, double* %_241279
    br label %exit_241049

exit_241049:
    ret void

new_body_241289:
    %_241311 = add nuw nsw i32 1, %k_241037
    %_241387 = trunc i32 %k_241037 to i8
    %_241393.zext = zext i8 %_241387 to i9 ; add one more bit for gep index as it is treated as signed value
    %_241393 = getelementptr inbounds [256 x double], [256 x double]* %_241360, i64 0, i9 %_241393.zext
    %_241399 = load double, double* %_241393
    %_241412.zext = zext i8 %_241387 to i9 ; add one more bit for gep index as it is treated as signed value
    %_241412 = getelementptr inbounds [256 x [256 x double]], [256 x [256 x double]]* %B_241406, i64 0, i9 %_241412.zext
    %_241418.zext = zext i8 %_241273 to i9 ; add one more bit for gep index as it is treated as signed value
    %_241418 = getelementptr inbounds [256 x double], [256 x double]* %_241412, i64 0, i9 %_241418.zext
    %_241424 = load double, double* %_241418
    %_241443 = fmul double %_241399, %_241424
    %_241448 = fadd double %acc_241281, %_241443
    br label %head_241024

}

define  void @MatMul_float(i32 %_242416, [256 x [256 x float]]* %A_241679, [0 x i32]* %_242421, i32 %_242426, i64 %_242431, [256 x [256 x float]]* %B_241704, [0 x i32]* %_242441, i32 %_242446, i64 %_242451, [256 x [256 x float]]* %C_241610, [0 x i32]* %_242461, i32 %_242466, i64 %_242471) {
MatMul_float_241467:
    %_241231 = tail call i64 @__hipsycl_sscp_get_local_id_y()
    %_241235 = tail call i64 @__hipsycl_sscp_get_local_size_y()
    %_241237 = tail call i64 @__hipsycl_sscp_get_group_id_y()
    %_241242 = mul nsw i64 %_241235, %_241237
    %_241247 = add nsw i64 %_241231, %_241242
    %_241248 = trunc i64 %_241247 to i8
    %_241258 = tail call i64 @__hipsycl_sscp_get_local_id_x()
    %_241260 = tail call i64 @__hipsycl_sscp_get_local_size_x()
    %_241262 = tail call i64 @__hipsycl_sscp_get_group_id_x()
    %_241267 = mul nsw i64 %_241260, %_241262
    %_241272 = add nsw i64 %_241258, %_241267
    %_241273 = trunc i64 %_241272 to i8
    %_241685.zext = zext i8 %_241248 to i9 ; add one more bit for gep index as it is treated as signed value
    %_241685 = getelementptr inbounds [256 x [256 x float]], [256 x [256 x float]]* %A_241679, i64 0, i9 %_241685.zext
    br label %head_241474

head_241474:
    %acc_241624 = phi float [ 0x0000000000000000, %MatMul_float_241467 ], [ %_241746, %new_body_241632 ]
    %k_241477 = phi i32 [ 0, %MatMul_float_241467 ], [ %_241637, %new_body_241632 ]
    %_241482 = icmp ult i32 %k_241477, 256
    br i1 %_241482, label %new_body_241632, label %new_exit_241483

new_exit_241483:
    %_241616.zext = zext i8 %_241248 to i9 ; add one more bit for gep index as it is treated as signed value
    %_241616 = getelementptr inbounds [256 x [256 x float]], [256 x [256 x float]]* %C_241610, i64 0, i9 %_241616.zext
    %_241622.zext = zext i8 %_241273 to i9 ; add one more bit for gep index as it is treated as signed value
    %_241622 = getelementptr inbounds [256 x float], [256 x float]* %_241616, i64 0, i9 %_241622.zext
    store float %acc_241624, float* %_241622
    br label %exit_241484

exit_241484:
    ret void

new_body_241632:
    %_241637 = add nuw nsw i32 1, %k_241477
    %_241686 = trunc i32 %k_241477 to i8
    %_241692.zext = zext i8 %_241686 to i9 ; add one more bit for gep index as it is treated as signed value
    %_241692 = getelementptr inbounds [256 x float], [256 x float]* %_241685, i64 0, i9 %_241692.zext
    %_241698 = load float, float* %_241692
    %_241710.zext = zext i8 %_241686 to i9 ; add one more bit for gep index as it is treated as signed value
    %_241710 = getelementptr inbounds [256 x [256 x float]], [256 x [256 x float]]* %B_241704, i64 0, i9 %_241710.zext
    %_241716.zext = zext i8 %_241273 to i9 ; add one more bit for gep index as it is treated as signed value
    %_241716 = getelementptr inbounds [256 x float], [256 x float]* %_241710, i64 0, i9 %_241716.zext
    %_241722 = load float, float* %_241716
    %_241741 = fmul float %_241698, %_241722
    %_241746 = fadd float %acc_241624, %_241741
    br label %head_241474

}

define  void @MatMul_int(i32 %_242517, [256 x [256 x i32]]* %A_241956, [0 x i32]* %_242522, i32 %_242527, i64 %_242532, [256 x [256 x i32]]* %B_241981, [0 x i32]* %_242542, i32 %_242547, i64 %_242552, [256 x [256 x i32]]* %C_241904, [0 x i32]* %_242562, i32 %_242567, i64 %_242572) {
MatMul_int_241765:
    %_241231 = tail call i64 @__hipsycl_sscp_get_local_id_y()
    %_241235 = tail call i64 @__hipsycl_sscp_get_local_size_y()
    %_241237 = tail call i64 @__hipsycl_sscp_get_group_id_y()
    %_241242 = mul nsw i64 %_241235, %_241237
    %_241247 = add nsw i64 %_241231, %_241242
    %_241248 = trunc i64 %_241247 to i8
    %_241258 = tail call i64 @__hipsycl_sscp_get_local_id_x()
    %_241260 = tail call i64 @__hipsycl_sscp_get_local_size_x()
    %_241262 = tail call i64 @__hipsycl_sscp_get_group_id_x()
    %_241267 = mul nsw i64 %_241260, %_241262
    %_241272 = add nsw i64 %_241258, %_241267
    %_241273 = trunc i64 %_241272 to i8
    %_241962.zext = zext i8 %_241248 to i9 ; add one more bit for gep index as it is treated as signed value
    %_241962 = getelementptr inbounds [256 x [256 x i32]], [256 x [256 x i32]]* %A_241956, i64 0, i9 %_241962.zext
    br label %head_241769

head_241769:
    %acc_241917 = phi i32 [ 0, %MatMul_int_241765 ], [ %_242023, %new_body_241925 ]
    %k_241771 = phi i32 [ 0, %MatMul_int_241765 ], [ %_241930, %new_body_241925 ]
    %_241776 = icmp ult i32 %k_241771, 256
    br i1 %_241776, label %new_body_241925, label %new_exit_241777

new_exit_241777:
    %_241910.zext = zext i8 %_241248 to i9 ; add one more bit for gep index as it is treated as signed value
    %_241910 = getelementptr inbounds [256 x [256 x i32]], [256 x [256 x i32]]* %C_241904, i64 0, i9 %_241910.zext
    %_241916.zext = zext i8 %_241273 to i9 ; add one more bit for gep index as it is treated as signed value
    %_241916 = getelementptr inbounds [256 x i32], [256 x i32]* %_241910, i64 0, i9 %_241916.zext
    store i32 %acc_241917, i32* %_241916
    br label %exit_241778

exit_241778:
    ret void

new_body_241925:
    %_241930 = add nuw nsw i32 1, %k_241771
    %_241963 = trunc i32 %k_241771 to i8
    %_241969.zext = zext i8 %_241963 to i9 ; add one more bit for gep index as it is treated as signed value
    %_241969 = getelementptr inbounds [256 x i32], [256 x i32]* %_241962, i64 0, i9 %_241969.zext
    %_241975 = load i32, i32* %_241969
    %_241987.zext = zext i8 %_241963 to i9 ; add one more bit for gep index as it is treated as signed value
    %_241987 = getelementptr inbounds [256 x [256 x i32]], [256 x [256 x i32]]* %B_241981, i64 0, i9 %_241987.zext
    %_241993.zext = zext i8 %_241273 to i9 ; add one more bit for gep index as it is treated as signed value
    %_241993 = getelementptr inbounds [256 x i32], [256 x i32]* %_241987, i64 0, i9 %_241993.zext
    %_241999 = load i32, i32* %_241993
    %_242018 = mul nsw i32 %_241975, %_241999
    %_242023 = add nsw i32 %acc_241917, %_242018
    br label %head_241769

}

define  void @MatMul_long_long(i32 %_242639, [256 x [256 x i64]]* %A_242235, [0 x i32]* %_242644, i32 %_242649, i64 %_242654, [256 x [256 x i64]]* %B_242260, [0 x i32]* %_242664, i32 %_242669, i64 %_242674, [256 x [256 x i64]]* %C_242185, [0 x i32]* %_242684, i32 %_242689, i64 %_242694) {
MatMul_long_long_242042:
    %_241231 = tail call i64 @__hipsycl_sscp_get_local_id_y()
    %_241235 = tail call i64 @__hipsycl_sscp_get_local_size_y()
    %_241237 = tail call i64 @__hipsycl_sscp_get_group_id_y()
    %_241242 = mul nsw i64 %_241235, %_241237
    %_241247 = add nsw i64 %_241231, %_241242
    %_241248 = trunc i64 %_241247 to i8
    %_241258 = tail call i64 @__hipsycl_sscp_get_local_id_x()
    %_241260 = tail call i64 @__hipsycl_sscp_get_local_size_x()
    %_241262 = tail call i64 @__hipsycl_sscp_get_group_id_x()
    %_241267 = mul nsw i64 %_241260, %_241262
    %_241272 = add nsw i64 %_241258, %_241267
    %_241273 = trunc i64 %_241272 to i8
    %_242241.zext = zext i8 %_241248 to i9 ; add one more bit for gep index as it is treated as signed value
    %_242241 = getelementptr inbounds [256 x [256 x i64]], [256 x [256 x i64]]* %A_242235, i64 0, i9 %_242241.zext
    br label %head_242049

head_242049:
    %acc_242199 = phi i64 [ 0, %MatMul_long_long_242042 ], [ %_242302, %new_body_242207 ]
    %k_242052 = phi i32 [ 0, %MatMul_long_long_242042 ], [ %_242212, %new_body_242207 ]
    %_242057 = icmp ult i32 %k_242052, 256
    br i1 %_242057, label %new_body_242207, label %new_exit_242058

new_exit_242058:
    %_242191.zext = zext i8 %_241248 to i9 ; add one more bit for gep index as it is treated as signed value
    %_242191 = getelementptr inbounds [256 x [256 x i64]], [256 x [256 x i64]]* %C_242185, i64 0, i9 %_242191.zext
    %_242197.zext = zext i8 %_241273 to i9 ; add one more bit for gep index as it is treated as signed value
    %_242197 = getelementptr inbounds [256 x i64], [256 x i64]* %_242191, i64 0, i9 %_242197.zext
    store i64 %acc_242199, i64* %_242197
    br label %exit_242059

exit_242059:
    ret void

new_body_242207:
    %_242212 = add nuw nsw i32 1, %k_242052
    %_242242 = trunc i32 %k_242052 to i8
    %_242248.zext = zext i8 %_242242 to i9 ; add one more bit for gep index as it is treated as signed value
    %_242248 = getelementptr inbounds [256 x i64], [256 x i64]* %_242241, i64 0, i9 %_242248.zext
    %_242254 = load i64, i64* %_242248
    %_242266.zext = zext i8 %_242242 to i9 ; add one more bit for gep index as it is treated as signed value
    %_242266 = getelementptr inbounds [256 x [256 x i64]], [256 x [256 x i64]]* %B_242260, i64 0, i9 %_242266.zext
    %_242272.zext = zext i8 %_241273 to i9 ; add one more bit for gep index as it is treated as signed value
    %_242272 = getelementptr inbounds [256 x i64], [256 x i64]* %_242266, i64 0, i9 %_242272.zext
    %_242278 = load i64, i64* %_242272
    %_242297 = mul nsw i64 %_242254, %_242278
    %_242302 = add nsw i64 %acc_242199, %_242297
    br label %head_242049

}


