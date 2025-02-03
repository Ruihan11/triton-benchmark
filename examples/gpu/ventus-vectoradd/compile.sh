#!/bin/bash

# 设置环境变量
MLIR_TRANSLATE=${LLVM_BUILD_DIR}/bin/mlir-translate
MLIR_OPT=${LLVM_BUILD_DIR}/bin/mlir-opt
VENTUS_SPIKE_BUILD=~/myProject/ventus-toolchain/ventus-gpgpu-isa-simulator/gpgpu-testcase/driver/build
LLC=${VENTUS_INSTALL_PREFIX}/bin/llc
LD=${VENTUS_INSTALL_PREFIX}/bin/ld.lld

# 设置文件名
GPU_FILE=gpu.mlir
LLVM_DIALECT_FROM_GPU_FILE=gpu_llvm_dialect.mlir
MLIR_FILE=vecadd.mlir
LLVM_DIALECT_FILE=vecadd_llvm_dialect.mlir
LL_FILE=vecadd.ll
OBJ_FILE=vecadd.o
OUTPUT_FILE=vecadd.riscv

# 生成 LLVM Dialect 文件 (从 GPU 文件)
echo "Generating LLVM Dialect file from GPU file..."
${MLIR_OPT} ${GPU_FILE} \
    --convert-gpu-to-llvm-spv \
    --convert-arith-to-llvm \
    --convert-func-to-llvm=use-bare-ptr-memref-call-conv=true \
    -finalize-memref-to-llvm -o ${LLVM_DIALECT_FROM_GPU_FILE}
echo "Generated ${LLVM_DIALECT_FROM_GPU_FILE} successfully."

# 生成 LLVM Dialect 文件 (从 MLIR 文件)
echo "Generating LLVM Dialect file..."
${MLIR_OPT} ${MLIR_FILE} \
    --pass-pipeline="builtin.module(convert-func-to-llvm{use-bare-ptr-memref-call-conv=true },\
    convert-arith-to-llvm,\
    finalize-memref-to-llvm,\
    reconcile-unrealized-casts)" \
    -o ${LLVM_DIALECT_FILE}
echo "Generated ${LLVM_DIALECT_FILE} successfully."

# 生成 LLVM IR 文件
echo "Generating LLVM IR file..."
${MLIR_TRANSLATE} -mlir-to-llvmir ${LLVM_DIALECT_FILE} -o ${LL_FILE}
sed -i 's/define void @vectorAdd/define ventus_kernel void @vectorAdd/' ${LL_FILE}
echo "Generated ${LL_FILE} successfully."

# # 生成目标文件 (Object File)
# echo "Generating object file..."
# ${LLC} -mtriple=riscv32 -mcpu=ventus-gpgpu --filetype=obj ${LL_FILE} -o ${OBJ_FILE}
# echo "Generated ${OBJ_FILE} successfully."

# # 生成 RISC-V 可执行文件
# echo "Generating RISC-V executable..."
# ${LD} -o ${OUTPUT_FILE} -T ${VENTUS_INSTALL_PREFIX}/../utils/ldscripts/ventus/elf32lriscv.ld \
#     ${OBJ_FILE} ${VENTUS_INSTALL_PREFIX}/lib/crt0.o ${VENTUS_INSTALL_PREFIX}/lib/riscv32clc.o \
#     -L ${VENTUS_INSTALL_PREFIX}/lib -lworkitem --gc-sections --init vectorAdd
# echo "Generated ${OUTPUT_FILE} successfully."

# # 运行 RISC-V 可执行文件
# echo "Running RISC-V executable..."
# cp ${OUTPUT_FILE} ${VENTUS_SPIKE_BUILD}
# ${VENTUS_SPIKE_BUILD}/spike_test
# echo "Execution completed."

