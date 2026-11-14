	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1201"
	.amdhsa_code_object_version 6
	.text
	.globl	qwen_tp_shard_bf16_h5120_i4352_b1
	.p2align	8
	.type	qwen_tp_shard_bf16_h5120_i4352_b1,@function
qwen_tp_shard_bf16_h5120_i4352_b1:
	s_load_b128 s[20:23], s[0:1], 0x50
	s_wait_kmcnt 0x0
	s_cmp_lt_i32 s20, 1
	s_cbranch_scc1 .LBB0_86
	s_load_b128 s[24:27], s[0:1], 0x40
	v_cmp_eq_u32_e64 s2, 0, v0
	s_and_saveexec_b32 s3, s2
	s_cbranch_execz .LBB0_3
	v_mov_b32_e32 v1, 0
	s_cmp_lg_u32 ttmp9, s23
	s_cselect_b32 s4, -1, 0
	s_wait_kmcnt 0x0
	global_load_b32 v2, v1, s[26:27] scope:SCOPE_DEV
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
	s_cbranch_vccnz .LBB0_86
	s_load_b512 s[4:19], s[0:1], 0x0
	v_lshrrev_b32_e32 v1, 5, v0
	s_cmp_ge_i32 ttmp9, s20
	s_delay_alu instid0(VALU_DEP_1)
	v_readfirstlane_b32 s23, v1
	s_cbranch_scc1 .LBB0_15
	v_and_b32_e32 v1, 31, v0
	v_dual_mov_b32 v10, 0 :: v_dual_lshlrev_b32 v3, 1, v0
	v_or_b32_e32 v9, 0xfffffe00, v0
	s_mov_b32 s28, ttmp9
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_lshlrev_b32_e32 v2, 2, v1
	v_cmp_gt_u32_e32 vcc_lo, 24, v1
	v_add_nc_u32_e32 v8, 4, v2
	v_add_nc_u32_e32 v7, 8, v2
	v_add_nc_u32_e32 v4, 32, v2
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_2)
	v_dual_cndmask_b32 v5, v2, v4 :: v_dual_add_nc_u32 v6, 16, v2
	v_cmp_gt_u32_e32 vcc_lo, 28, v1
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v6, v2, v6, vcc_lo
	v_cmp_gt_u32_e32 vcc_lo, 30, v1
	v_cmp_eq_u32_e64 s0, 0, v1
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v7, v2, v7, vcc_lo
	v_cmp_ne_u32_e32 vcc_lo, 31, v1
	s_wait_kmcnt 0x0
	v_add_co_u32 v1, s1, s8, v3
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_add_co_ci_u32_e64 v2, null, s9, 0, s1
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v8, 0x7c, v8, vcc_lo
	v_add_co_u32 v1, vcc_lo, 0x200, v1
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v2, null, 0, v2, vcc_lo
	s_lshl_b32 s8, s23, 2
	s_mul_i32 s9, ttmp9, 0x1400
.LBB0_6:
	v_dual_mov_b32 v4, 0 :: v_dual_mov_b32 v3, v0
	s_mul_i32 s29, s28, 0x1400
	s_mov_b32 s3, 0
.LBB0_7:
	s_wait_alu depctr_sa_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v11, s29, v3
	v_ashrrev_i32_e32 v12, 31, v11
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshlrev_b64_e32 v[12:13], 1, v[11:12]
	v_add_co_u32 v14, vcc_lo, s4, v12
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_add_co_ci_u32_e64 v15, null, s5, v13, vcc_lo
	v_add_co_u32 v16, vcc_lo, s6, v12
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v17, null, s7, v13, vcc_lo
	global_load_u16 v20, v[14:15], off
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
	v_add_co_u32 v16, vcc_lo, s4, v14
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_add_co_ci_u32_e64 v17, null, s5, v15, vcc_lo
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
	global_load_u16 v21, v[16:17], off
	global_load_u16 v22, v[18:19], off
	v_add_nc_u32_e32 v12, 0x100, v11
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v13, 31, v12
	v_lshlrev_b64_e32 v[12:13], 1, v[12:13]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v16, vcc_lo, s4, v12
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v17, null, s5, v13, vcc_lo
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
	global_load_u16 v22, v[16:17], off
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
	v_add_co_u32 v16, vcc_lo, s4, v14
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v17, null, s5, v15, vcc_lo
	v_add_co_u32 v18, vcc_lo, s6, v14
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v19, null, s7, v15, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v13, v13
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v22, v22, v23, vcc_lo
	v_cmp_lt_u32_e32 vcc_lo, 0x11ff, v3
	global_store_d16_hi_b16 v[11:12], v22, off
	global_load_u16 v11, v[16:17], off
	global_load_u16 v12, v[18:19], off
	v_add_nc_u32_e32 v16, 0x200, v3
	s_or_b32 s3, vcc_lo, s3
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
	v_add_co_u32 v11, s1, s16, v14
	v_or_b32_e32 v14, 0x400000, v16
	v_add3_u32 v13, v13, v16, 0x7fff
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_4) | instid1(VALU_DEP_3)
	v_add_f32_e32 v4, v4, v12
	v_mul_f32_e32 v17, v16, v16
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v12, null, s17, v15, s1
	v_cmp_u_f32_e64 s1, v16, v16
	v_add_f32_e32 v4, v4, v17
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_cndmask_b32_e64 v13, v13, v14, s1
	global_store_d16_hi_b16 v[11:12], v13, off
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_b32 exec_lo, exec_lo, s3
	s_cbranch_execnz .LBB0_7
	s_or_b32 exec_lo, exec_lo, s3
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
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_10
	s_wait_dscnt 0x0
	v_dual_add_f32 v3, v3, v4 :: v_dual_mov_b32 v4, s8
	ds_store_b32 v4, v3
