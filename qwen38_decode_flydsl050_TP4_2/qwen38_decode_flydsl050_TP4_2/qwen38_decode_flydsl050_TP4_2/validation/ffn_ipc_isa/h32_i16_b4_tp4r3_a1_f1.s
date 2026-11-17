	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1201"
	.amdhsa_code_object_version 6
	.text
	.globl	qwen_bf16_ffnar_v1_h32_i16_b4_tp4r3_a1_f1
	.p2align	8
	.type	qwen_bf16_ffnar_v1_h32_i16_b4_tp4r3_a1_f1,@function
qwen_bf16_ffnar_v1_h32_i16_b4_tp4r3_a1_f1:
	s_load_b128 s[36:39], s[0:1], 0x70
	s_wait_kmcnt 0x0
	s_cmp_lt_i32 s36, 1
	s_cbranch_scc1 .LBB0_355
	s_clause 0x2
	s_load_b256 s[20:27], s[0:1], 0x40
	s_load_b96 s[40:42], s[0:1], 0x80
	s_load_b128 s[28:31], s[0:1], 0x60
	v_cmp_eq_u32_e64 s2, 0, v0
	s_and_saveexec_b32 s3, s2
	s_cbranch_execz .LBB0_3
	v_mov_b32_e32 v1, 0
	s_cmp_lg_u32 ttmp9, s39
	s_cselect_b32 s4, -1, 0
	s_wait_kmcnt 0x0
	global_load_b32 v2, v1, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, 0, v2
	s_and_b32 s4, s4, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	s_and_b32 s4, s4, exec_lo
	s_cselect_b32 s4, 1, 0
	v_mov_b32_e32 v2, s4
	ds_store_b32 v1, v2 offset:20
.LBB0_3:
	s_or_b32 exec_lo, exec_lo, s3
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	v_mov_b32_e32 v1, 0
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	ds_load_b32 v2, v1 offset:20
	s_wait_dscnt 0x0
	v_cmp_eq_u32_e32 vcc_lo, 0, v2
	s_cbranch_vccnz .LBB0_350
	s_wait_kmcnt 0x0
	global_load_b64 v[7:8], v1, s[24:25] offset:24
	s_load_b512 s[4:19], s[0:1], 0x0
	v_lshl_or_b32 v25, ttmp9, 7, v0
	s_lshl_b32 s33, s36, 5
	s_delay_alu instid0(VALU_DEP_1) | instid1(SALU_CYCLE_1)
	v_cmp_gt_i32_e64 s0, s33, v25
	s_wait_loadcnt 0x0
	global_load_b32 v6, v[7:8], off offset:256 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	s_and_saveexec_b32 s3, s0
	s_cbranch_execz .LBB0_7
	v_add_co_u32 v3, vcc_lo, 0x200, v7
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v4, null, 0, v8, vcc_lo
	v_mov_b32_e32 v1, v25
	s_mov_b32 s34, 0
.LBB0_6:
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v2, 31, v1
	v_lshlrev_b64_e32 v[9:10], 1, v[1:2]
	v_add_nc_u32_e32 v1, 0x200, v1
	s_wait_kmcnt 0x0
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_add_co_u32 v11, vcc_lo, s4, v9
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v12, null, s5, v10, vcc_lo
	v_cmp_le_i32_e32 vcc_lo, s33, v1
	v_add_co_u32 v9, s1, v3, v9
	global_load_d16_b16 v2, v[11:12], off
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v10, null, v4, v10, s1
	s_or_b32 s34, vcc_lo, s34
	s_wait_loadcnt 0x0
	global_store_b16 v[9:10], v2, off
	s_and_not1_b32 exec_lo, exec_lo, s34
	s_cbranch_execnz .LBB0_6
.LBB0_7:
	s_or_b32 exec_lo, exec_lo, s3
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s3, s2
	s_cbranch_execz .LBB0_18
	v_mov_b32_e32 v2, 0
	s_mov_b32 s1, exec_lo
	s_wait_kmcnt 0x0
	s_mov_b32 s4, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	v_mbcnt_lo_u32_b32 v1, s1, 0
	global_load_b32 v3, v2, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_10
	s_bcnt1_i32_b32 s1, s1
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v4, s1
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v4, v2, v4, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_10:
	s_or_b32 exec_lo, exec_lo, s4
	v_readfirstlane_b32 s1, v4
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v1, s1, v1
	s_mov_b32 s1, exec_lo
	v_cmpx_ne_u32_e32 3, v1
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s4, exec_lo, s1
	s_cbranch_execz .LBB0_15
	s_cmp_lt_i32 s38, 1
	s_mov_b32 s5, 1
	s_cbranch_scc1 .LBB0_60
	v_mov_b32_e32 v1, 0
.LBB0_13:
	global_load_b32 v2, v1, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	global_load_b32 v4, v1, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, v2, v3
	v_cmp_eq_u32_e64 s1, 0, v4
	s_and_b32 s1, vcc_lo, s1
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s5, s38
	s_cselect_b32 s34, -1, 0
	s_add_co_i32 s5, s5, 1
	s_and_b32 s34, s1, s34
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_b32 vcc_lo, exec_lo, s34
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_13
	s_and_b32 vcc_lo, exec_lo, s1
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_61
.LBB0_15:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s1, s4
	s_cbranch_execz .LBB0_17
.LBB0_16:
	v_dual_mov_b32 v1, 0 :: v_dual_add_nc_u32 v2, 1, v3
	global_store_b32 v1, v1, s[20:21] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v1, v2, s[20:21] offset:4 scope:SCOPE_DEV
.LBB0_17:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s1
	v_mov_b32_e32 v1, 0
	global_load_b32 v2, v1, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, 0, v2
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e64 v2, 0, 1, vcc_lo
	ds_store_b32 v1, v2 offset:20
.LBB0_18:
	s_or_b32 exec_lo, exec_lo, s3
	s_wait_storecnt 0x0
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	v_mov_b32_e32 v1, 0
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	ds_load_b32 v1, v1 offset:20
	s_wait_dscnt 0x0
	v_cmp_eq_u32_e32 vcc_lo, 0, v1
	s_cbranch_vccnz .LBB0_98
	v_or_b32_e32 v1, ttmp9, v0
	v_add_nc_u32_e32 v3, 1, v6
	s_delay_alu instid0(VALU_DEP_2)
	v_cmp_eq_u32_e64 s1, 0, v1
	s_wait_kmcnt 0x0
	s_and_saveexec_b32 s4, s1
	s_cbranch_execz .LBB0_52
	s_cmp_gt_i32 s38, 0
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[7:8], v3, off scope:SCOPE_SYS
	s_cselect_b32 s5, -1, 0
	s_cmp_lt_i32 s38, 1
	s_cbranch_scc1 .LBB0_24
	v_mov_b32_e32 v4, 0
	s_mov_b32 s34, 1
	global_load_b64 v[1:2], v4, s[24:25]
.LBB0_22:
	s_wait_loadcnt 0x0
	global_load_b32 v6, v[1:2], off scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v5, v[1:2], off offset:384 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v9, v4, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	s_cmp_lt_i32 s34, s38
	s_cselect_b32 s35, -1, 0
	s_add_co_i32 s34, s34, 1
	v_cmp_ne_u32_e64 s3, v6, v3
	v_or_b32_e32 v5, v9, v5
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_cmp_eq_u32_e32 vcc_lo, 0, v5
	s_and_b32 s35, vcc_lo, s35
	s_and_b32 s35, s3, s35
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_b32 vcc_lo, exec_lo, s35
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_22
	v_cmp_ne_u32_e32 vcc_lo, 0, v5
	s_or_b32 s3, s3, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_b32 vcc_lo, exec_lo, s3
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_25
	s_branch .LBB0_28
.LBB0_24:
	s_cbranch_execz .LBB0_28
.LBB0_25:
	v_dual_mov_b32 v4, 1 :: v_dual_mov_b32 v5, 0
	s_mov_b32 s3, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v1, v5, v[4:5], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_27
	v_dual_mov_b32 v1, 10 :: v_dual_mov_b32 v2, v5
	global_store_b96 v5, v[1:3], s[22:23] offset:4
.LBB0_27:
	s_or_b32 exec_lo, exec_lo, s3
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[7:8], v4, off offset:384 scope:SCOPE_SYS
.LBB0_28:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s3, s5, exec_lo
	s_cselect_b32 s3, 1, 0
	s_mov_b32 s34, 1
	s_cmp_lg_u32 s3, 1
	s_cbranch_scc1 .LBB0_32
	v_mov_b32_e32 v4, 0
	global_load_b64 v[1:2], v4, s[24:25] offset:8
.LBB0_30:
	s_wait_loadcnt 0x0
	global_load_b32 v6, v[1:2], off scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v5, v[1:2], off offset:384 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v9, v4, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	s_cmp_lt_i32 s34, s38
	s_cselect_b32 s35, -1, 0
	s_add_co_i32 s34, s34, 1
	v_cmp_ne_u32_e64 s3, v6, v3
	v_or_b32_e32 v5, v9, v5
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_cmp_eq_u32_e32 vcc_lo, 0, v5
	s_and_b32 s35, vcc_lo, s35
	s_and_b32 s35, s3, s35
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_b32 vcc_lo, exec_lo, s35
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_30
	v_cmp_ne_u32_e32 vcc_lo, 0, v5
	s_or_b32 s3, s3, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_b32 vcc_lo, exec_lo, s3
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_33
	s_branch .LBB0_36
.LBB0_32:
	s_cbranch_execz .LBB0_36
.LBB0_33:
	v_dual_mov_b32 v4, 1 :: v_dual_mov_b32 v5, 0
	s_mov_b32 s3, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v1, v5, v[4:5], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_35
	v_dual_mov_b32 v1, 10 :: v_dual_mov_b32 v2, v5
	global_store_b96 v5, v[1:3], s[22:23] offset:4
.LBB0_35:
	s_or_b32 exec_lo, exec_lo, s3
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[7:8], v4, off offset:384 scope:SCOPE_SYS
.LBB0_36:
	s_and_b32 s3, s5, exec_lo
	s_cselect_b32 s3, 1, 0
	s_mov_b32 s34, 1
	s_cmp_lg_u32 s3, 1
	s_cbranch_scc1 .LBB0_40
	v_mov_b32_e32 v4, 0
	global_load_b64 v[1:2], v4, s[24:25] offset:16
.LBB0_38:
	s_wait_loadcnt 0x0
	global_load_b32 v6, v[1:2], off scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v5, v[1:2], off offset:384 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v9, v4, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	s_cmp_lt_i32 s34, s38
	s_cselect_b32 s35, -1, 0
	s_add_co_i32 s34, s34, 1
	v_cmp_ne_u32_e64 s3, v6, v3
	v_or_b32_e32 v5, v9, v5
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_cmp_eq_u32_e32 vcc_lo, 0, v5
	s_and_b32 s35, vcc_lo, s35
	s_and_b32 s35, s3, s35
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_b32 vcc_lo, exec_lo, s35
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_38
	v_cmp_ne_u32_e32 vcc_lo, 0, v5
	s_or_b32 s3, s3, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_b32 vcc_lo, exec_lo, s3
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_41
	s_branch .LBB0_44
.LBB0_40:
	s_cbranch_execz .LBB0_44
.LBB0_41:
	v_dual_mov_b32 v4, 1 :: v_dual_mov_b32 v5, 0
	s_mov_b32 s3, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v1, v5, v[4:5], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_43
	v_dual_mov_b32 v1, 10 :: v_dual_mov_b32 v2, v5
	global_store_b96 v5, v[1:3], s[22:23] offset:4
.LBB0_43:
	s_or_b32 exec_lo, exec_lo, s3
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[7:8], v4, off offset:384 scope:SCOPE_SYS
.LBB0_44:
	s_and_b32 s3, s5, exec_lo
	s_cselect_b32 s3, 1, 0
	s_mov_b32 s5, 1
	s_cmp_lg_u32 s3, 1
	s_cbranch_scc1 .LBB0_48
	v_mov_b32_e32 v4, 0
	global_load_b64 v[1:2], v4, s[24:25] offset:24
.LBB0_46:
	s_wait_loadcnt 0x0
	global_load_b32 v6, v[1:2], off scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v5, v[1:2], off offset:384 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v9, v4, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s5, s38
	s_cselect_b32 s34, -1, 0
	s_add_co_i32 s5, s5, 1
	v_cmp_ne_u32_e64 s3, v6, v3
	v_or_b32_e32 v5, v9, v5
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_cmp_eq_u32_e32 vcc_lo, 0, v5
	s_and_b32 s34, vcc_lo, s34
	s_and_b32 s34, s3, s34
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_b32 vcc_lo, exec_lo, s34
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_46
	v_cmp_ne_u32_e32 vcc_lo, 0, v5
	s_or_b32 s3, s3, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_b32 vcc_lo, exec_lo, s3
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_49
	s_branch .LBB0_52
.LBB0_48:
	s_cbranch_execz .LBB0_52
.LBB0_49:
	v_dual_mov_b32 v4, 1 :: v_dual_mov_b32 v5, 0
	s_mov_b32 s3, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v1, v5, v[4:5], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_51
	v_dual_mov_b32 v1, 10 :: v_dual_mov_b32 v2, v5
	global_store_b96 v5, v[1:3], s[22:23] offset:4
.LBB0_51:
	s_or_b32 exec_lo, exec_lo, s3
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[7:8], v4, off offset:384 scope:SCOPE_SYS
.LBB0_52:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s4, s2
	s_cbranch_execz .LBB0_71
	v_mov_b32_e32 v2, 0
	s_mov_b32 s3, exec_lo
	s_mov_b32 s5, exec_lo
	v_mbcnt_lo_u32_b32 v1, s3, 0
	global_load_b32 v6, v2, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_55
	s_bcnt1_i32_b32 s3, s3
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v4, s3
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v4, v2, v4, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_55:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s5
	v_readfirstlane_b32 s3, v4
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v1, s3, v1
	s_mov_b32 s3, exec_lo
	v_cmpx_ne_u32_e32 3, v1
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s5, exec_lo, s3
	s_cbranch_execz .LBB0_68
	s_cmp_lt_i32 s38, 1
	s_mov_b32 s34, 1
	s_cbranch_scc1 .LBB0_64
	v_mov_b32_e32 v1, 0
.LBB0_58:
	global_load_b32 v2, v1, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	global_load_b32 v4, v1, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, v2, v6
	v_cmp_eq_u32_e64 s3, 0, v4
	s_and_b32 s3, vcc_lo, s3
	s_cmp_lt_i32 s34, s38
	s_cselect_b32 s35, -1, 0
	s_add_co_i32 s34, s34, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s35, s3, s35
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_b32 vcc_lo, exec_lo, s35
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_58
	s_and_b32 vcc_lo, exec_lo, s3
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_65
	s_branch .LBB0_68
.LBB0_60:
	s_cbranch_execz .LBB0_15
