# 📄 Developer Note: Mathematical Isolation and the Simplex Collapse Vulnerability


1. Executive Summary

During the engineering transition from a binary system analysis to a 3-system agnostic evaluation engine, a critical architectural vulnerability was identified in standard machine learning normalization pipelines. While Softmax is traditionally used to project real-valued vectors onto a valid probability simplex (\(0 \le \rho_i \le 1, \sum \rho_i = 1\)) for cross-entropy calculations, it introduces a global normalization side-channel. This side-channel violates the core boundary isolation guarantees of the A6 Dual-Algebra Firewall, leading to a systemic vulnerability known as Simplex Collapse.
This note documents why global Softmax was rejected and details the remediation strategy implemented in the Julia testing spine.

2. The Vulnerability Mechanism: Global Coupling

The goal of the A6 firewall is absolute structural isolation: an architectural change or semantic expansion in System \(\mathcal{A}\) must never impact or manipulate the measurement curves of System \(\mathcal{B}\) or \(\mathcal{C}\).

The Mathematical Flaw in Softmax

Softmax normalizes an item \(x_{i}\) by dividing its exponent by the sum of all exponents in the vector:
\(\sigma (x)_{i}=\frac{e^{x_{i}}}{\sum _{j=1}^{N}e^{x_{j}}}\)
Because the denominator is a global sum (\(\sum e^{x_j}\)), the partial derivative of an output coordinate \(y_{i}\) with respect to an unrelated input coordinate \(x_{j}\) is non-zero:
\(\frac{\partial \sigma (x)_{i}}{\partial x_{j}}=-\sigma (x)_{i}\sigma (x)_{j}\ne 0\quad (\text{for\ }i\ne j)\)

The Enclave Side-Channel

If an attacker or an automated update injects a massive semantic weight into a single node within System \(\mathcal{A}\), the global denominator spikes. This artificially compresses the normalized semantic values of all other un-modified nodes in that system toward zero.
When evaluated by the 3-way Kullback-Leibler engine (\(D_{\rho }^{(3)}\)), this mathematical compression registers as a false-positive Root-Semantics Collapse. The system boundaries appear to be blending when, in reality, a single local variable change has cross-contaminated the entire evaluation space.

Normalization Metric	Coordinate Independence (\(\partial y_i / \partial x_j = 0\))	Prevents Division-by-Zero Errors	Preserves Pure Structural Boundaries
Global Softmax	❌ No (Cross-contaminates)	✅ Yes	❌ No
A6 Sigmoid-Scale	✅ Yes (Strict Isolation)	✅ Yes	✅ Yes


3. Remediation: Dimension-Bounded Coordinate Scaling

To restore strict mathematical isolation within the secure enclave runtime, the global Softmax layer was purged from the testing spine and replaced with an Element-wise Sigmoid Normalization bounded by a fixed dimension constant (\(N\)):
\(\rho _{i}=\frac{1}{N}\cdot \frac{1}{1+e^{-x_{i}}}\)

Why This Fix Works

1. Absolute Local Continuity: Because each coordinate is transformed completely independently, the derivative between mismatched indices is strictly zero (\(\partial \rho_i / \partial x_j = 0\)). Mutating node \(x_{1}\) has exactly zero mathematical impact on the evaluated magnitude of node \(x_{2}\).
2. Deterministic Enclave Bounds: Normalizing by the static dimension configuration (\(N\)) instead of a dynamic vector sum ensures that tracking metrics scale linearly. This prevents side-channel execution variance or artificial metric drifting across the 3-manifold ring.

4. Verification Protocol

Developers working within the enclave verification module must ensure that all new invariant lemmas added to CapacityBounds.v or System3Harness.v strictly enforce this coordinate independence. Any pull request reintroducing multi-variant global dependencies across isolated system manifests will fail automated boundary compilation checks.
