(* The AS virtual machine state for the interpreter *)

(* The integer datatype which represents the signed and unsigned versions 
   value -> bit representation
   type -> true is unsigned, false is signed
   valid -> true is overflowed operation, false is normal operation   
*)
Record DataType := data
{value : int
;type  : bool
;valid : bool
}.

(* The stack for the VM *)
Inductive stack : Type :=
  | null : stack
  | push : DataType -> stack -> stack.


Notation "x :: l" := (push x l) (at level 60, right associativity).

(* The abstraction for the state *)
Record state := createState
 { state_stack  : stack
 ; state_pc     : nat
 ; reg_0        : DataType
 ; reg_1        : DataType
 ; reg_2        : DataType
 ; reg_3        : DataType
 }.

