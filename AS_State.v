(*Record pre_state (A:Type) : Type := mkState
 { state_frame_stack   : list frame
 ; state_classes       : CP.cert_classpool
 ; state_object_heap   : cert_heap state_classes
 ; state_static_fields : cert_fieldstore state_classes state_object_heap
 ; state_res           : A
 ; state_reslimit      : A
 }.*)
Record DataType := data
{value : nat
;type  : bool
;valid : bool
}.

Inductive stack : Type :=
  | null : stack
  | push : DataType -> stack -> stack.

(*Inductive instruction : Type :=
  | pushbyte : nat -> instruction
  | pop : instruction.*)

Notation "x :: l" := (push x l) (at level 60, right associativity).

Record state := createState
 { state_stack  : stack
 ; state_pc     : nat
 ; reg_0        : DataType
 ; reg_1        : DataType
 ; reg_2        : DataType
 ; reg_3        : DataType
 }.
