%% bench.erl - run algorithm/topology combos at several sizes, append to results.csv
%% Usage (in the erl shell, after compiling):
%%   bench:run([100, 200, 500]).                              % everything
%%   bench:run([gossip], [line, full], [1000, 2000]).         % chosen combos
-module(bench).
-export([run/0, run/1, run/3]).

-define(RUNS, 3).      % runs averaged per data point
-define(CSV, "results.csv").

run() -> run([100, 200, 500, 1000]).

run(Sizes) ->
    run([gossip, 'push-sum'], [full, '2D', line, imp2D], Sizes).

run(Algos, Topos, Sizes) ->
    New = not filelib:is_file(?CSV),
    {ok, F} = file:open(?CSV, [append]),
    case New of
        true  -> io:format(F, "algorithm,topology,n,avg_ms,runs~n", []);
        false -> ok
    end,
    lists:foreach(
      fun(Algo) ->
          lists:foreach(
            fun(Topo) ->
                lists:foreach(fun(N) -> one(F, Algo, Topo, N) end, Sizes)
            end, Topos)
      end, Algos),
    file:close(F),
    io:format("done, see ~s~n", [?CSV]).

one(F, Algo, Topo, N0) ->
    N = topology:round_size(N0, Topo),                 % actual size used (squares for 2D)
    Times = [project2:start(N, Topo, Algo) || _ <- lists:seq(1, ?RUNS)],
    Avg = lists:sum(Times) / length(Times) / 1000,     % microseconds -> ms
    io:format(F, "~s,~s,~p,~.2f,~p~n",
              [atom_to_list(Algo), atom_to_list(Topo), N, Avg, ?RUNS]).