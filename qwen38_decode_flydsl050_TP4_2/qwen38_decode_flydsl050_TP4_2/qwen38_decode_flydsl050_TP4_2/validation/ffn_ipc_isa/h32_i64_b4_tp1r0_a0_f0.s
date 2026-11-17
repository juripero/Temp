	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1201"
	.amdhsa_code_object_version 6
	.text
	.globl	qwen_bf16_ffnar_v1_h32_i64_b4_tp1r0_a0_f0
	.p2align	8
	.type	qwen_bf16_ffnar_v1_h32_i64_b4_tp1r0_a0_f0,@function
qwen_bf16_ffnar_v1_h32_i64_b4_tp1r0_a0_f0:
	s_load_b128 s[24:27], s[0:1], 0x70
	s_wait_kmcnt 0x0
	s_cmp_lt_i32 s24, 1
	s_cbranch_scc1 .LBB0_88
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
	s_cbranch_vccnz .LBB0_88
	s_load_b512 s[8:23], s[0:1], 0x0
	v_lshrrev_b32_e32 v1, 5, v0
	s_cmp_ge_i32 ttmp9, s24
	s_delay_alu instid0(VALU_DEP_1)
	v_readfirstlane_b32 s27, v1
	s_cbranch_scc1 .LBB0_19
	v_and_b32_e32 v1, 31, v0
	s_load_b64 s[34:35], s[0:1], 0x58
	s_wait_kmcnt 0x0
	s_cmp_lg_u32 s6, 0
	v_cmp_gt_u32_e64 s3, 32, v0
	s_mov_b32 s5, ttmp9
	v_dual_mov_b32 v13, 0 :: v_dual_lshlrev_b32 v2, 2, v1
	v_cmp_gt_u32_e32 vcc_lo, 24, v1
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_2) | instid1(VALU_DEP_2)
	v_add_nc_u32_e32 v4, 16, v2
	v_add_nc_u32_e32 v3, 32, v2
	v_add_nc_u32_e32 v5, 8, v2
	v_cndmask_b32_e32 v9, v2, v3, vcc_lo
	v_cmp_gt_u32_e32 vcc_lo, 28, v1
	v_lshlrev_b32_e32 v3, 1, v0
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v10, v2, v4, vcc_lo
	v_cmp_gt_u32_e32 vcc_lo, 30, v1
	s_wait_alu depctr_va_vcc(0)
	v_dual_cndmask_b32 v11, v2, v5 :: v_dual_add_nc_u32 v6, 4, v2
	v_cmp_ne_u32_e32 vcc_lo, 31, v1
	v_lshl_add_u32 v5, ttmp9, 5, v0
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_2) | instid1(VALU_DEP_1)
	v_cndmask_b32_e32 v12, 0x7c, v6, vcc_lo
	v_cmp_eq_u32_e64 s4, 0, v1
	v_add_co_u32 v1, s6, s34, v3
	v_add_co_ci_u32_e64 v2, null, s35, 0, s6
	v_add_co_u32 v3, s6, s12, v3
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v4, null, s13, 0, s6
	s_cselect_b32 s6, -1, 0
	s_lshl_b32 s12, s27, 2
	s_branch .LBB0_8
.LBB0_6:
	v_add_co_u32 v15, vcc_lo, s10, v6
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v16, null, s11, v7, vcc_lo
	v_add_co_u32 v6, vcc_lo, s22, v6
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v7, null, s23, v7, vcc_lo
	global_load_u16 v15, v[15:16], off
	global_load_u16 v16, v[3:4], off
	s_wait_loadcnt 0x1
	v_lshlrev_b32_e32 v15, 16, v15
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v16, 16, v16
	v_lshlrev_b32_e32 v14, 16, v14
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_dual_add_f32 v14, v14, v15 :: v_dual_add_f32 v15, 1.0, v16
	s_wait_dscnt 0x0
	v_mul_f32_e32 v8, v8, v14
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v8, v8, v15
	v_bfe_u32 v14, v8, 16, 1
	v_or_b32_e32 v15, 0x400000, v8
	v_cmp_u_f32_e32 vcc_lo, v8, v8
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v14, v14, v8, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v8, v14, v15, vcc_lo
	global_store_d16_hi_b16 v[6:7], v8, off
.LBB0_7:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s13
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	s_barrier_signal -1
	v_add_nc_u32_e32 v5, 0x80, v5
	s_add_co_i32 s5, s5, 4
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s5, s24
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_cbranch_scc0 .LBB0_19
.LBB0_8:
	v_ashrrev_i32_e32 v6, 31, v5
	v_mov_b32_e32 v7, 0
	s_and_saveexec_b32 s13, s3
	s_cbranch_execz .LBB0_12
	s_delay_alu instid0(VALU_DEP_2)
	v_lshlrev_b64_e32 v[7:8], 1, v[5:6]
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s33, s6, exec_lo
	s_cselect_b32 s33, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s33, 1
	v_add_co_u32 v14, vcc_lo, s8, v7
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v15, null, s9, v8, vcc_lo
	global_load_d16_b16 v14, v[14:15], off
	s_cbranch_scc1 .LBB0_11
	v_mov_b16_e32 v15.l, 0
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v14, 16, v14
	global_load_d16_hi_b16 v15, v[1:2], off
	s_wait_loadcnt 0x0
	v_add_f32_e32 v15, 1.0, v15
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v16, v15, 16, 1
	v_or_b32_e32 v17, 0x400000, v15
	v_cmp_u_f32_e32 vcc_lo, v15, v15
	v_add3_u32 v16, v16, v15, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_cndmask_b32_e32 v15, v16, v17, vcc_lo
	v_and_b32_e32 v15, 0xffff0000, v15
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v14, v14, v15
	v_bfe_u32 v15, v14, 16, 1
	v_or_b32_e32 v16, 0x400000, v14
	v_cmp_u_f32_e32 vcc_lo, v14, v14
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v15, v15, v14, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v14, v15, v16, vcc_lo
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v14, 16, v14
.LBB0_11:
	v_add_co_u32 v15, vcc_lo, s10, v7
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v16, null, s11, v8, vcc_lo
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v14, 16, v14
	global_load_u16 v15, v[15:16], off
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v15, 16, v15
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v16, v14, v15
	v_bfe_u32 v14, v16, 16, 1
	v_or_b32_e32 v17, 0x400000, v16
	s_delay_alu instid0(VALU_DEP_2)
	v_add3_u32 v18, v14, v16, 0x7fff
	v_add_co_u32 v14, vcc_lo, s20, v7
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v15, null, s21, v8, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v16, v16
	s_wait_alu depctr_va_vcc(0)
	v_dual_mul_f32 v7, v16, v16 :: v_dual_cndmask_b32 v8, v18, v17
	global_store_d16_hi_b16 v[14:15], v8, off
