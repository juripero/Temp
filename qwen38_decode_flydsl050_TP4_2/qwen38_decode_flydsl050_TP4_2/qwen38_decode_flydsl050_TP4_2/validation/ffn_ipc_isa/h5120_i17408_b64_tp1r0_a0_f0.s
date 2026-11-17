	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1201"
	.amdhsa_code_object_version 6
	.text
	.globl	qwen_bf16_ffnar_v1_h5120_i17408_b64_tp1r0_a0_f0
	.p2align	8
	.type	qwen_bf16_ffnar_v1_h5120_i17408_b64_tp1r0_a0_f0,@function
qwen_bf16_ffnar_v1_h5120_i17408_b64_tp1r0_a0_f0:
	s_load_b128 s[24:27], s[0:1], 0x70
	s_wait_kmcnt 0x0
	s_cmp_lt_i32 s24, 1
	s_cbranch_scc1 .LBB0_118
	s_clause 0x1
	s_load_b64 s[6:7], s[0:1], 0x80
	s_load_b128 s[28:31], s[0:1], 0x40
	v_cmp_eq_u32_e64 s2, 0, v0
	s_and_saveexec_b32 s3, s2
	s_cbranch_execz .LBB0_3
	v_mov_b32_e32 v1, 0
	s_cmp_lg_u32 ttmp9, s27
	s_cselect_b32 s4, -1, 0
	s_wait_kmcnt 0x0
	global_load_b32 v2, v1, s[30:31] scope:SCOPE_DEV
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
	ds_load_b32 v1, v1 offset:20
	s_wait_dscnt 0x0
	v_cmp_eq_u32_e32 vcc_lo, 0, v1
	s_cbranch_vccnz .LBB0_118
	s_load_b512 s[8:23], s[0:1], 0x0
	v_lshrrev_b32_e32 v1, 5, v0
	s_cmp_ge_i32 ttmp9, s24
	s_delay_alu instid0(VALU_DEP_1)
	v_readfirstlane_b32 s5, v1
	s_cbranch_scc1 .LBB0_31
	v_dual_mov_b32 v2, 0 :: v_dual_and_b32 v1, 31, v0
	s_load_b64 s[34:35], s[0:1], 0x58
	v_or_b32_e32 v18, 0xfffffe00, v0
	s_wait_kmcnt 0x0
	s_cmp_lg_u32 s6, 0
	v_lshlrev_b32_e32 v3, 2, v1
	v_cmp_gt_u32_e32 vcc_lo, 24, v1
	v_cmp_eq_u32_e64 s3, 0, v1
	s_mov_b32 s27, ttmp9
	s_cselect_b32 s6, -1, 0
	v_add_nc_u32_e32 v5, 32, v3
	v_add_nc_u32_e32 v7, 8, v3
	v_add_nc_u32_e32 v8, 4, v3
	v_add_nc_u32_e32 v6, 16, v3
	s_lshl_b32 s33, s5, 2
	v_cndmask_b32_e32 v14, v3, v5, vcc_lo
	v_cmp_gt_u32_e32 vcc_lo, 28, v1
	v_lshlrev_b32_e32 v4, 1, v0
	s_mul_i32 s36, ttmp9, 0x1400
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v15, v3, v6, vcc_lo
	v_cmp_gt_u32_e32 vcc_lo, 30, v1
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v16, v3, v7, vcc_lo
	v_add_co_u32 v3, s4, s34, v4
	v_cmp_ne_u32_e32 vcc_lo, 31, v1
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v4, null, s35, 0, s4
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v17, 0x7c, v8, vcc_lo
	v_add_co_u32 v3, vcc_lo, 0x200, v3
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v4, null, 0, v4, vcc_lo
	s_branch .LBB0_7
.LBB0_6:
	s_or_b32 exec_lo, exec_lo, s37
	s_wait_storecnt 0x0
	s_barrier_signal -1
	s_add_co_i32 s27, s27, 64
	s_add_co_i32 s36, s36, 0x50000
	s_cmp_lt_i32 s27, s24
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_cbranch_scc0 .LBB0_31
.LBB0_7:
	s_delay_alu instid0(VALU_DEP_1)
	v_dual_mov_b32 v1, v18 :: v_dual_mov_b32 v6, v4
	v_mov_b32_e32 v5, v3
	v_mov_b32_e32 v11, v2
	s_mov_b32 s37, 0
	s_branch .LBB0_9
.LBB0_8:
	v_add_co_u32 v20, vcc_lo, s10, v7
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v21, null, s11, v8, vcc_lo
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v9, 16, v9
	v_mul_f32_e32 v19, v19, v19
	v_add_nc_u32_e32 v1, 0x200, v1
	global_load_u16 v10, v[20:21], off
	v_mul_f32_e32 v13, v13, v13
	v_add_co_u32 v7, vcc_lo, s20, v7
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v8, null, s21, v8, vcc_lo
	v_cmp_lt_u32_e32 vcc_lo, 0x11ff, v1
	s_or_b32 s37, vcc_lo, s37
	s_wait_loadcnt 0x0
	v_dual_add_f32 v11, v11, v13 :: v_dual_lshlrev_b32 v10, 16, v10
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_add_f32_e32 v11, v11, v19
	v_dual_add_f32 v9, v9, v10 :: v_dual_mul_f32 v10, v12, v12
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_add_f32_e32 v10, v11, v10
	v_bfe_u32 v12, v9, 16, 1
	v_or_b32_e32 v13, 0x400000, v9
	v_cmp_u_f32_e64 s4, v9, v9
	v_mul_f32_e32 v11, v9, v9
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_add3_u32 v12, v12, v9, 0x7fff
	v_add_f32_e32 v11, v10, v11
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_cndmask_b32_e64 v9, v12, v13, s4
	v_add_co_u32 v5, s4, 0x400, v5
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v6, null, 0, v6, s4
	global_store_d16_hi_b16 v[7:8], v9, off
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_b32 exec_lo, exec_lo, s37
	s_cbranch_execz .LBB0_17
.LBB0_9:
	s_wait_alu depctr_sa_sdst(0)
	v_add_nc_u32_e32 v12, s36, v1
	s_and_b32 s4, s6, exec_lo
	s_cselect_b32 s4, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s4, 1
	v_add_nc_u32_e32 v7, 0x200, v12
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v8, 31, v7
	v_lshlrev_b64_e32 v[9:10], 1, v[7:8]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v7, vcc_lo, s8, v9
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v8, null, s9, v10, vcc_lo
	global_load_d16_b16 v7, v[7:8], off
	s_cbranch_scc1 .LBB0_11
	v_mov_b16_e32 v8.l, 0
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v7, 16, v7
	global_load_d16_hi_b16 v8, v[5:6], off offset:-512
	s_wait_loadcnt 0x0
	v_add_f32_e32 v8, 1.0, v8
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v13, v8, 16, 1
	v_or_b32_e32 v19, 0x400000, v8
	v_cmp_u_f32_e32 vcc_lo, v8, v8
	v_add3_u32 v13, v13, v8, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_cndmask_b32_e32 v8, v13, v19, vcc_lo
	v_and_b32_e32 v8, 0xffff0000, v8
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v7, v7, v8
	v_bfe_u32 v8, v7, 16, 1
	v_or_b32_e32 v13, 0x400000, v7
	v_cmp_u_f32_e32 vcc_lo, v7, v7
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v8, v8, v7, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v7, v8, v13, vcc_lo
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v7, 16, v7
.LBB0_11:
	v_add_co_u32 v19, vcc_lo, s10, v9
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v20, null, s11, v10, vcc_lo
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v13, 16, v7
	v_add_nc_u32_e32 v7, 0x280, v12
	v_add_co_u32 v9, vcc_lo, s20, v9
	global_load_u16 v8, v[19:20], off
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v10, null, s21, v10, vcc_lo
	s_and_b32 s4, s6, exec_lo
	s_cselect_b32 s4, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s4, 1
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v8, 16, v8
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_f32_e32 v13, v13, v8
	v_ashrrev_i32_e32 v8, 31, v7
	v_bfe_u32 v19, v13, 16, 1
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_2) | instid1(VALU_DEP_4)
	v_lshlrev_b64_e32 v[7:8], 1, v[7:8]
	v_or_b32_e32 v20, 0x400000, v13
	v_cmp_u_f32_e32 vcc_lo, v13, v13
	v_add3_u32 v19, v19, v13, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_1)
	v_cndmask_b32_e32 v21, v19, v20, vcc_lo
	v_add_co_u32 v19, vcc_lo, s8, v7
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v20, null, s9, v8, vcc_lo
	global_store_d16_hi_b16 v[9:10], v21, off
	global_load_d16_b16 v9, v[19:20], off
	s_cbranch_scc1 .LBB0_13
	v_mov_b16_e32 v10.l, 0
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v9, 16, v9
	global_load_d16_hi_b16 v10, v[5:6], off offset:-256
	s_wait_loadcnt 0x0
	v_add_f32_e32 v10, 1.0, v10
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v19, v10, 16, 1
	v_or_b32_e32 v20, 0x400000, v10
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	v_add3_u32 v19, v19, v10, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_cndmask_b32_e32 v10, v19, v20, vcc_lo
	v_and_b32_e32 v10, 0xffff0000, v10
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v9, v9, v10
	v_bfe_u32 v10, v9, 16, 1
	v_or_b32_e32 v19, 0x400000, v9
	v_cmp_u_f32_e32 vcc_lo, v9, v9
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v10, v10, v9, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v9, v10, v19, vcc_lo
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v9, 16, v9
.LBB0_13:
	v_add_co_u32 v19, vcc_lo, s10, v7
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v20, null, s11, v8, vcc_lo
	v_add_co_u32 v7, vcc_lo, s20, v7
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v8, null, s21, v8, vcc_lo
	global_load_u16 v10, v[19:20], off
	s_wait_loadcnt 0x1
	v_lshlrev_b32_e32 v19, 16, v9
	s_and_b32 s4, s6, exec_lo
	s_cselect_b32 s4, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s4, 1
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v10, 16, v10
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v19, v19, v10
	v_bfe_u32 v20, v19, 16, 1
	v_or_b32_e32 v21, 0x400000, v19
	v_cmp_u_f32_e32 vcc_lo, v19, v19
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v20, v20, v19, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_dual_cndmask_b32 v22, v20, v21 :: v_dual_add_nc_u32 v9, 0x300, v12
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v10, 31, v9
	global_store_d16_hi_b16 v[7:8], v22, off
	v_lshlrev_b64_e32 v[9:10], 1, v[9:10]
	v_add_co_u32 v20, vcc_lo, s8, v9
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_add_co_ci_u32_e64 v21, null, s9, v10, vcc_lo
	global_load_d16_b16 v7, v[20:21], off
	s_cbranch_scc1 .LBB0_15
	v_mov_b16_e32 v8.l, 0
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v7, 16, v7
	global_load_d16_hi_b16 v8, v[5:6], off
	s_wait_loadcnt 0x0
	v_add_f32_e32 v8, 1.0, v8
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v20, v8, 16, 1
	v_or_b32_e32 v21, 0x400000, v8
	v_cmp_u_f32_e32 vcc_lo, v8, v8
	v_add3_u32 v20, v20, v8, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_cndmask_b32_e32 v8, v20, v21, vcc_lo
	v_and_b32_e32 v8, 0xffff0000, v8
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v7, v7, v8
	v_bfe_u32 v8, v7, 16, 1
	v_or_b32_e32 v20, 0x400000, v7
	v_cmp_u_f32_e32 vcc_lo, v7, v7
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v8, v8, v7, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v7, v8, v20, vcc_lo
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v7, 16, v7
.LBB0_15:
	v_add_co_u32 v20, vcc_lo, s10, v9
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v21, null, s11, v10, vcc_lo
	v_add_co_u32 v9, vcc_lo, s20, v9
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v10, null, s21, v10, vcc_lo
	global_load_u16 v8, v[20:21], off
	s_wait_loadcnt 0x1
	v_lshlrev_b32_e32 v20, 16, v7
	v_add_nc_u32_e32 v7, 0x380, v12
	s_and_b32 s4, s6, exec_lo
	s_cselect_b32 s4, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s4, 1
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v8, 16, v8
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v12, v20, v8
	v_bfe_u32 v20, v12, 16, 1
	v_or_b32_e32 v21, 0x400000, v12
	v_cmp_u_f32_e32 vcc_lo, v12, v12
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v20, v20, v12, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v22, v20, v21, vcc_lo
	v_ashrrev_i32_e32 v8, 31, v7
	global_store_d16_hi_b16 v[9:10], v22, off
	v_lshlrev_b64_e32 v[7:8], 1, v[7:8]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v20, vcc_lo, s8, v7
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v21, null, s9, v8, vcc_lo
	global_load_d16_b16 v9, v[20:21], off
	s_cbranch_scc1 .LBB0_8
	v_mov_b16_e32 v10.l, 0
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v9, 16, v9
	global_load_d16_hi_b16 v10, v[5:6], off offset:256
	s_wait_loadcnt 0x0
	v_add_f32_e32 v10, 1.0, v10
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v20, v10, 16, 1
	v_or_b32_e32 v21, 0x400000, v10
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	v_add3_u32 v20, v20, v10, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_cndmask_b32_e32 v10, v20, v21, vcc_lo
	v_and_b32_e32 v10, 0xffff0000, v10
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v9, v9, v10
	v_bfe_u32 v10, v9, 16, 1
	v_or_b32_e32 v20, 0x400000, v9
	v_cmp_u_f32_e32 vcc_lo, v9, v9
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v10, v10, v9, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v9, v10, v20, vcc_lo
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v9, 16, v9
	s_branch .LBB0_8