.LBB0_61:
	v_dual_mov_b32 v4, 1 :: v_dual_mov_b32 v5, 0
	s_mov_b32 s1, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v1, v5, v[4:5], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_63
	v_dual_mov_b32 v2, ttmp9 :: v_dual_mov_b32 v1, 3
	global_store_b96 v5, v[1:3], s[22:23] offset:4
.LBB0_63:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s1
	s_and_not1_saveexec_b32 s1, s4
	s_cbranch_execnz .LBB0_16
	s_branch .LBB0_17
.LBB0_64:
	s_cbranch_execz .LBB0_68
.LBB0_65:
	v_dual_mov_b32 v1, 1 :: v_dual_mov_b32 v2, 0
	s_mov_b32 s3, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v1, v2, v[1:2], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_67
	v_dual_mov_b32 v5, ttmp9 :: v_dual_mov_b32 v4, 4
	global_store_b96 v2, v[4:6], s[22:23] offset:4
.LBB0_67:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
.LBB0_68:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s3, s5
	s_cbranch_execz .LBB0_70
	v_dual_mov_b32 v1, 0 :: v_dual_add_nc_u32 v2, 1, v6
	global_store_b32 v1, v1, s[20:21] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v1, v2, s[20:21] offset:4 scope:SCOPE_DEV
.LBB0_70:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
	v_mov_b32_e32 v1, 0
	global_load_b32 v2, v1, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, 0, v2
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e64 v2, 0, 1, vcc_lo
	ds_store_b32 v1, v2 offset:20
.LBB0_71:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	s_wait_storecnt 0x0
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	v_mov_b32_e32 v1, 0
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	ds_load_b32 v1, v1 offset:20
	s_wait_dscnt 0x0
	v_cmp_eq_u32_e32 vcc_lo, 0, v1
	s_cbranch_vccnz .LBB0_98
	s_and_saveexec_b32 s4, s0
	s_cbranch_execz .LBB0_77
	v_dual_mov_b32 v6, 0 :: v_dual_mov_b32 v1, v25
	s_cmp_lg_u32 s40, 0
	s_mov_b32 s5, 0
	s_cselect_b32 s34, -1, 0
	s_branch .LBB0_75
.LBB0_74:
	v_add_nc_u32_e32 v1, 0x200, v1
	v_add_co_u32 v4, s3, s18, v4
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v5, null, s19, v5, s3
	s_delay_alu instid0(VALU_DEP_3)
	v_cmp_le_i32_e32 vcc_lo, s33, v1
	global_store_b16 v[4:5], v2, off offset:1536
	s_or_b32 s5, vcc_lo, s5
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_b32 exec_lo, exec_lo, s5
	s_cbranch_execz .LBB0_77
.LBB0_75:
	s_clause 0x1
	global_load_b128 v[9:12], v6, s[24:25]
	global_load_b128 v[13:16], v6, s[24:25] offset:16
	v_ashrrev_i32_e32 v2, 31, v1
	s_and_b32 s3, s34, exec_lo
	s_cselect_b32 s3, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s3, 1
	v_lshlrev_b64_e32 v[4:5], 1, v[1:2]
	s_wait_loadcnt 0x1
	v_add_co_u32 v2, vcc_lo, 0x200, v9
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v10, null, 0, v10, vcc_lo
	v_add_co_u32 v11, vcc_lo, 0x200, v11
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v12, null, 0, v12, vcc_lo
	s_wait_loadcnt 0x0
	v_add_co_u32 v13, vcc_lo, 0x200, v13
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v14, null, 0, v14, vcc_lo
	v_add_co_u32 v15, vcc_lo, 0x200, v15
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v16, null, 0, v16, vcc_lo
	v_add_co_u32 v9, vcc_lo, v2, v4
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v10, null, v10, v5, vcc_lo
	v_add_co_u32 v11, vcc_lo, v11, v4
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v12, null, v12, v5, vcc_lo
	global_load_u16 v2, v[9:10], off
	v_add_co_u32 v9, vcc_lo, v13, v4
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v10, null, v14, v5, vcc_lo
	global_load_u16 v13, v[11:12], off
	v_add_co_u32 v11, vcc_lo, v15, v4
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v12, null, v16, v5, vcc_lo
	global_load_u16 v9, v[9:10], off
	global_load_u16 v10, v[11:12], off
	s_wait_loadcnt 0x3
	v_lshlrev_b32_e32 v2, 16, v2
	s_wait_loadcnt 0x2
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_dual_add_f32 v2, 0, v2 :: v_dual_lshlrev_b32 v11, 16, v13
	s_wait_loadcnt 0x1
	v_dual_add_f32 v2, v2, v11 :: v_dual_lshlrev_b32 v9, 16, v9
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v10, 16, v10
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v2, v2, v9
	v_add_f32_e32 v2, v2, v10
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v9, v2, 16, 1
	v_or_b32_e32 v10, 0x400000, v2
	v_cmp_u_f32_e32 vcc_lo, v2, v2
	v_add3_u32 v9, v9, v2, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_cndmask_b32_e32 v2, v9, v10, vcc_lo
	v_lshrrev_b32_e32 v2, 16, v2
	s_cbranch_scc1 .LBB0_74
	v_ashrrev_i32_e32 v9, 31, v1
	v_mov_b16_e32 v11.l, 0
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_lshlrev_b32_e32 v2, 16, v2
	v_lshrrev_b32_e32 v9, 27, v9
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v9, v1, v9
	v_and_b32_e32 v9, 0xffffffe0, v9
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_sub_nc_u32_e32 v9, v1, v9
	v_ashrrev_i32_e32 v10, 31, v9
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshlrev_b64_e32 v[9:10], 1, v[9:10]
	v_add_co_u32 v9, vcc_lo, s26, v9
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_3) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v10, null, s27, v10, vcc_lo
	global_load_d16_hi_b16 v11, v[9:10], off
	s_wait_loadcnt 0x0
	v_add_f32_e32 v9, 1.0, v11
	v_bfe_u32 v10, v9, 16, 1
	v_or_b32_e32 v11, 0x400000, v9
	v_cmp_u_f32_e32 vcc_lo, v9, v9
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v10, v10, v9, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v9, v10, v11, vcc_lo
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_and_b32_e32 v9, 0xffff0000, v9
	v_mul_f32_e32 v2, v9, v2
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v9, v2, 16, 1
	v_or_b32_e32 v10, 0x400000, v2
	v_cmp_u_f32_e32 vcc_lo, v2, v2
	v_add3_u32 v9, v9, v2, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_cndmask_b32_e32 v2, v9, v10, vcc_lo
	v_lshrrev_b32_e32 v2, 16, v2
	s_branch .LBB0_74
.LBB0_77:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_inv scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s4, s2
	s_cbranch_execz .LBB0_92
	v_mov_b32_e32 v2, 0
	s_mov_b32 s3, exec_lo
	s_mov_b32 s5, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	v_mbcnt_lo_u32_b32 v1, s3, 0
	global_load_b32 v6, v2, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_80
	s_bcnt1_i32_b32 s3, s3
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v4, s3
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v4, v2, v4, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_80:
	s_or_b32 exec_lo, exec_lo, s5
	v_readfirstlane_b32 s3, v4
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v1, s3, v1
	s_mov_b32 s3, exec_lo
	v_cmpx_ne_u32_e32 3, v1
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s5, exec_lo, s3
	s_cbranch_execz .LBB0_89
	s_cmp_lt_i32 s38, 1
	s_mov_b32 s26, 1
	s_cbranch_scc1 .LBB0_84
	v_mov_b32_e32 v1, 0
.LBB0_83:
	global_load_b32 v2, v1, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	global_load_b32 v4, v1, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, v2, v6
	v_cmp_eq_u32_e64 s3, 0, v4
	s_and_b32 s3, vcc_lo, s3
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s26, s38
	s_cselect_b32 s27, -1, 0
	s_add_co_i32 s26, s26, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s27, s3, s27
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s27
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_83
	s_branch .LBB0_85
.LBB0_84:
	s_mov_b32 s3, -1
.LBB0_85:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s3
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccz .LBB0_89
	v_dual_mov_b32 v1, 1 :: v_dual_mov_b32 v2, 0
	s_mov_b32 s3, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v1, v2, v[1:2], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_88
	v_dual_mov_b32 v5, ttmp9 :: v_dual_mov_b32 v4, 5
	global_store_b96 v2, v[4:6], s[22:23] offset:4
.LBB0_88:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
.LBB0_89:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s3, s5
	s_cbranch_execz .LBB0_91
	v_dual_mov_b32 v1, 0 :: v_dual_add_nc_u32 v2, 1, v6
	global_store_b32 v1, v1, s[20:21] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v1, v2, s[20:21] offset:4 scope:SCOPE_DEV
.LBB0_91:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
	v_mov_b32_e32 v1, 0
	global_load_b32 v2, v1, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, 0, v2
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e64 v2, 0, 1, vcc_lo
	ds_store_b32 v1, v2 offset:20
.LBB0_92:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	s_wait_storecnt 0x0
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	v_mov_b32_e32 v1, 0
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	ds_load_b32 v1, v1 offset:20
	s_wait_dscnt 0x0
	v_cmp_eq_u32_e32 vcc_lo, 0, v1
	s_cbranch_vccnz .LBB0_98
	s_and_saveexec_b32 s3, s1
	s_cbranch_execz .LBB0_129
	s_cmp_gt_i32 s38, 0
	s_mov_b32 s5, 1
	s_cselect_b32 s4, -1, 0
	s_cmp_lt_i32 s38, 1
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[7:8], v3, off offset:128 scope:SCOPE_SYS
	s_cbranch_scc1 .LBB0_99
	v_mov_b32_e32 v4, 0
	global_load_b64 v[1:2], v4, s[24:25]
.LBB0_96:
	s_wait_loadcnt 0x0
	global_load_b32 v6, v[1:2], off offset:128 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v5, v[1:2], off offset:384 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v9, v4, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s5, s38
	s_cselect_b32 s26, -1, 0
	s_add_co_i32 s5, s5, 1
	v_cmp_ne_u32_e64 s1, v6, v3
	v_or_b32_e32 v5, v9, v5
	s_delay_alu instid0(VALU_DEP_1)
	v_cmp_eq_u32_e32 vcc_lo, 0, v5
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s26, vcc_lo, s26
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s26, s1, s26
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s26
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_96
	v_cmp_ne_u32_e32 vcc_lo, 0, v5
	s_or_b32 s1, s1, vcc_lo
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s1
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_100
	s_branch .LBB0_103
.LBB0_98:
	s_cbranch_execz .LBB0_145
	s_branch .LBB0_350
.LBB0_99:
	s_cbranch_execz .LBB0_103
.LBB0_100:
	v_dual_mov_b32 v4, 1 :: v_dual_mov_b32 v5, 0
	s_mov_b32 s1, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v1, v5, v[4:5], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_102
	v_dual_mov_b32 v1, 11 :: v_dual_mov_b32 v2, v5
	global_store_b96 v5, v[1:3], s[22:23] offset:4
.LBB0_102:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s1
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[7:8], v4, off offset:384 scope:SCOPE_SYS
.LBB0_103:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s1, s4, exec_lo
	s_cselect_b32 s1, 1, 0
	s_mov_b32 s5, 1
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s1, 1
	s_cbranch_scc1 .LBB0_107
	v_mov_b32_e32 v4, 0
	global_load_b64 v[1:2], v4, s[24:25] offset:8
.LBB0_105:
	s_wait_loadcnt 0x0
	global_load_b32 v6, v[1:2], off offset:128 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v5, v[1:2], off offset:384 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v9, v4, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	s_cmp_lt_i32 s5, s38
	s_cselect_b32 s26, -1, 0
	s_add_co_i32 s5, s5, 1
	v_cmp_ne_u32_e64 s1, v6, v3
	v_or_b32_e32 v5, v9, v5
	s_delay_alu instid0(VALU_DEP_1)
	v_cmp_eq_u32_e32 vcc_lo, 0, v5
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s26, vcc_lo, s26
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s26, s1, s26
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s26
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_105
	v_cmp_ne_u32_e32 vcc_lo, 0, v5
	s_or_b32 s1, s1, vcc_lo
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s1
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_108
	s_branch .LBB0_111
.LBB0_107:
	s_cbranch_execz .LBB0_111
.LBB0_108:
	v_dual_mov_b32 v4, 1 :: v_dual_mov_b32 v5, 0
	s_mov_b32 s1, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v1, v5, v[4:5], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_110
	v_dual_mov_b32 v1, 11 :: v_dual_mov_b32 v2, v5
	global_store_b96 v5, v[1:3], s[22:23] offset:4
.LBB0_110:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s1
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[7:8], v4, off offset:384 scope:SCOPE_SYS
.LBB0_111:
	s_and_b32 s1, s4, exec_lo
	s_cselect_b32 s1, 1, 0
	s_mov_b32 s5, 1
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s1, 1
	s_cbranch_scc1 .LBB0_115
	v_mov_b32_e32 v4, 0
	global_load_b64 v[1:2], v4, s[24:25] offset:16
.LBB0_113:
	s_wait_loadcnt 0x0
	global_load_b32 v6, v[1:2], off offset:128 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v5, v[1:2], off offset:384 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v9, v4, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	s_cmp_lt_i32 s5, s38
	s_cselect_b32 s26, -1, 0
	s_add_co_i32 s5, s5, 1
	v_cmp_ne_u32_e64 s1, v6, v3
	v_or_b32_e32 v5, v9, v5
	s_delay_alu instid0(VALU_DEP_1)
	v_cmp_eq_u32_e32 vcc_lo, 0, v5
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s26, vcc_lo, s26
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s26, s1, s26
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s26
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_113
	v_cmp_ne_u32_e32 vcc_lo, 0, v5
	s_or_b32 s1, s1, vcc_lo
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s1
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_116
	s_branch .LBB0_119
.LBB0_115:
	s_cbranch_execz .LBB0_119
.LBB0_116:
	v_dual_mov_b32 v4, 1 :: v_dual_mov_b32 v5, 0
	s_mov_b32 s1, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v1, v5, v[4:5], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_118
	v_dual_mov_b32 v1, 11 :: v_dual_mov_b32 v2, v5
	global_store_b96 v5, v[1:3], s[22:23] offset:4
.LBB0_118:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s1
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[7:8], v4, off offset:384 scope:SCOPE_SYS
.LBB0_119:
	s_and_b32 s1, s4, exec_lo
	s_cselect_b32 s1, 1, 0
	s_mov_b32 s4, 1
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s1, 1
	s_cbranch_scc1 .LBB0_123
	v_mov_b32_e32 v4, 0
	global_load_b64 v[1:2], v4, s[24:25] offset:24
