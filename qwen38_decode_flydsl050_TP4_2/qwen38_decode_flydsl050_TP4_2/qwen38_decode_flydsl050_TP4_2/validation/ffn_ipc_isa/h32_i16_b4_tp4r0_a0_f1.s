	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1201"
	.amdhsa_code_object_version 6
	.text
	.globl	qwen_bf16_ffnar_v1_h32_i16_b4_tp4r0_a0_f1
	.p2align	8
	.type	qwen_bf16_ffnar_v1_h32_i16_b4_tp4r0_a0_f1,@function
qwen_bf16_ffnar_v1_h32_i16_b4_tp4r0_a0_f1:
	s_load_b128 s[28:31], s[0:1], 0x70
	s_wait_kmcnt 0x0
	s_cmp_lt_i32 s28, 1
	s_cbranch_scc1 .LBB0_216
	s_clause 0x1
	s_load_b96 s[36:38], s[0:1], 0x80
	s_load_b128 s[20:23], s[0:1], 0x40
	v_cmp_eq_u32_e64 s2, 0, v0
	s_and_saveexec_b32 s3, s2
	s_cbranch_execz .LBB0_3
	v_mov_b32_e32 v1, 0
	s_cmp_lg_u32 ttmp9, s31
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
	s_clause 0x1
	s_load_b128 s[24:27], s[0:1], 0x58
	s_load_b64 s[34:35], s[0:1], 0x68
	v_mov_b32_e32 v1, 0
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	ds_load_b32 v1, v1 offset:20
	s_wait_dscnt 0x0
	v_cmp_eq_u32_e32 vcc_lo, 0, v1
	s_cbranch_vccnz .LBB0_213
	s_load_b512 s[4:19], s[0:1], 0x0
	v_lshrrev_b32_e32 v1, 5, v0
	s_cmp_ge_i32 ttmp9, s28
	s_delay_alu instid0(VALU_DEP_1)
	v_readfirstlane_b32 s3, v1
	s_cbranch_scc1 .LBB0_19
	v_and_b32_e32 v1, 31, v0
	v_cmp_gt_u32_e64 s0, 32, v0
	s_wait_kmcnt 0x0
	s_cmp_lg_u32 s36, 0
	s_mov_b32 s31, ttmp9
	v_dual_mov_b32 v13, 0 :: v_dual_lshlrev_b32 v2, 2, v1
	v_cmp_gt_u32_e32 vcc_lo, 24, v1
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_3) | instid1(VALU_DEP_4)
	v_add_nc_u32_e32 v4, 32, v2
	v_add_nc_u32_e32 v5, 16, v2
	v_add_nc_u32_e32 v6, 8, v2
	v_add_nc_u32_e32 v7, 4, v2
	v_cndmask_b32_e32 v9, v2, v4, vcc_lo
	v_cmp_gt_u32_e32 vcc_lo, 28, v1
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v10, v2, v5, vcc_lo
	v_cmp_gt_u32_e32 vcc_lo, 30, v1
	v_cmp_eq_u32_e64 s1, 0, v1
	v_lshl_add_u32 v5, ttmp9, 5, v0
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v11, v2, v6, vcc_lo
	v_cmp_ne_u32_e32 vcc_lo, 31, v1
	s_wait_alu depctr_va_vcc(0)
	v_dual_cndmask_b32 v12, 0x7c, v7 :: v_dual_lshlrev_b32 v3, 1, v0
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_u32 v1, s24, s24, v3
	v_add_co_u32 v3, s8, s8, v3
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v2, null, s25, 0, s24
	v_add_co_ci_u32_e64 v4, null, s9, 0, s8
	s_cselect_b32 s8, -1, 0
	s_lshl_b32 s9, s3, 2
	s_branch .LBB0_8
.LBB0_6:
	v_add_co_u32 v15, vcc_lo, s6, v6
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v16, null, s7, v7, vcc_lo
	v_add_co_u32 v6, vcc_lo, s18, v6
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v7, null, s19, v7, vcc_lo
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
	s_or_b32 exec_lo, exec_lo, s24
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	s_barrier_signal -1
	v_add_nc_u32_e32 v5, 0x80, v5
	s_add_co_i32 s31, s31, 4
	s_delay_alu instid0(SALU_CYCLE_1)
	s_cmp_lt_i32 s31, s28
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_cbranch_scc0 .LBB0_19
.LBB0_8:
	v_ashrrev_i32_e32 v6, 31, v5
	v_mov_b32_e32 v7, 0
	s_and_saveexec_b32 s24, s0
	s_cbranch_execz .LBB0_12
	s_delay_alu instid0(VALU_DEP_2)
	v_lshlrev_b64_e32 v[7:8], 1, v[5:6]
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s25, s8, exec_lo
	s_cselect_b32 s25, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s25, 1
	v_add_co_u32 v14, vcc_lo, s4, v7
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v15, null, s5, v8, vcc_lo
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
	v_add_co_u32 v15, vcc_lo, s6, v7
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v16, null, s7, v8, vcc_lo
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
	v_add_co_u32 v14, vcc_lo, s16, v7
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v15, null, s17, v8, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v16, v16
	s_wait_alu depctr_va_vcc(0)
	v_dual_mul_f32 v7, v16, v16 :: v_dual_cndmask_b32 v8, v18, v17
	global_store_d16_hi_b16 v[14:15], v8, off
.LBB0_12:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s24
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
	s_and_saveexec_b32 s24, s1
	s_cbranch_execz .LBB0_14
	s_wait_dscnt 0x0
	v_dual_add_f32 v7, v7, v8 :: v_dual_mov_b32 v8, s9
	ds_store_b32 v8, v7
.LBB0_14:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s24
	s_wait_storecnt 0x0
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s24, s2
	s_cbranch_execz .LBB0_16
	ds_load_b128 v[14:17], v13
	s_wait_dscnt 0x0
	v_readfirstlane_b32 s25, v14
	v_readfirstlane_b32 s33, v15
	v_readfirstlane_b32 s36, v16
	s_add_f32 s25, s25, 0
	s_wait_alu depctr_sa_sdst(0)
	s_delay_alu instid0(SALU_CYCLE_2) | instskip(SKIP_2) | instid1(SALU_CYCLE_1)
	s_add_f32 s25, s25, s33
	v_readfirstlane_b32 s33, v17
	s_wait_alu depctr_sa_sdst(0)
	s_add_f32 s25, s25, s36
	s_wait_alu depctr_sa_sdst(0)
	s_delay_alu instid0(SALU_CYCLE_2) | instskip(SKIP_1) | instid1(SALU_CYCLE_2)
	s_add_f32 s25, s25, s33
	s_wait_alu depctr_sa_sdst(0)
	s_mul_f32 s25, s25, 0x3d000000
	s_wait_alu depctr_sa_sdst(0)
	s_delay_alu instid0(SALU_CYCLE_2) | instskip(SKIP_1) | instid1(SALU_CYCLE_2)
	s_add_f32 s25, s29, s25
	s_wait_alu depctr_sa_sdst(0)
	s_mul_f32 s33, s25, 0x4f800000
	s_cmp_lt_f32 s25, 0xf800000
	s_wait_alu depctr_sa_sdst(0)
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_3) | instid1(TRANS32_DEP_1)
	s_cselect_b32 s33, s33, s25
	s_wait_alu depctr_sa_sdst(0)
	v_s_sqrt_f32 s36, s33
	s_mov_b32 s40, s33
	s_add_co_i32 s39, s36, -1
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_xor_b32 s41, s39, 0x80000000
	s_fmac_f32 s40, s41, s36
	s_mov_b32 s41, s33
	s_delay_alu instid0(SALU_CYCLE_2) | instskip(SKIP_2) | instid1(SALU_CYCLE_1)
	s_cmp_le_f32 s40, 0
	s_cselect_b32 s39, s39, s36
	s_add_co_i32 s40, s36, 1
	s_xor_b32 s42, s40, 0x80000000
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_2)
	s_fmac_f32 s41, s42, s36
	v_cmp_class_f32_e64 s36, s33, 0x260
	s_cmp_gt_f32 s41, 0
	s_cselect_b32 s39, s40, s39
	s_cmp_lt_f32 s25, 0xf800000
	s_mul_f32 s25, s39, 0x37800000
	s_wait_alu depctr_sa_sdst(0)
	s_delay_alu instid0(SALU_CYCLE_2)
	s_cselect_b32 s25, s25, s39
	s_and_b32 s36, s36, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	s_cselect_b32 s25, s33, s25
	s_wait_alu depctr_sa_sdst(0)
	v_div_scale_f32 v7, null, s25, s25, 1.0
	s_delay_alu instid0(VALU_DEP_1)
	v_rcp_f32_e32 v8, v7
	v_xor_b32_e32 v7, 0x80000000, v7
	s_delay_alu instid0(TRANS32_DEP_1) | instid1(VALU_DEP_1)
	v_fma_f32 v14, v7, v8, 1.0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_fmac_f32_e32 v8, v14, v8
	v_div_scale_f32 v14, vcc_lo, 1.0, s25, 1.0
	v_mul_f32_e32 v15, v14, v8
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fma_f32 v16, v7, v15, v14
	v_fmac_f32_e32 v15, v16, v8
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_fmac_f32_e32 v14, v7, v15
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v7, v14, v8, v15
	s_delay_alu instid0(VALU_DEP_1)
	v_div_fixup_f32 v7, v7, s25, 1.0
	ds_store_b32 v13, v7 offset:16
