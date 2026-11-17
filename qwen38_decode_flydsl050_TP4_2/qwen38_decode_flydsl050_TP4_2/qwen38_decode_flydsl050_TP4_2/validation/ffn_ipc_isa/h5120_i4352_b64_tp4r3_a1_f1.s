	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1201"
	.amdhsa_code_object_version 6
	.text
	.globl	qwen_bf16_ffnar_v1_h5120_i4352_b64_tp4r3_a1_f1
	.p2align	8
	.type	qwen_bf16_ffnar_v1_h5120_i4352_b64_tp4r3_a1_f1,@function
qwen_bf16_ffnar_v1_h5120_i4352_b64_tp4r3_a1_f1:
	s_load_b128 s[36:39], s[0:1], 0x70
	s_wait_kmcnt 0x0
	s_cmp_lt_i32 s36, 1
	s_cbranch_scc1 .LBB0_379
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
	s_cbranch_vccnz .LBB0_374
	s_wait_kmcnt 0x0
	global_load_b64 v[7:8], v1, s[24:25] offset:24
	s_load_b512 s[4:19], s[0:1], 0x0
	v_lshl_or_b32 v28, ttmp9, 7, v0
	s_mul_i32 s33, s36, 0x1400
	s_delay_alu instid0(VALU_DEP_1) | instid1(SALU_CYCLE_1)
	v_cmp_gt_i32_e64 s0, s33, v28
	s_wait_loadcnt 0x0
	global_load_b32 v6, v[7:8], off offset:256 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	s_and_saveexec_b32 s3, s0
	s_cbranch_execz .LBB0_7
	v_add_co_u32 v3, vcc_lo, 0x200, v7
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v4, null, 0, v8, vcc_lo
	v_mov_b32_e32 v1, v28
	s_mov_b32 s34, 0
.LBB0_6:
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v2, 31, v1
	v_lshlrev_b64_e32 v[9:10], 1, v[1:2]
	v_add_nc_u32_e32 v1, 0x2000, v1
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
	v_cmpx_ne_u32_e32 63, v1
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
	v_cmpx_ne_u32_e32 63, v1
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
	v_dual_mov_b32 v6, 0 :: v_dual_mov_b32 v1, v28
	s_cmp_lg_u32 s40, 0
	s_mov_b32 s5, 0
	s_cselect_b32 s34, -1, 0
	s_branch .LBB0_75
.LBB0_74:
	v_add_nc_u32_e32 v1, 0x2000, v1
	v_add_co_u32 v4, s3, s18, v4
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v5, null, s19, v5, s3
	s_delay_alu instid0(VALU_DEP_3)
	v_cmp_le_i32_e32 vcc_lo, s33, v1
	global_store_b16 v[4:5], v2, off offset:303104
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
	v_mul_hi_i32 v9, 0x66666667, v1
	v_mov_b16_e32 v11.l, 0
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_lshlrev_b32_e32 v2, 16, v2
	v_lshrrev_b32_e32 v10, 31, v9
	v_ashrrev_i32_e32 v9, 11, v9
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v9, v9, v10
	v_mul_i32_i24_e32 v9, 0x1400, v9
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
	v_cmpx_ne_u32_e32 63, v1
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
	s_branch .LBB0_374
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
	v_cmpx_ne_u32_e32 63, v1
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
	s_cbranch_vccnz .LBB0_374
.LBB0_145:
	v_lshrrev_b32_e32 v1, 5, v0
	s_cmp_ge_i32 ttmp9, s36
	s_wait_kmcnt 0x0
	s_delay_alu instid0(VALU_DEP_1)
	v_readfirstlane_b32 s5, v1
	s_cbranch_scc1 .LBB0_156
	v_and_b32_e32 v1, 31, v0
	v_dual_mov_b32 v10, 0 :: v_dual_lshlrev_b32 v3, 1, v0
	v_or_b32_e32 v9, 0xfffffe00, v0
	s_mov_b32 s26, ttmp9
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_lshlrev_b32_e32 v2, 2, v1
	v_cmp_gt_u32_e32 vcc_lo, 24, v1
	v_add_nc_u32_e32 v8, 4, v2
	v_add_nc_u32_e32 v7, 8, v2
	v_add_nc_u32_e32 v4, 32, v2
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_2)
	v_dual_cndmask_b32 v5, v2, v4 :: v_dual_add_nc_u32 v6, 16, v2
	v_cmp_gt_u32_e32 vcc_lo, 28, v1
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v6, v2, v6, vcc_lo
	v_cmp_gt_u32_e32 vcc_lo, 30, v1
	v_cmp_eq_u32_e64 s1, 0, v1
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v7, v2, v7, vcc_lo
	v_cmp_ne_u32_e32 vcc_lo, 31, v1
	v_add_co_u32 v1, s3, s8, v3
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v2, null, s9, 0, s3
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v8, 0x7c, v8, vcc_lo
	v_add_co_u32 v1, vcc_lo, 0x200, v1
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v2, null, 0, v2, vcc_lo
	s_lshl_b32 s8, s5, 2
	s_mul_i32 s9, ttmp9, 0x1400
.LBB0_147:
	v_dual_mov_b32 v4, 0 :: v_dual_mov_b32 v3, v0
	s_wait_alu depctr_sa_sdst(0)
	s_mul_i32 s27, s26, 0x1400
	s_mov_b32 s4, 0
.LBB0_148:
	s_wait_alu depctr_sa_sdst(0)
	v_add_nc_u32_e32 v11, s27, v3
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v12, 31, v11
	v_lshlrev_b64_e32 v[12:13], 1, v[11:12]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v14, vcc_lo, s18, v12
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v15, null, s19, v13, vcc_lo
	v_add_co_u32 v16, vcc_lo, s6, v12
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v17, null, s7, v13, vcc_lo
	global_load_u16 v20, v[14:15], off offset:303104
	global_load_u16 v21, v[16:17], off
	v_add_co_u32 v12, vcc_lo, s16, v12
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v13, null, s17, v13, vcc_lo
	s_wait_loadcnt 0x1
	v_lshlrev_b32_e32 v20, 16, v20
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v21, 16, v21
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v20, v20, v21
	v_bfe_u32 v21, v20, 16, 1
	v_or_b32_e32 v22, 0x400000, v20
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v21, v21, v20, 0x7fff
	v_add_nc_u32_e32 v14, 0x80, v11
	v_ashrrev_i32_e32 v15, 31, v14
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshlrev_b64_e32 v[14:15], 1, v[14:15]
	v_add_co_u32 v16, vcc_lo, s18, v14
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_add_co_ci_u32_e64 v17, null, s19, v15, vcc_lo
	v_add_co_u32 v18, vcc_lo, s6, v14
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v19, null, s7, v15, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v20, v20
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v21, v21, v22, vcc_lo
	v_add_co_u32 v14, vcc_lo, s16, v14
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v15, null, s17, v15, vcc_lo
	global_store_d16_hi_b16 v[12:13], v21, off
	global_load_u16 v21, v[16:17], off offset:303104
	global_load_u16 v22, v[18:19], off
	v_add_nc_u32_e32 v12, 0x100, v11
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v13, 31, v12
	v_lshlrev_b64_e32 v[12:13], 1, v[12:13]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v16, vcc_lo, s18, v12
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v17, null, s19, v13, vcc_lo
	v_add_co_u32 v18, vcc_lo, s6, v12
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v19, null, s7, v13, vcc_lo
	s_wait_loadcnt 0x1
	v_lshlrev_b32_e32 v21, 16, v21
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v22, 16, v22
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v21, v21, v22
	v_bfe_u32 v22, v21, 16, 1
	v_or_b32_e32 v23, 0x400000, v21
	v_cmp_u_f32_e32 vcc_lo, v21, v21
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v22, v22, v21, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v22, v22, v23, vcc_lo
	global_store_d16_hi_b16 v[14:15], v22, off
	global_load_u16 v22, v[16:17], off offset:303104
	global_load_u16 v23, v[18:19], off
	v_add_nc_u32_e32 v14, 0x180, v11
	v_add_co_u32 v11, vcc_lo, s16, v12
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v12, null, s17, v13, vcc_lo
	s_wait_loadcnt 0x1
	v_lshlrev_b32_e32 v13, 16, v22
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v22, 16, v23
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_f32_e32 v13, v13, v22
	v_ashrrev_i32_e32 v15, 31, v14
	v_bfe_u32 v22, v13, 16, 1
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_lshlrev_b64_e32 v[14:15], 1, v[14:15]
	v_or_b32_e32 v23, 0x400000, v13
	v_add3_u32 v22, v22, v13, 0x7fff
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_4)
	v_add_co_u32 v16, vcc_lo, s18, v14
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v17, null, s19, v15, vcc_lo
	v_add_co_u32 v18, vcc_lo, s6, v14
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v19, null, s7, v15, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v13, v13
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v22, v22, v23, vcc_lo
	v_cmp_lt_u32_e32 vcc_lo, 0x11ff, v3
	global_store_d16_hi_b16 v[11:12], v22, off
	global_load_u16 v11, v[16:17], off offset:303104
	global_load_u16 v12, v[18:19], off
	v_add_nc_u32_e32 v16, 0x200, v3
	s_or_b32 s4, vcc_lo, s4
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_4) | instid1(VALU_DEP_2)
	v_mov_b32_e32 v3, v16
	s_wait_loadcnt 0x1
	v_dual_mul_f32 v16, v20, v20 :: v_dual_lshlrev_b32 v11, 16, v11
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v12, 16, v12
	v_add_f32_e32 v4, v4, v16
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_dual_add_f32 v16, v11, v12 :: v_dual_mul_f32 v11, v21, v21
	v_mul_f32_e32 v12, v13, v13
	v_bfe_u32 v13, v16, 16, 1
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_2) | instid1(VALU_DEP_4)
	v_add_f32_e32 v4, v4, v11
	v_add_co_u32 v11, s3, s16, v14
	v_or_b32_e32 v14, 0x400000, v16
	v_add3_u32 v13, v13, v16, 0x7fff
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_4) | instid1(VALU_DEP_3)
	v_add_f32_e32 v4, v4, v12
	v_mul_f32_e32 v17, v16, v16
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v12, null, s17, v15, s3
	v_cmp_u_f32_e64 s3, v16, v16
	v_add_f32_e32 v4, v4, v17
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_cndmask_b32_e64 v13, v13, v14, s3
	global_store_d16_hi_b16 v[11:12], v13, off
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_b32 exec_lo, exec_lo, s4
	s_cbranch_execnz .LBB0_148
	s_or_b32 exec_lo, exec_lo, s4
	ds_swizzle_b32 v3, v4 offset:swizzle(BITMASK_PERM,"1pppp")
	s_wait_dscnt 0x0
	v_add_f32_e32 v3, v4, v3
	ds_bpermute_b32 v4, v5, v3
	s_wait_dscnt 0x0
	v_add_f32_e32 v3, v3, v4
	ds_bpermute_b32 v4, v6, v3
	s_wait_dscnt 0x0
	v_add_f32_e32 v3, v3, v4
	ds_bpermute_b32 v4, v7, v3
	s_wait_dscnt 0x0
	v_add_f32_e32 v3, v3, v4
	ds_bpermute_b32 v4, v8, v3
	s_and_saveexec_b32 s3, s1
	s_cbranch_execz .LBB0_151
	s_wait_dscnt 0x0
	v_dual_add_f32 v3, v3, v4 :: v_dual_mov_b32 v4, s8
	ds_store_b32 v4, v3