.LBB0_17:
	s_or_b32 exec_lo, exec_lo, s37
	ds_swizzle_b32 v1, v11 offset:swizzle(BITMASK_PERM,"1pppp")
	s_wait_dscnt 0x0
	v_add_f32_e32 v1, v11, v1
	ds_bpermute_b32 v5, v14, v1
	s_wait_dscnt 0x0
	v_add_f32_e32 v1, v1, v5
	ds_bpermute_b32 v5, v15, v1
	s_wait_dscnt 0x0
	v_add_f32_e32 v1, v1, v5
	ds_bpermute_b32 v5, v16, v1
	s_wait_dscnt 0x0
	v_add_f32_e32 v1, v1, v5
	ds_bpermute_b32 v5, v17, v1
	s_and_saveexec_b32 s4, s3
	s_cbranch_execz .LBB0_19
	s_wait_dscnt 0x0
	v_add_f32_e32 v1, v1, v5
	v_mov_b32_e32 v5, s33
	ds_store_b32 v5, v1
.LBB0_19:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	s_wait_storecnt_dscnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s4, s2
	s_cbranch_execz .LBB0_21
	ds_load_b128 v[5:8], v2
	s_wait_dscnt 0x0
	v_add_f32_e32 v1, 0, v5
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v1, v1, v6
	v_add_f32_e32 v1, v1, v7
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v1, v1, v8
	v_div_scale_f32 v5, null, 0x45a00000, 0x45a00000, v1
	v_div_scale_f32 v8, vcc_lo, v1, 0x45a00000, v1
	s_delay_alu instid0(VALU_DEP_2)
	v_rcp_f32_e32 v6, v5
	v_xor_b32_e32 v5, 0x80000000, v5
	s_delay_alu instid0(TRANS32_DEP_1) | instid1(VALU_DEP_1)
	v_fma_f32 v7, v5, v6, 1.0
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fmac_f32_e32 v6, v7, v6
	v_mul_f32_e32 v7, v8, v6
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fma_f32 v9, v5, v7, v8
	v_fmac_f32_e32 v7, v9, v6
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_fmac_f32_e32 v8, v5, v7
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v5, v8, v6, v7
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_div_fixup_f32 v1, v5, 0x45a00000, v1
	v_readfirstlane_b32 s37, v1
	s_add_f32 s37, s25, s37
	s_wait_alu depctr_sa_sdst(0)
	s_delay_alu instid0(SALU_CYCLE_2) | instskip(SKIP_2) | instid1(SALU_CYCLE_1)
	s_mul_f32 s38, s37, 0x4f800000
	s_cmp_lt_f32 s37, 0xf800000
	s_wait_alu depctr_sa_sdst(0)
	s_cselect_b32 s38, s38, s37
	s_wait_alu depctr_sa_sdst(0)
	v_s_sqrt_f32 s39, s38
	s_mov_b32 s41, s38
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_add_co_i32 s40, s39, -1
	s_xor_b32 s42, s40, 0x80000000
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_2)
	s_fmac_f32 s41, s42, s39
	s_mov_b32 s42, s38
	s_cmp_le_f32 s41, 0
	s_cselect_b32 s40, s40, s39
	s_add_co_i32 s41, s39, 1
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_xor_b32 s43, s41, 0x80000000
	s_fmac_f32 s42, s43, s39
	v_cmp_class_f32_e64 s39, s38, 0x260
	s_delay_alu instid0(SALU_CYCLE_2) | instskip(SKIP_4) | instid1(SALU_CYCLE_2)
	s_cmp_gt_f32 s42, 0
	s_cselect_b32 s40, s41, s40
	s_cmp_lt_f32 s37, 0xf800000
	s_mul_f32 s37, s40, 0x37800000
	s_wait_alu depctr_sa_sdst(0)
	s_cselect_b32 s37, s37, s40
	s_and_b32 s39, s39, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	s_cselect_b32 s37, s38, s37
	s_wait_alu depctr_sa_sdst(0)
	v_div_scale_f32 v1, null, s37, s37, 1.0
	s_delay_alu instid0(VALU_DEP_1)
	v_rcp_f32_e32 v5, v1
	v_xor_b32_e32 v1, 0x80000000, v1
	s_delay_alu instid0(TRANS32_DEP_1) | instid1(VALU_DEP_1)
	v_fma_f32 v6, v1, v5, 1.0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_fmac_f32_e32 v5, v6, v5
	v_div_scale_f32 v6, vcc_lo, 1.0, s37, 1.0
	v_mul_f32_e32 v7, v6, v5
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fma_f32 v8, v1, v7, v6
	v_fmac_f32_e32 v7, v8, v5
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_fmac_f32_e32 v6, v1, v7
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v1, v6, v5, v7
	s_delay_alu instid0(VALU_DEP_1)
	v_div_fixup_f32 v1, v1, s37, 1.0
	ds_store_b32 v2, v1 offset:16
.LBB0_21:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	v_mov_b32_e32 v1, v0
	s_mul_i32 s38, s27, 0x1400
	s_mov_b32 s37, 0
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	ds_load_b32 v19, v2 offset:16
	s_wait_dscnt 0x0
	s_branch .LBB0_23
.LBB0_22:
	v_add_co_u32 v5, vcc_lo, s10, v12
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v6, null, s11, v13, vcc_lo
	global_load_u16 v5, v[5:6], off
	global_load_u16 v6, v[7:8], off offset:768
	s_wait_loadcnt 0x2
	v_mov_b16_e32 v7.l, v9.l
	v_add_nc_u32_e32 v8, 0x200, v1
	s_wait_loadcnt 0x1
	v_lshlrev_b32_e32 v5, 16, v5
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v6, 16, v6
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_dual_add_f32 v6, 1.0, v6 :: v_dual_lshlrev_b32 v7, 16, v7
	v_add_f32_e32 v5, v7, v5
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v5, v19, v5
	v_mul_f32_e32 v7, v5, v6
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v5, v7, 16, 1
	v_or_b32_e32 v9, 0x400000, v7
	v_cmp_u_f32_e64 s4, v7, v7
	v_add3_u32 v10, v5, v7, 0x7fff
	v_add_co_u32 v5, vcc_lo, s22, v12
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v6, null, s23, v13, vcc_lo
	v_cmp_lt_u32_e32 vcc_lo, 0x11ff, v1
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v7, v10, v9, s4
	v_mov_b32_e32 v1, v8
	s_or_b32 s37, vcc_lo, s37
	global_store_d16_hi_b16 v[5:6], v7, off
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_b32 exec_lo, exec_lo, s37
	s_cbranch_execz .LBB0_6