.LBB0_16:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s24
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s24, s0
	s_cbranch_execz .LBB0_7
	v_lshlrev_b64_e32 v[6:7], 1, v[5:6]
	ds_load_b32 v8, v13 offset:16
	s_and_b32 s25, s8, exec_lo
	s_cselect_b32 s25, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s25, 1
	v_add_co_u32 v14, vcc_lo, s4, v6
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v15, null, s5, v7, vcc_lo
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
	s_and_saveexec_b32 s1, s2
	s_cbranch_execz .LBB0_30
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
	s_cbranch_execz .LBB0_22
	s_bcnt1_i32_b32 s0, s0
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v4, s0
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v4, v2, v4, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_22:
	s_or_b32 exec_lo, exec_lo, s4
	v_readfirstlane_b32 s0, v4
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v1, s0, v1
	s_mov_b32 s0, exec_lo
	v_cmpx_ne_u32_e32 3, v1
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s4, exec_lo, s0
	s_cbranch_execz .LBB0_27
	s_cmp_lt_i32 s30, 1
	s_mov_b32 s5, 1
	s_cbranch_scc1 .LBB0_48
	v_mov_b32_e32 v1, 0
.LBB0_25:
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
	s_cmp_lt_i32 s5, s30
	s_cselect_b32 s6, -1, 0
	s_add_co_i32 s5, s5, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s6, s0, s6
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s6
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_25
	s_and_b32 vcc_lo, exec_lo, s0
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_49
.LBB0_27:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s0, s4
	s_cbranch_execz .LBB0_29
.LBB0_28:
	v_dual_mov_b32 v1, 0 :: v_dual_add_nc_u32 v2, 1, v3
	global_store_b32 v1, v1, s[20:21] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v1, v2, s[20:21] offset:4 scope:SCOPE_DEV
.LBB0_29:
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
.LBB0_30:
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
	s_cbranch_vccnz .LBB0_213
	v_lshrrev_b32_e32 v1, 1, v0
	s_lshl_b32 s0, ttmp9, 2
	v_and_b32_e32 v29, 15, v0
	s_wait_kmcnt 0x0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s4, s0, s3
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_gt_i32 s4, 0
	v_and_b32_e32 v30, 8, v1
	s_cbranch_scc0 .LBB0_40
.LBB0_32:
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s1, s2
	s_cbranch_execz .LBB0_59
	v_mov_b32_e32 v2, 0
	s_mov_b32 s0, exec_lo
	s_mov_b32 s3, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	v_mbcnt_lo_u32_b32 v1, s0, 0
	global_load_b32 v3, v2, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_35
	s_bcnt1_i32_b32 s0, s0
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v4, s0
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v4, v2, v4, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_35:
	s_or_b32 exec_lo, exec_lo, s3
	v_readfirstlane_b32 s0, v4
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v1, s0, v1
	s_mov_b32 s0, exec_lo
	v_cmpx_ne_u32_e32 3, v1
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s3, exec_lo, s0
	s_cbranch_execz .LBB0_56
	s_cmp_lt_i32 s30, 1
	s_mov_b32 s5, 1
	s_cbranch_scc1 .LBB0_52
	v_mov_b32_e32 v1, 0
.LBB0_38:
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
	s_cmp_lt_i32 s5, s30
	s_cselect_b32 s6, -1, 0
	s_add_co_i32 s5, s5, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s6, s0, s6
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s6
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_38
	s_and_b32 vcc_lo, exec_lo, s0
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_53
	s_branch .LBB0_56
.LBB0_40:
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_4) | instid1(VALU_DEP_1)
	v_lshl_or_b32 v31, v29, 5, v30
	v_cmp_gt_i32_e64 s0, s28, v29
	v_lshlrev_b32_e32 v32, 4, v29
	s_mov_b32 s5, s4
	v_lshlrev_b32_e32 v1, 1, v31
	v_add_co_u32 v25, s1, s18, v1
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v26, null, s19, 0, s1
	s_branch .LBB0_42
.LBB0_41:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
	s_add_co_i32 s1, s5, 16
	s_cmp_lt_i32 s5, -15
	s_wait_alu depctr_sa_sdst(0)
	s_mov_b32 s5, s1
	s_cbranch_scc0 .LBB0_32
.LBB0_42:
	v_dual_mov_b32 v17, 0 :: v_dual_mov_b32 v18, 0
	v_dual_mov_b32 v19, 0 :: v_dual_mov_b32 v20, 0
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_44
	global_load_b128 v[17:20], v[25:26], off
.LBB0_44:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s1
	v_lshl_or_b32 v1, s5, 9, v31
	v_dual_mov_b32 v21, 0 :: v_dual_mov_b32 v22, 0
	v_dual_mov_b32 v23, 0 :: v_dual_mov_b32 v24, 0
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v2, 31, v1
	v_lshlrev_b64_e32 v[1:2], 1, v[1:2]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v27, vcc_lo, s10, v1
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v28, null, s11, v2, vcc_lo
	s_clause 0x1
	global_load_b128 v[1:4], v[27:28], off
	global_load_b128 v[33:36], v[27:28], off offset:1024
	s_wait_loadcnt 0x1
	v_wmma_f32_16x16x16_bf16 v[9:16], v[1:4], v[17:20], 0
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[1:8], v[33:36], v[17:20], 0
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_46
	global_load_b128 v[21:24], v[25:26], off offset:32
