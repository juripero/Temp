	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1201"
	.amdhsa_code_object_version 6
	.text
	.globl	qwen_bf16_ffnar_v1_h32_i32_b4_tp2r1_a1_f1
	.p2align	8
	.type	qwen_bf16_ffnar_v1_h32_i32_b4_tp2r1_a1_f1,@function
qwen_bf16_ffnar_v1_h32_i32_b4_tp2r1_a1_f1:
	s_load_b128 s[36:39], s[0:1], 0x70
	s_wait_kmcnt 0x0
	s_cmp_lt_i32 s36, 1
	s_cbranch_scc1 .LBB0_288
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
	s_cbranch_vccnz .LBB0_283
	s_wait_kmcnt 0x0
	global_load_b64 v[7:8], v1, s[24:25] offset:8
	s_load_b512 s[4:19], s[0:1], 0x0
	v_lshl_or_b32 v24, ttmp9, 7, v0
	s_lshl_b32 s33, s36, 5
	s_delay_alu instid0(VALU_DEP_1) | instid1(SALU_CYCLE_1)
	v_cmp_gt_i32_e64 s1, s33, v24
	s_wait_loadcnt 0x0
	global_load_b32 v6, v[7:8], off offset:256 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	s_and_saveexec_b32 s3, s1
	s_cbranch_execz .LBB0_7
	v_add_co_u32 v3, vcc_lo, 0x200, v7
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v4, null, 0, v8, vcc_lo
	v_mov_b32_e32 v1, v24
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
	v_add_co_u32 v9, s0, v3, v9
	global_load_d16_b16 v2, v[11:12], off
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v10, null, v4, v10, s0
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
	s_mov_b32 s0, exec_lo
	s_wait_kmcnt 0x0
	s_mov_b32 s4, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	v_mbcnt_lo_u32_b32 v1, s0, 0
	global_load_b32 v3, v2, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_10
	s_bcnt1_i32_b32 s0, s0
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v4, s0
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v4, v2, v4, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_10:
	s_or_b32 exec_lo, exec_lo, s4
	v_readfirstlane_b32 s0, v4
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v1, s0, v1
	s_mov_b32 s0, exec_lo
	v_cmpx_ne_u32_e32 3, v1
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s4, exec_lo, s0
	s_cbranch_execz .LBB0_15
	s_cmp_lt_i32 s38, 1
	s_mov_b32 s5, 1
	s_cbranch_scc1 .LBB0_44
	v_mov_b32_e32 v1, 0
.LBB0_13:
	global_load_b32 v2, v1, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	global_load_b32 v4, v1, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, v2, v3
	v_cmp_eq_u32_e64 s0, 0, v4
	s_and_b32 s0, vcc_lo, s0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s5, s38
	s_cselect_b32 s34, -1, 0
	s_add_co_i32 s5, s5, 1
	s_and_b32 s34, s0, s34
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_b32 vcc_lo, exec_lo, s34
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_13
	s_and_b32 vcc_lo, exec_lo, s0
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_45
.LBB0_15:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s0, s4
	s_cbranch_execz .LBB0_17
.LBB0_16:
	v_dual_mov_b32 v1, 0 :: v_dual_add_nc_u32 v2, 1, v3
	global_store_b32 v1, v1, s[20:21] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v1, v2, s[20:21] offset:4 scope:SCOPE_DEV
.LBB0_17:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s0
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
	s_cbranch_vccnz .LBB0_283
	v_or_b32_e32 v1, ttmp9, v0
	v_add_nc_u32_e32 v3, 1, v6
	s_delay_alu instid0(VALU_DEP_2)
	v_cmp_eq_u32_e64 s0, 0, v1
	s_wait_kmcnt 0x0
	s_and_saveexec_b32 s4, s0
	s_cbranch_execz .LBB0_36
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
	s_mov_b32 s5, 1
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
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s4, s2
	s_cbranch_execz .LBB0_55
	v_mov_b32_e32 v2, 0
	s_mov_b32 s3, exec_lo
	s_mov_b32 s5, exec_lo
	v_mbcnt_lo_u32_b32 v1, s3, 0
	global_load_b32 v6, v2, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_39
	s_bcnt1_i32_b32 s3, s3
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v4, s3
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v4, v2, v4, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_39:
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
	s_cbranch_execz .LBB0_52
	s_cmp_lt_i32 s38, 1
	s_mov_b32 s34, 1
	s_cbranch_scc1 .LBB0_48
	v_mov_b32_e32 v1, 0
.LBB0_42:
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
	s_cbranch_vccnz .LBB0_42
	s_and_b32 vcc_lo, exec_lo, s3
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_49
	s_branch .LBB0_52
.LBB0_44:
	s_cbranch_execz .LBB0_15
.LBB0_45:
	v_dual_mov_b32 v4, 1 :: v_dual_mov_b32 v5, 0
	s_mov_b32 s0, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v1, v5, v[4:5], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_47
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v2, ttmp9 :: v_dual_mov_b32 v1, 3
	global_store_b96 v5, v[1:3], s[22:23] offset:4
.LBB0_47:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s0
	s_and_not1_saveexec_b32 s0, s4
	s_cbranch_execnz .LBB0_16
	s_branch .LBB0_17
.LBB0_48:
	s_cbranch_execz .LBB0_52
.LBB0_49:
	v_dual_mov_b32 v1, 1 :: v_dual_mov_b32 v2, 0
	s_mov_b32 s3, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v1, v2, v[1:2], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_51
	v_dual_mov_b32 v5, ttmp9 :: v_dual_mov_b32 v4, 4
	global_store_b96 v2, v[4:6], s[22:23] offset:4
.LBB0_51:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
.LBB0_52:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s3, s5
	s_cbranch_execz .LBB0_54
	v_dual_mov_b32 v1, 0 :: v_dual_add_nc_u32 v2, 1, v6
	global_store_b32 v1, v1, s[20:21] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v1, v2, s[20:21] offset:4 scope:SCOPE_DEV
.LBB0_54:
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
.LBB0_55:
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
	s_cbranch_vccnz .LBB0_283
	s_and_saveexec_b32 s4, s1
	s_cbranch_execz .LBB0_61
	v_dual_mov_b32 v6, 0 :: v_dual_mov_b32 v1, v24
	s_cmp_lg_u32 s40, 0
	s_mov_b32 s5, 0
	s_cselect_b32 s34, -1, 0
	s_branch .LBB0_59
.LBB0_58:
	v_add_nc_u32_e32 v1, 0x200, v1
	v_add_co_u32 v4, s3, s18, v4
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v5, null, s19, v5, s3
	s_delay_alu instid0(VALU_DEP_3)
	v_cmp_le_i32_e32 vcc_lo, s33, v1
	global_store_b16 v[4:5], v2, off offset:2048
	s_or_b32 s5, vcc_lo, s5
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_b32 exec_lo, exec_lo, s5
	s_cbranch_execz .LBB0_61
.LBB0_59:
	global_load_b128 v[9:12], v6, s[24:25]
	v_ashrrev_i32_e32 v2, 31, v1
	s_and_b32 s3, s34, exec_lo
	s_cselect_b32 s3, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s3, 1
	v_lshlrev_b64_e32 v[4:5], 1, v[1:2]
	s_wait_loadcnt 0x0
	v_add_co_u32 v2, vcc_lo, 0x200, v9
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v10, null, 0, v10, vcc_lo
	v_add_co_u32 v11, vcc_lo, 0x200, v11
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v12, null, 0, v12, vcc_lo
	v_add_co_u32 v9, vcc_lo, v2, v4
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v10, null, v10, v5, vcc_lo
	v_add_co_u32 v11, vcc_lo, v11, v4
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v12, null, v12, v5, vcc_lo
	global_load_u16 v2, v[9:10], off
	global_load_u16 v9, v[11:12], off
	s_wait_loadcnt 0x1
	v_lshlrev_b32_e32 v2, 16, v2
	s_wait_loadcnt 0x0
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_dual_add_f32 v2, 0, v2 :: v_dual_lshlrev_b32 v9, 16, v9
	v_add_f32_e32 v2, v2, v9
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v9, v2, 16, 1
	v_or_b32_e32 v10, 0x400000, v2
	v_cmp_u_f32_e32 vcc_lo, v2, v2
	v_add3_u32 v9, v9, v2, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_cndmask_b32_e32 v2, v9, v10, vcc_lo
	v_lshrrev_b32_e32 v2, 16, v2
	s_cbranch_scc1 .LBB0_58
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
	s_branch .LBB0_58
.LBB0_61:
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
	s_cbranch_execz .LBB0_76
	v_mov_b32_e32 v2, 0
	s_mov_b32 s3, exec_lo
	s_mov_b32 s5, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	v_mbcnt_lo_u32_b32 v1, s3, 0
	global_load_b32 v6, v2, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_64
	s_bcnt1_i32_b32 s3, s3
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v4, s3
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v4, v2, v4, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_64:
	s_or_b32 exec_lo, exec_lo, s5
	v_readfirstlane_b32 s3, v4
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v1, s3, v1
	s_mov_b32 s3, exec_lo
	v_cmpx_ne_u32_e32 3, v1
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s5, exec_lo, s3
	s_cbranch_execz .LBB0_73
	s_cmp_lt_i32 s38, 1
	s_mov_b32 s26, 1
	s_cbranch_scc1 .LBB0_68
	v_mov_b32_e32 v1, 0
.LBB0_67:
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
	s_cbranch_vccnz .LBB0_67
	s_branch .LBB0_69
.LBB0_68:
	s_mov_b32 s3, -1
.LBB0_69:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s3
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccz .LBB0_73
	v_dual_mov_b32 v1, 1 :: v_dual_mov_b32 v2, 0
	s_mov_b32 s3, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v1, v2, v[1:2], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_72
	v_dual_mov_b32 v5, ttmp9 :: v_dual_mov_b32 v4, 5
	global_store_b96 v2, v[4:6], s[22:23] offset:4
.LBB0_72:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
.LBB0_73:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s3, s5
	s_cbranch_execz .LBB0_75
	v_dual_mov_b32 v1, 0 :: v_dual_add_nc_u32 v2, 1, v6
	global_store_b32 v1, v1, s[20:21] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v1, v2, s[20:21] offset:4 scope:SCOPE_DEV