.LBB0_10:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s1
	s_wait_storecnt_dscnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s1, s2
	s_cbranch_execz .LBB0_12
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
	v_readfirstlane_b32 s3, v3
	s_add_f32 s3, s21, s3
	s_wait_alu depctr_sa_sdst(0)
	s_delay_alu instid0(SALU_CYCLE_2) | instskip(SKIP_2) | instid1(SALU_CYCLE_1)
	s_mul_f32 s29, s3, 0x4f800000
	s_cmp_lt_f32 s3, 0xf800000
	s_wait_alu depctr_sa_sdst(0)
	s_cselect_b32 s29, s29, s3
	s_wait_alu depctr_sa_sdst(0)
	v_s_sqrt_f32 s30, s29
	s_mov_b32 s33, s29
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_add_co_i32 s31, s30, -1
	s_xor_b32 s34, s31, 0x80000000
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_2)
	s_fmac_f32 s33, s34, s30
	s_mov_b32 s34, s29
	s_cmp_le_f32 s33, 0
	s_cselect_b32 s31, s31, s30
	s_add_co_i32 s33, s30, 1
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_xor_b32 s35, s33, 0x80000000
	s_fmac_f32 s34, s35, s30
	v_cmp_class_f32_e64 s30, s29, 0x260
	s_delay_alu instid0(SALU_CYCLE_2) | instskip(SKIP_4) | instid1(SALU_CYCLE_2)
	s_cmp_gt_f32 s34, 0
	s_cselect_b32 s31, s33, s31
	s_cmp_lt_f32 s3, 0xf800000
	s_mul_f32 s3, s31, 0x37800000
	s_wait_alu depctr_sa_sdst(0)
	s_cselect_b32 s3, s3, s31
	s_and_b32 s30, s30, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	s_cselect_b32 s3, s29, s3
	s_wait_alu depctr_sa_sdst(0)
	v_div_scale_f32 v3, null, s3, s3, 1.0
	s_delay_alu instid0(VALU_DEP_1)
	v_rcp_f32_e32 v4, v3
	v_xor_b32_e32 v3, 0x80000000, v3
	s_delay_alu instid0(TRANS32_DEP_1) | instid1(VALU_DEP_1)
	v_fma_f32 v11, v3, v4, 1.0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_fmac_f32_e32 v4, v11, v4
	v_div_scale_f32 v11, vcc_lo, 1.0, s3, 1.0
	v_mul_f32_e32 v12, v11, v4
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fma_f32 v13, v3, v12, v11
	v_fmac_f32_e32 v12, v13, v4
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_fmac_f32_e32 v11, v3, v12
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v3, v11, v4, v12
	s_delay_alu instid0(VALU_DEP_1)
	v_div_fixup_f32 v3, v3, s3, 1.0
	ds_store_b32 v10, v3 offset:16
.LBB0_12:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s1
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	v_dual_mov_b32 v4, v2 :: v_dual_mov_b32 v3, v1
	v_mov_b32_e32 v12, v9
	s_mov_b32 s29, 0
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	ds_load_b32 v11, v10 offset:16
	s_wait_dscnt 0x0
.LBB0_13:
	v_add_nc_u32_e32 v21, s9, v12
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v13, 0x200, v21
	v_ashrrev_i32_e32 v14, 31, v13
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshlrev_b64_e32 v[13:14], 1, v[13:14]
	v_add_co_u32 v15, vcc_lo, s4, v13
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_add_co_ci_u32_e64 v16, null, s5, v14, vcc_lo
	v_add_co_u32 v17, vcc_lo, s6, v13
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v18, null, s7, v14, vcc_lo
	global_load_u16 v22, v[15:16], off
	global_load_u16 v23, v[17:18], off
	global_load_u16 v24, v[3:4], off offset:-512
	v_add_co_u32 v13, vcc_lo, s18, v13
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v14, null, s19, v14, vcc_lo
	s_wait_loadcnt 0x2
	v_lshlrev_b32_e32 v22, 16, v22
	s_wait_loadcnt 0x1
	v_lshlrev_b32_e32 v23, 16, v23
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v24, 16, v24
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_dual_add_f32 v22, v22, v23 :: v_dual_add_nc_u32 v15, 0x280, v21
	v_add_f32_e32 v24, 1.0, v24
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_ashrrev_i32_e32 v16, 31, v15
	v_mul_f32_e32 v22, v11, v22
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_lshlrev_b64_e32 v[15:16], 1, v[15:16]
	v_mul_f32_e32 v22, v22, v24
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_add_co_u32 v17, vcc_lo, s4, v15
	v_bfe_u32 v23, v22, 16, 1
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_4)
	v_add_co_ci_u32_e64 v18, null, s5, v16, vcc_lo
	v_add_co_u32 v19, vcc_lo, s6, v15
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v20, null, s7, v16, vcc_lo
	v_or_b32_e32 v24, 0x400000, v22
	v_add3_u32 v23, v23, v22, 0x7fff
	v_cmp_u_f32_e32 vcc_lo, v22, v22
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_cndmask_b32_e32 v22, v23, v24, vcc_lo
	v_add_co_u32 v15, vcc_lo, s18, v15
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v16, null, s19, v16, vcc_lo
	global_store_d16_hi_b16 v[13:14], v22, off
	global_load_u16 v18, v[17:18], off
	global_load_u16 v19, v[19:20], off
	global_load_u16 v20, v[3:4], off offset:-256
	v_add_nc_u32_e32 v13, 0x300, v21
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v14, 31, v13
	v_lshlrev_b64_e32 v[13:14], 1, v[13:14]
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_u32 v17, vcc_lo, s4, v13
	s_wait_loadcnt 0x2
	v_lshlrev_b32_e32 v18, 16, v18
	s_wait_loadcnt 0x1
	v_lshlrev_b32_e32 v19, 16, v19
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v20, 16, v20
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_dual_add_f32 v18, v18, v19 :: v_dual_add_f32 v19, 1.0, v20
	v_mul_f32_e32 v20, v11, v18
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v18, null, s5, v14, vcc_lo
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_mul_f32_e32 v20, v20, v19
	v_add_co_u32 v19, vcc_lo, s6, v13
	v_bfe_u32 v22, v20, 16, 1
	v_or_b32_e32 v23, 0x400000, v20
	v_cmp_u_f32_e64 s1, v20, v20
	s_delay_alu instid0(VALU_DEP_3)
	v_add3_u32 v22, v22, v20, 0x7fff
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v20, null, s7, v14, vcc_lo
	v_add_co_u32 v13, vcc_lo, s18, v13
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v22, v22, v23, s1
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v14, null, s19, v14, vcc_lo
	global_store_d16_hi_b16 v[15:16], v22, off
	global_load_u16 v17, v[17:18], off
	global_load_u16 v18, v[19:20], off
	global_load_u16 v19, v[3:4], off
	v_add_nc_u32_e32 v15, 0x380, v21
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v16, 31, v15
	v_lshlrev_b64_e32 v[15:16], 1, v[15:16]
	s_wait_loadcnt 0x2
	v_lshlrev_b32_e32 v17, 16, v17
	s_wait_loadcnt 0x1
	v_lshlrev_b32_e32 v18, 16, v18
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v19, 16, v19
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_dual_add_f32 v17, v17, v18 :: v_dual_add_f32 v18, 1.0, v19
	v_mul_f32_e32 v17, v11, v17
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_3) | instid1(VALU_DEP_3)
	v_mul_f32_e32 v20, v17, v18
	v_add_co_u32 v17, vcc_lo, s4, v15
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v18, null, s5, v16, vcc_lo
	v_bfe_u32 v19, v20, 16, 1
	v_or_b32_e32 v21, 0x400000, v20
	v_cmp_u_f32_e64 s1, v20, v20
	s_delay_alu instid0(VALU_DEP_3)
	v_add3_u32 v22, v19, v20, 0x7fff
	v_add_co_u32 v19, vcc_lo, s6, v15
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v20, null, s7, v16, vcc_lo
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v21, v22, v21, s1
	global_store_d16_hi_b16 v[13:14], v21, off
	global_load_u16 v13, v[17:18], off
	global_load_u16 v14, v[19:20], off
	global_load_u16 v17, v[3:4], off offset:256
	s_wait_loadcnt 0x2
	v_lshlrev_b32_e32 v13, 16, v13
	s_wait_loadcnt 0x1
	v_lshlrev_b32_e32 v14, 16, v14
	s_wait_loadcnt 0x0
	v_lshlrev_b32_e32 v17, 16, v17
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_dual_add_f32 v13, v13, v14 :: v_dual_add_f32 v14, 1.0, v17
	v_dual_mul_f32 v13, v11, v13 :: v_dual_add_nc_u32 v12, 0x200, v12
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_3) | instid1(VALU_DEP_3)
	v_mul_f32_e32 v17, v13, v14
	v_add_co_u32 v13, s1, s18, v15
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v14, null, s19, v16, s1
	v_bfe_u32 v15, v17, 16, 1
	v_or_b32_e32 v16, 0x400000, v17
	v_cmp_u_f32_e64 s3, v17, v17
	v_cmp_lt_u32_e32 vcc_lo, 0x11ff, v12
	v_add_co_u32 v3, s1, 0x400, v3
	v_add3_u32 v15, v15, v17, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v4, null, 0, v4, s1
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s29, vcc_lo, s29
	v_cndmask_b32_e64 v15, v15, v16, s3
	global_store_d16_hi_b16 v[13:14], v15, off
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_b32 exec_lo, exec_lo, s29
	s_cbranch_execnz .LBB0_13
	s_or_b32 exec_lo, exec_lo, s29
	s_wait_storecnt 0x0
	s_barrier_signal -1
	s_add_co_i32 s28, s28, 1
	s_addk_co_i32 s9, 0x1400
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lg_u32 s28, s20
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_cbranch_scc1 .LBB0_6
.LBB0_15:
	s_wait_loadcnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s1, s2
	s_cbranch_execz .LBB0_26
	v_mov_b32_e32 v2, 0
	s_mov_b32 s0, exec_lo
	s_mov_b32 s3, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	v_mbcnt_lo_u32_b32 v1, s0, 0
	s_wait_kmcnt 0x0
	global_load_b32 v3, v2, s[24:25] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_18
	s_bcnt1_i32_b32 s0, s0
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v4, s0
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v4, v2, v4, s[24:25] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_18:
	s_or_b32 exec_lo, exec_lo, s3
	v_readfirstlane_b32 s0, v4
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v1, s0, v1
	s_mov_b32 s0, exec_lo
	v_cmpx_ne_u32_e32 0, v1
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s3, exec_lo, s0
	s_cbranch_execz .LBB0_23
	s_cmp_lt_i32 s22, 1
	s_mov_b32 s4, 1
	s_cbranch_scc1 .LBB0_52
	v_mov_b32_e32 v1, 0