.LBB0_46:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s1
	s_clause 0x1
	global_load_b128 v[17:20], v[27:28], off offset:32
	global_load_b128 v[33:36], v[27:28], off offset:1056
	s_wait_loadcnt 0x1
	v_wmma_f32_16x16x16_bf16 v[9:16], v[17:20], v[21:24], v[9:16]
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[1:8], v[33:36], v[21:24], v[1:8]
	s_and_saveexec_b32 s6, s0
	s_cbranch_execz .LBB0_41
	v_bfe_u32 v17, v9, 16, 1
	v_or_b32_e32 v18, 0x400000, v9
	v_bfe_u32 v19, v10, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v9, v9
	v_or_b32_e32 v20, 0x400000, v10
	v_add3_u32 v17, v17, v9, 0x7fff
	v_bfe_u32 v23, v11, 16, 1
	v_add3_u32 v19, v19, v10, 0x7fff
	v_or_b32_e32 v24, 0x400000, v11
	v_bfe_u32 v33, v12, 16, 1
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v9, v17, v18, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	v_add3_u32 v23, v23, v11, 0x7fff
	v_or_b32_e32 v34, 0x400000, v12
	v_add3_u32 v33, v33, v12, 0x7fff
	v_bfe_u32 v17, v1, 16, 1
	s_wait_alu depctr_va_vcc(0)
	v_dual_cndmask_b32 v10, v19, v20 :: v_dual_and_b32 v21, 0xffff0000, v9
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	v_lshl_or_b32 v9, s5, 4, v30
	v_or_b32_e32 v18, 0x400000, v1
	s_delay_alu instid0(VALU_DEP_4)
	v_and_b32_e32 v27, 0xffff0000, v10
	v_add3_u32 v17, v17, v1, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v11, v23, v24, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v12, v12
	v_mul_f32_e32 v19, 0xbfb8aa3b, v21
	v_bfe_u32 v22, v2, 16, 1
	v_or_b32_e32 v20, 0x400000, v2
	v_cmp_u_f32_e64 s1, v2, v2
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v12, v33, v34, vcc_lo
	v_fma_f32 v10, 0xbfb8aa3b, v21, -v19
	v_rndne_f32_e32 v28, v19
	v_add3_u32 v22, v22, v2, 0x7fff
	v_bfe_u32 v36, v13, 16, 1
	v_or_b32_e32 v37, 0x400000, v13
	s_delay_alu instid0(VALU_DEP_4)
	v_dual_fmac_f32 v10, 0xb2a5705f, v21 :: v_dual_sub_f32 v19, v19, v28
	v_cvt_i32_f32_e32 v28, v28
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v20, v22, v20, s1
	v_add3_u32 v36, v36, v13, 0x7fff
	v_and_b32_e32 v12, 0xffff0000, v12
	v_add_f32_e32 v10, v19, v10
	v_cmp_nlt_f32_e32 vcc_lo, 0x42ce8ed0, v21
	v_and_b32_e32 v20, 0xffff0000, v20
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(TRANS32_DEP_1)
	v_exp_f32_e32 v10, v10
	v_ldexp_f32 v10, v10, v28
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_dual_mul_f32 v35, 0xbfb8aa3b, v27 :: v_dual_cndmask_b32 v10, 0, v10
	v_fma_f32 v38, 0xbfb8aa3b, v27, -v35
	v_rndne_f32_e32 v19, v35
	v_add_nc_u32_e32 v9, v9, v32
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2b17218, v21
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_fmac_f32_e32 v38, 0xb2a5705f, v27
	v_sub_f32_e32 v35, v35, v19
	v_cvt_i32_f32_e32 v19, v19
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v10, 0x7f800000, v10, vcc_lo
	v_and_b32_e32 v11, 0xffff0000, v11
	v_cmp_u_f32_e32 vcc_lo, v1, v1
	v_add_f32_e32 v35, v35, v38
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_dual_cndmask_b32 v1, v17, v18 :: v_dual_mul_f32 v18, 0xbfb8aa3b, v11
	v_exp_f32_e32 v23, v35
	v_cmp_nlt_f32_e32 vcc_lo, 0x42ce8ed0, v27
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(TRANS32_DEP_1)
	v_rndne_f32_e32 v28, v18
	v_ldexp_f32 v17, v23, v19
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_1)
	v_dual_add_f32 v19, 1.0, v10 :: v_dual_cndmask_b32 v10, 0, v17
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2b17218, v27
	v_fma_f32 v17, 0xbfb8aa3b, v11, -v18
	v_sub_f32_e32 v18, v18, v28
	v_cvt_i32_f32_e32 v28, v28
	v_cmp_nlt_f32_e64 s1, 0x42ce8ed0, v11
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v10, 0x7f800000, v10, vcc_lo
	v_div_scale_f32 v24, null, v19, v19, v21
	v_div_scale_f32 v40, vcc_lo, v21, v19, v21
	v_cmp_ngt_f32_e64 s3, 0xc2b17218, v11
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_add_f32_e32 v35, 1.0, v10
	v_rcp_f32_e32 v33, v24
	v_ashrrev_i32_e32 v10, 31, v9
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fma_f32 v39, -v24, v33, 1.0
	v_fmac_f32_e32 v33, v39, v33
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_dual_mul_f32 v23, 0xbfb8aa3b, v12 :: v_dual_mul_f32 v22, v40, v33
	v_fmac_f32_e32 v17, 0xb2a5705f, v11
	v_fma_f32 v34, 0xbfb8aa3b, v12, -v23
	v_rndne_f32_e32 v38, v23
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_dual_add_f32 v17, v18, v17 :: v_dual_fmac_f32 v34, 0xb2a5705f, v12
	v_sub_f32_e32 v23, v23, v38
	v_cvt_i32_f32_e32 v38, v38
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_exp_f32_e32 v17, v17
	v_dual_add_f32 v23, v23, v34 :: v_dual_and_b32 v34, 0xffff0000, v1
	v_div_scale_f32 v18, null, v35, v35, v27
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(TRANS32_DEP_2)
	v_rcp_f32_e32 v41, v18
	v_ldexp_f32 v1, v17, v28
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_2) | instid1(VALU_DEP_2)
	v_exp_f32_e32 v17, v23
	v_fma_f32 v23, -v24, v22, v40
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v1, 0, v1, s1
	v_div_scale_f32 v28, s1, v27, v35, v27
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(TRANS32_DEP_2)
	v_fmac_f32_e32 v22, v23, v33
	v_fma_f32 v2, -v18, v41, 1.0
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_cndmask_b32_e64 v23, 0x7f800000, v1, s3
	v_cmp_u_f32_e64 s3, v7, v7
	v_fmac_f32_e32 v41, v2, v41
	v_lshlrev_b64_e32 v[1:2], 1, v[9:10]
	v_ldexp_f32 v10, v17, v38
	v_fma_f32 v17, -v24, v22, v40
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_div_fmas_f32 v17, v17, v33, v22
	v_cmp_nlt_f32_e32 vcc_lo, 0x42ce8ed0, v12
	v_div_fixup_f32 v17, v17, v19, v21
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v10, 0, v10, vcc_lo
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2b17218, v12
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_mul_f32_e32 v17, v17, v34
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v10, 0x7f800000, v10, vcc_lo
	s_mov_b32 vcc_lo, s1
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_bfe_u32 v21, v17, 16, 1
	v_cmp_u_f32_e64 s1, v17, v17
	v_dual_add_f32 v10, 1.0, v10 :: v_dual_mul_f32 v39, v28, v41
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_add3_u32 v21, v21, v17, 0x7fff
	v_fma_f32 v24, -v18, v39, v28
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fmac_f32_e32 v39, v24, v41
	v_fma_f32 v18, -v18, v39, v28
	s_wait_alu depctr_sa_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_div_fmas_f32 v18, v18, v41, v39
	v_div_fixup_f32 v18, v18, v35, v27
	v_or_b32_e32 v27, 0x400000, v17
	v_or_b32_e32 v35, 0x400000, v3
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_mul_f32_e32 v18, v18, v20
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v17, v21, v27, s1
	v_add_co_u32 v1, s1, s18, v1
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v2, null, s19, v2, s1
	v_cmp_u_f32_e64 s1, v13, v13
	v_div_scale_f32 v20, null, v10, v10, v12
	v_bfe_u32 v27, v3, 16, 1
	v_lshrrev_b32_e32 v17, 16, v17
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v13, v36, v37, s1
	v_rcp_f32_e32 v34, v20
	v_add3_u32 v27, v27, v3, 0x7fff
	v_cmp_u_f32_e64 s1, v3, v3
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_and_b32_e32 v13, 0xffff0000, v13
	v_add_f32_e32 v23, 1.0, v23
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v3, v27, v35, s1
	v_cmp_u_f32_e64 s1, v18, v18
	v_mul_f32_e32 v36, 0xbfb8aa3b, v13
	v_div_scale_f32 v22, null, v23, v23, v11
	v_div_scale_f32 v28, vcc_lo, v11, v23, v11
	v_fma_f32 v27, -v20, v34, 1.0
	v_and_b32_e32 v3, 0xffff0000, v3
	v_rndne_f32_e32 v35, v36
	v_rcp_f32_e32 v19, v22
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_fmac_f32_e32 v34, v27, v34
	v_cvt_i32_f32_e32 v27, v35
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fma_f32 v24, -v22, v19, 1.0
	v_fmac_f32_e32 v19, v24, v19
	v_bfe_u32 v24, v18, 16, 1
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_mul_f32_e32 v21, v28, v19
	v_add3_u32 v24, v24, v18, 0x7fff
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fma_f32 v33, -v22, v21, v28
	v_fmac_f32_e32 v21, v33, v19
	v_or_b32_e32 v33, 0x400000, v18
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_fma_f32 v22, -v22, v21, v28
	v_fma_f32 v28, 0xbfb8aa3b, v13, -v36
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v18, v24, v33, s1
	v_cmp_u_f32_e64 s1, v4, v4
	v_bfe_u32 v33, v15, 16, 1
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v19, v22, v19, v21
	v_dual_fmac_f32 v28, 0xb2a5705f, v13 :: v_dual_sub_f32 v21, v36, v35
	v_div_scale_f32 v22, vcc_lo, v12, v10, v12
	v_lshrrev_b32_e32 v18, 16, v18
	s_delay_alu instid0(VALU_DEP_4)
	v_div_fixup_f32 v11, v19, v23, v11
	v_or_b32_e32 v36, 0x400000, v6
	v_add_f32_e32 v19, v21, v28
	v_mul_f32_e32 v21, v22, v34
	v_or_b32_e32 v28, 0x400000, v4
	v_mul_f32_e32 v11, v11, v3
	v_bfe_u32 v3, v4, 16, 1
	v_exp_f32_e32 v19, v19
	v_fma_f32 v23, -v20, v21, v22
	v_mov_b16_e32 v17.h, v18.l
	v_bfe_u32 v24, v11, 16, 1
	v_add3_u32 v3, v3, v4, 0x7fff
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_fmac_f32_e32 v21, v23, v34
	v_add3_u32 v23, v24, v11, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_cndmask_b32_e64 v4, v3, v28, s1
	v_ldexp_f32 v19, v19, v27
	v_fma_f32 v3, -v20, v21, v22
	v_and_b32_e32 v22, 0xffff0000, v4
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_div_fmas_f32 v20, v3, v34, v21
	v_or_b32_e32 v21, 0x400000, v11
	v_add_nc_u32_e32 v3, 3, v9
	v_div_fixup_f32 v10, v20, v10, v12
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_ashrrev_i32_e32 v4, 31, v3
	v_mul_f32_e32 v10, v10, v22
	v_cmp_nlt_f32_e64 s1, 0x42ce8ed0, v13
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2b17218, v13
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_lshlrev_b64_e32 v[3:4], 1, v[3:4]
	v_bfe_u32 v18, v10, 16, 1
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v19, 0, v19, s1
	v_cmp_u_f32_e64 s1, v10, v10
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_add3_u32 v18, v18, v10, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v19, 0x7f800000, v19, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	s_delay_alu instid0(VALU_DEP_2)
	v_add_f32_e32 v12, 1.0, v19
	v_bfe_u32 v19, v14, 16, 1
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v20, v23, v21, vcc_lo
	v_or_b32_e32 v21, 0x400000, v14
	v_cmp_u_f32_e32 vcc_lo, v14, v14
	v_div_scale_f32 v11, null, v12, v12, v13
	v_add3_u32 v19, v19, v14, 0x7fff
	v_bfe_u32 v23, v5, 16, 1
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_rcp_f32_e32 v22, v11
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v14, v19, v21, vcc_lo
	v_add_co_u32 v3, vcc_lo, s18, v3
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v4, null, s19, v4, vcc_lo
	v_or_b32_e32 v21, 0x400000, v10
	v_and_b32_e32 v14, 0xffff0000, v14
	v_add3_u32 v10, v23, v5, 0x7fff
	v_fma_f32 v19, -v11, v22, 1.0
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v18, v18, v21, s1
	v_or_b32_e32 v21, 0x400000, v5
	v_cmp_u_f32_e64 s1, v5, v5
	v_fmac_f32_e32 v22, v19, v22
	v_div_scale_f32 v19, vcc_lo, v13, v12, v13
	v_mul_f32_e32 v24, 0xbfb8aa3b, v14
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v5, v10, v21, s1
	v_cmp_u_f32_e64 s1, v15, v15
	v_mul_f32_e32 v23, v19, v22
	v_rndne_f32_e32 v28, v24
	v_fma_f32 v27, 0xbfb8aa3b, v14, -v24
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_fma_f32 v21, -v11, v23, v19
	v_sub_f32_e32 v10, v24, v28
	v_add3_u32 v24, v33, v15, 0x7fff
	v_or_b32_e32 v33, 0x400000, v15
	v_fmac_f32_e32 v27, 0xb2a5705f, v14
	v_fmac_f32_e32 v23, v21, v22
	v_bfe_u32 v21, v16, 16, 1
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v15, v24, v33, s1
	v_or_b32_e32 v24, 0x400000, v16
	v_fma_f32 v11, -v11, v23, v19
	v_add3_u32 v21, v21, v16, 0x7fff
	v_add_f32_e32 v10, v10, v27
	v_cvt_i32_f32_e32 v19, v28
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v11, v11, v22, v23
	v_cmp_u_f32_e32 vcc_lo, v16, v16
	v_exp_f32_e32 v10, v10
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_3) | instid1(VALU_DEP_2)
	v_div_fixup_f32 v12, v11, v12, v13
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v16, v21, v24, vcc_lo
	v_cmp_nlt_f32_e32 vcc_lo, 0x42ce8ed0, v14
	v_and_b32_e32 v16, 0xffff0000, v16
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_ldexp_f32 v10, v10, v19
	v_mul_f32_e32 v22, 0xbfb8aa3b, v16
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_cndmask_b32_e32 v10, 0, v10, vcc_lo
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2b17218, v14
	v_rndne_f32_e32 v27, v22
	v_and_b32_e32 v5, 0xffff0000, v5
	v_fma_f32 v24, 0xbfb8aa3b, v16, -v22
	s_wait_alu depctr_va_vcc(0)
	v_dual_cndmask_b32 v11, 0x7f800000, v10 :: v_dual_add_nc_u32 v10, 4, v9
	v_sub_f32_e32 v22, v22, v27
	v_dual_mul_f32 v12, v12, v5 :: v_dual_and_b32 v15, 0xffff0000, v15
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_add_f32_e32 v23, 1.0, v11
	v_ashrrev_i32_e32 v11, 31, v10
	v_fmac_f32_e32 v24, 0xb2a5705f, v16
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_1) | instid1(VALU_DEP_4)
	v_mul_f32_e32 v19, 0xbfb8aa3b, v15
	v_cmp_ngt_f32_e64 s1, 0xc2b17218, v15
	v_lshlrev_b64_e32 v[10:11], 1, v[10:11]
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_fma_f32 v13, 0xbfb8aa3b, v15, -v19
	v_rndne_f32_e32 v21, v19
	v_add_co_u32 v10, vcc_lo, s18, v10
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_fmac_f32_e32 v13, 0xb2a5705f, v15
	v_sub_f32_e32 v19, v19, v21
	v_cvt_i32_f32_e32 v5, v21
	v_add_f32_e32 v21, v22, v24
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v11, null, s19, v11, vcc_lo
	v_add_f32_e32 v13, v19, v13
	v_div_scale_f32 v19, null, v23, v23, v14
	v_cmp_nlt_f32_e32 vcc_lo, 0x42ce8ed0, v15
	v_exp_f32_e32 v21, v21
	v_bfe_u32 v22, v12, 16, 1
	v_exp_f32_e32 v13, v13
	v_rcp_f32_e32 v28, v19
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(TRANS32_DEP_2)
	v_add3_u32 v22, v22, v12, 0x7fff
	v_ldexp_f32 v5, v13, v5
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_fma_f32 v13, -v19, v28, 1.0
	s_wait_alu depctr_va_vcc(0)
	v_dual_cndmask_b32 v5, 0, v5 :: v_dual_fmac_f32 v28, v13, v28
	v_cvt_i32_f32_e32 v13, v27
	v_div_scale_f32 v24, vcc_lo, v14, v23, v14
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_3)
	v_cndmask_b32_e64 v5, 0x7f800000, v5, s1
	v_cmp_nlt_f32_e64 s1, 0x42ce8ed0, v16
	v_ldexp_f32 v13, v21, v13
	v_mul_f32_e32 v27, v24, v28
	v_or_b32_e32 v21, 0x400000, v12
	v_add_f32_e32 v33, 1.0, v5
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v5, 0, v13, s1
	v_cmp_ngt_f32_e64 s1, 0xc2b17218, v16
	v_bfe_u32 v13, v6, 16, 1
	v_fma_f32 v34, -v19, v27, v24
	v_div_scale_f32 v35, null, v33, v33, v15
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v5, 0x7f800000, v5, s1
	v_add3_u32 v13, v13, v6, 0x7fff
	v_fmac_f32_e32 v27, v34, v28
	v_cmp_u_f32_e64 s1, v6, v6
	v_rcp_f32_e32 v34, v35
	v_add_f32_e32 v37, 1.0, v5
	v_add_nc_u32_e32 v5, 5, v9
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v6, v13, v36, s1
	v_fma_f32 v13, -v19, v27, v24
	v_div_scale_f32 v19, null, v37, v37, v16
	v_cmp_u_f32_e64 s1, v12, v12
	v_or_b32_e32 v36, 0x400000, v7
	v_fma_f32 v24, -v35, v34, 1.0
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v13, v13, v28, v27
	v_rcp_f32_e32 v28, v19
	v_and_b32_e32 v27, 0xffff0000, v6
	v_ashrrev_i32_e32 v6, 31, v5
	v_fmac_f32_e32 v34, v24, v34
	v_div_fixup_f32 v13, v13, v23, v14
	v_div_scale_f32 v14, vcc_lo, v15, v33, v15
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v21, v22, v21, s1
	v_lshlrev_b64_e32 v[5:6], 1, v[5:6]
	v_bfe_u32 v23, v7, 16, 1
	v_dual_mul_f32 v12, v13, v27 :: v_dual_mul_f32 v13, v14, v34
	v_fma_f32 v22, -v19, v28, 1.0
	s_delay_alu instid0(VALU_DEP_4)
	v_add_co_u32 v5, s1, s18, v5
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v6, null, s19, v6, s1
	v_fma_f32 v27, -v35, v13, v14
	v_fmac_f32_e32 v28, v22, v28
	v_div_scale_f32 v22, s1, v16, v37, v16
	v_add3_u32 v23, v23, v7, 0x7fff
	v_bfe_u32 v24, v12, 16, 1
	v_fmac_f32_e32 v13, v27, v34
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_mul_f32_e32 v27, v22, v28
	v_cndmask_b32_e64 v7, v23, v36, s3
	v_bfe_u32 v23, v8, 16, 1
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_2) | instid1(VALU_DEP_4)
	v_fma_f32 v14, -v35, v13, v14
	v_add3_u32 v24, v24, v12, 0x7fff
	v_fma_f32 v35, -v19, v27, v22
	v_add3_u32 v23, v23, v8, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v13, v14, v34, v13
	v_or_b32_e32 v34, 0x400000, v8
	v_fmac_f32_e32 v27, v35, v28
	v_cmp_u_f32_e32 vcc_lo, v8, v8
	v_and_b32_e32 v14, 0xffff0000, v7
	v_div_fixup_f32 v13, v13, v33, v15
	v_add_nc_u32_e32 v7, 6, v9
	v_fma_f32 v15, -v19, v27, v22
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v19, v23, v34, vcc_lo
	s_mov_b32 vcc_lo, s1
	v_mul_f32_e32 v14, v13, v14
	v_ashrrev_i32_e32 v8, 31, v7
	s_wait_alu depctr_sa_sdst(0)
	v_div_fmas_f32 v15, v15, v28, v27
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
	global_store_d16_hi_b16 v[1:2], v20, off offset:1028
	global_store_b32 v[1:2], v17, off offset:1024
	global_store_d16_hi_b16 v[3:4], v18, off offset:1024
	global_store_d16_hi_b16 v[10:11], v21, off offset:1024
	global_store_d16_hi_b16 v[5:6], v22, off offset:1024
	global_store_d16_hi_b16 v[7:8], v14, off offset:1024
	global_store_d16_hi_b16 v[12:13], v9, off offset:1024
	s_branch .LBB0_41
