; ModuleID = 'backprop_kernel.cl'
source_filename = "backprop_kernel.cl"
target datalayout = "e-m:e-p:32:32-i64:64-n32-S128-A5-G1"
target triple = "riscv32"

; Function Attrs: convergent norecurse nounwind vscale_range(1,2048)
define dso_local ventus_kernel void @bpnn_layerforward_ocl(ptr addrspace(1) nocapture noundef readonly align 4 %0, ptr addrspace(1) nocapture noundef readnone align 4 %1, ptr addrspace(1) nocapture noundef align 4 %2, ptr addrspace(1) nocapture noundef writeonly align 4 %3, ptr addrspace(3) nocapture noundef align 4 %4, ptr addrspace(3) nocapture noundef align 4 %5, i32 noundef %6, i32 noundef %7) local_unnamed_addr #0 !kernel_arg_addr_space !6 !kernel_arg_access_qual !7 !kernel_arg_type !8 !kernel_arg_base_type !8 !kernel_arg_type_qual !9 {
  %9 = call i32 @_Z12get_group_idj(i32 noundef 1) #4
  %10 = call i32 @_Z12get_local_idj(i32 noundef 0) #4
  %11 = call i32 @_Z12get_local_idj(i32 noundef 1) #4
  %12 = add nsw i32 %7, 1
  %13 = shl i32 %9, 4
  %14 = add i32 %11, %13
  %15 = mul i32 %14, %12
  %16 = add i32 %7, 2
  %17 = add i32 %16, %10
  %18 = add i32 %17, %15
  %19 = icmp eq i32 %10, 0
  br i1 %19, label %20, label %26

20:                                               ; preds = %8
  %21 = getelementptr inbounds float, ptr addrspace(3) %4, i32 %11
  %22 = or i32 %13, 1
  %23 = add i32 %22, %11
  %24 = getelementptr inbounds float, ptr addrspace(1) %0, i32 %23
  %25 = load float, ptr addrspace(1) %24, align 4, !tbaa !10
  store float %25, ptr addrspace(3) %21, align 4, !tbaa !10
  br label %26

26:                                               ; preds = %20, %8
  call void @llvm.riscv.ventus.barrier(i32 1)
  %27 = getelementptr inbounds float, ptr addrspace(1) %2, i32 %18
  %28 = load float, ptr addrspace(1) %27, align 4, !tbaa !10
  %29 = shl nsw i32 %11, 4
  %30 = add nsw i32 %29, %10
  %31 = getelementptr inbounds float, ptr addrspace(3) %5, i32 %30
  store float %28, ptr addrspace(3) %31, align 4, !tbaa !10
  call void @llvm.riscv.ventus.barrier(i32 1)
  %32 = load float, ptr addrspace(3) %31, align 4, !tbaa !10
  %33 = getelementptr inbounds float, ptr addrspace(3) %4, i32 %11
  %34 = load float, ptr addrspace(3) %33, align 4, !tbaa !10
  %35 = fmul float %32, %34
  store float %35, ptr addrspace(3) %31, align 4, !tbaa !10
  call void @llvm.riscv.ventus.barrier(i32 1)
  %36 = load float, ptr addrspace(3) %31, align 4, !tbaa !10
  %37 = fadd float %36, %36
  store float %37, ptr addrspace(3) %31, align 4, !tbaa !10
  call void @llvm.riscv.ventus.barrier(i32 1)
  %38 = and i32 %11, 1
  %39 = icmp eq i32 %38, 0
  br i1 %39, label %40, label %48

40:                                               ; preds = %26
  %41 = load float, ptr addrspace(3) %31, align 4, !tbaa !10
  %42 = shl i32 %11, 4
  %43 = add i32 %42, 16
  %44 = add nsw i32 %43, %10
  %45 = getelementptr inbounds float, ptr addrspace(3) %5, i32 %44
  %46 = load float, ptr addrspace(3) %45, align 4, !tbaa !10
  %47 = fadd float %41, %46
  store float %47, ptr addrspace(3) %31, align 4, !tbaa !10
  br label %48

48:                                               ; preds = %40, %26
  call void @llvm.riscv.ventus.barrier(i32 1)
  %49 = and i32 %11, 3
  %50 = icmp eq i32 %49, 0
  br i1 %50, label %51, label %59

51:                                               ; preds = %48
  %52 = load float, ptr addrspace(3) %31, align 4, !tbaa !10
  %53 = shl i32 %11, 4
  %54 = add i32 %53, 32
  %55 = add nsw i32 %54, %10
  %56 = getelementptr inbounds float, ptr addrspace(3) %5, i32 %55
  %57 = load float, ptr addrspace(3) %56, align 4, !tbaa !10
  %58 = fadd float %52, %57
  store float %58, ptr addrspace(3) %31, align 4, !tbaa !10
  br label %59