.LBB0_23:
	s_wait_alu depctr_sa_sdst(0)
	v_add_nc_u32_e32 v9, s38, v1
	s_and_b32 s4, s6, exec_lo
	s_cselect_b32 s4, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s4, 1
	v_ashrrev_i32_e32 v10, 31, v9
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshlrev_b64_e32 v[10:11], 1, v[9:10]
	v_add_co_u32 v5, vcc_lo, s8, v10
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_add_co_ci_u32_e64 v6, null, s9, v11, vcc_lo
	global_load_d16_b16 v12, v[5:6], off
	v_lshlrev_b64_e32 v[5:6], 1, v[1:2]
	s_cbranch_scc1 .LBB0_25
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v7, vcc_lo, s34, v5
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v8, null, s35, v6, vcc_lo
	v_mov_b16_e32 v13.l, 0
	global_load_d16_hi_b16 v13, v[7:8], off
	s_wait_loadcnt 0x0
	v_add_f32_e32 v7, 1.0, v13
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v8, v7, 16, 1
	v_or_b32_e32 v13, 0x400000, v7
	v_cmp_u_f32_e32 vcc_lo, v7, v7
	v_add3_u32 v8, v8, v7, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_dual_cndmask_b32 v7, v8, v13 :: v_dual_lshlrev_b32 v8, 16, v12
	v_and_b32_e32 v7, 0xffff0000, v7
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v7, v8, v7
	v_bfe_u32 v8, v7, 16, 1
	v_or_b32_e32 v12, 0x400000, v7
	v_cmp_u_f32_e32 vcc_lo, v7, v7
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v8, v8, v7, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v7, v8, v12, vcc_lo
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v12, 16, v7
.LBB0_25:
	v_add_co_u32 v20, vcc_lo, s10, v10
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v21, null, s11, v11, vcc_lo
	s_delay_alu instid0(VALU_DEP_3)
	v_add_co_u32 v7, vcc_lo, s12, v5
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v8, null, s13, v6, vcc_lo
	global_load_u16 v13, v[20:21], off
	global_load_u16 v20, v[7:8], off
	s_wait_loadcnt 0x2
	v_lshlrev_b32_e32 v12, 16, v12
	v_add_co_u32 v10, vcc_lo, s22, v10
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v11, null, s23, v11, vcc_lo
	s_and_b32 s4, s6, exec_lo
	s_cselect_b32 s4, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s4, 1
	s_wait_loadcnt 0x1
	v_lshlrev_b32_e32 v13, 16, v13
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v20, 16, v20
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_dual_add_f32 v12, v12, v13 :: v_dual_add_f32 v13, 1.0, v20
	v_mul_f32_e32 v20, v19, v12
	v_add_nc_u32_e32 v12, 0x80, v9
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_mul_f32_e32 v20, v20, v13
	v_ashrrev_i32_e32 v13, 31, v12
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_bfe_u32 v21, v20, 16, 1
	v_lshlrev_b64_e32 v[12:13], 1, v[12:13]
	v_or_b32_e32 v22, 0x400000, v20
	v_cmp_u_f32_e32 vcc_lo, v20, v20
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v21, v21, v20, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v22, v21, v22, vcc_lo
	v_add_co_u32 v20, vcc_lo, s8, v12
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v21, null, s9, v13, vcc_lo
	global_store_d16_hi_b16 v[10:11], v22, off
	global_load_d16_b16 v10, v[20:21], off
	s_cbranch_scc1 .LBB0_27
	v_add_co_u32 v20, vcc_lo, s34, v5
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v21, null, s35, v6, vcc_lo
	v_mov_b16_e32 v11.l, 0
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v10, 16, v10
	global_load_d16_hi_b16 v11, v[20:21], off offset:256
	s_wait_loadcnt 0x0
	v_add_f32_e32 v11, 1.0, v11
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v20, v11, 16, 1
	v_or_b32_e32 v21, 0x400000, v11
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	v_add3_u32 v20, v20, v11, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_cndmask_b32_e32 v11, v20, v21, vcc_lo
	v_and_b32_e32 v11, 0xffff0000, v11
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v10, v10, v11
	v_bfe_u32 v11, v10, 16, 1
	v_or_b32_e32 v20, 0x400000, v10
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v11, v11, v10, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v10, v11, v20, vcc_lo
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v10, 16, v10
.LBB0_27:
	v_add_co_u32 v20, vcc_lo, s10, v12
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v21, null, s11, v13, vcc_lo
	v_add_co_u32 v12, vcc_lo, s22, v12
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v13, null, s23, v13, vcc_lo
	global_load_u16 v11, v[20:21], off
	global_load_u16 v20, v[7:8], off offset:256
	s_and_b32 s4, s6, exec_lo
	s_cselect_b32 s4, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s4, 1
	s_wait_loadcnt 0x1
	v_lshlrev_b32_e32 v11, 16, v11
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v20, 16, v20
	v_lshlrev_b32_e32 v10, 16, v10
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_dual_add_f32 v10, v10, v11 :: v_dual_add_f32 v11, 1.0, v20
	v_mul_f32_e32 v20, v19, v10
	v_add_nc_u32_e32 v10, 0x100, v9
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_mul_f32_e32 v20, v20, v11
	v_ashrrev_i32_e32 v11, 31, v10
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_bfe_u32 v21, v20, 16, 1
	v_lshlrev_b64_e32 v[10:11], 1, v[10:11]
	v_or_b32_e32 v22, 0x400000, v20
	v_cmp_u_f32_e32 vcc_lo, v20, v20
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v21, v21, v20, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v22, v21, v22, vcc_lo
	v_add_co_u32 v20, vcc_lo, s8, v10
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v21, null, s9, v11, vcc_lo
	global_store_d16_hi_b16 v[12:13], v22, off
	global_load_d16_b16 v12, v[20:21], off
	s_cbranch_scc1 .LBB0_29
	v_add_co_u32 v20, vcc_lo, s34, v5
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v21, null, s35, v6, vcc_lo
	v_mov_b16_e32 v13.l, 0
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v12, 16, v12
	global_load_d16_hi_b16 v13, v[20:21], off offset:512
	s_wait_loadcnt 0x0
	v_add_f32_e32 v13, 1.0, v13
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v20, v13, 16, 1
	v_or_b32_e32 v21, 0x400000, v13
	v_cmp_u_f32_e32 vcc_lo, v13, v13
	v_add3_u32 v20, v20, v13, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_cndmask_b32_e32 v13, v20, v21, vcc_lo
	v_and_b32_e32 v13, 0xffff0000, v13
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v12, v12, v13
	v_bfe_u32 v13, v12, 16, 1
	v_or_b32_e32 v20, 0x400000, v12
	v_cmp_u_f32_e32 vcc_lo, v12, v12
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v13, v13, v12, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v12, v13, v20, vcc_lo
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v12, 16, v12
.LBB0_29:
	v_add_co_u32 v20, vcc_lo, s10, v10
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v21, null, s11, v11, vcc_lo
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v12, 16, v12
	s_and_b32 s4, s6, exec_lo
	s_cselect_b32 s4, 1, 0
	global_load_u16 v13, v[20:21], off
	global_load_u16 v20, v[7:8], off offset:512
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s4, 1
	s_wait_loadcnt 0x1
	v_lshlrev_b32_e32 v13, 16, v13
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v20, 16, v20
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_dual_add_f32 v12, v12, v13 :: v_dual_add_f32 v13, 1.0, v20
	v_mul_f32_e32 v20, v19, v12
	v_add_nc_u32_e32 v12, 0x180, v9
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_mul_f32_e32 v20, v20, v13
	v_ashrrev_i32_e32 v13, 31, v12
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_bfe_u32 v9, v20, 16, 1
	v_lshlrev_b64_e32 v[12:13], 1, v[12:13]
	v_or_b32_e32 v21, 0x400000, v20
	s_delay_alu instid0(VALU_DEP_3)
	v_add3_u32 v22, v9, v20, 0x7fff
	v_add_co_u32 v9, vcc_lo, s22, v10
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v10, null, s23, v11, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v20, v20
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v11, v22, v21, vcc_lo
	v_add_co_u32 v20, vcc_lo, s8, v12
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v21, null, s9, v13, vcc_lo
	global_store_d16_hi_b16 v[9:10], v11, off
	global_load_d16_b16 v9, v[20:21], off
	s_cbranch_scc1 .LBB0_22
	v_add_co_u32 v5, vcc_lo, s34, v5
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v6, null, s35, v6, vcc_lo
	v_mov_b16_e32 v10.l, 0
	global_load_d16_hi_b16 v10, v[5:6], off offset:768
	s_wait_loadcnt 0x0
	v_add_f32_e32 v5, 1.0, v10
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v6, v5, 16, 1
	v_or_b32_e32 v10, 0x400000, v5
	v_cmp_u_f32_e32 vcc_lo, v5, v5
	v_add3_u32 v6, v6, v5, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_dual_cndmask_b32 v5, v6, v10 :: v_dual_lshlrev_b32 v6, 16, v9
	v_and_b32_e32 v5, 0xffff0000, v5
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v5, v6, v5
	v_bfe_u32 v6, v5, 16, 1
	v_or_b32_e32 v9, 0x400000, v5
	v_cmp_u_f32_e32 vcc_lo, v5, v5
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v6, v6, v5, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v5, v6, v9, vcc_lo
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v9, 16, v5
	s_branch .LBB0_22
.LBB0_31:
	s_wait_loadcnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s4, s2
	s_cbranch_execz .LBB0_42
	v_mov_b32_e32 v2, 0
	s_mov_b32 s3, exec_lo
	s_wait_kmcnt 0x0
	s_mov_b32 s6, exec_lo
	v_mbcnt_lo_u32_b32 v1, s3, 0
	global_load_b32 v3, v2, s[28:29] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_34
	s_bcnt1_i32_b32 s3, s3
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v4, s3
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v4, v2, v4, s[28:29] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_34:
	s_or_b32 exec_lo, exec_lo, s6
	v_readfirstlane_b32 s3, v4
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v1, s3, v1
	s_mov_b32 s3, exec_lo
	v_cmpx_ne_u32_e32 63, v1
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s6, exec_lo, s3
	s_cbranch_execz .LBB0_39
	s_cmp_lt_i32 s26, 1
	s_mov_b32 s8, 1
	s_cbranch_scc1 .LBB0_68
	v_mov_b32_e32 v1, 0
.LBB0_37:
	global_load_b32 v2, v1, s[28:29] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	global_load_b32 v4, v1, s[30:31] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, v2, v3
	v_cmp_eq_u32_e64 s3, 0, v4
	s_and_b32 s3, vcc_lo, s3
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s8, s26
	s_cselect_b32 s9, -1, 0
	s_add_co_i32 s8, s8, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s9, s3, s9
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s9
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_37
	s_and_b32 vcc_lo, exec_lo, s3
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_69
.LBB0_39:
	s_and_not1_saveexec_b32 s3, s6
	s_cbranch_execz .LBB0_41
.LBB0_40:
	v_dual_mov_b32 v1, 0 :: v_dual_add_nc_u32 v2, 1, v3
	global_store_b32 v1, v1, s[28:29] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v1, v2, s[28:29] offset:4 scope:SCOPE_DEV
.LBB0_41:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
	v_mov_b32_e32 v1, 0
	global_load_b32 v2, v1, s[30:31] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, 0, v2
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e64 v2, 0, 1, vcc_lo
	ds_store_b32 v1, v2 offset:20
.LBB0_42:
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
	s_cbranch_vccnz .LBB0_118
	v_lshrrev_b32_e32 v1, 1, v0
	v_and_b32_e32 v31, 15, v0
	s_lshl_b32 s3, ttmp9, 2
	s_wait_kmcnt 0x0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s6, s3, s5
	v_and_b32_e32 v32, 8, v1
	v_cmp_gt_i32_e64 s3, s24, v31
	v_mul_u32_u24_e32 v33, 0x1400, v31
	v_mul_u32_u24_e32 v34, 0x4400, v31
	s_cmp_gt_i32 s6, 0x43f
	s_cbranch_scc1 .LBB0_60
	s_delay_alu instid0(VALU_DEP_2)
	v_or_b32_e32 v35, v33, v32
	v_mov_b32_e32 v28, 0
	s_mov_b32 s8, s6
	s_branch .LBB0_46
.LBB0_45:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s9
	s_add_co_i32 s4, s8, 0x100
	s_cmp_lt_i32 s8, 0x340
	s_wait_alu depctr_sa_sdst(0)
	s_mov_b32 s8, s4
	s_cbranch_scc0 .LBB0_60
.LBB0_46:
	s_wait_alu depctr_sa_sdst(0)
	s_lshl_b32 s4, s8, 4
	v_dual_mov_b32 v8, v28 :: v_dual_mov_b32 v9, v28
	s_wait_alu depctr_sa_sdst(0)
	v_or_b32_e32 v0, s4, v31
	v_dual_mov_b32 v10, v28 :: v_dual_mov_b32 v11, v28
	v_dual_mov_b32 v12, v28 :: v_dual_mov_b32 v13, v28
	s_delay_alu instid0(VALU_DEP_3)
	v_mul_lo_u32 v4, 0x1400, v0
	v_dual_mov_b32 v14, v28 :: v_dual_mov_b32 v15, v28
	v_dual_mov_b32 v0, v28 :: v_dual_mov_b32 v1, v28
	v_dual_mov_b32 v2, v28 :: v_dual_mov_b32 v3, v28
	v_mov_b32_e32 v5, v28
	v_or_b32_e32 v36, v4, v32
	v_mov_b32_e32 v4, v28
	v_dual_mov_b32 v6, v28 :: v_dual_mov_b32 v7, v28
	s_mov_b32 s5, 0
	s_branch .LBB0_48