.LBB0_48:
	s_cbranch_execz .LBB0_27
.LBB0_49:
	v_dual_mov_b32 v4, 1 :: v_dual_mov_b32 v5, 0
	s_mov_b32 s0, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v1, v5, v[4:5], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_51
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v2, ttmp9 :: v_dual_mov_b32 v1, v4
	global_store_b96 v5, v[1:3], s[22:23] offset:4
.LBB0_51:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s0
	s_and_not1_saveexec_b32 s0, s4
	s_cbranch_execnz .LBB0_28
	s_branch .LBB0_29
.LBB0_52:
	s_cbranch_execz .LBB0_56
.LBB0_53:
	v_dual_mov_b32 v4, 1 :: v_dual_mov_b32 v5, 0
	s_mov_b32 s0, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v1, v5, v[4:5], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_55
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v2, ttmp9 :: v_dual_mov_b32 v1, 2
	global_store_b96 v5, v[1:3], s[22:23] offset:4
.LBB0_55:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s0
.LBB0_56:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s0, s3
	s_cbranch_execz .LBB0_58
	v_dual_mov_b32 v1, 0 :: v_dual_add_nc_u32 v2, 1, v3
	global_store_b32 v1, v1, s[20:21] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v1, v2, s[20:21] offset:4 scope:SCOPE_DEV
