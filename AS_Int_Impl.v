

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


Definition TrueFalse : bool -> bool:=
 fun n  => match n with
 | false => true
 | true  => false
end. 


Definition OneIsTrueOneIsFalse (x y: int) : bool := 
  if zlt ((Int.signed) x + (Int.unsigned)y) (Int.max_unsigned) then false else true.




Definition doAdd : DataType -> DataType -> DataType :=
fun n m => match n, m with
 | data x k t, data y l p =>

if ( (TrueFalse k) && (TrueFalse l) )
 then 
( 
 if ( (zlt (Int.signed x) 0) && (zlt (Int.signed y) 0)  ) 
  then 
     ( 
          if (zlt  ((Int.signed) x + (Int.signed)y) (Int.min_signed) ) 
          then (data (Int.add x y) false true) else (data (Int.add x y) false false)
      )
 else 
     (
          if ( zlt  (Int.max_signed) ((Int.signed) x + (Int.signed)y))  
          then (data (Int.add x y) false true ) else (data (Int.add x y) false false) 
     ) 
)
else
(

     if(k && l) 
      then 
      ( 
       (if ( zlt   (Int.max_unsigned) ((Int.unsigned) x + (Int.unsigned)y)) 
        then (data (Int.add x y) true true ) else (data (Int.add x y) true false) ) 
      )

      else 
      ( 
        if (k) 
        then (data (Int.add x y) true (OneIsTrueOneIsFalse y x)) else(data (Int.add x y) true (OneIsTrueOneIsFalse x y)) 
      )

)

end.





Fixpoint pop_stack (s:stack) : stack := 
  match s with
  | null => s
  | t :: s' => s'
  end.


Fixpoint getTopStack (s:stack) : DataType:=
 match s with
 | null => data (Int.repr 0) false true
 | t :: s' => t 
 end.

Fixpoint add (s:stack) : stack := 
  match s with
  | null => s
  | t :: null => s
  | t :: k :: s' => (doAdd t k) :: s'
  end.

Definition exec_add : state -> state :=
  fun state => match state with
  | createState stack pc reg_0 reg_1 reg_2 reg_3 => 
       createState (add stack) (S pc) reg_0 reg_1 reg_2 reg_3
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


Definition exec_setLocal: state -> nat -> state:=
 fun s n => match n with
 | O          => exec_loadRegister_0 s
 | S(O)       => exec_loadRegister_1 s
 | S(S(O))    => exec_loadRegister_2 s
 | S(S(S(O))) => exec_loadRegister_3 s
 |  _         => s
 end.

Definition exec_getLocal: state -> nat -> state:=
 fun s n => match n with
 | O          => exec_pushbyte (getReg_0 s) s
 | S(O)       => exec_pushbyte (getReg_1 s) s
 | S(S(O))    => exec_pushbyte (getReg_2 s) s
 | S(S(S(O))) => exec_pushbyte (getReg_3 s) s
 |  _         => s
 end.


Definition checkU (n: int) : bool :=
  if zlt (Int.signed n) (Int.signed (Int.repr 16)) then true else false.

Definition checkI (n: int) : bool :=
  if zlt (Int.signed n) (Int.signed (Int.repr 32)) then true else false.


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