59:                                               ; preds = %51, %48
  call void @llvm.riscv.ventus.barrier(i32 1)
  %60 = and i32 %11, 7
  %61 = icmp eq i32 %60, 0
  br i1 %61, label %62, label %70

62:                                               ; preds = %59
  %63 = load float, ptr addrspace(3) %31, align 4, !tbaa !10
  %64 = shl i32 %11, 4
  %65 = add i32 %64, 64
  %66 = add nsw i32 %65, %10
  %67 = getelementptr inbounds float, ptr addrspace(3) %5, i32 %66
  %68 = load float, ptr addrspace(3) %67, align 4, !tbaa !10
  %69 = fadd float %63, %68
  store float %69, ptr addrspace(3) %31, align 4, !tbaa !10
  br label %70

70:                                               ; preds = %62, %59
  call void @llvm.riscv.ventus.barrier(i32 1)
  %71 = and i32 %11, 15
  %72 = icmp eq i32 %71, 0
  br i1 %72, label %73, label %81

73:                                               ; preds = %70
  %74 = load float, ptr addrspace(3) %31, align 4, !tbaa !10
  %75 = shl i32 %11, 4
  %76 = add i32 %75, 128
  %77 = add nsw i32 %76, %10
  %78 = getelementptr inbounds float, ptr addrspace(3) %5, i32 %77
  %79 = load float, ptr addrspace(3) %78, align 4, !tbaa !10
  %80 = fadd float %74, %79
  store float %80, ptr addrspace(3) %31, align 4, !tbaa !10
  br label %81

81:                                               ; preds = %73, %70
  call void @llvm.riscv.ventus.barrier(i32 1)
  %82 = load float, ptr addrspace(3) %31, align 4, !tbaa !10
  store float %82, ptr addrspace(1) %27, align 4, !tbaa !10
  call void @llvm.riscv.ventus.barrier(i32 1)
  br i1 %19, label %83, label %89

83:                                               ; preds = %81
  %84 = mul nsw i32 %9, %7
  %85 = add nsw i32 %11, %84
  %86 = getelementptr inbounds float, ptr addrspace(1) %3, i32 %85
  %87 = getelementptr inbounds float, ptr addrspace(3) %5, i32 %11
  %88 = load float, ptr addrspace(3) %87, align 4, !tbaa !10
  store float %88, ptr addrspace(1) %86, align 4, !tbaa !10
  br label %89

89:                                               ; preds = %83, %81
  ret void
}

; Function Attrs: convergent mustprogress nofree nounwind willreturn memory(none)
declare dso_local i32 @_Z12get_group_idj(i32 noundef) local_unnamed_addr #1

; Function Attrs: convergent mustprogress nofree nounwind willreturn memory(none)
declare dso_local i32 @_Z12get_local_idj(i32 noundef) local_unnamed_addr #1

; Function Attrs: nounwind
declare void @llvm.riscv.ventus.barrier(i32 immarg) #2

; Function Attrs: convergent norecurse nounwind vscale_range(1,2048)
define dso_local ventus_kernel void @bpnn_adjust_weights_ocl(ptr addrspace(1) nocapture noundef readonly align 4 %0, i32 noundef %1, ptr addrspace(1) nocapture noundef readonly align 4 %2, i32 noundef %3, ptr addrspace(1) nocapture noundef align 4 %4, ptr addrspace(1) nocapture noundef align 4 %5) local_unnamed_addr #0 !kernel_arg_addr_space !14 !kernel_arg_access_qual !15 !kernel_arg_type !16 !kernel_arg_base_type !16 !kernel_arg_type_qual !17 {
  %7 = call i32 @_Z12get_group_idj(i32 noundef 1) #4
  %8 = call i32 @_Z12get_local_idj(i32 noundef 0) #4
  %9 = call i32 @_Z12get_local_idj(i32 noundef 1) #4
  %10 = add nsw i32 %1, 1
  %11 = shl i32 %7, 4
  %12 = add i32 %9, %11
  %13 = mul i32 %12, %10
  %14 = add i32 %8, 1
  %15 = add i32 %14, %10
  %16 = add i32 %15, %13
  %17 = or i32 %11, 1
  %18 = add i32 %17, %9
  %19 = getelementptr inbounds float, ptr addrspace(1) %0, i32 %14
  %20 = load float, ptr addrspace(1) %19, align 4, !tbaa !10
  %21 = fmul float %20, 0x3FD3333340000000
  %22 = getelementptr inbounds float, ptr addrspace(1) %2, i32 %18
  %23 = load float, ptr addrspace(1) %22, align 4, !tbaa !10
  %24 = getelementptr inbounds float, ptr addrspace(1) %5, i32 %16
  %25 = load float, ptr addrspace(1) %24, align 4, !tbaa !10
  %26 = fmul float %25, 0x3FD3333340000000
  %27 = call float @llvm.fmuladd.f32(float %21, float %23, float %26)
  %28 = getelementptr inbounds float, ptr addrspace(1) %4, i32 %16
  %29 = load float, ptr addrspace(1) %28, align 4, !tbaa !10
  %30 = fadd float %29, %27
  store float %30, ptr addrspace(1) %28, align 4, !tbaa !10
  %31 = load float, ptr addrspace(1) %19, align 4, !tbaa !10
  %32 = fmul float %31, 0x3FD3333340000000
  %33 = load float, ptr addrspace(1) %22, align 4, !tbaa !10
  %34 = load float, ptr addrspace(1) %24, align 4, !tbaa !10
  %35 = fmul float %34, 0x3FD3333340000000
  %36 = call float @llvm.fmuladd.f32(float %32, float %33, float %35)
  store float %36, ptr addrspace(1) %24, align 4, !tbaa !10
  call void @llvm.riscv.ventus.barrier(i32 1)
  %37 = icmp eq i32 %9, 0
  %38 = icmp eq i32 %7, 0
  %39 = select i1 %37, i1 %38, i1 false
  br i1 %39, label %40, label %53