.LBB0_21:
	global_load_b32 v2, v1, s[24:25] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	global_load_b32 v4, v1, s[26:27] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, v2, v3
	v_cmp_eq_u32_e64 s0, 0, v4
	s_and_b32 s0, vcc_lo, s0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s4, s22
	s_cselect_b32 s5, -1, 0
	s_add_co_i32 s4, s4, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s5, s0, s5
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s5
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_21
	s_and_b32 vcc_lo, exec_lo, s0
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_53
.LBB0_23:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s0, s3
	s_cbranch_execz .LBB0_25
.LBB0_24:
	v_dual_mov_b32 v1, 0 :: v_dual_add_nc_u32 v2, 1, v3
	global_store_b32 v1, v1, s[24:25] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v1, v2, s[24:25] offset:4 scope:SCOPE_DEV
.LBB0_25:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s0
	v_mov_b32_e32 v1, 0
	global_load_b32 v2, v1, s[26:27] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, 0, v2
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e64 v2, 0, 1, vcc_lo
	ds_store_b32 v1, v2 offset:20
.LBB0_26:
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
	s_cbranch_vccnz .LBB0_86
	v_lshrrev_b32_e32 v1, 1, v0
	v_and_b32_e32 v31, 15, v0
	s_lshl_b32 s0, ttmp9, 2
	s_wait_kmcnt 0x0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s4, s0, s23
	v_and_b32_e32 v32, 8, v1
	v_cmp_gt_i32_e64 s0, s20, v31
	v_mul_u32_u24_e32 v33, 0x1400, v31
	v_mul_u32_u24_e32 v34, 0x1100, v31
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_gt_i32 s4, 0x10f
	s_cbranch_scc1 .LBB0_44
	v_or_b32_e32 v35, v33, v32
	v_mov_b32_e32 v28, 0
	s_mov_b32 s5, s4
	s_branch .LBB0_30
.LBB0_29:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
	s_add_co_i32 s1, s5, 4
	s_cmp_lt_i32 s5, 0x10c
	s_wait_alu depctr_sa_sdst(0)
	s_mov_b32 s5, s1
	s_cbranch_scc0 .LBB0_44
.LBB0_30:
	s_wait_alu depctr_sa_sdst(0)
	s_lshl_b32 s1, s5, 4
	v_dual_mov_b32 v8, v28 :: v_dual_mov_b32 v9, v28
	s_wait_alu depctr_sa_sdst(0)
	v_or_b32_e32 v0, s1, v31
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
	s_mov_b32 s3, 0
	s_branch .LBB0_32
.LBB0_31:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
	v_add_nc_u32_e32 v20, 64, v29
	s_add_co_i32 s6, s3, 0x50
	s_cmp_lt_u32 s3, 0x13b0
	s_wait_alu depctr_sa_sdst(0)
	s_mov_b32 s3, s6
	v_ashrrev_i32_e32 v21, 31, v20
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshlrev_b64_e32 v[20:21], 1, v[20:21]
	v_add_co_u32 v20, vcc_lo, s10, v20
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_add_co_ci_u32_e64 v21, null, s11, v21, vcc_lo
	v_add_co_u32 v24, vcc_lo, 0x2800000, v20
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_2)
	v_add_co_ci_u32_e64 v25, null, 0, v21, vcc_lo
	s_clause 0x1
	global_load_b128 v[20:23], v[20:21], off
	global_load_b128 v[24:27], v[24:25], off offset:2621440
	s_wait_loadcnt 0x1
	v_wmma_f32_16x16x16_bf16 v[8:15], v[20:23], v[16:19], v[8:15]
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[24:27], v[16:19], v[0:7]
	s_cbranch_scc0 .LBB0_42