.LBB0_12:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s13
	ds_swizzle_b32 v8, v7 offset:swizzle(BITMASK_PERM,"1pppp")
	s_wait_dscnt 0x0
	v_add_f32_e32 v7, v7, v8
	ds_bpermute_b32 v8, v9, v7
	s_wait_dscnt 0x0
	v_add_f32_e32 v7, v7, v8
	ds_bpermute_b32 v8, v10, v7
	s_wait_dscnt 0x0
	v_add_f32_e32 v7, v7, v8
	ds_bpermute_b32 v8, v11, v7
	s_wait_dscnt 0x0
	v_add_f32_e32 v7, v7, v8
	ds_bpermute_b32 v8, v12, v7
	s_and_saveexec_b32 s13, s4
	s_cbranch_execz .LBB0_14
	s_wait_dscnt 0x0
	v_dual_add_f32 v7, v7, v8 :: v_dual_mov_b32 v8, s12
	ds_store_b32 v8, v7
.LBB0_14:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s13
	s_wait_storecnt 0x0
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s13, s2
	s_cbranch_execz .LBB0_16
	ds_load_b128 v[14:17], v13
	s_wait_dscnt 0x0
	v_readfirstlane_b32 s33, v14
	v_readfirstlane_b32 s34, v15
	v_readfirstlane_b32 s35, v16
	s_add_f32 s33, s33, 0
	s_wait_alu depctr_sa_sdst(0)
	s_delay_alu instid0(SALU_CYCLE_2) | instskip(SKIP_2) | instid1(SALU_CYCLE_1)
	s_add_f32 s33, s33, s34
	v_readfirstlane_b32 s34, v17
	s_wait_alu depctr_sa_sdst(0)
	s_add_f32 s33, s33, s35
	s_wait_alu depctr_sa_sdst(0)
	s_delay_alu instid0(SALU_CYCLE_2) | instskip(SKIP_1) | instid1(SALU_CYCLE_2)
	s_add_f32 s33, s33, s34
	s_wait_alu depctr_sa_sdst(0)
	s_mul_f32 s33, s33, 0x3d000000
	s_wait_alu depctr_sa_sdst(0)
	s_delay_alu instid0(SALU_CYCLE_2) | instskip(SKIP_1) | instid1(SALU_CYCLE_2)
	s_add_f32 s33, s25, s33
	s_wait_alu depctr_sa_sdst(0)
	s_mul_f32 s34, s33, 0x4f800000
	s_cmp_lt_f32 s33, 0xf800000
	s_wait_alu depctr_sa_sdst(0)
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_3) | instid1(TRANS32_DEP_1)
	s_cselect_b32 s34, s34, s33
	s_wait_alu depctr_sa_sdst(0)
	v_s_sqrt_f32 s35, s34
	s_mov_b32 s37, s34
	s_add_co_i32 s36, s35, -1
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_xor_b32 s38, s36, 0x80000000
	s_fmac_f32 s37, s38, s35
	s_mov_b32 s38, s34
	s_delay_alu instid0(SALU_CYCLE_2) | instskip(SKIP_2) | instid1(SALU_CYCLE_1)
	s_cmp_le_f32 s37, 0
	s_cselect_b32 s36, s36, s35
	s_add_co_i32 s37, s35, 1
	s_xor_b32 s39, s37, 0x80000000
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_2)
	s_fmac_f32 s38, s39, s35
	v_cmp_class_f32_e64 s35, s34, 0x260
	s_cmp_gt_f32 s38, 0
	s_cselect_b32 s36, s37, s36
	s_cmp_lt_f32 s33, 0xf800000
	s_mul_f32 s33, s36, 0x37800000
	s_wait_alu depctr_sa_sdst(0)
	s_delay_alu instid0(SALU_CYCLE_2)
	s_cselect_b32 s33, s33, s36
	s_and_b32 s35, s35, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	s_cselect_b32 s33, s34, s33
	s_wait_alu depctr_sa_sdst(0)
	v_div_scale_f32 v7, null, s33, s33, 1.0
	s_delay_alu instid0(VALU_DEP_1)
	v_rcp_f32_e32 v8, v7
	v_xor_b32_e32 v7, 0x80000000, v7
	s_delay_alu instid0(TRANS32_DEP_1) | instid1(VALU_DEP_1)
	v_fma_f32 v14, v7, v8, 1.0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_fmac_f32_e32 v8, v14, v8
	v_div_scale_f32 v14, vcc_lo, 1.0, s33, 1.0
	v_mul_f32_e32 v15, v14, v8
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fma_f32 v16, v7, v15, v14
	v_fmac_f32_e32 v15, v16, v8
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_fmac_f32_e32 v14, v7, v15
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v7, v14, v8, v15
	s_delay_alu instid0(VALU_DEP_1)
	v_div_fixup_f32 v7, v7, s33, 1.0
	ds_store_b32 v13, v7 offset:16
.LBB0_16:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s13
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s13, s3
	s_cbranch_execz .LBB0_7
	v_lshlrev_b64_e32 v[6:7], 1, v[5:6]
	ds_load_b32 v8, v13 offset:16
	s_and_b32 s33, s6, exec_lo
	s_cselect_b32 s33, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s33, 1
	v_add_co_u32 v14, vcc_lo, s8, v6
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v15, null, s9, v7, vcc_lo
	global_load_d16_b16 v14, v[14:15], off
	s_cbranch_scc1 .LBB0_6
	v_mov_b16_e32 v15.l, 0
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v14, 16, v14
	global_load_d16_hi_b16 v15, v[1:2], off
	s_wait_loadcnt 0x0
	v_add_f32_e32 v15, 1.0, v15
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v16, v15, 16, 1
	v_or_b32_e32 v17, 0x400000, v15
	v_cmp_u_f32_e32 vcc_lo, v15, v15
	v_add3_u32 v16, v16, v15, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_cndmask_b32_e32 v15, v16, v17, vcc_lo
	v_and_b32_e32 v15, 0xffff0000, v15
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v14, v14, v15
	v_bfe_u32 v15, v14, 16, 1
	v_or_b32_e32 v16, 0x400000, v14
	v_cmp_u_f32_e32 vcc_lo, v14, v14
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v15, v15, v14, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v14, v15, v16, vcc_lo
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v14, 16, v14
	s_branch .LBB0_6
.LBB0_19:
	s_wait_loadcnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s4, s2
	s_cbranch_execz .LBB0_30
	v_mov_b32_e32 v2, 0
	s_mov_b32 s3, exec_lo
	s_mov_b32 s5, exec_lo
	v_mbcnt_lo_u32_b32 v1, s3, 0
	s_wait_kmcnt 0x0
	global_load_b32 v3, v2, s[28:29] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_22
	s_bcnt1_i32_b32 s3, s3
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v4, s3
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v4, v2, v4, s[28:29] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_22:
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
	s_cbranch_execz .LBB0_27
	s_cmp_lt_i32 s26, 1
	s_mov_b32 s6, 1
	s_cbranch_scc1 .LBB0_48
	v_mov_b32_e32 v1, 0
.LBB0_25:
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
	s_cmp_lt_i32 s6, s26
	s_cselect_b32 s8, -1, 0
	s_add_co_i32 s6, s6, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s8, s3, s8
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s8
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_25
	s_and_b32 vcc_lo, exec_lo, s3
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_49
.LBB0_27:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s3, s5
	s_cbranch_execz .LBB0_29
.LBB0_28:
	v_dual_mov_b32 v1, 0 :: v_dual_add_nc_u32 v2, 1, v3
	global_store_b32 v1, v1, s[28:29] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v1, v2, s[28:29] offset:4 scope:SCOPE_DEV
