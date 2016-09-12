-module(process_ring).

-export([make/1, send/3]).

make(N) ->
	spawn(fun() -> init(N) end).

init(N) ->
	Self = self(),
	NextPid = spawn(fun() -> init(N - 1, Self) end),
	loop({ NextPid }).



send(Ring, Message, N) ->
	Ref = make_ref(),
	Ring ! { send, Ref, self(), Message, N },
	receive
		{ complete, Ref, ReceivedMessage } ->
			"Received " ++ ReceivedMessage ++ ", expected " ++ Message
		after 5000 ->
			"Timeout"
	end.

init(N, FirstPid) when N > 0 ->
	NextPid = spawn(fun() -> init(N - 1, FirstPid) end),
	loop({ NextPid });
init(0, FirstPid) ->
	loop({ FirstPid }).

loop({ NextProcess }) ->
	receive
		{ send, Ref, Client, Message, 0 } ->
			Client ! { complete, Ref, Message };
		{ send, Ref, Client, Message, N } ->
			io:format("~p", [N]),
			NextProcess ! { send, Ref, Client, Message, N - 1 }
	end.