.LBB0_151:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
	s_wait_storecnt_dscnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s3, s2
	s_cbranch_execz .LBB0_153
	ds_load_b128 v[11:14], v10
	s_wait_dscnt 0x0
	v_add_f32_e32 v3, 0, v11
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v3, v3, v12
	v_add_f32_e32 v3, v3, v13
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v3, v3, v14
	v_div_scale_f32 v4, null, 0x45a00000, 0x45a00000, v3
	v_div_scale_f32 v13, vcc_lo, v3, 0x45a00000, v3
	s_delay_alu instid0(VALU_DEP_2)
	v_rcp_f32_e32 v11, v4
	v_xor_b32_e32 v4, 0x80000000, v4
	s_delay_alu instid0(TRANS32_DEP_1) | instid1(VALU_DEP_1)
	v_fma_f32 v12, v4, v11, 1.0
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fmac_f32_e32 v11, v12, v11
	v_mul_f32_e32 v12, v13, v11
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fma_f32 v14, v4, v12, v13
	v_fmac_f32_e32 v12, v14, v11
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_fmac_f32_e32 v13, v4, v12
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v4, v13, v11, v12
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_div_fixup_f32 v3, v4, 0x45a00000, v3
	v_readfirstlane_b32 s4, v3
	s_add_f32 s4, s37, s4
	s_wait_alu depctr_sa_sdst(0)
	s_delay_alu instid0(SALU_CYCLE_2) | instskip(SKIP_2) | instid1(SALU_CYCLE_1)
	s_mul_f32 s27, s4, 0x4f800000
	s_cmp_lt_f32 s4, 0xf800000
	s_wait_alu depctr_sa_sdst(0)
	s_cselect_b32 s27, s27, s4
	s_wait_alu depctr_sa_sdst(0)
	v_s_sqrt_f32 s34, s27
	s_mov_b32 s39, s27
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_add_co_i32 s35, s34, -1
	s_xor_b32 s40, s35, 0x80000000
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_2)
	s_fmac_f32 s39, s40, s34
	s_mov_b32 s40, s27
	s_cmp_le_f32 s39, 0
	s_cselect_b32 s35, s35, s34
	s_add_co_i32 s39, s34, 1
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_xor_b32 s43, s39, 0x80000000
	s_fmac_f32 s40, s43, s34
	v_cmp_class_f32_e64 s34, s27, 0x260
	s_delay_alu instid0(SALU_CYCLE_2) | instskip(SKIP_4) | instid1(SALU_CYCLE_2)
	s_cmp_gt_f32 s40, 0
	s_cselect_b32 s35, s39, s35
	s_cmp_lt_f32 s4, 0xf800000
	s_mul_f32 s4, s35, 0x37800000
	s_wait_alu depctr_sa_sdst(0)
	s_cselect_b32 s4, s4, s35
	s_and_b32 s34, s34, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	s_cselect_b32 s4, s27, s4
	s_wait_alu depctr_sa_sdst(0)
	v_div_scale_f32 v3, null, s4, s4, 1.0
	s_delay_alu instid0(VALU_DEP_1)
	v_rcp_f32_e32 v4, v3
	v_xor_b32_e32 v3, 0x80000000, v3
	s_delay_alu instid0(TRANS32_DEP_1) | instid1(VALU_DEP_1)
	v_fma_f32 v11, v3, v4, 1.0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_fmac_f32_e32 v4, v11, v4
	v_div_scale_f32 v11, vcc_lo, 1.0, s4, 1.0
	v_mul_f32_e32 v12, v11, v4
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fma_f32 v13, v3, v12, v11
	v_fmac_f32_e32 v12, v13, v4
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_fmac_f32_e32 v11, v3, v12
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v3, v11, v4, v12
	s_delay_alu instid0(VALU_DEP_1)
	v_div_fixup_f32 v3, v3, s4, 1.0
	ds_store_b32 v10, v3 offset:16
.LBB0_153:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	v_dual_mov_b32 v4, v2 :: v_dual_mov_b32 v3, v1
	v_mov_b32_e32 v12, v9
	s_mov_b32 s27, 0
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	ds_load_b32 v11, v10 offset:16
	s_wait_dscnt 0x0
.LBB0_154:
	v_add_nc_u32_e32 v19, s9, v12
	v_add_nc_u32_e32 v12, 0x200, v12
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v13, 0x200, v19
	v_ashrrev_i32_e32 v14, 31, v13
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshlrev_b64_e32 v[13:14], 1, v[13:14]
	v_add_co_u32 v15, vcc_lo, s18, v13
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_add_co_ci_u32_e64 v16, null, s19, v14, vcc_lo
	v_add_co_u32 v13, vcc_lo, s6, v13
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v14, null, s7, v14, vcc_lo
	global_load_u16 v20, v[15:16], off offset:303104
	global_load_u16 v21, v[13:14], off
	global_load_u16 v22, v[3:4], off offset:-512
	s_wait_loadcnt 0x2
	v_lshlrev_b32_e32 v20, 16, v20
	s_wait_loadcnt 0x1
	v_lshlrev_b32_e32 v21, 16, v21
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v22, 16, v22
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_dual_add_f32 v20, v20, v21 :: v_dual_add_nc_u32 v13, 0x280, v19
	v_add_f32_e32 v22, 1.0, v22
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_ashrrev_i32_e32 v14, 31, v13
	v_mul_f32_e32 v20, v11, v20
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_lshlrev_b64_e32 v[13:14], 1, v[13:14]
	v_mul_f32_e32 v20, v20, v22
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_add_co_u32 v17, vcc_lo, s18, v13
	v_bfe_u32 v21, v20, 16, 1
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_4)
	v_add_co_ci_u32_e64 v18, null, s19, v14, vcc_lo
	v_add_co_u32 v13, vcc_lo, s6, v13
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v14, null, s7, v14, vcc_lo
	v_or_b32_e32 v22, 0x400000, v20
	v_add3_u32 v21, v21, v20, 0x7fff
	v_cmp_u_f32_e32 vcc_lo, v20, v20
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_cndmask_b32_e32 v20, v21, v22, vcc_lo
	global_store_d16_hi_b16 v[15:16], v20, off
	global_load_u16 v20, v[17:18], off offset:303104
	global_load_u16 v21, v[13:14], off
	global_load_u16 v22, v[3:4], off offset:-256
	v_add_nc_u32_e32 v13, 0x300, v19
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v14, 31, v13
	v_lshlrev_b64_e32 v[13:14], 1, v[13:14]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v15, vcc_lo, s18, v13
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v16, null, s19, v14, vcc_lo
	v_add_co_u32 v13, vcc_lo, s6, v13
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v14, null, s7, v14, vcc_lo
	s_wait_loadcnt 0x2
	v_lshlrev_b32_e32 v20, 16, v20
	s_wait_loadcnt 0x1
	v_lshlrev_b32_e32 v21, 16, v21
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v22, 16, v22
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_dual_add_f32 v20, v20, v21 :: v_dual_add_f32 v21, 1.0, v22
	v_mul_f32_e32 v20, v11, v20
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v20, v20, v21
	v_bfe_u32 v21, v20, 16, 1
	v_or_b32_e32 v22, 0x400000, v20
	v_cmp_u_f32_e32 vcc_lo, v20, v20
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v21, v21, v20, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v20, v21, v22, vcc_lo
	global_store_d16_hi_b16 v[17:18], v20, off
	global_load_u16 v20, v[15:16], off offset:303104
	global_load_u16 v21, v[13:14], off
	global_load_u16 v22, v[3:4], off
	v_add_nc_u32_e32 v13, 0x380, v19
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v14, 31, v13
	v_lshlrev_b64_e32 v[13:14], 1, v[13:14]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v17, vcc_lo, s18, v13
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v18, null, s19, v14, vcc_lo
	v_add_co_u32 v13, vcc_lo, s6, v13
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v14, null, s7, v14, vcc_lo
	s_wait_loadcnt 0x2
	v_lshlrev_b32_e32 v19, 16, v20
	s_wait_loadcnt 0x1
	v_lshlrev_b32_e32 v20, 16, v21
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v21, 16, v22
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_dual_add_f32 v19, v19, v20 :: v_dual_add_f32 v20, 1.0, v21
	v_mul_f32_e32 v19, v11, v19
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v19, v19, v20
	v_bfe_u32 v20, v19, 16, 1
	v_or_b32_e32 v21, 0x400000, v19
	v_cmp_u_f32_e32 vcc_lo, v19, v19
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v20, v20, v19, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v19, v20, v21, vcc_lo
	v_cmp_lt_u32_e32 vcc_lo, 0x11ff, v12
	global_store_d16_hi_b16 v[15:16], v19, off
	global_load_u16 v15, v[17:18], off offset:303104
	global_load_u16 v13, v[13:14], off
	global_load_u16 v14, v[3:4], off offset:256
	v_add_co_u32 v3, s3, 0x400, v3
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v4, null, 0, v4, s3
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s27, vcc_lo, s27
	s_wait_loadcnt 0x2
	v_lshlrev_b32_e32 v15, 16, v15
	s_wait_loadcnt 0x1
	v_lshlrev_b32_e32 v13, 16, v13
	s_wait_loadcnt 0x0
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_dual_add_f32 v13, v15, v13 :: v_dual_lshlrev_b32 v14, 16, v14
	v_dual_add_f32 v14, 1.0, v14 :: v_dual_mul_f32 v13, v11, v13
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v13, v13, v14
	v_bfe_u32 v14, v13, 16, 1
	v_or_b32_e32 v15, 0x400000, v13
	v_cmp_u_f32_e64 s4, v13, v13
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v14, v14, v13, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v13, v14, v15, s4
	global_store_d16_hi_b16 v[17:18], v13, off
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_b32 exec_lo, exec_lo, s27
	s_cbranch_execnz .LBB0_154
	s_or_b32 exec_lo, exec_lo, s27
	s_wait_storecnt 0x0
	s_barrier_signal -1
	s_add_co_i32 s26, s26, 64
	s_add_co_i32 s9, s9, 0x50000
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s26, s36
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_cbranch_scc1 .LBB0_147
.LBB0_156:
	s_wait_loadcnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s1, s2
	s_cbranch_execz .LBB0_171
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
	s_cbranch_execz .LBB0_159
	s_bcnt1_i32_b32 s4, s4
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v3, s4
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v3, v2, v3, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_159:
	s_or_b32 exec_lo, exec_lo, s6
	v_readfirstlane_b32 s4, v3
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v1, s4, v1
	s_mov_b32 s4, exec_lo
	v_cmpx_ne_u32_e32 63, v1
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s4, exec_lo, s4
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
	s_and_not1_saveexec_b32 s4, s4
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
	s_or_b32 exec_lo, exec_lo, s4
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
	s_cbranch_vccnz .LBB0_374
	v_lshrrev_b32_e32 v1, 1, v0
	s_lshl_b32 s1, ttmp9, 2
	v_and_b32_e32 v33, 15, v0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s5, s1, s5
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_gt_i32 s5, 0x10f
	v_and_b32_e32 v34, 8, v1
	s_cbranch_scc1 .LBB0_189
	v_mul_u32_u24_e32 v1, 0x1400, v33
	v_cmp_gt_i32_e64 s1, s36, v33
	v_mul_u32_u24_e32 v35, 0x1100, v33
	v_mov_b32_e32 v30, 0
	s_mov_b32 s6, s5
	v_or_b32_e32 v36, v1, v34
	s_branch .LBB0_175
