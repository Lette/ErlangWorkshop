
Test-timing för process_ring med 500 noder:

    1> c(process_ring).
    {ok,process_ring}
    2> Pid = process_ring:make(500).
    <0.62.0>
    3> process_ring:send_with_timer(Pid, "hej", 500).
    {0,"Received hej, expected hej"}

0 millisekunder, med en timerupplösning på 0.5 ms.


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