.LBB0_47:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s9
	v_add_nc_u32_e32 v20, 64, v29
	s_add_co_i32 s9, s5, 0x50
	s_cmp_lt_u32 s5, 0x13b0
	s_wait_alu depctr_sa_sdst(0)
	s_mov_b32 s5, s9
	v_ashrrev_i32_e32 v21, 31, v20
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshlrev_b64_e32 v[20:21], 1, v[20:21]
	v_add_co_u32 v20, vcc_lo, s14, v20
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_add_co_ci_u32_e64 v21, null, s15, v21, vcc_lo
	v_add_co_u32 v24, vcc_lo, 0xa800000, v20
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_add_co_ci_u32_e64 v25, null, 0, v21, vcc_lo
	s_clause 0x1
	global_load_b128 v[20:23], v[20:21], off
	global_load_b128 v[24:27], v[24:25], off offset:2097152
	s_wait_loadcnt 0x1
	v_wmma_f32_16x16x16_bf16 v[8:15], v[20:23], v[16:19], v[8:15]
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[24:27], v[16:19], v[0:7]
	s_cbranch_scc0 .LBB0_58
.LBB0_48:
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v16, 0 :: v_dual_add_nc_u32 v27, s5, v35
	v_dual_mov_b32 v19, 0 :: v_dual_mov_b32 v20, 0
	v_dual_mov_b32 v21, 0 :: v_dual_mov_b32 v22, 0
	s_and_saveexec_b32 s9, s3
	s_cbranch_execz .LBB0_50
	v_lshlrev_b64_e32 v[17:18], 1, v[27:28]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v17, vcc_lo, s22, v17
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v18, null, s23, v18, vcc_lo
	global_load_b128 v[19:22], v[17:18], off
.LBB0_50:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s9
	v_add_nc_u32_e32 v29, s5, v36
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v30, 31, v29
	v_lshlrev_b64_e32 v[17:18], 1, v[29:30]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v17, vcc_lo, s14, v17
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v18, null, s15, v18, vcc_lo
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v37, vcc_lo, 0xa800000, v17
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v38, null, 0, v18, vcc_lo
	s_clause 0x1
	global_load_b128 v[23:26], v[17:18], off
	global_load_b128 v[37:40], v[37:38], off offset:2097152
	v_dual_mov_b32 v17, 0 :: v_dual_mov_b32 v18, 0
	s_wait_loadcnt 0x1
	v_wmma_f32_16x16x16_bf16 v[8:15], v[23:26], v[19:22], v[8:15]
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[37:40], v[19:22], v[0:7]
	v_mov_b32_e32 v19, 0
	s_and_saveexec_b32 s9, s3
	s_cbranch_execz .LBB0_52
	v_lshlrev_b64_e32 v[16:17], 1, v[27:28]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v16, vcc_lo, s22, v16
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v17, null, s23, v17, vcc_lo
	global_load_b128 v[16:19], v[16:17], off offset:32
.LBB0_52:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s9
	v_add_nc_u32_e32 v20, 16, v29
	v_mov_b32_e32 v24, 0
	v_dual_mov_b32 v26, 0 :: v_dual_mov_b32 v25, 0
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v21, 31, v20
	v_lshlrev_b64_e32 v[20:21], 1, v[20:21]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v20, vcc_lo, s14, v20
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v21, null, s15, v21, vcc_lo
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v22, vcc_lo, 0xa800000, v20
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v23, null, 0, v21, vcc_lo
	s_clause 0x1
	global_load_b128 v[37:40], v[20:21], off
	global_load_b128 v[41:44], v[22:23], off offset:2097152
	v_dual_mov_b32 v20, 0 :: v_dual_mov_b32 v23, 0
	s_wait_loadcnt 0x1
	v_wmma_f32_16x16x16_bf16 v[8:15], v[37:40], v[16:19], v[8:15]
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[41:44], v[16:19], v[0:7]
	s_and_saveexec_b32 s9, s3
	s_cbranch_execz .LBB0_54
	v_lshlrev_b64_e32 v[16:17], 1, v[27:28]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v16, vcc_lo, s22, v16
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v17, null, s23, v17, vcc_lo
	global_load_b128 v[23:26], v[16:17], off offset:64
.LBB0_54:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s9
	v_add_nc_u32_e32 v16, 32, v29
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v17, 31, v16
	v_lshlrev_b64_e32 v[16:17], 1, v[16:17]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v16, vcc_lo, s14, v16
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v17, null, s15, v17, vcc_lo
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v21, vcc_lo, 0xa800000, v16
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v22, null, 0, v17, vcc_lo
	s_clause 0x1
	global_load_b128 v[16:19], v[16:17], off
	global_load_b128 v[37:40], v[21:22], off offset:2097152
	v_dual_mov_b32 v21, 0 :: v_dual_mov_b32 v22, 0
	s_wait_loadcnt 0x1
	v_wmma_f32_16x16x16_bf16 v[8:15], v[16:19], v[23:26], v[8:15]
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[37:40], v[23:26], v[0:7]
	v_mov_b32_e32 v23, 0
	s_and_saveexec_b32 s9, s3
	s_cbranch_execz .LBB0_56
	v_lshlrev_b64_e32 v[16:17], 1, v[27:28]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v16, vcc_lo, s22, v16
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v17, null, s23, v17, vcc_lo
	global_load_b128 v[20:23], v[16:17], off offset:96
.LBB0_56:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s9
	v_add_nc_u32_e32 v16, 48, v29
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v17, 31, v16
	v_lshlrev_b64_e32 v[16:17], 1, v[16:17]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v16, vcc_lo, s14, v16
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v17, null, s15, v17, vcc_lo
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v18, vcc_lo, 0xa800000, v16
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v19, null, 0, v17, vcc_lo
	s_clause 0x1
	global_load_b128 v[37:40], v[16:17], off
	global_load_b128 v[41:44], v[18:19], off offset:2097152
	v_dual_mov_b32 v16, 0 :: v_dual_mov_b32 v19, 0
	v_dual_mov_b32 v17, 0 :: v_dual_mov_b32 v18, 0
	s_wait_loadcnt 0x1
	v_wmma_f32_16x16x16_bf16 v[8:15], v[37:40], v[20:23], v[8:15]
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[41:44], v[20:23], v[0:7]
	s_and_saveexec_b32 s9, s3
	s_cbranch_execz .LBB0_47
	v_lshlrev_b64_e32 v[16:17], 1, v[27:28]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v16, vcc_lo, s22, v16
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v17, null, s23, v17, vcc_lo
	global_load_b128 v[16:19], v[16:17], off offset:128
	s_branch .LBB0_47