.LBB0_32:
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v16, 0 :: v_dual_add_nc_u32 v27, s3, v35
	v_dual_mov_b32 v19, 0 :: v_dual_mov_b32 v20, 0
	v_dual_mov_b32 v21, 0 :: v_dual_mov_b32 v22, 0
	s_and_saveexec_b32 s6, s0
	s_cbranch_execz .LBB0_34
	v_lshlrev_b64_e32 v[17:18], 1, v[27:28]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v17, vcc_lo, s18, v17
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v18, null, s19, v18, vcc_lo
	global_load_b128 v[19:22], v[17:18], off
.LBB0_34:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
	v_add_nc_u32_e32 v29, s3, v36
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v30, 31, v29
	v_lshlrev_b64_e32 v[17:18], 1, v[29:30]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v17, vcc_lo, s10, v17
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v18, null, s11, v18, vcc_lo
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v37, vcc_lo, 0x2800000, v17
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v38, null, 0, v18, vcc_lo
	s_clause 0x1
	global_load_b128 v[23:26], v[17:18], off
	global_load_b128 v[37:40], v[37:38], off offset:2621440
	v_dual_mov_b32 v17, 0 :: v_dual_mov_b32 v18, 0
	s_wait_loadcnt 0x1
	v_wmma_f32_16x16x16_bf16 v[8:15], v[23:26], v[19:22], v[8:15]
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[37:40], v[19:22], v[0:7]
	v_mov_b32_e32 v19, 0
	s_and_saveexec_b32 s6, s0
	s_cbranch_execz .LBB0_36
	v_lshlrev_b64_e32 v[16:17], 1, v[27:28]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v16, vcc_lo, s18, v16
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v17, null, s19, v17, vcc_lo
	global_load_b128 v[16:19], v[16:17], off offset:32
.LBB0_36:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
	v_add_nc_u32_e32 v20, 16, v29
	v_mov_b32_e32 v24, 0
	v_dual_mov_b32 v26, 0 :: v_dual_mov_b32 v25, 0
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v21, 31, v20
	v_lshlrev_b64_e32 v[20:21], 1, v[20:21]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v20, vcc_lo, s10, v20
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v21, null, s11, v21, vcc_lo
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v22, vcc_lo, 0x2800000, v20
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v23, null, 0, v21, vcc_lo
	s_clause 0x1
	global_load_b128 v[37:40], v[20:21], off
	global_load_b128 v[41:44], v[22:23], off offset:2621440
	v_dual_mov_b32 v20, 0 :: v_dual_mov_b32 v23, 0
	s_wait_loadcnt 0x1
	v_wmma_f32_16x16x16_bf16 v[8:15], v[37:40], v[16:19], v[8:15]
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[41:44], v[16:19], v[0:7]
	s_and_saveexec_b32 s6, s0
	s_cbranch_execz .LBB0_38
	v_lshlrev_b64_e32 v[16:17], 1, v[27:28]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v16, vcc_lo, s18, v16
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v17, null, s19, v17, vcc_lo
	global_load_b128 v[23:26], v[16:17], off offset:64
.LBB0_38:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
	v_add_nc_u32_e32 v16, 32, v29
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v17, 31, v16
	v_lshlrev_b64_e32 v[16:17], 1, v[16:17]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v16, vcc_lo, s10, v16
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v17, null, s11, v17, vcc_lo
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v21, vcc_lo, 0x2800000, v16
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v22, null, 0, v17, vcc_lo
	s_clause 0x1
	global_load_b128 v[16:19], v[16:17], off
	global_load_b128 v[37:40], v[21:22], off offset:2621440
	v_dual_mov_b32 v21, 0 :: v_dual_mov_b32 v22, 0
	s_wait_loadcnt 0x1
	v_wmma_f32_16x16x16_bf16 v[8:15], v[16:19], v[23:26], v[8:15]
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[37:40], v[23:26], v[0:7]
	v_mov_b32_e32 v23, 0
	s_and_saveexec_b32 s6, s0
	s_cbranch_execz .LBB0_40
	v_lshlrev_b64_e32 v[16:17], 1, v[27:28]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v16, vcc_lo, s18, v16
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v17, null, s19, v17, vcc_lo
	global_load_b128 v[20:23], v[16:17], off offset:96
.LBB0_40:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s6
	v_add_nc_u32_e32 v16, 48, v29
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v17, 31, v16
	v_lshlrev_b64_e32 v[16:17], 1, v[16:17]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v16, vcc_lo, s10, v16
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v17, null, s11, v17, vcc_lo
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v18, vcc_lo, 0x2800000, v16
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v19, null, 0, v17, vcc_lo
	s_clause 0x1
	global_load_b128 v[37:40], v[16:17], off
	global_load_b128 v[41:44], v[18:19], off offset:2621440
	v_dual_mov_b32 v16, 0 :: v_dual_mov_b32 v19, 0
	v_dual_mov_b32 v17, 0 :: v_dual_mov_b32 v18, 0
	s_wait_loadcnt 0x1
	v_wmma_f32_16x16x16_bf16 v[8:15], v[37:40], v[20:23], v[8:15]
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[41:44], v[20:23], v[0:7]
	s_and_saveexec_b32 s6, s0
	s_cbranch_execz .LBB0_31
	v_lshlrev_b64_e32 v[16:17], 1, v[27:28]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v16, vcc_lo, s18, v16
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v17, null, s19, v17, vcc_lo
	global_load_b128 v[16:19], v[16:17], off offset:128
	s_branch .LBB0_31
