### COP5612 Project 2: Gossip Simulator (Erlang)
## Team Members 

- Rohan Vudavagandla (vudavagandla.ro@ufl.edu)
- Jatin Verma (jverma@ufl.edu)

## How to run it?

Compile all modules:

```sh
erlc *.erl
```

Run from the command line as `numNodes topology algorithm`, where topology is one of `full`, `2D`, `line`, `imp2D` and algorithm is one of `gossip`, `push-sum`:

```sh
erl -noshell -run project2 main 100 line gossip -s init stop
```

Or run from the Erlang shell (`'2D'` and `'push-sum'` must be quoted there):

```erlang
1> project2:start(100, '2D', 'push-sum').
```


Outputs - 

1> project2:start(100, full, gossip).
gossip full N=100: 24.602 ms
24602

2> project2:start(100, line, gossip).
gossip line N=100: 390.63 ms
390630

3> project2:start(100, '2D', gossip).
gossip '2D' N=100: 57.962 ms
57962

4> project2:start(100, imp2D, gossip).
gossip imp2D N=100: 30.545 ms
30545

5> project2:start(100, full, 'push-sum').
last estimate 50.50000000001979, true average 50.5
'push-sum' full N=100: 10.595 ms
10595

6> project2:start(100, line, 'push-sum').
last estimate 50.49999992435291, true average 50.5
'push-sum' line N=100: 1177.277 ms
1177277

7> project2:start(100, imp2D, 'push-sum').
last estimate 50.50000000002826, true average 50.5
'push-sum' imp2D N=100: 25.748 ms
25748

8> project2:start(100, '2D', 'push-sum').
last estimate 50.49999999991999, true average 50.5
'push-sum' '2D' N=100: 58.63 ms
58630

|  N = 100 | Gossip   | Push-Sum |
|----------|----------|----------|
| Full     | 24.6 ms  | 10.6 ms  |
| 2D       | 58.0 ms  | 58.6 ms  |
| Imp2d    | 30.5 ms  | 25.7 ms  |
| Line     | 390.6 ms | 117.3 ms |


## What is Working?

- **Gossip** is working on all four topologies.
    - The main processs tells the rumor to one actor that starts telling it to a random neighbor.
    - Each neighbor that hears it once, starts telling it to others randomly.
    - It stops transmitting once it has heard the rumor 10 times.
    - We can conclude Convergence when every actor has heard the rumor.

- **Push-Sum** on all four topologies.
    - Actor `i` starts with `s = i`, `w = 1`, keeps half and sends half on every message.
    - It finishes once its `s/w` ratio changes by less than `1e-10` for 3 consecutive rounds.
    - Convergence is reached when every actor is done.

- **Topologies:** 
    - `full`
    - `2D` (`numNodes` is rounded up to the next perfect square.)
    - `line`
    - `imp2D` (grid neighbors plus one random extra neighbor. `numNodes` is rounded up to the next perfect square.)

- **Timing(ms)** of each run with `erlang:monotonic_time`.

## Largest Network We Managed to Deal With:
| Topology | Gossip | Push-Sum |
|----------|--------|----------|
| full |  |  |
| 2D | |  |
| line |  |  |
| imp2D |  |  |
