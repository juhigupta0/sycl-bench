declare i64 @__hipsycl_sscp_get_group_id_x() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_local_size_x() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_local_id_x() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_num_groups_x() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_group_id_y() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_local_size_y() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_local_id_y() local_unnamed_addr
declare i64 @__hipsycl_sscp_get_num_groups_y() local_unnamed_addr


declare ptr addrspace(3) @__hipsycl_sscp_get_dynamic_local_memory() local_unnamed_addr


define  void @Modulo_Based_Addition(i64 %scratch_1_142516, i64 %_142731, [0 x i32]* %acc_142549, [0 x i32]* %_142736, i32 %_142741) {
Modulo_Based_Addition_142253:
    %_142269 = tail call i64 @__hipsycl_sscp_get_local_id_x()
    %_142569 = tail call i64 @__hipsycl_sscp_get_local_size_x()
    %_142571 = tail call i64 @__hipsycl_sscp_get_group_id_x()
    %_142576 = mul nsw i64 %_142569, %_142571
    %_142581 = add nsw i64 %_142269, %_142576
    %_142591 = getelementptr inbounds [0 x i32], [0 x i32]* %acc_142549, i64 0, i64 %_142581
    %_142632 = load i32, i32* %_142591
    %_142513 = tail call ptr addrspace(3) @__hipsycl_sscp_get_dynamic_local_memory()
    %_142525.cast = addrspacecast ptr addrspace(3) %_142513 to ptr
    %_142525 = getelementptr inbounds [0 x i8], [0 x i8]* %_142525.cast, i64 0, i64 %scratch_1_142516
    %_142528 = bitcast [0 x i8]* %_142525 to [0 x i32]*
    %_142538 = getelementptr inbounds [0 x i32], [0 x i32]* %_142528, i64 0, i64 %_142269
    store i32 %_142632, i32* %_142538
    %_142648 = add nsw i64 1, %_142269
    %_142651 = urem i64 %_142648, %_142569
    %_142665 = getelementptr inbounds [0 x i32], [0 x i32]* %_142528, i64 0, i64 %_142651
    %_142671 = load i32, i32* %_142665
    %_142679 = load i32, i32* %_142538
    %_142719 = add nsw i32 %_142671, %_142679
    store i32 %_142719, i32* %_142538
    %_142274 = icmp eq i64 0, %_142269
    br i1 %_142274, label %cond_body_142284, label %exit_142276

cond_body_142284:
    %_142544 = load i32, i32* %_142538
    store i32 %_142544, i32* %_142591
    br label %exit_142276

exit_142276:
    ret void

}


