### COP5612 Project 2: Gossip Simulator (Erlang)
## Team Members 

- Rohan Vudavagandla (vudavagandla.ro@ufl.edu)
- Jatin Verma (jverma@ufl.edu)


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

### 