.LBB0_121:
	s_wait_loadcnt 0x0
	global_load_b32 v6, v[1:2], off offset:128 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v5, v[1:2], off offset:384 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v9, v4, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	s_cmp_lt_i32 s4, s38
	s_cselect_b32 s5, -1, 0
	s_add_co_i32 s4, s4, 1
	v_cmp_ne_u32_e64 s1, v6, v3
	v_or_b32_e32 v5, v9, v5
	s_delay_alu instid0(VALU_DEP_1)
	v_cmp_eq_u32_e32 vcc_lo, 0, v5
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s5, vcc_lo, s5
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s5, s1, s5
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s5
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_121
	v_cmp_ne_u32_e32 vcc_lo, 0, v5
	s_or_b32 s1, s1, vcc_lo
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s1
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_124
	s_branch .LBB0_127
.LBB0_123:
	s_cbranch_execz .LBB0_127
.LBB0_124:
	v_dual_mov_b32 v4, 1 :: v_dual_mov_b32 v5, 0
	s_mov_b32 s1, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v1, v5, v[4:5], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_126
	v_dual_mov_b32 v1, 11 :: v_dual_mov_b32 v2, v5
	global_store_b96 v5, v[1:3], s[22:23] offset:4
.LBB0_126:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s1
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[7:8], v4, off offset:384 scope:SCOPE_SYS
.LBB0_127:
	v_mov_b32_e32 v1, 0
	global_load_b32 v1, v1, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_ne_u32_e32 vcc_lo, 0, v1
	s_cbranch_vccnz .LBB0_129
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[7:8], v3, off offset:256 scope:SCOPE_SYS
.LBB0_129:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s1, s2
	s_cbranch_execz .LBB0_144
	v_mov_b32_e32 v2, 0
	s_mov_b32 s4, exec_lo
	s_mov_b32 s5, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	v_mbcnt_lo_u32_b32 v1, s4, 0
	global_load_b32 v3, v2, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s3, v3
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_132
	s_bcnt1_i32_b32 s4, s4
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v3, s4
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v3, v2, v3, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_132:
	s_or_b32 exec_lo, exec_lo, s5
	v_readfirstlane_b32 s4, v3
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v1, s4, v1
	s_mov_b32 s4, exec_lo
	v_cmpx_ne_u32_e32 3, v1
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s4, exec_lo, s4
	s_cbranch_execz .LBB0_141
	s_cmp_lt_i32 s38, 1
	s_mov_b32 s5, 1
	s_cbranch_scc1 .LBB0_136
	v_mov_b32_e32 v1, 0
.LBB0_135:
	global_load_b32 v2, v1, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	global_load_b32 v3, v1, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s26, v2
	v_readfirstlane_b32 s27, v3
	s_cmp_eq_u32 s26, s3
	s_cselect_b32 s26, -1, 0
	s_cmp_eq_u32 s27, 0
	s_cselect_b32 s27, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s26, s26, s27
	s_cmp_lt_i32 s5, s38
	s_cselect_b32 s27, -1, 0
	s_add_co_i32 s5, s5, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s27, s26, s27
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s27
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_135
	s_branch .LBB0_137
.LBB0_136:
	s_mov_b32 s26, -1
.LBB0_137:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s5, s26, exec_lo
	s_cselect_b32 s5, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s5, 1
	s_cbranch_scc1 .LBB0_141
	v_dual_mov_b32 v1, 1 :: v_dual_mov_b32 v2, 0
	s_mov_b32 s5, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v1, v2, v[1:2], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_140
	v_dual_mov_b32 v4, ttmp9 :: v_dual_mov_b32 v3, 6
	v_mov_b32_e32 v5, s3
	global_store_b96 v2, v[3:5], s[22:23] offset:4
.LBB0_140:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s5
.LBB0_141:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s4, s4
	s_cbranch_execz .LBB0_143
	s_add_co_i32 s3, s3, 1
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v1, 0 :: v_dual_mov_b32 v2, s3
	global_store_b32 v1, v1, s[20:21] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v1, v2, s[20:21] offset:4 scope:SCOPE_DEV
.LBB0_143:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	v_mov_b32_e32 v1, 0
	global_load_b32 v2, v1, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, 0, v2
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e64 v2, 0, 1, vcc_lo
	ds_store_b32 v1, v2 offset:20
.LBB0_144:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s1
	s_wait_storecnt 0x0
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	v_mov_b32_e32 v1, 0
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	ds_load_b32 v1, v1 offset:20
	s_wait_dscnt 0x0
	v_cmp_eq_u32_e64 s1, 0, v1
	s_and_b32 vcc_lo, exec_lo, s1
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_350
.LBB0_145:
	v_lshrrev_b32_e32 v1, 5, v0
	s_cmp_ge_i32 ttmp9, s36
	s_wait_kmcnt 0x0
	s_delay_alu instid0(VALU_DEP_1)
	v_readfirstlane_b32 s4, v1
	s_cbranch_scc1 .LBB0_156
	v_and_b32_e32 v1, 31, v0
	v_lshlrev_b32_e32 v3, 1, v0
	v_cmp_gt_u32_e64 s1, 32, v0
	s_mov_b32 s5, ttmp9
	v_dual_mov_b32 v9, 0 :: v_dual_lshlrev_b32 v2, 2, v1
	v_cmp_gt_u32_e32 vcc_lo, 24, v1
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_3) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v8, 4, v2
	v_add_nc_u32_e32 v7, 8, v2
	v_add_nc_u32_e32 v4, 32, v2
	s_wait_alu depctr_va_vcc(0)
	v_dual_cndmask_b32 v5, v2, v4 :: v_dual_add_nc_u32 v6, 16, v2
	v_cmp_gt_u32_e32 vcc_lo, 28, v1
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_cndmask_b32_e32 v6, v2, v6, vcc_lo
	v_cmp_gt_u32_e32 vcc_lo, 30, v1
	v_cmp_eq_u32_e64 s3, 0, v1
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v7, v2, v7, vcc_lo
	v_cmp_ne_u32_e32 vcc_lo, 31, v1
	v_add_co_u32 v1, s8, s8, v3
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v2, null, s9, 0, s8
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v8, 0x7c, v8, vcc_lo
	v_lshl_add_u32 v3, ttmp9, 5, v0
	s_lshl_b32 s8, s4, 2
	s_branch .LBB0_148
.LBB0_147:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s9
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	s_barrier_signal -1
	v_add_nc_u32_e32 v3, 0x80, v3
	s_add_co_i32 s5, s5, 4
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s5, s36
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_cbranch_scc0 .LBB0_156
.LBB0_148:
	s_delay_alu instid0(VALU_DEP_1)
	v_ashrrev_i32_e32 v4, 31, v3
	v_mov_b32_e32 v10, 0
	s_and_saveexec_b32 s9, s1
	s_cbranch_execz .LBB0_150
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshlrev_b64_e32 v[10:11], 1, v[3:4]
	v_add_co_u32 v12, vcc_lo, s18, v10
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_add_co_ci_u32_e64 v13, null, s19, v11, vcc_lo
	v_add_co_u32 v14, vcc_lo, s6, v10
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v15, null, s7, v11, vcc_lo
	global_load_u16 v12, v[12:13], off offset:1536
	global_load_u16 v13, v[14:15], off
	s_wait_loadcnt 0x1
	v_lshlrev_b32_e32 v12, 16, v12
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v13, 16, v13
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v14, v12, v13
	v_bfe_u32 v12, v14, 16, 1
	v_or_b32_e32 v15, 0x400000, v14
	s_delay_alu instid0(VALU_DEP_2)
	v_add3_u32 v16, v12, v14, 0x7fff
	v_add_co_u32 v12, vcc_lo, s16, v10
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v13, null, s17, v11, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v14, v14
	s_wait_alu depctr_va_vcc(0)
	v_dual_mul_f32 v10, v14, v14 :: v_dual_cndmask_b32 v11, v16, v15
	global_store_d16_hi_b16 v[12:13], v11, off
.LBB0_150:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s9
	ds_swizzle_b32 v11, v10 offset:swizzle(BITMASK_PERM,"1pppp")
	s_wait_dscnt 0x0
	v_add_f32_e32 v10, v10, v11
	ds_bpermute_b32 v11, v5, v10
	s_wait_dscnt 0x0
	v_add_f32_e32 v10, v10, v11
	ds_bpermute_b32 v11, v6, v10
	s_wait_dscnt 0x0
	v_add_f32_e32 v10, v10, v11
	ds_bpermute_b32 v11, v7, v10
	s_wait_dscnt 0x0
	v_add_f32_e32 v10, v10, v11
	ds_bpermute_b32 v11, v8, v10
	s_and_saveexec_b32 s9, s3
	s_cbranch_execz .LBB0_152
	s_wait_dscnt 0x0
	v_dual_add_f32 v10, v10, v11 :: v_dual_mov_b32 v11, s8
	ds_store_b32 v11, v10
.LBB0_152:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s9
	s_wait_storecnt 0x0
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s9, s2
	s_cbranch_execz .LBB0_154
	ds_load_b128 v[10:13], v9
	s_wait_dscnt 0x0
	v_readfirstlane_b32 s26, v10
	v_readfirstlane_b32 s27, v11
	v_readfirstlane_b32 s34, v12
	s_add_f32 s26, s26, 0
	s_wait_alu depctr_sa_sdst(0)
	s_delay_alu instid0(SALU_CYCLE_2) | instskip(SKIP_2) | instid1(SALU_CYCLE_1)
	s_add_f32 s26, s26, s27
	v_readfirstlane_b32 s27, v13
	s_wait_alu depctr_sa_sdst(0)
	s_add_f32 s26, s26, s34
	s_wait_alu depctr_sa_sdst(0)
	s_delay_alu instid0(SALU_CYCLE_2) | instskip(SKIP_1) | instid1(SALU_CYCLE_2)
	s_add_f32 s26, s26, s27
	s_wait_alu depctr_sa_sdst(0)
	s_mul_f32 s26, s26, 0x3d000000
	s_wait_alu depctr_sa_sdst(0)
	s_delay_alu instid0(SALU_CYCLE_2) | instskip(SKIP_1) | instid1(SALU_CYCLE_2)
	s_add_f32 s26, s37, s26
	s_wait_alu depctr_sa_sdst(0)
	s_mul_f32 s27, s26, 0x4f800000
	s_cmp_lt_f32 s26, 0xf800000
	s_wait_alu depctr_sa_sdst(0)
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_3) | instid1(TRANS32_DEP_1)
	s_cselect_b32 s27, s27, s26
	s_wait_alu depctr_sa_sdst(0)
	v_s_sqrt_f32 s34, s27
	s_mov_b32 s39, s27
	s_add_co_i32 s35, s34, -1
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_xor_b32 s40, s35, 0x80000000
	s_fmac_f32 s39, s40, s34
	s_mov_b32 s40, s27
	s_delay_alu instid0(SALU_CYCLE_2) | instskip(SKIP_2) | instid1(SALU_CYCLE_1)
	s_cmp_le_f32 s39, 0
	s_cselect_b32 s35, s35, s34
	s_add_co_i32 s39, s34, 1
	s_xor_b32 s43, s39, 0x80000000
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_2)
	s_fmac_f32 s40, s43, s34
	v_cmp_class_f32_e64 s34, s27, 0x260
	s_cmp_gt_f32 s40, 0
	s_cselect_b32 s35, s39, s35
	s_cmp_lt_f32 s26, 0xf800000
	s_mul_f32 s26, s35, 0x37800000
	s_wait_alu depctr_sa_sdst(0)
	s_delay_alu instid0(SALU_CYCLE_2)
	s_cselect_b32 s26, s26, s35
	s_and_b32 s34, s34, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	s_cselect_b32 s26, s27, s26
	s_wait_alu depctr_sa_sdst(0)
	v_div_scale_f32 v10, null, s26, s26, 1.0
	s_delay_alu instid0(VALU_DEP_1)
	v_rcp_f32_e32 v11, v10
	v_xor_b32_e32 v10, 0x80000000, v10
	s_delay_alu instid0(TRANS32_DEP_1) | instid1(VALU_DEP_1)
	v_fma_f32 v12, v10, v11, 1.0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_fmac_f32_e32 v11, v12, v11
	v_div_scale_f32 v12, vcc_lo, 1.0, s26, 1.0
	v_mul_f32_e32 v13, v12, v11
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fma_f32 v14, v10, v13, v12
	v_fmac_f32_e32 v13, v14, v11
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_fmac_f32_e32 v12, v10, v13
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v10, v12, v11, v13
	s_delay_alu instid0(VALU_DEP_1)
	v_div_fixup_f32 v10, v10, s26, 1.0
	ds_store_b32 v9, v10 offset:16
.LBB0_154:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s9
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s9, s1
	s_cbranch_execz .LBB0_147
	v_lshlrev_b64_e32 v[10:11], 1, v[3:4]
	ds_load_b32 v14, v9 offset:16
	v_add_co_u32 v12, vcc_lo, s18, v10
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v13, null, s19, v11, vcc_lo
	v_add_co_u32 v10, vcc_lo, s6, v10
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v11, null, s7, v11, vcc_lo
	global_load_u16 v4, v[12:13], off offset:1536
	global_load_u16 v10, v[10:11], off
	global_load_u16 v11, v[1:2], off
	s_wait_loadcnt 0x2
	v_lshlrev_b32_e32 v4, 16, v4
	s_wait_loadcnt 0x1
	v_lshlrev_b32_e32 v10, 16, v10
	s_wait_loadcnt 0x0
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_dual_add_f32 v4, v4, v10 :: v_dual_lshlrev_b32 v11, 16, v11
	v_add_f32_e32 v10, 1.0, v11
	s_wait_dscnt 0x0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v4, v14, v4
	v_mul_f32_e32 v4, v4, v10
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v10, v4, 16, 1
	v_or_b32_e32 v11, 0x400000, v4
	v_cmp_u_f32_e32 vcc_lo, v4, v4
	v_add3_u32 v10, v10, v4, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_1)
	v_cndmask_b32_e32 v4, v10, v11, vcc_lo
	global_store_d16_hi_b16 v[12:13], v4, off
	s_branch .LBB0_147
.LBB0_156:
	s_wait_loadcnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s1, s2
	s_cbranch_execz .LBB0_171
	v_mov_b32_e32 v2, 0
	s_mov_b32 s5, exec_lo
	s_mov_b32 s6, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	v_mbcnt_lo_u32_b32 v1, s5, 0
	global_load_b32 v3, v2, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s3, v3
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_159
	s_bcnt1_i32_b32 s5, s5
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v3, s5
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v3, v2, v3, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_159:
	s_or_b32 exec_lo, exec_lo, s6
	v_readfirstlane_b32 s5, v3
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v1, s5, v1
	s_mov_b32 s5, exec_lo
	v_cmpx_ne_u32_e32 3, v1
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s5, exec_lo, s5
	s_cbranch_execz .LBB0_168
	s_cmp_lt_i32 s38, 1
	s_mov_b32 s6, 1
	s_cbranch_scc1 .LBB0_163
	v_mov_b32_e32 v1, 0