.LBB0_29:
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
.LBB0_30:
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
	s_cbranch_vccnz .LBB0_88
	v_lshrrev_b32_e32 v1, 1, v0
	v_and_b32_e32 v29, 15, v0
	s_wait_kmcnt 0x0
	s_lshl_b32 s6, ttmp9, 2
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s8, s6, s27
	v_and_b32_e32 v28, 8, v1
	v_cmp_gt_i32_e64 s3, s24, v29
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_gt_i32 s8, 3
	s_cbranch_scc1 .LBB0_40
	v_lshl_or_b32 v30, v29, 5, v28
	v_lshlrev_b32_e32 v31, 6, v29
	s_mov_b32 s9, s8
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshlrev_b32_e32 v0, 1, v30
	v_add_co_u32 v24, s4, s22, v0
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v25, null, s23, 0, s4
	s_branch .LBB0_34
.LBB0_33:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s10
	s_add_co_i32 s4, s9, 16
	s_cmp_lt_i32 s9, -12
	s_wait_alu depctr_sa_sdst(0)
	s_mov_b32 s9, s4
	s_cbranch_scc0 .LBB0_40
.LBB0_34:
	v_dual_mov_b32 v16, 0 :: v_dual_mov_b32 v17, 0
	v_dual_mov_b32 v18, 0 :: v_dual_mov_b32 v19, 0
	s_and_saveexec_b32 s4, s3
	s_cbranch_execz .LBB0_36
	global_load_b128 v[16:19], v[24:25], off
.LBB0_36:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	v_lshl_or_b32 v0, s9, 9, v30
	v_dual_mov_b32 v20, 0 :: v_dual_mov_b32 v21, 0
	v_dual_mov_b32 v22, 0 :: v_dual_mov_b32 v23, 0
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v1, 31, v0
	v_lshlrev_b64_e32 v[0:1], 1, v[0:1]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v26, vcc_lo, s14, v0
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v27, null, s15, v1, vcc_lo
	s_clause 0x1
	global_load_b128 v[0:3], v[26:27], off
	global_load_b128 v[32:35], v[26:27], off offset:4096
	s_wait_loadcnt 0x1
	v_wmma_f32_16x16x16_bf16 v[8:15], v[0:3], v[16:19], 0
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[32:35], v[16:19], 0
	s_and_saveexec_b32 s4, s3
	s_cbranch_execz .LBB0_38
	global_load_b128 v[20:23], v[24:25], off offset:32
