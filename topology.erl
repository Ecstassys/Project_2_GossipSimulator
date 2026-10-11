%% topology.erl - who is a neighbor of whom, and how to pick one at random
-module(topology).
-export([round_size/2, neighbors/3, send_random/3]).

%% 2D topologies need a perfect square number of nodes
round_size(N, T) when T =:= '2D'; T =:= imp2D ->
    S = ceil(math:sqrt(N)),
    S * S;
round_size(N, _) -> N.

%% neighbors(Topology, Index, N) -> list of neighbor indices (or the atom full)
neighbors(full, _, _) -> full;
neighbors(line, I, N) -> [X || X <- [I - 1, I + 1], X >= 1, X =< N];
neighbors('2D', I, N) -> grid(I, N);
neighbors(imp2D, I, N) -> G = grid(I, N), [extra(I, N, G) | G].

grid(I, N) ->
    S = round(math:sqrt(N)),
    R = (I - 1) div S,
    C = (I - 1) rem S,
    [R2 * S + C2 + 1
     || {R2, C2} <- [{R - 1, C}, {R + 1, C}, {R, C - 1}, {R, C + 1}],
        R2 >= 0, R2 < S, C2 >= 0, C2 < S].

%% one extra random neighbor for imp2D (not yourself, not already a grid neighbor)
extra(I, N, Excl) ->
    X = rand:uniform(N),
    case X =:= I orelse lists:member(X, Excl) of
        true  -> extra(I, N, Excl);
        false -> X
    end.

%% Send Msg to a random neighbor. Pids come from the shared persistent_term
%% tuple (index -> Pid), so actors only store small index lists.
send_random(Id, Ns, Msg) ->
    Pids = persistent_term:get(pids),
    Target = pick(Id, Ns, tuple_size(Pids)),
    element(Target, Pids) ! Msg.

pick(Id, full, N) ->
    case rand:uniform(N) of
        Id -> pick(Id, full, N);       % never pick yourself
        T  -> T
    end;
pick(_, Ns, _) ->
    lists:nth(rand:uniform(length(Ns)), Ns).