.LBB0_75:
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
.LBB0_76:
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
	s_cbranch_vccnz .LBB0_283
	s_and_saveexec_b32 s4, s0
	s_cbranch_execz .LBB0_96
	s_cmp_gt_i32 s38, 0
	s_mov_b32 s26, 1
	s_cselect_b32 s5, -1, 0
	s_cmp_lt_i32 s38, 1
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[7:8], v3, off offset:128 scope:SCOPE_SYS
	s_cbranch_scc1 .LBB0_82
	v_mov_b32_e32 v4, 0
	global_load_b64 v[1:2], v4, s[24:25]
.LBB0_80:
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
	s_cmp_lt_i32 s26, s38
	s_cselect_b32 s27, -1, 0
	s_add_co_i32 s26, s26, 1
	v_cmp_ne_u32_e64 s3, v6, v3
	v_or_b32_e32 v5, v9, v5
	s_delay_alu instid0(VALU_DEP_1)
	v_cmp_eq_u32_e32 vcc_lo, 0, v5
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s27, vcc_lo, s27
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s27, s3, s27
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s27
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_80
	v_cmp_ne_u32_e32 vcc_lo, 0, v5
	s_or_b32 s3, s3, vcc_lo
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s3
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_83
	s_branch .LBB0_86
.LBB0_82:
	s_cbranch_execz .LBB0_86
.LBB0_83:
	v_dual_mov_b32 v4, 1 :: v_dual_mov_b32 v5, 0
	s_mov_b32 s3, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v1, v5, v[4:5], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_85
	v_dual_mov_b32 v1, 11 :: v_dual_mov_b32 v2, v5
	global_store_b96 v5, v[1:3], s[22:23] offset:4
.LBB0_85:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[7:8], v4, off offset:384 scope:SCOPE_SYS
.LBB0_86:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s3, s5, exec_lo
	s_cselect_b32 s3, 1, 0
	s_mov_b32 s5, 1
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s3, 1
	s_cbranch_scc1 .LBB0_90
	v_mov_b32_e32 v4, 0
	global_load_b64 v[1:2], v4, s[24:25] offset:8
.LBB0_88:
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
	v_cmp_ne_u32_e64 s3, v6, v3
	v_or_b32_e32 v5, v9, v5
	s_delay_alu instid0(VALU_DEP_1)
	v_cmp_eq_u32_e32 vcc_lo, 0, v5
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s26, vcc_lo, s26
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s26, s3, s26
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s26
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_88
	v_cmp_ne_u32_e32 vcc_lo, 0, v5
	s_or_b32 s3, s3, vcc_lo
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s3
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_91
	s_branch .LBB0_94
.LBB0_90:
	s_cbranch_execz .LBB0_94
.LBB0_91:
	v_dual_mov_b32 v4, 1 :: v_dual_mov_b32 v5, 0
	s_mov_b32 s3, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v1, v5, v[4:5], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_93
	v_dual_mov_b32 v1, 11 :: v_dual_mov_b32 v2, v5
	global_store_b96 v5, v[1:3], s[22:23] offset:4
.LBB0_93:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[7:8], v4, off offset:384 scope:SCOPE_SYS
.LBB0_94:
	v_mov_b32_e32 v1, 0
	global_load_b32 v1, v1, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_ne_u32_e32 vcc_lo, 0, v1
	s_cbranch_vccnz .LBB0_96
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[7:8], v3, off offset:256 scope:SCOPE_SYS
.LBB0_96:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s4, s2
	s_cbranch_execz .LBB0_111
	v_mov_b32_e32 v2, 0
	s_mov_b32 s3, exec_lo
	s_mov_b32 s5, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	v_mbcnt_lo_u32_b32 v1, s3, 0
	global_load_b32 v3, v2, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_99
	s_bcnt1_i32_b32 s3, s3
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v4, s3
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v4, v2, v4, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_99:
	s_or_b32 exec_lo, exec_lo, s5
	v_readfirstlane_b32 s3, v4
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v1, s3, v1
	s_mov_b32 s3, exec_lo
	v_cmpx_ne_u32_e32 3, v1
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s5, exec_lo, s3
	s_cbranch_execz .LBB0_108
	s_cmp_lt_i32 s38, 1
	s_mov_b32 s26, 1
	s_cbranch_scc1 .LBB0_103
	v_mov_b32_e32 v1, 0
.LBB0_102:
	global_load_b32 v2, v1, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	global_load_b32 v4, v1, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, v2, v3
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
	s_cbranch_vccnz .LBB0_102
	s_branch .LBB0_104
.LBB0_103:
	s_mov_b32 s3, -1
.LBB0_104:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s3
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccz .LBB0_108
	v_dual_mov_b32 v4, 1 :: v_dual_mov_b32 v5, 0
	s_mov_b32 s3, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v1, v5, v[4:5], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_107
	v_dual_mov_b32 v2, ttmp9 :: v_dual_mov_b32 v1, 6
	global_store_b96 v5, v[1:3], s[22:23] offset:4
.LBB0_107:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
.LBB0_108:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s3, s5
	s_cbranch_execz .LBB0_110
	v_dual_mov_b32 v1, 0 :: v_dual_add_nc_u32 v2, 1, v3
	global_store_b32 v1, v1, s[20:21] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v1, v2, s[20:21] offset:4 scope:SCOPE_DEV
.LBB0_110:
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
.LBB0_111:
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
	s_cbranch_vccnz .LBB0_283
	v_lshrrev_b32_e32 v1, 5, v0
	s_cmp_ge_i32 ttmp9, s36
	s_delay_alu instid0(VALU_DEP_1)
	v_readfirstlane_b32 s26, v1
	s_cbranch_scc1 .LBB0_123
	v_and_b32_e32 v1, 31, v0
	v_lshlrev_b32_e32 v3, 1, v0
	v_cmp_gt_u32_e64 s3, 32, v0
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
	v_cmp_eq_u32_e64 s4, 0, v1
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v7, v2, v7, vcc_lo
	v_cmp_ne_u32_e32 vcc_lo, 31, v1
	v_add_co_u32 v1, s8, s8, v3
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v2, null, s9, 0, s8
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v8, 0x7c, v8, vcc_lo
	v_lshl_add_u32 v3, ttmp9, 5, v0
	s_lshl_b32 s8, s26, 2
	s_branch .LBB0_115
.LBB0_114:
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
	s_cbranch_scc0 .LBB0_123
.LBB0_115:
	s_delay_alu instid0(VALU_DEP_1)
	v_ashrrev_i32_e32 v4, 31, v3
	v_mov_b32_e32 v10, 0
	s_and_saveexec_b32 s9, s3
	s_cbranch_execz .LBB0_117
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshlrev_b64_e32 v[10:11], 1, v[3:4]
	v_add_co_u32 v12, vcc_lo, s18, v10
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_add_co_ci_u32_e64 v13, null, s19, v11, vcc_lo
	v_add_co_u32 v14, vcc_lo, s6, v10
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v15, null, s7, v11, vcc_lo
	global_load_u16 v12, v[12:13], off offset:2048
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
.LBB0_117:
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
	s_and_saveexec_b32 s9, s4
	s_cbranch_execz .LBB0_119
	s_wait_dscnt 0x0
	v_dual_add_f32 v10, v10, v11 :: v_dual_mov_b32 v11, s8
	ds_store_b32 v11, v10
.LBB0_119:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s9
	s_wait_storecnt 0x0
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s9, s2
	s_cbranch_execz .LBB0_121
	ds_load_b128 v[10:13], v9
	s_wait_dscnt 0x0
	v_readfirstlane_b32 s27, v10
	v_readfirstlane_b32 s34, v11
	v_readfirstlane_b32 s35, v12
	s_add_f32 s27, s27, 0
	s_wait_alu depctr_sa_sdst(0)
	s_delay_alu instid0(SALU_CYCLE_2) | instskip(SKIP_2) | instid1(SALU_CYCLE_1)
	s_add_f32 s27, s27, s34
	v_readfirstlane_b32 s34, v13
	s_wait_alu depctr_sa_sdst(0)
	s_add_f32 s27, s27, s35
	s_wait_alu depctr_sa_sdst(0)
	s_delay_alu instid0(SALU_CYCLE_2) | instskip(SKIP_1) | instid1(SALU_CYCLE_2)
	s_add_f32 s27, s27, s34
	s_wait_alu depctr_sa_sdst(0)
	s_mul_f32 s27, s27, 0x3d000000
	s_wait_alu depctr_sa_sdst(0)
	s_delay_alu instid0(SALU_CYCLE_2) | instskip(SKIP_1) | instid1(SALU_CYCLE_2)
	s_add_f32 s27, s37, s27
	s_wait_alu depctr_sa_sdst(0)
	s_mul_f32 s34, s27, 0x4f800000
	s_cmp_lt_f32 s27, 0xf800000
	s_wait_alu depctr_sa_sdst(0)
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_3) | instid1(TRANS32_DEP_1)
	s_cselect_b32 s34, s34, s27
	s_wait_alu depctr_sa_sdst(0)
	v_s_sqrt_f32 s35, s34
	s_mov_b32 s40, s34
	s_add_co_i32 s39, s35, -1
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_xor_b32 s43, s39, 0x80000000
	s_fmac_f32 s40, s43, s35
	s_mov_b32 s43, s34
	s_delay_alu instid0(SALU_CYCLE_2) | instskip(SKIP_2) | instid1(SALU_CYCLE_1)
	s_cmp_le_f32 s40, 0
	s_cselect_b32 s39, s39, s35
	s_add_co_i32 s40, s35, 1
	s_xor_b32 s44, s40, 0x80000000
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_2)
	s_fmac_f32 s43, s44, s35
	v_cmp_class_f32_e64 s35, s34, 0x260
	s_cmp_gt_f32 s43, 0
	s_cselect_b32 s39, s40, s39
	s_cmp_lt_f32 s27, 0xf800000
	s_mul_f32 s27, s39, 0x37800000
	s_wait_alu depctr_sa_sdst(0)
	s_delay_alu instid0(SALU_CYCLE_2)
	s_cselect_b32 s27, s27, s39
	s_and_b32 s35, s35, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	s_cselect_b32 s27, s34, s27
	s_wait_alu depctr_sa_sdst(0)
	v_div_scale_f32 v10, null, s27, s27, 1.0
	s_delay_alu instid0(VALU_DEP_1)
	v_rcp_f32_e32 v11, v10
	v_xor_b32_e32 v10, 0x80000000, v10
	s_delay_alu instid0(TRANS32_DEP_1) | instid1(VALU_DEP_1)
	v_fma_f32 v12, v10, v11, 1.0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_fmac_f32_e32 v11, v12, v11
	v_div_scale_f32 v12, vcc_lo, 1.0, s27, 1.0
	v_mul_f32_e32 v13, v12, v11
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fma_f32 v14, v10, v13, v12
	v_fmac_f32_e32 v13, v14, v11
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_fmac_f32_e32 v12, v10, v13
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v10, v12, v11, v13
	s_delay_alu instid0(VALU_DEP_1)
	v_div_fixup_f32 v10, v10, s27, 1.0
	ds_store_b32 v9, v10 offset:16