.LBB0_38:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	s_clause 0x1
	global_load_b128 v[16:19], v[26:27], off offset:32
	global_load_b128 v[32:35], v[26:27], off offset:4128
	s_wait_loadcnt 0x1
	v_wmma_f32_16x16x16_bf16 v[8:15], v[16:19], v[20:23], v[8:15]
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[32:35], v[20:23], v[0:7]
	s_and_saveexec_b32 s10, s3
	s_cbranch_execz .LBB0_33
	v_bfe_u32 v16, v8, 16, 1
	v_or_b32_e32 v17, 0x400000, v8
	v_bfe_u32 v18, v9, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v8, v8
	v_or_b32_e32 v19, 0x400000, v9
	v_add3_u32 v16, v16, v8, 0x7fff
	v_bfe_u32 v22, v10, 16, 1
	v_add3_u32 v18, v18, v9, 0x7fff
	v_or_b32_e32 v23, 0x400000, v10
	v_bfe_u32 v32, v11, 16, 1
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v8, v16, v17, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v9, v9
	v_add3_u32 v22, v22, v10, 0x7fff
	v_or_b32_e32 v33, 0x400000, v11
	v_add3_u32 v32, v32, v11, 0x7fff
	v_bfe_u32 v16, v0, 16, 1
	s_wait_alu depctr_va_vcc(0)
	v_dual_cndmask_b32 v9, v18, v19 :: v_dual_and_b32 v20, 0xffff0000, v8
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	v_lshl_or_b32 v8, s9, 4, v28
	v_or_b32_e32 v17, 0x400000, v0
	s_delay_alu instid0(VALU_DEP_4)
	v_and_b32_e32 v26, 0xffff0000, v9
	v_add3_u32 v16, v16, v0, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v10, v22, v23, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	v_mul_f32_e32 v18, 0xbfb8aa3b, v20
	v_bfe_u32 v21, v1, 16, 1
	v_or_b32_e32 v19, 0x400000, v1
	v_cmp_u_f32_e64 s4, v1, v1
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v11, v32, v33, vcc_lo
	v_fma_f32 v9, 0xbfb8aa3b, v20, -v18
	v_rndne_f32_e32 v27, v18
	v_add3_u32 v21, v21, v1, 0x7fff
	v_bfe_u32 v35, v12, 16, 1
	v_or_b32_e32 v36, 0x400000, v12
	s_delay_alu instid0(VALU_DEP_4)
	v_dual_fmac_f32 v9, 0xb2a5705f, v20 :: v_dual_sub_f32 v18, v18, v27
	v_cvt_i32_f32_e32 v27, v27
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v19, v21, v19, s4
	v_add3_u32 v35, v35, v12, 0x7fff
	v_and_b32_e32 v11, 0xffff0000, v11
	v_add_f32_e32 v9, v18, v9
	v_cmp_nlt_f32_e32 vcc_lo, 0x42ce8ed0, v20
	v_and_b32_e32 v19, 0xffff0000, v19
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(TRANS32_DEP_1)
	v_exp_f32_e32 v9, v9
	v_ldexp_f32 v9, v9, v27
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_dual_mul_f32 v34, 0xbfb8aa3b, v26 :: v_dual_cndmask_b32 v9, 0, v9
	v_fma_f32 v37, 0xbfb8aa3b, v26, -v34
	v_rndne_f32_e32 v18, v34
	v_add_nc_u32_e32 v8, v8, v31
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2b17218, v20
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_fmac_f32_e32 v37, 0xb2a5705f, v26
	v_sub_f32_e32 v34, v34, v18
	v_cvt_i32_f32_e32 v18, v18
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v9, 0x7f800000, v9, vcc_lo
	v_and_b32_e32 v10, 0xffff0000, v10
	v_cmp_u_f32_e32 vcc_lo, v0, v0
	v_add_f32_e32 v34, v34, v37
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_dual_cndmask_b32 v0, v16, v17 :: v_dual_mul_f32 v17, 0xbfb8aa3b, v10
	v_exp_f32_e32 v22, v34
	v_cmp_nlt_f32_e32 vcc_lo, 0x42ce8ed0, v26
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(TRANS32_DEP_1)
	v_rndne_f32_e32 v27, v17
	v_ldexp_f32 v16, v22, v18
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_1)
	v_dual_add_f32 v18, 1.0, v9 :: v_dual_cndmask_b32 v9, 0, v16
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2b17218, v26
	v_fma_f32 v16, 0xbfb8aa3b, v10, -v17
	v_sub_f32_e32 v17, v17, v27
	v_cvt_i32_f32_e32 v27, v27
	v_cmp_nlt_f32_e64 s4, 0x42ce8ed0, v10
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v9, 0x7f800000, v9, vcc_lo
	v_div_scale_f32 v23, null, v18, v18, v20
	v_div_scale_f32 v39, vcc_lo, v20, v18, v20
	v_cmp_ngt_f32_e64 s5, 0xc2b17218, v10
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_add_f32_e32 v34, 1.0, v9
	v_rcp_f32_e32 v32, v23
	v_ashrrev_i32_e32 v9, 31, v8
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fma_f32 v38, -v23, v32, 1.0
	v_fmac_f32_e32 v32, v38, v32
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_dual_mul_f32 v22, 0xbfb8aa3b, v11 :: v_dual_mul_f32 v21, v39, v32
	v_fmac_f32_e32 v16, 0xb2a5705f, v10
	v_fma_f32 v33, 0xbfb8aa3b, v11, -v22
	v_rndne_f32_e32 v37, v22
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_dual_add_f32 v16, v17, v16 :: v_dual_fmac_f32 v33, 0xb2a5705f, v11
	v_sub_f32_e32 v22, v22, v37
	v_cvt_i32_f32_e32 v37, v37
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_exp_f32_e32 v16, v16
	v_dual_add_f32 v22, v22, v33 :: v_dual_and_b32 v33, 0xffff0000, v0
	v_div_scale_f32 v17, null, v34, v34, v26
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(TRANS32_DEP_2)
	v_rcp_f32_e32 v40, v17
	v_ldexp_f32 v0, v16, v27
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_2) | instid1(VALU_DEP_2)
	v_exp_f32_e32 v16, v22
	v_fma_f32 v22, -v23, v21, v39
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v0, 0, v0, s4
	v_div_scale_f32 v27, s4, v26, v34, v26
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(TRANS32_DEP_2)
	v_fmac_f32_e32 v21, v22, v32
	v_fma_f32 v1, -v17, v40, 1.0
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_cndmask_b32_e64 v22, 0x7f800000, v0, s5
	v_cmp_u_f32_e64 s5, v6, v6
	v_fmac_f32_e32 v40, v1, v40
	v_lshlrev_b64_e32 v[0:1], 1, v[8:9]
	v_ldexp_f32 v9, v16, v37
	v_fma_f32 v16, -v23, v21, v39
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_div_fmas_f32 v16, v16, v32, v21
	v_cmp_nlt_f32_e32 vcc_lo, 0x42ce8ed0, v11
	v_div_fixup_f32 v16, v16, v18, v20
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v9, 0, v9, vcc_lo
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2b17218, v11
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_mul_f32_e32 v16, v16, v33
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v9, 0x7f800000, v9, vcc_lo
	s_mov_b32 vcc_lo, s4
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_bfe_u32 v20, v16, 16, 1
	v_cmp_u_f32_e64 s4, v16, v16
	v_dual_add_f32 v9, 1.0, v9 :: v_dual_mul_f32 v38, v27, v40
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_add3_u32 v20, v20, v16, 0x7fff
	v_fma_f32 v23, -v17, v38, v27
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fmac_f32_e32 v38, v23, v40
	v_fma_f32 v17, -v17, v38, v27
	s_wait_alu depctr_sa_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_div_fmas_f32 v17, v17, v40, v38
	v_div_fixup_f32 v17, v17, v34, v26
	v_or_b32_e32 v26, 0x400000, v16
	v_or_b32_e32 v34, 0x400000, v2
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_mul_f32_e32 v17, v17, v19
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v16, v20, v26, s4
	v_add_co_u32 v0, s4, s22, v0
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v1, null, s23, v1, s4
	v_cmp_u_f32_e64 s4, v12, v12
	v_div_scale_f32 v19, null, v9, v9, v11
	v_bfe_u32 v26, v2, 16, 1
	v_lshrrev_b32_e32 v16, 16, v16
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v12, v35, v36, s4
	v_rcp_f32_e32 v33, v19
	v_add3_u32 v26, v26, v2, 0x7fff
	v_cmp_u_f32_e64 s4, v2, v2
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_and_b32_e32 v12, 0xffff0000, v12
	v_add_f32_e32 v22, 1.0, v22
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v2, v26, v34, s4
	v_cmp_u_f32_e64 s4, v17, v17
	v_mul_f32_e32 v35, 0xbfb8aa3b, v12
	v_div_scale_f32 v21, null, v22, v22, v10
	v_div_scale_f32 v27, vcc_lo, v10, v22, v10
	v_fma_f32 v26, -v19, v33, 1.0
	v_and_b32_e32 v2, 0xffff0000, v2
	v_rndne_f32_e32 v34, v35
	v_rcp_f32_e32 v18, v21
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_fmac_f32_e32 v33, v26, v33
	v_cvt_i32_f32_e32 v26, v34
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fma_f32 v23, -v21, v18, 1.0
	v_fmac_f32_e32 v18, v23, v18
	v_bfe_u32 v23, v17, 16, 1
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_mul_f32_e32 v20, v27, v18
	v_add3_u32 v23, v23, v17, 0x7fff
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fma_f32 v32, -v21, v20, v27
	v_fmac_f32_e32 v20, v32, v18
	v_or_b32_e32 v32, 0x400000, v17
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_fma_f32 v21, -v21, v20, v27
	v_fma_f32 v27, 0xbfb8aa3b, v12, -v35
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v17, v23, v32, s4
	v_cmp_u_f32_e64 s4, v3, v3
	v_bfe_u32 v32, v14, 16, 1
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v18, v21, v18, v20
	v_dual_fmac_f32 v27, 0xb2a5705f, v12 :: v_dual_sub_f32 v20, v35, v34
	v_div_scale_f32 v21, vcc_lo, v11, v9, v11
	v_lshrrev_b32_e32 v17, 16, v17
	s_delay_alu instid0(VALU_DEP_4)
	v_div_fixup_f32 v10, v18, v22, v10
	v_or_b32_e32 v35, 0x400000, v5
	v_add_f32_e32 v18, v20, v27
	v_mul_f32_e32 v20, v21, v33
	v_or_b32_e32 v27, 0x400000, v3
	v_mul_f32_e32 v10, v10, v2
	v_bfe_u32 v2, v3, 16, 1
	v_exp_f32_e32 v18, v18
	v_fma_f32 v22, -v19, v20, v21
	v_mov_b16_e32 v16.h, v17.l
	v_bfe_u32 v23, v10, 16, 1
	v_add3_u32 v2, v2, v3, 0x7fff
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_fmac_f32_e32 v20, v22, v33
	v_add3_u32 v22, v23, v10, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_cndmask_b32_e64 v3, v2, v27, s4
	v_ldexp_f32 v18, v18, v26
	v_fma_f32 v2, -v19, v20, v21
	v_and_b32_e32 v21, 0xffff0000, v3
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_div_fmas_f32 v19, v2, v33, v20
	v_or_b32_e32 v20, 0x400000, v10
	v_add_nc_u32_e32 v2, 3, v8
	v_div_fixup_f32 v9, v19, v9, v11
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_ashrrev_i32_e32 v3, 31, v2
	v_mul_f32_e32 v9, v9, v21
	v_cmp_nlt_f32_e64 s4, 0x42ce8ed0, v12
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2b17218, v12
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_lshlrev_b64_e32 v[2:3], 1, v[2:3]
	v_bfe_u32 v17, v9, 16, 1
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v18, 0, v18, s4
	v_cmp_u_f32_e64 s4, v9, v9
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_add3_u32 v17, v17, v9, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v18, 0x7f800000, v18, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	s_delay_alu instid0(VALU_DEP_2)
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
	v_add_co_u32 v2, vcc_lo, s22, v2
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v3, null, s23, v3, vcc_lo
	v_or_b32_e32 v20, 0x400000, v9
	v_and_b32_e32 v13, 0xffff0000, v13
	v_add3_u32 v9, v22, v4, 0x7fff
	v_fma_f32 v18, -v10, v21, 1.0
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v17, v17, v20, s4
	v_or_b32_e32 v20, 0x400000, v4
	v_cmp_u_f32_e64 s4, v4, v4
	v_fmac_f32_e32 v21, v18, v21
	v_div_scale_f32 v18, vcc_lo, v12, v11, v12
	v_mul_f32_e32 v23, 0xbfb8aa3b, v13
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v4, v9, v20, s4
	v_cmp_u_f32_e64 s4, v14, v14
	v_mul_f32_e32 v22, v18, v21
	v_rndne_f32_e32 v27, v23
	v_fma_f32 v26, 0xbfb8aa3b, v13, -v23
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_fma_f32 v20, -v10, v22, v18
	v_sub_f32_e32 v9, v23, v27
	v_add3_u32 v23, v32, v14, 0x7fff
	v_or_b32_e32 v32, 0x400000, v14
	v_fmac_f32_e32 v26, 0xb2a5705f, v13
	v_fmac_f32_e32 v22, v20, v21
	v_bfe_u32 v20, v15, 16, 1
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v14, v23, v32, s4
	v_or_b32_e32 v23, 0x400000, v15
	v_fma_f32 v10, -v10, v22, v18
	v_add3_u32 v20, v20, v15, 0x7fff
	v_add_f32_e32 v9, v9, v26
	v_cvt_i32_f32_e32 v18, v27
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v10, v10, v21, v22
	v_cmp_u_f32_e32 vcc_lo, v15, v15
	v_exp_f32_e32 v9, v9
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_3) | instid1(VALU_DEP_2)
	v_div_fixup_f32 v11, v10, v11, v12
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v15, v20, v23, vcc_lo
	v_cmp_nlt_f32_e32 vcc_lo, 0x42ce8ed0, v13
	v_and_b32_e32 v15, 0xffff0000, v15
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_ldexp_f32 v9, v9, v18
	v_mul_f32_e32 v21, 0xbfb8aa3b, v15
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_cndmask_b32_e32 v9, 0, v9, vcc_lo
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2b17218, v13
	v_rndne_f32_e32 v26, v21
	v_and_b32_e32 v4, 0xffff0000, v4
	v_fma_f32 v23, 0xbfb8aa3b, v15, -v21
	s_wait_alu depctr_va_vcc(0)
	v_dual_cndmask_b32 v10, 0x7f800000, v9 :: v_dual_add_nc_u32 v9, 4, v8
	v_sub_f32_e32 v21, v21, v26
	v_dual_mul_f32 v11, v11, v4 :: v_dual_and_b32 v14, 0xffff0000, v14
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_add_f32_e32 v22, 1.0, v10
	v_ashrrev_i32_e32 v10, 31, v9
	v_fmac_f32_e32 v23, 0xb2a5705f, v15
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_1) | instid1(VALU_DEP_4)
	v_mul_f32_e32 v18, 0xbfb8aa3b, v14
	v_cmp_ngt_f32_e64 s4, 0xc2b17218, v14
	v_lshlrev_b64_e32 v[9:10], 1, v[9:10]
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_fma_f32 v12, 0xbfb8aa3b, v14, -v18
	v_rndne_f32_e32 v20, v18
	v_add_co_u32 v9, vcc_lo, s22, v9
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_fmac_f32_e32 v12, 0xb2a5705f, v14
	v_sub_f32_e32 v18, v18, v20
	v_cvt_i32_f32_e32 v4, v20
	v_add_f32_e32 v20, v21, v23
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v10, null, s23, v10, vcc_lo
	v_add_f32_e32 v12, v18, v12
	v_div_scale_f32 v18, null, v22, v22, v13
	v_cmp_nlt_f32_e32 vcc_lo, 0x42ce8ed0, v14
	v_exp_f32_e32 v20, v20
	v_bfe_u32 v21, v11, 16, 1
	v_exp_f32_e32 v12, v12
	v_rcp_f32_e32 v27, v18
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(TRANS32_DEP_2)
	v_add3_u32 v21, v21, v11, 0x7fff
	v_ldexp_f32 v4, v12, v4
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_fma_f32 v12, -v18, v27, 1.0
	s_wait_alu depctr_va_vcc(0)
	v_dual_cndmask_b32 v4, 0, v4 :: v_dual_fmac_f32 v27, v12, v27
	v_cvt_i32_f32_e32 v12, v26
	v_div_scale_f32 v23, vcc_lo, v13, v22, v13
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_3)
	v_cndmask_b32_e64 v4, 0x7f800000, v4, s4
	v_cmp_nlt_f32_e64 s4, 0x42ce8ed0, v15
	v_ldexp_f32 v12, v20, v12
	v_mul_f32_e32 v26, v23, v27
	v_or_b32_e32 v20, 0x400000, v11
	v_add_f32_e32 v32, 1.0, v4
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v4, 0, v12, s4
	v_cmp_ngt_f32_e64 s4, 0xc2b17218, v15
	v_bfe_u32 v12, v5, 16, 1
	v_fma_f32 v33, -v18, v26, v23
	v_div_scale_f32 v34, null, v32, v32, v14
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v4, 0x7f800000, v4, s4
	v_add3_u32 v12, v12, v5, 0x7fff
	v_fmac_f32_e32 v26, v33, v27
	v_cmp_u_f32_e64 s4, v5, v5
	v_rcp_f32_e32 v33, v34
	v_add_f32_e32 v36, 1.0, v4
	v_add_nc_u32_e32 v4, 5, v8
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v5, v12, v35, s4
	v_fma_f32 v12, -v18, v26, v23
	v_div_scale_f32 v18, null, v36, v36, v15
	v_cmp_u_f32_e64 s4, v11, v11
	v_or_b32_e32 v35, 0x400000, v6
	v_fma_f32 v23, -v34, v33, 1.0
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v12, v12, v27, v26
	v_rcp_f32_e32 v27, v18
	v_and_b32_e32 v26, 0xffff0000, v5
	v_ashrrev_i32_e32 v5, 31, v4
	v_fmac_f32_e32 v33, v23, v33
	v_div_fixup_f32 v12, v12, v22, v13
	v_div_scale_f32 v13, vcc_lo, v14, v32, v14
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v20, v21, v20, s4
	v_lshlrev_b64_e32 v[4:5], 1, v[4:5]
	v_bfe_u32 v22, v6, 16, 1
	v_dual_mul_f32 v11, v12, v26 :: v_dual_mul_f32 v12, v13, v33
	v_fma_f32 v21, -v18, v27, 1.0
	s_delay_alu instid0(VALU_DEP_4)
	v_add_co_u32 v4, s4, s22, v4
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v5, null, s23, v5, s4
	v_fma_f32 v26, -v34, v12, v13
	v_fmac_f32_e32 v27, v21, v27
	v_div_scale_f32 v21, s4, v15, v36, v15
	v_add3_u32 v22, v22, v6, 0x7fff
	v_bfe_u32 v23, v11, 16, 1
	v_fmac_f32_e32 v12, v26, v33
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_mul_f32_e32 v26, v21, v27
	v_cndmask_b32_e64 v6, v22, v35, s5
	v_bfe_u32 v22, v7, 16, 1
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_2) | instid1(VALU_DEP_4)
	v_fma_f32 v13, -v34, v12, v13
	v_add3_u32 v23, v23, v11, 0x7fff
	v_fma_f32 v34, -v18, v26, v21
	v_add3_u32 v22, v22, v7, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v12, v13, v33, v12
	v_or_b32_e32 v33, 0x400000, v7
	v_fmac_f32_e32 v26, v34, v27
	v_cmp_u_f32_e32 vcc_lo, v7, v7
	v_and_b32_e32 v13, 0xffff0000, v6
	v_div_fixup_f32 v12, v12, v32, v14
	v_add_nc_u32_e32 v6, 6, v8
	v_fma_f32 v14, -v18, v26, v21
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v18, v22, v33, vcc_lo
	s_mov_b32 vcc_lo, s4
	v_mul_f32_e32 v13, v12, v13
	v_ashrrev_i32_e32 v7, 31, v6
	s_wait_alu depctr_sa_sdst(0)
	v_div_fmas_f32 v14, v14, v27, v26
	v_or_b32_e32 v12, 0x400000, v11
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	v_add_nc_u32_e32 v11, 7, v8
	v_and_b32_e32 v18, 0xffff0000, v18
	v_div_fixup_f32 v14, v14, v36, v15
	v_lshlrev_b64_e32 v[6:7], 1, v[6:7]
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v21, v23, v12, vcc_lo
	v_ashrrev_i32_e32 v12, 31, v11
	v_bfe_u32 v15, v13, 16, 1
	v_mul_f32_e32 v8, v14, v18
	v_add_co_u32 v6, vcc_lo, s22, v6
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
	global_store_d16_hi_b16 v[0:1], v19, off offset:1028
	global_store_b32 v[0:1], v16, off offset:1024
	global_store_d16_hi_b16 v[2:3], v17, off offset:1024
	global_store_d16_hi_b16 v[9:10], v20, off offset:1024
	global_store_d16_hi_b16 v[4:5], v21, off offset:1024
	global_store_d16_hi_b16 v[6:7], v13, off offset:1024
	global_store_d16_hi_b16 v[11:12], v8, off offset:1024
	s_branch .LBB0_33
