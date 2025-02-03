# 编译流程

## 生成 LLVM Dialect

```sh
${LLVM_DIALECT_FROM_GPU_FILE}: ${GPU_FILE}
	@${MLIR_OPT} $< --convert-gpu-to-llvm-spv --convert-arith-to-llvm --convert-func-to-llvm=use-bare-ptr-memref-call-conv=true -finalize-memref-to-llvm -o $@
```
- gpu.mlir → LLVM Dialect（带 GPU Kernel） 
- 

```sh
${LLVM_DIALECT_FILE}: ${MLIR_FILE}
	@${MLIR_OPT} $< --pass-pipeline="builtin.module(convert-func-to-llvm{use-bare-ptr-memref-call-conv=true },convert-arith-to-llvm,finalize-memref-to-llvm,reconcile-unrealized-casts)" -o $@
```
- vecadd.mlir → LLVM Dialect（普通 MLIR 转换）



${LL_FILE}: ${LLVM_DIALECT_FILE}
	@${MLIR_TRANSLATE} -mlir-to-llvmir $< -o $@
	@sed -i 's/define void @vectorAdd/define ventus_kernel void @vectorAdd/' $@