.LBB0_58:
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
.LBB0_59:
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
	s_cbranch_vccnz .LBB0_213
	s_cmp_gt_i32 s4, 1
	s_cbranch_scc1 .LBB0_67
	v_mov_b32_e32 v1, 0
	v_lshlrev_b32_e32 v15, 5, v29
	v_cmp_gt_i32_e32 vcc_lo, s28, v29
	global_load_b64 v[1:2], v1, s[26:27]
	v_lshl_or_b32 v3, v30, 1, v15
	s_wait_loadcnt 0x0
	v_add_co_u32 v16, s0, 0x200, v1
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v17, null, 0, v2, s0
	v_add_co_u32 v13, s0, s18, v3
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v14, null, s19, 0, s0
	s_branch .LBB0_63
.LBB0_62:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s1
	s_add_co_i32 s0, s4, 16
	s_cmp_lt_i32 s4, -14
	s_wait_alu depctr_sa_sdst(0)
	s_mov_b32 s4, s0
	s_cbranch_scc0 .LBB0_67
.LBB0_63:
	v_dual_mov_b32 v9, 0 :: v_dual_mov_b32 v10, 0
	v_dual_mov_b32 v11, 0 :: v_dual_mov_b32 v12, 0
	s_and_saveexec_b32 s0, vcc_lo
	s_cbranch_execz .LBB0_65
	global_load_b128 v[9:12], v[13:14], off offset:1024
.LBB0_65:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s0
	s_lshl_b32 s3, s4, 4
	s_wait_alu depctr_sa_sdst(0)
	v_or_b32_e32 v1, s3, v29
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshl_or_b32 v1, v1, 4, v30
	v_ashrrev_i32_e32 v2, 31, v1
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshlrev_b64_e32 v[1:2], 1, v[1:2]
	v_add_co_u32 v1, s0, s12, v1
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_add_co_ci_u32_e64 v2, null, s13, v2, s0
	global_load_b128 v[18:21], v[1:2], off
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[1:8], v[18:21], v[9:12], 0
	s_and_saveexec_b32 s1, vcc_lo
	s_cbranch_execz .LBB0_62
	v_or_b32_e32 v9, s3, v30
	s_delay_alu instid0(VALU_DEP_2)
	v_bfe_u32 v10, v1, 16, 1
	v_or_b32_e32 v11, 0x400000, v1
	v_bfe_u32 v12, v2, 16, 1
	v_cmp_u_f32_e64 s0, v1, v1
	v_add_nc_u32_e32 v9, v9, v15
	v_add3_u32 v21, v10, v1, 0x7fff
	v_or_b32_e32 v18, 0x400000, v2
	v_add3_u32 v12, v12, v2, 0x7fff
	v_bfe_u32 v19, v3, 16, 1
	v_ashrrev_i32_e32 v10, 31, v9
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v1, v21, v11, s0
	v_cmp_u_f32_e64 s0, v2, v2
	v_or_b32_e32 v20, 0x400000, v3
	v_add3_u32 v11, v19, v3, 0x7fff
	v_lshlrev_b64_e32 v[9:10], 1, v[9:10]
	v_bfe_u32 v22, v4, 16, 1
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v2, v12, v18, s0
	v_or_b32_e32 v18, 0x400000, v4
	v_bfe_u32 v19, v5, 16, 1
	v_bfe_u32 v21, v7, 16, 1
	v_add_co_u32 v9, s0, v16, v9
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v10, null, v17, v10, s0
	v_cmp_u_f32_e64 s0, v3, v3
	v_add3_u32 v12, v22, v4, 0x7fff
	v_or_b32_e32 v22, 0x400000, v8
	v_lshrrev_b32_e32 v1, 16, v1
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v3, v11, v20, s0
	v_lshrrev_b32_e32 v11, 16, v2
	v_cmp_u_f32_e64 s0, v4, v4
	v_or_b32_e32 v20, 0x400000, v6
	s_delay_alu instid0(VALU_DEP_4)
	v_lshrrev_b32_e32 v2, 16, v3
	v_bfe_u32 v3, v6, 16, 1
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v4, v12, v18, s0
	v_bfe_u32 v18, v8, 16, 1
	v_cmp_u_f32_e64 s0, v6, v6
	v_add3_u32 v12, v19, v5, 0x7fff
	v_add3_u32 v3, v3, v6, 0x7fff
	v_or_b32_e32 v19, 0x400000, v5
	v_add3_u32 v18, v18, v8, 0x7fff
	v_add3_u32 v6, v21, v7, 0x7fff
	v_mov_b16_e32 v1.h, v11.l
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v3, v3, v20, s0
	v_cmp_u_f32_e64 s0, v8, v8
	v_or_b32_e32 v20, 0x400000, v7
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_2) | instid1(VALU_DEP_1)
	v_cndmask_b32_e64 v8, v18, v22, s0
	v_cmp_u_f32_e64 s0, v5, v5
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v5, v12, v19, s0
	v_cmp_u_f32_e64 s0, v7, v7
	v_lshrrev_b32_e32 v7, 16, v8
	v_lshrrev_b32_e32 v8, 16, v3
	v_lshrrev_b32_e32 v12, 16, v4
	v_lshrrev_b32_e32 v3, 16, v5
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v6, v6, v20, s0
	v_mov_b16_e32 v3.h, v8.l
	v_mov_b16_e32 v2.h, v12.l
	s_delay_alu instid0(VALU_DEP_3)
	v_lshrrev_b32_e32 v4, 16, v6
	v_mov_b16_e32 v4.h, v7.l
	global_store_b128 v[9:10], v[1:4], off
	s_branch .LBB0_62
.LBB0_67:
	s_cmp_eq_u32 ttmp9, s38
	s_cbranch_scc1 .LBB0_213
	v_mov_b32_e32 v1, 0
	global_load_b64 v[4:5], v1, s[26:27]
	s_wait_loadcnt 0x0
	global_load_b32 v2, v[4:5], off offset:256 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	s_barrier_signal -1
	v_readfirstlane_b32 s3, v2
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s1, s2
	s_cbranch_execz .LBB0_83
	global_load_b32 v3, v1, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	s_mov_b32 s4, exec_lo
	s_mov_b32 s0, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	v_mbcnt_lo_u32_b32 v1, s4, 0
	s_delay_alu instid0(VALU_DEP_1)
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_71
	s_bcnt1_i32_b32 s4, s4
	v_mov_b32_e32 v2, 0
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v6, s4
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v2, v2, v6, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_71:
	s_or_b32 exec_lo, exec_lo, s0
	v_readfirstlane_b32 s0, v2
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v1, s0, v1
	s_mov_b32 s0, exec_lo
	v_cmpx_ne_u32_e32 3, v1
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s4, exec_lo, s0
	s_cbranch_execz .LBB0_80
	s_cmp_lt_i32 s30, 1
	s_mov_b32 s5, 1
	s_cbranch_scc1 .LBB0_75
	v_mov_b32_e32 v1, 0
.LBB0_74:
	global_load_b32 v2, v1, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	global_load_b32 v6, v1, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, v2, v3
	v_cmp_eq_u32_e64 s0, 0, v6
	s_and_b32 s0, vcc_lo, s0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s5, s30
	s_cselect_b32 s6, -1, 0
	s_add_co_i32 s5, s5, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s6, s0, s6
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s6
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_74
	s_branch .LBB0_76
.LBB0_75:
	s_mov_b32 s0, -1
.LBB0_76:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s0
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccz .LBB0_80
	v_dual_mov_b32 v6, 1 :: v_dual_mov_b32 v7, 0
	s_mov_b32 s0, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v1, v7, v[6:7], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_79
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v2, ttmp9 :: v_dual_mov_b32 v1, 20
	global_store_b96 v7, v[1:3], s[22:23] offset:4
.LBB0_79:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s0
.LBB0_80:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s0, s4
	s_cbranch_execz .LBB0_82
	v_dual_mov_b32 v1, 0 :: v_dual_add_nc_u32 v2, 1, v3
	global_store_b32 v1, v1, s[20:21] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v1, v2, s[20:21] offset:4 scope:SCOPE_DEV
.LBB0_82:
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
.LBB0_83:
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
	s_cbranch_vccnz .LBB0_213
	v_or_b32_e32 v1, ttmp9, v0
	s_add_co_i32 s3, s3, 1
	s_delay_alu instid0(VALU_DEP_1)
	v_cmp_eq_u32_e64 s0, 0, v1
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_121
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v1, s3
	s_cmp_gt_i32 s30, 0
	s_cselect_b32 s4, -1, 0
	s_cmp_lt_i32 s30, 1
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[4:5], v1, off scope:SCOPE_SYS
	s_cbranch_scc1 .LBB0_89
	v_mov_b32_e32 v3, 0
	s_mov_b32 s5, 1
	global_load_b64 v[1:2], v3, s[26:27]
.LBB0_87:
	s_wait_loadcnt 0x0
	global_load_b32 v6, v[1:2], off scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v7, v[1:2], off offset:384 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v8, v3, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s8, v6
	v_readfirstlane_b32 s7, v7
	v_readfirstlane_b32 s6, v8
	s_or_b32 s6, s6, s7
	s_cmp_lg_u32 s8, s3
	s_cselect_b32 s7, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s5, s30
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
	s_cbranch_vccnz .LBB0_87
	s_cmp_lg_u32 s6, 0
	s_cselect_b32 s5, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s5, s7, s5
	s_branch .LBB0_90
.LBB0_89:
	s_mov_b32 s5, -1