.LBB0_40:
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s3, s2
	s_cbranch_execz .LBB0_59
	v_mov_b32_e32 v1, 0
	s_mov_b32 s2, exec_lo
	s_mov_b32 s4, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	v_mbcnt_lo_u32_b32 v0, s2, 0
	global_load_b32 v2, v1, s[28:29] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_43
	s_bcnt1_i32_b32 s2, s2
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v3, s2
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v3, v1, v3, s[28:29] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_43:
	s_or_b32 exec_lo, exec_lo, s4
	v_readfirstlane_b32 s2, v3
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v0, s2, v0
	s_mov_b32 s2, exec_lo
	v_cmpx_ne_u32_e32 3, v0
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s4, exec_lo, s2
	s_cbranch_execz .LBB0_56
	s_cmp_lt_i32 s26, 1
	s_mov_b32 s5, 1
	s_cbranch_scc1 .LBB0_52
	v_mov_b32_e32 v0, 0
.LBB0_46:
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
	s_cselect_b32 s9, -1, 0
	s_add_co_i32 s5, s5, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s9, s2, s9
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s9
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_46
	s_and_b32 vcc_lo, exec_lo, s2
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_53
	s_branch .LBB0_56
.LBB0_48:
	s_cbranch_execz .LBB0_27
.LBB0_49:
	v_dual_mov_b32 v4, 1 :: v_dual_mov_b32 v5, 0
	s_mov_b32 s3, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v1, v5, v[4:5], s[30:31] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_51
	v_dual_mov_b32 v2, ttmp9 :: v_dual_mov_b32 v1, v4
	global_store_b96 v5, v[1:3], s[30:31] offset:4
