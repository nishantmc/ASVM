

Load AS_State.


Fixpoint plus (n : nat) (m : nat) : nat :=
  match n with
    | O => m
    | S n' => S (plus n' m)
  end.

Definition checkValid : bool -> bool -> bool :=
 fun n m => match n,m with
 | false,m => false
 | n,false => false
 | n,m     => true
end. 

Definition checkAdd : DataType -> DataType -> DataType :=
fun n m => match n, m with
 | data x k t, data y l p => data (plus x y) (checkValid k l) true
end.

Fixpoint add (s:stack) : stack := 
  match s with
  | null => s
  | t :: null => s
  | t :: k :: s' => (checkAdd t k) :: s'
  end.

Definition addFromState : state -> state :=
  fun state => match state with
  | createState stack pc reg_0 reg_1 reg_2 reg_3 => 
       createState (add stack) (S pc) reg_0 reg_1 reg_2 reg_3
  end.





Fixpoint pop_stack (s:stack) : stack := 
  match s with
  | null => s
  | t :: s' => s'
  end.

Definition exec_pop : state -> state :=
  fun state => match state with
  | createState stack pc reg_0 reg_1 reg_2 reg_3 => 
       createState (pop_stack stack) (S pc) reg_0 reg_1 reg_2 reg_3
  end.


Definition exec_pushbyte : DataType -> state -> state :=
  fun n state => match state with
  | createState stack pc reg_0 reg_1 reg_2 reg_3 => 
       createState (n::stack) (S pc) reg_0 reg_1 reg_2 reg_3
  end.

Fixpoint getTopStack (s:stack) : DataType:=
 match s with
 | null => data O false true
 | t :: s' => t 
 end.

Definition exec_loadRegister_0 : state -> state :=
 fun s => match s with
 | createState stack pc reg_0 reg_1 reg_2 reg_3 =>
   createState stack (S pc) (getTopStack stack) reg_1 reg_2 reg_3
 end.

Definition exec_loadRegister_1 : state -> state :=
 fun s => match s with
 | createState stack pc reg_0 reg_1 reg_2 reg_3 =>
   createState stack (S pc) reg_0 (getTopStack stack) reg_2 reg_3
 end.

Definition exec_loadRegister_2 : state -> state :=
 fun s => match s with
 | createState stack pc reg_0 reg_1 reg_2 reg_3 =>
   createState stack (S pc) reg_0 reg_1 (getTopStack stack) reg_3
 end.

Definition exec_loadRegister_3 : state -> state :=
 fun s => match s with
 | createState stack pc reg_0 reg_1 reg_2 reg_3 =>
   createState stack (S pc) reg_0 reg_1 reg_2 (getTopStack stack)
 end.

Definition getReg_0 : state -> DataType :=
 fun s => match s with
 | createState stack pc reg_0 reg_1 reg_2 reg_3 => reg_0
end.

Definition getReg_1 : state -> DataType :=
 fun s => match s with
 | createState stack pc reg_0 reg_1 reg_2 reg_3 => reg_1
end.

Definition getReg_2 : state -> DataType :=
 fun s => match s with
 | createState stack pc reg_0 reg_1 reg_2 reg_3 => reg_2
end.

Definition getReg_3 : state -> DataType :=
 fun s => match s with
 | createState stack pc reg_0 reg_1 reg_2 reg_3 => reg_3
end.


Definition setLocal: state -> nat -> state:=
 fun s n => match n with
 | O          => exec_loadRegister_0 s
 | S(O)       => exec_loadRegister_1 s
 | S(S(O))    => exec_loadRegister_2 s
 | S(S(S(O))) => exec_loadRegister_3 s
 |  _         => s
 end.

Definition getLocal: state -> nat -> state:=
 fun s n => match n with
 | O          => exec_pushbyte (getReg_0 s) s
 | S(O)       => exec_pushbyte (getReg_1 s) s
 | S(S(O))    => exec_pushbyte (getReg_2 s) s
 | S(S(S(O))) => exec_pushbyte (getReg_3 s) s
 |  _         => s
 end.


Fixpoint checkU (n:nat) : bool:=
match n with
 | O => true
 | 16 => false
 | S k => (checkU k)
 end.

Fixpoint checkI (n:nat) : bool:=
match n with
 | O => true
 | 8 => false
 | S k => (checkI k)
 end.

Definition convertI: DataType -> DataType :=
 fun d => match d with
 | data x false t => data x true (checkI x)
 | data x true t => data x true (checkI x)
 end.

Definition convertU: DataType -> DataType :=
 fun d => match d with
 | data x true t => data x false (checkU x)
 | data x false t => data x false (checkU x)
 end.



Definition convertIFromState: state -> state :=
 fun s => match s with
   | createState stack pc reg_0 reg_1 reg_2 reg_3 => 
    exec_pushbyte (convertI (getTopStack stack)) (exec_pop (exec_pop s))
  end.