.LBB0_121:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s9
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s9, s3
	s_cbranch_execz .LBB0_114
	v_lshlrev_b64_e32 v[10:11], 1, v[3:4]
	ds_load_b32 v14, v9 offset:16
	v_add_co_u32 v12, vcc_lo, s18, v10
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v13, null, s19, v11, vcc_lo
	v_add_co_u32 v10, vcc_lo, s6, v10
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v11, null, s7, v11, vcc_lo
	global_load_u16 v4, v[12:13], off offset:2048
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
	s_branch .LBB0_114
.LBB0_123:
	s_wait_loadcnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s4, s2
	s_cbranch_execz .LBB0_138
	v_mov_b32_e32 v2, 0
	s_mov_b32 s3, exec_lo
	s_mov_b32 s5, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	v_mbcnt_lo_u32_b32 v1, s3, 0
	global_load_b32 v3, v2, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_126
	s_bcnt1_i32_b32 s3, s3
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v4, s3
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v4, v2, v4, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_126:
	s_or_b32 exec_lo, exec_lo, s5
	v_readfirstlane_b32 s3, v4
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v1, s3, v1
	s_mov_b32 s3, exec_lo
	v_cmpx_ne_u32_e32 3, v1
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s5, exec_lo, s3
	s_cbranch_execz .LBB0_135
	s_cmp_lt_i32 s38, 1
	s_mov_b32 s6, 1
	s_cbranch_scc1 .LBB0_130
	v_mov_b32_e32 v1, 0
.LBB0_129:
	global_load_b32 v2, v1, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	global_load_b32 v4, v1, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, v2, v3
	v_cmp_eq_u32_e64 s3, 0, v4
	s_and_b32 s3, vcc_lo, s3
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s6, s38
	s_cselect_b32 s7, -1, 0
	s_add_co_i32 s6, s6, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s7, s3, s7
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s7
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_129
	s_branch .LBB0_131
.LBB0_130:
	s_mov_b32 s3, -1
.LBB0_131:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s3
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccz .LBB0_135
	v_dual_mov_b32 v4, 1 :: v_dual_mov_b32 v5, 0
	s_mov_b32 s3, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v1, v5, v[4:5], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_134
	v_dual_mov_b32 v2, ttmp9 :: v_dual_mov_b32 v1, v4
	global_store_b96 v5, v[1:3], s[22:23] offset:4
.LBB0_134:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
.LBB0_135:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s3, s5
	s_cbranch_execz .LBB0_137
	v_dual_mov_b32 v1, 0 :: v_dual_add_nc_u32 v2, 1, v3
	global_store_b32 v1, v1, s[20:21] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v1, v2, s[20:21] offset:4 scope:SCOPE_DEV
.LBB0_137:
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
.LBB0_138:
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
	s_cbranch_vccnz .LBB0_283
	v_lshrrev_b32_e32 v1, 1, v0
	s_lshl_b32 s6, ttmp9, 2
	v_and_b32_e32 v30, 15, v0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s8, s6, s26
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s8, 2
	v_and_b32_e32 v29, 8, v1
	s_cselect_b32 s7, -1, 0
	s_cmp_gt_i32 s8, 1
	s_cbranch_scc1 .LBB0_148
	v_lshlrev_b32_e32 v31, 5, v30
	v_cmp_gt_i32_e64 s3, s36, v30
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_or_b32_e32 v32, v31, v29
	v_lshlrev_b32_e32 v0, 1, v32
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_u32 v25, s4, s18, v0
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v26, null, s19, 0, s4
	s_branch .LBB0_142
.LBB0_141:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s9
	s_add_co_i32 s4, s8, 16
	s_cmp_lt_i32 s8, -14
	s_wait_alu depctr_sa_sdst(0)
	s_mov_b32 s8, s4
	s_cbranch_scc0 .LBB0_148
.LBB0_142:
	v_dual_mov_b32 v16, 0 :: v_dual_mov_b32 v17, 0
	v_dual_mov_b32 v18, 0 :: v_dual_mov_b32 v19, 0
	s_and_saveexec_b32 s4, s3
	s_cbranch_execz .LBB0_144
	global_load_b128 v[16:19], v[25:26], off
.LBB0_144:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	v_lshl_or_b32 v0, s8, 9, v32
	v_dual_mov_b32 v20, 0 :: v_dual_mov_b32 v21, 0
	v_dual_mov_b32 v22, 0 :: v_dual_mov_b32 v23, 0
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v1, 31, v0
	v_lshlrev_b64_e32 v[0:1], 1, v[0:1]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v27, vcc_lo, s10, v0
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v28, null, s11, v1, vcc_lo
	s_clause 0x1
	global_load_b128 v[0:3], v[27:28], off
	global_load_b128 v[33:36], v[27:28], off offset:2048
	s_wait_loadcnt 0x1
	v_wmma_f32_16x16x16_bf16 v[8:15], v[0:3], v[16:19], 0
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[33:36], v[16:19], 0
	s_and_saveexec_b32 s4, s3
	s_cbranch_execz .LBB0_146
	global_load_b128 v[20:23], v[25:26], off offset:32