.LBB0_174:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s7
	s_add_co_i32 s3, s6, 0x100
	s_cmp_lt_i32 s6, 16
	s_wait_alu depctr_sa_sdst(0)
	s_mov_b32 s6, s3
	s_cbranch_scc0 .LBB0_189
.LBB0_175:
	s_wait_alu depctr_sa_sdst(0)
	s_lshl_b32 s3, s6, 4
	v_dual_mov_b32 v9, v30 :: v_dual_mov_b32 v10, v30
	s_wait_alu depctr_sa_sdst(0)
	v_or_b32_e32 v1, s3, v33
	v_dual_mov_b32 v11, v30 :: v_dual_mov_b32 v12, v30
	v_dual_mov_b32 v13, v30 :: v_dual_mov_b32 v14, v30
	s_delay_alu instid0(VALU_DEP_3)
	v_mul_lo_u32 v5, 0x1400, v1
	v_dual_mov_b32 v15, v30 :: v_dual_mov_b32 v16, v30
	v_dual_mov_b32 v1, v30 :: v_dual_mov_b32 v2, v30
	v_dual_mov_b32 v3, v30 :: v_dual_mov_b32 v4, v30
	v_mov_b32_e32 v6, v30
	v_or_b32_e32 v37, v5, v34
	v_mov_b32_e32 v5, v30
	v_dual_mov_b32 v7, v30 :: v_dual_mov_b32 v8, v30
	s_mov_b32 s4, 0
	s_branch .LBB0_177
.LBB0_176:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s7
	v_add_nc_u32_e32 v21, 64, v31
	s_add_co_i32 s7, s4, 0x50
	s_cmp_lt_u32 s4, 0x13b0
	s_wait_alu depctr_sa_sdst(0)
	s_mov_b32 s4, s7
	v_ashrrev_i32_e32 v22, 31, v21
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshlrev_b64_e32 v[21:22], 1, v[21:22]
	v_add_co_u32 v21, vcc_lo, s10, v21
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_add_co_ci_u32_e64 v22, null, s11, v22, vcc_lo
	v_add_co_u32 v25, vcc_lo, 0x2800000, v21
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_add_co_ci_u32_e64 v26, null, 0, v22, vcc_lo
	s_clause 0x1
	global_load_b128 v[21:24], v[21:22], off
	global_load_b128 v[38:41], v[25:26], off offset:2621440
	s_wait_loadcnt 0x1
	v_wmma_f32_16x16x16_bf16 v[9:16], v[21:24], v[17:20], v[9:16]
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[1:8], v[38:41], v[17:20], v[1:8]
	s_cbranch_scc0 .LBB0_187
.LBB0_177:
	v_dual_mov_b32 v17, 0 :: v_dual_mov_b32 v20, 0
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v22, 0 :: v_dual_add_nc_u32 v29, s4, v36
	v_mov_b32_e32 v21, 0
	v_mov_b32_e32 v23, 0
	s_and_saveexec_b32 s7, s1
	s_cbranch_execz .LBB0_179
	v_lshlrev_b64_e32 v[18:19], 1, v[29:30]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v18, vcc_lo, s18, v18
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v19, null, s19, v19, vcc_lo
	global_load_b128 v[20:23], v[18:19], off
.LBB0_179:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s7
	v_add_nc_u32_e32 v31, s4, v37
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v32, 31, v31
	v_lshlrev_b64_e32 v[18:19], 1, v[31:32]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v18, vcc_lo, s10, v18
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v19, null, s11, v19, vcc_lo
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v38, vcc_lo, 0x2800000, v18
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v39, null, 0, v19, vcc_lo
	s_clause 0x1
	global_load_b128 v[24:27], v[18:19], off
	global_load_b128 v[38:41], v[38:39], off offset:2621440
	v_dual_mov_b32 v18, 0 :: v_dual_mov_b32 v19, 0
	s_wait_loadcnt 0x1
	v_wmma_f32_16x16x16_bf16 v[9:16], v[24:27], v[20:23], v[9:16]
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[1:8], v[38:41], v[20:23], v[1:8]
	v_mov_b32_e32 v20, 0
	s_and_saveexec_b32 s7, s1
	s_cbranch_execz .LBB0_181
	v_lshlrev_b64_e32 v[17:18], 1, v[29:30]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v17, vcc_lo, s18, v17
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v18, null, s19, v18, vcc_lo
	global_load_b128 v[17:20], v[17:18], off offset:32
.LBB0_181:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s7
	v_add_nc_u32_e32 v21, 16, v31
	v_mov_b32_e32 v25, 0
	v_dual_mov_b32 v27, 0 :: v_dual_mov_b32 v26, 0
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v22, 31, v21
	v_lshlrev_b64_e32 v[21:22], 1, v[21:22]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v21, vcc_lo, s10, v21
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v22, null, s11, v22, vcc_lo
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v23, vcc_lo, 0x2800000, v21
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v24, null, 0, v22, vcc_lo
	s_clause 0x1
	global_load_b128 v[38:41], v[21:22], off
	global_load_b128 v[42:45], v[23:24], off offset:2621440
	v_dual_mov_b32 v21, 0 :: v_dual_mov_b32 v24, 0
	s_wait_loadcnt 0x1
	v_wmma_f32_16x16x16_bf16 v[9:16], v[38:41], v[17:20], v[9:16]
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[1:8], v[42:45], v[17:20], v[1:8]
	s_and_saveexec_b32 s7, s1
	s_cbranch_execz .LBB0_183
	v_lshlrev_b64_e32 v[17:18], 1, v[29:30]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v17, vcc_lo, s18, v17
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v18, null, s19, v18, vcc_lo
	global_load_b128 v[24:27], v[17:18], off offset:64
.LBB0_183:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s7
	v_add_nc_u32_e32 v17, 32, v31
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v18, 31, v17
	v_lshlrev_b64_e32 v[17:18], 1, v[17:18]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v17, vcc_lo, s10, v17
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v18, null, s11, v18, vcc_lo
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v22, vcc_lo, 0x2800000, v17
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v23, null, 0, v18, vcc_lo
	s_clause 0x1
	global_load_b128 v[17:20], v[17:18], off
	global_load_b128 v[38:41], v[22:23], off offset:2621440
	v_dual_mov_b32 v22, 0 :: v_dual_mov_b32 v23, 0
	s_wait_loadcnt 0x1
	v_wmma_f32_16x16x16_bf16 v[9:16], v[17:20], v[24:27], v[9:16]
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[1:8], v[38:41], v[24:27], v[1:8]
	v_mov_b32_e32 v24, 0
	s_and_saveexec_b32 s7, s1
	s_cbranch_execz .LBB0_185
	v_lshlrev_b64_e32 v[17:18], 1, v[29:30]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v17, vcc_lo, s18, v17
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v18, null, s19, v18, vcc_lo
	global_load_b128 v[21:24], v[17:18], off offset:96
.LBB0_185:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s7
	v_add_nc_u32_e32 v17, 48, v31
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v18, 31, v17
	v_lshlrev_b64_e32 v[17:18], 1, v[17:18]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v17, vcc_lo, s10, v17
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v18, null, s11, v18, vcc_lo
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v19, vcc_lo, 0x2800000, v17
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v20, null, 0, v18, vcc_lo
	s_clause 0x1
	global_load_b128 v[38:41], v[17:18], off
	global_load_b128 v[42:45], v[19:20], off offset:2621440
	v_dual_mov_b32 v17, 0 :: v_dual_mov_b32 v20, 0
	v_dual_mov_b32 v18, 0 :: v_dual_mov_b32 v19, 0
	s_wait_loadcnt 0x1
	v_wmma_f32_16x16x16_bf16 v[9:16], v[38:41], v[21:24], v[9:16]
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[1:8], v[42:45], v[21:24], v[1:8]
	s_and_saveexec_b32 s7, s1
	s_cbranch_execz .LBB0_176
	v_lshlrev_b64_e32 v[17:18], 1, v[29:30]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v17, vcc_lo, s18, v17
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v18, null, s19, v18, vcc_lo
	global_load_b128 v[17:20], v[17:18], off offset:128
	s_branch .LBB0_176