40:                                               ; preds = %6
  %41 = load float, ptr addrspace(1) %19, align 4, !tbaa !10
  %42 = getelementptr inbounds float, ptr addrspace(1) %5, i32 %14
  %43 = load float, ptr addrspace(1) %42, align 4, !tbaa !10
  %44 = fmul float %43, 0x3FD3333340000000
  %45 = call float @llvm.fmuladd.f32(float %41, float 0x3FD3333340000000, float %44)
  %46 = getelementptr inbounds float, ptr addrspace(1) %4, i32 %14
  %47 = load float, ptr addrspace(1) %46, align 4, !tbaa !10
  %48 = fadd float %47, %45
  store float %48, ptr addrspace(1) %46, align 4, !tbaa !10
  %49 = load float, ptr addrspace(1) %19, align 4, !tbaa !10
  %50 = load float, ptr addrspace(1) %42, align 4, !tbaa !10
  %51 = fmul float %50, 0x3FD3333340000000
  %52 = call float @llvm.fmuladd.f32(float %49, float 0x3FD3333340000000, float %51)
  store float %52, ptr addrspace(1) %42, align 4, !tbaa !10
  br label %53

53:                                               ; preds = %40, %6
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.fmuladd.f32(float, float, float) #3

attributes #0 = { convergent norecurse nounwind vscale_range(1,2048) "disable-tail-calls"="true" "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ventus-gpgpu" "target-features"="+32bit,+a,+m,+relax,+zdinx,+zfinx,+zhinx,+zve32f,+zve32x,+zvl32b,-64bit,-save-restore" "uniform-work-group-size"="false" }
attributes #1 = { convergent mustprogress nofree nounwind willreturn memory(none) "disable-tail-calls"="true" "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ventus-gpgpu" "target-features"="+32bit,+a,+m,+relax,+zdinx,+zfinx,+zhinx,+zve32f,+zve32x,+zvl32b,-64bit,-save-restore" }
attributes #2 = { nounwind }
attributes #3 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #4 = { convergent nounwind willreturn memory(none) }

!llvm.module.flags = !{!0, !1, !2, !3}
!opencl.ocl.version = !{!4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"target-abi", !"ilp32"}
!2 = !{i32 7, !"frame-pointer", i32 2}
!3 = !{i32 1, !"SmallDataLimit", i32 8}
!4 = !{i32 2, i32 0}
!5 = !{!"clang version 16.0.0 (https://github.com/THU-DSP-LAB/llvm-project.git 248085fdbeac0b5cc25151889a840643dc74972d)"}
!6 = !{i32 1, i32 1, i32 1, i32 1, i32 3, i32 3, i32 0, i32 0}
!7 = !{!"none", !"none", !"none", !"none", !"none", !"none", !"none", !"none"}
!8 = !{!"float*", !"float*", !"float*", !"float*", !"float*", !"float*", !"int", !"int"}
!9 = !{!"", !"", !"", !"", !"", !"", !"", !""}
!10 = !{!11, !11, i64 0}
!11 = !{!"float", !12, i64 0}
!12 = !{!"omnipotent char", !13, i64 0}
!13 = !{!"Simple C/C++ TBAA"}
!14 = !{i32 1, i32 0, i32 1, i32 0, i32 1, i32 1}
!15 = !{!"none", !"none", !"none", !"none", !"none", !"none"}
!16 = !{!"float*", !"int", !"float*", !"int", !"float*", !"float*"}
!17 = !{!"", !"", !"", !"", !"", !""}
