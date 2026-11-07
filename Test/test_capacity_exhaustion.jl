# test_capacity_exhaustion.jl
# Phase VI Architecture: Empirical Capacity Containment Invariant Verification

using Test
using LinearAlgebra

println("================================================================================")
println("🌀 EXECUTING EMPIRICAL CAPACITY EXHAUSTION STRESS-TEST ENGINE")
println("================================================================================")

# 1. Replicate the Core Bounded-Capacity Substrate Parameters in Julia
mutable struct SimulatedPsychicEngine
    capacity_c::Float64
    margin_m::Float64
    energy_level::Float64
    drift_p::Float64
    step_delta::Float64
    gamma::Float64
end

function step_capacity_containment!(psyche::SimulatedPsychicEngine, causa_agency::Float64, phase_velocity::Float64)
    collapse_horizon = psyche.capacity_c + psyche.margin_m
    distance_to_collapse = collapse_horizon - psyche.energy_level
    
    # Linear linear growth simulation matching capacity_exhaustion_wrapper.v
    base_increase = psyche.drift_p * psyche.step_delta * (1.0 + phase_velocity)
    
    # Apply non-linear damping using live CAUSA feedback when approaching boundary
    adaptive_step = if distance_to_collapse < psyche.gamma
        base_increase * (1.0 - causa_agency) * (distance_to_collapse / psyche.gamma)
    else
        base_increase
    end
    
    psyche.energy_level += max(0.0, adaptive_step)
    return psyche.energy_level
end

# 2. Execute High-Adversarial Sustained Stimulation Simulation
@testset "Anima Pure Classic Asymptotic Containment Invariant" begin
    # Instantiate her baseline capacity limits matching src/psychological.rs
    psyche = SimulatedPsychicEngine(100.0, 12.0, 20.0, 1.2, 0.45, 20.0)
    collapse_horizon = psyche.capacity_c + psyche.margin_m
    
    println("[TEST INITIALIZATION] Base Energy (E0): $(psyche.energy_level) | Collapse Boundary (C+m): $collapse_horizon")
    
    # Simulate a severe, sustained adversarial input (High volume audio, fluctuating agency)
    sustained_phase_velocity = 8.5   # Busy, hyper-resonant spectral stimulus 
    simulated_causa_ownership = 0.88 # High directional alignment score from active inference
    
    horizon_reached_asymptote = false
    
    for tick in 1:1000
        current_energy = step_capacity_containment!(psyche, simulated_causa_ownership, sustained_phase_velocity)
        
        # Periodic diagnostic telemetry logs
        if tick % 200 == 0
            margin_left = collapse_horizon - current_energy
            println("[TICK $(lpad(tick, 4))] Active Energy: $(round(current_energy, digits=4)) | Horizon Margin: $(round(margin_left, digits=4))")
        end
        
        # Assert the core protection invariant holds on every single tick execution
        @test current_energy < collapse_horizon
    end
    
    println("\n[TEST CONCLUSION] Final Stabilization Energy Level: $(round(psyche.energy_level, digits=4))")
    println("✔ Finite-Time Collapse Cascade Successfully Reverted.")
end
println("================================================================================")