.LBB0_187:
	s_and_saveexec_b32 s7, s1
	s_cbranch_execz .LBB0_174
	v_bfe_u32 v17, v9, 16, 1
	v_or_b32_e32 v18, 0x400000, v9
	v_bfe_u32 v19, v10, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v9, v9
	v_or_b32_e32 v20, 0x400000, v10
	v_add3_u32 v17, v17, v9, 0x7fff
	v_bfe_u32 v23, v11, 16, 1
	v_add3_u32 v19, v19, v10, 0x7fff
	v_or_b32_e32 v24, 0x400000, v11
	v_bfe_u32 v27, v12, 16, 1
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v9, v17, v18, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	v_add3_u32 v23, v23, v11, 0x7fff
	v_or_b32_e32 v29, 0x400000, v12
	v_add3_u32 v27, v27, v12, 0x7fff
	v_bfe_u32 v17, v1, 16, 1
	s_wait_alu depctr_va_vcc(0)
	v_dual_cndmask_b32 v10, v19, v20 :: v_dual_and_b32 v21, 0xffff0000, v9
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	v_or_b32_e32 v18, 0x400000, v1
	v_add3_u32 v17, v17, v1, 0x7fff
	v_or_b32_e32 v9, s3, v34
	v_mul_f32_e32 v19, 0xbfb8aa3b, v21
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v11, v23, v24, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v12, v12
	v_and_b32_e32 v25, 0xffff0000, v10
	v_bfe_u32 v22, v2, 16, 1
	v_fma_f32 v10, 0xbfb8aa3b, v21, -v19
	v_rndne_f32_e32 v26, v19
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v12, v27, v29, vcc_lo
	v_or_b32_e32 v20, 0x400000, v2
	v_add3_u32 v22, v22, v2, 0x7fff
	v_dual_fmac_f32 v10, 0xb2a5705f, v21 :: v_dual_sub_f32 v19, v19, v26
	v_cvt_i32_f32_e32 v26, v26
	v_cmp_u_f32_e64 s3, v2, v2
	v_bfe_u32 v32, v13, 16, 1
	v_or_b32_e32 v37, 0x400000, v13
	v_add_f32_e32 v10, v19, v10
	v_cmp_nlt_f32_e32 vcc_lo, 0x42ce8ed0, v21
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v20, v22, v20, s3
	v_add3_u32 v32, v32, v13, 0x7fff
	v_and_b32_e32 v12, 0xffff0000, v12
	v_exp_f32_e32 v10, v10
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(TRANS32_DEP_1)
	v_and_b32_e32 v20, 0xffff0000, v20
	v_ldexp_f32 v10, v10, v26
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_2)
	v_cndmask_b32_e32 v10, 0, v10, vcc_lo
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2b17218, v21
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v10, 0x7f800000, v10, vcc_lo
	v_and_b32_e32 v11, 0xffff0000, v11
	v_mul_f32_e32 v31, 0xbfb8aa3b, v25
	v_cmp_u_f32_e32 vcc_lo, v1, v1
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_dual_cndmask_b32 v1, v17, v18 :: v_dual_mul_f32 v18, 0xbfb8aa3b, v11
	v_fma_f32 v38, 0xbfb8aa3b, v25, -v31
	v_rndne_f32_e32 v19, v31
	v_add_nc_u32_e32 v9, v9, v35
	v_cmp_nlt_f32_e32 vcc_lo, 0x42ce8ed0, v25
	v_rndne_f32_e32 v26, v18
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_dual_fmac_f32 v38, 0xb2a5705f, v25 :: v_dual_sub_f32 v31, v31, v19
	v_cvt_i32_f32_e32 v19, v19
	v_add_f32_e32 v31, v31, v38
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(TRANS32_DEP_1)
	v_exp_f32_e32 v23, v31
	v_ldexp_f32 v17, v23, v19
	v_add_f32_e32 v19, 1.0, v10
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_3) | instid1(VALU_DEP_4)
	v_dual_mul_f32 v23, 0xbfb8aa3b, v12 :: v_dual_cndmask_b32 v10, 0, v17
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2b17218, v25
	v_fma_f32 v17, 0xbfb8aa3b, v11, -v18
	v_sub_f32_e32 v18, v18, v26
	v_fma_f32 v29, 0xbfb8aa3b, v12, -v23
	v_rndne_f32_e32 v38, v23
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v10, 0x7f800000, v10, vcc_lo
	v_div_scale_f32 v24, null, v19, v19, v21
	v_fmac_f32_e32 v17, 0xb2a5705f, v11
	v_fmac_f32_e32 v29, 0xb2a5705f, v12
	v_sub_f32_e32 v23, v23, v38
	v_div_scale_f32 v40, vcc_lo, v21, v19, v21
	v_rcp_f32_e32 v27, v24
	v_add_f32_e32 v17, v18, v17
	v_cvt_i32_f32_e32 v26, v26
	v_add_f32_e32 v23, v23, v29
	v_cmp_nlt_f32_e64 s3, 0x42ce8ed0, v11
	v_cvt_i32_f32_e32 v38, v38
	v_exp_f32_e32 v17, v17
	v_cmp_ngt_f32_e64 s4, 0xc2b17218, v11
	s_delay_alu instid0(TRANS32_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fma_f32 v39, -v24, v27, 1.0
	v_fmac_f32_e32 v27, v39, v27
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(TRANS32_DEP_1)
	v_dual_mul_f32 v22, v40, v27 :: v_dual_and_b32 v29, 0xffff0000, v1
	v_ldexp_f32 v1, v17, v26
	v_exp_f32_e32 v17, v23
	s_delay_alu instid0(VALU_DEP_2)
	v_fma_f32 v23, -v24, v22, v40
	v_add_f32_e32 v31, 1.0, v10
	v_ashrrev_i32_e32 v10, 31, v9
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v1, 0, v1, s3
	v_fmac_f32_e32 v22, v23, v27
	v_div_scale_f32 v18, null, v31, v31, v25
	v_div_scale_f32 v26, s3, v25, v31, v25
	s_wait_alu depctr_sa_sdst(0)
	v_cndmask_b32_e64 v23, 0x7f800000, v1, s4
	v_cmp_u_f32_e64 s4, v7, v7
	v_rcp_f32_e32 v41, v18
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fma_f32 v2, -v18, v41, 1.0
	v_fmac_f32_e32 v41, v2, v41
	v_lshlrev_b64_e32 v[1:2], 1, v[9:10]
	v_ldexp_f32 v10, v17, v38
	v_fma_f32 v17, -v24, v22, v40
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_mul_f32_e32 v39, v26, v41
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v17, v17, v27, v22
	v_cmp_nlt_f32_e32 vcc_lo, 0x42ce8ed0, v12
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_fma_f32 v24, -v18, v39, v26
	v_div_fixup_f32 v17, v17, v19, v21
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_dual_cndmask_b32 v10, 0, v10 :: v_dual_fmac_f32 v39, v24, v41
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2b17218, v12
	v_mul_f32_e32 v17, v17, v29
	s_delay_alu instid0(VALU_DEP_3)
	v_fma_f32 v18, -v18, v39, v26
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v10, 0x7f800000, v10, vcc_lo
	s_mov_b32 vcc_lo, s3
	v_bfe_u32 v21, v17, 16, 1
	v_cmp_u_f32_e64 s3, v17, v17
	s_wait_alu depctr_sa_sdst(0)
	v_div_fmas_f32 v18, v18, v41, v39
	v_add_f32_e32 v10, 1.0, v10
	v_add3_u32 v21, v21, v17, 0x7fff
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_div_fixup_f32 v18, v18, v31, v25
	v_or_b32_e32 v25, 0x400000, v17
	v_or_b32_e32 v31, 0x400000, v3
	v_mul_f32_e32 v18, v18, v20
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_3)
	v_cndmask_b32_e64 v17, v21, v25, s3
	v_add_co_u32 v1, s3, s18, v1
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v2, null, s19, v2, s3
	v_cmp_u_f32_e64 s3, v13, v13
	v_div_scale_f32 v20, null, v10, v10, v12
	v_bfe_u32 v25, v3, 16, 1
	v_lshrrev_b32_e32 v17, 16, v17
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v13, v32, v37, s3
	v_rcp_f32_e32 v29, v20
	v_add3_u32 v25, v25, v3, 0x7fff
	v_cmp_u_f32_e64 s3, v3, v3
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_and_b32_e32 v13, 0xffff0000, v13
	v_add_f32_e32 v23, 1.0, v23
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v3, v25, v31, s3
	v_cmp_u_f32_e64 s3, v18, v18
	v_mul_f32_e32 v32, 0xbfb8aa3b, v13
	v_div_scale_f32 v22, null, v23, v23, v11
	v_div_scale_f32 v26, vcc_lo, v11, v23, v11
	v_fma_f32 v25, -v20, v29, 1.0
	v_and_b32_e32 v3, 0xffff0000, v3
	v_rndne_f32_e32 v31, v32
	v_rcp_f32_e32 v19, v22
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_fmac_f32_e32 v29, v25, v29
	v_cvt_i32_f32_e32 v25, v31
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fma_f32 v24, -v22, v19, 1.0
	v_fmac_f32_e32 v19, v24, v19
	v_bfe_u32 v24, v18, 16, 1
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_mul_f32_e32 v21, v26, v19
	v_add3_u32 v24, v24, v18, 0x7fff
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fma_f32 v27, -v22, v21, v26
	v_fmac_f32_e32 v21, v27, v19
	v_or_b32_e32 v27, 0x400000, v18
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_fma_f32 v22, -v22, v21, v26
	v_fma_f32 v26, 0xbfb8aa3b, v13, -v32
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v18, v24, v27, s3
	v_cmp_u_f32_e64 s3, v4, v4
	v_bfe_u32 v27, v15, 16, 1
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v19, v22, v19, v21
	v_dual_fmac_f32 v26, 0xb2a5705f, v13 :: v_dual_sub_f32 v21, v32, v31
	v_div_scale_f32 v22, vcc_lo, v12, v10, v12
	v_lshrrev_b32_e32 v18, 16, v18
	s_delay_alu instid0(VALU_DEP_4)
	v_div_fixup_f32 v11, v19, v23, v11
	v_or_b32_e32 v32, 0x400000, v6
	v_add_f32_e32 v19, v21, v26
	v_mul_f32_e32 v21, v22, v29
	v_or_b32_e32 v26, 0x400000, v4
	v_mul_f32_e32 v11, v11, v3
	v_bfe_u32 v3, v4, 16, 1
	v_exp_f32_e32 v19, v19
	v_fma_f32 v23, -v20, v21, v22
	v_mov_b16_e32 v17.h, v18.l
	v_bfe_u32 v24, v11, 16, 1
	v_add3_u32 v3, v3, v4, 0x7fff
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_fmac_f32_e32 v21, v23, v29
	v_add3_u32 v23, v24, v11, 0x7fff
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(SKIP_4) | instid1(VALU_DEP_3)
	v_ldexp_f32 v19, v19, v25
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v4, v3, v26, s3
	v_fma_f32 v3, -v20, v21, v22
	v_cmp_nlt_f32_e64 s3, 0x42ce8ed0, v13
	v_and_b32_e32 v22, 0xffff0000, v4
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_3)
	v_div_fmas_f32 v20, v3, v29, v21
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v19, 0, v19, s3
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2b17218, v13
	v_or_b32_e32 v21, 0x400000, v11
	v_add_nc_u32_e32 v3, 3, v9
	v_div_fixup_f32 v10, v20, v10, v12
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v19, 0x7f800000, v19, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	v_ashrrev_i32_e32 v4, 31, v3
	v_mul_f32_e32 v10, v10, v22
	s_delay_alu instid0(VALU_DEP_4)
	v_add_f32_e32 v12, 1.0, v19
	v_bfe_u32 v19, v14, 16, 1
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v20, v23, v21, vcc_lo
	v_or_b32_e32 v21, 0x400000, v14
	v_bfe_u32 v18, v10, 16, 1
	v_div_scale_f32 v11, null, v12, v12, v13
	v_add3_u32 v19, v19, v14, 0x7fff
	v_cmp_u_f32_e32 vcc_lo, v14, v14
	v_bfe_u32 v23, v5, 16, 1
	v_add3_u32 v18, v18, v10, 0x7fff
	v_rcp_f32_e32 v22, v11
	v_cmp_u_f32_e64 s3, v10, v10
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v14, v19, v21, vcc_lo
	v_or_b32_e32 v21, 0x400000, v10
	v_lshlrev_b64_e32 v[3:4], 1, v[3:4]
	v_add3_u32 v10, v23, v5, 0x7fff
	s_delay_alu instid0(VALU_DEP_4)
	v_and_b32_e32 v14, 0xffff0000, v14
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v18, v18, v21, s3
	v_fma_f32 v19, -v11, v22, 1.0
	v_or_b32_e32 v21, 0x400000, v5
	v_cmp_u_f32_e64 s3, v5, v5
	v_add_co_u32 v3, vcc_lo, s18, v3
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v4, null, s19, v4, vcc_lo
	v_fmac_f32_e32 v22, v19, v22
	v_div_scale_f32 v19, vcc_lo, v13, v12, v13
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v5, v10, v21, s3
	v_mul_f32_e32 v24, 0xbfb8aa3b, v14
	v_cmp_u_f32_e64 s3, v15, v15
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_4)
	v_and_b32_e32 v5, 0xffff0000, v5
	v_mul_f32_e32 v23, v19, v22
	v_fma_f32 v25, 0xbfb8aa3b, v14, -v24
	v_rndne_f32_e32 v26, v24
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_fma_f32 v21, -v11, v23, v19
	v_fmac_f32_e32 v25, 0xb2a5705f, v14
	s_delay_alu instid0(VALU_DEP_3)
	v_sub_f32_e32 v10, v24, v26
	v_add3_u32 v24, v27, v15, 0x7fff
	v_or_b32_e32 v27, 0x400000, v15
	v_fmac_f32_e32 v23, v21, v22
	v_bfe_u32 v21, v16, 16, 1
	v_add_f32_e32 v10, v10, v25
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v15, v24, v27, s3
	v_fma_f32 v11, -v11, v23, v19
	v_cvt_i32_f32_e32 v19, v26
	v_exp_f32_e32 v10, v10
	v_add3_u32 v21, v21, v16, 0x7fff
	v_or_b32_e32 v24, 0x400000, v16
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v11, v11, v22, v23
	v_cmp_u_f32_e32 vcc_lo, v16, v16
	v_and_b32_e32 v15, 0xffff0000, v15
	s_delay_alu instid0(TRANS32_DEP_1)
	v_ldexp_f32 v10, v10, v19
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v16, v21, v24, vcc_lo
	v_cmp_nlt_f32_e32 vcc_lo, 0x42ce8ed0, v14
	v_mul_f32_e32 v19, 0xbfb8aa3b, v15
	v_div_fixup_f32 v12, v11, v12, v13
	v_cmp_ngt_f32_e64 s3, 0xc2b17218, v15
	v_and_b32_e32 v16, 0xffff0000, v16
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v10, 0, v10, vcc_lo
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2b17218, v14
	v_fma_f32 v13, 0xbfb8aa3b, v15, -v19
	v_rndne_f32_e32 v21, v19
	v_mul_f32_e32 v22, 0xbfb8aa3b, v16
	s_wait_alu depctr_va_vcc(0)
	v_dual_mul_f32 v12, v12, v5 :: v_dual_cndmask_b32 v11, 0x7f800000, v10
	v_fmac_f32_e32 v13, 0xb2a5705f, v15
	v_sub_f32_e32 v19, v19, v21
	v_add_nc_u32_e32 v10, 4, v9
	v_fma_f32 v24, 0xbfb8aa3b, v16, -v22
	v_add_f32_e32 v23, 1.0, v11
	v_rndne_f32_e32 v25, v22
	v_add_f32_e32 v13, v19, v13
	v_ashrrev_i32_e32 v11, 31, v10
	v_fmac_f32_e32 v24, 0xb2a5705f, v16
	v_div_scale_f32 v19, null, v23, v23, v14
	v_sub_f32_e32 v22, v22, v25
	v_exp_f32_e32 v13, v13
	v_lshlrev_b64_e32 v[10:11], 1, v[10:11]
	v_cvt_i32_f32_e32 v5, v21
	v_rcp_f32_e32 v26, v19
	v_add_f32_e32 v21, v22, v24
	v_bfe_u32 v22, v12, 16, 1
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_3) | instid1(TRANS32_DEP_1)
	v_add_co_u32 v10, vcc_lo, s18, v10
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v11, null, s19, v11, vcc_lo
	v_ldexp_f32 v5, v13, v5
	v_fma_f32 v13, -v19, v26, 1.0
	v_cmp_nlt_f32_e32 vcc_lo, 0x42ce8ed0, v15
	v_exp_f32_e32 v21, v21
	v_add3_u32 v22, v22, v12, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_dual_fmac_f32 v26, v13, v26 :: v_dual_cndmask_b32 v5, 0, v5
	v_cvt_i32_f32_e32 v13, v25
	v_div_scale_f32 v24, vcc_lo, v14, v23, v14
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_3)
	v_cndmask_b32_e64 v5, 0x7f800000, v5, s3
	s_delay_alu instid0(TRANS32_DEP_1) | instid1(VALU_DEP_3)
	v_ldexp_f32 v13, v21, v13
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_3) | instid1(VALU_DEP_4)
	v_mul_f32_e32 v25, v24, v26
	v_cmp_nlt_f32_e64 s3, 0x42ce8ed0, v16
	v_or_b32_e32 v21, 0x400000, v12
	v_add_f32_e32 v27, 1.0, v5
	v_fma_f32 v29, -v19, v25, v24
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v5, 0, v13, s3
	v_bfe_u32 v13, v6, 16, 1
	v_cmp_ngt_f32_e64 s3, 0xc2b17218, v16
	v_fmac_f32_e32 v25, v29, v26
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_add3_u32 v13, v13, v6, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v5, 0x7f800000, v5, s3
	v_cmp_u_f32_e64 s3, v6, v6
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_f32_e32 v37, 1.0, v5
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v6, v13, v32, s3
	v_fma_f32 v13, -v19, v25, v24
	v_cmp_u_f32_e64 s3, v12, v12
	v_add_nc_u32_e32 v5, 5, v9
	v_div_scale_f32 v19, null, v37, v37, v16
	v_or_b32_e32 v32, 0x400000, v7
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v13, v13, v26, v25
	v_and_b32_e32 v25, 0xffff0000, v6
	v_ashrrev_i32_e32 v6, 31, v5
	v_rcp_f32_e32 v26, v19
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v21, v22, v21, s3
	v_div_fixup_f32 v13, v13, v23, v14
	v_bfe_u32 v23, v7, 16, 1
	v_lshlrev_b64_e32 v[5:6], 1, v[5:6]
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_4) | instid1(VALU_DEP_4)
	v_mul_f32_e32 v12, v13, v25
	v_div_scale_f32 v31, null, v27, v27, v15
	v_div_scale_f32 v14, vcc_lo, v15, v27, v15
	v_fma_f32 v22, -v19, v26, 1.0
	v_add_co_u32 v5, s3, s18, v5
	v_rcp_f32_e32 v29, v31
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v6, null, s19, v6, s3
	v_fmac_f32_e32 v26, v22, v26
	v_div_scale_f32 v22, s3, v16, v37, v16
	v_add3_u32 v23, v23, v7, 0x7fff
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_fma_f32 v24, -v31, v29, 1.0
	v_cndmask_b32_e64 v7, v23, v32, s4
	v_bfe_u32 v23, v8, 16, 1
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_fmac_f32_e32 v29, v24, v29
	v_bfe_u32 v24, v12, 16, 1
	v_add3_u32 v23, v23, v8, 0x7fff
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_mul_f32_e32 v13, v14, v29
	v_add3_u32 v24, v24, v12, 0x7fff
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fma_f32 v25, -v31, v13, v14
	v_fmac_f32_e32 v13, v25, v29
	v_mul_f32_e32 v25, v22, v26
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_fma_f32 v14, -v31, v13, v14
	v_fma_f32 v31, -v19, v25, v22
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_div_fmas_f32 v13, v14, v29, v13
	v_fmac_f32_e32 v25, v31, v26
	v_or_b32_e32 v29, 0x400000, v8
	v_cmp_u_f32_e32 vcc_lo, v8, v8
	v_and_b32_e32 v14, 0xffff0000, v7
	v_div_fixup_f32 v13, v13, v27, v15
	v_add_nc_u32_e32 v7, 6, v9
	v_fma_f32 v15, -v19, v25, v22
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v19, v23, v29, vcc_lo
	s_mov_b32 vcc_lo, s3
	v_mul_f32_e32 v14, v13, v14
	v_ashrrev_i32_e32 v8, 31, v7
	s_wait_alu depctr_sa_sdst(0)
	v_div_fmas_f32 v15, v15, v26, v25
	v_or_b32_e32 v13, 0x400000, v12
	v_cmp_u_f32_e32 vcc_lo, v12, v12
	v_add_nc_u32_e32 v12, 7, v9
	v_and_b32_e32 v19, 0xffff0000, v19
	v_div_fixup_f32 v15, v15, v37, v16
	v_lshlrev_b64_e32 v[7:8], 1, v[7:8]
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v22, v24, v13, vcc_lo
	v_ashrrev_i32_e32 v13, 31, v12
	v_bfe_u32 v16, v14, 16, 1
	v_mul_f32_e32 v9, v15, v19
	v_add_co_u32 v7, vcc_lo, s18, v7
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_lshlrev_b64_e32 v[12:13], 1, v[12:13]
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
	global_store_d16_hi_b16 v[1:2], v20, off offset:163844
	global_store_b32 v[1:2], v17, off offset:163840
	global_store_d16_hi_b16 v[3:4], v18, off offset:163840
	global_store_d16_hi_b16 v[10:11], v21, off offset:163840
	global_store_d16_hi_b16 v[5:6], v22, off offset:163840
	global_store_d16_hi_b16 v[7:8], v14, off offset:163840
	global_store_d16_hi_b16 v[12:13], v9, off offset:163840
	s_branch .LBB0_174