.LBB0_90:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s5, s5, exec_lo
	s_cselect_b32 s5, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s5, 1
	s_cbranch_scc1 .LBB0_94
	v_dual_mov_b32 v1, 1 :: v_dual_mov_b32 v2, 0
	s_mov_b32 s5, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v3, v2, v[1:2], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v3
	s_cbranch_execz .LBB0_93
	v_dual_mov_b32 v6, 30 :: v_dual_mov_b32 v7, v2
	v_mov_b32_e32 v8, s3
	global_store_b96 v2, v[6:8], s[22:23] offset:4
.LBB0_93:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s5
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[4:5], v1, off offset:384 scope:SCOPE_SYS
.LBB0_94:
	s_and_b32 s5, s4, exec_lo
	s_cselect_b32 s5, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s5, 1
	s_cbranch_scc1 .LBB0_98
	v_mov_b32_e32 v3, 0
	s_mov_b32 s5, 1
	global_load_b64 v[1:2], v3, s[26:27] offset:8
.LBB0_96:
	s_wait_loadcnt 0x0
	global_load_b32 v6, v[1:2], off scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v7, v[1:2], off offset:384 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v8, v3, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s8, v6
	v_readfirstlane_b32 s7, v7
	v_readfirstlane_b32 s6, v8
	s_or_b32 s6, s6, s7
	s_cmp_lg_u32 s8, s3
	s_cselect_b32 s7, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s5, s30
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
	s_cbranch_vccnz .LBB0_96
	s_cmp_lg_u32 s6, 0
	s_cselect_b32 s5, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s5, s7, s5
	s_branch .LBB0_99
.LBB0_98:
	s_mov_b32 s5, -1
.LBB0_99:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s5, s5, exec_lo
	s_cselect_b32 s5, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s5, 1
	s_cbranch_scc1 .LBB0_103
	v_dual_mov_b32 v1, 1 :: v_dual_mov_b32 v2, 0
	s_mov_b32 s5, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v3, v2, v[1:2], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v3
	s_cbranch_execz .LBB0_102
	v_dual_mov_b32 v6, 30 :: v_dual_mov_b32 v7, v2
	v_mov_b32_e32 v8, s3
	global_store_b96 v2, v[6:8], s[22:23] offset:4
.LBB0_102:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s5
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[4:5], v1, off offset:384 scope:SCOPE_SYS
.LBB0_103:
	s_and_b32 s5, s4, exec_lo
	s_cselect_b32 s5, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s5, 1
	s_cbranch_scc1 .LBB0_107
	v_mov_b32_e32 v3, 0
	s_mov_b32 s5, 1
	global_load_b64 v[1:2], v3, s[26:27] offset:16
.LBB0_105:
	s_wait_loadcnt 0x0
	global_load_b32 v6, v[1:2], off scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v7, v[1:2], off offset:384 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v8, v3, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s8, v6
	v_readfirstlane_b32 s7, v7
	v_readfirstlane_b32 s6, v8
	s_or_b32 s6, s6, s7
	s_cmp_lg_u32 s8, s3
	s_cselect_b32 s7, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s5, s30
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
	s_cbranch_vccnz .LBB0_105
	s_cmp_lg_u32 s6, 0
	s_cselect_b32 s5, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s5, s7, s5
	s_branch .LBB0_108
.LBB0_107:
	s_mov_b32 s5, -1
.LBB0_108:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s5, s5, exec_lo
	s_cselect_b32 s5, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s5, 1
	s_cbranch_scc1 .LBB0_112
	v_dual_mov_b32 v1, 1 :: v_dual_mov_b32 v2, 0
	s_mov_b32 s5, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v3, v2, v[1:2], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v3
	s_cbranch_execz .LBB0_111
	v_dual_mov_b32 v6, 30 :: v_dual_mov_b32 v7, v2
	v_mov_b32_e32 v8, s3
	global_store_b96 v2, v[6:8], s[22:23] offset:4
.LBB0_111:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s5
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[4:5], v1, off offset:384 scope:SCOPE_SYS
.LBB0_112:
	s_and_b32 s4, s4, exec_lo
	s_cselect_b32 s4, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s4, 1
	s_cbranch_scc1 .LBB0_116
	v_mov_b32_e32 v3, 0
	s_mov_b32 s4, 1
	global_load_b64 v[1:2], v3, s[26:27] offset:24
.LBB0_114:
	s_wait_loadcnt 0x0
	global_load_b32 v6, v[1:2], off scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v7, v[1:2], off offset:384 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v8, v3, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s7, v6
	v_readfirstlane_b32 s6, v7
	v_readfirstlane_b32 s5, v8
	s_or_b32 s5, s5, s6
	s_cmp_lg_u32 s7, s3
	s_cselect_b32 s6, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s4, s30
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
	s_cbranch_vccnz .LBB0_114
	s_cmp_lg_u32 s5, 0
	s_cselect_b32 s4, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s4, s6, s4
	s_branch .LBB0_117
.LBB0_116:
	s_mov_b32 s4, -1
.LBB0_117:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s4, s4, exec_lo
	s_cselect_b32 s4, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s4, 1
	s_cbranch_scc1 .LBB0_121
	v_dual_mov_b32 v1, 1 :: v_dual_mov_b32 v2, 0
	s_mov_b32 s4, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v3, v2, v[1:2], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v3
	s_cbranch_execz .LBB0_120
	v_dual_mov_b32 v6, 30 :: v_dual_mov_b32 v7, v2
	v_mov_b32_e32 v8, s3
	global_store_b96 v2, v[6:8], s[22:23] offset:4
.LBB0_120:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[4:5], v1, off offset:384 scope:SCOPE_SYS
.LBB0_121:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s1
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s1, s2
	s_cbranch_execz .LBB0_136
	v_mov_b32_e32 v2, 0
	s_mov_b32 s5, exec_lo
	s_mov_b32 s6, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	v_mbcnt_lo_u32_b32 v1, s5, 0
	global_load_b32 v3, v2, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s4, v3
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_124
	s_bcnt1_i32_b32 s5, s5
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v3, s5
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v3, v2, v3, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_124:
	s_or_b32 exec_lo, exec_lo, s6
	v_readfirstlane_b32 s5, v3
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v1, s5, v1
	s_mov_b32 s5, exec_lo
	v_cmpx_ne_u32_e32 3, v1
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s5, exec_lo, s5
	s_cbranch_execz .LBB0_133
	s_cmp_lt_i32 s30, 1
	s_mov_b32 s6, 1
	s_cbranch_scc1 .LBB0_128
	v_mov_b32_e32 v1, 0
.LBB0_127:
	global_load_b32 v2, v1, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	global_load_b32 v3, v1, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s7, v2
	v_readfirstlane_b32 s8, v3
	s_cmp_eq_u32 s7, s4
	s_cselect_b32 s7, -1, 0
	s_cmp_eq_u32 s8, 0
	s_cselect_b32 s8, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s7, s7, s8
	s_cmp_lt_i32 s6, s30
	s_cselect_b32 s8, -1, 0
	s_add_co_i32 s6, s6, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s8, s7, s8
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s8
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_127
	s_branch .LBB0_129
.LBB0_128:
	s_mov_b32 s7, -1
.LBB0_129:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s6, s7, exec_lo
	s_cselect_b32 s6, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s6, 1
	s_cbranch_scc1 .LBB0_133
	v_dual_mov_b32 v1, 1 :: v_dual_mov_b32 v2, 0
	s_mov_b32 s6, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v1, v2, v[1:2], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_132
	v_dual_mov_b32 v7, ttmp9 :: v_dual_mov_b32 v6, 21
	v_mov_b32_e32 v8, s4
	global_store_b96 v2, v[6:8], s[22:23] offset:4
.LBB0_132:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
.LBB0_133:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s5, s5
	s_cbranch_execz .LBB0_135
	s_add_co_i32 s4, s4, 1
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v1, 0 :: v_dual_mov_b32 v2, s4
	global_store_b32 v1, v1, s[20:21] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v1, v2, s[20:21] offset:4 scope:SCOPE_DEV
.LBB0_135:
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
.LBB0_136:
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
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	ds_load_b32 v1, v1 offset:20
	s_wait_dscnt 0x0
	v_cmp_eq_u32_e32 vcc_lo, 0, v1
	s_cbranch_vccnz .LBB0_213
	v_lshl_or_b32 v0, ttmp9, 7, v0
	s_lshl_b32 s4, s28, 5
	s_mov_b32 s5, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	s_delay_alu instid0(VALU_DEP_1)
	v_cmpx_gt_i32_e32 s4, v0
	s_cbranch_execz .LBB0_142
	v_mov_b32_e32 v3, 0
	s_cmp_lg_u32 s37, 0
	s_mov_b32 s6, 0
	s_cselect_b32 s7, -1, 0
	s_branch .LBB0_140
.LBB0_139:
	v_add_nc_u32_e32 v0, 0x200, v0
	v_add_co_u32 v1, s1, s14, v1
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v2, null, s15, v2, s1
	s_delay_alu instid0(VALU_DEP_3)
	v_cmp_le_i32_e32 vcc_lo, s4, v0
	global_store_b16 v[1:2], v6, off
	s_or_b32 s6, vcc_lo, s6
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_b32 exec_lo, exec_lo, s6
	s_cbranch_execz .LBB0_142