.LBB0_58:
	s_and_saveexec_b32 s9, s3
	s_cbranch_execz .LBB0_45
	v_bfe_u32 v16, v8, 16, 1
	v_or_b32_e32 v17, 0x400000, v8
	v_bfe_u32 v18, v9, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v8, v8
	v_or_b32_e32 v19, 0x400000, v9
	v_add3_u32 v16, v16, v8, 0x7fff
	v_bfe_u32 v22, v10, 16, 1
	v_add3_u32 v18, v18, v9, 0x7fff
	v_or_b32_e32 v23, 0x400000, v10
	v_bfe_u32 v26, v11, 16, 1
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v8, v16, v17, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v9, v9
	v_add3_u32 v22, v22, v10, 0x7fff
	v_or_b32_e32 v27, 0x400000, v11
	v_add3_u32 v26, v26, v11, 0x7fff
	v_bfe_u32 v16, v0, 16, 1
	s_wait_alu depctr_va_vcc(0)
	v_dual_cndmask_b32 v9, v18, v19 :: v_dual_and_b32 v20, 0xffff0000, v8
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	v_or_b32_e32 v8, s4, v32
	v_or_b32_e32 v17, 0x400000, v0
	s_delay_alu instid0(VALU_DEP_4)
	v_and_b32_e32 v24, 0xffff0000, v9
	v_add3_u32 v16, v16, v0, 0x7fff
	v_bfe_u32 v21, v1, 16, 1
	v_or_b32_e32 v19, 0x400000, v1
	v_cmp_u_f32_e64 s4, v1, v1
	v_mul_f32_e32 v29, 0xbfb8aa3b, v24
	v_bfe_u32 v30, v12, 16, 1
	v_add3_u32 v21, v21, v1, 0x7fff
	v_or_b32_e32 v36, 0x400000, v12
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v10, v22, v23, vcc_lo
	v_fma_f32 v37, 0xbfb8aa3b, v24, -v29
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v19, v21, v19, s4
	v_add3_u32 v30, v30, v12, 0x7fff
	v_and_b32_e32 v10, 0xffff0000, v10
	v_fmac_f32_e32 v37, 0xb2a5705f, v24
	s_wait_alu depctr_va_vcc(0)
	v_dual_mul_f32 v18, 0xbfb8aa3b, v20 :: v_dual_cndmask_b32 v11, v26, v27
	v_add_nc_u32_e32 v8, v8, v34
	v_cmp_nlt_f32_e64 s4, 0x42ce8ed0, v10
	v_cmp_ngt_f32_e64 s5, 0xc2b17218, v10
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_2) | instid1(VALU_DEP_2)
	v_fma_f32 v9, 0xbfb8aa3b, v20, -v18
	v_rndne_f32_e32 v25, v18
	v_and_b32_e32 v11, 0xffff0000, v11
	v_dual_fmac_f32 v9, 0xb2a5705f, v20 :: v_dual_sub_f32 v18, v18, v25
	v_cvt_i32_f32_e32 v25, v25
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_add_f32_e32 v9, v18, v9
	v_rndne_f32_e32 v18, v29
	v_cmp_nlt_f32_e32 vcc_lo, 0x42ce8ed0, v20
	v_exp_f32_e32 v9, v9
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_sub_f32_e32 v29, v29, v18
	v_cvt_i32_f32_e32 v18, v18
	v_add_f32_e32 v29, v29, v37
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_ldexp_f32 v9, v9, v25
	v_exp_f32_e32 v22, v29
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_2)
	v_cndmask_b32_e32 v9, 0, v9, vcc_lo
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2b17218, v20
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v9, 0x7f800000, v9, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v0, v0
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v0, v16, v17, vcc_lo
	v_ldexp_f32 v16, v22, v18
	v_dual_mul_f32 v17, 0xbfb8aa3b, v10 :: v_dual_add_f32 v18, 1.0, v9
	v_cmp_nlt_f32_e32 vcc_lo, 0x42ce8ed0, v24
	v_mul_f32_e32 v22, 0xbfb8aa3b, v11
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_rndne_f32_e32 v25, v17
	v_div_scale_f32 v23, null, v18, v18, v20
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v9, 0, v16, vcc_lo
	v_fma_f32 v16, 0xbfb8aa3b, v10, -v17
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2b17218, v24
	v_fma_f32 v27, 0xbfb8aa3b, v11, -v22
	v_rcp_f32_e32 v26, v23
	v_rndne_f32_e32 v37, v22
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_dual_fmac_f32 v16, 0xb2a5705f, v10 :: v_dual_fmac_f32 v27, 0xb2a5705f, v11
	v_sub_f32_e32 v22, v22, v37
	v_sub_f32_e32 v17, v17, v25
	v_cvt_i32_f32_e32 v25, v25
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(SKIP_4) | instid1(VALU_DEP_3)
	v_fma_f32 v38, -v23, v26, 1.0
	s_wait_alu depctr_va_vcc(0)
	v_dual_cndmask_b32 v9, 0x7f800000, v9 :: v_dual_add_f32 v22, v22, v27
	v_add_f32_e32 v16, v17, v16
	v_div_scale_f32 v39, vcc_lo, v20, v18, v20
	v_dual_fmac_f32 v26, v38, v26 :: v_dual_add_f32 v29, 1.0, v9
	v_and_b32_e32 v27, 0xffff0000, v0
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_3) | instid1(VALU_DEP_1)
	v_exp_f32_e32 v16, v16
	v_ashrrev_i32_e32 v9, 31, v8
	v_cvt_i32_f32_e32 v37, v37
	v_div_scale_f32 v17, null, v29, v29, v24
	v_rcp_f32_e32 v40, v17
	s_delay_alu instid0(TRANS32_DEP_2) | instskip(SKIP_2) | instid1(VALU_DEP_1)
	v_ldexp_f32 v0, v16, v25
	v_exp_f32_e32 v16, v22
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v0, 0, v0, s4
	s_delay_alu instid0(TRANS32_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fma_f32 v1, -v17, v40, 1.0
	v_fmac_f32_e32 v40, v1, v40
	v_div_scale_f32 v25, s4, v24, v29, v24
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_dual_mul_f32 v21, v39, v26 :: v_dual_mul_f32 v38, v25, v40
	v_fma_f32 v22, -v23, v21, v39
	s_delay_alu instid0(VALU_DEP_1)
	v_fmac_f32_e32 v21, v22, v26
	s_wait_alu depctr_sa_sdst(0)
	v_cndmask_b32_e64 v22, 0x7f800000, v0, s5
	v_lshlrev_b64_e32 v[0:1], 1, v[8:9]
	v_ldexp_f32 v9, v16, v37
	v_cmp_u_f32_e64 s5, v6, v6
	v_fma_f32 v16, -v23, v21, v39
	v_add_f32_e32 v22, 1.0, v22
	v_fma_f32 v23, -v17, v38, v25
	s_delay_alu instid0(VALU_DEP_1)
	v_fmac_f32_e32 v38, v23, v40
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v16, v16, v26, v21
	v_div_scale_f32 v21, null, v22, v22, v10
	v_cmp_nlt_f32_e32 vcc_lo, 0x42ce8ed0, v11
	v_fma_f32 v17, -v17, v38, v25
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_div_fixup_f32 v16, v16, v18, v20
	v_rcp_f32_e32 v18, v21
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v9, 0, v9, vcc_lo
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2b17218, v11
	v_mul_f32_e32 v16, v16, v27
	s_delay_alu instid0(TRANS32_DEP_1)
	v_fma_f32 v23, -v21, v18, 1.0
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v9, 0x7f800000, v9, vcc_lo
	s_mov_b32 vcc_lo, s4
	v_bfe_u32 v20, v16, 16, 1
	s_wait_alu depctr_sa_sdst(0)
	v_div_fmas_f32 v17, v17, v40, v38
	v_cmp_u_f32_e64 s4, v16, v16
	v_div_scale_f32 v25, vcc_lo, v10, v22, v10
	v_fmac_f32_e32 v18, v23, v18
	v_add3_u32 v20, v20, v16, 0x7fff
	v_div_fixup_f32 v17, v17, v29, v24
	v_or_b32_e32 v24, 0x400000, v16
	v_and_b32_e32 v19, 0xffff0000, v19
	v_or_b32_e32 v29, 0x400000, v2
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_3)
	v_cndmask_b32_e64 v16, v20, v24, s4
	v_add_co_u32 v0, s4, s22, v0
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v1, null, s23, v1, s4
	v_cmp_u_f32_e64 s4, v12, v12
	v_mul_f32_e32 v20, v25, v18
	v_bfe_u32 v24, v2, 16, 1
	v_lshrrev_b32_e32 v16, 16, v16
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v12, v30, v36, s4
	v_add_f32_e32 v9, 1.0, v9
	v_fma_f32 v26, -v21, v20, v25
	v_mul_f32_e32 v17, v17, v19
	v_add3_u32 v24, v24, v2, 0x7fff
	v_and_b32_e32 v12, 0xffff0000, v12
	v_div_scale_f32 v19, null, v9, v9, v11
	v_fmac_f32_e32 v20, v26, v18
	v_cmp_u_f32_e64 s4, v2, v2
	v_bfe_u32 v23, v17, 16, 1
	v_or_b32_e32 v26, 0x400000, v17
	v_rcp_f32_e32 v27, v19
	v_fma_f32 v21, -v21, v20, v25
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v2, v24, v29, s4
	v_add3_u32 v23, v23, v17, 0x7fff
	v_cmp_u_f32_e64 s4, v17, v17
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v18, v21, v18, v20
	v_and_b32_e32 v2, 0xffff0000, v2
	v_div_scale_f32 v21, vcc_lo, v11, v9, v11
	v_fma_f32 v24, -v19, v27, 1.0
	v_mul_f32_e32 v30, 0xbfb8aa3b, v12
	v_div_fixup_f32 v10, v18, v22, v10
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v17, v23, v26, s4
	v_cmp_u_f32_e64 s4, v3, v3
	v_fmac_f32_e32 v27, v24, v27
	v_fma_f32 v25, 0xbfb8aa3b, v12, -v30
	v_rndne_f32_e32 v29, v30
	v_mul_f32_e32 v10, v10, v2
	v_bfe_u32 v2, v3, 16, 1
	v_lshrrev_b32_e32 v17, 16, v17
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_1) | instid1(VALU_DEP_4)
	v_dual_fmac_f32 v25, 0xb2a5705f, v12 :: v_dual_sub_f32 v20, v30, v29
	v_cvt_i32_f32_e32 v24, v29
	v_add3_u32 v2, v2, v3, 0x7fff
	s_delay_alu instid0(VALU_DEP_4)
	v_mov_b16_e32 v16.h, v17.l
	v_bfe_u32 v26, v14, 16, 1
	v_add_f32_e32 v18, v20, v25
	v_mul_f32_e32 v20, v21, v27
	v_or_b32_e32 v25, 0x400000, v3
	v_or_b32_e32 v30, 0x400000, v5
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_fma_f32 v22, -v19, v20, v21
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v3, v2, v25, s4
	v_cmp_nlt_f32_e64 s4, 0x42ce8ed0, v12
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fmac_f32_e32 v20, v22, v27
	v_fma_f32 v2, -v19, v20, v21
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_2) | instid1(VALU_DEP_2)
	v_and_b32_e32 v21, 0xffff0000, v3
	v_exp_f32_e32 v18, v18
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v19, v2, v27, v20
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2b17218, v12
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(TRANS32_DEP_1)
	v_div_fixup_f32 v9, v19, v9, v11
	v_ldexp_f32 v18, v18, v24
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_mul_f32_e32 v9, v9, v21
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v18, 0, v18, s4
	v_bfe_u32 v23, v10, 16, 1
	v_or_b32_e32 v20, 0x400000, v10
	v_bfe_u32 v17, v9, 16, 1
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v18, 0x7f800000, v18, vcc_lo
	v_add3_u32 v22, v23, v10, 0x7fff
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	v_cmp_u_f32_e64 s4, v9, v9
	v_add3_u32 v17, v17, v9, 0x7fff
	v_add_f32_e32 v11, 1.0, v18
	v_bfe_u32 v18, v13, 16, 1
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v19, v22, v20, vcc_lo
	v_or_b32_e32 v20, 0x400000, v13
	v_cmp_u_f32_e32 vcc_lo, v13, v13
	v_div_scale_f32 v10, null, v11, v11, v12
	v_add3_u32 v18, v18, v13, 0x7fff
	v_bfe_u32 v22, v4, 16, 1
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_rcp_f32_e32 v21, v10
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v13, v18, v20, vcc_lo
	v_or_b32_e32 v20, 0x400000, v9
	v_add3_u32 v9, v22, v4, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(TRANS32_DEP_1)
	v_cndmask_b32_e64 v17, v17, v20, s4
	v_or_b32_e32 v20, 0x400000, v4
	v_fma_f32 v18, -v10, v21, 1.0
	v_add_nc_u32_e32 v2, 3, v8
	v_cmp_u_f32_e64 s4, v4, v4
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_fmac_f32_e32 v21, v18, v21
	v_ashrrev_i32_e32 v3, 31, v2
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_cndmask_b32_e64 v4, v9, v20, s4
	v_cmp_u_f32_e64 s4, v14, v14
	v_lshlrev_b64_e32 v[2:3], 1, v[2:3]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v2, vcc_lo, s22, v2
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v3, null, s23, v3, vcc_lo
	v_div_scale_f32 v18, vcc_lo, v12, v11, v12
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_mul_f32_e32 v22, v18, v21
	v_and_b32_e32 v13, 0xffff0000, v13
	v_fma_f32 v20, -v10, v22, v18
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_mul_f32_e32 v23, 0xbfb8aa3b, v13
	v_fmac_f32_e32 v22, v20, v21
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_2) | instid1(VALU_DEP_4)
	v_rndne_f32_e32 v25, v23
	v_fma_f32 v24, 0xbfb8aa3b, v13, -v23
	v_bfe_u32 v20, v15, 16, 1
	v_fma_f32 v10, -v10, v22, v18
	s_delay_alu instid0(VALU_DEP_4)
	v_sub_f32_e32 v9, v23, v25
	v_add3_u32 v23, v26, v14, 0x7fff
	v_or_b32_e32 v26, 0x400000, v14
	v_add3_u32 v20, v20, v15, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v10, v10, v21, v22
	v_cmp_u_f32_e32 vcc_lo, v15, v15
	v_cvt_i32_f32_e32 v18, v25
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v14, v23, v26, s4
	v_or_b32_e32 v23, 0x400000, v15
	v_fmac_f32_e32 v24, 0xb2a5705f, v13
	v_div_fixup_f32 v11, v10, v11, v12
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_dual_cndmask_b32 v15, v20, v23 :: v_dual_and_b32 v14, 0xffff0000, v14
	v_add_f32_e32 v9, v9, v24
	v_cmp_nlt_f32_e32 vcc_lo, 0x42ce8ed0, v13
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_cmp_ngt_f32_e64 s4, 0xc2b17218, v14
	v_and_b32_e32 v15, 0xffff0000, v15
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(TRANS32_DEP_1)
	v_exp_f32_e32 v9, v9
	v_ldexp_f32 v9, v9, v18
	v_mul_f32_e32 v18, 0xbfb8aa3b, v14
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_dual_cndmask_b32 v9, 0, v9 :: v_dual_and_b32 v4, 0xffff0000, v4
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2b17218, v13
	v_fma_f32 v12, 0xbfb8aa3b, v14, -v18
	v_rndne_f32_e32 v20, v18
	v_mul_f32_e32 v21, 0xbfb8aa3b, v15
	s_wait_alu depctr_va_vcc(0)
	v_dual_cndmask_b32 v10, 0x7f800000, v9 :: v_dual_add_nc_u32 v9, 4, v8
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_sub_f32_e32 v18, v18, v20
	v_fma_f32 v23, 0xbfb8aa3b, v15, -v21
	v_fmac_f32_e32 v12, 0xb2a5705f, v14
	v_rndne_f32_e32 v24, v21
	v_add_f32_e32 v22, 1.0, v10
	v_ashrrev_i32_e32 v10, 31, v9
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_dual_fmac_f32 v23, 0xb2a5705f, v15 :: v_dual_add_f32 v12, v18, v12
	v_sub_f32_e32 v21, v21, v24
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_div_scale_f32 v18, null, v22, v22, v13
	v_lshlrev_b64_e32 v[9:10], 1, v[9:10]
	v_mul_f32_e32 v11, v11, v4
	v_exp_f32_e32 v12, v12
	v_cvt_i32_f32_e32 v4, v20
	v_rcp_f32_e32 v25, v18
	v_add_f32_e32 v20, v21, v23
	v_add_co_u32 v9, vcc_lo, s22, v9
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v10, null, s23, v10, vcc_lo
	v_cmp_nlt_f32_e32 vcc_lo, 0x42ce8ed0, v14
	s_delay_alu instid0(TRANS32_DEP_2) | instskip(SKIP_1) | instid1(TRANS32_DEP_2)
	v_ldexp_f32 v4, v12, v4
	v_exp_f32_e32 v20, v20
	v_fma_f32 v12, -v18, v25, 1.0
	v_bfe_u32 v21, v11, 16, 1
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v4, 0, v4, vcc_lo
	v_div_scale_f32 v23, vcc_lo, v13, v22, v13
	v_fmac_f32_e32 v25, v12, v25
	v_cvt_i32_f32_e32 v12, v24
	v_add3_u32 v21, v21, v11, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v4, 0x7f800000, v4, s4
	v_cmp_nlt_f32_e64 s4, 0x42ce8ed0, v15
	v_mul_f32_e32 v24, v23, v25
	v_ldexp_f32 v12, v20, v12
	v_or_b32_e32 v20, 0x400000, v11
	v_add_f32_e32 v26, 1.0, v4
	s_delay_alu instid0(VALU_DEP_4)
	v_fma_f32 v27, -v18, v24, v23
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v4, 0, v12, s4
	v_bfe_u32 v12, v5, 16, 1
	v_cmp_ngt_f32_e64 s4, 0xc2b17218, v15
	v_div_scale_f32 v29, null, v26, v26, v14
	v_fmac_f32_e32 v24, v27, v25
	s_delay_alu instid0(VALU_DEP_4)
	v_add3_u32 v12, v12, v5, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v4, 0x7f800000, v4, s4
	v_cmp_u_f32_e64 s4, v5, v5
	v_rcp_f32_e32 v27, v29
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_3) | instid1(TRANS32_DEP_1)
	v_cndmask_b32_e64 v5, v12, v30, s4
	v_fma_f32 v12, -v18, v24, v23
	v_cmp_u_f32_e64 s4, v11, v11
	v_or_b32_e32 v30, 0x400000, v6
	v_fma_f32 v23, -v29, v27, 1.0
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v12, v12, v25, v24
	v_and_b32_e32 v24, 0xffff0000, v5
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v20, v21, v20, s4
	v_fmac_f32_e32 v27, v23, v27
	v_div_fixup_f32 v12, v12, v22, v13
	v_div_scale_f32 v13, vcc_lo, v14, v26, v14
	v_bfe_u32 v22, v6, 16, 1
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_dual_mul_f32 v11, v12, v24 :: v_dual_mul_f32 v12, v13, v27
	v_add3_u32 v22, v22, v6, 0x7fff
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_bfe_u32 v23, v11, 16, 1
	v_fma_f32 v24, -v29, v12, v13
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_4)
	v_cndmask_b32_e64 v6, v22, v30, s5
	v_bfe_u32 v22, v7, 16, 1
	v_add3_u32 v23, v23, v11, 0x7fff
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_fmac_f32_e32 v12, v24, v27
	v_add3_u32 v22, v22, v7, 0x7fff
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_fma_f32 v13, -v29, v12, v13
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v12, v13, v27, v12
	v_and_b32_e32 v13, 0xffff0000, v6
	v_or_b32_e32 v27, 0x400000, v7
	v_cmp_u_f32_e32 vcc_lo, v7, v7
	v_add_nc_u32_e32 v6, 6, v8
	v_div_fixup_f32 v12, v12, v26, v14
	v_add_f32_e32 v36, 1.0, v4
	v_add_nc_u32_e32 v4, 5, v8
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_ashrrev_i32_e32 v7, 31, v6
	v_mul_f32_e32 v13, v12, v13
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_div_scale_f32 v18, null, v36, v36, v15
	v_ashrrev_i32_e32 v5, 31, v4
	v_or_b32_e32 v12, 0x400000, v11
	v_lshlrev_b64_e32 v[6:7], 1, v[6:7]
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_rcp_f32_e32 v25, v18
	v_lshlrev_b64_e32 v[4:5], 1, v[4:5]
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(TRANS32_DEP_1)
	v_add_co_u32 v4, s4, s22, v4
	v_fma_f32 v21, -v18, v25, 1.0
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_add_co_ci_u32_e64 v5, null, s23, v5, s4
	v_fmac_f32_e32 v25, v21, v25
	v_div_scale_f32 v21, s4, v15, v36, v15
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v24, v21, v25
	v_fma_f32 v29, -v18, v24, v21
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fmac_f32_e32 v24, v29, v25
	v_fma_f32 v14, -v18, v24, v21
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v18, v22, v27, vcc_lo
	s_mov_b32 vcc_lo, s4
	s_wait_alu depctr_sa_sdst(0)
	v_div_fmas_f32 v14, v14, v25, v24
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	v_add_nc_u32_e32 v11, 7, v8
	v_and_b32_e32 v18, 0xffff0000, v18
	s_delay_alu instid0(VALU_DEP_4)
	v_div_fixup_f32 v14, v14, v36, v15
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v21, v23, v12, vcc_lo
	v_ashrrev_i32_e32 v12, 31, v11
	v_bfe_u32 v15, v13, 16, 1
	v_add_co_u32 v6, vcc_lo, s22, v6
	v_mul_f32_e32 v8, v14, v18
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_lshlrev_b64_e32 v[11:12], 1, v[11:12]
	v_add3_u32 v14, v15, v13, 0x7fff
	v_or_b32_e32 v15, 0x400000, v13
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v7, null, s23, v7, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v13, v13
	v_bfe_u32 v18, v8, 16, 1
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v13, v14, v15, vcc_lo
	v_add_co_u32 v11, vcc_lo, s22, v11
	s_delay_alu instid0(VALU_DEP_3)
	v_add3_u32 v14, v18, v8, 0x7fff
	v_or_b32_e32 v15, 0x400000, v8
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v12, null, s23, v12, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v8, v8
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v8, v14, v15, vcc_lo
	s_clause 0x6
	global_store_d16_hi_b16 v[0:1], v19, off offset:163844
	global_store_b32 v[0:1], v16, off offset:163840
	global_store_d16_hi_b16 v[2:3], v17, off offset:163840
	global_store_d16_hi_b16 v[9:10], v20, off offset:163840
	global_store_d16_hi_b16 v[4:5], v21, off offset:163840
	global_store_d16_hi_b16 v[6:7], v13, off offset:163840
	global_store_d16_hi_b16 v[11:12], v8, off offset:163840
	s_branch .LBB0_45