.LBB0_146:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	s_clause 0x1
	global_load_b128 v[16:19], v[27:28], off offset:32
	global_load_b128 v[33:36], v[27:28], off offset:2080
	s_wait_loadcnt 0x1
	v_wmma_f32_16x16x16_bf16 v[8:15], v[16:19], v[20:23], v[8:15]
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[33:36], v[20:23], v[0:7]
	s_and_saveexec_b32 s9, s3
	s_cbranch_execz .LBB0_141
	v_bfe_u32 v16, v8, 16, 1
	v_or_b32_e32 v17, 0x400000, v8
	v_bfe_u32 v18, v9, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v8, v8
	v_or_b32_e32 v19, 0x400000, v9
	v_add3_u32 v16, v16, v8, 0x7fff
	v_bfe_u32 v22, v10, 16, 1
	v_add3_u32 v18, v18, v9, 0x7fff
	v_or_b32_e32 v23, 0x400000, v10
	v_bfe_u32 v33, v11, 16, 1
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v8, v16, v17, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v9, v9
	v_add3_u32 v22, v22, v10, 0x7fff
	v_bfe_u32 v16, v0, 16, 1
	v_or_b32_e32 v34, 0x400000, v11
	v_add3_u32 v33, v33, v11, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_dual_cndmask_b32 v9, v18, v19 :: v_dual_and_b32 v20, 0xffff0000, v8
	v_lshl_or_b32 v8, s8, 4, v29
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	v_or_b32_e32 v17, 0x400000, v0
	s_delay_alu instid0(VALU_DEP_4)
	v_and_b32_e32 v27, 0xffff0000, v9
	v_mul_f32_e32 v18, 0xbfb8aa3b, v20
	v_add3_u32 v16, v16, v0, 0x7fff
	v_bfe_u32 v21, v1, 16, 1
	v_or_b32_e32 v19, 0x400000, v1
	v_mul_f32_e32 v35, 0xbfb8aa3b, v27
	v_fma_f32 v9, 0xbfb8aa3b, v20, -v18
	v_rndne_f32_e32 v28, v18
	v_add3_u32 v21, v21, v1, 0x7fff
	v_add_nc_u32_e32 v8, v8, v31
	v_cmp_u_f32_e64 s4, v1, v1
	v_fmac_f32_e32 v9, 0xb2a5705f, v20
	v_sub_f32_e32 v18, v18, v28
	v_fma_f32 v38, 0xbfb8aa3b, v27, -v35
	v_cvt_i32_f32_e32 v28, v28
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v19, v21, v19, s4
	v_bfe_u32 v36, v12, 16, 1
	v_add_f32_e32 v9, v18, v9
	v_rndne_f32_e32 v18, v35
	v_fmac_f32_e32 v38, 0xb2a5705f, v27
	v_or_b32_e32 v37, 0x400000, v12
	v_add3_u32 v36, v36, v12, 0x7fff
	v_exp_f32_e32 v9, v9
	s_wait_alu depctr_va_vcc(0)
	v_dual_sub_f32 v35, v35, v18 :: v_dual_cndmask_b32 v10, v22, v23
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	v_cvt_i32_f32_e32 v18, v18
	v_and_b32_e32 v19, 0xffff0000, v19
	s_delay_alu instid0(VALU_DEP_4)
	v_add_f32_e32 v35, v35, v38
	v_and_b32_e32 v10, 0xffff0000, v10
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v11, v33, v34, vcc_lo
	v_ldexp_f32 v9, v9, v28
	v_cmp_nlt_f32_e32 vcc_lo, 0x42ce8ed0, v20
	v_exp_f32_e32 v22, v35
	v_cmp_nlt_f32_e64 s4, 0x42ce8ed0, v10
	v_cmp_ngt_f32_e64 s5, 0xc2b17218, v10
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v9, 0, v9, vcc_lo
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2b17218, v20
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_cndmask_b32_e32 v9, 0x7f800000, v9, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v0, v0
	s_wait_alu depctr_va_vcc(0)
	v_dual_cndmask_b32 v0, v16, v17 :: v_dual_and_b32 v11, 0xffff0000, v11
	v_ldexp_f32 v16, v22, v18
	v_dual_add_f32 v18, 1.0, v9 :: v_dual_mul_f32 v17, 0xbfb8aa3b, v10
	v_cmp_nlt_f32_e32 vcc_lo, 0x42ce8ed0, v27
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_mul_f32_e32 v22, 0xbfb8aa3b, v11
	v_div_scale_f32 v23, null, v18, v18, v20
	s_delay_alu instid0(VALU_DEP_4)
	v_rndne_f32_e32 v28, v17
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v9, 0, v16, vcc_lo
	v_fma_f32 v16, 0xbfb8aa3b, v10, -v17
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2b17218, v27
	v_rcp_f32_e32 v33, v23
	v_fma_f32 v34, 0xbfb8aa3b, v11, -v22
	s_delay_alu instid0(VALU_DEP_3)
	v_dual_sub_f32 v17, v17, v28 :: v_dual_fmac_f32 v16, 0xb2a5705f, v10
	v_rndne_f32_e32 v38, v22
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v9, 0x7f800000, v9, vcc_lo
	v_fmac_f32_e32 v34, 0xb2a5705f, v11
	v_div_scale_f32 v40, vcc_lo, v20, v18, v20
	v_add_f32_e32 v16, v17, v16
	v_fma_f32 v39, -v23, v33, 1.0
	v_dual_sub_f32 v22, v22, v38 :: v_dual_add_f32 v35, 1.0, v9
	v_cvt_i32_f32_e32 v28, v28
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_exp_f32_e32 v16, v16
	v_dual_fmac_f32 v33, v39, v33 :: v_dual_add_f32 v22, v22, v34
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_2) | instid1(VALU_DEP_4)
	v_div_scale_f32 v17, null, v35, v35, v27
	v_and_b32_e32 v34, 0xffff0000, v0
	v_ashrrev_i32_e32 v9, 31, v8
	v_mul_f32_e32 v21, v40, v33
	v_cvt_i32_f32_e32 v38, v38
	v_rcp_f32_e32 v41, v17
	s_delay_alu instid0(TRANS32_DEP_2) | instskip(SKIP_3) | instid1(VALU_DEP_2)
	v_ldexp_f32 v0, v16, v28
	v_exp_f32_e32 v16, v22
	v_fma_f32 v22, -v23, v21, v40
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v0, 0, v0, s4
	v_div_scale_f32 v28, s4, v27, v35, v27
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(TRANS32_DEP_2)
	v_fmac_f32_e32 v21, v22, v33
	v_fma_f32 v1, -v17, v41, 1.0
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_cndmask_b32_e64 v22, 0x7f800000, v0, s5
	v_cmp_u_f32_e64 s5, v6, v6
	v_fmac_f32_e32 v41, v1, v41
	v_lshlrev_b64_e32 v[0:1], 1, v[8:9]
	v_ldexp_f32 v9, v16, v38
	v_fma_f32 v16, -v23, v21, v40
	v_add_f32_e32 v22, 1.0, v22
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_div_fmas_f32 v16, v16, v33, v21
	v_div_scale_f32 v21, null, v22, v22, v10
	v_cmp_nlt_f32_e32 vcc_lo, 0x42ce8ed0, v11
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_div_fixup_f32 v16, v16, v18, v20
	v_rcp_f32_e32 v18, v21
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_mul_f32_e32 v16, v16, v34
	v_mul_f32_e32 v39, v28, v41
	v_bfe_u32 v20, v16, 16, 1
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_fma_f32 v23, -v17, v39, v28
	v_add3_u32 v20, v20, v16, 0x7fff
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(TRANS32_DEP_1)
	v_fmac_f32_e32 v39, v23, v41
	v_fma_f32 v23, -v21, v18, 1.0
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_fma_f32 v17, -v17, v39, v28
	s_wait_alu depctr_va_vcc(0)
	v_dual_fmac_f32 v18, v23, v18 :: v_dual_cndmask_b32 v9, 0, v9
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2b17218, v11
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_cndmask_b32_e32 v9, 0x7f800000, v9, vcc_lo
	s_mov_b32 vcc_lo, s4
	v_cmp_u_f32_e64 s4, v16, v16
	s_wait_alu depctr_sa_sdst(0)
	v_div_fmas_f32 v17, v17, v41, v39
	v_div_scale_f32 v28, vcc_lo, v10, v22, v10
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_3) | instid1(VALU_DEP_2)
	v_div_fixup_f32 v17, v17, v35, v27
	v_or_b32_e32 v27, 0x400000, v16
	v_or_b32_e32 v35, 0x400000, v2
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v16, v20, v27, s4
	v_add_co_u32 v0, s4, s18, v0
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v1, null, s19, v1, s4
	v_cmp_u_f32_e64 s4, v12, v12
	v_mul_f32_e32 v20, v28, v18
	v_bfe_u32 v27, v2, 16, 1
	v_lshrrev_b32_e32 v16, 16, v16
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v12, v36, v37, s4
	v_fma_f32 v33, -v21, v20, v28
	v_add3_u32 v27, v27, v2, 0x7fff
	v_cmp_u_f32_e64 s4, v2, v2
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_dual_mul_f32 v17, v17, v19 :: v_dual_and_b32 v12, 0xffff0000, v12
	v_fmac_f32_e32 v20, v33, v18
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_cndmask_b32_e64 v2, v27, v35, s4
	v_mul_f32_e32 v36, 0xbfb8aa3b, v12
	v_bfe_u32 v23, v17, 16, 1
	v_fma_f32 v21, -v21, v20, v28
	s_delay_alu instid0(VALU_DEP_4)
	v_and_b32_e32 v2, 0xffff0000, v2
	v_or_b32_e32 v33, 0x400000, v17
	v_rndne_f32_e32 v35, v36
	v_fma_f32 v28, 0xbfb8aa3b, v12, -v36
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v18, v21, v18, v20
	v_add3_u32 v23, v23, v17, 0x7fff
	v_cmp_u_f32_e64 s4, v17, v17
	v_dual_sub_f32 v20, v36, v35 :: v_dual_add_f32 v9, 1.0, v9
	v_fmac_f32_e32 v28, 0xb2a5705f, v12
	v_div_fixup_f32 v10, v18, v22, v10
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v17, v23, v33, s4
	v_cmp_u_f32_e64 s4, v3, v3
	v_div_scale_f32 v19, null, v9, v9, v11
	v_div_scale_f32 v21, vcc_lo, v11, v9, v11
	v_add_f32_e32 v18, v20, v28
	v_mul_f32_e32 v10, v10, v2
	v_bfe_u32 v2, v3, 16, 1
	v_rcp_f32_e32 v34, v19
	v_or_b32_e32 v28, 0x400000, v3
	v_lshrrev_b32_e32 v17, 16, v17
	v_bfe_u32 v33, v14, 16, 1
	v_add3_u32 v2, v2, v3, 0x7fff
	v_or_b32_e32 v36, 0x400000, v5
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(TRANS32_DEP_1)
	v_mov_b16_e32 v16.h, v17.l
	v_fma_f32 v27, -v19, v34, 1.0
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v3, v2, v28, s4
	v_cmp_nlt_f32_e64 s4, 0x42ce8ed0, v12
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_fmac_f32_e32 v34, v27, v34
	v_cvt_i32_f32_e32 v27, v35
	v_mul_f32_e32 v20, v21, v34
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fma_f32 v22, -v19, v20, v21
	v_fmac_f32_e32 v20, v22, v34
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_3) | instid1(VALU_DEP_2)
	v_fma_f32 v2, -v19, v20, v21
	v_and_b32_e32 v21, 0xffff0000, v3
	v_exp_f32_e32 v18, v18
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v19, v2, v34, v20
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2b17218, v12
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(TRANS32_DEP_1)
	v_div_fixup_f32 v9, v19, v9, v11
	v_ldexp_f32 v18, v18, v27
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_mul_f32_e32 v9, v9, v21
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v18, 0, v18, s4
	v_bfe_u32 v23, v10, 16, 1
	v_or_b32_e32 v20, 0x400000, v10
	v_bfe_u32 v17, v9, 16, 1
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v18, 0x7f800000, v18, vcc_lo
	v_add_nc_u32_e32 v2, 3, v8
	v_add3_u32 v22, v23, v10, 0x7fff
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	v_add3_u32 v17, v17, v9, 0x7fff
	v_add_f32_e32 v11, 1.0, v18
	v_bfe_u32 v18, v13, 16, 1
	v_ashrrev_i32_e32 v3, 31, v2
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v19, v22, v20, vcc_lo
	v_or_b32_e32 v20, 0x400000, v13
	v_div_scale_f32 v10, null, v11, v11, v12
	v_add3_u32 v18, v18, v13, 0x7fff
	v_cmp_u_f32_e32 vcc_lo, v13, v13
	v_bfe_u32 v22, v4, 16, 1
	v_cmp_u_f32_e64 s4, v9, v9
	v_rcp_f32_e32 v21, v10
	v_lshlrev_b64_e32 v[2:3], 1, v[2:3]
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v13, v18, v20, vcc_lo
	v_or_b32_e32 v20, 0x400000, v9
	v_add3_u32 v9, v22, v4, 0x7fff
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(TRANS32_DEP_1)
	v_add_co_u32 v2, vcc_lo, s18, v2
	v_fma_f32 v18, -v10, v21, 1.0
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v17, v17, v20, s4
	v_or_b32_e32 v20, 0x400000, v4
	v_cmp_u_f32_e64 s4, v4, v4
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v3, null, s19, v3, vcc_lo
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_3) | instid1(VALU_DEP_4)
	v_cndmask_b32_e64 v4, v9, v20, s4
	v_fmac_f32_e32 v21, v18, v21
	v_div_scale_f32 v18, vcc_lo, v12, v11, v12
	v_cmp_u_f32_e64 s4, v14, v14
	v_and_b32_e32 v4, 0xffff0000, v4
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_mul_f32_e32 v22, v18, v21
	v_and_b32_e32 v13, 0xffff0000, v13
	v_fma_f32 v20, -v10, v22, v18
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_mul_f32_e32 v23, 0xbfb8aa3b, v13
	v_fmac_f32_e32 v22, v20, v21
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_2) | instid1(VALU_DEP_4)
	v_rndne_f32_e32 v28, v23
	v_fma_f32 v27, 0xbfb8aa3b, v13, -v23
	v_bfe_u32 v20, v15, 16, 1
	v_fma_f32 v10, -v10, v22, v18
	s_delay_alu instid0(VALU_DEP_4)
	v_sub_f32_e32 v9, v23, v28
	v_add3_u32 v23, v33, v14, 0x7fff
	v_or_b32_e32 v33, 0x400000, v14
	v_cvt_i32_f32_e32 v18, v28
	v_add3_u32 v20, v20, v15, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v10, v10, v21, v22
	v_cmp_u_f32_e32 vcc_lo, v15, v15
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v14, v23, v33, s4
	v_or_b32_e32 v23, 0x400000, v15
	v_div_fixup_f32 v11, v10, v11, v12
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_dual_cndmask_b32 v15, v20, v23 :: v_dual_and_b32 v14, 0xffff0000, v14
	v_fmac_f32_e32 v27, 0xb2a5705f, v13
	v_cmp_nlt_f32_e32 vcc_lo, 0x42ce8ed0, v13
	v_cmp_ngt_f32_e64 s4, 0xc2b17218, v14
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v9, v9, v27
	v_exp_f32_e32 v9, v9
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_ldexp_f32 v9, v9, v18
	s_wait_alu depctr_va_vcc(0)
	v_dual_mul_f32 v18, 0xbfb8aa3b, v14 :: v_dual_cndmask_b32 v9, 0, v9
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_3) | instid1(VALU_DEP_4)
	v_fma_f32 v12, 0xbfb8aa3b, v14, -v18
	v_rndne_f32_e32 v20, v18
	v_and_b32_e32 v15, 0xffff0000, v15
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2b17218, v13
	v_fmac_f32_e32 v12, 0xb2a5705f, v14
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_2) | instid1(VALU_DEP_1)
	v_sub_f32_e32 v18, v18, v20
	s_wait_alu depctr_va_vcc(0)
	v_dual_cndmask_b32 v10, 0x7f800000, v9 :: v_dual_add_nc_u32 v9, 4, v8
	v_dual_mul_f32 v21, 0xbfb8aa3b, v15 :: v_dual_add_f32 v22, 1.0, v10
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_ashrrev_i32_e32 v10, 31, v9
	v_fma_f32 v23, 0xbfb8aa3b, v15, -v21
	v_add_f32_e32 v12, v18, v12
	v_rndne_f32_e32 v27, v21
	v_div_scale_f32 v18, null, v22, v22, v13
	v_lshlrev_b64_e32 v[9:10], 1, v[9:10]
	v_fmac_f32_e32 v23, 0xb2a5705f, v15
	v_exp_f32_e32 v12, v12
	v_mul_f32_e32 v11, v11, v4
	v_cvt_i32_f32_e32 v4, v20
	v_rcp_f32_e32 v28, v18
	v_add_co_u32 v9, vcc_lo, s18, v9
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v10, null, s19, v10, vcc_lo
	v_cmp_nlt_f32_e32 vcc_lo, 0x42ce8ed0, v14
	s_delay_alu instid0(TRANS32_DEP_2) | instskip(SKIP_1) | instid1(TRANS32_DEP_1)
	v_ldexp_f32 v4, v12, v4
	v_sub_f32_e32 v21, v21, v27
	v_fma_f32 v12, -v18, v28, 1.0
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_cndmask_b32_e32 v4, 0, v4, vcc_lo
	v_add_f32_e32 v20, v21, v23
	v_div_scale_f32 v23, vcc_lo, v13, v22, v13
	v_fmac_f32_e32 v28, v12, v28
	v_cvt_i32_f32_e32 v12, v27
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v4, 0x7f800000, v4, s4
	v_exp_f32_e32 v20, v20
	v_cmp_nlt_f32_e64 s4, 0x42ce8ed0, v15
	v_mul_f32_e32 v27, v23, v28
	v_bfe_u32 v21, v11, 16, 1
	v_add_f32_e32 v33, 1.0, v4
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_fma_f32 v34, -v18, v27, v23
	v_add3_u32 v21, v21, v11, 0x7fff
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_ldexp_f32 v12, v20, v12
	v_div_scale_f32 v35, null, v33, v33, v14
	v_or_b32_e32 v20, 0x400000, v11
	v_fmac_f32_e32 v27, v34, v28
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v4, 0, v12, s4
	v_bfe_u32 v12, v5, 16, 1
	v_cmp_ngt_f32_e64 s4, 0xc2b17218, v15
	v_rcp_f32_e32 v34, v35
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add3_u32 v12, v12, v5, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v4, 0x7f800000, v4, s4
	v_cmp_u_f32_e64 s4, v5, v5
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(TRANS32_DEP_1)
	v_cndmask_b32_e64 v5, v12, v36, s4
	v_fma_f32 v12, -v18, v27, v23
	v_fma_f32 v23, -v35, v34, 1.0
	v_cmp_u_f32_e64 s4, v11, v11
	v_or_b32_e32 v36, 0x400000, v6
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v12, v12, v28, v27
	v_dual_fmac_f32 v34, v23, v34 :: v_dual_and_b32 v27, 0xffff0000, v5
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v20, v21, v20, s4
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_2) | instid1(VALU_DEP_2)
	v_div_fixup_f32 v12, v12, v22, v13
	v_div_scale_f32 v13, vcc_lo, v14, v33, v14
	v_bfe_u32 v22, v6, 16, 1
	v_dual_mul_f32 v11, v12, v27 :: v_dual_mul_f32 v12, v13, v34
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_add3_u32 v22, v22, v6, 0x7fff
	v_fma_f32 v27, -v35, v12, v13
	v_add_f32_e32 v37, 1.0, v4
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_4)
	v_cndmask_b32_e64 v6, v22, v36, s5
	v_bfe_u32 v22, v7, 16, 1
	v_fmac_f32_e32 v12, v27, v34
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_div_scale_f32 v18, null, v37, v37, v15
	v_add3_u32 v22, v22, v7, 0x7fff
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_fma_f32 v13, -v35, v12, v13
	v_rcp_f32_e32 v28, v18
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_1)
	v_div_fmas_f32 v12, v13, v34, v12
	v_and_b32_e32 v13, 0xffff0000, v6
	v_or_b32_e32 v34, 0x400000, v7
	v_cmp_u_f32_e32 vcc_lo, v7, v7
	v_add_nc_u32_e32 v6, 6, v8
	v_div_fixup_f32 v12, v12, v33, v14
	v_add_nc_u32_e32 v4, 5, v8
	v_fma_f32 v21, -v18, v28, 1.0
	v_bfe_u32 v23, v11, 16, 1
	v_ashrrev_i32_e32 v7, 31, v6
	v_mul_f32_e32 v13, v12, v13
	v_ashrrev_i32_e32 v5, 31, v4
	v_fmac_f32_e32 v28, v21, v28
	v_add3_u32 v23, v23, v11, 0x7fff
	v_or_b32_e32 v12, 0x400000, v11
	v_lshlrev_b64_e32 v[6:7], 1, v[6:7]
	v_lshlrev_b64_e32 v[4:5], 1, v[4:5]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v4, s4, s18, v4
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v5, null, s19, v5, s4
	v_div_scale_f32 v21, s4, v15, v37, v15
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v27, v21, v28
	v_fma_f32 v35, -v18, v27, v21
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fmac_f32_e32 v27, v35, v28
	v_fma_f32 v14, -v18, v27, v21
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v18, v22, v34, vcc_lo
	s_mov_b32 vcc_lo, s4
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_4) | instid1(VALU_DEP_3)
	v_and_b32_e32 v18, 0xffff0000, v18
	s_wait_alu depctr_sa_sdst(0)
	v_div_fmas_f32 v14, v14, v28, v27
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	v_add_nc_u32_e32 v11, 7, v8
	v_div_fixup_f32 v14, v14, v37, v15
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v21, v23, v12, vcc_lo
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_3) | instid1(VALU_DEP_4)
	v_ashrrev_i32_e32 v12, 31, v11
	v_bfe_u32 v15, v13, 16, 1
	v_add_co_u32 v6, vcc_lo, s18, v6
	v_mul_f32_e32 v8, v14, v18
	v_lshlrev_b64_e32 v[11:12], 1, v[11:12]
	s_delay_alu instid0(VALU_DEP_4)
	v_add3_u32 v14, v15, v13, 0x7fff
	v_or_b32_e32 v15, 0x400000, v13
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v7, null, s19, v7, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v13, v13
	v_bfe_u32 v18, v8, 16, 1
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v13, v14, v15, vcc_lo
	v_add_co_u32 v11, vcc_lo, s18, v11
	s_delay_alu instid0(VALU_DEP_3)
	v_add3_u32 v14, v18, v8, 0x7fff
	v_or_b32_e32 v15, 0x400000, v8
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v12, null, s19, v12, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v8, v8
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v8, v14, v15, vcc_lo
	s_clause 0x6
	global_store_d16_hi_b16 v[0:1], v19, off offset:1028
	global_store_b32 v[0:1], v16, off offset:1024
	global_store_d16_hi_b16 v[2:3], v17, off offset:1024
	global_store_d16_hi_b16 v[9:10], v20, off offset:1024
	global_store_d16_hi_b16 v[4:5], v21, off offset:1024
	global_store_d16_hi_b16 v[6:7], v13, off offset:1024
	global_store_d16_hi_b16 v[11:12], v8, off offset:1024
	s_branch .LBB0_141
