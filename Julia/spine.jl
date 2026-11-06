using LinearAlgebra

# 1. Agnostic System Manifest
struct SystemManifest
    id::String
    ontology_dimension::Int
    adjacency::Matrix{Float64}
    semantics::Vector{Float64} # Pure un-normalized vector weights in R^N
end

# 2. A6 Firewall Evaluator (Simulated 13 Constructive Fixes)
function evaluate_a6_firewall(sys::SystemManifest)::Vector{Int}
    signature = ones(Int, 13)
    if abs(det(sys.adjacency)) < 1e-5
        signature[7] = 0 # Vulnerability specifically trips fix #7
    end
    return signature
end

# 3. Multi-Spectral Deviation Matrix Calculator
function compute_tri_spectral_deviation(sysA::SystemManifest, sysB::SystemManifest, sysC::SystemManifest)::Float64
    specA = sort(real(eigen(sysA.adjacency).values))
    specB = sort(real(eigen(sysB.adjacency).values))
    specC = sort(real(eigen(sysC.adjacency).values))
    
    return norm(specA - specB) + norm(specB - specC) + norm(specC - specA)
end

# 4. Stabilized Scale-Invariant Cosine Distance Engine
function safe_cosine_distance(v1::Vector{Float64}, v2::Vector{Float64})::Float64
    norm1 = norm(v1)
    norm2 = norm(v2)
    
    # Structural Safeguard: If either vector collapses to zero magnitude,
    # return a maximal orthogonal penalty (1.0) rather than allowing NaN propagation.
    if norm1 < 1e-12 || norm2 < 1e-12
        return 1.0
    end
    
    # Compute the clamped inner product to prevent floating-point bleed past [-1.0, 1.0]
    cos_theta = dot(v1, v2) / (norm1 * norm2)
    cos_theta = clamp(cos_theta, -1.0, 1.0)
    
    return 1.0 - cos_theta
end

function compute_tri_geometric_deviation(sysA::SystemManifest, sysB::SystemManifest, sysC::SystemManifest)::Float64
    d_AB = safe_cosine_distance(sysA.semantics, sysB.semantics)
    d_BC = safe_cosine_distance(sysB.semantics, sysC.semantics)
    d_CA = safe_cosine_distance(sysC.semantics, sysA.semantics)
    
    return d_AB + d_BC + d_CA
end

# 5. Core Diagnostics Controller
function run_diagnostics(sysA::SystemManifest, sysB::SystemManifest, sysC::SystemManifest)
    Σ_3 = [
        evaluate_a6_firewall(sysA)';
        evaluate_a6_firewall(sysB)';
        evaluate_a6_firewall(sysC)'
    ]
    
    D_spec = compute_tri_spectral_deviation(sysA, sysB, sysC)
    D_geo  = compute_tri_geometric_deviation(sysA, sysB, sysC)
    
    println("=== TRI-SYSTEM ENCLAVE DIAGNOSTICS ===")
    println("Firewall Matrix State (Σ_3):")
    display(Σ_3)
    
    println("\nMulti-Spectral Deviation (D_spec):   ", round(D_spec, digits=6))
    println("Tri-Geometric Deviation (D_geo):     ", round(D_geo, digits=6))
    
    if 0 in Σ_3
        println("🚨 STATUS: CRITICAL - A6 Firewall Breach Detected!")
    elseif D_spec < 1e-4
        println("🚨 STATUS: CRITICAL - Tri-System Spectral Collapse Impending!")
    elseif D_geo < 1e-4
        println("🚨 STATUS: CRITICAL - Geometric Semantic Collapse Detected!")
    else
        println("✅ STATUS: SECURE - Systems Isolated within Geometric A6 Boundaries.")
    end
end

# === Runtime Testing & Verification Setup ===
dim = 5
mat_A = (rand(dim, dim) + rand(dim, dim)') / 2
mat_B = (rand(dim, dim) + rand(dim, dim)') / 2
mat_C = (rand(dim, dim) + rand(dim, dim)') / 2

# Baseline Isolated Architectures
sysA = SystemManifest("Arch_A", dim, mat_A, rand(dim) .* 10.0)
sysB = SystemManifest("Arch_B", dim, mat_B, rand(dim) .* 5.0)

println("--- Case 1: Active Absolute Vector Collapse Simulation ---")
# System C completely crashes out or is uninitialized (All zero weights)
sysC_collapsed = SystemManifest("Arch_C_Zero", dim, mat_C, zeros(dim))

# Run check to verify that our safe execution boundary intercepts NaN errors
run_diagnostics(sysA, sysB, sysC_collapsed)