.LBB0_162:
	global_load_b32 v2, v1, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	global_load_b32 v3, v1, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s7, v2
	v_readfirstlane_b32 s8, v3
	s_cmp_eq_u32 s7, s3
	s_cselect_b32 s7, -1, 0
	s_cmp_eq_u32 s8, 0
	s_cselect_b32 s8, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s7, s7, s8
	s_cmp_lt_i32 s6, s38
	s_cselect_b32 s8, -1, 0
	s_add_co_i32 s6, s6, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s8, s7, s8
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s8
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_162
	s_branch .LBB0_164
.LBB0_163:
	s_mov_b32 s7, -1
.LBB0_164:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s6, s7, exec_lo
	s_cselect_b32 s6, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s6, 1
	s_cbranch_scc1 .LBB0_168
	v_dual_mov_b32 v1, 1 :: v_dual_mov_b32 v2, 0
	s_mov_b32 s6, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v3, v2, v[1:2], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v3
	s_cbranch_execz .LBB0_167
	v_dual_mov_b32 v4, ttmp9 :: v_dual_mov_b32 v5, s3
	v_mov_b32_e32 v3, v1
	global_store_b96 v2, v[3:5], s[22:23] offset:4
.LBB0_167:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
.LBB0_168:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s5, s5
	s_cbranch_execz .LBB0_170
	s_add_co_i32 s3, s3, 1
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v1, 0 :: v_dual_mov_b32 v2, s3
	global_store_b32 v1, v1, s[20:21] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v1, v2, s[20:21] offset:4 scope:SCOPE_DEV
.LBB0_170:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s5
	v_mov_b32_e32 v1, 0
	global_load_b32 v2, v1, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, 0, v2
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e64 v2, 0, 1, vcc_lo
	ds_store_b32 v1, v2 offset:20
.LBB0_171:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s1
	s_wait_storecnt 0x0
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	v_mov_b32_e32 v1, 0
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	ds_load_b32 v1, v1 offset:20
	s_wait_dscnt 0x0
	v_cmp_eq_u32_e32 vcc_lo, 0, v1
	s_cbranch_vccnz .LBB0_350
	v_lshrrev_b32_e32 v1, 1, v0
	s_lshl_b32 s1, ttmp9, 2
	v_and_b32_e32 v30, 15, v0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s5, s1, s4
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_gt_i32 s5, 0
	v_and_b32_e32 v31, 8, v1
	s_cbranch_scc0 .LBB0_180
.LBB0_173:
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s1, s2
	s_cbranch_execz .LBB0_196
	v_mov_b32_e32 v2, 0
	s_mov_b32 s4, exec_lo
	s_mov_b32 s6, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	v_mbcnt_lo_u32_b32 v1, s4, 0
	global_load_b32 v3, v2, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s3, v3
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_176
	s_bcnt1_i32_b32 s4, s4
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v3, s4
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v3, v2, v3, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_176:
	s_or_b32 exec_lo, exec_lo, s6
	v_readfirstlane_b32 s4, v3
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v1, s4, v1
	s_mov_b32 s4, exec_lo
	v_cmpx_ne_u32_e32 3, v1
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s4, exec_lo, s4
	s_cbranch_execz .LBB0_193
	s_cmp_lt_i32 s38, 1
	s_mov_b32 s6, 1
	s_cbranch_scc1 .LBB0_188
	v_mov_b32_e32 v1, 0
.LBB0_179:
	global_load_b32 v2, v1, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	global_load_b32 v3, v1, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s7, v2
	v_readfirstlane_b32 s8, v3
	s_cmp_eq_u32 s7, s3
	s_cselect_b32 s7, -1, 0
	s_cmp_eq_u32 s8, 0
	s_cselect_b32 s8, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s7, s7, s8
	s_cmp_lt_i32 s6, s38
	s_cselect_b32 s8, -1, 0
	s_add_co_i32 s6, s6, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s8, s7, s8
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s8
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_179
	s_branch .LBB0_189
.LBB0_180:
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_4) | instid1(VALU_DEP_1)
	v_lshl_or_b32 v32, v30, 5, v31
	v_cmp_gt_i32_e64 s1, s36, v30
	v_lshlrev_b32_e32 v33, 4, v30
	s_mov_b32 s6, s5
	v_lshlrev_b32_e32 v1, 1, v32
	v_add_co_u32 v26, s3, s18, v1
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v27, null, s19, 0, s3
	s_branch .LBB0_182
.LBB0_181:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s7
	s_add_co_i32 s3, s6, 16
	s_cmp_lt_i32 s6, -15
	s_wait_alu depctr_sa_sdst(0)
	s_mov_b32 s6, s3
	s_cbranch_scc0 .LBB0_173
.LBB0_182:
	v_dual_mov_b32 v17, 0 :: v_dual_mov_b32 v18, 0
	v_dual_mov_b32 v19, 0 :: v_dual_mov_b32 v20, 0
	s_and_saveexec_b32 s3, s1
	s_cbranch_execz .LBB0_184
	global_load_b128 v[17:20], v[26:27], off
.LBB0_184:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
	v_lshl_or_b32 v1, s6, 9, v32
	v_dual_mov_b32 v21, 0 :: v_dual_mov_b32 v22, 0
	v_dual_mov_b32 v23, 0 :: v_dual_mov_b32 v24, 0
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v2, 31, v1
	v_lshlrev_b64_e32 v[1:2], 1, v[1:2]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v28, vcc_lo, s10, v1
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v29, null, s11, v2, vcc_lo
	s_clause 0x1
	global_load_b128 v[1:4], v[28:29], off
	global_load_b128 v[34:37], v[28:29], off offset:1024
	s_wait_loadcnt 0x1
	v_wmma_f32_16x16x16_bf16 v[9:16], v[1:4], v[17:20], 0
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[1:8], v[34:37], v[17:20], 0
	s_and_saveexec_b32 s3, s1
	s_cbranch_execz .LBB0_186
	global_load_b128 v[21:24], v[26:27], off offset:32