.LBB0_42:
	s_and_saveexec_b32 s6, s0
	s_cbranch_execz .LBB0_29
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
	v_or_b32_e32 v8, s1, v32
	v_or_b32_e32 v17, 0x400000, v0
	s_delay_alu instid0(VALU_DEP_4)
	v_and_b32_e32 v24, 0xffff0000, v9
	v_add3_u32 v16, v16, v0, 0x7fff
	v_bfe_u32 v21, v1, 16, 1
	v_or_b32_e32 v19, 0x400000, v1
	v_cmp_u_f32_e64 s1, v1, v1
	v_mul_f32_e32 v29, 0xbfb8aa3b, v24
	v_bfe_u32 v30, v12, 16, 1
	v_add3_u32 v21, v21, v1, 0x7fff
	v_or_b32_e32 v36, 0x400000, v12
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v10, v22, v23, vcc_lo
	v_fma_f32 v37, 0xbfb8aa3b, v24, -v29
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v19, v21, v19, s1
	v_add3_u32 v30, v30, v12, 0x7fff
	v_and_b32_e32 v10, 0xffff0000, v10
	v_fmac_f32_e32 v37, 0xb2a5705f, v24
	s_wait_alu depctr_va_vcc(0)
	v_dual_mul_f32 v18, 0xbfb8aa3b, v20 :: v_dual_cndmask_b32 v11, v26, v27
	v_add_nc_u32_e32 v8, v8, v34
	v_cmp_nlt_f32_e64 s1, 0x42ce8ed0, v10
	v_cmp_ngt_f32_e64 s3, 0xc2b17218, v10
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
	v_cndmask_b32_e64 v0, 0, v0, s1
	s_delay_alu instid0(TRANS32_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fma_f32 v1, -v17, v40, 1.0
	v_fmac_f32_e32 v40, v1, v40
	v_div_scale_f32 v25, s1, v24, v29, v24
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_dual_mul_f32 v21, v39, v26 :: v_dual_mul_f32 v38, v25, v40
	v_fma_f32 v22, -v23, v21, v39
	s_delay_alu instid0(VALU_DEP_1)
	v_fmac_f32_e32 v21, v22, v26
	s_wait_alu depctr_sa_sdst(0)
	v_cndmask_b32_e64 v22, 0x7f800000, v0, s3
	v_lshlrev_b64_e32 v[0:1], 1, v[8:9]
	v_ldexp_f32 v9, v16, v37
	v_cmp_u_f32_e64 s3, v6, v6
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
	s_mov_b32 vcc_lo, s1
	v_bfe_u32 v20, v16, 16, 1
	s_wait_alu depctr_sa_sdst(0)
	v_div_fmas_f32 v17, v17, v40, v38
	v_cmp_u_f32_e64 s1, v16, v16
	v_div_scale_f32 v25, vcc_lo, v10, v22, v10
	v_fmac_f32_e32 v18, v23, v18
	v_add3_u32 v20, v20, v16, 0x7fff
	v_div_fixup_f32 v17, v17, v29, v24
	v_or_b32_e32 v24, 0x400000, v16
	v_and_b32_e32 v19, 0xffff0000, v19
	v_or_b32_e32 v29, 0x400000, v2
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_3)
	v_cndmask_b32_e64 v16, v20, v24, s1
	v_add_co_u32 v0, s1, s18, v0
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v1, null, s19, v1, s1
	v_cmp_u_f32_e64 s1, v12, v12
	v_mul_f32_e32 v20, v25, v18
	v_bfe_u32 v24, v2, 16, 1
	v_lshrrev_b32_e32 v16, 16, v16
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v12, v30, v36, s1
	v_add_f32_e32 v9, 1.0, v9
	v_fma_f32 v26, -v21, v20, v25
	v_mul_f32_e32 v17, v17, v19
	v_add3_u32 v24, v24, v2, 0x7fff
	v_and_b32_e32 v12, 0xffff0000, v12
	v_div_scale_f32 v19, null, v9, v9, v11
	v_fmac_f32_e32 v20, v26, v18
	v_cmp_u_f32_e64 s1, v2, v2
	v_bfe_u32 v23, v17, 16, 1
	v_or_b32_e32 v26, 0x400000, v17
	v_rcp_f32_e32 v27, v19
	v_fma_f32 v21, -v21, v20, v25
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v2, v24, v29, s1
	v_add3_u32 v23, v23, v17, 0x7fff
	v_cmp_u_f32_e64 s1, v17, v17
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v18, v21, v18, v20
	v_and_b32_e32 v2, 0xffff0000, v2
	v_div_scale_f32 v21, vcc_lo, v11, v9, v11
	v_fma_f32 v24, -v19, v27, 1.0
	v_mul_f32_e32 v30, 0xbfb8aa3b, v12
	v_div_fixup_f32 v10, v18, v22, v10
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v17, v23, v26, s1
	v_cmp_u_f32_e64 s1, v3, v3
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
	v_cndmask_b32_e64 v3, v2, v25, s1
	v_cmp_nlt_f32_e64 s1, 0x42ce8ed0, v12
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
	v_cndmask_b32_e64 v18, 0, v18, s1
	v_bfe_u32 v23, v10, 16, 1
	v_or_b32_e32 v20, 0x400000, v10
	v_bfe_u32 v17, v9, 16, 1
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v18, 0x7f800000, v18, vcc_lo
	v_add3_u32 v22, v23, v10, 0x7fff
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	v_cmp_u_f32_e64 s1, v9, v9
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
	v_cndmask_b32_e64 v17, v17, v20, s1
	v_or_b32_e32 v20, 0x400000, v4
	v_fma_f32 v18, -v10, v21, 1.0
	v_add_nc_u32_e32 v2, 3, v8
	v_cmp_u_f32_e64 s1, v4, v4
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_fmac_f32_e32 v21, v18, v21
	v_ashrrev_i32_e32 v3, 31, v2
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_cndmask_b32_e64 v4, v9, v20, s1
	v_cmp_u_f32_e64 s1, v14, v14
	v_lshlrev_b64_e32 v[2:3], 1, v[2:3]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v2, vcc_lo, s18, v2
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v3, null, s19, v3, vcc_lo
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
	v_cndmask_b32_e64 v14, v23, v26, s1
	v_or_b32_e32 v23, 0x400000, v15
	v_fmac_f32_e32 v24, 0xb2a5705f, v13
	v_div_fixup_f32 v11, v10, v11, v12
	s_wait_alu depctr_va_vcc(0)
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_dual_cndmask_b32 v15, v20, v23 :: v_dual_and_b32 v14, 0xffff0000, v14
	v_add_f32_e32 v9, v9, v24
	v_cmp_nlt_f32_e32 vcc_lo, 0x42ce8ed0, v13
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_cmp_ngt_f32_e64 s1, 0xc2b17218, v14
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
	v_add_co_u32 v9, vcc_lo, s18, v9
	s_wait_alu depctr_va_vcc(0)
	v_add_co_ci_u32_e64 v10, null, s19, v10, vcc_lo
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
	v_cndmask_b32_e64 v4, 0x7f800000, v4, s1
	v_cmp_nlt_f32_e64 s1, 0x42ce8ed0, v15
	v_mul_f32_e32 v24, v23, v25
	v_ldexp_f32 v12, v20, v12
	v_or_b32_e32 v20, 0x400000, v11
	v_add_f32_e32 v26, 1.0, v4
	s_delay_alu instid0(VALU_DEP_4)
	v_fma_f32 v27, -v18, v24, v23
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v4, 0, v12, s1
	v_bfe_u32 v12, v5, 16, 1
	v_cmp_ngt_f32_e64 s1, 0xc2b17218, v15
	v_div_scale_f32 v29, null, v26, v26, v14
	v_fmac_f32_e32 v24, v27, v25
	s_delay_alu instid0(VALU_DEP_4)
	v_add3_u32 v12, v12, v5, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v4, 0x7f800000, v4, s1
	v_cmp_u_f32_e64 s1, v5, v5
	v_rcp_f32_e32 v27, v29
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_3) | instid1(TRANS32_DEP_1)
	v_cndmask_b32_e64 v5, v12, v30, s1
	v_fma_f32 v12, -v18, v24, v23
	v_cmp_u_f32_e64 s1, v11, v11
	v_or_b32_e32 v30, 0x400000, v6
	v_fma_f32 v23, -v29, v27, 1.0
	s_wait_alu depctr_va_vcc(0)
	v_div_fmas_f32 v12, v12, v25, v24
	v_and_b32_e32 v24, 0xffff0000, v5
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v20, v21, v20, s1
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
	v_cndmask_b32_e64 v6, v22, v30, s3
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
	v_add_co_u32 v4, s1, s18, v4
	v_fma_f32 v21, -v18, v25, 1.0
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_add_co_ci_u32_e64 v5, null, s19, v5, s1
	v_fmac_f32_e32 v25, v21, v25
	v_div_scale_f32 v21, s1, v15, v36, v15
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mul_f32_e32 v24, v21, v25
	v_fma_f32 v29, -v18, v24, v21
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_fmac_f32_e32 v24, v29, v25
	v_fma_f32 v14, -v18, v24, v21
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e32 v18, v22, v27, vcc_lo
	s_mov_b32 vcc_lo, s1
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
	v_add_co_u32 v6, vcc_lo, s18, v6
	v_mul_f32_e32 v8, v14, v18
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_lshlrev_b64_e32 v[11:12], 1, v[11:12]
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
	global_store_d16_hi_b16 v[0:1], v19, off offset:163844
	global_store_b32 v[0:1], v16, off offset:163840
	global_store_d16_hi_b16 v[2:3], v17, off offset:163840
	global_store_d16_hi_b16 v[9:10], v20, off offset:163840
	global_store_d16_hi_b16 v[4:5], v21, off offset:163840
	global_store_d16_hi_b16 v[6:7], v13, off offset:163840
	global_store_d16_hi_b16 v[11:12], v8, off offset:163840
	s_branch .LBB0_29
