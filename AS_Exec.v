

Load Integers.
Load AS_State.
Load AS_Int_Impl.
Load AS_Int.

(* The execution of single instruction *)
Definition exec :instruction -> state -> state :=
  fun inst state => match state with
  | createState stack pc reg_0 reg_1 reg_2 reg_3 => 
      match inst with
      |inst_pushbyte n => exec_pushbyte (data n false false) state
      |inst_pop => exec_pop state
      |inst_getlocal_0 => exec_getLocal state 0
      |inst_getlocal_1 => exec_getLocal state 1
      |inst_getlocal_2 => exec_getLocal state 2
      |inst_getlocal_3 => exec_getLocal state 3
      |inst_setlocal_0 => exec_setLocal state 0
      |inst_setlocal_1 => exec_setLocal state 1
      |inst_setlocal_2 => exec_setLocal state 2
      |inst_setlocal_3 => exec_setLocal state 3
      |inst_add        => exec_add state
      |inst_convert_i  => convertIFromState state
      |_ => state
      end
  end.

(* The execution of list of instructions *)
Fixpoint startExec (inst_seq:list instruction) (s:state) : state := 
  match inst_seq with
 | nil => s
 | cons x t' => startExec t' (exec x s)
  end.