.LBB0_186:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
	s_clause 0x1
	global_load_b128 v[17:20], v[28:29], off offset:32
	global_load_b128 v[34:37], v[28:29], off offset:1056
	s_wait_loadcnt 0x1
	v_wmma_f32_16x16x16_bf16 v[9:16], v[17:20], v[21:24], v[9:16]
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[1:8], v[34:37], v[21:24], v[1:8]
	s_and_saveexec_b32 s7, s1
	s_cbranch_execz .LBB0_181
	v_bfe_u32 v17, v9, 16, 1
	v_or_b32_e32 v18, 0x400000, v9
	v_bfe_u32 v19, v10, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v9, v9
	v_or_b32_e32 v20, 0x400000, v10
	v_add3_u32 v17, v17, v9, 0x7fff
	v_bfe_u32 v23, v11, 16, 1
	v_add3_u32 v19, v19, v10, 0x7fff
	v_or_b32_e32 v24, 0x400000, v11
	v_bfe_u32 v34, v12, 16, 1
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v9, v17, v18, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	v_add3_u32 v23, v23, v11, 0x7fff
	v_bfe_u32 v17, v1, 16, 1
	v_or_b32_e32 v35, 0x400000, v12
	v_add3_u32 v34, v34, v12, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_dual_cndmask_b32 v10, v19, v20 :: v_dual_and_b32 v21, 0xffff0000, v9
	v_lshl_or_b32 v9, s6, 4, v31
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	v_or_b32_e32 v18, 0x400000, v1
	s_delay_alu instid0(VALU_DEP_4)
	v_and_b32_e32 v28, 0xffff0000, v10
	v_mul_f32_e32 v19, 0xbfb8aa3b, v21
	v_add3_u32 v17, v17, v1, 0x7fff
	v_bfe_u32 v22, v2, 16, 1
	v_or_b32_e32 v20, 0x400000, v2
	v_mul_f32_e32 v36, 0xbfb8aa3b, v28
	v_fma_f32 v10, 0xbfb8aa3b, v21, -v19
	v_rndne_f32_e32 v29, v19
	v_add3_u32 v22, v22, v2, 0x7fff
	v_cmp_u_f32_e64 s3, v2, v2
	v_bfe_u32 v37, v13, 16, 1
	v_or_b32_e32 v38, 0x400000, v13
	v_sub_f32_e32 v19, v19, v29
	v_fma_f32 v39, 0xbfb8aa3b, v28, -v36
	v_fmac_f32_e32 v10, 0xb2a5705f, v21
	v_cvt_i32_f32_e32 v29, v29
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v20, v22, v20, s3
	v_add3_u32 v37, v37, v13, 0x7fff
	v_dual_fmac_f32 v39, 0xb2a5705f, v28 :: v_dual_add_f32 v10, v19, v10
	v_rndne_f32_e32 v19, v36
	v_add_nc_u32_e32 v9, v9, v33
	v_and_b32_e32 v20, 0xffff0000, v20
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v11, v23, v24, vcc_lo
	v_exp_f32_e32 v10, v10
	v_sub_f32_e32 v36, v36, v19
	v_cmp_u_f32_e32 vcc_lo, v12, v12
	v_cvt_i32_f32_e32 v19, v19
	v_and_b32_e32 v11, 0xffff0000, v11
	s_delay_alu instid0(VALU_DEP_4)
	v_add_f32_e32 v36, v36, v39
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v12, v34, v35, vcc_lo
	v_cmp_nlt_f32_e32 vcc_lo, 0x42ce8ed0, v21
	v_ldexp_f32 v10, v10, v29
	v_cmp_nlt_f32_e64 s3, 0x42ce8ed0, v11
	v_exp_f32_e32 v23, v36
	v_cmp_ngt_f32_e64 s4, 0xc2b17218, v11
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v10, 0, v10, vcc_lo
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2b17218, v21
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_cndmask_b32_e32 v10, 0x7f800000, v10, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v1, v1
	s_wait_alu depctr_va_vcc(0)
	v_dual_cndmask_b32 v1, v17, v18 :: v_dual_and_b32 v12, 0xffff0000, v12
	v_ldexp_f32 v17, v23, v19
	v_dual_add_f32 v19, 1.0, v10 :: v_dual_mul_f32 v18, 0xbfb8aa3b, v11
	v_cmp_nlt_f32_e32 vcc_lo, 0x42ce8ed0, v28
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_mul_f32_e32 v23, 0xbfb8aa3b, v12
	v_div_scale_f32 v24, null, v19, v19, v21
	s_delay_alu instid0(VALU_DEP_4)
	v_rndne_f32_e32 v29, v18
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v10, 0, v17, vcc_lo
	v_fma_f32 v17, 0xbfb8aa3b, v11, -v18
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2b17218, v28
	v_rcp_f32_e32 v34, v24
	v_fma_f32 v35, 0xbfb8aa3b, v12, -v23
	s_delay_alu instid0(VALU_DEP_3)
	v_dual_sub_f32 v18, v18, v29 :: v_dual_fmac_f32 v17, 0xb2a5705f, v11
	v_rndne_f32_e32 v39, v23
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v10, 0x7f800000, v10, vcc_lo
	v_fmac_f32_e32 v35, 0xb2a5705f, v12
	v_div_scale_f32 v41, vcc_lo, v21, v19, v21
	v_add_f32_e32 v17, v18, v17
	v_fma_f32 v40, -v24, v34, 1.0
	v_dual_sub_f32 v23, v23, v39 :: v_dual_add_f32 v36, 1.0, v10
	v_cvt_i32_f32_e32 v29, v29
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_exp_f32_e32 v17, v17
	v_dual_fmac_f32 v34, v40, v34 :: v_dual_add_f32 v23, v23, v35
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_2) | instid1(VALU_DEP_4)
	v_div_scale_f32 v18, null, v36, v36, v28
	v_and_b32_e32 v35, 0xffff0000, v1
	v_ashrrev_i32_e32 v10, 31, v9
	v_mul_f32_e32 v22, v41, v34
	v_cvt_i32_f32_e32 v39, v39
	v_rcp_f32_e32 v42, v18
	s_delay_alu instid0(TRANS32_DEP_2) | instskip(SKIP_3) | instid1(VALU_DEP_2)
	v_ldexp_f32 v1, v17, v29
	v_exp_f32_e32 v17, v23
	v_fma_f32 v23, -v24, v22, v41
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v1, 0, v1, s3
	v_div_scale_f32 v29, s3, v28, v36, v28
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(TRANS32_DEP_2)
	v_fmac_f32_e32 v22, v23, v34
	v_fma_f32 v2, -v18, v42, 1.0
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_cndmask_b32_e64 v23, 0x7f800000, v1, s4
	v_cmp_u_f32_e64 s4, v7, v7
	v_fmac_f32_e32 v42, v2, v42
	v_lshlrev_b64_e32 v[1:2], 1, v[9:10]
	v_ldexp_f32 v10, v17, v39
	v_fma_f32 v17, -v24, v22, v41
	v_add_f32_e32 v23, 1.0, v23
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_div_fmas_f32 v17, v17, v34, v22
	v_div_scale_f32 v22, null, v23, v23, v11
	v_cmp_nlt_f32_e32 vcc_lo, 0x42ce8ed0, v12
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_div_fixup_f32 v17, v17, v19, v21
	v_rcp_f32_e32 v19, v22
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_mul_f32_e32 v17, v17, v35
	v_mul_f32_e32 v40, v29, v42
	v_bfe_u32 v21, v17, 16, 1
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_fma_f32 v24, -v18, v40, v29
	v_add3_u32 v21, v21, v17, 0x7fff
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(TRANS32_DEP_1)
	v_fmac_f32_e32 v40, v24, v42
	v_fma_f32 v24, -v22, v19, 1.0
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_fma_f32 v18, -v18, v40, v29
	s_wait_alu depctr_va_vcc(0)
	v_dual_fmac_f32 v19, v24, v19 :: v_dual_cndmask_b32 v10, 0, v10
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2b17218, v12
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_cndmask_b32_e32 v10, 0x7f800000, v10, vcc_lo
	s_mov_b32 vcc_lo, s3
	v_cmp_u_f32_e64 s3, v17, v17
	s_wait_alu depctr_sa_sdst(0)
	v_div_fmas_f32 v18, v18, v42, v40
	v_div_scale_f32 v29, vcc_lo, v11, v23, v11
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_3) | instid1(VALU_DEP_2)
	v_div_fixup_f32 v18, v18, v36, v28
	v_or_b32_e32 v28, 0x400000, v17
	v_or_b32_e32 v36, 0x400000, v3
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v17, v21, v28, s3
	v_add_co_u32 v1, s3, s18, v1
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v2, null, s19, v2, s3
	v_cmp_u_f32_e64 s3, v13, v13
	v_mul_f32_e32 v21, v29, v19
	v_bfe_u32 v28, v3, 16, 1
	v_lshrrev_b32_e32 v17, 16, v17
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v13, v37, v38, s3
	v_fma_f32 v34, -v22, v21, v29
	v_add3_u32 v28, v28, v3, 0x7fff
	v_cmp_u_f32_e64 s3, v3, v3
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_dual_mul_f32 v18, v18, v20 :: v_dual_and_b32 v13, 0xffff0000, v13
	v_fmac_f32_e32 v21, v34, v19
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_cndmask_b32_e64 v3, v28, v36, s3
	v_mul_f32_e32 v37, 0xbfb8aa3b, v13
	v_bfe_u32 v24, v18, 16, 1
	v_fma_f32 v22, -v22, v21, v29
	s_delay_alu instid0(VALU_DEP_4)
	v_and_b32_e32 v3, 0xffff0000, v3
	v_or_b32_e32 v34, 0x400000, v18
	v_rndne_f32_e32 v36, v37
	v_fma_f32 v29, 0xbfb8aa3b, v13, -v37
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v19, v22, v19, v21
	v_add3_u32 v24, v24, v18, 0x7fff
	v_cmp_u_f32_e64 s3, v18, v18
	v_dual_sub_f32 v21, v37, v36 :: v_dual_add_f32 v10, 1.0, v10
	v_fmac_f32_e32 v29, 0xb2a5705f, v13
	v_div_fixup_f32 v11, v19, v23, v11
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v18, v24, v34, s3
	v_cmp_u_f32_e64 s3, v4, v4
	v_div_scale_f32 v20, null, v10, v10, v12
	v_div_scale_f32 v22, vcc_lo, v12, v10, v12
	v_add_f32_e32 v19, v21, v29
	v_mul_f32_e32 v11, v11, v3
	v_bfe_u32 v3, v4, 16, 1
	v_rcp_f32_e32 v35, v20
	v_or_b32_e32 v29, 0x400000, v4
	v_lshrrev_b32_e32 v18, 16, v18
	v_bfe_u32 v34, v15, 16, 1
	v_add3_u32 v3, v3, v4, 0x7fff
	v_or_b32_e32 v37, 0x400000, v6
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(TRANS32_DEP_1)
	v_mov_b16_e32 v17.h, v18.l
	v_fma_f32 v28, -v20, v35, 1.0
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v4, v3, v29, s3
	v_cmp_nlt_f32_e64 s3, 0x42ce8ed0, v13
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_fmac_f32_e32 v35, v28, v35
	v_cvt_i32_f32_e32 v28, v36
	v_mul_f32_e32 v21, v22, v35
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fma_f32 v23, -v20, v21, v22
	v_fmac_f32_e32 v21, v23, v35
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_3) | instid1(VALU_DEP_2)
	v_fma_f32 v3, -v20, v21, v22
	v_and_b32_e32 v22, 0xffff0000, v4
	v_exp_f32_e32 v19, v19
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v20, v3, v35, v21
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2b17218, v13
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(TRANS32_DEP_1)
	v_div_fixup_f32 v10, v20, v10, v12
	v_ldexp_f32 v19, v19, v28
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_mul_f32_e32 v10, v10, v22
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v19, 0, v19, s3
	v_bfe_u32 v24, v11, 16, 1
	v_or_b32_e32 v21, 0x400000, v11
	v_bfe_u32 v18, v10, 16, 1
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v19, 0x7f800000, v19, vcc_lo
	v_add_nc_u32_e32 v3, 3, v9
	v_add3_u32 v23, v24, v11, 0x7fff
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	v_add3_u32 v18, v18, v10, 0x7fff
	v_add_f32_e32 v12, 1.0, v19
	v_bfe_u32 v19, v14, 16, 1
	v_ashrrev_i32_e32 v4, 31, v3
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v20, v23, v21, vcc_lo
	v_or_b32_e32 v21, 0x400000, v14
	v_div_scale_f32 v11, null, v12, v12, v13
	v_add3_u32 v19, v19, v14, 0x7fff
	v_cmp_u_f32_e32 vcc_lo, v14, v14
	v_bfe_u32 v23, v5, 16, 1
	v_cmp_u_f32_e64 s3, v10, v10
	v_rcp_f32_e32 v22, v11
	v_lshlrev_b64_e32 v[3:4], 1, v[3:4]
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v14, v19, v21, vcc_lo
	v_or_b32_e32 v21, 0x400000, v10
	v_add3_u32 v10, v23, v5, 0x7fff
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(TRANS32_DEP_1)
	v_add_co_u32 v3, vcc_lo, s18, v3
	v_fma_f32 v19, -v11, v22, 1.0
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v18, v18, v21, s3
	v_or_b32_e32 v21, 0x400000, v5
	v_cmp_u_f32_e64 s3, v5, v5
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v4, null, s19, v4, vcc_lo
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_3) | instid1(VALU_DEP_4)
	v_cndmask_b32_e64 v5, v10, v21, s3
	v_fmac_f32_e32 v22, v19, v22
	v_div_scale_f32 v19, vcc_lo, v13, v12, v13
	v_cmp_u_f32_e64 s3, v15, v15
	v_and_b32_e32 v5, 0xffff0000, v5
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_mul_f32_e32 v23, v19, v22
	v_and_b32_e32 v14, 0xffff0000, v14
	v_fma_f32 v21, -v11, v23, v19
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_mul_f32_e32 v24, 0xbfb8aa3b, v14
	v_fmac_f32_e32 v23, v21, v22
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_2) | instid1(VALU_DEP_4)
	v_rndne_f32_e32 v29, v24
	v_fma_f32 v28, 0xbfb8aa3b, v14, -v24
	v_bfe_u32 v21, v16, 16, 1
	v_fma_f32 v11, -v11, v23, v19
	s_delay_alu instid0(VALU_DEP_4)
	v_sub_f32_e32 v10, v24, v29
	v_add3_u32 v24, v34, v15, 0x7fff
	v_or_b32_e32 v34, 0x400000, v15
	v_cvt_i32_f32_e32 v19, v29
	v_add3_u32 v21, v21, v16, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v11, v11, v22, v23
	v_cmp_u_f32_e32 vcc_lo, v16, v16
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v15, v24, v34, s3
	v_or_b32_e32 v24, 0x400000, v16
	v_div_fixup_f32 v12, v11, v12, v13
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_dual_cndmask_b32 v16, v21, v24 :: v_dual_and_b32 v15, 0xffff0000, v15
	v_fmac_f32_e32 v28, 0xb2a5705f, v14
	v_cmp_nlt_f32_e32 vcc_lo, 0x42ce8ed0, v14
	v_cmp_ngt_f32_e64 s3, 0xc2b17218, v15
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v10, v10, v28
	v_exp_f32_e32 v10, v10
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_ldexp_f32 v10, v10, v19
	s_wait_alu depctr_va_vcc(0)
	v_dual_mul_f32 v19, 0xbfb8aa3b, v15 :: v_dual_cndmask_b32 v10, 0, v10
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_3) | instid1(VALU_DEP_4)
	v_fma_f32 v13, 0xbfb8aa3b, v15, -v19
	v_rndne_f32_e32 v21, v19
	v_and_b32_e32 v16, 0xffff0000, v16
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2b17218, v14
	v_fmac_f32_e32 v13, 0xb2a5705f, v15
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_2) | instid1(VALU_DEP_1)
	v_sub_f32_e32 v19, v19, v21
	s_wait_alu depctr_va_vcc(0)
	v_dual_cndmask_b32 v11, 0x7f800000, v10 :: v_dual_add_nc_u32 v10, 4, v9
	v_dual_mul_f32 v22, 0xbfb8aa3b, v16 :: v_dual_add_f32 v23, 1.0, v11
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_ashrrev_i32_e32 v11, 31, v10
	v_fma_f32 v24, 0xbfb8aa3b, v16, -v22
	v_add_f32_e32 v13, v19, v13
	v_rndne_f32_e32 v28, v22
	v_div_scale_f32 v19, null, v23, v23, v14
	v_lshlrev_b64_e32 v[10:11], 1, v[10:11]
	v_fmac_f32_e32 v24, 0xb2a5705f, v16
	v_exp_f32_e32 v13, v13
	v_mul_f32_e32 v12, v12, v5
	v_cvt_i32_f32_e32 v5, v21
	v_rcp_f32_e32 v29, v19
	v_add_co_u32 v10, vcc_lo, s18, v10
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v11, null, s19, v11, vcc_lo
	v_cmp_nlt_f32_e32 vcc_lo, 0x42ce8ed0, v15
	s_delay_alu instid0(TRANS32_DEP_2) | instskip(SKIP_1) | instid1(TRANS32_DEP_1)
	v_ldexp_f32 v5, v13, v5
	v_sub_f32_e32 v22, v22, v28
	v_fma_f32 v13, -v19, v29, 1.0
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_cndmask_b32_e32 v5, 0, v5, vcc_lo
	v_add_f32_e32 v21, v22, v24
	v_div_scale_f32 v24, vcc_lo, v14, v23, v14
	v_fmac_f32_e32 v29, v13, v29
	v_cvt_i32_f32_e32 v13, v28
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v5, 0x7f800000, v5, s3
	v_exp_f32_e32 v21, v21
	v_cmp_nlt_f32_e64 s3, 0x42ce8ed0, v16
	v_mul_f32_e32 v28, v24, v29
	v_bfe_u32 v22, v12, 16, 1
	v_add_f32_e32 v34, 1.0, v5
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_fma_f32 v35, -v19, v28, v24
	v_add3_u32 v22, v22, v12, 0x7fff
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_ldexp_f32 v13, v21, v13
	v_div_scale_f32 v36, null, v34, v34, v15
	v_or_b32_e32 v21, 0x400000, v12
	v_fmac_f32_e32 v28, v35, v29
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v5, 0, v13, s3
	v_bfe_u32 v13, v6, 16, 1
	v_cmp_ngt_f32_e64 s3, 0xc2b17218, v16
	v_rcp_f32_e32 v35, v36
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add3_u32 v13, v13, v6, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v5, 0x7f800000, v5, s3
	v_cmp_u_f32_e64 s3, v6, v6
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(TRANS32_DEP_1)
	v_cndmask_b32_e64 v6, v13, v37, s3
	v_fma_f32 v13, -v19, v28, v24
	v_fma_f32 v24, -v36, v35, 1.0
	v_cmp_u_f32_e64 s3, v12, v12
	v_or_b32_e32 v37, 0x400000, v7
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v13, v13, v29, v28
	v_dual_fmac_f32 v35, v24, v35 :: v_dual_and_b32 v28, 0xffff0000, v6
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v21, v22, v21, s3
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_2) | instid1(VALU_DEP_2)
	v_div_fixup_f32 v13, v13, v23, v14
	v_div_scale_f32 v14, vcc_lo, v15, v34, v15
	v_bfe_u32 v23, v7, 16, 1
	v_dual_mul_f32 v12, v13, v28 :: v_dual_mul_f32 v13, v14, v35
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_add3_u32 v23, v23, v7, 0x7fff
	v_fma_f32 v28, -v36, v13, v14
	v_add_f32_e32 v38, 1.0, v5
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_4)
	v_cndmask_b32_e64 v7, v23, v37, s4
	v_bfe_u32 v23, v8, 16, 1
	v_fmac_f32_e32 v13, v28, v35
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_div_scale_f32 v19, null, v38, v38, v16
	v_add3_u32 v23, v23, v8, 0x7fff
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_fma_f32 v14, -v36, v13, v14
	v_rcp_f32_e32 v29, v19
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_1)
	v_div_fmas_f32 v13, v14, v35, v13
	v_and_b32_e32 v14, 0xffff0000, v7
	v_or_b32_e32 v35, 0x400000, v8
	v_cmp_u_f32_e32 vcc_lo, v8, v8
	v_add_nc_u32_e32 v7, 6, v9
	v_div_fixup_f32 v13, v13, v34, v15
	v_add_nc_u32_e32 v5, 5, v9
	v_fma_f32 v22, -v19, v29, 1.0
	v_bfe_u32 v24, v12, 16, 1
	v_ashrrev_i32_e32 v8, 31, v7
	v_mul_f32_e32 v14, v13, v14
	v_ashrrev_i32_e32 v6, 31, v5
	v_fmac_f32_e32 v29, v22, v29
	v_add3_u32 v24, v24, v12, 0x7fff
	v_or_b32_e32 v13, 0x400000, v12
	v_lshlrev_b64_e32 v[7:8], 1, v[7:8]
	v_lshlrev_b64_e32 v[5:6], 1, v[5:6]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v5, s3, s18, v5
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v6, null, s19, v6, s3
	v_div_scale_f32 v22, s3, v16, v38, v16
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v28, v22, v29
	v_fma_f32 v36, -v19, v28, v22
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fmac_f32_e32 v28, v36, v29
	v_fma_f32 v15, -v19, v28, v22
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v19, v23, v35, vcc_lo
	s_mov_b32 vcc_lo, s3
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_4) | instid1(VALU_DEP_3)
	v_and_b32_e32 v19, 0xffff0000, v19
	s_wait_alu depctr_sa_sdst(0)
	v_div_fmas_f32 v15, v15, v29, v28
	v_cmp_u_f32_e32 vcc_lo, v12, v12
	v_add_nc_u32_e32 v12, 7, v9
	v_div_fixup_f32 v15, v15, v38, v16
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v22, v24, v13, vcc_lo
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_3) | instid1(VALU_DEP_4)
	v_ashrrev_i32_e32 v13, 31, v12
	v_bfe_u32 v16, v14, 16, 1
	v_add_co_u32 v7, vcc_lo, s18, v7
	v_mul_f32_e32 v9, v15, v19
	v_lshlrev_b64_e32 v[12:13], 1, v[12:13]
	s_delay_alu instid0(VALU_DEP_4)
	v_add3_u32 v15, v16, v14, 0x7fff
	v_or_b32_e32 v16, 0x400000, v14
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v8, null, s19, v8, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v14, v14
	v_bfe_u32 v19, v9, 16, 1
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v14, v15, v16, vcc_lo
	v_add_co_u32 v12, vcc_lo, s18, v12
	s_delay_alu instid0(VALU_DEP_3)
	v_add3_u32 v15, v19, v9, 0x7fff
	v_or_b32_e32 v16, 0x400000, v9
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v13, null, s19, v13, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v9, v9
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v9, v15, v16, vcc_lo
	s_clause 0x6
	global_store_d16_hi_b16 v[1:2], v20, off offset:1028
	global_store_b32 v[1:2], v17, off offset:1024
	global_store_d16_hi_b16 v[3:4], v18, off offset:1024
	global_store_d16_hi_b16 v[10:11], v21, off offset:1024
	global_store_d16_hi_b16 v[5:6], v22, off offset:1024
	global_store_d16_hi_b16 v[7:8], v14, off offset:1024
	global_store_d16_hi_b16 v[12:13], v9, off offset:1024
	s_branch .LBB0_181
.LBB0_188:
	s_mov_b32 s7, -1
.LBB0_189:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s6, s7, exec_lo
	s_cselect_b32 s6, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s6, 1
	s_cbranch_scc1 .LBB0_193
	v_dual_mov_b32 v1, 1 :: v_dual_mov_b32 v2, 0
	s_mov_b32 s6, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v1, v2, v[1:2], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_192
	v_dual_mov_b32 v4, ttmp9 :: v_dual_mov_b32 v3, 2
	v_mov_b32_e32 v5, s3
	global_store_b96 v2, v[3:5], s[22:23] offset:4
