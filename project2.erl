%% entry point: parses args, times the run, picks the algorithm
-module(project2).
-export([start/3, main/1]).


main([N, Topo, Algo]) ->
    start(list_to_integer(N), list_to_atom(Topo), list_to_atom(Algo));
main(_) ->
    io:format("usage: project2 numNodes full|2D|line|imp2D gossip|push-sum~n").

start(N0, Topo, Algo) ->
    N = topology:round_size(N0, Topo),
    {Time, _} = measure_running_time(fun() -> dispatch(N, Topo, Algo) end),
    io:format("~p ~p N=~p: ~p ms~n", [Algo, Topo, N, Time / 1000]),
    Time.

dispatch(N, Topo, gossip)      -> gossip:run(N, Topo);
dispatch(N, Topo, 'push-sum')  -> pushsum:run(N, Topo).

measure_running_time(Fun) ->
    Start = erlang:monotonic_time(microsecond),
    Res = Fun(),
    End = erlang:monotonic_time(microsecond),
    {End - Start, Res}.