.LBB0_140:
	s_clause 0x1
	global_load_b128 v[6:9], v3, s[26:27]
	global_load_b128 v[10:13], v3, s[26:27] offset:16
	v_ashrrev_i32_e32 v1, 31, v0
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s1, s7, exec_lo
	s_cselect_b32 s1, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s1, 1
	v_lshlrev_b64_e32 v[1:2], 1, v[0:1]
	s_wait_loadcnt 0x1
	v_add_co_u32 v6, vcc_lo, 0x200, v6
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v7, null, 0, v7, vcc_lo
	v_add_co_u32 v8, vcc_lo, 0x200, v8
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v9, null, 0, v9, vcc_lo
	s_wait_loadcnt 0x0
	v_add_co_u32 v10, vcc_lo, 0x200, v10
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v11, null, 0, v11, vcc_lo
	v_add_co_u32 v12, vcc_lo, 0x200, v12
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v13, null, 0, v13, vcc_lo
	v_add_co_u32 v6, vcc_lo, v6, v1
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v7, null, v7, v2, vcc_lo
	v_add_co_u32 v8, vcc_lo, v8, v1
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v9, null, v9, v2, vcc_lo
	global_load_u16 v14, v[6:7], off
	v_add_co_u32 v6, vcc_lo, v10, v1
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v7, null, v11, v2, vcc_lo
	global_load_u16 v10, v[8:9], off
	v_add_co_u32 v8, vcc_lo, v12, v1
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v9, null, v13, v2, vcc_lo
	global_load_u16 v6, v[6:7], off
	global_load_u16 v7, v[8:9], off
	s_wait_loadcnt 0x3
	v_lshlrev_b32_e32 v8, 16, v14
	s_wait_loadcnt 0x2
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_3) | instid1(VALU_DEP_2)
	v_dual_add_f32 v8, 0, v8 :: v_dual_lshlrev_b32 v9, 16, v10
	s_wait_loadcnt 0x1
	v_lshlrev_b32_e32 v6, 16, v6
	s_wait_loadcnt 0x0
	v_dual_add_f32 v8, v8, v9 :: v_dual_lshlrev_b32 v7, 16, v7
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v6, v8, v6
	v_add_f32_e32 v6, v6, v7
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v7, v6, 16, 1
	v_or_b32_e32 v8, 0x400000, v6
	v_cmp_u_f32_e32 vcc_lo, v6, v6
	v_add3_u32 v7, v7, v6, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_cndmask_b32_e32 v6, v7, v8, vcc_lo
	v_lshrrev_b32_e32 v6, 16, v6
	s_cbranch_scc1 .LBB0_139
	v_ashrrev_i32_e32 v7, 31, v0
	v_mov_b16_e32 v9.l, 0
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_lshlrev_b32_e32 v6, 16, v6
	v_lshrrev_b32_e32 v7, 27, v7
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v7, v0, v7
	v_and_b32_e32 v7, 0xffffffe0, v7
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_sub_nc_u32_e32 v7, v0, v7
	v_ashrrev_i32_e32 v8, 31, v7
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshlrev_b64_e32 v[7:8], 1, v[7:8]
	v_add_co_u32 v7, vcc_lo, s34, v7
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_3) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v8, null, s35, v8, vcc_lo
	global_load_d16_hi_b16 v9, v[7:8], off
	s_wait_loadcnt 0x0
	v_add_f32_e32 v7, 1.0, v9
	v_bfe_u32 v8, v7, 16, 1
	v_or_b32_e32 v9, 0x400000, v7
	v_cmp_u_f32_e32 vcc_lo, v7, v7
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add3_u32 v8, v8, v7, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v7, v8, v9, vcc_lo
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_and_b32_e32 v7, 0xffff0000, v7
	v_mul_f32_e32 v6, v7, v6
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_bfe_u32 v7, v6, 16, 1
	v_or_b32_e32 v8, 0x400000, v6
	v_cmp_u_f32_e32 vcc_lo, v6, v6
	v_add3_u32 v7, v7, v6, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_cndmask_b32_e32 v6, v7, v8, vcc_lo
	v_lshrrev_b32_e32 v6, 16, v6
	s_branch .LBB0_139
.LBB0_142:
	s_or_b32 exec_lo, exec_lo, s5
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_inv scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s1, s2
	s_cbranch_execz .LBB0_157
	v_mov_b32_e32 v1, 0
	s_mov_b32 s5, exec_lo
	s_mov_b32 s6, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	v_mbcnt_lo_u32_b32 v0, s5, 0
	global_load_b32 v2, v1, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s4, v2
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_145
	s_bcnt1_i32_b32 s5, s5
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v2, s5
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v2, v1, v2, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_145:
	s_or_b32 exec_lo, exec_lo, s6
	v_readfirstlane_b32 s5, v2
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v0, s5, v0
	s_mov_b32 s5, exec_lo
	v_cmpx_ne_u32_e32 3, v0
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s5, exec_lo, s5
	s_cbranch_execz .LBB0_154
	s_cmp_lt_i32 s30, 1
	s_mov_b32 s6, 1
	s_cbranch_scc1 .LBB0_149
	v_mov_b32_e32 v0, 0
.LBB0_148:
	global_load_b32 v1, v0, s[20:21] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	global_load_b32 v2, v0, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s7, v1
	v_readfirstlane_b32 s8, v2
	s_cmp_eq_u32 s7, s4
	s_cselect_b32 s7, -1, 0
	s_cmp_eq_u32 s8, 0
	s_cselect_b32 s8, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s7, s7, s8
	s_cmp_lt_i32 s6, s30
	s_cselect_b32 s8, -1, 0
	s_add_co_i32 s6, s6, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s8, s7, s8
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s8
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_148
	s_branch .LBB0_150
.LBB0_149:
	s_mov_b32 s7, -1
.LBB0_150:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s6, s7, exec_lo
	s_cselect_b32 s6, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s6, 1
	s_cbranch_scc1 .LBB0_154
	v_dual_mov_b32 v0, 1 :: v_dual_mov_b32 v1, 0
	s_mov_b32 s6, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v0, v1, v[0:1], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_153
	v_dual_mov_b32 v7, ttmp9 :: v_dual_mov_b32 v6, 22
	v_mov_b32_e32 v8, s4
	global_store_b96 v1, v[6:8], s[22:23] offset:4
.LBB0_153:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
.LBB0_154:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s5, s5
	s_cbranch_execz .LBB0_156
	s_add_co_i32 s4, s4, 1
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v0, 0 :: v_dual_mov_b32 v1, s4
	global_store_b32 v0, v0, s[20:21] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v0, v1, s[20:21] offset:4 scope:SCOPE_DEV
.LBB0_156:
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
.LBB0_157:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s1
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
	s_cbranch_vccnz .LBB0_213
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_197
	v_mov_b32_e32 v0, s3
	s_cmp_gt_i32 s30, 0
	s_mov_b32 s4, 1
	s_cselect_b32 s0, -1, 0
	s_cmp_lt_i32 s30, 1
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[4:5], v0, off offset:128 scope:SCOPE_SYS
	s_cbranch_scc1 .LBB0_163
	v_mov_b32_e32 v2, 0
	global_load_b64 v[0:1], v2, s[26:27]
.LBB0_161:
	s_wait_loadcnt 0x0
	global_load_b32 v3, v[0:1], off offset:128 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v6, v[0:1], off offset:384 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v7, v2, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s7, v3
	v_readfirstlane_b32 s6, v6
	v_readfirstlane_b32 s5, v7
	s_or_b32 s5, s5, s6
	s_cmp_lg_u32 s7, s3
	s_cselect_b32 s6, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s4, s30
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
	s_cbranch_vccnz .LBB0_161
	s_cmp_lg_u32 s5, 0
	s_cselect_b32 s4, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s4, s6, s4
	s_branch .LBB0_164
.LBB0_163:
	s_mov_b32 s4, -1
.LBB0_164:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s4, s4, exec_lo
	s_cselect_b32 s4, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s4, 1
	s_cbranch_scc1 .LBB0_168
	v_dual_mov_b32 v0, 1 :: v_dual_mov_b32 v1, 0
	s_mov_b32 s4, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v2, v1, v[0:1], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v2
	s_cbranch_execz .LBB0_167
	v_dual_mov_b32 v6, 31 :: v_dual_mov_b32 v7, v1
	v_mov_b32_e32 v8, s3
	global_store_b96 v1, v[6:8], s[22:23] offset:4
.LBB0_167:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[4:5], v0, off offset:384 scope:SCOPE_SYS
.LBB0_168:
	s_and_b32 s4, s0, exec_lo
	s_cselect_b32 s4, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s4, 1
	s_cbranch_scc1 .LBB0_172
	v_mov_b32_e32 v2, 0
	s_mov_b32 s4, 1
	global_load_b64 v[0:1], v2, s[26:27] offset:8
.LBB0_170:
	s_wait_loadcnt 0x0
	global_load_b32 v3, v[0:1], off offset:128 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v6, v[0:1], off offset:384 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v7, v2, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s7, v3
	v_readfirstlane_b32 s6, v6
	v_readfirstlane_b32 s5, v7
	s_or_b32 s5, s5, s6
	s_cmp_lg_u32 s7, s3
	s_cselect_b32 s6, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s4, s30
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
	s_cbranch_vccnz .LBB0_170
	s_cmp_lg_u32 s5, 0
	s_cselect_b32 s4, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s4, s6, s4
	s_branch .LBB0_173
.LBB0_172:
	s_mov_b32 s4, -1
.LBB0_173:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s4, s4, exec_lo
	s_cselect_b32 s4, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s4, 1
	s_cbranch_scc1 .LBB0_177
	v_dual_mov_b32 v0, 1 :: v_dual_mov_b32 v1, 0
	s_mov_b32 s4, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v2, v1, v[0:1], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v2
	s_cbranch_execz .LBB0_176
	v_dual_mov_b32 v6, 31 :: v_dual_mov_b32 v7, v1
	v_mov_b32_e32 v8, s3
	global_store_b96 v1, v[6:8], s[22:23] offset:4