.LBB0_189:
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s1, s2
	s_cbranch_execz .LBB0_204
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
	s_cbranch_execz .LBB0_192
	s_bcnt1_i32_b32 s4, s4
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v3, s4
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v3, v2, v3, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_192:
	s_or_b32 exec_lo, exec_lo, s6
	v_readfirstlane_b32 s4, v3
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v1, s4, v1
	s_mov_b32 s4, exec_lo
	v_cmpx_ne_u32_e32 63, v1
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s4, exec_lo, s4
	s_cbranch_execz .LBB0_201
	s_cmp_lt_i32 s38, 1
	s_mov_b32 s6, 1
	s_cbranch_scc1 .LBB0_196
	v_mov_b32_e32 v1, 0
.LBB0_195:
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
	s_cbranch_vccnz .LBB0_195
	s_branch .LBB0_197
.LBB0_196:
	s_mov_b32 s7, -1
.LBB0_197:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s6, s7, exec_lo
	s_cselect_b32 s6, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s6, 1
	s_cbranch_scc1 .LBB0_201
	v_dual_mov_b32 v1, 1 :: v_dual_mov_b32 v2, 0
	s_mov_b32 s6, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v1, v2, v[1:2], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_200
	v_dual_mov_b32 v4, ttmp9 :: v_dual_mov_b32 v3, 2
	v_mov_b32_e32 v5, s3
	global_store_b96 v2, v[3:5], s[22:23] offset:4
.LBB0_200:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
.LBB0_201:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s4, s4
	s_cbranch_execz .LBB0_203
	s_add_co_i32 s3, s3, 1
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v1, 0 :: v_dual_mov_b32 v2, s3
	global_store_b32 v1, v1, s[20:21] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v1, v2, s[20:21] offset:4 scope:SCOPE_DEV
.LBB0_203:
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
.LBB0_204:
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
	s_cbranch_vccnz .LBB0_374
	s_cmp_gt_i32 s5, 0x13f
	s_cbranch_scc1 .LBB0_228
	v_mov_b32_e32 v21, 0
	v_mul_u32_u24_e32 v3, 0x1100, v33
	v_mul_u32_u24_e32 v27, 0x1400, v33
	v_cmp_gt_i32_e32 vcc_lo, s36, v33
	global_load_b64 v[1:2], v21, s[28:29] offset:24
	v_or_b32_e32 v24, v3, v34
	s_wait_loadcnt 0x0
	v_add_co_u32 v25, s1, 0x200, v1
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v26, null, 0, v2, s1
	s_branch .LBB0_208
.LBB0_207:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	s_add_co_i32 s1, s5, 0x100
	s_cmp_lt_i32 s5, 64
	s_wait_alu depctr_sa_sdst(0)
	s_mov_b32 s5, s1
	s_cbranch_scc0 .LBB0_228
