%% pushsum.erl
%% Convergence = every actor terminated.
-module(pushsum).
-export([run/2, actor/7]).

run(N, Topo) ->
    Main = self(),
    Pids = [spawn(?MODULE, actor,
                  [I, topology:neighbors(Topo, I, N), float(I), 1.0, 0, false, Main])
            || I <- lists:seq(1, N)],
    persistent_term:put(pids, list_to_tuple(Pids)),
    hd(Pids) ! start,                          % ask actor 1 to begin
    Last = wait_done(N, none),
    io:format("last estimate ~p, true average ~p~n", [Last, (N + 1) / 2]),
    [exit(P, kill) || P <- Pids],
    persistent_term:erase(pids),
    ok.

wait_done(0, Last) -> Last;
wait_done(K, _) -> receive {done, _, R} -> wait_done(K - 1, R) end.

%% S, W = my pair. Stable = consecutive rounds with ratio change < 1e-10.
%% Done = already reported (a done actor still forwards messages).
actor(Id, Ns, S, W, Stable, Done, Main) ->
    receive
        start ->
            S2 = S / 2, W2 = W / 2,
            topology:send_random(Id, Ns, {S2, W2}),
            actor(Id, Ns, S2, W2, Stable, Done, Main);
        {S0, W0} ->
            S1 = S + S0,
            W1 = W + W0,
            Change = abs(S1 / W1 - S / W),
            Stable1 = case Change < 1.0e-10 of
                          true  -> Stable + 1;
                          false -> 0
                      end,
            Done1 = Done orelse Stable1 >= 3,
            case Done1 andalso not Done of
                true  -> Main ! {done, Id, S1 / W1};
                false -> ok
            end,
            S2 = S1 / 2,
            W2 = W1 / 2,
            topology:send_random(Id, Ns, {S2, W2}),
            actor(Id, Ns, S2, W2, Stable1, Done1, Main)
    end.