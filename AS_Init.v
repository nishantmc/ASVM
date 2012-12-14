


Load AS_Exec.


Definition instruction_sequence : list instruction :=
[
inst_pushscope;
inst_constructsuper 0;
inst_pushbyte 20;
inst_pushbyte 4;
inst_add;	
inst_convert_i;  	 	
inst_returnvoid
].


Eval simpl in startExec instruction_sequence (createState (null) 0 (data O false true) (data O false true) (data O false true) (data O false true)).