.LBB0_208:
	s_wait_alu depctr_sa_sdst(0)
	s_lshl_b32 s3, s5, 4
	v_dual_mov_b32 v3, v21 :: v_dual_mov_b32 v4, v21
	s_wait_alu depctr_sa_sdst(0)
	v_or_b32_e32 v1, s3, v33
	v_dual_mov_b32 v5, v21 :: v_dual_mov_b32 v6, v21
	v_dual_mov_b32 v7, v21 :: v_dual_mov_b32 v2, v21
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_2) | instid1(VALU_DEP_2)
	v_mul_lo_u32 v8, 0x1100, v1
	v_mov_b32_e32 v1, v21
	s_mov_b32 s4, 0
	v_or_b32_e32 v29, v8, v34
	v_mov_b32_e32 v8, v21
	s_branch .LBB0_210
.LBB0_209:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
	global_load_b128 v[9:12], v[22:23], off offset:224
	s_add_co_i32 s1, s4, 0x80
	s_cmp_lt_u32 s4, 0x1080
	s_wait_alu depctr_sa_sdst(0)
	s_mov_b32 s4, s1
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[1:8], v[9:12], v[13:16], v[1:8]
	s_cbranch_scc0 .LBB0_226
.LBB0_210:
	v_dual_mov_b32 v9, 0 :: v_dual_mov_b32 v12, 0
	v_dual_mov_b32 v13, 0 :: v_dual_mov_b32 v14, 0
	v_mov_b32_e32 v15, 0
	s_and_saveexec_b32 s6, vcc_lo
	s_cbranch_execz .LBB0_212
	s_wait_alu depctr_sa_sdst(0)
	v_add_nc_u32_e32 v20, s4, v24
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshlrev_b64_e32 v[10:11], 1, v[20:21]
	v_add_co_u32 v10, s1, s18, v10
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_add_co_ci_u32_e64 v11, null, s19, v11, s1
	global_load_b128 v[12:15], v[10:11], off offset:163840
.LBB0_212:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
	v_add_nc_u32_e32 v10, s4, v29
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v11, 31, v10
	v_lshlrev_b64_e32 v[10:11], 1, v[10:11]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v22, s1, s12, v10
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v23, null, s13, v11, s1
	v_dual_mov_b32 v10, 0 :: v_dual_mov_b32 v11, 0
	global_load_b128 v[16:19], v[22:23], off
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[1:8], v[16:19], v[12:15], v[1:8]
	v_mov_b32_e32 v12, 0
	s_and_saveexec_b32 s6, vcc_lo
	s_cbranch_execz .LBB0_214
	v_add_nc_u32_e32 v20, s4, v24
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshlrev_b64_e32 v[9:10], 1, v[20:21]
	v_add_co_u32 v9, s1, s18, v9
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_add_co_ci_u32_e64 v10, null, s19, v10, s1
	global_load_b128 v[9:12], v[9:10], off offset:163872
.LBB0_214:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
	global_load_b128 v[35:38], v[22:23], off offset:32
	v_dual_mov_b32 v13, 0 :: v_dual_mov_b32 v16, 0
	v_dual_mov_b32 v17, 0 :: v_dual_mov_b32 v18, 0
	v_mov_b32_e32 v19, 0
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[1:8], v[35:38], v[9:12], v[1:8]
	s_and_saveexec_b32 s6, vcc_lo
	s_cbranch_execz .LBB0_216
	v_add_nc_u32_e32 v20, s4, v24
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshlrev_b64_e32 v[9:10], 1, v[20:21]
	v_add_co_u32 v9, s1, s18, v9
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_add_co_ci_u32_e64 v10, null, s19, v10, s1
	global_load_b128 v[16:19], v[9:10], off offset:163904
.LBB0_216:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
	global_load_b128 v[9:12], v[22:23], off offset:64
	v_dual_mov_b32 v14, 0 :: v_dual_mov_b32 v15, 0
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[1:8], v[9:12], v[16:19], v[1:8]
	v_mov_b32_e32 v16, 0
	s_and_saveexec_b32 s6, vcc_lo
	s_cbranch_execz .LBB0_218
	v_add_nc_u32_e32 v20, s4, v24
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshlrev_b64_e32 v[9:10], 1, v[20:21]
	v_add_co_u32 v9, s1, s18, v9
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_add_co_ci_u32_e64 v10, null, s19, v10, s1
	global_load_b128 v[13:16], v[9:10], off offset:163936
.LBB0_218:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
	global_load_b128 v[35:38], v[22:23], off offset:96
	v_dual_mov_b32 v9, 0 :: v_dual_mov_b32 v18, 0
	v_dual_mov_b32 v17, 0 :: v_dual_mov_b32 v20, 0
	v_mov_b32_e32 v19, 0
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[1:8], v[35:38], v[13:16], v[1:8]
	s_and_saveexec_b32 s6, vcc_lo
	s_cbranch_execz .LBB0_220
	v_add_nc_u32_e32 v20, s4, v24
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshlrev_b64_e32 v[10:11], 1, v[20:21]
	v_add_co_u32 v10, s1, s18, v10
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_add_co_ci_u32_e64 v11, null, s19, v11, s1
	global_load_b128 v[17:20], v[10:11], off offset:163968
.LBB0_220:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
	global_load_b128 v[12:15], v[22:23], off offset:128
	v_dual_mov_b32 v10, 0 :: v_dual_mov_b32 v11, 0
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[1:8], v[12:15], v[17:20], v[1:8]
	v_mov_b32_e32 v12, 0
	s_and_saveexec_b32 s6, vcc_lo
	s_cbranch_execz .LBB0_222
	v_add_nc_u32_e32 v20, s4, v24
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshlrev_b64_e32 v[9:10], 1, v[20:21]
	v_add_co_u32 v9, s1, s18, v9
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_add_co_ci_u32_e64 v10, null, s19, v10, s1
	global_load_b128 v[9:12], v[9:10], off offset:164000
.LBB0_222:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
	global_load_b128 v[35:38], v[22:23], off offset:160
	v_dual_mov_b32 v13, 0 :: v_dual_mov_b32 v16, 0
	v_dual_mov_b32 v17, 0 :: v_dual_mov_b32 v18, 0
	v_mov_b32_e32 v19, 0
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[1:8], v[35:38], v[9:12], v[1:8]
	s_and_saveexec_b32 s6, vcc_lo
	s_cbranch_execz .LBB0_224
	v_add_nc_u32_e32 v20, s4, v24
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshlrev_b64_e32 v[9:10], 1, v[20:21]
	v_add_co_u32 v9, s1, s18, v9
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_add_co_ci_u32_e64 v10, null, s19, v10, s1
	global_load_b128 v[16:19], v[9:10], off offset:164032
.LBB0_224:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
	global_load_b128 v[9:12], v[22:23], off offset:192
	v_dual_mov_b32 v14, 0 :: v_dual_mov_b32 v15, 0
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[1:8], v[9:12], v[16:19], v[1:8]
	v_mov_b32_e32 v16, 0
	s_and_saveexec_b32 s6, vcc_lo
	s_cbranch_execz .LBB0_209
	v_add_nc_u32_e32 v20, s4, v24
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshlrev_b64_e32 v[9:10], 1, v[20:21]
	v_add_co_u32 v9, s1, s18, v9
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_add_co_ci_u32_e64 v10, null, s19, v10, s1
	global_load_b128 v[13:16], v[9:10], off offset:164064
	s_branch .LBB0_209
.LBB0_226:
	s_and_saveexec_b32 s4, vcc_lo
	s_cbranch_execz .LBB0_207
	v_or_b32_e32 v9, s3, v34
	v_bfe_u32 v10, v1, 16, 1
	v_or_b32_e32 v11, 0x400000, v1
	v_bfe_u32 v12, v2, 16, 1
	v_cmp_u_f32_e64 s1, v1, v1
	v_add_nc_u32_e32 v9, v9, v27
	v_add3_u32 v16, v10, v1, 0x7fff
	v_or_b32_e32 v13, 0x400000, v2
	v_add3_u32 v12, v12, v2, 0x7fff
	v_bfe_u32 v14, v3, 16, 1
	v_ashrrev_i32_e32 v10, 31, v9
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v1, v16, v11, s1
	v_cmp_u_f32_e64 s1, v2, v2
	v_or_b32_e32 v15, 0x400000, v3
	v_add3_u32 v11, v14, v3, 0x7fff
	v_lshlrev_b64_e32 v[9:10], 1, v[9:10]
	v_bfe_u32 v17, v4, 16, 1
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v2, v12, v13, s1
	v_or_b32_e32 v13, 0x400000, v4
	v_bfe_u32 v14, v5, 16, 1
	v_bfe_u32 v16, v7, 16, 1
	v_add_co_u32 v9, s1, v25, v9
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v10, null, v26, v10, s1
	v_cmp_u_f32_e64 s1, v3, v3
	v_add3_u32 v12, v17, v4, 0x7fff
	v_or_b32_e32 v17, 0x400000, v8
	v_lshrrev_b32_e32 v1, 16, v1
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v3, v11, v15, s1
	v_lshrrev_b32_e32 v11, 16, v2
	v_cmp_u_f32_e64 s1, v4, v4
	v_or_b32_e32 v15, 0x400000, v6
	s_delay_alu instid0(VALU_DEP_4)
	v_lshrrev_b32_e32 v2, 16, v3
	v_bfe_u32 v3, v6, 16, 1
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v4, v12, v13, s1
	v_bfe_u32 v13, v8, 16, 1
	v_cmp_u_f32_e64 s1, v6, v6
	v_add3_u32 v12, v14, v5, 0x7fff
	v_add3_u32 v3, v3, v6, 0x7fff
	v_or_b32_e32 v14, 0x400000, v5
	v_add3_u32 v13, v13, v8, 0x7fff
	v_add3_u32 v6, v16, v7, 0x7fff
	v_mov_b16_e32 v1.h, v11.l
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v3, v3, v15, s1
	v_cmp_u_f32_e64 s1, v8, v8
	v_or_b32_e32 v15, 0x400000, v7
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_2) | instid1(VALU_DEP_1)
	v_cndmask_b32_e64 v8, v13, v17, s1
	v_cmp_u_f32_e64 s1, v5, v5
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v5, v12, v14, s1
	v_cmp_u_f32_e64 s1, v7, v7
	v_lshrrev_b32_e32 v7, 16, v8
	v_lshrrev_b32_e32 v8, 16, v3
	v_lshrrev_b32_e32 v12, 16, v4
	v_lshrrev_b32_e32 v3, 16, v5
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v6, v6, v15, s1
	v_mov_b16_e32 v3.h, v8.l
	v_mov_b16_e32 v2.h, v12.l
	s_delay_alu instid0(VALU_DEP_3)
	v_lshrrev_b32_e32 v4, 16, v6
	v_mov_b16_e32 v4.h, v7.l
	global_store_b128 v[9:10], v[1:4], off
	s_branch .LBB0_207
.LBB0_228:
	s_cmp_eq_u32 ttmp9, s42
	s_cbranch_scc1 .LBB0_374
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
	s_cbranch_execz .LBB0_244
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
	s_cbranch_execz .LBB0_232
	s_bcnt1_i32_b32 s5, s5
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v4, 0 :: v_dual_mov_b32 v5, s5
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v4, v4, v5, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_232:
	s_or_b32 exec_lo, exec_lo, s6
	v_readfirstlane_b32 s5, v4
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v3, s5, v3
	s_mov_b32 s5, exec_lo
	v_cmpx_ne_u32_e32 63, v3
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s5, exec_lo, s5
	s_cbranch_execz .LBB0_241
	s_cmp_lt_i32 s38, 1
	s_mov_b32 s6, 1
	s_cbranch_scc1 .LBB0_236
	v_mov_b32_e32 v3, 0