.LBB0_44:
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_and_saveexec_b32 s1, s2
	s_cbranch_execz .LBB0_63
	v_mov_b32_e32 v1, 0
	s_mov_b32 s0, exec_lo
	s_mov_b32 s2, exec_lo
	s_wait_alu depctr_sa_sdst(0)
	v_mbcnt_lo_u32_b32 v0, s0, 0
	global_load_b32 v2, v1, s[24:25] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_47
	s_bcnt1_i32_b32 s0, s0
	s_wait_alu depctr_sa_sdst(0)
	v_mov_b32_e32 v3, s0
	s_wait_loadcnt 0x0
	global_atomic_add_u32 v3, v1, v3, s[24:25] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
.LBB0_47:
	s_or_b32 exec_lo, exec_lo, s2
	v_readfirstlane_b32 s0, v3
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v0, s0, v0
	s_mov_b32 s0, exec_lo
	v_cmpx_ne_u32_e32 0, v0
	s_wait_alu depctr_sa_sdst(0)
	s_xor_b32 s2, exec_lo, s0
	s_cbranch_execz .LBB0_60
	s_cmp_lt_i32 s22, 1
	s_mov_b32 s3, 1
	s_cbranch_scc1 .LBB0_56
	v_mov_b32_e32 v0, 0
.LBB0_50:
	global_load_b32 v1, v0, s[24:25] offset:4 scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	global_load_b32 v3, v0, s[26:27] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, v1, v2
	v_cmp_eq_u32_e64 s0, 0, v3
	s_and_b32 s0, vcc_lo, s0
	s_wait_alu depctr_sa_sdst(0)
	s_cmp_lt_i32 s3, s22
	s_cselect_b32 s5, -1, 0
	s_add_co_i32 s3, s3, 1
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 s5, s0, s5
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s5
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_50
	s_and_b32 vcc_lo, exec_lo, s0
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_57
	s_branch .LBB0_60
.LBB0_52:
	s_cbranch_execz .LBB0_23
.LBB0_53:
	v_dual_mov_b32 v4, 1 :: v_dual_mov_b32 v5, 0
	s_mov_b32 s0, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v1, v5, v[4:5], s[26:27] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v1
	s_cbranch_execz .LBB0_55
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v2, ttmp9 :: v_dual_mov_b32 v1, v4
	global_store_b96 v5, v[1:3], s[26:27] offset:4
.LBB0_55:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s0
	s_and_not1_saveexec_b32 s0, s3
	s_cbranch_execnz .LBB0_24
	s_branch .LBB0_25
.LBB0_56:
	s_cbranch_execz .LBB0_60
.LBB0_57:
	v_dual_mov_b32 v3, 1 :: v_dual_mov_b32 v4, 0
	s_mov_b32 s0, exec_lo
	s_wait_loadcnt 0x0
	global_atomic_cmpswap_b32 v0, v4, v[3:4], s[26:27] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_59
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v1, ttmp9 :: v_dual_mov_b32 v0, 2
	global_store_b96 v4, v[0:2], s[26:27] offset:4
.LBB0_59:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s0
.LBB0_60:
	s_wait_alu depctr_sa_sdst(0)
	s_and_not1_saveexec_b32 s0, s2
	s_cbranch_execz .LBB0_62
	v_dual_mov_b32 v0, 0 :: v_dual_add_nc_u32 v1, 1, v2
	global_store_b32 v0, v0, s[24:25] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	s_wait_storecnt 0x0
	global_store_b32 v0, v1, s[24:25] offset:4 scope:SCOPE_DEV
.LBB0_62:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s0
	v_mov_b32_e32 v0, 0
	global_load_b32 v1, v0, s[26:27] scope:SCOPE_DEV
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	v_cmp_eq_u32_e32 vcc_lo, 0, v1
	s_wait_alu depctr_va_vcc(0)
	v_cndmask_b32_e64 v1, 0, 1, vcc_lo
	ds_store_b32 v0, v1 offset:20
.LBB0_63:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s1
	s_wait_storecnt 0x0
	s_wait_loadcnt_dscnt 0x0
	s_barrier_signal -1
	v_mov_b32_e32 v21, 0
	s_cmp_gt_i32 s4, 0x13f
	s_cselect_b32 s0, -1, 0
	s_barrier_wait -1
	global_inv scope:SCOPE_SE
	s_wait_loadcnt 0x0
	global_inv scope:SCOPE_DEV
	ds_load_b32 v0, v21 offset:20
	s_wait_dscnt 0x0
	v_cmp_eq_u32_e32 vcc_lo, 0, v0
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 s0, vcc_lo, s0
	s_wait_alu depctr_sa_sdst(0)
	s_and_b32 vcc_lo, exec_lo, s0
	s_wait_alu depctr_sa_sdst(0)
	s_cbranch_vccnz .LBB0_86
	v_or_b32_e32 v24, v34, v32
	v_cmp_gt_i32_e32 vcc_lo, s20, v31
	s_branch .LBB0_66