.LBB0_192:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
.LBB0_193:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s4, s4
	s_cbranch_execz .LBB0_195
	s_add_co_i32 s3, s3, 1
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v1, 0 :: v_dual_mov_b32 v2, s3
	global_store_b32 v1, v1, s[20:21] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v1, v2, s[20:21] offset:4 scope:SCOPE_DEV
.LBB0_195:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	v_mov_b32_e32 v1, 0
	global_load_b32 v2, v1, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, 0, v2
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e64 v2, 0, 1, vcc_lo
	ds_store_b32 v1, v2 offset:20
.LBB0_196:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s1
	s_wait_storecnt 0x0
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	v_mov_b32_e32 v1, 0
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	ds_load_b32 v1, v1 offset:20
	s_wait_dscnt 0x0
	v_cmp_eq_u32_e32 vcc_lo, 0, v1
	s_cbranch_vccnz .LBB0_350
	s_cmp_gt_i32 s5, 1
	s_cbranch_scc1 .LBB0_204
	v_mov_b32_e32 v1, 0
	v_lshlrev_b32_e32 v15, 5, v30
	v_cmp_gt_i32_e32 vcc_lo, s36, v30
	global_load_b64 v[1:2], v1, s[28:29] offset:24
	v_lshl_or_b32 v3, v31, 1, v15
	s_wait_loadcnt 0x0
	v_add_co_u32 v16, s1, 0x200, v1
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v17, null, 0, v2, s1
	v_add_co_u32 v13, s1, s18, v3
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v14, null, s19, 0, s1
	s_branch .LBB0_200
.LBB0_199:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
	s_add_co_i32 s1, s5, 16
	s_cmp_lt_i32 s5, -14
	s_wait_alu depctr_sa_sdst(0)
	s_mov_b32 s5, s1
	s_cbranch_scc0 .LBB0_204
.LBB0_200:
	v_dual_mov_b32 v9, 0 :: v_dual_mov_b32 v10, 0
	v_dual_mov_b32 v11, 0 :: v_dual_mov_b32 v12, 0
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_202
	global_load_b128 v[9:12], v[13:14], off offset:1024
.LBB0_202:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s1
	s_lshl_b32 s4, s5, 4
	s_wait_alu depctr_sa_sdst(0)
	v_or_b32_e32 v1, s4, v30
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshl_or_b32 v1, v1, 4, v31
	v_ashrrev_i32_e32 v2, 31, v1
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshlrev_b64_e32 v[1:2], 1, v[1:2]
	v_add_co_u32 v1, s1, s12, v1
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_add_co_ci_u32_e64 v2, null, s13, v2, s1
	global_load_b128 v[18:21], v[1:2], off
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[1:8], v[18:21], v[9:12], 0
	s_and_saveexec_b32 s3, vcc_lo
	s_cbranch_execz .LBB0_199
	v_or_b32_e32 v9, s4, v31
	s_delay_alu instid0(VALU_DEP_2)
	v_bfe_u32 v10, v1, 16, 1
	v_or_b32_e32 v11, 0x400000, v1
	v_bfe_u32 v12, v2, 16, 1
	v_cmp_u_f32_e64 s1, v1, v1
	v_add_nc_u32_e32 v9, v9, v15
	v_add3_u32 v21, v10, v1, 0x7fff
	v_or_b32_e32 v18, 0x400000, v2
	v_add3_u32 v12, v12, v2, 0x7fff
	v_bfe_u32 v19, v3, 16, 1
	v_ashrrev_i32_e32 v10, 31, v9
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v1, v21, v11, s1
	v_cmp_u_f32_e64 s1, v2, v2
	v_or_b32_e32 v20, 0x400000, v3
	v_add3_u32 v11, v19, v3, 0x7fff
	v_lshlrev_b64_e32 v[9:10], 1, v[9:10]
	v_bfe_u32 v22, v4, 16, 1
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v2, v12, v18, s1
	v_or_b32_e32 v18, 0x400000, v4
	v_bfe_u32 v19, v5, 16, 1
	v_bfe_u32 v21, v7, 16, 1
	v_add_co_u32 v9, s1, v16, v9
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v10, null, v17, v10, s1
	v_cmp_u_f32_e64 s1, v3, v3
	v_add3_u32 v12, v22, v4, 0x7fff
	v_or_b32_e32 v22, 0x400000, v8
	v_lshrrev_b32_e32 v1, 16, v1
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v3, v11, v20, s1
	v_lshrrev_b32_e32 v11, 16, v2
	v_cmp_u_f32_e64 s1, v4, v4
	v_or_b32_e32 v20, 0x400000, v6
	s_delay_alu instid0(VALU_DEP_4)
	v_lshrrev_b32_e32 v2, 16, v3
	v_bfe_u32 v3, v6, 16, 1
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v4, v12, v18, s1
	v_bfe_u32 v18, v8, 16, 1
	v_cmp_u_f32_e64 s1, v6, v6
	v_add3_u32 v12, v19, v5, 0x7fff
	v_add3_u32 v3, v3, v6, 0x7fff
	v_or_b32_e32 v19, 0x400000, v5
	v_add3_u32 v18, v18, v8, 0x7fff
	v_add3_u32 v6, v21, v7, 0x7fff
	v_mov_b16_e32 v1.h, v11.l
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v3, v3, v20, s1
	v_cmp_u_f32_e64 s1, v8, v8
	v_or_b32_e32 v20, 0x400000, v7
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_2) | instid1(VALU_DEP_1)
	v_cndmask_b32_e64 v8, v18, v22, s1
	v_cmp_u_f32_e64 s1, v5, v5
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v5, v12, v19, s1
	v_cmp_u_f32_e64 s1, v7, v7
	v_lshrrev_b32_e32 v7, 16, v8
	v_lshrrev_b32_e32 v8, 16, v3
	v_lshrrev_b32_e32 v12, 16, v4
	v_lshrrev_b32_e32 v3, 16, v5
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v6, v6, v20, s1
	v_mov_b16_e32 v3.h, v8.l
	v_mov_b16_e32 v2.h, v12.l
	s_delay_alu instid0(VALU_DEP_3)
	v_lshrrev_b32_e32 v4, 16, v6
	v_mov_b16_e32 v4.h, v7.l
	global_store_b128 v[9:10], v[1:4], off
	s_branch .LBB0_199
.LBB0_204:
	s_cmp_eq_u32 ttmp9, s42
	s_cbranch_scc1 .LBB0_350
	v_mov_b32_e32 v3, 0
	global_load_b64 v[1:2], v3, s[28:29] offset:24
	s_wait_loadcnt 0x0
	global_load_b32 v4, v[1:2], off offset:256 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	s_barrier_signal -1
	v_readfirstlane_b32 s3, v4
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s1, s2
	s_cbranch_execz .LBB0_220
	global_load_b32 v4, v3, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	s_mov_b32 s5, exec_lo
	s_mov_b32 s6, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	v_mbcnt_lo_u32_b32 v3, s5, 0
	v_readfirstlane_b32 s4, v4
	s_delay_alu instid0(VALU_DEP_2)
	v_cmpx_eq_u32_e32 0, v3
	s_cbranch_execz .LBB0_208
	s_bcnt1_i32_b32 s5, s5
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v4, 0 :: v_dual_mov_b32 v5, s5
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v4, v4, v5, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_208:
	s_or_b32 exec_lo, exec_lo, s6
	v_readfirstlane_b32 s5, v4
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v3, s5, v3
	s_mov_b32 s5, exec_lo
	v_cmpx_ne_u32_e32 3, v3
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s5, exec_lo, s5
	s_cbranch_execz .LBB0_217
	s_cmp_lt_i32 s38, 1
	s_mov_b32 s6, 1
	s_cbranch_scc1 .LBB0_212
	v_mov_b32_e32 v3, 0
.LBB0_211:
	global_load_b32 v4, v3, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	global_load_b32 v5, v3, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s7, v4
	v_readfirstlane_b32 s8, v5
	s_cmp_eq_u32 s7, s4
	s_cselect_b32 s7, -1, 0
	s_cmp_eq_u32 s8, 0
	s_cselect_b32 s8, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s7, s7, s8
	s_cmp_lt_i32 s6, s38
	s_cselect_b32 s8, -1, 0
	s_add_co_i32 s6, s6, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s8, s7, s8
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s8
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_211
	s_branch .LBB0_213
.LBB0_212:
	s_mov_b32 s7, -1
.LBB0_213:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s6, s7, exec_lo
	s_cselect_b32 s6, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s6, 1
	s_cbranch_scc1 .LBB0_217
	v_dual_mov_b32 v3, 1 :: v_dual_mov_b32 v4, 0
	s_mov_b32 s6, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v3, v4, v[3:4], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v3
	s_cbranch_execz .LBB0_216
	v_dual_mov_b32 v6, ttmp9 :: v_dual_mov_b32 v5, 20
	v_mov_b32_e32 v7, s4
	global_store_b96 v4, v[5:7], s[22:23] offset:4
.LBB0_216:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
.LBB0_217:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s5, s5
	s_cbranch_execz .LBB0_219
	s_add_co_i32 s4, s4, 1
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v3, 0 :: v_dual_mov_b32 v4, s4
	global_store_b32 v3, v3, s[20:21] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v3, v4, s[20:21] offset:4 scope:SCOPE_DEV
.LBB0_219:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s5
	v_mov_b32_e32 v3, 0
	global_load_b32 v4, v3, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, 0, v4
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e64 v4, 0, 1, vcc_lo
	ds_store_b32 v3, v4 offset:20
.LBB0_220:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s1
	s_wait_storecnt 0x0
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	v_mov_b32_e32 v3, 0
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	ds_load_b32 v3, v3 offset:20
	s_wait_dscnt 0x0
	v_cmp_eq_u32_e32 vcc_lo, 0, v3
	s_cbranch_vccnz .LBB0_350
	v_or_b32_e32 v0, ttmp9, v0
	s_add_co_i32 s3, s3, 1
	s_delay_alu instid0(VALU_DEP_1)
	v_cmp_eq_u32_e64 s1, 0, v0
	s_and_saveexec_b32 s4, s1
	s_cbranch_execz .LBB0_258
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v0, s3
	s_cmp_gt_i32 s38, 0
	s_cselect_b32 s5, -1, 0
	s_cmp_lt_i32 s38, 1
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[1:2], v0, off scope:SCOPE_SYS
	s_cbranch_scc1 .LBB0_226
	v_mov_b32_e32 v0, 0
	s_mov_b32 s6, 1
	global_load_b64 v[3:4], v0, s[28:29]
.LBB0_224:
	s_wait_loadcnt 0x0
	global_load_b32 v5, v[3:4], off scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v6, v[3:4], off offset:384 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v7, v0, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s9, v5
	v_readfirstlane_b32 s8, v6
	v_readfirstlane_b32 s7, v7
	s_or_b32 s7, s7, s8
	s_cmp_lg_u32 s9, s3
	s_cselect_b32 s8, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s6, s38
	s_cselect_b32 s9, -1, 0
	s_cmp_eq_u32 s7, 0
	s_cselect_b32 s10, -1, 0
	s_add_co_i32 s6, s6, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s9, s10, s9
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s9, s8, s9
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s9
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_224
	s_cmp_lg_u32 s7, 0
	s_cselect_b32 s6, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s6, s8, s6
	s_branch .LBB0_227
.LBB0_226:
	s_mov_b32 s6, -1
.LBB0_227:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s6, s6, exec_lo
	s_cselect_b32 s6, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s6, 1
	s_cbranch_scc1 .LBB0_231
	v_dual_mov_b32 v3, 1 :: v_dual_mov_b32 v4, 0
	s_mov_b32 s6, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v0, v4, v[3:4], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_230
	v_dual_mov_b32 v5, 30 :: v_dual_mov_b32 v6, v4
	v_mov_b32_e32 v7, s3
	global_store_b96 v4, v[5:7], s[22:23] offset:4
.LBB0_230:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[1:2], v3, off offset:384 scope:SCOPE_SYS
.LBB0_231:
	s_and_b32 s6, s5, exec_lo
	s_cselect_b32 s6, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s6, 1
	s_cbranch_scc1 .LBB0_235
	v_mov_b32_e32 v0, 0
	s_mov_b32 s6, 1
	global_load_b64 v[3:4], v0, s[28:29] offset:8
.LBB0_233:
	s_wait_loadcnt 0x0
	global_load_b32 v5, v[3:4], off scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v6, v[3:4], off offset:384 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v7, v0, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s9, v5
	v_readfirstlane_b32 s8, v6
	v_readfirstlane_b32 s7, v7
	s_or_b32 s7, s7, s8
	s_cmp_lg_u32 s9, s3
	s_cselect_b32 s8, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s6, s38
	s_cselect_b32 s9, -1, 0
	s_cmp_eq_u32 s7, 0
	s_cselect_b32 s10, -1, 0
	s_add_co_i32 s6, s6, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s9, s10, s9
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s9, s8, s9
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s9
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_233
	s_cmp_lg_u32 s7, 0
	s_cselect_b32 s6, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s6, s8, s6
	s_branch .LBB0_236
.LBB0_235:
	s_mov_b32 s6, -1
.LBB0_236:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s6, s6, exec_lo
	s_cselect_b32 s6, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s6, 1
	s_cbranch_scc1 .LBB0_240
	v_dual_mov_b32 v3, 1 :: v_dual_mov_b32 v4, 0
	s_mov_b32 s6, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v0, v4, v[3:4], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_239
	v_dual_mov_b32 v5, 30 :: v_dual_mov_b32 v6, v4
	v_mov_b32_e32 v7, s3
	global_store_b96 v4, v[5:7], s[22:23] offset:4
.LBB0_239:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[1:2], v3, off offset:384 scope:SCOPE_SYS
.LBB0_240:
	s_and_b32 s6, s5, exec_lo
	s_cselect_b32 s6, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s6, 1
	s_cbranch_scc1 .LBB0_244
	v_mov_b32_e32 v0, 0
	s_mov_b32 s6, 1
	global_load_b64 v[3:4], v0, s[28:29] offset:16
.LBB0_242:
	s_wait_loadcnt 0x0
	global_load_b32 v5, v[3:4], off scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v6, v[3:4], off offset:384 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v7, v0, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s9, v5
	v_readfirstlane_b32 s8, v6
	v_readfirstlane_b32 s7, v7
	s_or_b32 s7, s7, s8
	s_cmp_lg_u32 s9, s3
	s_cselect_b32 s8, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s6, s38
	s_cselect_b32 s9, -1, 0
	s_cmp_eq_u32 s7, 0
	s_cselect_b32 s10, -1, 0
	s_add_co_i32 s6, s6, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s9, s10, s9
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s9, s8, s9
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s9
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_242
	s_cmp_lg_u32 s7, 0
	s_cselect_b32 s6, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s6, s8, s6
	s_branch .LBB0_245