.LBB0_51:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
	s_and_not1_saveexec_b32 s3, s5
	s_cbranch_execnz .LBB0_28
	s_branch .LBB0_29
.LBB0_52:
	s_cbranch_execz .LBB0_56
.LBB0_53:
	v_dual_mov_b32 v3, 1 :: v_dual_mov_b32 v4, 0
	s_mov_b32 s2, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v0, v4, v[3:4], s[30:31] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_55
	v_dual_mov_b32 v1, ttmp9 :: v_dual_mov_b32 v0, 2
	global_store_b96 v4, v[0:2], s[30:31] offset:4
.LBB0_55:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s2
.LBB0_56:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s2, s4
	s_cbranch_execz .LBB0_58
	v_dual_mov_b32 v0, 0 :: v_dual_add_nc_u32 v1, 1, v2
	global_store_b32 v0, v0, s[28:29] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v0, v1, s[28:29] offset:4 scope:SCOPE_DEV
.LBB0_58:
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
.LBB0_59:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
	s_wait_storecnt 0x0
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	v_mov_b32_e32 v0, 0
	s_cmp_gt_i32 s8, 1
	s_cselect_b32 s2, -1, 0
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	ds_load_b32 v0, v0 offset:20
	s_wait_dscnt 0x0
	v_cmp_eq_u32_e32 vcc_lo, 0, v0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s2, vcc_lo, s2
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s2
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_88
	s_load_b64 s[2:3], s[0:1], 0x68
	v_lshl_or_b32 v0, v29, 6, v28
	s_cmp_lg_u32 s7, 0
	v_lshlrev_b32_e32 v26, 5, v29
	s_cselect_b32 s1, -1, 0
	s_lshl_b32 s4, s27, 4
	v_lshlrev_b32_e32 v1, 1, v0
	s_lshl_b32 s5, ttmp9, 12
	s_lshl_b32 s7, s27, 10
	v_cmp_gt_i32_e32 vcc_lo, s24, v29
	s_wait_alu depctr_sa_sdst(0)
	v_or3_b32 v23, s5, s7, v0
	v_add_co_u32 v19, s0, s22, v1
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v20, null, s23, 0, s0
	s_lshl_b32 s0, ttmp9, 6
	s_wait_alu depctr_sa_sdst(0)
	v_or3_b32 v21, s0, s4, v28
	s_add_co_i32 s0, s27, s6
	s_wait_alu depctr_sa_sdst(0)
	s_add_co_i32 s4, s0, -16
	s_branch .LBB0_63
.LBB0_61:
	global_store_b16 v[0:1], v3, off offset:14