.LBB0_65:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s2
	s_add_co_i32 s0, s4, 4
	s_cmp_lt_i32 s4, 0x13c
	s_wait_alu depctr_sa_sdst(0)
	s_mov_b32 s4, s0
	s_cbranch_scc0 .LBB0_86
.LBB0_66:
	s_wait_alu depctr_sa_sdst(0)
	s_lshl_b32 s1, s4, 4
	v_mov_b32_e32 v0, 0
	s_wait_alu depctr_sa_sdst(0)
	v_or_b32_e32 v1, s1, v31
	s_mov_b32 s2, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_dual_mov_b32 v3, v0 :: v_dual_mov_b32 v4, v0
	v_mul_lo_u32 v7, 0x1100, v1
	v_dual_mov_b32 v1, v0 :: v_dual_mov_b32 v2, v0
	v_dual_mov_b32 v5, v0 :: v_dual_mov_b32 v6, v0
	s_delay_alu instid0(VALU_DEP_3)
	v_or_b32_e32 v25, v7, v32
	v_mov_b32_e32 v7, v0
	s_branch .LBB0_68
.LBB0_67:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
	global_load_b128 v[8:11], v[22:23], off offset:224
	s_add_co_i32 s0, s2, 0x80
	s_cmp_lt_u32 s2, 0x1080
	s_wait_alu depctr_sa_sdst(0)
	s_mov_b32 s2, s0
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[8:11], v[12:15], v[0:7]
	s_cbranch_scc0 .LBB0_84
.LBB0_68:
	s_wait_alu depctr_sa_sdst(0)
	v_dual_mov_b32 v9, 0 :: v_dual_add_nc_u32 v20, s2, v24
	v_dual_mov_b32 v10, 0 :: v_dual_mov_b32 v11, 0
	v_mov_b32_e32 v12, 0
	s_and_saveexec_b32 s3, vcc_lo
	s_cbranch_execz .LBB0_70
	v_lshlrev_b64_e32 v[8:9], 1, v[20:21]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v8, s0, s18, v8
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v9, null, s19, v9, s0
	global_load_b128 v[9:12], v[8:9], off offset:163840
.LBB0_70:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
	v_dual_mov_b32 v8, 0 :: v_dual_add_nc_u32 v13, s2, v25
	v_mov_b32_e32 v15, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v14, 31, v13
	v_lshlrev_b64_e32 v[13:14], 1, v[13:14]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v22, s0, s12, v13
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v23, null, s13, v14, s0
	v_dual_mov_b32 v13, 0 :: v_dual_mov_b32 v14, 0
	global_load_b128 v[16:19], v[22:23], off
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[16:19], v[9:12], v[0:7]
	v_mov_b32_e32 v16, 0
	s_and_saveexec_b32 s3, vcc_lo
	s_cbranch_execz .LBB0_72
	v_lshlrev_b64_e32 v[9:10], 1, v[20:21]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v9, s0, s18, v9
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v10, null, s19, v10, s0
	global_load_b128 v[13:16], v[9:10], off offset:163872
.LBB0_72:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
	global_load_b128 v[26:29], v[22:23], off offset:32
	v_dual_mov_b32 v9, 0 :: v_dual_mov_b32 v10, 0
	v_mov_b32_e32 v11, 0
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[26:29], v[13:16], v[0:7]
	s_and_saveexec_b32 s3, vcc_lo
	s_cbranch_execz .LBB0_74
	v_lshlrev_b64_e32 v[8:9], 1, v[20:21]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v8, s0, s18, v8
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v9, null, s19, v9, s0
	global_load_b128 v[8:11], v[8:9], off offset:163904
.LBB0_74:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
	global_load_b128 v[26:29], v[22:23], off offset:64
	v_dual_mov_b32 v12, 0 :: v_dual_mov_b32 v15, 0
	v_dual_mov_b32 v16, 0 :: v_dual_mov_b32 v17, 0
	v_mov_b32_e32 v18, 0
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[26:29], v[8:11], v[0:7]
	s_and_saveexec_b32 s3, vcc_lo
	s_cbranch_execz .LBB0_76
	v_lshlrev_b64_e32 v[8:9], 1, v[20:21]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v8, s0, s18, v8
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v9, null, s19, v9, s0
	global_load_b128 v[15:18], v[8:9], off offset:163936
.LBB0_76:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
	global_load_b128 v[8:11], v[22:23], off offset:96
	v_dual_mov_b32 v13, 0 :: v_dual_mov_b32 v14, 0
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[8:11], v[15:18], v[0:7]
	v_mov_b32_e32 v15, 0
	s_and_saveexec_b32 s3, vcc_lo
	s_cbranch_execz .LBB0_78
	v_lshlrev_b64_e32 v[8:9], 1, v[20:21]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v8, s0, s18, v8
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v9, null, s19, v9, s0
	global_load_b128 v[12:15], v[8:9], off offset:163968
.LBB0_78:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
	global_load_b128 v[26:29], v[22:23], off offset:128
	v_dual_mov_b32 v8, 0 :: v_dual_mov_b32 v17, 0
	v_dual_mov_b32 v16, 0 :: v_dual_mov_b32 v19, 0
	v_mov_b32_e32 v18, 0
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[26:29], v[12:15], v[0:7]
	s_and_saveexec_b32 s3, vcc_lo
	s_cbranch_execz .LBB0_80
	v_lshlrev_b64_e32 v[9:10], 1, v[20:21]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v9, s0, s18, v9
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v10, null, s19, v10, s0
	global_load_b128 v[16:19], v[9:10], off offset:164000
.LBB0_80:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
	global_load_b128 v[11:14], v[22:23], off offset:160
	v_dual_mov_b32 v9, 0 :: v_dual_mov_b32 v10, 0
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[11:14], v[16:19], v[0:7]
	v_mov_b32_e32 v11, 0
	s_and_saveexec_b32 s3, vcc_lo
	s_cbranch_execz .LBB0_82
	v_lshlrev_b64_e32 v[8:9], 1, v[20:21]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v8, s0, s18, v8
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v9, null, s19, v9, s0
	global_load_b128 v[8:11], v[8:9], off offset:164032
.LBB0_82:
	s_wait_alu depctr_sa_sdst(0)
	s_or_b32 exec_lo, exec_lo, s3
	global_load_b128 v[15:18], v[22:23], off offset:192
	v_dual_mov_b32 v12, 0 :: v_dual_mov_b32 v13, 0
	v_mov_b32_e32 v14, 0
	s_wait_loadcnt 0x0
	v_wmma_f32_16x16x16_bf16 v[0:7], v[15:18], v[8:11], v[0:7]
	v_mov_b32_e32 v15, 0
	s_and_saveexec_b32 s3, vcc_lo
	s_cbranch_execz .LBB0_67
	v_lshlrev_b64_e32 v[8:9], 1, v[20:21]
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add_co_u32 v8, s0, s18, v8
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v9, null, s19, v9, s0
	global_load_b128 v[12:15], v[8:9], off offset:164064
	s_branch .LBB0_67