.LBB0_235:
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
	s_cbranch_vccnz .LBB0_235
	s_branch .LBB0_237
.LBB0_236:
	s_mov_b32 s7, -1
.LBB0_237:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s6, s7, exec_lo
	s_cselect_b32 s6, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s6, 1
	s_cbranch_scc1 .LBB0_241
	v_dual_mov_b32 v3, 1 :: v_dual_mov_b32 v4, 0
	s_mov_b32 s6, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v3, v4, v[3:4], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v3
	s_cbranch_execz .LBB0_240
	v_dual_mov_b32 v6, ttmp9 :: v_dual_mov_b32 v5, 20
	v_mov_b32_e32 v7, s4
	global_store_b96 v4, v[5:7], s[22:23] offset:4
.LBB0_240:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
.LBB0_241:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s5, s5
	s_cbranch_execz .LBB0_243
	s_add_co_i32 s4, s4, 1
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v3, 0 :: v_dual_mov_b32 v4, s4
	global_store_b32 v3, v3, s[20:21] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v3, v4, s[20:21] offset:4 scope:SCOPE_DEV
.LBB0_243:
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
.LBB0_244:
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
	s_cbranch_vccnz .LBB0_374
	v_or_b32_e32 v0, ttmp9, v0
	s_add_co_i32 s3, s3, 1
	s_delay_alu instid0(VALU_DEP_1)
	v_cmp_eq_u32_e64 s1, 0, v0
	s_and_saveexec_b32 s4, s1
	s_cbranch_execz .LBB0_282
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v0, s3
	s_cmp_gt_i32 s38, 0
	s_cselect_b32 s5, -1, 0
	s_cmp_lt_i32 s38, 1
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[1:2], v0, off scope:SCOPE_SYS
	s_cbranch_scc1 .LBB0_250
	v_mov_b32_e32 v0, 0
	s_mov_b32 s6, 1
	global_load_b64 v[3:4], v0, s[28:29]
.LBB0_248:
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
	s_cbranch_vccnz .LBB0_248
	s_cmp_lg_u32 s7, 0
	s_cselect_b32 s6, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s6, s8, s6
	s_branch .LBB0_251
.LBB0_250:
	s_mov_b32 s6, -1
.LBB0_251:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s6, s6, exec_lo
	s_cselect_b32 s6, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s6, 1
	s_cbranch_scc1 .LBB0_255
	v_dual_mov_b32 v3, 1 :: v_dual_mov_b32 v4, 0
	s_mov_b32 s6, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v0, v4, v[3:4], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_254
	v_dual_mov_b32 v5, 30 :: v_dual_mov_b32 v6, v4
	v_mov_b32_e32 v7, s3
	global_store_b96 v4, v[5:7], s[22:23] offset:4
.LBB0_254:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[1:2], v3, off offset:384 scope:SCOPE_SYS
.LBB0_255:
	s_and_b32 s6, s5, exec_lo
	s_cselect_b32 s6, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s6, 1
	s_cbranch_scc1 .LBB0_259
	v_mov_b32_e32 v0, 0
	s_mov_b32 s6, 1
	global_load_b64 v[3:4], v0, s[28:29] offset:8
.LBB0_257:
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
	s_cbranch_vccnz .LBB0_257
	s_cmp_lg_u32 s7, 0
	s_cselect_b32 s6, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s6, s8, s6
	s_branch .LBB0_260
.LBB0_259:
	s_mov_b32 s6, -1
.LBB0_260:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s6, s6, exec_lo
	s_cselect_b32 s6, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s6, 1
	s_cbranch_scc1 .LBB0_264
	v_dual_mov_b32 v3, 1 :: v_dual_mov_b32 v4, 0
	s_mov_b32 s6, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v0, v4, v[3:4], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_263
	v_dual_mov_b32 v5, 30 :: v_dual_mov_b32 v6, v4
	v_mov_b32_e32 v7, s3
	global_store_b96 v4, v[5:7], s[22:23] offset:4
.LBB0_263:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[1:2], v3, off offset:384 scope:SCOPE_SYS
.LBB0_264:
	s_and_b32 s6, s5, exec_lo
	s_cselect_b32 s6, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s6, 1
	s_cbranch_scc1 .LBB0_268
	v_mov_b32_e32 v0, 0
	s_mov_b32 s6, 1
	global_load_b64 v[3:4], v0, s[28:29] offset:16
.LBB0_266:
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
	s_cbranch_vccnz .LBB0_266
	s_cmp_lg_u32 s7, 0
	s_cselect_b32 s6, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s6, s8, s6
	s_branch .LBB0_269
.LBB0_268:
	s_mov_b32 s6, -1
.LBB0_269:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s6, s6, exec_lo
	s_cselect_b32 s6, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s6, 1
	s_cbranch_scc1 .LBB0_273
	v_dual_mov_b32 v3, 1 :: v_dual_mov_b32 v4, 0
	s_mov_b32 s6, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v0, v4, v[3:4], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_272
	v_dual_mov_b32 v5, 30 :: v_dual_mov_b32 v6, v4
	v_mov_b32_e32 v7, s3
	global_store_b96 v4, v[5:7], s[22:23] offset:4
.LBB0_272:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[1:2], v3, off offset:384 scope:SCOPE_SYS
.LBB0_273:
	s_and_b32 s5, s5, exec_lo
	s_cselect_b32 s5, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s5, 1
	s_cbranch_scc1 .LBB0_277
	v_mov_b32_e32 v0, 0
	s_mov_b32 s5, 1
	global_load_b64 v[3:4], v0, s[28:29] offset:24
.LBB0_275:
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
	s_cbranch_vccnz .LBB0_275
	s_cmp_lg_u32 s6, 0
	s_cselect_b32 s5, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s5, s7, s5
	s_branch .LBB0_278
.LBB0_277:
	s_mov_b32 s5, -1
.LBB0_278:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s5, s5, exec_lo
	s_cselect_b32 s5, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s5, 1
	s_cbranch_scc1 .LBB0_282
	v_dual_mov_b32 v3, 1 :: v_dual_mov_b32 v4, 0
	s_mov_b32 s5, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v0, v4, v[3:4], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_281
	v_dual_mov_b32 v5, 30 :: v_dual_mov_b32 v6, v4
	v_mov_b32_e32 v7, s3
	global_store_b96 v4, v[5:7], s[22:23] offset:4
.LBB0_281:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s5
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[1:2], v3, off offset:384 scope:SCOPE_SYS
.LBB0_282:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s4, s2
	s_cbranch_execz .LBB0_297
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
	s_cbranch_execz .LBB0_285
	s_bcnt1_i32_b32 s6, s6
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v4, s6
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v4, v3, v4, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_285:
	s_or_b32 exec_lo, exec_lo, s7
	v_readfirstlane_b32 s6, v4
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v0, s6, v0
	s_mov_b32 s6, exec_lo
	v_cmpx_ne_u32_e32 63, v0
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s6, exec_lo, s6
	s_cbranch_execz .LBB0_294
	s_cmp_lt_i32 s38, 1
	s_mov_b32 s7, 1
	s_cbranch_scc1 .LBB0_289
	v_mov_b32_e32 v0, 0
.LBB0_288:
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
	s_cbranch_vccnz .LBB0_288
	s_branch .LBB0_290
.LBB0_289:
	s_mov_b32 s8, -1
.LBB0_290:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s7, s8, exec_lo
	s_cselect_b32 s7, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s7, 1
	s_cbranch_scc1 .LBB0_294
	v_dual_mov_b32 v3, 1 :: v_dual_mov_b32 v4, 0
	s_mov_b32 s7, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v0, v4, v[3:4], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_293
	v_dual_mov_b32 v6, ttmp9 :: v_dual_mov_b32 v5, 21
	v_mov_b32_e32 v7, s5
	global_store_b96 v4, v[5:7], s[22:23] offset:4
.LBB0_293:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s7
.LBB0_294:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s6, s6
	s_cbranch_execz .LBB0_296
	s_add_co_i32 s5, s5, 1
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v0, 0 :: v_dual_mov_b32 v3, s5
	global_store_b32 v0, v0, s[20:21] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v0, v3, s[20:21] offset:4 scope:SCOPE_DEV
.LBB0_296:
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
.LBB0_297:
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
	s_cbranch_vccnz .LBB0_374
	s_and_saveexec_b32 s4, s0
	s_cbranch_execz .LBB0_303
	v_mov_b32_e32 v0, 0
	s_cmp_lg_u32 s41, 0
	s_mov_b32 s5, 0
	s_cselect_b32 s6, -1, 0
	s_branch .LBB0_301
.LBB0_300:
	v_add_nc_u32_e32 v28, 0x2000, v28
	v_add_co_u32 v3, s0, s14, v3
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v4, null, s15, v4, s0
	s_delay_alu instid0(VALU_DEP_3)
	v_cmp_le_i32_e32 vcc_lo, s33, v28
	global_store_b16 v[3:4], v5, off
	s_or_b32 s5, vcc_lo, s5
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_b32 exec_lo, exec_lo, s5
	s_cbranch_execz .LBB0_303
.LBB0_301:
	s_clause 0x1
	global_load_b128 v[5:8], v0, s[28:29]
	global_load_b128 v[9:12], v0, s[28:29] offset:16
	v_ashrrev_i32_e32 v29, 31, v28
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s0, s6, exec_lo
	s_cselect_b32 s0, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s0, 1
	v_lshlrev_b64_e32 v[3:4], 1, v[28:29]
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
	s_cbranch_scc1 .LBB0_300
	v_mul_hi_i32 v6, 0x66666667, v28
	v_mov_b16_e32 v8.l, 0
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_lshlrev_b32_e32 v5, 16, v5
	v_lshrrev_b32_e32 v7, 31, v6
	v_ashrrev_i32_e32 v6, 11, v6
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v6, v6, v7
	v_mul_i32_i24_e32 v6, 0x1400, v6
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_sub_nc_u32_e32 v6, v28, v6
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
	s_branch .LBB0_300
.LBB0_303:
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
	s_cbranch_execz .LBB0_318
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
	s_cbranch_execz .LBB0_306
	s_bcnt1_i32_b32 s5, s5
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v4, s5
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v4, v3, v4, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_306:
	s_or_b32 exec_lo, exec_lo, s6
	v_readfirstlane_b32 s5, v4
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v0, s5, v0
	s_mov_b32 s5, exec_lo
	v_cmpx_ne_u32_e32 63, v0
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s5, exec_lo, s5
	s_cbranch_execz .LBB0_315
	s_cmp_lt_i32 s38, 1
	s_mov_b32 s6, 1
	s_cbranch_scc1 .LBB0_310
	v_mov_b32_e32 v0, 0
.LBB0_309:
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
	s_cbranch_vccnz .LBB0_309
	s_branch .LBB0_311
.LBB0_310:
	s_mov_b32 s7, -1