.LBB0_176:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[4:5], v0, off offset:384 scope:SCOPE_SYS
.LBB0_177:
	s_and_b32 s4, s0, exec_lo
	s_cselect_b32 s4, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s4, 1
	s_cbranch_scc1 .LBB0_181
	v_mov_b32_e32 v2, 0
	s_mov_b32 s4, 1
	global_load_b64 v[0:1], v2, s[26:27] offset:16
.LBB0_179:
	s_wait_loadcnt 0x0
	global_load_b32 v3, v[0:1], off offset:128 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v6, v[0:1], off offset:384 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v7, v2, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s7, v3
	v_readfirstlane_b32 s6, v6
	v_readfirstlane_b32 s5, v7
	s_or_b32 s5, s5, s6
	s_cmp_lg_u32 s7, s3
	s_cselect_b32 s6, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s4, s30
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
	s_cbranch_vccnz .LBB0_179
	s_cmp_lg_u32 s5, 0
	s_cselect_b32 s4, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s4, s6, s4
	s_branch .LBB0_182
.LBB0_181:
	s_mov_b32 s4, -1
.LBB0_182:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s4, s4, exec_lo
	s_cselect_b32 s4, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s4, 1
	s_cbranch_scc1 .LBB0_186
	v_dual_mov_b32 v0, 1 :: v_dual_mov_b32 v1, 0
	s_mov_b32 s4, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v2, v1, v[0:1], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v2
	s_cbranch_execz .LBB0_185
	v_dual_mov_b32 v6, 31 :: v_dual_mov_b32 v7, v1
	v_mov_b32_e32 v8, s3
	global_store_b96 v1, v[6:8], s[22:23] offset:4
.LBB0_185:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[4:5], v0, off offset:384 scope:SCOPE_SYS
.LBB0_186:
	s_and_b32 s0, s0, exec_lo
	s_cselect_b32 s0, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s0, 1
	s_cbranch_scc1 .LBB0_190
	v_mov_b32_e32 v2, 0
	s_mov_b32 s0, 1
	global_load_b64 v[0:1], v2, s[26:27] offset:24
.LBB0_188:
	s_wait_loadcnt 0x0
	global_load_b32 v3, v[0:1], off offset:128 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v6, v[0:1], off offset:384 scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_SYS
	global_load_b32 v7, v2, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_readfirstlane_b32 s6, v3
	v_readfirstlane_b32 s5, v6
	v_readfirstlane_b32 s4, v7
	s_or_b32 s4, s4, s5
	s_cmp_lg_u32 s6, s3
	s_cselect_b32 s5, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s0, s30
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
	s_cbranch_vccnz .LBB0_188
	s_cmp_lg_u32 s4, 0
	s_cselect_b32 s0, -1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s0, s5, s0
	s_branch .LBB0_191
.LBB0_190:
	s_mov_b32 s0, -1
.LBB0_191:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s0, s0, exec_lo
	s_cselect_b32 s0, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s0, 1
	s_cbranch_scc1 .LBB0_195
	v_dual_mov_b32 v0, 1 :: v_dual_mov_b32 v1, 0
	s_mov_b32 s0, exec_lo
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_atomic_cmpswap_b32 v2, v1, v[0:1], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v2
	s_cbranch_execz .LBB0_194
	v_dual_mov_b32 v6, 31 :: v_dual_mov_b32 v7, v1
	v_mov_b32_e32 v8, s3
	global_store_b96 v1, v[6:8], s[22:23] offset:4
.LBB0_194:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s0
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[4:5], v0, off offset:384 scope:SCOPE_SYS
.LBB0_195:
	v_mov_b32_e32 v0, 0
	global_load_b32 v0, v0, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_ne_u32_e32 vcc_lo, 0, v0
	s_cbranch_vccnz .LBB0_197
	v_mov_b32_e32 v0, s3
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[4:5], v0, off offset:256 scope:SCOPE_SYS
.LBB0_197:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s1
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s0, s2
	s_cbranch_execz .LBB0_212
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
	s_cbranch_execz .LBB0_200
	s_bcnt1_i32_b32 s3, s3
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v2, s3
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v2, v1, v2, s[20:21] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_200:
	s_or_b32 exec_lo, exec_lo, s4
	v_readfirstlane_b32 s3, v2
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v0, s3, v0
	s_mov_b32 s3, exec_lo
	v_cmpx_ne_u32_e32 3, v0
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s3, exec_lo, s3
	s_cbranch_execz .LBB0_209
	s_cmp_lt_i32 s30, 1
	s_mov_b32 s4, 1
	s_cbranch_scc1 .LBB0_204
	v_mov_b32_e32 v0, 0
.LBB0_203:
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
	s_cmp_lt_i32 s4, s30
	s_cselect_b32 s6, -1, 0
	s_add_co_i32 s4, s4, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s6, s5, s6
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s6
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_203
	s_branch .LBB0_205
.LBB0_204:
	s_mov_b32 s5, -1
.LBB0_205:
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s4, s5, exec_lo
	s_cselect_b32 s4, 1, 0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s4, 1
	s_cbranch_scc1 .LBB0_209
	v_dual_mov_b32 v0, 1 :: v_dual_mov_b32 v1, 0
	s_mov_b32 s4, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v0, v1, v[0:1], s[22:23] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_208
	v_dual_mov_b32 v3, ttmp9 :: v_dual_mov_b32 v2, 23
	v_mov_b32_e32 v4, s1
	global_store_b96 v1, v[2:4], s[22:23] offset:4
.LBB0_208:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s4
.LBB0_209:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s3, s3
	s_cbranch_execz .LBB0_211
	s_add_co_i32 s1, s1, 1
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v0, 0 :: v_dual_mov_b32 v1, s1
	global_store_b32 v0, v0, s[20:21] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v0, v1, s[20:21] offset:4 scope:SCOPE_DEV
.LBB0_211:
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
.LBB0_212:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s0
	s_wait_storecnt 0x0
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_213:
	s_and_saveexec_b32 s0, s2
	s_cbranch_execz .LBB0_216
	v_mov_b32_e32 v0, 0
	s_wait_kmcnt 0x0
	global_load_b32 v1, v0, s[22:23] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, 0, v1
	s_cbranch_vccnz .LBB0_216
	global_load_b64 v[0:1], v0, s[26:27]
	v_mov_b32_e32 v2, 1
	global_wb scope:SCOPE_SYS
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v[0:1], v2, off offset:384 scope:SCOPE_SYS
.LBB0_216:
	s_endpgm
.Lfunc_end0:
	.size	qwen_bf16_ffnar_v1_h32_i16_b4_tp4r0_a0_f1, .Lfunc_end0-qwen_bf16_ffnar_v1_h32_i16_b4_tp4r0_a0_f1
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel qwen_bf16_ffnar_v1_h32_i16_b4_tp4r0_a0_f1
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
		.amdhsa_next_free_sgpr 43
		.amdhsa_reserve_vcc 1
		.amdhsa_float_round_mode_32 0
		.amdhsa_float_round_mode_16_64 0
		.amdhsa_float_denorm_mode_32 3
		.amdhsa_float_denorm_mode_16_64 3
		.amdhsa_fp16_overflow 0
		.amdhsa_workgroup_processor_mode 1
		.amdhsa_memory_ordered 1
		.amdhsa_forward_progress 1
		.amdhsa_inst_pref_size ((instprefsize(.Lfunc_end0-qwen_bf16_ffnar_v1_h32_i16_b4_tp4r0_a0_f1)<<4)&4080)>>4
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

	.set .Lqwen_bf16_ffnar_v1_h32_i16_b4_tp4r0_a0_f1.num_vgpr, 42
	.set .Lqwen_bf16_ffnar_v1_h32_i16_b4_tp4r0_a0_f1.num_agpr, 0
	.set .Lqwen_bf16_ffnar_v1_h32_i16_b4_tp4r0_a0_f1.numbered_sgpr, 43
	.set .Lqwen_bf16_ffnar_v1_h32_i16_b4_tp4r0_a0_f1.num_named_barrier, 0
	.set .Lqwen_bf16_ffnar_v1_h32_i16_b4_tp4r0_a0_f1.private_seg_size, 0
	.set .Lqwen_bf16_ffnar_v1_h32_i16_b4_tp4r0_a0_f1.uses_vcc, 1
	.set .Lqwen_bf16_ffnar_v1_h32_i16_b4_tp4r0_a0_f1.uses_flat_scratch, 0
	.set .Lqwen_bf16_ffnar_v1_h32_i16_b4_tp4r0_a0_f1.has_dyn_sized_stack, 0
	.set .Lqwen_bf16_ffnar_v1_h32_i16_b4_tp4r0_a0_f1.has_recursion, 0
	.set .Lqwen_bf16_ffnar_v1_h32_i16_b4_tp4r0_a0_f1.has_indirect_call, 0
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
    .name:           qwen_bf16_ffnar_v1_h32_i16_b4_tp4r0_a0_f1
    .private_segment_fixed_size: 0
    .reqd_workgroup_size:
      - 128
      - 1
      - 1
    .sgpr_count:     45
    .sgpr_spill_count: 0
    .symbol:         qwen_bf16_ffnar_v1_h32_i16_b4_tp4r0_a0_f1.kd
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
