
Concurrency-primitiver

Pid = spawn(fun() ->... end)
Pid ! Message
receive
	Pattern1 -> ...;
	Pattern2 -> ...
end

loop(State) ->
	receive
		Message ->
			io:format("~p got message: ~p\n", [self(), Message]),
			loop(State)
	end.

Start
Init
Loop
