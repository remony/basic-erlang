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
-export([list/1]).
-export([read/1]).
-export([listunique/1]).
-export([listuniquecount/1]).
-export([listuniquecountread/1]).
-export([listlowercase/1]).
-export([listnocharacters/1]).
-export([count/1]).

%% API points
-export([showUnique/0]).
-export([showUniqueCount/0]).
-export([listFromFile/1]).
-export([getUniqueCountOf/1]).

% Sorts the list
sort([Pivot|T]) ->
  sort([ X || X <- T, X < Pivot]) ++
    [Pivot] ++
    sort([ X || X <- T, X >= Pivot]);
sort([]) -> [].

% Lists the file
list([H|T]) -> [N || N <- [H|T]].

% Lists all of the unique items in a list
listunique([H|T]) ->
  listunique([ X || X <- T, X < H]) ++ [H] ++ listunique([ X || X <- T, X > H]);
listunique([]) -> [].

% Count of unique items 
listuniquecount(LIST) -> count(listunique(LIST)).

% count of list (all items)
count(LIST) -> length(LIST).

% Lists the number of unique items in a list read from a file
listuniquecountread(FILENAME) -> length(listunique(read(FILENAME))).

% Convert all items in list to lowercase
listlowercase([H|T]) -> [string:to_lower(N) || N <- [H|T]].

% Remove all characters in a list
listnocharacters([H|T]) -> [re:replace(N, "[^a-z^A-Z0-9+]", "", [global, {return, list}]) || N <- [H|T]].

% Read in a file 
read(FILENAME) -> {ok, Device} = file:read_file(FILENAME),
    string:tokens(erlang:binary_to_list(Device), "\n\t\r,.\' _-[]()><"). % Read in only string values (words)

%% Main methods

% Show unique items in list
showUnique() -> listunique([2,5,3,6,3,2,7,8,5,6]).
% Show unique count in list
showUniqueCount() -> count(listunique([2,5,3,6,3,2,7,8,5,6])).


%% Create list from file
listFromFile(FILENAME) -> read(FILENAME).

%% Read in file and get word count (including lowercase removal of bad chars)
getUniqueCountOf(FILENAME) -> listuniquecount(listlowercase(read(FILENAME))).