.LBB0_148:
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s3, s2
	s_cbranch_execz .LBB0_163
	v_mov_b32_e32 v1, 0
	s_mov_b32 s5, exec_lo
	s_mov_b32 s8, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	v_mbcnt_lo_u32_b32 v0, s5, 0
	global_load_b32 v2, v1, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s4, v2
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_151
	s_bcnt1_i32_b32 s5, s5
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v2, s5
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v2, v1, v2, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_151:
	s_or_b32 exec_lo, exec_lo, s8
	v_readfirstlane_b32 s5, v2
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v0, s5, v0
	s_mov_b32 s5, exec_lo
	v_cmpx_ne_u32_e32 3, v0
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s5, exec_lo, s5
	s_cbranch_execz .LBB0_160
	s_cmp_lt_i32 s38, 1
	s_mov_b32 s8, 1
	s_cbranch_scc1 .LBB0_155
	v_mov_b32_e32 v0, 0
.LBB0_154:
	global_load_b32 v1, v0, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	global_load_b32 v2, v0, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s9, v1
	v_readfirstlane_b32 s10, v2
	s_cmp_eq_u32 s9, s4
	s_cselect_b32 s9, -1, 0
	s_cmp_eq_u32 s10, 0
	s_cselect_b32 s10, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s9, s9, s10
	s_cmp_lt_i32 s8, s38
	s_cselect_b32 s10, -1, 0
	s_add_co_i32 s8, s8, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s10, s9, s10
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s10
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_154
	s_branch .LBB0_156
.LBB0_155:
	s_mov_b32 s9, -1
