(***********************************************************************)
(*  v      *   The Coq Proof Assistant  /  The Coq Development Team    *)
(* <O___,, *        INRIA-Rocquencourt  &  LRI-CNRS-Orsay              *)
(*   \VV/  *************************************************************)
(*    //   *      This file is distributed under the terms of the      *)
(*         *       GNU Lesser General Public License Version 2.1       *)
(***********************************************************************)

(* $Id$ *)

open Names
open Closure

(* Opaque constants *)
let cst_transp = ref KNpred.full

let set_opaque_const kn = cst_transp := KNpred.remove kn !cst_transp
let set_transparent_const kn = cst_transp := KNpred.add kn !cst_transp

let is_opaque_cst kn = not (KNpred.mem kn !cst_transp)

(* Opaque variables *)
let var_transp = ref Idpred.full

let set_opaque_var kn = var_transp := Idpred.remove kn !var_transp
let set_transparent_var kn = var_transp := Idpred.add kn !var_transp

let is_opaque_var kn = not (Idpred.mem kn !var_transp)

(* Opaque reference keys *)
let is_opaque = function
  | ConstKey cst -> is_opaque_cst cst
  | VarKey id -> is_opaque_var id
  | FarRelKey _ -> false

(* Unfold the first only if it is not opaque and the second is opaque *)
let oracle_order k1 k2 = is_opaque k2 & not (is_opaque k1)

(* summary operations *)

let init() = (cst_transp := KNpred.full; var_transp := Idpred.full)
let freeze () = (!var_transp, !cst_transp)
let unfreeze (vo,co) = (cst_transp := co; var_transp := vo)
