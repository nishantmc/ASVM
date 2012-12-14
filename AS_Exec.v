

Load AS_Int.
Load AS_Int_Impl.

Definition exec :instruction -> state -> state :=
  fun inst state => match state with
  | createState stack pc reg_0 reg_1 reg_2 reg_3 => 
      match inst with
      |inst_pushbyte n => exec_pushbyte (data n false true) state
      |inst_pop => exec_pop state
      |inst_getlocal_0 => getLocal state 0
      |inst_getlocal_1 => getLocal state 1
      |inst_getlocal_2 => getLocal state 2
      |inst_getlocal_3 => getLocal state 3
      |inst_add        => addFromState state
      |inst_convert_i  => convertIFromState state
      |_ => state
      end
  end.

Fixpoint startExec (inst_seq:list instruction) (s:state) : state := 
  match inst_seq with
 | nil => s
 | cons x t' => startExec t' (exec x s)
  end.