.LBB0_156:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s8, s9, exec_lo
	s_cselect_b32 s8, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s8, 1
	s_cbranch_scc1 .LBB0_160
	v_dual_mov_b32 v0, 1 :: v_dual_mov_b32 v1, 0
	s_mov_b32 s8, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v0, v1, v[0:1], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_159
	v_dual_mov_b32 v3, ttmp9 :: v_dual_mov_b32 v2, 2
	v_mov_b32_e32 v4, s4
	global_store_b96 v1, v[2:4], s[22:23] offset:4
.LBB0_159:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s8
.LBB0_160:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s5, s5
	s_cbranch_execz .LBB0_162
	s_add_co_i32 s4, s4, 1
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v0, 0 :: v_dual_mov_b32 v1, s4
	global_store_b32 v0, v0, s[20:21] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v0, v1, s[20:21] offset:4 scope:SCOPE_DEV
.LBB0_162:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s5
	v_mov_b32_e32 v0, 0
	global_load_b32 v1, v0, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, 0, v1
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e64 v1, 0, 1, vcc_lo
	ds_store_b32 v0, v1 offset:20
.LBB0_163:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
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
	s_cbranch_vccnz .LBB0_283
	s_and_b32 s3, s7, exec_lo
	s_cselect_b32 s3, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s3, 1
	s_cbranch_scc1 .LBB0_173
	v_mov_b32_e32 v0, 0
	v_lshlrev_b32_e32 v2, 5, v30
	s_lshl_b32 s3, ttmp9, 6
	s_lshl_b32 s4, s26, 4
	s_lshl_b32 s5, s26, 9
	global_load_b64 v[0:1], v0, s[28:29] offset:8
	v_or_b32_e32 v3, v2, v29
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s4, s4, s3
	v_cmp_gt_i32_e32 vcc_lo, s36, v30
	s_wait_alu depctr_sa_sdst(0)
	v_add_nc_u32_e32 v2, s4, v2
	s_lshl_b32 s4, ttmp9, 11
	v_lshlrev_b32_e32 v4, 1, v3
	s_wait_alu depctr_sa_sdst(0)
	v_or3_b32 v20, s4, s5, v3
	v_or_b32_e32 v16, v2, v29
	s_delay_alu instid0(VALU_DEP_3)
	v_add_co_u32 v18, s3, s18, v4
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v19, null, s19, 0, s3
	s_wait_loadcnt 0x0
	v_add_co_u32 v23, s3, 0x200, v0
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v25, null, 0, v1, s3
	s_add_co_i32 s3, s26, s6
	s_wait_alu depctr_sa_sdst(0)
	s_add_co_i32 s4, s3, -16
	s_branch .LBB0_167
.LBB0_166:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s5
	v_add_nc_u32_e32 v16, 0x100, v16
	v_add_nc_u32_e32 v20, 0x2000, v20
	s_add_co_i32 s4, s4, 16
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s4, -14
	s_cbranch_scc0 .LBB0_173
.LBB0_167:
	v_dual_mov_b32 v8, 0 :: v_dual_mov_b32 v9, 0
	v_dual_mov_b32 v10, 0 :: v_dual_mov_b32 v11, 0
	s_and_saveexec_b32 s3, vcc_lo
	s_cbranch_execz .LBB0_169
	global_load_b128 v[8:11], v[18:19], off offset:1024
.LBB0_169:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
	v_ashrrev_i32_e32 v21, 31, v20
	v_dual_mov_b32 v12, 0 :: v_dual_mov_b32 v13, 0
	v_dual_mov_b32 v14, 0 :: v_dual_mov_b32 v15, 0
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshlrev_b64_e32 v[0:1], 1, v[20:21]
	v_add_co_u32 v21, s3, s12, v0
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_add_co_ci_u32_e64 v22, null, s13, v1, s3
	global_load_b128 v[26:29], v[21:22], off
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[26:29], v[8:11], 0
	s_and_saveexec_b32 s3, vcc_lo
	s_cbranch_execz .LBB0_171
	global_load_b128 v[12:15], v[18:19], off offset:1056
.LBB0_171:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
	global_load_b128 v[8:11], v[21:22], off offset:32
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[8:11], v[12:15], v[0:7]
	s_and_saveexec_b32 s5, vcc_lo
	s_cbranch_execz .LBB0_166
	s_delay_alu instid0(VALU_DEP_1)
	v_bfe_u32 v8, v0, 16, 1
	v_or_b32_e32 v9, 0x400000, v0
	v_ashrrev_i32_e32 v17, 31, v16
	v_cmp_u_f32_e64 s3, v0, v0
	v_bfe_u32 v10, v1, 16, 1
	v_add3_u32 v8, v8, v0, 0x7fff
	v_or_b32_e32 v11, 0x400000, v1
	v_bfe_u32 v12, v2, 16, 1
	v_or_b32_e32 v13, 0x400000, v2
	v_add3_u32 v10, v10, v1, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v0, v8, v9, s3
	v_lshlrev_b64_e32 v[8:9], 1, v[16:17]
	v_cmp_u_f32_e64 s3, v1, v1
	v_add3_u32 v12, v12, v2, 0x7fff
	v_or_b32_e32 v14, 0x400000, v5
	v_or_b32_e32 v17, 0x400000, v7
	v_bfe_u32 v15, v6, 16, 1
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v1, v10, v11, s3
	v_add_co_u32 v8, s3, v23, v8
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v9, null, v25, v9, s3
	v_cmp_u_f32_e64 s3, v2, v2
	v_bfe_u32 v10, v3, 16, 1
	v_lshrrev_b32_e32 v11, 16, v1
	v_lshrrev_b32_e32 v0, 16, v0
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v2, v12, v13, s3
	v_add3_u32 v10, v10, v3, 0x7fff
	v_or_b32_e32 v12, 0x400000, v3
	v_cmp_u_f32_e64 s3, v3, v3
	v_bfe_u32 v13, v4, 16, 1
	v_lshrrev_b32_e32 v1, 16, v2
	v_bfe_u32 v2, v5, 16, 1
	v_mov_b16_e32 v0.h, v11.l
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v3, v10, v12, s3
	v_bfe_u32 v12, v7, 16, 1
	v_cmp_u_f32_e64 s3, v5, v5
	v_add3_u32 v2, v2, v5, 0x7fff
	v_add3_u32 v10, v13, v4, 0x7fff
	v_or_b32_e32 v13, 0x400000, v4
	v_add3_u32 v12, v12, v7, 0x7fff
	v_add3_u32 v5, v15, v6, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v2, v2, v14, s3
	v_cmp_u_f32_e64 s3, v7, v7
	v_or_b32_e32 v14, 0x400000, v6
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_2) | instid1(VALU_DEP_1)
	v_cndmask_b32_e64 v7, v12, v17, s3
	v_cmp_u_f32_e64 s3, v4, v4
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v4, v10, v13, s3
	v_cmp_u_f32_e64 s3, v6, v6
	v_lshrrev_b32_e32 v6, 16, v7
	v_lshrrev_b32_e32 v7, 16, v2
	v_lshrrev_b32_e32 v10, 16, v3
	v_lshrrev_b32_e32 v2, 16, v4
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v5, v5, v14, s3
	v_mov_b16_e32 v2.h, v7.l
	v_mov_b16_e32 v1.h, v10.l
	s_delay_alu instid0(VALU_DEP_3)
	v_lshrrev_b32_e32 v3, 16, v5
	v_mov_b16_e32 v3.h, v6.l
	global_store_b128 v[8:9], v[0:3], off
	s_branch .LBB0_166
.LBB0_173:
	s_cmp_eq_u32 ttmp9, s42
	s_cbranch_scc1 .LBB0_283
	v_mov_b32_e32 v2, 0
	global_load_b64 v[0:1], v2, s[28:29] offset:8
	s_wait_loadcnt 0x0
	global_load_b32 v3, v[0:1], off offset:256 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	s_barrier_signal -1
	v_readfirstlane_b32 s3, v3
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s4, s2
	s_cbranch_execz .LBB0_189
	global_load_b32 v3, v2, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	s_mov_b32 s6, exec_lo
	s_mov_b32 s7, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	v_mbcnt_lo_u32_b32 v2, s6, 0
	v_readfirstlane_b32 s5, v3
	s_delay_alu instid0(VALU_DEP_2)
	v_cmpx_eq_u32_e32 0, v2
	s_cbranch_execz .LBB0_177
	s_bcnt1_i32_b32 s6, s6
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v3, 0 :: v_dual_mov_b32 v4, s6
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v3, v3, v4, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_177:
	s_or_b32 exec_lo, exec_lo, s7
	v_readfirstlane_b32 s6, v3
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v2, s6, v2
	s_mov_b32 s6, exec_lo
	v_cmpx_ne_u32_e32 3, v2
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s6, exec_lo, s6
	s_cbranch_execz .LBB0_186
	s_cmp_lt_i32 s38, 1
	s_mov_b32 s7, 1
	s_cbranch_scc1 .LBB0_181
	v_mov_b32_e32 v2, 0
.LBB0_180:
	global_load_b32 v3, v2, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	global_load_b32 v4, v2, s[22:23] scope:SCOPE_DEV
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
	s_cbranch_vccnz .LBB0_180
	s_branch .LBB0_182
.LBB0_181:
	s_mov_b32 s8, -1
.LBB0_182:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s7, s8, exec_lo
	s_cselect_b32 s7, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s7, 1
	s_cbranch_scc1 .LBB0_186
	v_dual_mov_b32 v2, 1 :: v_dual_mov_b32 v3, 0
	s_mov_b32 s7, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v2, v3, v[2:3], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v2
	s_cbranch_execz .LBB0_185
	v_dual_mov_b32 v5, ttmp9 :: v_dual_mov_b32 v4, 20
	v_mov_b32_e32 v6, s5
	global_store_b96 v3, v[4:6], s[22:23] offset:4
.LBB0_185:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s7
.LBB0_186:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s6, s6
	s_cbranch_execz .LBB0_188
	s_add_co_i32 s5, s5, 1
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v2, 0 :: v_dual_mov_b32 v3, s5
	global_store_b32 v2, v2, s[20:21] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v2, v3, s[20:21] offset:4 scope:SCOPE_DEV
.LBB0_188:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
	v_mov_b32_e32 v2, 0
	global_load_b32 v3, v2, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, 0, v3
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e64 v3, 0, 1, vcc_lo
	ds_store_b32 v2, v3 offset:20
