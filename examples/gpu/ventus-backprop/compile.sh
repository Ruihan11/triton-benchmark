#!/bin/bash

export LLVM_BUILD_DIR=${LLVM_BUILD_DIR:-"/root/ventus/llvm-project/build"}
export VENTUS_INSTALL_PREFIX=${VENTUS_INSTALL_PREFIX:-"/root/ventus/llvm-project/install"}
export SPIKE_SRC_DIR=${SPIKE_SRC_DIR:-"/root/ventus/ventus-gpgpu-isa-simulator"}
export VENTUS_SPIKE_BUILD="${SPIKE_SRC_DIR}/gpgpu-testcase/driver/build"

MLIR_TRANSLATE="${LLVM_BUILD_DIR}/bin/mlir-translate"
LLC="${LLVM_BUILD_DIR}/bin/llc"
LD_LLD="${VENTUS_INSTALL_PREFIX}/bin/ld.lld"
DIFF_TOOL="vimdiff"
FILENAME="backprop_kernel"

# check if files exit
for dir in "$LLVM_BUILD_DIR" "$VENTUS_INSTALL_PREFIX" "$VENTUS_SPIKE_BUILD"; do
    if [ ! -d "$dir" ]; then
        echo "Error: Directory $dir does not exist."
        exit 1
    fi
done

# # OpenCL -> LLVM IR (.ll)
# echo "==>compiling OpenCL code to LLVM IR"
# ${VENTUS_INSTALL_PREFIX}/bin/clang -S -cl-std=CL2.0 -target riscv32 -mcpu=ventus-gpgpu ${FILENAME}.cl -emit-llvm -o ${FILENAME}.ll
# echo "Generated ${FILENAME}.ll"

# MLIR 
echo "==> Converting LL to MLIR"
${MLIR_TRANSLATE} --import-llvm -o ${FILENAME}.mlir ${FILENAME}.ll
echo "Generated ${FILENAME}.mlir"

# echo "==> Converting backprop_official_import_llvm.mlir back to LLVM IR"
# $MLIR_TRANSLATE --mlir-to-llvmir -o ${FILENAME}_llvmir.ll ${FILENAME}.mlir

# # 2. LLVM IR 编译为 RISC-V 汇编
# echo "==> Compiling backprop_official.ll to RISC-V assembly"
# $LLC -mtriple=riscv32 -mcpu=ventus-gpgpu backprop_official.ll -o backprop_official.s

# echo "==> Compiling backprop_manual.ll to RISC-V assembly"
# $LLC -mtriple=riscv32 -mcpu=ventus-gpgpu backprop_manual.ll -o backprop_manual.s

# # 3. 比较不同版本的汇编代码
# echo "==> Comparing assembly differences"
# $DIFF_TOOL backprop_manual.s backprop_official.s

# # 4. 生成 RISC-V 目标文件
# echo "==> Generating object file from backprop.ll"
# $LLC -mtriple=riscv32 -mcpu=ventus-gpgpu --filetype=obj backprop.ll -o backprop.o

# # 5. 链接 RISC-V 可执行文件
# echo "==> Linking RISC-V executable"
# $LD_LLD -o vecadd.riscv \
#     -T ${VENTUS_INSTALL_PREFIX}/../utils/ldscripts/ventus/elf32lriscv.ld \
#     backprop.o \
#     ${VENTUS_INSTALL_PREFIX}/lib/crt0.o \
#     ${VENTUS_INSTALL_PREFIX}/lib/riscv32clc.o \
#     -L${VENTUS_INSTALL_PREFIX}/lib -lworkitem --gc-sections \
#     --init bpnn_layerforward_ocl --init bpnn_adjust_weights_ocl

# # 6. 运行 RISC-V 反向传播算法
# echo "==> Copying executable to Ventus Spike simulator directory"
# cp vecadd.riscv ${VENTUS_SPIKE_BUILD}

# echo "==> Running backpropagation on Ventus Spike simulator"
# ${VENTUS_SPIKE_BUILD}/spike_test

# # 7. 清理生成的中间文件
# echo "==> Cleaning up temporary files"
# rm -f *.s backprop.o vecadd.riscv vecadd.riscv.log

# echo "==> All tasks completed successfully!"