.LBB0_60:
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s3, s2
	s_cbranch_execz .LBB0_79
	v_mov_b32_e32 v1, 0
	s_mov_b32 s2, exec_lo
	s_mov_b32 s4, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	v_mbcnt_lo_u32_b32 v0, s2, 0
	global_load_b32 v2, v1, s[28:29] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_63
	s_bcnt1_i32_b32 s2, s2
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v3, s2
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v3, v1, v3, s[28:29] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_63:
	s_or_b32 exec_lo, exec_lo, s4
	v_readfirstlane_b32 s2, v3
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v0, s2, v0
	s_mov_b32 s2, exec_lo
	v_cmpx_ne_u32_e32 63, v0
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s4, exec_lo, s2
	s_cbranch_execz .LBB0_76
	s_cmp_lt_i32 s26, 1
	s_mov_b32 s5, 1
	s_cbranch_scc1 .LBB0_72
	v_mov_b32_e32 v0, 0
.LBB0_66:
	global_load_b32 v1, v0, s[28:29] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	global_load_b32 v3, v0, s[30:31] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, v1, v2
	v_cmp_eq_u32_e64 s2, 0, v3
	s_and_b32 s2, vcc_lo, s2
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s5, s26
	s_cselect_b32 s8, -1, 0
	s_add_co_i32 s5, s5, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s8, s2, s8
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s8
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_66
	s_and_b32 vcc_lo, exec_lo, s2
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_73
	s_branch .LBB0_76
.LBB0_68:
	s_cbranch_execz .LBB0_39
.LBB0_69:
	v_dual_mov_b32 v4, 1 :: v_dual_mov_b32 v5, 0
	s_mov_b32 s3, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v1, v5, v[4:5], s[30:31] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_71
	v_dual_mov_b32 v2, ttmp9 :: v_dual_mov_b32 v1, v4
	global_store_b96 v5, v[1:3], s[30:31] offset:4
.LBB0_71:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
	s_and_not1_saveexec_b32 s3, s6
	s_cbranch_execnz .LBB0_40
	s_branch .LBB0_41
.LBB0_72:
	s_cbranch_execz .LBB0_76
.LBB0_73:
	v_dual_mov_b32 v3, 1 :: v_dual_mov_b32 v4, 0
	s_mov_b32 s2, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v0, v4, v[3:4], s[30:31] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_75
	v_dual_mov_b32 v1, ttmp9 :: v_dual_mov_b32 v0, 2
	global_store_b96 v4, v[0:2], s[30:31] offset:4
.LBB0_75:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s2
.LBB0_76:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s2, s4
	s_cbranch_execz .LBB0_78
	v_dual_mov_b32 v0, 0 :: v_dual_add_nc_u32 v1, 1, v2
	global_store_b32 v0, v0, s[28:29] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v0, v1, s[28:29] offset:4 scope:SCOPE_DEV
.LBB0_78:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s2
	v_mov_b32_e32 v0, 0
	global_load_b32 v1, v0, s[30:31] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, 0, v1
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e64 v1, 0, 1, vcc_lo
	ds_store_b32 v0, v1 offset:20
.LBB0_79:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
	s_wait_storecnt 0x0
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	v_mov_b32_e32 v21, 0
	s_cmp_gt_i32 s6, 0x13f
	s_cselect_b32 s2, -1, 0
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	ds_load_b32 v0, v21 offset:20
	s_wait_dscnt 0x0
	v_cmp_eq_u32_e32 vcc_lo, 0, v0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s2, vcc_lo, s2
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s2
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_118
	s_load_b64 s[2:3], s[0:1], 0x68
	v_or_b32_e32 v24, v34, v32
	s_cmp_lg_u32 s7, 0
	v_cmp_gt_i32_e32 vcc_lo, s24, v31
	s_cselect_b32 s1, -1, 0
	s_branch .LBB0_83
.LBB0_81:
	global_store_b16 v[0:1], v3, off offset:14
.LBB0_82:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	s_add_co_i32 s0, s6, 0x100
	s_cmp_lt_i32 s6, 64
	s_wait_alu depctr_sa_sdst(0)
	s_mov_b32 s6, s0
	s_cbranch_scc0 .LBB0_118