.LBB0_62:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s5
	v_add_nc_u32_e32 v21, 0x100, v21
	v_add_nc_u32_e32 v23, 0x4000, v23
	s_add_co_i32 s4, s4, 16
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s4, -14
	s_cbranch_scc0 .LBB0_88
.LBB0_63:
	v_dual_mov_b32 v8, 0 :: v_dual_mov_b32 v11, 0
	v_dual_mov_b32 v12, 0 :: v_dual_mov_b32 v13, 0
	v_mov_b32_e32 v14, 0
	s_and_saveexec_b32 s0, vcc_lo
	s_cbranch_execz .LBB0_65
	global_load_b128 v[11:14], v[19:20], off offset:1024
.LBB0_65:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s0
	v_ashrrev_i32_e32 v24, 31, v23
	v_dual_mov_b32 v9, 0 :: v_dual_mov_b32 v10, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshlrev_b64_e32 v[0:1], 1, v[23:24]
	v_add_co_u32 v24, s0, s16, v0
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_add_co_ci_u32_e64 v25, null, s17, v1, s0
	global_load_b128 v[15:18], v[24:25], off
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[15:18], v[11:14], 0
	v_mov_b32_e32 v11, 0
	s_and_saveexec_b32 s0, vcc_lo
	s_cbranch_execz .LBB0_67
	global_load_b128 v[8:11], v[19:20], off offset:1056
.LBB0_67:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s0
	global_load_b128 v[27:30], v[24:25], off offset:32
	v_dual_mov_b32 v12, 0 :: v_dual_mov_b32 v15, 0
	v_dual_mov_b32 v16, 0 :: v_dual_mov_b32 v17, 0
	v_mov_b32_e32 v18, 0
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[27:30], v[8:11], v[0:7]
	s_and_saveexec_b32 s0, vcc_lo
	s_cbranch_execz .LBB0_69
	global_load_b128 v[15:18], v[19:20], off offset:1088
.LBB0_69:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s0
	global_load_b128 v[8:11], v[24:25], off offset:64
	v_dual_mov_b32 v13, 0 :: v_dual_mov_b32 v14, 0
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[8:11], v[15:18], v[0:7]
	v_mov_b32_e32 v15, 0
	s_and_saveexec_b32 s0, vcc_lo
	s_cbranch_execz .LBB0_71
	global_load_b128 v[12:15], v[19:20], off offset:1120
.LBB0_71:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s0
	global_load_b128 v[8:11], v[24:25], off offset:96
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[8:11], v[12:15], v[0:7]
	s_and_saveexec_b32 s5, vcc_lo
	s_cbranch_execz .LBB0_62
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_3) | instid1(VALU_DEP_4)
	v_bfe_u32 v8, v0, 16, 1
	v_or_b32_e32 v9, 0x400000, v0
	v_cmp_u_f32_e64 s0, v0, v0
	v_ashrrev_i32_e32 v22, 31, v21
	v_add3_u32 v8, v8, v0, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1)
	v_cndmask_b32_e64 v0, v8, v9, s0
	s_and_b32 s0, s1, exec_lo
	s_cselect_b32 s0, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s0, 1
	v_lshrrev_b32_e32 v8, 16, v0
	s_cbranch_scc1 .LBB0_74
	v_lshlrev_b64_e32 v[9:10], 1, v[21:22]
	v_mov_b16_e32 v0.l, 0
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_lshlrev_b32_e32 v8, 16, v8
	s_wait_kmcnt 0x0
	v_add_co_u32 v9, s0, s2, v9
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v10, null, s3, v10, s0
	global_load_d16_hi_b16 v0, v[9:10], off
	s_wait_loadcnt 0x0
	v_add_f32_e32 v0, 1.0, v0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v9, v0, 16, 1
	v_or_b32_e32 v10, 0x400000, v0
	v_cmp_u_f32_e64 s0, v0, v0
	v_add3_u32 v9, v9, v0, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_cndmask_b32_e64 v0, v9, v10, s0
	v_and_b32_e32 v0, 0xffff0000, v0
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v0, v0, v8
	v_bfe_u32 v8, v0, 16, 1
	v_or_b32_e32 v9, 0x400000, v0
	v_cmp_u_f32_e64 s0, v0, v0
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v8, v8, v0, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v0, v8, v9, s0
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v8, 16, v0
.LBB0_74:
	v_bfe_u32 v0, v1, 16, 1
	v_add_nc_u32_e32 v9, v26, v21
	v_or_b32_e32 v11, 0x400000, v1
	v_cmp_u_f32_e64 s0, v1, v1
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_add3_u32 v0, v0, v1, 0x7fff
	v_ashrrev_i32_e32 v10, 31, v9
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cndmask_b32_e64 v11, v0, v11, s0
	v_lshlrev_b64_e32 v[0:1], 1, v[9:10]
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_lshrrev_b32_e32 v9, 16, v11
	v_add_co_u32 v0, s0, s18, v0
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_3)
	v_add_co_ci_u32_e64 v1, null, s19, v1, s0
	s_and_b32 s0, s1, exec_lo
	s_cselect_b32 s0, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s0, 1
	global_store_b16 v[0:1], v8, off
	s_cbranch_scc1 .LBB0_76
	v_lshlrev_b64_e32 v[10:11], 1, v[21:22]
	v_mov_b16_e32 v8.l, 0
	v_lshlrev_b32_e32 v9, 16, v9
	s_wait_kmcnt 0x0
	s_delay_alu instid0(VALU_DEP_3)
	v_add_co_u32 v10, s0, s2, v10
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v11, null, s3, v11, s0
	global_load_d16_hi_b16 v8, v[10:11], off offset:2
	s_wait_loadcnt 0x0
	v_add_f32_e32 v8, 1.0, v8
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v10, v8, 16, 1
	v_or_b32_e32 v11, 0x400000, v8
	v_cmp_u_f32_e64 s0, v8, v8
	v_add3_u32 v10, v10, v8, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_cndmask_b32_e64 v8, v10, v11, s0
	v_and_b32_e32 v8, 0xffff0000, v8
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v8, v8, v9
	v_bfe_u32 v9, v8, 16, 1
	v_or_b32_e32 v10, 0x400000, v8
	v_cmp_u_f32_e64 s0, v8, v8
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v9, v9, v8, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v8, v9, v10, s0
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v9, 16, v8
.LBB0_76:
	v_bfe_u32 v8, v2, 16, 1
	v_or_b32_e32 v10, 0x400000, v2
	v_cmp_u_f32_e64 s0, v2, v2
	global_store_b16 v[0:1], v9, off offset:2
	v_add3_u32 v8, v8, v2, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1)
	v_cndmask_b32_e64 v2, v8, v10, s0
	s_and_b32 s0, s1, exec_lo
	s_cselect_b32 s0, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s0, 1
	v_lshrrev_b32_e32 v2, 16, v2
	s_cbranch_scc1 .LBB0_78
	v_lshlrev_b64_e32 v[8:9], 1, v[21:22]
	v_mov_b16_e32 v10.l, 0
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_lshlrev_b32_e32 v2, 16, v2
	s_wait_kmcnt 0x0
	v_add_co_u32 v8, s0, s2, v8
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v9, null, s3, v9, s0
	global_load_d16_hi_b16 v10, v[8:9], off offset:4
	s_wait_loadcnt 0x0
	v_add_f32_e32 v8, 1.0, v10
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v9, v8, 16, 1
	v_or_b32_e32 v10, 0x400000, v8
	v_cmp_u_f32_e64 s0, v8, v8
	v_add3_u32 v9, v9, v8, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_cndmask_b32_e64 v8, v9, v10, s0
	v_and_b32_e32 v8, 0xffff0000, v8
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v2, v8, v2
	v_bfe_u32 v8, v2, 16, 1
	v_or_b32_e32 v9, 0x400000, v2
	v_cmp_u_f32_e64 s0, v2, v2
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v8, v8, v2, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v2, v8, v9, s0
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v2, 16, v2
.LBB0_78:
	v_bfe_u32 v8, v3, 16, 1
	v_or_b32_e32 v9, 0x400000, v3
	v_cmp_u_f32_e64 s0, v3, v3
	global_store_b16 v[0:1], v2, off offset:4
	v_add3_u32 v8, v8, v3, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1)
	v_cndmask_b32_e64 v3, v8, v9, s0
	s_and_b32 s0, s1, exec_lo
	s_cselect_b32 s0, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s0, 1
	v_lshrrev_b32_e32 v3, 16, v3
	s_cbranch_scc1 .LBB0_80
	v_lshlrev_b64_e32 v[8:9], 1, v[21:22]
	v_mov_b16_e32 v2.l, 0
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_lshlrev_b32_e32 v3, 16, v3
	s_wait_kmcnt 0x0
	v_add_co_u32 v8, s0, s2, v8
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v9, null, s3, v9, s0
	global_load_d16_hi_b16 v2, v[8:9], off offset:6
	s_wait_loadcnt 0x0
	v_add_f32_e32 v2, 1.0, v2
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v8, v2, 16, 1
	v_or_b32_e32 v9, 0x400000, v2
	v_cmp_u_f32_e64 s0, v2, v2
	v_add3_u32 v8, v8, v2, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_cndmask_b32_e64 v2, v8, v9, s0
	v_and_b32_e32 v2, 0xffff0000, v2
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v2, v2, v3
	v_bfe_u32 v3, v2, 16, 1
	v_or_b32_e32 v8, 0x400000, v2
	v_cmp_u_f32_e64 s0, v2, v2
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v3, v3, v2, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v2, v3, v8, s0
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v3, 16, v2
.LBB0_80:
	v_bfe_u32 v2, v4, 16, 1
	v_or_b32_e32 v8, 0x400000, v4
	v_cmp_u_f32_e64 s0, v4, v4
	global_store_b16 v[0:1], v3, off offset:6
	v_add3_u32 v2, v2, v4, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1)
	v_cndmask_b32_e64 v2, v2, v8, s0
	s_and_b32 s0, s1, exec_lo
	s_cselect_b32 s0, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s0, 1
	v_lshrrev_b32_e32 v2, 16, v2
	s_cbranch_scc1 .LBB0_82
	v_lshlrev_b64_e32 v[3:4], 1, v[21:22]
	v_mov_b16_e32 v8.l, 0
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_lshlrev_b32_e32 v2, 16, v2
	s_wait_kmcnt 0x0
	v_add_co_u32 v3, s0, s2, v3
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v4, null, s3, v4, s0
	global_load_d16_hi_b16 v8, v[3:4], off offset:8
	s_wait_loadcnt 0x0
	v_add_f32_e32 v3, 1.0, v8
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v4, v3, 16, 1
	v_or_b32_e32 v8, 0x400000, v3
	v_cmp_u_f32_e64 s0, v3, v3
	v_add3_u32 v4, v4, v3, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_cndmask_b32_e64 v3, v4, v8, s0
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
.LBB0_82:
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
	s_cbranch_scc1 .LBB0_84
	v_lshlrev_b64_e32 v[4:5], 1, v[21:22]
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
.LBB0_84:
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
	s_cbranch_scc1 .LBB0_86
	v_lshlrev_b64_e32 v[3:4], 1, v[21:22]
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
.LBB0_86:
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
	s_cbranch_scc1 .LBB0_61
	v_lshlrev_b64_e32 v[4:5], 1, v[21:22]
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
	s_branch .LBB0_61
