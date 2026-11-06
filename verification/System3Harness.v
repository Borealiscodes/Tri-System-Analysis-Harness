(* ========================================================================== *)
(* SYSTEM3HARNESS.V: SCALE INVARIANCE INVARIANT PROOF ENGINE                  *)
(* ========================================================================== *)

Require Import Reals.
Open Scope R_scope.

Section GeometricScaleInvariance.

  (* Abstract vector representations *)
  Variable SemanticVector : Type.
  Variable dot_product : SemanticVector -> SemanticVector -> R.
  Variable vector_norm : SemanticVector -> R.
  Variable scalar_mult : R -> SemanticVector -> SemanticVector.

  (* Axiomatic linear algebra properties for inner-product scaling *)
  Hypothesis dot_scalar_l : forall (k : R) (v1 v2 : SemanticVector),
    dot_product (scalar_mult k v1) v2 = k * dot_product v1 v2.

  Hypothesis norm_scalar_l : forall (k : R) (v : SemanticVector),
    0 < k -> vector_norm (scalar_mult k v) = k * vector_norm v.

  (* Core scale-invariant cosine distance calculation *)
  Definition cosine_distance (v1 v2 : SemanticVector) : R :=
    1 - (dot_product v1 v2) / (vector_norm v1 * vector_norm v2).

  (* ========================================================================== *)
  (* THEOREM: TRUE SCALE INVARIANCE (A6 BOUNDARY PROTECTION)                    *)
  (* ========================================================================== *)
  
  Theorem a6_scale_invariance : forall (v1 v2 : SemanticVector) (k : R),
    0 < k -> 
    vector_norm v1 > 0 -> 
    vector_norm v2 > 0 ->
    cosine_distance (scalar_mult k v1) v2 = cosine_distance v1 v2.
  Proof.
    intros v1 v2 k Hk Hnv1 Hnv2.
    unfold cosine_distance.
    
    (* Apply scalar expansion lemmas to the left side *)
    rewrite dot_scalar_l.
    rewrite norm_scalar_l; [|exact Hk].
    
    (* Rearrange denominator terms multiplication associativity *)
    replace (k * vector_norm v1 * vector_norm v2) with (k * (vector_norm v1 * vector_norm v2)) by ring.
    
    (* Cancel out the scaling scalar multiplier k from numerator and denominator *)
    rewrite Rquot_mult_cancel_l.
    - reflexivity.
    - lra. (* Prove k is non-zero from 0 < k constraint *)
  Qed.

End GeometricScaleInvariance.
