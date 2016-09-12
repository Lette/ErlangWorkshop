-module(number_station).

-export(
	[
		start/1,
		next/1,
		set_list/2,
		loop/1
	]).

start(List) ->
	spawn(fun() -> init(List) end).

next(Server) ->
	Ref = make_ref(),
	Server ! { next, Ref, self() },
	receive
		{ next, Ref, _, NextNumber } -> NextNumber
	end.

set_list(Server, List) ->
	Server ! { set_list, List }.

init(List) ->
	loop(List).

loop([First | Rest]) ->
	receive
		{ next, Ref, ClientPid } ->
			ClientPid ! { next, Ref, self(), First },
			%%io:format("~p got message: ~p\nNext number is: ~p", [self(), ClientPid, First]),
			loop(Rest ++ [First]);
		{ set_list, List } ->
			number_station:loop(List)
	end.