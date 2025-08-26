## 上次报告的回顾
在上一次的报告中，我们使用 `gcc -O3 -fopt-info-vec-missed -fvect-cost-model=unlimited` 让 gcc 在不计成本最大化向量化程度的同时，汇报所有向量化失败的输出。

- **simple_vectorizable**: 成功向量化  
  - 证据: ir_vectorization_analysis.txt L55 `src/ir_analysis_test.c:9:23: optimized`
  - 原因: 连续内存的逐元素加法，易于SIMD。

- **complex_loop**: 未向量化  
  - 证据: L51–L52 `src/ir_analysis_test.c:16:23: missed: control flow in loop`
  - 原因: 循环内有分支，阻碍自动向量化。

- **reduction_loop**: 成功向量化  
  - 证据: L48 `src/ir_analysis_test.c:28:23: optimized`
  - 原因: 简单加法归约，编译器可做向量化归约。

- **loop_with_function**: 成功向量化  
  - 证据: L44 `src/ir_analysis_test.c:39:23: optimized`
  - 说明: `some_function` 很短且可内联，消除了函数调用阻碍。

- **nested_loops**: 内层循环成功向量化，外层未向量化  
  - 证据:  
    - 内层成功: L41 `src/ir_analysis_test.c:51:27: optimized`  
    - 外层/相关语句未向量化: L39–L40 `missed: complicated access pattern`
  - 原因: 内层按 `j` 连续访存（`b[j]` 与 `c[i*n + j]` 对 `j` 连续），易向量化；外层对 `i` 的步进不利于SIMD。

- **loop_with_dependencies**: 未向量化  
  - 证据: L33–L36、L34 `missed: complicated access pattern / no vectype`（针对行 59–60）  
  - 原因: 存在跨迭代真实依赖 `a[i-1]`。

- **mixed_types**: 成功向量化  
  - 证据: L31 `src/ir_analysis_test.c:66:23: optimized`
  - 原因: `int` 转 `float` + 逐元素加法可用SIMD指令序列完成。

- **strided_access**: 成功向量化（主体循环），尾处理在标量分支  
  - 证据: L28 `src/ir_analysis_test.c:73:23: optimized`  
  - 注: 日志中也有若干 “missed” 针对同一段的不同尝试/语句级别提示，但最终明确报告了“loop vectorized”。

