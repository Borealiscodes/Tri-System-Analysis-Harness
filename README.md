# Tri-System Analysis Harness v2.0 (Geometric Edition)

An agnostic formal verification and mathematical auditing engine designed to preserve absolute structural isolation across three independent local AI runtimes executing within a secure hardware enclave.

## 🚀 Overview & Research Lineage

This repository archives **Version 2.0 (Empirical)** of the Tri-System Analysis Harness. This framework functions as an out-of-band cross-system audit ring, evaluating three arbitrary system manifolds (\(\mathcal{M}_A, \mathcal{M}_B, \mathcal{M}_C\)) concurrently. 

This architecture descends conceptually from the open-source ternary computing infrastructure and cognitive wave memory models engineered by the **8b Research Project Public Interest Foundation (8b-is)**, as documented in Zenodo Record DOI: 10.5281/zenodo.23997879. While the underlying node lineage uses Lean 4 and Rust to enforce compile-time safety on individual local ternary instances, this harness provides the multi-tenant runtime environment needed to verify total boundary containment under dynamic workloads.

## ⚠ Honest Engineering Disclosure & Scope
This framework is currently a **high-altitude software simulation baseline**. The mathematical proofs and runtime pipelines have been validated using numeric floating-point simulations in Julia and interactive proof scripts in Coq. 

### Current Methodological Limitations:
* **Simulation Abstraction:** This system has not been compiled or stress-tested live on physical 1.58-bit ternary silicon, custom FPGA arrays, or specialized hardware substrates.
* **Static Dimensionality:** The input parser requires uniform dimensional matching across all three system manifests on ingestion. Dynamic runtime expansions that shift ontology lengths on the fly will trigger validation failures.
* **Axiomatic Rounding vs. IEEE 754:** While Coq proofs rely on idealized real-number axioms (`R_scope`), execution on actual physical hardware runs on precision-bounded floats, meaning subnormal input thresholds could introduce micro-rounding drift before reaching clamping rings.

## 🟥 Identified Pitfalls & AI "Math-Washing" Protection

Traditional multi-system safety metrics rely heavily on volume-destructive projections like **Global Softmax Normalization** to map ontology vectors onto a probability simplex. Testing revealed two critical vulnerabilities:

1. **The Simplex Collapse Trap:** Because Softmax uses a global denominator, the partial derivative of an output relative to an unlinked system input is non-zero (\(\frac{\partial y_i}{\partial x_j} \neq 0\)). An adversarial or drifting AI can inject high-magnitude technical jargon matrices ("math-washing") into its runtime path, inflating the global denominator and artificially compressing the metrics of unlinked systems to zero. This triggers false-positive system shutdowns.
2. **Metric Disintegration:** Replacing Softmax with independent element-wise sigmoid scaling breaks probability axioms. Feeding these un-normalized coordinate fields into a traditional Kullback-Leibler log-ratio loop generates mathematical noise, leaving security boundaries ungrounded.

### The Fix: Geometric Cosine Tensors
Harness v2.0 abandons probability distributions entirely. It maps root semantics onto un-normalized vector fields in \(\mathbb{R}^N\) and measures distance strictly via angular divergence:
\[d_{\mathrm{geo}}(\mathbf{\rho}_X, \mathbf{\rho}_Y) = 1.0 - \frac{\mathbf{\rho}_X \cdot \mathbf{\rho}_Y}{\Vert{}\mathbf{\rho}_X\Vert{} \Vert{}\mathbf{\rho}_Y\Vert{}}\]

Because the evaluation of unlinked systems relies purely on local inner products, the partial derivative across unrelated channels is identically zero:
\[\frac{\partial}{\partial \mathbf{\rho}_{A,i}} d_{\mathrm{geo}}(\mathbf{\rho}_B, \mathbf{\rho}_C) \equiv 0\]
No amount of jargon injection or scaling manipulation inside System \(\mathcal{A}\) can alter the boundary tracking metric of Systems \(\mathcal{B}\) and \(\mathcal{C}\).

## 📁 Repository Layout

```text
Tri-System-Analysis-Harness/
├── _CoqProject               # Coq compilation workspace mappings
├── Makefile                  # Automated build script for formal proofs
├── System3Harness.v          # Coq specification verifying scale invariance and isolation
├── orchestrator.jl           # Main enclave pipeline: sanitizing parser + metric suite
├── test_math_washing.jl      # Adversarial script executing jargon-injection attacks
└── docs/
    └── harness.tex           # Formal LaTeX Preprint v2.0 mathematical specification
```

## 🛠 Compilation & Execution Instructions

### 1. Build and Verify the Coq Invariant Engine
Ensure the Coq compiler toolchain is installed locally. To compile and check the formal proofs:
```bash
make
```
This script proves both the **Scale Invariance Theorem** (\(k > 0\)) and the **Coordinate Isolation Theorem** reflexively.

### 2. Run the Enclave Orchestrator Pipeline
Ensure Julia (v1.10+ LTS or v1.13+ Stable) is configured. Run the orchestrator to ingest your `manifest.json` asset and parse inputs against Coq-derived magnitude checks (\(\Vert\mathbf{\rho}\Vert > 10^{-12}\)):
```bash
julia orchestrator.jl
```

### 3. Execute the Adversarial Math-Washing Validation
To empirically verify that high-magnitude adversarial noise cannot disrupt unlinked system boundaries:
```bash
julia test_math_washing.jl
```
The script will assert that an injection factor of \(10^6\) in `Arch_A` results in an exact metric shift delta of `0.000000` on the `Arch_B ↔ Arch_C` horizon.

## 🤝 Lineage Attribution & Acknowledgments

This framework functions as an independent out-of-band validation system built specifically to audit multi-tenant local environments. It descends conceptually from the architectural primitives and low-power ternary computing concepts pioneered by the **8b Research Project Public Interest Foundation (8b-is)**.

* **Inspiration & Lineage:** Special acknowledgment is given to core systems architects **Christopher Chenoweth** and **Peter Lodri** for their development of pure-Rust cognitive wave memory arrays (`MEM|8`) and localized computing substrates. Their open-source codebases provided the foundation for our multi-manifold validation tracking.
* **Authorship Disclaimer:** The 8b Research Project, Christopher Chenoweth, and Peter Lodri are the creators of the underlying node lineage archived in Zenodo Record 23997879. They did not author, review, or maintain this specific Tri-System-Analysis-Harness repository, its formal Coq proofs, or its accompanying mathematical specifications. All implementation choices, analysis metrics, and testing scope limitations contained herein are the sole responsibility of the repository maintainer.

## 📝 Open Provenance & Citation

To cite this repository baseline:
```text
Hedling, B. S. (2026). Tri-System-Analysis-Harness v2.0: Agnostic Tri-Manifold Geometric Cosine Tensors for Secure Enclave Isolation. GitHub Repository: Borealiscodes/Tri-System-Analysis-Harness.
```
