


(* The next two lines pull is some extra list manipulations and the [ ... ; ...] *)
(* notation for lists. *)
Require Import List.
Import List.ListNotations.

(* TODO: Verify whether Array belongs here and whether we are missing any types. *)
(* Declaration types for the ActionScript language. Does not include types that are only *)
(* produced by the compiler like u16 and s24. *)
Inductive lang_type : Set :=
  (* Primitive types *)
  | lt_String
  | lt_Number
  | lt_int
  | lt_uint
  | lt_Boolean
  | lt_Null (* Contains only the value 'null' *)
  | lt_Undefined (* Contains only the value 'undefined' *)
  (* Complex types*)
  | lt_Object
  | lt_Array.


(* Descriptive names for operand types in the bytecode *)
Definition ot_register_index := nat. (* u30 *)
Definition ot_arg_count := int. (* u30 *)
Definition ot_ubyte := int. (* unsigned byte *)


(* The instruction set for the interpreter *)
Inductive instruction : Set :=
  (* Arithmetic *)
  | inst_add : instruction

  (* Function invocation and return *)
  | inst_returnvoid : instruction

  (* Load and store *)
  | inst_getlocal_0 : instruction
  | inst_getlocal_1 : instruction
  | inst_getlocal_2 : instruction
  | inst_getlocal_3 : instruction
  | inst_getlocal : ot_register_index -> instruction
  | inst_setlocal_0 : instruction
  | inst_setlocal_1 : instruction
  | inst_setlocal_2 : instruction
  | inst_setlocal_3 : instruction
  | inst_setlocal : ot_register_index -> instruction

  (* Object create and manipulation *)
  | inst_constructsuper : ot_arg_count -> instruction

  (* Other*)
  | inst_pushscope : instruction
  | inst_pushbyte : ot_ubyte -> instruction
  | inst_pop : instruction

  (* Type conversion *)
  | inst_convert_i : instruction.

