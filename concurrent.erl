%%%-------------------------------------------------------------------
%%% @author Stuart Douglas
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. Nov 2015 20:48
%%%-------------------------------------------------------------------
-module(concurrent).
-author("Stuart Douglas").

-export ([load/1,count/3,go/1,join/2,split/2]).
-export([process/3, countit/2, receiver/4]).

%% load in the file and start the count process
load(F)->
  {ok, Bin} = file:read_file(F),
  io:fwrite("Reading in file: ~p~n", [F]),

  List    = binary_to_list(Bin),
  Length  = round(length(List)/10),
  Ls      = string:to_lower(List),
  Sl      = split(Ls,Length),

  io:fwrite("~p is loaded and split into ~p parts.~n", [F, length(Sl)]),

%%  Spawn a receiver process: This will gather the lists and join them as there processed
  Pid = spawn(?MODULE, receiver, [[], 0, length(Sl), os:timestamp()]),

%% Pass the split lists to the process method, This will pass the split lists into there own processes
  process(Sl, 0, Pid).



%% process recursively spawns process for each split list
process([H|T], N, Pid) ->
  %% Spawn a process to count the characters in the list of he head
  spawn(?MODULE, countit, [H, Pid]),
  %% pass the tail into process incrementing the count
  process(T, N+1, Pid);
process([], N, Pid) ->
  %% When we have a empty list print a message with the count of spawned processes
  io:fwrite("~nProcesses spawned: ~p~n", [N]).

%% countit takes the head and counts the chars in that list
countit(H, Pid) ->
  L = go(H),
  Pid ! {self(), L}.


%% receiver receives responses from the spawned processes and joins them
receiver(L, N, Length, Time) ->
receive
  {FROM, MSG} ->
    %% If the count N is less than the length - 1 join and loop
    if (N < Length - 1) ->
        J = join(L, MSG),
        receiver(J, N + 1, Length, Time);
      %% If the connt N is the same as Length - 1 then we join and display the final count
    (N == Length - 1) ->
      J = join(L, MSG),
      CompleteTime = timer:now_diff(os:timestamp(), Time) / 1000,

      io:fwrite("~nResult~n~p~nTime ~p~n", [J, CompleteTime])
    end
end.




join([],[])->[];
join([],R)->R;
join([H1 |T1],[H2|T2])->
  {C,N}=H1,
  {C1,N1}=H2,
  [{C1,N+N1}]++join(T1,T2).

%% splits file into 20 pieces
split([],_)->[];
split(List,Length)->
  S1=string:substr(List,1,Length),
  case length(List) > Length of
    true->S2=string:substr(List,Length+1,length(List));
    false->S2=[]
  end,
  [S1]++split(S2,Length).

count(Ch, [],N)->N;
count(Ch, [H|T],N) ->
  case Ch==H of
    true-> count(Ch,T,N+1);
    false -> count(Ch,T,N)
  end.

go(L)->
  Alph=[$a,$b,$c,$d,$e,$f,$g,$h,$i,$j,$k,$l,$m,$n,$o,$p,$q,$r,$s,$t,$u,$v,$w,$x,$y,$z],
  rgo(Alph,L,[]).

rgo([H|T],L,Result)->
  N=count(H,L,0),
  Result2=Result++[{[H],N}],
  rgo(T,L,Result2);

rgo([],L,Result)->Result.