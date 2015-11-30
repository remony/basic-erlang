%%%-------------------------------------------------------------------
%%% @author Stuart Douglas
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. Nov 2015 19:56
%%%-------------------------------------------------------------------
%%%	How to run.
%%%	   c(pi). pi:pi().  - defaults to 5 point accuracy		
%%%	   c(pi). pi:pi(5). - calculates to defined point accuracy
%%%-------------------------------------------------------------------
-module(pi).
-author("Stuart").

%% API
-export([pi/0]).
-export([pi/1]).
-export([pistep/4]).



pi() -> pistep(0, 1, 1, 5). % defined percision to 5 decimal place
pi(N) -> pistep(0, 1, 1, N). % Change the percision of the PI by decimal place

%% N is our sign this is going to be 4 or -4
%% CDIVIDER is the index in the Talor Series
pistep(RESULT, N, CDIVIDER, P) ->
  PRECISION = (1 / CDIVIDER),
  LIMIT = (math:pow(10, P + 1)), % called in as an argument this is the decimal places

  if PRECISION > 1/LIMIT  ->
    pistep((N * PRECISION) + RESULT, N * -1, CDIVIDER + 2, P);
    true -> io_lib:fwrite("~p", [RESULT * 4])
  end.