.LBB0_244:
	s_mov_b32 s6, -1
.LBB0_245:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s6, s6, exec_lo
	s_cselect_b32 s6, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s6, 1
	s_cbranch_scc1 .LBB0_249
	v_dual_mov_b32 v3, 1 :: v_dual_mov_b32 v4, 0
	s_mov_b32 s6, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v0, v4, v[3:4], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_248
	v_dual_mov_b32 v5, 30 :: v_dual_mov_b32 v6, v4
	v_mov_b32_e32 v7, s3
	global_store_b96 v4, v[5:7], s[22:23] offset:4
.LBB0_248:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[1:2], v3, off offset:384 scope:SCOPE_SYS
.LBB0_249:
	s_and_b32 s5, s5, exec_lo
	s_cselect_b32 s5, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s5, 1
	s_cbranch_scc1 .LBB0_253
	v_mov_b32_e32 v0, 0
	s_mov_b32 s5, 1
	global_load_b64 v[3:4], v0, s[28:29] offset:24
.LBB0_251:
	s_wait_loadcnt 0x0
	global_load_b32 v5, v[3:4], off scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v6, v[3:4], off offset:384 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v7, v0, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s8, v5
	v_readfirstlane_b32 s7, v6
	v_readfirstlane_b32 s6, v7
	s_or_b32 s6, s6, s7
	s_cmp_lg_u32 s8, s3
	s_cselect_b32 s7, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s5, s38
	s_cselect_b32 s8, -1, 0
	s_cmp_eq_u32 s6, 0
	s_cselect_b32 s9, -1, 0
	s_add_co_i32 s5, s5, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s8, s9, s8
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s8, s7, s8
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s8
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_251
	s_cmp_lg_u32 s6, 0
	s_cselect_b32 s5, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s5, s7, s5
	s_branch .LBB0_254
.LBB0_253:
	s_mov_b32 s5, -1
.LBB0_254:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s5, s5, exec_lo
	s_cselect_b32 s5, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s5, 1
	s_cbranch_scc1 .LBB0_258
	v_dual_mov_b32 v3, 1 :: v_dual_mov_b32 v4, 0
	s_mov_b32 s5, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v0, v4, v[3:4], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_257
	v_dual_mov_b32 v5, 30 :: v_dual_mov_b32 v6, v4
	v_mov_b32_e32 v7, s3
	global_store_b96 v4, v[5:7], s[22:23] offset:4
.LBB0_257:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s5
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[1:2], v3, off offset:384 scope:SCOPE_SYS
.LBB0_258:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s4, s2
	s_cbranch_execz .LBB0_273
	v_mov_b32_e32 v3, 0
	s_mov_b32 s6, exec_lo
	s_mov_b32 s7, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	v_mbcnt_lo_u32_b32 v0, s6, 0
	global_load_b32 v4, v3, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s5, v4
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_261
	s_bcnt1_i32_b32 s6, s6
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v4, s6
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v4, v3, v4, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_261:
	s_or_b32 exec_lo, exec_lo, s7
	v_readfirstlane_b32 s6, v4
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v0, s6, v0
	s_mov_b32 s6, exec_lo
	v_cmpx_ne_u32_e32 3, v0
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s6, exec_lo, s6
	s_cbranch_execz .LBB0_270
	s_cmp_lt_i32 s38, 1
	s_mov_b32 s7, 1
	s_cbranch_scc1 .LBB0_265
	v_mov_b32_e32 v0, 0
.LBB0_264:
	global_load_b32 v3, v0, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	global_load_b32 v4, v0, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s8, v3
	v_readfirstlane_b32 s9, v4
	s_cmp_eq_u32 s8, s5
	s_cselect_b32 s8, -1, 0
	s_cmp_eq_u32 s9, 0
	s_cselect_b32 s9, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s8, s8, s9
	s_cmp_lt_i32 s7, s38
	s_cselect_b32 s9, -1, 0
	s_add_co_i32 s7, s7, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s9, s8, s9
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s9
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_264
	s_branch .LBB0_266
.LBB0_265:
	s_mov_b32 s8, -1
.LBB0_266:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s7, s8, exec_lo
	s_cselect_b32 s7, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s7, 1
	s_cbranch_scc1 .LBB0_270
	v_dual_mov_b32 v3, 1 :: v_dual_mov_b32 v4, 0
	s_mov_b32 s7, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v0, v4, v[3:4], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_269
	v_dual_mov_b32 v6, ttmp9 :: v_dual_mov_b32 v5, 21
	v_mov_b32_e32 v7, s5
	global_store_b96 v4, v[5:7], s[22:23] offset:4
.LBB0_269:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s7
.LBB0_270:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s6, s6
	s_cbranch_execz .LBB0_272
	s_add_co_i32 s5, s5, 1
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v0, 0 :: v_dual_mov_b32 v3, s5
	global_store_b32 v0, v0, s[20:21] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v0, v3, s[20:21] offset:4 scope:SCOPE_DEV
.LBB0_272:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
	v_mov_b32_e32 v0, 0
	global_load_b32 v3, v0, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, 0, v3
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e64 v3, 0, 1, vcc_lo
	ds_store_b32 v0, v3 offset:20
.LBB0_273:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	s_wait_storecnt 0x0
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	v_mov_b32_e32 v0, 0
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	ds_load_b32 v0, v0 offset:20
	s_wait_dscnt 0x0
	v_cmp_eq_u32_e32 vcc_lo, 0, v0
	s_cbranch_vccnz .LBB0_350
	s_and_saveexec_b32 s4, s0
	s_cbranch_execz .LBB0_279
	v_mov_b32_e32 v0, 0
	s_cmp_lg_u32 s41, 0
	s_mov_b32 s5, 0
	s_cselect_b32 s6, -1, 0
	s_branch .LBB0_277
.LBB0_276:
	v_add_nc_u32_e32 v25, 0x200, v25
	v_add_co_u32 v3, s0, s14, v3
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v4, null, s15, v4, s0
	s_delay_alu instid0(VALU_DEP_3)
	v_cmp_le_i32_e32 vcc_lo, s33, v25
	global_store_b16 v[3:4], v5, off
	s_or_b32 s5, vcc_lo, s5
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_b32 exec_lo, exec_lo, s5
	s_cbranch_execz .LBB0_279
.LBB0_277:
	s_clause 0x1
	global_load_b128 v[5:8], v0, s[28:29]
	global_load_b128 v[9:12], v0, s[28:29] offset:16
	v_ashrrev_i32_e32 v26, 31, v25
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s0, s6, exec_lo
	s_cselect_b32 s0, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s0, 1
	v_lshlrev_b64_e32 v[3:4], 1, v[25:26]
	s_wait_loadcnt 0x1
	v_add_co_u32 v5, vcc_lo, 0x200, v5
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v6, null, 0, v6, vcc_lo
	v_add_co_u32 v7, vcc_lo, 0x200, v7
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v8, null, 0, v8, vcc_lo
	s_wait_loadcnt 0x0
	v_add_co_u32 v9, vcc_lo, 0x200, v9
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v10, null, 0, v10, vcc_lo
	v_add_co_u32 v11, vcc_lo, 0x200, v11
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v12, null, 0, v12, vcc_lo
	v_add_co_u32 v5, vcc_lo, v5, v3
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v6, null, v6, v4, vcc_lo
	v_add_co_u32 v7, vcc_lo, v7, v3
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v8, null, v8, v4, vcc_lo
	global_load_u16 v13, v[5:6], off
	v_add_co_u32 v5, vcc_lo, v9, v3
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v6, null, v10, v4, vcc_lo
	global_load_u16 v9, v[7:8], off
	v_add_co_u32 v7, vcc_lo, v11, v3
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v8, null, v12, v4, vcc_lo
	global_load_u16 v5, v[5:6], off
	global_load_u16 v6, v[7:8], off
	s_wait_loadcnt 0x3
	v_lshlrev_b32_e32 v7, 16, v13
	s_wait_loadcnt 0x2
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_3) | instid1(VALU_DEP_2)
	v_dual_add_f32 v7, 0, v7 :: v_dual_lshlrev_b32 v8, 16, v9
	s_wait_loadcnt 0x1
	v_lshlrev_b32_e32 v5, 16, v5
	s_wait_loadcnt 0x0
	v_dual_add_f32 v7, v7, v8 :: v_dual_lshlrev_b32 v6, 16, v6
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v5, v7, v5
	v_add_f32_e32 v5, v5, v6
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v6, v5, 16, 1
	v_or_b32_e32 v7, 0x400000, v5
	v_cmp_u_f32_e32 vcc_lo, v5, v5
	v_add3_u32 v6, v6, v5, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_cndmask_b32_e32 v5, v6, v7, vcc_lo
	v_lshrrev_b32_e32 v5, 16, v5
	s_cbranch_scc1 .LBB0_276
	v_ashrrev_i32_e32 v6, 31, v25
	v_mov_b16_e32 v8.l, 0
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_lshlrev_b32_e32 v5, 16, v5
	v_lshrrev_b32_e32 v6, 27, v6
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v6, v25, v6
	v_and_b32_e32 v6, 0xffffffe0, v6
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_sub_nc_u32_e32 v6, v25, v6
	v_ashrrev_i32_e32 v7, 31, v6
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshlrev_b64_e32 v[6:7], 1, v[6:7]
	v_add_co_u32 v6, vcc_lo, s30, v6
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_3) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v7, null, s31, v7, vcc_lo
	global_load_d16_hi_b16 v8, v[6:7], off
	s_wait_loadcnt 0x0
	v_add_f32_e32 v6, 1.0, v8
	v_bfe_u32 v7, v6, 16, 1
	v_or_b32_e32 v8, 0x400000, v6
	v_cmp_u_f32_e32 vcc_lo, v6, v6
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v7, v7, v6, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v6, v7, v8, vcc_lo
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_and_b32_e32 v6, 0xffff0000, v6
	v_mul_f32_e32 v5, v6, v5
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v6, v5, 16, 1
	v_or_b32_e32 v7, 0x400000, v5
	v_cmp_u_f32_e32 vcc_lo, v5, v5
	v_add3_u32 v6, v6, v5, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_cndmask_b32_e32 v5, v6, v7, vcc_lo
	v_lshrrev_b32_e32 v5, 16, v5
	s_branch .LBB0_276
.LBB0_279:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_inv scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s0, s2
	s_cbranch_execz .LBB0_294
	v_mov_b32_e32 v3, 0
	s_mov_b32 s5, exec_lo
	s_mov_b32 s6, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	v_mbcnt_lo_u32_b32 v0, s5, 0
	global_load_b32 v4, v3, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s4, v4
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_282
	s_bcnt1_i32_b32 s5, s5
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v4, s5
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v4, v3, v4, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_282:
	s_or_b32 exec_lo, exec_lo, s6
	v_readfirstlane_b32 s5, v4
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v0, s5, v0
	s_mov_b32 s5, exec_lo
	v_cmpx_ne_u32_e32 3, v0
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s5, exec_lo, s5
	s_cbranch_execz .LBB0_291
	s_cmp_lt_i32 s38, 1
	s_mov_b32 s6, 1
	s_cbranch_scc1 .LBB0_286
	v_mov_b32_e32 v0, 0
.LBB0_285:
	global_load_b32 v3, v0, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	global_load_b32 v4, v0, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s7, v3
	v_readfirstlane_b32 s8, v4
	s_cmp_eq_u32 s7, s4
	s_cselect_b32 s7, -1, 0
	s_cmp_eq_u32 s8, 0
	s_cselect_b32 s8, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s7, s7, s8
	s_cmp_lt_i32 s6, s38
	s_cselect_b32 s8, -1, 0
	s_add_co_i32 s6, s6, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s8, s7, s8
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s8
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_285
	s_branch .LBB0_287
.LBB0_286:
	s_mov_b32 s7, -1
.LBB0_287:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s6, s7, exec_lo
	s_cselect_b32 s6, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s6, 1
	s_cbranch_scc1 .LBB0_291
	v_dual_mov_b32 v3, 1 :: v_dual_mov_b32 v4, 0
	s_mov_b32 s6, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v0, v4, v[3:4], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_290
	v_dual_mov_b32 v6, ttmp9 :: v_dual_mov_b32 v5, 22
	v_mov_b32_e32 v7, s4
	global_store_b96 v4, v[5:7], s[22:23] offset:4
.LBB0_290:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
.LBB0_291:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s5, s5
	s_cbranch_execz .LBB0_293
	s_add_co_i32 s4, s4, 1
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v0, 0 :: v_dual_mov_b32 v3, s4
	global_store_b32 v0, v0, s[20:21] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v0, v3, s[20:21] offset:4 scope:SCOPE_DEV
.LBB0_293:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s5
	v_mov_b32_e32 v0, 0
	global_load_b32 v3, v0, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, 0, v3
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e64 v3, 0, 1, vcc_lo
	ds_store_b32 v0, v3 offset:20
.LBB0_294:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s0
	s_wait_storecnt 0x0
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	v_mov_b32_e32 v0, 0
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	ds_load_b32 v0, v0 offset:20
	s_wait_dscnt 0x0
	v_cmp_eq_u32_e32 vcc_lo, 0, v0
	s_cbranch_vccnz .LBB0_350
	s_and_saveexec_b32 s0, s1
	s_cbranch_execz .LBB0_334
	v_mov_b32_e32 v0, s3
	s_cmp_gt_i32 s38, 0
	s_mov_b32 s4, 1
	s_cselect_b32 s1, -1, 0
	s_cmp_lt_i32 s38, 1
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[1:2], v0, off offset:128 scope:SCOPE_SYS
	s_cbranch_scc1 .LBB0_300
	v_mov_b32_e32 v0, 0
	global_load_b64 v[3:4], v0, s[28:29]
.LBB0_298:
	s_wait_loadcnt 0x0
	global_load_b32 v5, v[3:4], off offset:128 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v6, v[3:4], off offset:384 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v7, v0, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s7, v5
	v_readfirstlane_b32 s6, v6
	v_readfirstlane_b32 s5, v7
	s_or_b32 s5, s5, s6
	s_cmp_lg_u32 s7, s3
	s_cselect_b32 s6, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s4, s38
	s_cselect_b32 s7, -1, 0
	s_cmp_eq_u32 s5, 0
	s_cselect_b32 s8, -1, 0
	s_add_co_i32 s4, s4, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s7, s8, s7
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s7, s6, s7
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s7
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_298
	s_cmp_lg_u32 s5, 0
	s_cselect_b32 s4, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s4, s6, s4
	s_branch .LBB0_301
.LBB0_300:
	s_mov_b32 s4, -1
.LBB0_301:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s4, s4, exec_lo
	s_cselect_b32 s4, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s4, 1
	s_cbranch_scc1 .LBB0_305
	v_dual_mov_b32 v3, 1 :: v_dual_mov_b32 v4, 0
	s_mov_b32 s4, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v0, v4, v[3:4], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_304
	v_dual_mov_b32 v5, 31 :: v_dual_mov_b32 v6, v4
	v_mov_b32_e32 v7, s3
	global_store_b96 v4, v[5:7], s[22:23] offset:4
