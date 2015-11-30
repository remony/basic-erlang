%%%-------------------------------------------------------------------
%%% @author Stuart Douglas
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. Nov 2015 20:48
%%%-------------------------------------------------------------------
-module(list).
-author("Stuart").

%% API
-export([]).
-export([sort/1]).
-export([print/1]).
-export([list/1]).
-export([uniqueitemscount/1]).
-export([read/1]).
-export([listunique/1]).
-export([listuniquecount/1]).
-export([listuniquecountread/1]).
-export([listlowercase/1]).
-export([listnocharacters/1]).
-export([count/1]).
-export([countcombine/1]).
-export([countcombine/2]).

-export([flattenlist/1]).
-export([flattenlist/2]).

%% API points
-export([showUnique/0]).
-export([showUniqueCount/0]).
-export([listFromFile/1]).
-export([getUniqueCountOf/1]).


sort([Pivot|T]) ->
  sort([ X || X <- T, X < Pivot]) ++
    [Pivot] ++
    sort([ X || X <- T, X >= Pivot]);
sort([]) -> [].

print(V) -> file:write("~p~n", [V]).

list([H|T]) -> [2 * N || N <- [H|T]].


listunique([H|T]) ->
  listunique([ X || X <- T, X < H]) ++ [H] ++ listunique([ X || X <- T, X > H]);
listunique([]) -> [].

listuniquecount(LIST) -> count(listunique(LIST)).

count(LIST) -> length(LIST).

countcombine(L) -> countcombine(L, 0).
countcombine([H|T], C) ->
  countcombine(T, H + C);
countcombine([], C) -> C.

listuniquecountread(FILENAME) ->length(listunique(read(FILENAME))).

listlowercase([H|T]) -> [string:to_lower(N) || N <- [H|T]].

listnocharacters([H|T]) -> [re:replace(N, "[^a-z^A-Z0-9+]", "", [global, {return, list}]) || N <- [H|T]].


flattenlist(L) -> flattenlist(L, []).

flattenlist([], C) -> C;
flattenlist([H|T], C) when is_list(H) -> flattenlist(T, flattenlist(H, C));
flattenlist([H|T], C) -> flattenlist(T, [H|C]).

uniqueitemscount(LIST) -> length(uniqueitems(LIST)).

read(FILENAME) -> {ok, Device} = file:read_file(FILENAME),
    string:tokens(erlang:binary_to_list(Device), "\n\t\r,.\' _-[]()><").


%% Main methods

% Show unique items in list
showUnique() -> listunique([2,5,3,6,3,2,7,8,5,6]).
% Show unique count in list
showUniqueCount() -> count(listunique([2,5,3,6,3,2,7,8,5,6])).


%% Create list from file
listFromFile(FILENAME) -> read(FILENAME).

%% Read in file and get word count (including lowercase removal of bad chars)
getUniqueCountOf(FILENAME) -> listuniquecount(listlowercase(read(FILENAME))).