.LBB0_189:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	s_wait_storecnt 0x0
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	v_mov_b32_e32 v2, 0
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	ds_load_b32 v2, v2 offset:20
	s_wait_dscnt 0x0
	v_cmp_eq_u32_e32 vcc_lo, 0, v2
	s_cbranch_vccnz .LBB0_283
	s_add_co_i32 s3, s3, 1
	s_and_saveexec_b32 s4, s0
	s_cbranch_execz .LBB0_209
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v2, s3
	s_cmp_gt_i32 s38, 0
	s_cselect_b32 s5, -1, 0
	s_cmp_lt_i32 s38, 1
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[0:1], v2, off scope:SCOPE_SYS
	s_cbranch_scc1 .LBB0_195
	v_mov_b32_e32 v4, 0
	s_mov_b32 s6, 1
	global_load_b64 v[2:3], v4, s[28:29]
.LBB0_193:
	s_wait_loadcnt 0x0
	global_load_b32 v5, v[2:3], off scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v6, v[2:3], off offset:384 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v7, v4, s[22:23] scope:SCOPE_DEV
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
	s_cbranch_vccnz .LBB0_193
	s_cmp_lg_u32 s7, 0
	s_cselect_b32 s6, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s6, s8, s6
	s_branch .LBB0_196
.LBB0_195:
	s_mov_b32 s6, -1
.LBB0_196:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s6, s6, exec_lo
	s_cselect_b32 s6, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s6, 1
	s_cbranch_scc1 .LBB0_200
	v_dual_mov_b32 v2, 1 :: v_dual_mov_b32 v3, 0
	s_mov_b32 s6, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v4, v3, v[2:3], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v4
	s_cbranch_execz .LBB0_199
	v_dual_mov_b32 v4, 30 :: v_dual_mov_b32 v5, v3
	v_mov_b32_e32 v6, s3
	global_store_b96 v3, v[4:6], s[22:23] offset:4
.LBB0_199:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[0:1], v2, off offset:384 scope:SCOPE_SYS
.LBB0_200:
	s_and_b32 s5, s5, exec_lo
	s_cselect_b32 s5, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s5, 1
	s_cbranch_scc1 .LBB0_204
	v_mov_b32_e32 v4, 0
	s_mov_b32 s5, 1
	global_load_b64 v[2:3], v4, s[28:29] offset:8
.LBB0_202:
	s_wait_loadcnt 0x0
	global_load_b32 v5, v[2:3], off scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v6, v[2:3], off offset:384 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v7, v4, s[22:23] scope:SCOPE_DEV
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
	s_cbranch_vccnz .LBB0_202
	s_cmp_lg_u32 s6, 0
	s_cselect_b32 s5, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s5, s7, s5
	s_branch .LBB0_205
.LBB0_204:
	s_mov_b32 s5, -1
.LBB0_205:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s5, s5, exec_lo
	s_cselect_b32 s5, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s5, 1
	s_cbranch_scc1 .LBB0_209
	v_dual_mov_b32 v2, 1 :: v_dual_mov_b32 v3, 0
	s_mov_b32 s5, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v4, v3, v[2:3], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v4
	s_cbranch_execz .LBB0_208
	v_dual_mov_b32 v4, 30 :: v_dual_mov_b32 v5, v3
	v_mov_b32_e32 v6, s3
	global_store_b96 v3, v[4:6], s[22:23] offset:4
.LBB0_208:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s5
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[0:1], v2, off offset:384 scope:SCOPE_SYS
.LBB0_209:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s4, s2
	s_cbranch_execz .LBB0_224
	v_mov_b32_e32 v3, 0
	s_mov_b32 s6, exec_lo
	s_mov_b32 s7, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	v_mbcnt_lo_u32_b32 v2, s6, 0
	global_load_b32 v4, v3, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s5, v4
	v_cmpx_eq_u32_e32 0, v2
	s_cbranch_execz .LBB0_212
	s_bcnt1_i32_b32 s6, s6
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v4, s6
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v4, v3, v4, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_212:
	s_or_b32 exec_lo, exec_lo, s7
	v_readfirstlane_b32 s6, v4
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v2, s6, v2
	s_mov_b32 s6, exec_lo
	v_cmpx_ne_u32_e32 3, v2
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s6, exec_lo, s6
	s_cbranch_execz .LBB0_221
	s_cmp_lt_i32 s38, 1
	s_mov_b32 s7, 1
	s_cbranch_scc1 .LBB0_216
	v_mov_b32_e32 v2, 0
.LBB0_215:
	global_load_b32 v3, v2, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	global_load_b32 v4, v2, s[22:23] scope:SCOPE_DEV
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
	s_cbranch_vccnz .LBB0_215
	s_branch .LBB0_217
.LBB0_216:
	s_mov_b32 s8, -1
.LBB0_217:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s7, s8, exec_lo
	s_cselect_b32 s7, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s7, 1
	s_cbranch_scc1 .LBB0_221
	v_dual_mov_b32 v2, 1 :: v_dual_mov_b32 v3, 0
	s_mov_b32 s7, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v2, v3, v[2:3], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v2
	s_cbranch_execz .LBB0_220
	v_dual_mov_b32 v5, ttmp9 :: v_dual_mov_b32 v4, 21
	v_mov_b32_e32 v6, s5
	global_store_b96 v3, v[4:6], s[22:23] offset:4
.LBB0_220:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s7
.LBB0_221:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s6, s6
	s_cbranch_execz .LBB0_223
	s_add_co_i32 s5, s5, 1
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v2, 0 :: v_dual_mov_b32 v3, s5
	global_store_b32 v2, v2, s[20:21] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v2, v3, s[20:21] offset:4 scope:SCOPE_DEV
.LBB0_223:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
	v_mov_b32_e32 v2, 0
	global_load_b32 v3, v2, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, 0, v3
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e64 v3, 0, 1, vcc_lo
	ds_store_b32 v2, v3 offset:20
.LBB0_224:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	s_wait_storecnt 0x0
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	v_mov_b32_e32 v2, 0
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	ds_load_b32 v2, v2 offset:20
	s_wait_dscnt 0x0
	v_cmp_eq_u32_e32 vcc_lo, 0, v2
	s_cbranch_vccnz .LBB0_283
	s_and_saveexec_b32 s4, s1
	s_cbranch_execz .LBB0_230
	v_mov_b32_e32 v4, 0
	s_cmp_lg_u32 s41, 0
	s_mov_b32 s5, 0
	s_cselect_b32 s6, -1, 0
	s_branch .LBB0_228
.LBB0_227:
	v_add_nc_u32_e32 v24, 0x200, v24
	v_add_co_u32 v2, s1, s14, v2
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v3, null, s15, v3, s1
	s_delay_alu instid0(VALU_DEP_3)
	v_cmp_le_i32_e32 vcc_lo, s33, v24
	global_store_b16 v[2:3], v5, off
	s_or_b32 s5, vcc_lo, s5
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_b32 exec_lo, exec_lo, s5
	s_cbranch_execz .LBB0_230
.LBB0_228:
	global_load_b128 v[5:8], v4, s[28:29]
	v_ashrrev_i32_e32 v25, 31, v24
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s1, s6, exec_lo
	s_cselect_b32 s1, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s1, 1
	v_lshlrev_b64_e32 v[2:3], 1, v[24:25]
	s_wait_loadcnt 0x0
	v_add_co_u32 v5, vcc_lo, 0x200, v5
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v6, null, 0, v6, vcc_lo
	v_add_co_u32 v7, vcc_lo, 0x200, v7
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v8, null, 0, v8, vcc_lo
	v_add_co_u32 v5, vcc_lo, v5, v2
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v6, null, v6, v3, vcc_lo
	v_add_co_u32 v7, vcc_lo, v7, v2
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v8, null, v8, v3, vcc_lo
	global_load_u16 v5, v[5:6], off
	global_load_u16 v6, v[7:8], off
	s_wait_loadcnt 0x1
	v_lshlrev_b32_e32 v5, 16, v5
	s_wait_loadcnt 0x0
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_dual_add_f32 v5, 0, v5 :: v_dual_lshlrev_b32 v6, 16, v6
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
	s_cbranch_scc1 .LBB0_227
	v_ashrrev_i32_e32 v6, 31, v24
	v_mov_b16_e32 v8.l, 0
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_lshlrev_b32_e32 v5, 16, v5
	v_lshrrev_b32_e32 v6, 27, v6
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v6, v24, v6
	v_and_b32_e32 v6, 0xffffffe0, v6
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_sub_nc_u32_e32 v6, v24, v6
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
	s_branch .LBB0_227
.LBB0_230:
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
	s_and_saveexec_b32 s1, s2
	s_cbranch_execz .LBB0_245
	v_mov_b32_e32 v3, 0
	s_mov_b32 s5, exec_lo
	s_mov_b32 s6, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	v_mbcnt_lo_u32_b32 v2, s5, 0
	global_load_b32 v4, v3, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s4, v4
	v_cmpx_eq_u32_e32 0, v2
	s_cbranch_execz .LBB0_233
	s_bcnt1_i32_b32 s5, s5
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v4, s5
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v4, v3, v4, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_233:
	s_or_b32 exec_lo, exec_lo, s6
	v_readfirstlane_b32 s5, v4
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v2, s5, v2
	s_mov_b32 s5, exec_lo
	v_cmpx_ne_u32_e32 3, v2
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s5, exec_lo, s5
	s_cbranch_execz .LBB0_242
	s_cmp_lt_i32 s38, 1
	s_mov_b32 s6, 1
	s_cbranch_scc1 .LBB0_237
	v_mov_b32_e32 v2, 0
.LBB0_236:
	global_load_b32 v3, v2, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	global_load_b32 v4, v2, s[22:23] scope:SCOPE_DEV
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
	s_cbranch_vccnz .LBB0_236
	s_branch .LBB0_238
.LBB0_237:
	s_mov_b32 s7, -1
.LBB0_238:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s6, s7, exec_lo
	s_cselect_b32 s6, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s6, 1
	s_cbranch_scc1 .LBB0_242
	v_dual_mov_b32 v2, 1 :: v_dual_mov_b32 v3, 0
	s_mov_b32 s6, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v2, v3, v[2:3], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v2
	s_cbranch_execz .LBB0_241
	v_dual_mov_b32 v5, ttmp9 :: v_dual_mov_b32 v4, 22
	v_mov_b32_e32 v6, s4
	global_store_b96 v3, v[4:6], s[22:23] offset:4