.LBB0_311:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s6, s7, exec_lo
	s_cselect_b32 s6, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s6, 1
	s_cbranch_scc1 .LBB0_315
	v_dual_mov_b32 v3, 1 :: v_dual_mov_b32 v4, 0
	s_mov_b32 s6, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v0, v4, v[3:4], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_314
	v_dual_mov_b32 v6, ttmp9 :: v_dual_mov_b32 v5, 22
	v_mov_b32_e32 v7, s4
	global_store_b96 v4, v[5:7], s[22:23] offset:4
.LBB0_314:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
.LBB0_315:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s5, s5
	s_cbranch_execz .LBB0_317
	s_add_co_i32 s4, s4, 1
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v0, 0 :: v_dual_mov_b32 v3, s4
	global_store_b32 v0, v0, s[20:21] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v0, v3, s[20:21] offset:4 scope:SCOPE_DEV
.LBB0_317:
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
.LBB0_318:
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
	s_cbranch_vccnz .LBB0_374
	s_and_saveexec_b32 s0, s1
	s_cbranch_execz .LBB0_358
	v_mov_b32_e32 v0, s3
	s_cmp_gt_i32 s38, 0
	s_mov_b32 s4, 1
	s_cselect_b32 s1, -1, 0
	s_cmp_lt_i32 s38, 1
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[1:2], v0, off offset:128 scope:SCOPE_SYS
	s_cbranch_scc1 .LBB0_324
	v_mov_b32_e32 v0, 0
	global_load_b64 v[3:4], v0, s[28:29]
.LBB0_322:
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
	s_cbranch_vccnz .LBB0_322
	s_cmp_lg_u32 s5, 0
	s_cselect_b32 s4, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s4, s6, s4
	s_branch .LBB0_325
.LBB0_324:
	s_mov_b32 s4, -1
.LBB0_325:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s4, s4, exec_lo
	s_cselect_b32 s4, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s4, 1
	s_cbranch_scc1 .LBB0_329
	v_dual_mov_b32 v3, 1 :: v_dual_mov_b32 v4, 0
	s_mov_b32 s4, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v0, v4, v[3:4], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_328
	v_dual_mov_b32 v5, 31 :: v_dual_mov_b32 v6, v4
	v_mov_b32_e32 v7, s3
	global_store_b96 v4, v[5:7], s[22:23] offset:4
.LBB0_328:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[1:2], v3, off offset:384 scope:SCOPE_SYS
.LBB0_329:
	s_and_b32 s4, s1, exec_lo
	s_cselect_b32 s4, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s4, 1
	s_cbranch_scc1 .LBB0_333
	v_mov_b32_e32 v0, 0
	s_mov_b32 s4, 1
	global_load_b64 v[3:4], v0, s[28:29] offset:8
.LBB0_331:
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
	s_cbranch_vccnz .LBB0_331
	s_cmp_lg_u32 s5, 0
	s_cselect_b32 s4, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s4, s6, s4
	s_branch .LBB0_334
.LBB0_333:
	s_mov_b32 s4, -1
.LBB0_334:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s4, s4, exec_lo
	s_cselect_b32 s4, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s4, 1
	s_cbranch_scc1 .LBB0_338
	v_dual_mov_b32 v3, 1 :: v_dual_mov_b32 v4, 0
	s_mov_b32 s4, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v0, v4, v[3:4], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_337
	v_dual_mov_b32 v5, 31 :: v_dual_mov_b32 v6, v4
	v_mov_b32_e32 v7, s3
	global_store_b96 v4, v[5:7], s[22:23] offset:4
.LBB0_337:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[1:2], v3, off offset:384 scope:SCOPE_SYS
.LBB0_338:
	s_and_b32 s4, s1, exec_lo
	s_cselect_b32 s4, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s4, 1
	s_cbranch_scc1 .LBB0_342
	v_mov_b32_e32 v0, 0
	s_mov_b32 s4, 1
	global_load_b64 v[3:4], v0, s[28:29] offset:16
.LBB0_340:
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
	s_cbranch_vccnz .LBB0_340
	s_cmp_lg_u32 s5, 0
	s_cselect_b32 s4, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s4, s6, s4
	s_branch .LBB0_343
.LBB0_342:
	s_mov_b32 s4, -1
.LBB0_343:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s4, s4, exec_lo
	s_cselect_b32 s4, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s4, 1
	s_cbranch_scc1 .LBB0_347
	v_dual_mov_b32 v3, 1 :: v_dual_mov_b32 v4, 0
	s_mov_b32 s4, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v0, v4, v[3:4], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_346
	v_dual_mov_b32 v5, 31 :: v_dual_mov_b32 v6, v4
	v_mov_b32_e32 v7, s3
	global_store_b96 v4, v[5:7], s[22:23] offset:4
.LBB0_346:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[1:2], v3, off offset:384 scope:SCOPE_SYS
.LBB0_347:
	s_and_b32 s1, s1, exec_lo
	s_cselect_b32 s1, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s1, 1
	s_cbranch_scc1 .LBB0_351
	v_mov_b32_e32 v0, 0
	s_mov_b32 s1, 1
	global_load_b64 v[3:4], v0, s[28:29] offset:24
.LBB0_349:
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
	s_cbranch_vccnz .LBB0_349
	s_cmp_lg_u32 s4, 0
	s_cselect_b32 s1, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s1, s5, s1
	s_branch .LBB0_352
.LBB0_351:
	s_mov_b32 s1, -1
.LBB0_352:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s1, s1, exec_lo
	s_cselect_b32 s1, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s1, 1
	s_cbranch_scc1 .LBB0_356
	v_dual_mov_b32 v3, 1 :: v_dual_mov_b32 v4, 0
	s_mov_b32 s1, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v0, v4, v[3:4], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_355
	v_dual_mov_b32 v5, 31 :: v_dual_mov_b32 v6, v4
	v_mov_b32_e32 v7, s3
	global_store_b96 v4, v[5:7], s[22:23] offset:4
.LBB0_355:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s1
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[1:2], v3, off offset:384 scope:SCOPE_SYS
.LBB0_356:
	v_mov_b32_e32 v0, 0
	global_load_b32 v0, v0, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_ne_u32_e32 vcc_lo, 0, v0
	s_cbranch_vccnz .LBB0_358
	v_mov_b32_e32 v0, s3
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[1:2], v0, off offset:256 scope:SCOPE_SYS
.LBB0_358:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s0
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s0, s2
	s_cbranch_execz .LBB0_373
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
	s_cbranch_execz .LBB0_361
	s_bcnt1_i32_b32 s3, s3
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v2, s3
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v2, v1, v2, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_361:
	s_or_b32 exec_lo, exec_lo, s4
	v_readfirstlane_b32 s3, v2
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v0, s3, v0
	s_mov_b32 s3, exec_lo
	v_cmpx_ne_u32_e32 63, v0
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s3, exec_lo, s3
	s_cbranch_execz .LBB0_370
	s_cmp_lt_i32 s38, 1
	s_mov_b32 s4, 1
	s_cbranch_scc1 .LBB0_365
	v_mov_b32_e32 v0, 0
.LBB0_364:
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
	s_cbranch_vccnz .LBB0_364
	s_branch .LBB0_366
.LBB0_365:
	s_mov_b32 s5, -1
.LBB0_366:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s4, s5, exec_lo
	s_cselect_b32 s4, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s4, 1
	s_cbranch_scc1 .LBB0_370
	v_dual_mov_b32 v0, 1 :: v_dual_mov_b32 v1, 0
	s_mov_b32 s4, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v0, v1, v[0:1], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_369
	v_dual_mov_b32 v3, ttmp9 :: v_dual_mov_b32 v2, 23
	v_mov_b32_e32 v4, s1
	global_store_b96 v1, v[2:4], s[22:23] offset:4
.LBB0_369:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
.LBB0_370:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s3, s3
	s_cbranch_execz .LBB0_372
	s_add_co_i32 s1, s1, 1
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v0, 0 :: v_dual_mov_b32 v1, s1
	global_store_b32 v0, v0, s[20:21] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v0, v1, s[20:21] offset:4 scope:SCOPE_DEV
.LBB0_372:
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
.LBB0_373:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s0
	s_wait_storecnt 0x0
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_374:
	s_and_saveexec_b32 s0, s2
	s_cbranch_execz .LBB0_379
	v_mov_b32_e32 v0, 0
	s_wait_kmcnt 0x0
	global_load_b32 v1, v0, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, 0, v1
	s_cbranch_vccnz .LBB0_377
	global_load_b64 v[1:2], v0, s[24:25] offset:24
	v_mov_b32_e32 v3, 1
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[1:2], v3, off offset:384 scope:SCOPE_SYS
.LBB0_377:
	global_load_b32 v0, v0, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, 0, v0
	s_cbranch_vccnz .LBB0_379
	v_mov_b32_e32 v0, 0
	v_mov_b32_e32 v2, 1
	global_load_b64 v[0:1], v0, s[28:29] offset:24
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[0:1], v2, off offset:384 scope:SCOPE_SYS
.LBB0_379:
	s_endpgm
.Lfunc_end0:
	.size	qwen_bf16_ffnar_v1_h5120_i4352_b64_tp4r3_a1_f1, .Lfunc_end0-qwen_bf16_ffnar_v1_h5120_i4352_b64_tp4r3_a1_f1
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel qwen_bf16_ffnar_v1_h5120_i4352_b64_tp4r3_a1_f1
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
		.amdhsa_next_free_vgpr 46
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
		.amdhsa_inst_pref_size ((instprefsize(.Lfunc_end0-qwen_bf16_ffnar_v1_h5120_i4352_b64_tp4r3_a1_f1)<<4)&4080)>>4
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

	.set .Lqwen_bf16_ffnar_v1_h5120_i4352_b64_tp4r3_a1_f1.num_vgpr, 46
	.set .Lqwen_bf16_ffnar_v1_h5120_i4352_b64_tp4r3_a1_f1.num_agpr, 0
	.set .Lqwen_bf16_ffnar_v1_h5120_i4352_b64_tp4r3_a1_f1.numbered_sgpr, 44
	.set .Lqwen_bf16_ffnar_v1_h5120_i4352_b64_tp4r3_a1_f1.num_named_barrier, 0
	.set .Lqwen_bf16_ffnar_v1_h5120_i4352_b64_tp4r3_a1_f1.private_seg_size, 0
	.set .Lqwen_bf16_ffnar_v1_h5120_i4352_b64_tp4r3_a1_f1.uses_vcc, 1
	.set .Lqwen_bf16_ffnar_v1_h5120_i4352_b64_tp4r3_a1_f1.uses_flat_scratch, 0
	.set .Lqwen_bf16_ffnar_v1_h5120_i4352_b64_tp4r3_a1_f1.has_dyn_sized_stack, 0
	.set .Lqwen_bf16_ffnar_v1_h5120_i4352_b64_tp4r3_a1_f1.has_recursion, 0
	.set .Lqwen_bf16_ffnar_v1_h5120_i4352_b64_tp4r3_a1_f1.has_indirect_call, 0
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
    .name:           qwen_bf16_ffnar_v1_h5120_i4352_b64_tp4r3_a1_f1
    .private_segment_fixed_size: 0
    .reqd_workgroup_size:
      - 128
      - 1
      - 1
    .sgpr_count:     46
    .sgpr_spill_count: 0
    .symbol:         qwen_bf16_ffnar_v1_h5120_i4352_b64_tp4r3_a1_f1.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     46
    .vgpr_spill_count: 0
    .wavefront_size: 32
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1201
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
