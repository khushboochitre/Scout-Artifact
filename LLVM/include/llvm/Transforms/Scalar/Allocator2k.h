//===- RefEqimizer.h - memcpy optimization ------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This pass performs various transformations related to eliminating memcpy
// calls, or transforming sets of stores into memset's.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_TRANSFORMS_SCALAR_ALLOCATOR_H
#define LLVM_TRANSFORMS_SCALAR_ALLOCTAOR_H

#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/CallSite.h"
#include "llvm/IR/PassManager.h"
#include <cstdint>
#include <functional>

namespace llvm {

class AssumptionCache;
class CallInst;
class DominatorTree;
class Function;
class Instruction;
class MemCpyInst;
class MemMoveInst;
class MemoryDependenceResults;
class MemSetInst;
class StoreInst;
class TargetLibraryInfo;
class Value;

class Allocator2kPass : public PassInfoMixin<Allocator2kPass> {

public:
  Allocator2kPass() = default;

private:
};

} // end namespace llvm

#endif