.LBB0_241:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
.LBB0_242:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s5, s5
	s_cbranch_execz .LBB0_244
	s_add_co_i32 s4, s4, 1
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v2, 0 :: v_dual_mov_b32 v3, s4
	global_store_b32 v2, v2, s[20:21] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v2, v3, s[20:21] offset:4 scope:SCOPE_DEV
.LBB0_244:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s5
	v_mov_b32_e32 v2, 0
	global_load_b32 v3, v2, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, 0, v3
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e64 v3, 0, 1, vcc_lo
	ds_store_b32 v2, v3 offset:20
.LBB0_245:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s1
	s_wait_storecnt 0x0
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	v_mov_b32_e32 v2, 0
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	ds_load_b32 v2, v2 offset:20
	s_wait_dscnt 0x0
	v_cmp_eq_u32_e32 vcc_lo, 0, v2
	s_cbranch_vccnz .LBB0_283
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_267
	v_mov_b32_e32 v2, s3
	s_cmp_gt_i32 s38, 0
	s_mov_b32 s4, 1
	s_cselect_b32 s0, -1, 0
	s_cmp_lt_i32 s38, 1
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[0:1], v2, off offset:128 scope:SCOPE_SYS
	s_cbranch_scc1 .LBB0_251
	v_mov_b32_e32 v4, 0
	global_load_b64 v[2:3], v4, s[28:29]
.LBB0_249:
	s_wait_loadcnt 0x0
	global_load_b32 v5, v[2:3], off offset:128 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v6, v[2:3], off offset:384 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v7, v4, s[22:23] scope:SCOPE_DEV
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
	s_cbranch_vccnz .LBB0_249
	s_cmp_lg_u32 s5, 0
	s_cselect_b32 s4, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s4, s6, s4
	s_branch .LBB0_252
.LBB0_251:
	s_mov_b32 s4, -1
.LBB0_252:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s4, s4, exec_lo
	s_cselect_b32 s4, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s4, 1
	s_cbranch_scc1 .LBB0_256
	v_dual_mov_b32 v2, 1 :: v_dual_mov_b32 v3, 0
	s_mov_b32 s4, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v4, v3, v[2:3], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v4
	s_cbranch_execz .LBB0_255
	v_dual_mov_b32 v4, 31 :: v_dual_mov_b32 v5, v3
	v_mov_b32_e32 v6, s3
	global_store_b96 v3, v[4:6], s[22:23] offset:4
.LBB0_255:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[0:1], v2, off offset:384 scope:SCOPE_SYS
.LBB0_256:
	s_and_b32 s0, s0, exec_lo
	s_cselect_b32 s0, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s0, 1
	s_cbranch_scc1 .LBB0_260
	v_mov_b32_e32 v4, 0
	s_mov_b32 s0, 1
	global_load_b64 v[2:3], v4, s[28:29] offset:8
.LBB0_258:
	s_wait_loadcnt 0x0
	global_load_b32 v5, v[2:3], off offset:128 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v6, v[2:3], off offset:384 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v7, v4, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s6, v5
	v_readfirstlane_b32 s5, v6
	v_readfirstlane_b32 s4, v7
	s_or_b32 s4, s4, s5
	s_cmp_lg_u32 s6, s3
	s_cselect_b32 s5, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s0, s38
	s_cselect_b32 s6, -1, 0
	s_cmp_eq_u32 s4, 0
	s_cselect_b32 s7, -1, 0
	s_add_co_i32 s0, s0, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s6, s7, s6
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s6, s5, s6
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s6
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_258
	s_cmp_lg_u32 s4, 0
	s_cselect_b32 s0, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s0, s5, s0
	s_branch .LBB0_261
.LBB0_260:
	s_mov_b32 s0, -1
.LBB0_261:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s0, s0, exec_lo
	s_cselect_b32 s0, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s0, 1
	s_cbranch_scc1 .LBB0_265
	v_dual_mov_b32 v2, 1 :: v_dual_mov_b32 v3, 0
	s_mov_b32 s0, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v4, v3, v[2:3], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v4
	s_cbranch_execz .LBB0_264
	v_dual_mov_b32 v4, 31 :: v_dual_mov_b32 v5, v3
	v_mov_b32_e32 v6, s3
	global_store_b96 v3, v[4:6], s[22:23] offset:4
.LBB0_264:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s0
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[0:1], v2, off offset:384 scope:SCOPE_SYS
.LBB0_265:
	v_mov_b32_e32 v2, 0
	global_load_b32 v2, v2, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_ne_u32_e32 vcc_lo, 0, v2
	s_cbranch_vccnz .LBB0_267
	v_mov_b32_e32 v2, s3
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[0:1], v2, off offset:256 scope:SCOPE_SYS
.LBB0_267:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s1
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s0, s2
	s_cbranch_execz .LBB0_282
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
	s_cbranch_execz .LBB0_270
	s_bcnt1_i32_b32 s3, s3
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v2, s3
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v2, v1, v2, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_270:
	s_or_b32 exec_lo, exec_lo, s4
	v_readfirstlane_b32 s3, v2
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v0, s3, v0
	s_mov_b32 s3, exec_lo
	v_cmpx_ne_u32_e32 3, v0
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s3, exec_lo, s3
	s_cbranch_execz .LBB0_279
	s_cmp_lt_i32 s38, 1
	s_mov_b32 s4, 1
	s_cbranch_scc1 .LBB0_274
	v_mov_b32_e32 v0, 0
.LBB0_273:
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
	s_cbranch_vccnz .LBB0_273
	s_branch .LBB0_275
.LBB0_274:
	s_mov_b32 s5, -1
.LBB0_275:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s4, s5, exec_lo
	s_cselect_b32 s4, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s4, 1
	s_cbranch_scc1 .LBB0_279
	v_dual_mov_b32 v0, 1 :: v_dual_mov_b32 v1, 0
	s_mov_b32 s4, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v0, v1, v[0:1], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_278
	v_dual_mov_b32 v3, ttmp9 :: v_dual_mov_b32 v2, 23
	v_mov_b32_e32 v4, s1
	global_store_b96 v1, v[2:4], s[22:23] offset:4
.LBB0_278:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
.LBB0_279:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s3, s3
	s_cbranch_execz .LBB0_281
	s_add_co_i32 s1, s1, 1
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v0, 0 :: v_dual_mov_b32 v1, s1
	global_store_b32 v0, v0, s[20:21] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v0, v1, s[20:21] offset:4 scope:SCOPE_DEV
.LBB0_281:
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
.LBB0_282:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s0
	s_wait_storecnt 0x0
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_283:
	s_and_saveexec_b32 s0, s2
	s_cbranch_execz .LBB0_288
	v_mov_b32_e32 v0, 0
	s_wait_kmcnt 0x0
	global_load_b32 v1, v0, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, 0, v1
	s_cbranch_vccnz .LBB0_286
	global_load_b64 v[1:2], v0, s[24:25] offset:8
	v_mov_b32_e32 v3, 1
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[1:2], v3, off offset:384 scope:SCOPE_SYS
.LBB0_286:
	global_load_b32 v0, v0, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, 0, v0
	s_cbranch_vccnz .LBB0_288
	v_mov_b32_e32 v0, 0
	v_mov_b32_e32 v2, 1
	global_load_b64 v[0:1], v0, s[28:29] offset:8
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[0:1], v2, off offset:384 scope:SCOPE_SYS
.LBB0_288:
	s_endpgm
.Lfunc_end0:
	.size	qwen_bf16_ffnar_v1_h32_i32_b4_tp2r1_a1_f1, .Lfunc_end0-qwen_bf16_ffnar_v1_h32_i32_b4_tp2r1_a1_f1
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel qwen_bf16_ffnar_v1_h32_i32_b4_tp2r1_a1_f1
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
		.amdhsa_next_free_vgpr 42
		.amdhsa_next_free_sgpr 45
		.amdhsa_reserve_vcc 1
		.amdhsa_float_round_mode_32 0
		.amdhsa_float_round_mode_16_64 0
		.amdhsa_float_denorm_mode_32 3
		.amdhsa_float_denorm_mode_16_64 3
		.amdhsa_fp16_overflow 0
		.amdhsa_workgroup_processor_mode 1
		.amdhsa_memory_ordered 1
		.amdhsa_forward_progress 1
		.amdhsa_inst_pref_size ((instprefsize(.Lfunc_end0-qwen_bf16_ffnar_v1_h32_i32_b4_tp2r1_a1_f1)<<4)&4080)>>4
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

	.set .Lqwen_bf16_ffnar_v1_h32_i32_b4_tp2r1_a1_f1.num_vgpr, 42
	.set .Lqwen_bf16_ffnar_v1_h32_i32_b4_tp2r1_a1_f1.num_agpr, 0
	.set .Lqwen_bf16_ffnar_v1_h32_i32_b4_tp2r1_a1_f1.numbered_sgpr, 45
	.set .Lqwen_bf16_ffnar_v1_h32_i32_b4_tp2r1_a1_f1.num_named_barrier, 0
	.set .Lqwen_bf16_ffnar_v1_h32_i32_b4_tp2r1_a1_f1.private_seg_size, 0
	.set .Lqwen_bf16_ffnar_v1_h32_i32_b4_tp2r1_a1_f1.uses_vcc, 1
	.set .Lqwen_bf16_ffnar_v1_h32_i32_b4_tp2r1_a1_f1.uses_flat_scratch, 0
	.set .Lqwen_bf16_ffnar_v1_h32_i32_b4_tp2r1_a1_f1.has_dyn_sized_stack, 0
	.set .Lqwen_bf16_ffnar_v1_h32_i32_b4_tp2r1_a1_f1.has_recursion, 0
	.set .Lqwen_bf16_ffnar_v1_h32_i32_b4_tp2r1_a1_f1.has_indirect_call, 0
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
    .name:           qwen_bf16_ffnar_v1_h32_i32_b4_tp2r1_a1_f1
    .private_segment_fixed_size: 0
    .reqd_workgroup_size:
      - 128
      - 1
      - 1
    .sgpr_count:     47
    .sgpr_spill_count: 0
    .symbol:         qwen_bf16_ffnar_v1_h32_i32_b4_tp2r1_a1_f1.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     42
    .vgpr_spill_count: 0
    .wavefront_size: 32
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1201
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