.LBB0_83:
	s_lshl_b32 s5, s6, 4
	v_mov_b32_e32 v0, 0
	s_wait_alu depctr_sa_sdst(0)
	v_or_b32_e32 v1, s5, v31
	s_mov_b32 s4, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_dual_mov_b32 v3, v0 :: v_dual_mov_b32 v4, v0
	v_mul_lo_u32 v7, 0x4400, v1
	v_dual_mov_b32 v1, v0 :: v_dual_mov_b32 v2, v0
	v_dual_mov_b32 v5, v0 :: v_dual_mov_b32 v6, v0
	s_delay_alu instid0(VALU_DEP_3)
	v_or_b32_e32 v25, v7, v32
	v_mov_b32_e32 v7, v0
	s_branch .LBB0_85
.LBB0_84:
	s_or_b32 exec_lo, exec_lo, s7
	global_load_b128 v[8:11], v[22:23], off offset:224
	s_add_co_i32 s0, s4, 0x80
	s_cmp_lt_u32 s4, 0x4380
	s_wait_alu depctr_sa_sdst(0)
	s_mov_b32 s4, s0
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[8:11], v[12:15], v[0:7]
	s_cbranch_scc0 .LBB0_101
.LBB0_85:
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v9, 0 :: v_dual_add_nc_u32 v20, s4, v24
	v_dual_mov_b32 v10, 0 :: v_dual_mov_b32 v11, 0
	v_mov_b32_e32 v12, 0
	s_and_saveexec_b32 s7, vcc_lo
	s_cbranch_execz .LBB0_87
	v_lshlrev_b64_e32 v[8:9], 1, v[20:21]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v8, s0, s22, v8
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v9, null, s23, v9, s0
	global_load_b128 v[9:12], v[8:9], off offset:163840
.LBB0_87:
	s_or_b32 exec_lo, exec_lo, s7
	v_dual_mov_b32 v8, 0 :: v_dual_add_nc_u32 v13, s4, v25
	v_mov_b32_e32 v15, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v14, 31, v13
	v_lshlrev_b64_e32 v[13:14], 1, v[13:14]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v22, s0, s16, v13
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v23, null, s17, v14, s0
	v_dual_mov_b32 v13, 0 :: v_dual_mov_b32 v14, 0
	global_load_b128 v[16:19], v[22:23], off
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[16:19], v[9:12], v[0:7]
	v_mov_b32_e32 v16, 0
	s_and_saveexec_b32 s7, vcc_lo
	s_cbranch_execz .LBB0_89
	v_lshlrev_b64_e32 v[9:10], 1, v[20:21]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v9, s0, s22, v9
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v10, null, s23, v10, s0
	global_load_b128 v[13:16], v[9:10], off offset:163872
.LBB0_89:
	s_or_b32 exec_lo, exec_lo, s7
	global_load_b128 v[26:29], v[22:23], off offset:32
	v_dual_mov_b32 v9, 0 :: v_dual_mov_b32 v10, 0
	v_mov_b32_e32 v11, 0
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[26:29], v[13:16], v[0:7]
	s_and_saveexec_b32 s7, vcc_lo
	s_cbranch_execz .LBB0_91
	v_lshlrev_b64_e32 v[8:9], 1, v[20:21]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v8, s0, s22, v8
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v9, null, s23, v9, s0
	global_load_b128 v[8:11], v[8:9], off offset:163904
.LBB0_91:
	s_or_b32 exec_lo, exec_lo, s7
	global_load_b128 v[26:29], v[22:23], off offset:64
	v_dual_mov_b32 v12, 0 :: v_dual_mov_b32 v15, 0
	v_dual_mov_b32 v16, 0 :: v_dual_mov_b32 v17, 0
	v_mov_b32_e32 v18, 0
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[26:29], v[8:11], v[0:7]
	s_and_saveexec_b32 s7, vcc_lo
	s_cbranch_execz .LBB0_93
	v_lshlrev_b64_e32 v[8:9], 1, v[20:21]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v8, s0, s22, v8
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v9, null, s23, v9, s0
	global_load_b128 v[15:18], v[8:9], off offset:163936
.LBB0_93:
	s_or_b32 exec_lo, exec_lo, s7
	global_load_b128 v[8:11], v[22:23], off offset:96
	v_dual_mov_b32 v13, 0 :: v_dual_mov_b32 v14, 0
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[8:11], v[15:18], v[0:7]
	v_mov_b32_e32 v15, 0
	s_and_saveexec_b32 s7, vcc_lo
	s_cbranch_execz .LBB0_95
	v_lshlrev_b64_e32 v[8:9], 1, v[20:21]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v8, s0, s22, v8
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v9, null, s23, v9, s0
	global_load_b128 v[12:15], v[8:9], off offset:163968
.LBB0_95:
	s_or_b32 exec_lo, exec_lo, s7
	global_load_b128 v[26:29], v[22:23], off offset:128
	v_dual_mov_b32 v8, 0 :: v_dual_mov_b32 v17, 0
	v_dual_mov_b32 v16, 0 :: v_dual_mov_b32 v19, 0
	v_mov_b32_e32 v18, 0
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[26:29], v[12:15], v[0:7]
	s_and_saveexec_b32 s7, vcc_lo
	s_cbranch_execz .LBB0_97
	v_lshlrev_b64_e32 v[9:10], 1, v[20:21]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v9, s0, s22, v9
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v10, null, s23, v10, s0
	global_load_b128 v[16:19], v[9:10], off offset:164000
.LBB0_97:
	s_or_b32 exec_lo, exec_lo, s7
	global_load_b128 v[11:14], v[22:23], off offset:160
	v_dual_mov_b32 v9, 0 :: v_dual_mov_b32 v10, 0
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[11:14], v[16:19], v[0:7]
	v_mov_b32_e32 v11, 0
	s_and_saveexec_b32 s7, vcc_lo
	s_cbranch_execz .LBB0_99
	v_lshlrev_b64_e32 v[8:9], 1, v[20:21]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v8, s0, s22, v8
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v9, null, s23, v9, s0
	global_load_b128 v[8:11], v[8:9], off offset:164032
.LBB0_99:
	s_or_b32 exec_lo, exec_lo, s7
	global_load_b128 v[15:18], v[22:23], off offset:192
	v_dual_mov_b32 v12, 0 :: v_dual_mov_b32 v13, 0
	v_mov_b32_e32 v14, 0
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[15:18], v[8:11], v[0:7]
	v_mov_b32_e32 v15, 0
	s_and_saveexec_b32 s7, vcc_lo
	s_cbranch_execz .LBB0_84
	v_lshlrev_b64_e32 v[8:9], 1, v[20:21]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v8, s0, s22, v8
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v9, null, s23, v9, s0
	global_load_b128 v[12:15], v[8:9], off offset:164064
	s_branch .LBB0_84
