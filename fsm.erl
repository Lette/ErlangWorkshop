-module(fsm).

-export([
	start/0,
	coin/1,
	push/1
	]).


start() ->
	spawn(fun() -> init() end).

init() ->
	closed_state().

coin(Turnstile) ->
	Ref = make_ref(),
	Turnstile ! { coin, Ref, self() },
	receive
		{ first_coin, Ref } -> "Open!";
		{ sucker_coin, Ref } -> "Looooser!"
	end.

push(Turnstile) ->
	Ref = make_ref(),
	Turnstile ! { push, Ref, self() },
	receive
		{ passed, Ref } -> "Welcome!";
		{ you_shall_not_pass, Ref } -> "You shall not pass!"
	end.

closed_state() ->
	receive
		{ coin, Ref, Client } ->
			Client ! { first_coin, Ref },
			opened_state();
		{ push, Ref, Client } ->
			Client ! { you_shall_not_pass, Ref },
			closed_state()
	end.

opened_state() ->
	receive
		{ coin, Ref, Client } ->
			Client ! { sucker_coin, Ref },
			opened_state();
		{ push, Ref, Client } ->
			Client ! { passed, Ref },
			closed_state()
	end.