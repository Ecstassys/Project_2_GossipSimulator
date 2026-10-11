%% gossip.erl - rumor spreading. Convergence = every actor has heard the rumor.
-module(gossip).
-export([run/2, actor/4]).

%% Main-process side: spawn, kick off, wait, clean up
run(N, Topo) ->
    Main = self(),
    Pids = [spawn(?MODULE, actor, [I, topology:neighbors(Topo, I, N), 0, Main])
            || I <- lists:seq(1, N)],
    persistent_term:put(pids, list_to_tuple(Pids)),
    hd(Pids) ! rumor,                          % tell the rumor to actor 1
    wait_heard(N),
    [exit(P, kill) || P <- Pids],
    persistent_term:erase(pids),
    ok.

wait_heard(0) -> ok;
wait_heard(K) -> receive {heard, _} -> wait_heard(K - 1) end.

%% Actor side: Count = how many times I have heard the rumor
actor(Id, Ns, Count, Main) ->
    receive
        rumor ->
            case Count of
                0 -> Main ! {heard, Id},                    % first time: tell main
                     erlang:send_after(1, self(), tick);    % and start ticking
                _ -> ok
            end,
            actor(Id, Ns, Count + 1, Main);
        tick when Count < 10 ->
            topology:send_random(Id, Ns, rumor),
            erlang:send_after(1, self(), tick),
            actor(Id, Ns, Count, Main);
        tick ->                                             % heard 10 times: stop sending
            actor(Id, Ns, Count, Main)
    end.