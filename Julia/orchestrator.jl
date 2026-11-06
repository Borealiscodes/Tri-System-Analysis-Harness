using JSON
using LinearAlgebra

# ==========================================================================
# 1. MUTABLE STRUCT DEFINITIONS & CONTAINERS
# ==========================================================================

struct SystemManifest
    id::String
    ontology_dimension::Int
    adjacency::Matrix{Float64}
    semantics::Vector{Float64}
end

# ==========================================================================
# 2. A6-COMPLIANT DATA INGESTION PARSER
# ==========================================================================

function parse_and_sanitize_enclave_input(filepath::String)::Vector{SystemManifest}
    if !isfile(filepath)
        error("🔒 ENCLAVE SECURITY BREACH: Target payload manifest file missing.")
    end
    
    raw_data = JSON.parsefile(filepath)
    parsed_systems = Vector{SystemManifest}()
    
    if !haskey(raw_data, "systems") || length(raw_data["systems"]) != 3
        error("🚨 VALIDATION FAILURE: Enclave evaluation requires exactly 3 systems.")
    end
    
    expected_dim = -1
    for sys_raw in raw_data["systems"]
        id = string(sys_raw["id"])
        dim = Int(sys_raw["dimension"])
        
        if expected_dim == -1
            expected_dim = dim
        elseif dim != expected_dim
            error("🚨 VALIDATION FAILURE: Mismatched dimensions across systems at '$id'.")
        end
        
        raw_adj = sys_raw["adjacency"]
        # Convert nested array safely to a Float64 Matrix
        adjacency_matrix = hcat(Vector{Float64}.(raw_adj)...)'
        
        if size(adjacency_matrix) != (dim, dim)
            error("🚨 VALIDATION FAILURE: Adjacency dimensions for '$id' do not match declared size.")
        end
        
        semantics_vector = Vector{Float64}(sys_raw["semantics"])
        if length(semantics_vector) != dim
            error("🚨 VALIDATION FAILURE: Semantics vector length for '$id' does not match dimension.")
        end
        
        # Enforce the Coq-proven vector_norm > 0 invariant
        if norm(semantics_vector) < 1e-12
            error("🚨 BOUNDARY CRASH DETECTED: System '$id' submitted a collapsed zero-norm semantic matrix.")
        end
        
        push!(parsed_systems, SystemManifest(id, dim, adjacency_matrix, semantics_vector))
    end
    return parsed_systems
end

# ==========================================================================
# 3. CORE GEOMETRIC & SPECTRAL EVALUATION TENSORS
# ==========================================================================

function evaluate_a6_firewall(sys::SystemManifest)::Vector{Int}
    signature = ones(Int, 13)
    if abs(det(sys.adjacency)) < 1e-5
        signature[7] = 0 # Vulnerability specifically trips constructive fix #7
    end
    return signature
end

function compute_tri_spectral_deviation(sysA::SystemManifest, sysB::SystemManifest, sysC::SystemManifest)::Float64
    specA = sort(real(eigen(sysA.adjacency).values))
    specB = sort(real(eigen(sysB.adjacency).values))
    specC = sort(real(eigen(sysC.adjacency).values))
    
    return norm(specA - specB) + norm(specB - specC) + norm(specC - specA)
end

function safe_cosine_distance(v1::Vector{Float64}, v2::Vector{Float64})::Float64
    norm1, norm2 = norm(v1), norm(v2)
    if norm1 < 1e-12 || norm2 < 1e-12 return 1.0 end
    cos_theta = clamp(dot(v1, v2) / (norm1 * norm2), -1.0, 1.0)
    return 1.0 - cos_theta
end

function compute_tri_geometric_deviation(sysA::SystemManifest, sysB::SystemManifest, sysC::SystemManifest)::Float64
    d_AB = safe_cosine_distance(sysA.semantics, sysB.semantics)
    d_BC = safe_cosine_distance(sysB.semantics, sysC.semantics)
    d_CA = safe_cosine_distance(sysC.semantics, sysA.semantics)
    return d_AB + d_BC + d_CA
end

# ==========================================================================
# 4. ORCHESTRATION PIPELINE CONTROL RING
# ==========================================================================

function execute_enclave_orchestration(manifest_path::String)
    println("🔒 INITIALIZING ENCLAVE SECURITY PIPELINE...")
    
    # Step 1: Parse and sanitize
    systems = parse_and_sanitize_enclave_input(manifest_path)
    sysA, sysB, sysC = systems[1], systems[2], systems[3]
    
    # Step 2: Compute Boundary Diagnostics
    Σ_3 = [evaluate_a6_firewall(sysA)'; evaluate_a6_firewall(sysB)'; evaluate_a6_firewall(sysC)']
    D_spec = compute_tri_spectral_deviation(sysA, sysB, sysC)
    D_geo  = compute_tri_geometric_deviation(sysA, sysB, sysC)
    
    # Step 3: Formal Integrity Assessment Reporting
    println("\n=== TRI-SYSTEM ENCLAVE DIAGNOSTICS (GEOMETRIC A6) ===")
    println("Firewall Matrix State (Σ_3):")
    display(Σ_3)
    println("\nMulti-Spectral Deviation (D_spec):   ", round(D_spec, digits=6))
    println("Tri-Geometric Deviation (D_geo):     ", round(D_geo, digits=6))
    
    if 0 in Σ_3
        println("🚨 STATUS: CRITICAL - A6 Firewall Breach Detected!")
        exit(1)
    elseif D_spec < 1e-4
        println("🚨 STATUS: CRITICAL - Tri-System Spectral Collapse Impending!")
        exit(2)
    elseif D_geo < 1e-4
        println("🚨 STATUS: CRITICAL - Geometric Semantic Collapse Detected!")
        exit(3)
    else
        println("✅ STATUS: SECURE - Systems Isolated within Geometric A6 Boundaries.")
        exit(0)
    end
end

# Trigger pipeline evaluation against local input path
if abspath(PROGRAM_FILE) == @__FILE__
    execute_enclave_orchestration("manifest.json")
end