.LBB0_84:
	s_and_saveexec_b32 s2, vcc_lo
	s_cbranch_execz .LBB0_65
	v_or_b32_e32 v8, s1, v32
	v_bfe_u32 v10, v0, 16, 1
	v_or_b32_e32 v11, 0x400000, v0
	v_bfe_u32 v12, v1, 16, 1
	v_cmp_u_f32_e64 s0, v0, v0
	v_add_nc_u32_e32 v8, v8, v33
	v_add3_u32 v10, v10, v0, 0x7fff
	v_or_b32_e32 v13, 0x400000, v1
	v_add3_u32 v12, v12, v1, 0x7fff
	v_bfe_u32 v14, v2, 16, 1
	v_ashrrev_i32_e32 v9, 31, v8
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v0, v10, v11, s0
	v_cmp_u_f32_e64 s0, v1, v1
	v_or_b32_e32 v15, 0x400000, v2
	v_add3_u32 v14, v14, v2, 0x7fff
	v_lshlrev_b64_e32 v[8:9], 1, v[8:9]
	v_bfe_u32 v16, v3, 16, 1
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v1, v12, v13, s0
	v_or_b32_e32 v12, 0x400000, v3
	v_bfe_u32 v13, v4, 16, 1
	v_lshrrev_b32_e32 v0, 16, v0
	v_add_co_u32 v8, s0, s14, v8
	s_wait_alu depctr_va_sdst(0)
	v_add_co_ci_u32_e64 v9, null, s15, v9, s0
	v_cmp_u_f32_e64 s0, v2, v2
	v_lshrrev_b32_e32 v10, 16, v1
	v_add3_u32 v11, v16, v3, 0x7fff
	v_or_b32_e32 v16, 0x400000, v7
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v2, v14, v15, s0
	v_cmp_u_f32_e64 s0, v3, v3
	v_or_b32_e32 v14, 0x400000, v5
	v_bfe_u32 v15, v6, 16, 1
	v_mov_b16_e32 v0.h, v10.l
	v_lshrrev_b32_e32 v1, 16, v2
	v_bfe_u32 v2, v5, 16, 1
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v3, v11, v12, s0
	v_bfe_u32 v12, v7, 16, 1
	v_cmp_u_f32_e64 s0, v5, v5
	v_add3_u32 v11, v13, v4, 0x7fff
	v_add3_u32 v2, v2, v5, 0x7fff
	v_or_b32_e32 v13, 0x400000, v4
	v_add3_u32 v12, v12, v7, 0x7fff
	v_add3_u32 v5, v15, v6, 0x7fff
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v2, v2, v14, s0
	v_cmp_u_f32_e64 s0, v7, v7
	v_or_b32_e32 v14, 0x400000, v6
	s_wait_alu depctr_va_sdst(0)
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_2) | instid1(VALU_DEP_1)
	v_cndmask_b32_e64 v7, v12, v16, s0
	v_cmp_u_f32_e64 s0, v4, v4
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v4, v11, v13, s0
	v_cmp_u_f32_e64 s0, v6, v6
	v_lshrrev_b32_e32 v6, 16, v7
	v_lshrrev_b32_e32 v7, 16, v2
	v_lshrrev_b32_e32 v11, 16, v3
	v_lshrrev_b32_e32 v2, 16, v4
	s_wait_alu depctr_va_sdst(0)
	v_cndmask_b32_e64 v5, v5, v14, s0
	v_mov_b16_e32 v2.h, v7.l
	v_mov_b16_e32 v1.h, v11.l
	s_delay_alu instid0(VALU_DEP_3)
	v_lshrrev_b32_e32 v3, 16, v5
	v_mov_b16_e32 v3.h, v6.l
	global_store_b128 v[8:9], v[0:3], off
	s_branch .LBB0_65
.LBB0_86:
	s_endpgm
.Lfunc_end0:
	.size	qwen_tp_shard_bf16_h5120_i4352_b1, .Lfunc_end0-qwen_tp_shard_bf16_h5120_i4352_b1
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel qwen_tp_shard_bf16_h5120_i4352_b1
		.amdhsa_group_segment_fixed_size 24
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 96
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
		.amdhsa_next_free_sgpr 36
		.amdhsa_reserve_vcc 1
		.amdhsa_float_round_mode_32 0
		.amdhsa_float_round_mode_16_64 0
		.amdhsa_float_denorm_mode_32 3
		.amdhsa_float_denorm_mode_16_64 3
		.amdhsa_fp16_overflow 0
		.amdhsa_workgroup_processor_mode 1
		.amdhsa_memory_ordered 1
		.amdhsa_forward_progress 1
		.amdhsa_inst_pref_size ((instprefsize(.Lfunc_end0-qwen_tp_shard_bf16_h5120_i4352_b1)<<4)&4080)>>4
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

	.set .Lqwen_tp_shard_bf16_h5120_i4352_b1.num_vgpr, 45
	.set .Lqwen_tp_shard_bf16_h5120_i4352_b1.num_agpr, 0
	.set .Lqwen_tp_shard_bf16_h5120_i4352_b1.numbered_sgpr, 36
	.set .Lqwen_tp_shard_bf16_h5120_i4352_b1.num_named_barrier, 0
	.set .Lqwen_tp_shard_bf16_h5120_i4352_b1.private_seg_size, 0
	.set .Lqwen_tp_shard_bf16_h5120_i4352_b1.uses_vcc, 1
	.set .Lqwen_tp_shard_bf16_h5120_i4352_b1.uses_flat_scratch, 0
	.set .Lqwen_tp_shard_bf16_h5120_i4352_b1.has_dyn_sized_stack, 0
	.set .Lqwen_tp_shard_bf16_h5120_i4352_b1.has_recursion, 0
	.set .Lqwen_tp_shard_bf16_h5120_i4352_b1.has_indirect_call, 0
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
      - .offset:         80
        .size:           4
        .value_kind:     by_value
      - .offset:         84
        .size:           4
        .value_kind:     by_value
      - .offset:         88
        .size:           4
        .value_kind:     by_value
      - .offset:         92
        .size:           4
        .value_kind:     by_value
    .group_segment_fixed_size: 24
    .kernarg_segment_align: 8
    .kernarg_segment_size: 96
    .max_flat_workgroup_size: 128
    .name:           qwen_tp_shard_bf16_h5120_i4352_b1
    .private_segment_fixed_size: 0
    .reqd_workgroup_size:
      - 128
      - 1
      - 1
    .sgpr_count:     38
    .sgpr_spill_count: 0
    .symbol:         qwen_tp_shard_bf16_h5120_i4352_b1.kd
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