.LBB0_304:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[1:2], v3, off offset:384 scope:SCOPE_SYS
.LBB0_305:
	s_and_b32 s4, s1, exec_lo
	s_cselect_b32 s4, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s4, 1
	s_cbranch_scc1 .LBB0_309
	v_mov_b32_e32 v0, 0
	s_mov_b32 s4, 1
	global_load_b64 v[3:4], v0, s[28:29] offset:8
.LBB0_307:
	s_wait_loadcnt 0x0
	global_load_b32 v5, v[3:4], off offset:128 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v6, v[3:4], off offset:384 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v7, v0, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s7, v5
	v_readfirstlane_b32 s6, v6
	v_readfirstlane_b32 s5, v7
	s_or_b32 s5, s5, s6
	s_cmp_lg_u32 s7, s3
	s_cselect_b32 s6, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s4, s38
	s_cselect_b32 s7, -1, 0
	s_cmp_eq_u32 s5, 0
	s_cselect_b32 s8, -1, 0
	s_add_co_i32 s4, s4, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s7, s8, s7
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s7, s6, s7
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s7
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_307
	s_cmp_lg_u32 s5, 0
	s_cselect_b32 s4, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s4, s6, s4
	s_branch .LBB0_310
.LBB0_309:
	s_mov_b32 s4, -1
.LBB0_310:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s4, s4, exec_lo
	s_cselect_b32 s4, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s4, 1
	s_cbranch_scc1 .LBB0_314
	v_dual_mov_b32 v3, 1 :: v_dual_mov_b32 v4, 0
	s_mov_b32 s4, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v0, v4, v[3:4], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_313
	v_dual_mov_b32 v5, 31 :: v_dual_mov_b32 v6, v4
	v_mov_b32_e32 v7, s3
	global_store_b96 v4, v[5:7], s[22:23] offset:4
.LBB0_313:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[1:2], v3, off offset:384 scope:SCOPE_SYS
.LBB0_314:
	s_and_b32 s4, s1, exec_lo
	s_cselect_b32 s4, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s4, 1
	s_cbranch_scc1 .LBB0_318
	v_mov_b32_e32 v0, 0
	s_mov_b32 s4, 1
	global_load_b64 v[3:4], v0, s[28:29] offset:16
.LBB0_316:
	s_wait_loadcnt 0x0
	global_load_b32 v5, v[3:4], off offset:128 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v6, v[3:4], off offset:384 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v7, v0, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s7, v5
	v_readfirstlane_b32 s6, v6
	v_readfirstlane_b32 s5, v7
	s_or_b32 s5, s5, s6
	s_cmp_lg_u32 s7, s3
	s_cselect_b32 s6, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s4, s38
	s_cselect_b32 s7, -1, 0
	s_cmp_eq_u32 s5, 0
	s_cselect_b32 s8, -1, 0
	s_add_co_i32 s4, s4, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s7, s8, s7
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s7, s6, s7
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s7
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_316
	s_cmp_lg_u32 s5, 0
	s_cselect_b32 s4, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s4, s6, s4
	s_branch .LBB0_319
.LBB0_318:
	s_mov_b32 s4, -1
.LBB0_319:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s4, s4, exec_lo
	s_cselect_b32 s4, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s4, 1
	s_cbranch_scc1 .LBB0_323
	v_dual_mov_b32 v3, 1 :: v_dual_mov_b32 v4, 0
	s_mov_b32 s4, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v0, v4, v[3:4], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_322
	v_dual_mov_b32 v5, 31 :: v_dual_mov_b32 v6, v4
	v_mov_b32_e32 v7, s3
	global_store_b96 v4, v[5:7], s[22:23] offset:4
.LBB0_322:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[1:2], v3, off offset:384 scope:SCOPE_SYS
.LBB0_323:
	s_and_b32 s1, s1, exec_lo
	s_cselect_b32 s1, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s1, 1
	s_cbranch_scc1 .LBB0_327
	v_mov_b32_e32 v0, 0
	s_mov_b32 s1, 1
	global_load_b64 v[3:4], v0, s[28:29] offset:24
.LBB0_325:
	s_wait_loadcnt 0x0
	global_load_b32 v5, v[3:4], off offset:128 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v6, v[3:4], off offset:384 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v7, v0, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s6, v5
	v_readfirstlane_b32 s5, v6
	v_readfirstlane_b32 s4, v7
	s_or_b32 s4, s4, s5
	s_cmp_lg_u32 s6, s3
	s_cselect_b32 s5, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s1, s38
	s_cselect_b32 s6, -1, 0
	s_cmp_eq_u32 s4, 0
	s_cselect_b32 s7, -1, 0
	s_add_co_i32 s1, s1, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s6, s7, s6
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s6, s5, s6
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s6
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_325
	s_cmp_lg_u32 s4, 0
	s_cselect_b32 s1, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s1, s5, s1
	s_branch .LBB0_328
.LBB0_327:
	s_mov_b32 s1, -1
.LBB0_328:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s1, s1, exec_lo
	s_cselect_b32 s1, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s1, 1
	s_cbranch_scc1 .LBB0_332
	v_dual_mov_b32 v3, 1 :: v_dual_mov_b32 v4, 0
	s_mov_b32 s1, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v0, v4, v[3:4], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_331
	v_dual_mov_b32 v5, 31 :: v_dual_mov_b32 v6, v4
	v_mov_b32_e32 v7, s3
	global_store_b96 v4, v[5:7], s[22:23] offset:4
.LBB0_331:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s1
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[1:2], v3, off offset:384 scope:SCOPE_SYS
.LBB0_332:
	v_mov_b32_e32 v0, 0
	global_load_b32 v0, v0, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_ne_u32_e32 vcc_lo, 0, v0
	s_cbranch_vccnz .LBB0_334
	v_mov_b32_e32 v0, s3
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[1:2], v0, off offset:256 scope:SCOPE_SYS
.LBB0_334:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s0
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s0, s2
	s_cbranch_execz .LBB0_349
	v_mov_b32_e32 v1, 0
	s_mov_b32 s3, exec_lo
	s_mov_b32 s4, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	v_mbcnt_lo_u32_b32 v0, s3, 0
	global_load_b32 v2, v1, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s1, v2
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_337
	s_bcnt1_i32_b32 s3, s3
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v2, s3
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v2, v1, v2, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_337:
	s_or_b32 exec_lo, exec_lo, s4
	v_readfirstlane_b32 s3, v2
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v0, s3, v0
	s_mov_b32 s3, exec_lo
	v_cmpx_ne_u32_e32 3, v0
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s3, exec_lo, s3
	s_cbranch_execz .LBB0_346
	s_cmp_lt_i32 s38, 1
	s_mov_b32 s4, 1
	s_cbranch_scc1 .LBB0_341
	v_mov_b32_e32 v0, 0
.LBB0_340:
	global_load_b32 v1, v0, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	global_load_b32 v2, v0, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s5, v1
	v_readfirstlane_b32 s6, v2
	s_cmp_eq_u32 s5, s1
	s_cselect_b32 s5, -1, 0
	s_cmp_eq_u32 s6, 0
	s_cselect_b32 s6, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s5, s5, s6
	s_cmp_lt_i32 s4, s38
	s_cselect_b32 s6, -1, 0
	s_add_co_i32 s4, s4, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s6, s5, s6
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s6
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_340
	s_branch .LBB0_342
.LBB0_341:
	s_mov_b32 s5, -1
.LBB0_342:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s4, s5, exec_lo
	s_cselect_b32 s4, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s4, 1
	s_cbranch_scc1 .LBB0_346
	v_dual_mov_b32 v0, 1 :: v_dual_mov_b32 v1, 0
	s_mov_b32 s4, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v0, v1, v[0:1], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_345
	v_dual_mov_b32 v3, ttmp9 :: v_dual_mov_b32 v2, 23
	v_mov_b32_e32 v4, s1
	global_store_b96 v1, v[2:4], s[22:23] offset:4
.LBB0_345:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
.LBB0_346:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s3, s3
	s_cbranch_execz .LBB0_348
	s_add_co_i32 s1, s1, 1
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v0, 0 :: v_dual_mov_b32 v1, s1
	global_store_b32 v0, v0, s[20:21] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v0, v1, s[20:21] offset:4 scope:SCOPE_DEV
.LBB0_348:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
	v_mov_b32_e32 v0, 0
	global_load_b32 v1, v0, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, 0, v1
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e64 v1, 0, 1, vcc_lo
	ds_store_b32 v0, v1 offset:20
.LBB0_349:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s0
	s_wait_storecnt 0x0
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_350:
	s_and_saveexec_b32 s0, s2
	s_cbranch_execz .LBB0_355
	v_mov_b32_e32 v0, 0
	s_wait_kmcnt 0x0
	global_load_b32 v1, v0, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, 0, v1
	s_cbranch_vccnz .LBB0_353
	global_load_b64 v[1:2], v0, s[24:25] offset:24
	v_mov_b32_e32 v3, 1
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[1:2], v3, off offset:384 scope:SCOPE_SYS
.LBB0_353:
	global_load_b32 v0, v0, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, 0, v0
	s_cbranch_vccnz .LBB0_355
	v_mov_b32_e32 v0, 0
	v_mov_b32_e32 v2, 1
	global_load_b64 v[0:1], v0, s[28:29] offset:24
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[0:1], v2, off offset:384 scope:SCOPE_SYS
.LBB0_355:
	s_endpgm
.Lfunc_end0:
	.size	qwen_bf16_ffnar_v1_h32_i16_b4_tp4r3_a1_f1, .Lfunc_end0-qwen_bf16_ffnar_v1_h32_i16_b4_tp4r3_a1_f1
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel qwen_bf16_ffnar_v1_h32_i16_b4_tp4r3_a1_f1
		.amdhsa_group_segment_fixed_size 24
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 140
		.amdhsa_user_sgpr_count 2
		.amdhsa_user_sgpr_dispatch_ptr 0
		.amdhsa_user_sgpr_queue_ptr 0
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_user_sgpr_dispatch_id 0
		.amdhsa_user_sgpr_private_segment_size 0
		.amdhsa_wavefront_size32 1
		.amdhsa_uses_dynamic_stack 0
		.amdhsa_enable_private_segment 0
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 0
		.amdhsa_system_sgpr_workgroup_id_z 0
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 43
		.amdhsa_next_free_sgpr 44
		.amdhsa_reserve_vcc 1
		.amdhsa_float_round_mode_32 0
		.amdhsa_float_round_mode_16_64 0
		.amdhsa_float_denorm_mode_32 3
		.amdhsa_float_denorm_mode_16_64 3
		.amdhsa_fp16_overflow 0
		.amdhsa_workgroup_processor_mode 1
		.amdhsa_memory_ordered 1
		.amdhsa_forward_progress 1
		.amdhsa_inst_pref_size ((instprefsize(.Lfunc_end0-qwen_bf16_ffnar_v1_h32_i16_b4_tp4r3_a1_f1)<<4)&4080)>>4
		.amdhsa_round_robin_scheduling 0
		.amdhsa_exception_fp_ieee_invalid_op 0
		.amdhsa_exception_fp_denorm_src 0
		.amdhsa_exception_fp_ieee_div_zero 0
		.amdhsa_exception_fp_ieee_overflow 0
		.amdhsa_exception_fp_ieee_underflow 0
		.amdhsa_exception_fp_ieee_inexact 0
		.amdhsa_exception_int_div_zero 0
	.end_amdhsa_kernel
	.text

	.set .Lqwen_bf16_ffnar_v1_h32_i16_b4_tp4r3_a1_f1.num_vgpr, 43
	.set .Lqwen_bf16_ffnar_v1_h32_i16_b4_tp4r3_a1_f1.num_agpr, 0
	.set .Lqwen_bf16_ffnar_v1_h32_i16_b4_tp4r3_a1_f1.numbered_sgpr, 44
	.set .Lqwen_bf16_ffnar_v1_h32_i16_b4_tp4r3_a1_f1.num_named_barrier, 0
	.set .Lqwen_bf16_ffnar_v1_h32_i16_b4_tp4r3_a1_f1.private_seg_size, 0
	.set .Lqwen_bf16_ffnar_v1_h32_i16_b4_tp4r3_a1_f1.uses_vcc, 1
	.set .Lqwen_bf16_ffnar_v1_h32_i16_b4_tp4r3_a1_f1.uses_flat_scratch, 0
	.set .Lqwen_bf16_ffnar_v1_h32_i16_b4_tp4r3_a1_f1.has_dyn_sized_stack, 0
	.set .Lqwen_bf16_ffnar_v1_h32_i16_b4_tp4r3_a1_f1.has_recursion, 0
	.set .Lqwen_bf16_ffnar_v1_h32_i16_b4_tp4r3_a1_f1.has_indirect_call, 0
	.p2alignl 7, 3214868480
	.fill 96, 4, 3214868480
	.section	.AMDGPU.gpr_maximums,"",@progbits
	.set amdgpu.max_num_vgpr, 0
	.set amdgpu.max_num_agpr, 0
	.set amdgpu.max_num_sgpr, 0
	.set amdgpu.max_num_named_barrier, 0
	.text
	.section	".note.GNU-stack","",@progbits
	.amdgpu_metadata
---
amdhsa.kernels:
  - .args:
      - .address_space:  global
        .offset:         0
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .offset:         8
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .offset:         16
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .offset:         24
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .offset:         32
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .offset:         40
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .offset:         48
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .offset:         56
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .offset:         64
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .offset:         72
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .offset:         80
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .offset:         88
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .offset:         96
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .offset:         104
        .size:           8
        .value_kind:     global_buffer
      - .offset:         112
        .size:           4
        .value_kind:     by_value
      - .offset:         116
        .size:           4
        .value_kind:     by_value
      - .offset:         120
        .size:           4
        .value_kind:     by_value
      - .offset:         124
        .size:           4
        .value_kind:     by_value
      - .offset:         128
        .size:           4
        .value_kind:     by_value
      - .offset:         132
        .size:           4
        .value_kind:     by_value
      - .offset:         136
        .size:           4
        .value_kind:     by_value
    .group_segment_fixed_size: 24
    .kernarg_segment_align: 8
    .kernarg_segment_size: 140
    .max_flat_workgroup_size: 128
    .name:           qwen_bf16_ffnar_v1_h32_i16_b4_tp4r3_a1_f1
    .private_segment_fixed_size: 0
    .reqd_workgroup_size:
      - 128
      - 1
      - 1
    .sgpr_count:     46
    .sgpr_spill_count: 0
    .symbol:         qwen_bf16_ffnar_v1_h32_i16_b4_tp4r3_a1_f1.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     43
    .vgpr_spill_count: 0
    .wavefront_size: 32
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1201
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