.LBB0_101:
	s_and_saveexec_b32 s4, vcc_lo
	s_cbranch_execz .LBB0_82
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v8, v0, 16, 1
	v_or_b32_e32 v9, 0x400000, v0
	v_cmp_u_f32_e64 s0, v0, v0
	v_add3_u32 v8, v8, v0, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1)
	v_cndmask_b32_e64 v0, v8, v9, s0
	v_or_b32_e32 v8, s5, v32
	s_and_b32 s0, s1, exec_lo
	s_cselect_b32 s0, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s0, 1
	v_lshrrev_b32_e32 v10, 16, v0
	v_ashrrev_i32_e32 v9, 31, v8
	s_cbranch_scc1 .LBB0_104
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_3) | instid1(VALU_DEP_3)
	v_lshlrev_b64_e32 v[11:12], 1, v[8:9]
	v_mov_b16_e32 v0.l, 0
	v_lshlrev_b32_e32 v10, 16, v10
	s_wait_kmcnt 0x0
	v_add_co_u32 v11, s0, s2, v11
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v12, null, s3, v12, s0
	global_load_d16_hi_b16 v0, v[11:12], off
	s_wait_loadcnt 0x0
	v_add_f32_e32 v0, 1.0, v0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v11, v0, 16, 1
	v_or_b32_e32 v12, 0x400000, v0
	v_cmp_u_f32_e64 s0, v0, v0
	v_add3_u32 v11, v11, v0, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_cndmask_b32_e64 v0, v11, v12, s0
	v_and_b32_e32 v0, 0xffff0000, v0
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v0, v0, v10
	v_bfe_u32 v10, v0, 16, 1
	v_or_b32_e32 v11, 0x400000, v0
	v_cmp_u_f32_e64 s0, v0, v0
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v10, v10, v0, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v0, v10, v11, s0
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v10, 16, v0
.LBB0_104:
	v_bfe_u32 v0, v1, 16, 1
	v_add_nc_u32_e32 v11, v8, v33
	v_or_b32_e32 v13, 0x400000, v1
	v_cmp_u_f32_e64 s0, v1, v1
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_add3_u32 v0, v0, v1, 0x7fff
	v_ashrrev_i32_e32 v12, 31, v11
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cndmask_b32_e64 v13, v0, v13, s0
	v_lshlrev_b64_e32 v[0:1], 1, v[11:12]
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_lshrrev_b32_e32 v11, 16, v13
	v_add_co_u32 v0, s0, s18, v0
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_3)
	v_add_co_ci_u32_e64 v1, null, s19, v1, s0
	s_and_b32 s0, s1, exec_lo
	s_cselect_b32 s0, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s0, 1
	global_store_b16 v[0:1], v10, off
	s_cbranch_scc1 .LBB0_106
	v_lshlrev_b64_e32 v[12:13], 1, v[8:9]
	v_mov_b16_e32 v10.l, 0
	v_lshlrev_b32_e32 v11, 16, v11
	s_wait_kmcnt 0x0
	s_delay_alu instid0(VALU_DEP_3)
	v_add_co_u32 v12, s0, s2, v12
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v13, null, s3, v13, s0
	global_load_d16_hi_b16 v10, v[12:13], off offset:2
	s_wait_loadcnt 0x0
	v_add_f32_e32 v10, 1.0, v10
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v12, v10, 16, 1
	v_or_b32_e32 v13, 0x400000, v10
	v_cmp_u_f32_e64 s0, v10, v10
	v_add3_u32 v12, v12, v10, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_cndmask_b32_e64 v10, v12, v13, s0
	v_and_b32_e32 v10, 0xffff0000, v10
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v10, v10, v11
	v_bfe_u32 v11, v10, 16, 1
	v_or_b32_e32 v12, 0x400000, v10
	v_cmp_u_f32_e64 s0, v10, v10
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v11, v11, v10, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v10, v11, v12, s0
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v11, 16, v10
.LBB0_106:
	v_bfe_u32 v10, v2, 16, 1
	v_or_b32_e32 v12, 0x400000, v2
	v_cmp_u_f32_e64 s0, v2, v2
	global_store_b16 v[0:1], v11, off offset:2
	v_add3_u32 v10, v10, v2, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1)
	v_cndmask_b32_e64 v2, v10, v12, s0
	s_and_b32 s0, s1, exec_lo
	s_cselect_b32 s0, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s0, 1
	v_lshrrev_b32_e32 v2, 16, v2
	s_cbranch_scc1 .LBB0_108
	v_lshlrev_b64_e32 v[10:11], 1, v[8:9]
	v_mov_b16_e32 v12.l, 0
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_lshlrev_b32_e32 v2, 16, v2
	s_wait_kmcnt 0x0
	v_add_co_u32 v10, s0, s2, v10
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v11, null, s3, v11, s0
	global_load_d16_hi_b16 v12, v[10:11], off offset:4
	s_wait_loadcnt 0x0
	v_add_f32_e32 v10, 1.0, v12
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v11, v10, 16, 1
	v_or_b32_e32 v12, 0x400000, v10
	v_cmp_u_f32_e64 s0, v10, v10
	v_add3_u32 v11, v11, v10, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_cndmask_b32_e64 v10, v11, v12, s0
	v_and_b32_e32 v10, 0xffff0000, v10
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v2, v10, v2
	v_bfe_u32 v10, v2, 16, 1
	v_or_b32_e32 v11, 0x400000, v2
	v_cmp_u_f32_e64 s0, v2, v2
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v10, v10, v2, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v2, v10, v11, s0
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v2, 16, v2
.LBB0_108:
	v_bfe_u32 v10, v3, 16, 1
	v_or_b32_e32 v11, 0x400000, v3
	v_cmp_u_f32_e64 s0, v3, v3
	global_store_b16 v[0:1], v2, off offset:4
	v_add3_u32 v10, v10, v3, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1)
	v_cndmask_b32_e64 v3, v10, v11, s0
	s_and_b32 s0, s1, exec_lo
	s_cselect_b32 s0, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s0, 1
	v_lshrrev_b32_e32 v3, 16, v3
	s_cbranch_scc1 .LBB0_110
	v_lshlrev_b64_e32 v[10:11], 1, v[8:9]
	v_mov_b16_e32 v2.l, 0
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_lshlrev_b32_e32 v3, 16, v3
	s_wait_kmcnt 0x0
	v_add_co_u32 v10, s0, s2, v10
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v11, null, s3, v11, s0
	global_load_d16_hi_b16 v2, v[10:11], off offset:6
	s_wait_loadcnt 0x0
	v_add_f32_e32 v2, 1.0, v2
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v10, v2, 16, 1
	v_or_b32_e32 v11, 0x400000, v2
	v_cmp_u_f32_e64 s0, v2, v2
	v_add3_u32 v10, v10, v2, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_cndmask_b32_e64 v2, v10, v11, s0
	v_and_b32_e32 v2, 0xffff0000, v2
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v2, v2, v3
	v_bfe_u32 v3, v2, 16, 1
	v_or_b32_e32 v10, 0x400000, v2
	v_cmp_u_f32_e64 s0, v2, v2
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v3, v3, v2, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v2, v3, v10, s0
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v3, 16, v2
.LBB0_110:
	v_bfe_u32 v2, v4, 16, 1
	v_or_b32_e32 v10, 0x400000, v4
	v_cmp_u_f32_e64 s0, v4, v4
	global_store_b16 v[0:1], v3, off offset:6
	v_add3_u32 v2, v2, v4, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1)
	v_cndmask_b32_e64 v2, v2, v10, s0
	s_and_b32 s0, s1, exec_lo
	s_cselect_b32 s0, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s0, 1
	v_lshrrev_b32_e32 v2, 16, v2
	s_cbranch_scc1 .LBB0_112
	v_lshlrev_b64_e32 v[3:4], 1, v[8:9]
	v_mov_b16_e32 v10.l, 0
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_lshlrev_b32_e32 v2, 16, v2
	s_wait_kmcnt 0x0
	v_add_co_u32 v3, s0, s2, v3
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v4, null, s3, v4, s0
	global_load_d16_hi_b16 v10, v[3:4], off offset:8
	s_wait_loadcnt 0x0
	v_add_f32_e32 v3, 1.0, v10
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v4, v3, 16, 1
	v_or_b32_e32 v10, 0x400000, v3
	v_cmp_u_f32_e64 s0, v3, v3
	v_add3_u32 v4, v4, v3, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_cndmask_b32_e64 v3, v4, v10, s0
	v_and_b32_e32 v3, 0xffff0000, v3
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v2, v3, v2
	v_bfe_u32 v3, v2, 16, 1
	v_or_b32_e32 v4, 0x400000, v2
	v_cmp_u_f32_e64 s0, v2, v2
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v3, v3, v2, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v2, v3, v4, s0
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v2, 16, v2
.LBB0_112:
	v_bfe_u32 v3, v5, 16, 1
	v_or_b32_e32 v4, 0x400000, v5
	v_cmp_u_f32_e64 s0, v5, v5
	global_store_b16 v[0:1], v2, off offset:8
	v_add3_u32 v3, v3, v5, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1)
	v_cndmask_b32_e64 v3, v3, v4, s0
	s_and_b32 s0, s1, exec_lo
	s_cselect_b32 s0, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s0, 1
	v_lshrrev_b32_e32 v3, 16, v3
	s_cbranch_scc1 .LBB0_114
	v_lshlrev_b64_e32 v[4:5], 1, v[8:9]
	v_mov_b16_e32 v2.l, 0
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_lshlrev_b32_e32 v3, 16, v3
	s_wait_kmcnt 0x0
	v_add_co_u32 v4, s0, s2, v4
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v5, null, s3, v5, s0
	global_load_d16_hi_b16 v2, v[4:5], off offset:10
	s_wait_loadcnt 0x0
	v_add_f32_e32 v2, 1.0, v2
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v4, v2, 16, 1
	v_or_b32_e32 v5, 0x400000, v2
	v_cmp_u_f32_e64 s0, v2, v2
	v_add3_u32 v4, v4, v2, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_cndmask_b32_e64 v2, v4, v5, s0
	v_and_b32_e32 v2, 0xffff0000, v2
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v2, v2, v3
	v_bfe_u32 v3, v2, 16, 1
	v_or_b32_e32 v4, 0x400000, v2
	v_cmp_u_f32_e64 s0, v2, v2
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v3, v3, v2, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v2, v3, v4, s0
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v3, 16, v2
.LBB0_114:
	v_bfe_u32 v2, v6, 16, 1
	v_or_b32_e32 v4, 0x400000, v6
	v_cmp_u_f32_e64 s0, v6, v6
	global_store_b16 v[0:1], v3, off offset:10
	v_add3_u32 v2, v2, v6, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1)
	v_cndmask_b32_e64 v2, v2, v4, s0
	s_and_b32 s0, s1, exec_lo
	s_cselect_b32 s0, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s0, 1
	v_lshrrev_b32_e32 v2, 16, v2
	s_cbranch_scc1 .LBB0_116
	v_lshlrev_b64_e32 v[3:4], 1, v[8:9]
	v_mov_b16_e32 v5.l, 0
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_lshlrev_b32_e32 v2, 16, v2
	s_wait_kmcnt 0x0
	v_add_co_u32 v3, s0, s2, v3
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v4, null, s3, v4, s0
	global_load_d16_hi_b16 v5, v[3:4], off offset:12
	s_wait_loadcnt 0x0
	v_add_f32_e32 v3, 1.0, v5
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v4, v3, 16, 1
	v_or_b32_e32 v5, 0x400000, v3
	v_cmp_u_f32_e64 s0, v3, v3
	v_add3_u32 v4, v4, v3, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_cndmask_b32_e64 v3, v4, v5, s0
	v_and_b32_e32 v3, 0xffff0000, v3
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v2, v3, v2
	v_bfe_u32 v3, v2, 16, 1
	v_or_b32_e32 v4, 0x400000, v2
	v_cmp_u_f32_e64 s0, v2, v2
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v3, v3, v2, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v2, v3, v4, s0
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v2, 16, v2
.LBB0_116:
	v_bfe_u32 v3, v7, 16, 1
	v_or_b32_e32 v4, 0x400000, v7
	v_cmp_u_f32_e64 s0, v7, v7
	global_store_b16 v[0:1], v2, off offset:12
	v_add3_u32 v3, v3, v7, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1)
	v_cndmask_b32_e64 v3, v3, v4, s0
	s_and_b32 s0, s1, exec_lo
	s_cselect_b32 s0, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s0, 1
	v_lshrrev_b32_e32 v3, 16, v3
	s_cbranch_scc1 .LBB0_81
	v_lshlrev_b64_e32 v[4:5], 1, v[8:9]
	v_mov_b16_e32 v2.l, 0
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_lshlrev_b32_e32 v3, 16, v3
	s_wait_kmcnt 0x0
	v_add_co_u32 v4, s0, s2, v4
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v5, null, s3, v5, s0
	global_load_d16_hi_b16 v2, v[4:5], off offset:14
	s_wait_loadcnt 0x0
	v_add_f32_e32 v2, 1.0, v2
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v4, v2, 16, 1
	v_or_b32_e32 v5, 0x400000, v2
	v_cmp_u_f32_e64 s0, v2, v2
	v_add3_u32 v4, v4, v2, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_cndmask_b32_e64 v2, v4, v5, s0
	v_and_b32_e32 v2, 0xffff0000, v2
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v2, v2, v3
	v_bfe_u32 v3, v2, 16, 1
	v_or_b32_e32 v4, 0x400000, v2
	v_cmp_u_f32_e64 s0, v2, v2
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v3, v3, v2, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v2, v3, v4, s0
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v3, 16, v2
	s_branch .LBB0_81
.LBB0_118:
	s_endpgm
.Lfunc_end0:
	.size	qwen_bf16_ffnar_v1_h5120_i17408_b64_tp1r0_a0_f0, .Lfunc_end0-qwen_bf16_ffnar_v1_h5120_i17408_b64_tp1r0_a0_f0
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel qwen_bf16_ffnar_v1_h5120_i17408_b64_tp1r0_a0_f0
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
		.amdhsa_next_free_vgpr 45
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
		.amdhsa_inst_pref_size ((instprefsize(.Lfunc_end0-qwen_bf16_ffnar_v1_h5120_i17408_b64_tp1r0_a0_f0)<<4)&4080)>>4
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

	.set .Lqwen_bf16_ffnar_v1_h5120_i17408_b64_tp1r0_a0_f0.num_vgpr, 45
	.set .Lqwen_bf16_ffnar_v1_h5120_i17408_b64_tp1r0_a0_f0.num_agpr, 0
	.set .Lqwen_bf16_ffnar_v1_h5120_i17408_b64_tp1r0_a0_f0.numbered_sgpr, 44
	.set .Lqwen_bf16_ffnar_v1_h5120_i17408_b64_tp1r0_a0_f0.num_named_barrier, 0
	.set .Lqwen_bf16_ffnar_v1_h5120_i17408_b64_tp1r0_a0_f0.private_seg_size, 0
	.set .Lqwen_bf16_ffnar_v1_h5120_i17408_b64_tp1r0_a0_f0.uses_vcc, 1
	.set .Lqwen_bf16_ffnar_v1_h5120_i17408_b64_tp1r0_a0_f0.uses_flat_scratch, 0
	.set .Lqwen_bf16_ffnar_v1_h5120_i17408_b64_tp1r0_a0_f0.has_dyn_sized_stack, 0
	.set .Lqwen_bf16_ffnar_v1_h5120_i17408_b64_tp1r0_a0_f0.has_recursion, 0
	.set .Lqwen_bf16_ffnar_v1_h5120_i17408_b64_tp1r0_a0_f0.has_indirect_call, 0
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
    .name:           qwen_bf16_ffnar_v1_h5120_i17408_b64_tp1r0_a0_f0
    .private_segment_fixed_size: 0
    .reqd_workgroup_size:
      - 128
      - 1
      - 1
    .sgpr_count:     46
    .sgpr_spill_count: 0
    .symbol:         qwen_bf16_ffnar_v1_h5120_i17408_b64_tp1r0_a0_f0.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     45
    .vgpr_spill_count: 0
    .wavefront_size: 32
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1201
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
