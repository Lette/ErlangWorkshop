-module(process_ring).

-export([make/1, send/3]).

make(N) ->
	spawn(fun() -> init(N - 1) end).

send(Ring, Message, N) ->
	Ref = make_ref(),
	%%io:format("Calling ~p:send from ~p with data ~p.\n", [Ring, self(), Message]),
	Ring ! { send, Ref, self(), Message, N - 1 },
	receive
		{ complete, Ref, ReceivedMessage } ->
			"Received " ++ ReceivedMessage ++ ", expected " ++ Message
		after 5000 ->
			"Timeout"
	end.

init(N) ->
	Self = self(),
	NextPid = spawn(fun() -> init(N - 1, Self) end),
	loop({ NextPid }).

init(N, FirstPid) when N > 0 ->
	NextPid = spawn(fun() -> init(N - 1, FirstPid) end),
	loop({ NextPid });

init(0, FirstPid) ->
	loop({ FirstPid }).

loop({ NextPid }) ->
	%%io:format("I am ~p. My target is ~p.\n", [self(), NextProcess]),
	receive
		{ send, Ref, Client, Message, 0 } ->
			%%io:format("loop received 'send' with ~p, ~p\n", [Message, 0]),
			Client ! { complete, Ref, Message },
			loop({ NextPid });
		{ send, Ref, Client, Message, N } ->
			%%io:format("loop received 'send' with ~p, ~p\n", [Message, N]),
			NextPid ! { send, Ref, Client, Message, N - 1 },
			loop({ NextPid })
	end.