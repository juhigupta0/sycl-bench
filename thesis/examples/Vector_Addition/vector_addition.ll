declare i64 @__hipsycl_sscp_get_group_id_x() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_local_size_x() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_local_id_x() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_num_groups_x() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_group_id_y() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_local_size_y() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_local_id_y() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_num_groups_y() local_unnamed_addr




define  void @Vector_Add_double([0 x double]* %arg1_177132, [0 x double]* %_177875, double %_177880, [0 x double]* %arg2_177190, [0 x double]* %_177885, double %_177890, [0 x double]* %result_177211, [0 x double]* %_177900, double %_177905) {
Vector_Add_double_177019:
    %_177155 = tail call i64 @__hipsycl_sscp_get_group_id_x()
    %_177157 = tail call i64 @__hipsycl_sscp_get_local_size_x()
    %_177162 = mul i64 %_177155, %_177157
    %_177164 = tail call i64 @__hipsycl_sscp_get_local_id_x()
    %_177169 = add i64 %_177162, %_177164
    %_177179 = getelementptr inbounds [0 x double], [0 x double]* %arg1_177132, i64 0, i64 %_177169
    %_177185 = load double, double* %_177179
    %_177200 = getelementptr inbounds [0 x double], [0 x double]* %arg2_177190, i64 0, i64 %_177169
    %_177206 = load double, double* %_177200
    %_177221 = getelementptr inbounds [0 x double], [0 x double]* %result_177211, i64 0, i64 %_177169
    %_177259 = fadd double %_177185, %_177206
    store double %_177259, double* %_177221
    br label %exit_177020

exit_177020:
    ret void

}

define  void @Vector_Add_float([0 x float]* %arg1_177378, [0 x float]* %_177934, float %_177939, [0 x float]* %arg2_177398, [0 x float]* %_177944, float %_177949, [0 x float]* %result_177418, [0 x float]* %_177959, float %_177964) {
Vector_Add_float_177276:
    %_177155 = tail call i64 @__hipsycl_sscp_get_group_id_x()
    %_177157 = tail call i64 @__hipsycl_sscp_get_local_size_x()
    %_177162 = mul i64 %_177155, %_177157
    %_177164 = tail call i64 @__hipsycl_sscp_get_local_id_x()
    %_177169 = add i64 %_177162, %_177164
    %_177388 = getelementptr inbounds [0 x float], [0 x float]* %arg1_177378, i64 0, i64 %_177169
    %_177394 = load float, float* %_177388
    %_177408 = getelementptr inbounds [0 x float], [0 x float]* %arg2_177398, i64 0, i64 %_177169
    %_177414 = load float, float* %_177408
    %_177428 = getelementptr inbounds [0 x float], [0 x float]* %result_177418, i64 0, i64 %_177169
    %_177466 = fadd float %_177394, %_177414
    store float %_177466, float* %_177428
    br label %exit_177277

exit_177277:
    ret void

}

define  void @Vector_Add_int([0 x i32]* %arg1_177585, [0 x i32]* %_177993, i32 %_177998, [0 x i32]* %arg2_177605, [0 x i32]* %_178003, i32 %_178008, [0 x i32]* %result_177625, [0 x i32]* %_178018, i32 %_178023) {
Vector_Add_int_177483:
    %_177155 = tail call i64 @__hipsycl_sscp_get_group_id_x()
    %_177157 = tail call i64 @__hipsycl_sscp_get_local_size_x()
    %_177162 = mul i64 %_177155, %_177157
    %_177164 = tail call i64 @__hipsycl_sscp_get_local_id_x()
    %_177169 = add i64 %_177162, %_177164
    %_177595 = getelementptr inbounds [0 x i32], [0 x i32]* %arg1_177585, i64 0, i64 %_177169
    %_177601 = load i32, i32* %_177595
    %_177615 = getelementptr inbounds [0 x i32], [0 x i32]* %arg2_177605, i64 0, i64 %_177169
    %_177621 = load i32, i32* %_177615
    %_177635 = getelementptr inbounds [0 x i32], [0 x i32]* %result_177625, i64 0, i64 %_177169
    %_177673 = add i32 %_177601, %_177621
    store i32 %_177673, i32* %_177635
    br label %exit_177484

exit_177484:
    ret void

}

define  void @Vector_Add_long_long([0 x i64]* %arg1_177792, [0 x i64]* %_178052, i64 %_178057, [0 x i64]* %arg2_177812, [0 x i64]* %_178062, i64 %_178067, [0 x i64]* %result_177832, [0 x i64]* %_178077, i64 %_178082) {
Vector_Add_long_long_177690:
    %_177155 = tail call i64 @__hipsycl_sscp_get_group_id_x()
    %_177157 = tail call i64 @__hipsycl_sscp_get_local_size_x()
    %_177162 = mul i64 %_177155, %_177157
    %_177164 = tail call i64 @__hipsycl_sscp_get_local_id_x()
    %_177169 = add i64 %_177162, %_177164
    %_177802 = getelementptr inbounds [0 x i64], [0 x i64]* %arg1_177792, i64 0, i64 %_177169
    %_177808 = load i64, i64* %_177802
    %_177822 = getelementptr inbounds [0 x i64], [0 x i64]* %arg2_177812, i64 0, i64 %_177169
    %_177828 = load i64, i64* %_177822
    %_177842 = getelementptr inbounds [0 x i64], [0 x i64]* %result_177832, i64 0, i64 %_177169
    %_177863 = add i64 %_177808, %_177828
    store i64 %_177863, i64* %_177842
    br label %exit_177691

exit_177691:
    ret void

}


