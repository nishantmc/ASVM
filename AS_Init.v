


Load AS_Exec.





Definition instruction_sequence : list instruction :=
[
inst_pushscope;
inst_constructsuper (Int.repr (0));
inst_pushbyte (Int.repr 2147483648);
inst_pushbyte (Int.repr 2147483648);
inst_add;  	 	
inst_returnvoid
].

Definition instruction_sequence1 : list instruction :=
[
inst_pushscope;
inst_constructsuper (Int.repr (0));
inst_pushbyte (Int.repr (3));
inst_pushbyte (Int.repr (4));
inst_add;		 	
inst_returnvoid
].

Definition instruction_sequence2 : list instruction :=
[
inst_pushscope;
inst_constructsuper (Int.repr (0));
inst_pushbyte (Int.repr (Z.neg 2147483648));
inst_pushbyte (Int.repr (Z.neg 2147483648));
inst_add;		 	
inst_returnvoid
].




Eval compute in startExec instruction_sequence (createState (null) 0 (data (Int.repr 0) false false) (data (Int.repr 0) false true) (data (Int.repr 0) false true) (data (Int.repr 0) false true)).
Eval compute in startExec instruction_sequence1 (createState (null) 0 (data (Int.repr 0) false false) (data (Int.repr 0) false true) (data (Int.repr 0) false true) (data (Int.repr 0) false true)).
Eval compute in startExec instruction_sequence2 (createState (null) 0 (data (Int.repr 0) false false) (data (Int.repr 0) false true) (data (Int.repr 0) false true) (data (Int.repr 0) false true)).