.LBB0_88:
	s_endpgm
.Lfunc_end0:
	.size	qwen_bf16_ffnar_v1_h32_i64_b4_tp1r0_a0_f0, .Lfunc_end0-qwen_bf16_ffnar_v1_h32_i64_b4_tp1r0_a0_f0
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel qwen_bf16_ffnar_v1_h32_i64_b4_tp1r0_a0_f0
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
		.amdhsa_next_free_vgpr 41
		.amdhsa_next_free_sgpr 40
		.amdhsa_reserve_vcc 1
		.amdhsa_float_round_mode_32 0
		.amdhsa_float_round_mode_16_64 0
		.amdhsa_float_denorm_mode_32 3
		.amdhsa_float_denorm_mode_16_64 3
		.amdhsa_fp16_overflow 0
		.amdhsa_workgroup_processor_mode 1
		.amdhsa_memory_ordered 1
		.amdhsa_forward_progress 1
		.amdhsa_inst_pref_size ((instprefsize(.Lfunc_end0-qwen_bf16_ffnar_v1_h32_i64_b4_tp1r0_a0_f0)<<4)&4080)>>4
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

	.set .Lqwen_bf16_ffnar_v1_h32_i64_b4_tp1r0_a0_f0.num_vgpr, 41
	.set .Lqwen_bf16_ffnar_v1_h32_i64_b4_tp1r0_a0_f0.num_agpr, 0
	.set .Lqwen_bf16_ffnar_v1_h32_i64_b4_tp1r0_a0_f0.numbered_sgpr, 40
	.set .Lqwen_bf16_ffnar_v1_h32_i64_b4_tp1r0_a0_f0.num_named_barrier, 0
	.set .Lqwen_bf16_ffnar_v1_h32_i64_b4_tp1r0_a0_f0.private_seg_size, 0
	.set .Lqwen_bf16_ffnar_v1_h32_i64_b4_tp1r0_a0_f0.uses_vcc, 1
	.set .Lqwen_bf16_ffnar_v1_h32_i64_b4_tp1r0_a0_f0.uses_flat_scratch, 0
	.set .Lqwen_bf16_ffnar_v1_h32_i64_b4_tp1r0_a0_f0.has_dyn_sized_stack, 0
	.set .Lqwen_bf16_ffnar_v1_h32_i64_b4_tp1r0_a0_f0.has_recursion, 0
	.set .Lqwen_bf16_ffnar_v1_h32_i64_b4_tp1r0_a0_f0.has_indirect_call, 0
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
    .name:           qwen_bf16_ffnar_v1_h32_i64_b4_tp1r0_a0_f0
    .private_segment_fixed_size: 0
    .reqd_workgroup_size:
      - 128
      - 1
      - 1
    .sgpr_count:     42
    .sgpr_spill_count: 0
    .symbol:         qwen_bf16_ffnar_v1_h32_i64_b4_tp1r0_a0_f0.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     41
    .vgpr_spill_count: 0
    .wavefront_size: 32
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1201
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
