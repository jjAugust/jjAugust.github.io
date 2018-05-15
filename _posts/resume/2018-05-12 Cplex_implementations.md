---

category: work
published: true
layout: post
title: Cplex impletations
description: read more.

---

# report

2018-05-12 19:48:13

## Background

**The air traffic flow management problem with enroute capacities**

+ bertsimas
+ 1998 
+ *Operations research* (运筹学)
+ cited by 561

**Cplex is used to solve four basic problems such as ：**

+ linear programming (LP), 
+ quadratic programming (QP), 
+ quadratic programming with constraints (QCQP), 
+ second-order cone programming (SOCP). 

**Cplex 3 advantages:**

+ The solution speed is very **fast**; 
+ sometimes it also provides **superlinear** **acceleration**.
+ **Functional** **advantages**.

As you know, I've worked for 4 years, however, I am not familiar with Cplex and its c plus plus Reference Manual. So I took several days to understood it approximately.

## paper review

Definitely speaking, this paper including 6 parts.

+ TFMP formulation
+ comlexity of TFMP
+ model variations
+ insights from stucture
+ Insights from computations
+ conclusion

As the requirements asked. I will discuss the issues as below:

Firstly,



#### Motivation

In my opinion, when we do research or reading a paper. we should know:

What's the problem? Why you do it? what about the others have done? Then how you do it? How could you evaluate it?(such as make a comparation with others or yourself experiments.)

##### **Problem in this paper.**

Due to the demand for airport use has been increasing rapidly, however, airport capacity has been stagnating. Congestion on the air traffic system.



#### Contributions:

- 1、model that taking into account the (compara to others. or what about the others have done? )

  - capacities of NAS
  - capacities of airports

- 2、complexity of the problem is <u>**NP-Hard**</u> (point out its hard)

- 3、account for several variations of the basic problem

  how to reroute flights  

  how to handle banks in the hub

- 4、compared to all others proposed in the literature(1994 a) for this problem

- 5、solve large scale, realistic size problems (several thousand flights).

#### problem definition

schedule flights in real time in order to minimize congestion costs

#### model formulation

- **<u>objective:</u>**  when each flight held on the ground and in the air in order to minimize the total delay cost.


- **<u>input data:</u>**

  flights

  airports

  time periods

  continued flights

  path

  capacity(air sector or depart airport and arrival airport)

  scheduled time(depart and arrival)

  cost(ground and in the air )

  must time in one sector


- **<u>decision variables</u>**:

  flight f arrives at sector j by time t.


- **<u>the objective function:</u>** （<u>**formula**</u>） (<u>minus</u>)

  - actual departure time - scheduled departure time    

    <u>**means**</u>

    <u>held on the ground time</u>     (1)


  - actual arrival time - scheduled arrival time -(actual departure time - scheduled departure time )

    **<u>equals</u>**

    (actual arrival time-actual departure time)-(scheduled arrival time-scheduled departure time)      

    **<u>means</u>**

    <u>held in the air time</u>      (2)

    ​

  so the minimize total delay cost <u>**equals**</u>

  (1) * cost on the ground +(2) *  cost in the air      (<u>mutiply</u> by)

#### solution algorithm

complexity of the tfmp is NP-hard problem

the author using a job-shop schedule to confirm all the constraints of the TFMP will be satisfied if and only if there is a feasible job-shop schedule.

#### modeling variations(could be used in many directions)

+ Dependence Between Arrival and Departure Capacities Hub Connectivity with Multiple Connections
+ Banks of Flights
+ Rerouting of Aircraft

####  implementation

 using cplex

#### case studies

Air Traffic Flow Management Problem Test Cases

performed one set of experiments in the <u>**four airports**</u> for 200 flights over a 24-hour time period and another set for 1,000 flights over a 24-hour time period.

- Boston Logan (BOS), 
- NY LaGuardia (LGA), 
- Washington National (DCA),
- a node representing all other airports(X)

For the set of <u>200 flights,</u> to solve the problem CPLEX requires <u>234 seconds CPU time.</u> 

For the <u>1000</u>, solve it at the infeasibility border over a <u>24 hour time</u> period.

## paper replication

#### algorithm design

I think it is a linear programming (LP).

main.cpp+tfmp.cpp+createInfo.cpp+commonFunction.cpp+ .h

Firstly, structure input

```c++
// create capacity Info.
        Create_capacity( D_k, A_k, S_sector, H, j);
 //create time Info. still have some problems
        Create_time( D_f, R_f, S_f, flight);
//create path
        Create_path( P, P_f, X, flight,j,env,H);
 //create the cost_g,cost_a,P_f
        Create_Cost( cost_g, cost_a, P.copy(), P_f.copy(), flight, t, env, X);
//create each flight's every sector's least-time
        Create_sector_time( L_sector, L_sector_f, X, flight,j,env,H,D_f.copy(),R_f.copy()); 
// create method
        create_sector_FeasibleTime(T_sector_first, T_sector_last, T_sector_first_f, T_sector_last_f, env, L_sector_f.copy(), D, D_f.copy(), R_f.copy(), X, flight);
```

Secondly,structure Objective function

Finally,structure Limit function (7 formula)

#### data structure

```c++
		//departure capacity
        IloNumArray D_k(env,H);
        //arrival capacity
        IloNumArray A_k(env,H);
        //sector capacity
        IloNumArray S_sector(env,j);
        
        //scheduled departure time
        IloNumArray D_f(env,flight);
        //scheduled arrival time
        IloNumArray R_f(env,flight);
        //turn around time after flight f;
        IloNumArray S_f(env,flight);
       
        // Path of a flight
        IloNumArray P(env,X+2);
        //flights' path
        IloNumArrayArray P_f(env,flight);
     
        // flight f cost on the ground
        IloNumArray cost_g(env,flight);
        // flight f cost in the air
        IloNumArray cost_a(env,flight);
       
        // Path's sector must spend time units
        IloNumArray L_sector(env,X+2);
        //flights' path-sector must spend time units
        IloNumArrayArray L_sector_f(env,flight);
        
        // first time period in the set T_f_j
        IloNumArray T_sector_first(env,X+2);
        // last time period in the set T_f_j
        IloNumArray T_sector_last(env,X+2);
        //flights' first time period in the set T_f_j
        IloNumArrayArray T_sector_first_f(env,flight);
        //flights' last time period in the set T_f_j
        IloNumArrayArray T_sector_last_f(env,flight);
```

object-oriented programming

input and output data(for example)

```
flight number: 100
intervals number: 168
sectors number: 20
flight's path number: 5
airports number: 20
upper bound of half an hour that a flight late to any given sector
number: 6
departure capacity
[5, 7, 6, 6, 3, 5, 7, 6, 6, 7,
3, 3, 5, 5, 5, 6, 5, 7, 3, 5]
arrival capacity
[6, 7, 7, 5, 3, 6, 7, 6, 4, 3,
5, 4, 5, 5, 3, 6, 7, 7, 7, 4]
sector capacity
[5, 5, 6, 4, 3, 3, 6, 4, 7, 5,
4, 6, 6, 7, 6, 3, 7, 4, 3, 6]
departure time
[83, 155, 118, 81, 114, 86, 106, 1, 157, 158,
155, 14, 20, 14, 106, 23, 120, 97, 42, 6,
28, 95, 22, 134, 30, 60, 82, 165, 4, 67,
61, 156, 138, 59, 97, 63, 77, 34, 159, 25,
118, 106, 96, 165, 42, 15, 26, 46, 55, 49,
66, 24, 18, 40, 4, 147, 143, 32, 129, 141,
133, 110, 139, 161, 164, 145, 42, 107, 71, 139, 167, 158, 11, 149, 128, 118, 16, 65, 112, 150,
63, 136, 51, 34, 137, 135, 33, 152, 48, 167,
93, 155, 88, 88, 151, 96, 2, 105, 74, 103]
arrival time
[110, 181, 147, 107, 144, 132, 142, 45, 203, 204,
181, 56, 63, 56, 134, 69, 158, 136, 73, 33,
53, 120, 54, 161, 77, 93, 122, 202, 35, 95,
93, 188, 169, 86, 130, 101, 111, 69, 198, 49,
154, 137, 122, 209, 78, 54, 57, 87, 84, 86,
99, 67, 59, 66, 42, 174, 167, 57, 154, 174,
164, 154, 174, 185, 203, 176, 76, 134, 107, 176,
207, 190, 49, 189, 163, 163, 47, 104, 137, 191,
95, 167, 90, 76, 164, 181, 77, 180, 81, 194,
129, 193, 112, 117, 178, 129, 29, 140, 101, 149]
each flight's turn around time
[7, 7, 7, 6, 7, 7, 6, 6, 7, 7,
7, 7, 6, 6, 6, 7, 6, 6, 6, 6,
6, 6, 6, 7, 6, 7, 6, 7, 6, 7,
7, 7, 7, 7, 7, 7, 7, 6, 7, 6,
7, 6, 6, 6, 6, 6, 6, 7, 6, 6,
7, 7, 7, 6, 6, 6, 7, 7, 6, 6,
7, 7, 7, 7, 6, 6, 7, 7, 7, 6,
7, 7, 7, 6, 6, 6, 6, 6, 7, 7,
6, 6, 7, 6, 7, 6, 6, 6, 7, 7,
7, 6, 7, 6, 6, 6, 7, 7, 7, 7]
Path of a flight
[[8, 8, 15, 13, 16, 8, 10], [6, 4, 14, 9, 19, 20, 7], [11, 5, 13, 14,
4, 18, 1], [0, 12, 1, 4, 14, 19, 17], [13, 15, 1, 20, 10, 3, 12], [0,
20, 4, 11, 1, 12, 10], [2, 7, 20, 11, 17, 5, 19], [6, 12, 5, 1, 19,
4, 2], [20, 1, 19, 15, 10, 14, 6], [17, 4, 9, 18, 11, 5, 16],
[10, 18, 12, 11, 7, 14, 6], [20, 3, 4, 13, 8, 2, 11], [20, 20, 8, 12,
15, 6, 2], [15, 9, 3, 16, 6, 14, 1], [7, 20, 15, 6, 10, 14, 17], [10,
1, 19, 13, 17, 8, 20], [20, 2, 12, 17, 9, 6, 1], [19, 19, 14, 8, 11,
12, 4], [7, 14, 8, 8, 16, 12, 3], [11, 7, 16, 5, 2, 18, 4],
[6, 5, 9, 17, 2, 16, 11], [1, 6, 14, 2, 12, 10, 8], [3, 9, 6, 5, 8,
10, 17], [7, 17, 8, 1, 5, 12, 11], [11, 12, 5, 19, 19, 15, 6], [5,
10, 19, 15, 6, 9, 8], [3, 15, 1, 17, 16, 4, 9], [12, 12, 13, 5, 17,
18, 16], [19, 11, 16, 13, 8, 18, 20], [15, 16, 14, 20, 10, 5, 2],
[11, 6, 10, 19, 14, 1, 18], [11, 19, 4, 17, 2, 20, 8], [10, 20, 8,
16, 16, 13, 5], [6, 5, 15, 8, 20, 16, 17], [6, 6, 20, 12, 4, 19, 5],
[6, 20, 12, 8, 5, 2, 15], [9, 11, 4, 13, 13, 2, 15], [2, 18, 1, 10,
6, 8, 3], [13, 18, 17, 9, 3, 10, 20], [17, 4, 18, 2, 13, 7, 16],
[18, 11, 15, 16, 2, 13, 14], [14, 13, 5, 12, 19, 17, 11], [2, 20, 15,
7, 16, 4, 13], [4, 20, 11, 11, 10, 6, 12], [4, 13, 17, 20, 12, 11,
18], [3, 9, 18, 11, 4, 17, 10], [6, 15, 12, 5, 7, 11, 3], [1, 11, 5,
14, 2, 8, 20], [14, 18, 11, 2, 2, 6, 3], [10, 13, 15, 20, 8, 18, 3],
[14, 11, 20, 18, 2, 17, 1], [20, 13, 17, 11, 9, 15, 5], [3, 11, 2,
16, 12, 6, 18], [5, 9, 6, 14, 18, 10, 17], [12, 2, 16, 19, 1, 10, 3],
[19, 4, 4, 10, 11, 16, 5], [2, 4, 19, 13, 13, 17, 15], [17, 1, 11, 9,
   2, 8, 15], [13, 12, 9, 16, 14, 10, 20], [12, 1, 5, 20, 11, 11, 14],
[1, 3, 19, 5, 9, 14, 16], [18, 1, 17, 8, 11, 4, 14], [0, 2, 5, 1, 1,
19, 18], [6, 19, 15, 3, 10, 11, 16], [15, 16, 6, 2, 12, 7, 20], [10,
15, 18, 20, 19, 1, 6], [2, 5, 3, 16, 1, 8, 7], [7, 3, 4, 10, 11, 19,
14], [3, 11, 1, 19, 15, 8, 17], [2, 7, 12, 5, 20, 17, 13],
[16, 9, 15, 15, 20, 12, 11], [5, 8, 4, 15, 9, 2, 13], [12, 4, 20, 20,
20, 17, 2], [19, 14, 20, 9, 5, 1, 7], [7, 15, 17, 10, 8, 20, 5], [12,
10, 7, 8, 11, 14, 2], [2, 17, 15, 16, 12, 13, 9], [7, 11, 8, 18, 10,
12, 13], [5, 13, 2, 12, 11, 14, 9], [3, 1, 20, 15, 13, 11, 18],
[11, 20, 13, 13, 4, 2, 14], [17, 2, 19, 12, 1, 1, 5], [8, 10, 5, 16,
11, 17, 20], [16, 19, 9, 13, 1, 3, 10], [9, 4, 16, 20, 19, 2, 3],
[12, 15, 1, 2, 11, 9, 5], [2, 16, 10, 11, 13, 4, 6], [0, 11, 12, 4,
7, 10, 15], [18, 13, 5, 5, 2, 20, 1], [11, 2, 6, 15, 10, 3, 1],
[14, 14, 9, 3, 2, 7, 4], [14, 20, 18, 5, 19, 17, 12], [4, 16, 17, 10,
9, 1, 3], [13, 17, 8, 7, 12, 12, 4], [12, 6, 8, 14, 7, 13, 1], [18,
18, 14, 16, 20, 12, 19], [4, 1, 19, 10, 16, 13, 14], [13, 17, 17, 7,
14, 5, 20], [10, 9, 20, 3, 6, 17, 8], [7, 9, 1, 11, 19, 13, 6]]
each flight cost on the ground
[1, 5, 2, 4, 2, 5, 5, 3, 2, 4,
2, 4, 4, 1, 4, 2, 2, 4, 3, 2,
2, 4, 4, 4, 1, 2, 4, 4, 5, 5,
4, 3, 3, 4, 4, 4, 1, 2, 1, 5,
3, 3, 5, 2, 1, 4, 4, 1, 5, 1,
4, 1, 1, 5, 1, 3, 3, 4, 3, 2,
5, 4, 1, 5, 1, 2, 5, 5, 4, 2,
4, 5, 3, 5, 1, 3, 1, 1, 3, 1,
5, 3, 2, 1, 2, 2, 1, 1, 3, 4,
1, 1, 1, 1, 3, 5, 4, 1, 2, 1]
each flight cost in the air
[4, 1, 4, 3, 4, 4, 3, 2, 5, 2,
2, 4, 5, 2, 3, 5, 2, 2, 2, 5,
5, 5, 1, 3, 2, 3, 3, 1, 3, 2,
2, 5, 4, 3, 5, 5, 4, 1, 3, 5,
5, 5, 5, 5, 2, 3, 5, 5, 3, 4,
1, 5, 1, 4, 2, 2, 1, 4, 5, 2,
4, 2, 4, 2, 4, 1, 4, 3, 2, 3,
5, 2, 5, 2, 3, 1, 1, 5, 3, 2,
3, 2, 4, 5, 2, 5, 1, 5, 4, 4,
4, 3, 4, 4, 4, 5, 2, 4, 2, 5]
each flight must spend time units
[[0, 6, 5, 5, 5, 6, 0], [0, 5, 5, 6, 6, 4, 0], [0, 6, 6, 6, 6, 5, 0],
[0, 5, 5, 6, 6, 4, 0], [0, 6, 7, 6, 6, 5, 0], [0, 9, 9, 10, 10, 8,
0], [0, 8, 8, 8, 7, 5, 0], [0, 8, 8, 9, 9, 10, 0], [0, 10, 10, 9, 9,
8, 0], [0, 9, 9, 9, 10, 9, 0],
[0, 5, 5, 6, 5, 5, 0], [0, 9, 8, 8, 8, 9, 0], [0, 9, 9, 9, 8, 8, 0],
[0, 8, 8, 9, 8, 9, 0], [0, 6, 5, 6, 5, 6, 0], [0, 9, 9, 10, 9, 9, 0],
[0, 7, 7, 8, 8, 8, 0], [0, 7, 7, 8, 8, 9, 0], [0, 7, 6, 6, 6, 6, 0],
[0, 5, 6, 5, 5, 6, 0],
[0, 6, 5, 6, 6, 2, 0], [0, 6, 5, 6, 6, 2, 0], [0, 7, 7, 7, 7, 4, 0],
   [0, 5, 5, 6, 6, 5, 0], [0, 10, 10, 10, 10, 7, 0], [0, 7, 7, 6, 6, 7,
0], [0, 9, 9, 8, 9, 5, 0], [0, 7, 8, 8, 7, 7, 0], [0, 6, 6, 7, 6, 6,
0], [0, 5, 6, 6, 5, 6, 0],
[0, 7, 6, 7, 7, 5, 0], [0, 6, 7, 6, 6, 7, 0], [0, 6, 7, 7, 7, 4, 0],
[0, 6, 6, 5, 5, 5, 0], [0, 6, 7, 7, 7, 6, 0], [0, 7, 7, 8, 8, 8, 0],
[0, 7, 6, 7, 6, 8, 0], [0, 7, 7, 7, 7, 7, 0], [0, 7, 8, 7, 7, 10, 0],
[0, 5, 5, 4, 4, 6, 0],
[0, 8, 8, 7, 7, 6, 0], [0, 7, 6, 7, 7, 4, 0], [0, 6, 6, 6, 5, 3, 0],
[0, 9, 9, 8, 8, 10, 0], [0, 8, 7, 8, 7, 6, 0], [0, 8, 7, 8, 7, 9, 0],
[0, 7, 7, 7, 6, 4, 0], [0, 8, 9, 8, 8, 8, 0], [0, 5, 6, 6, 5, 7, 0],
[0, 7, 7, 8, 8, 7, 0],
[0, 7, 6, 6, 7, 7, 0], [0, 9, 8, 8, 9, 9, 0], [0, 9, 9, 9, 9, 5, 0],
[0, 5, 6, 6, 6, 3, 0], [0, 7, 7, 7, 8, 9, 0], [0, 5, 5, 6, 6, 5, 0],
[0, 5, 5, 4, 4, 6, 0], [0, 5, 6, 5, 6, 3, 0], [0, 5, 6, 6, 6, 2, 0],
[0, 6, 7, 7, 7, 6, 0],
[0, 6, 6, 6, 6, 7, 0], [0, 9, 9, 9, 9, 8, 0], [0, 8, 7, 7, 8, 5, 0],
[0, 4, 4, 5, 4, 7, 0], [0, 8, 8, 8, 7, 8, 0], [0, 7, 7, 6, 7, 4, 0],
[0, 6, 7, 7, 6, 8, 0], [0, 5, 6, 5, 5, 6, 0], [0, 8, 8, 7, 7, 6, 0],
[0, 8, 8, 8, 7, 6, 0],
[0, 9, 8, 9, 8, 6, 0], [0, 6, 6, 6, 6, 8, 0], [0, 8, 7, 7, 8, 8, 0],
[0, 8, 9, 9, 9, 5, 0], [0, 7, 8, 7, 7, 6, 0], [0, 9, 10, 9, 9, 8, 0],
[0, 7, 6, 7, 6, 5, 0], [0, 8, 7, 8, 8, 8, 0], [0, 5, 5, 6, 6, 3, 0],
[0, 9, 9, 8, 9, 6, 0],
[0, 6, 6, 6, 7, 7, 0], [0, 7, 6, 7, 6, 5, 0], [0, 8, 7, 7, 8, 9, 0],
[0, 9, 9, 8, 8, 8, 0], [0, 5, 5, 5, 6, 6, 0], [0, 10, 10, 9, 10, 7,
0], [0, 8, 8, 8, 9, 11, 0], [0, 6, 6, 6, 5, 5, 0], [0, 6, 6, 7, 7, 7,
0], [0, 6, 5, 5, 5, 6, 0],
[0, 8, 8, 7, 8, 5, 0], [0, 8, 8, 7, 7, 8, 0], [0, 5, 4, 5, 5, 5, 0],
[0, 5, 5, 5, 5, 9, 0], [0, 6, 5, 5, 5, 6, 0], [0, 7, 6, 6, 7, 7, 0],
[0, 5, 5, 5, 5, 7, 0], [0, 8, 7, 7, 7, 6, 0], [0, 6, 5, 5, 6, 5, 0],
[0, 9, 9, 9, 9, 10, 0]]
each flight first time period in one sector
[[83, 83, 89, 94, 99, 104, 110], [155, 155, 160, 165, 171, 177, 181],
[118, 118, 124, 130, 136, 142, 147], [81, 81, 86, 91, 97, 103, 107],
[114, 114, 120, 127, 133, 139, 144], [86, 86, 95, 104, 114, 124,
132], [106, 106, 114, 122, 130, 137, 142], [1, 1, 9, 17, 26, 35, 45],
[157, 157, 167, 177, 186, 195, 203], [158, 158, 167, 176, 185, 195,
204],
[155, 155, 160, 165, 171, 176, 181], [14, 14, 23, 31, 39, 47, 56],
[20, 20, 29, 38, 47, 55, 63], [14, 14, 22, 30, 39, 47, 56], [106,
106, 112, 117, 123, 128, 134], [23, 23, 32, 41, 51, 60, 69], [120,
120, 127, 134, 142, 150, 158], [97, 97, 104, 111, 119, 127, 136],
[42, 42, 49, 55, 61, 67, 73], [6, 6, 11, 17, 22, 27, 33],
[28, 28, 34, 39, 45, 51, 53], [95, 95, 101, 106, 112, 118, 120], [22,
22, 29, 36, 43, 50, 54], [134, 134, 139, 144, 150, 156, 161], [30,
30, 40, 50, 60, 70, 77], [60, 60, 67, 74, 80, 86, 93], [82, 82, 91,
100, 108, 117, 122], [165, 165, 172, 180, 188, 195, 202], [4, 4, 10,
16, 23, 29, 35], [67, 67, 72, 78, 84, 89, 95],
[61, 61, 68, 74, 81, 88, 93], [156, 156, 162, 169, 175, 181, 188],
   [138, 138, 144, 151, 158, 165, 169], [59, 59, 65, 71, 76, 81, 86],
[97, 97, 103, 110, 117, 124, 130], [63, 63, 70, 77, 85, 93, 101],
[77, 77, 84, 90, 97, 103, 111], [34, 34, 41, 48, 55, 62, 69], [159,
159, 166, 174, 181, 188, 198], [25, 25, 30, 35, 39, 43, 49],
[118, 118, 126, 134, 141, 148, 154], [106, 106, 113, 119, 126, 133,
137], [96, 96, 102, 108, 114, 119, 122], [165, 165, 174, 183, 191,
199, 209], [42, 42, 50, 57, 65, 72, 78], [15, 15, 23, 30, 38, 45,
54], [26, 26, 33, 40, 47, 53, 57], [46, 46, 54, 63, 71, 79, 87], [55,
55, 60, 66, 72, 77, 84], [49, 49, 56, 63, 71, 79, 86],
[66, 66, 73, 79, 85, 92, 99], [24, 24, 33, 41, 49, 58, 67], [18, 18,
27, 36, 45, 54, 59], [40, 40, 45, 51, 57, 63, 66], [4, 4, 11, 18, 25,
33, 42], [147, 147, 152, 157, 163, 169, 174], [143, 143, 148, 153,
157, 161, 167], [32, 32, 37, 43, 48, 54, 57], [129, 129, 134, 140,
146, 152, 154], [141, 141, 147, 154, 161, 168, 174],
[133, 133, 139, 145, 151, 157, 164], [110, 110, 119, 128, 137, 146,
154], [139, 139, 147, 154, 161, 169, 174], [161, 161, 165, 169, 174,
178, 185], [164, 164, 172, 180, 188, 195, 203], [145, 145, 152, 159,
165, 172, 176], [42, 42, 48, 55, 62, 68, 76], [107, 107, 112, 118,
123, 128, 134], [71, 71, 79, 87, 94, 101, 107], [139, 139, 147, 155,
163, 170, 176],
[167, 167, 176, 184, 193, 201, 207], [158, 158, 164, 170, 176, 182,
190], [11, 11, 19, 26, 33, 41, 49], [149, 149, 157, 166, 175, 184,
189], [128, 128, 135, 143, 150, 157, 163], [118, 118, 127, 137, 146,
155, 163], [16, 16, 23, 29, 36, 42, 47], [65, 65, 73, 80, 88, 96,
104], [112, 112, 117, 122, 128, 134, 137], [150, 150, 159, 168, 176,
185, 191],
[63, 63, 69, 75, 81, 88, 95], [136, 136, 143, 149, 156, 162, 167],
[51, 51, 59, 66, 73, 81, 90], [34, 34, 43, 52, 60, 68, 76], [137,
137, 142, 147, 152, 158, 164], [135, 135, 145, 155, 164, 174, 181],
[33, 33, 41, 49, 57, 66, 77], [152, 152, 158, 164, 170, 175, 180],
[48, 48, 54, 60, 67, 74, 81], [167, 167, 173, 178, 183, 188, 194],
[93, 93, 101, 109, 116, 124, 129], [155, 155, 163, 171, 178, 185,
193], [88, 88, 93, 97, 102, 107, 112], [88, 88, 93, 98, 103, 108,
117], [151, 151, 157, 162, 167, 172, 178], [96, 96, 103, 109, 115,
122, 129], [2, 2, 7, 12, 17, 22, 29], [105, 105, 113, 120, 127, 134,
140], [74, 74, 80, 85, 90, 96, 101], [103, 103, 112, 121, 130, 139,
149]]
each flight last time period in one sector
[[89, 101, 112, 123, 134, 146, 152], [161, 172, 183, 195, 207, 217,
223], [124, 136, 148, 160, 172, 183, 189], [87, 98, 109, 121, 133,
143, 149], [120, 132, 145, 157, 169, 180, 186], [92, 107, 122, 138,
154, 168, 174], [112, 126, 140, 154, 167, 178, 184], [7, 21, 35, 50,
65, 81, 87], [163, 179, 195, 210, 225, 239, 245], [164, 179, 194,
209, 225, 240, 246],
[161, 172, 183, 195, 206, 217, 223], [20, 35, 49, 63, 77, 92, 98],
[26, 41, 56, 71, 85, 99, 105], [20, 34, 48, 63, 77, 92, 98], [112,
124, 135, 147, 158, 170, 176], [29, 44, 59, 75, 90, 105, 111], [126,
139, 152, 166, 180, 194, 200], [103, 116, 129, 143, 157, 172, 178],
[48, 61, 73, 85, 97, 109, 115], [12, 23, 35, 46, 57, 69, 75],
  [34, 46, 57, 69, 81, 89, 95], [101, 113, 124, 136, 148, 156, 162],
[28, 41, 54, 67, 80, 90, 96], [140, 151, 162, 174, 186, 197, 203],
[36, 52, 68, 84, 100, 113, 119], [66, 79, 92, 104, 116, 129, 135],
[88, 103, 118, 132, 147, 158, 164], [171, 184, 198, 212, 225, 238,
244], [10, 22, 34, 47, 59, 71, 77], [73, 84, 96, 108, 119, 131, 137],
[67, 80, 92, 105, 118, 129, 135], [162, 174, 187, 199, 211, 224,
230], [144, 156, 169, 182, 195, 205, 211], [65, 77, 89, 100, 111,
122, 128], [103, 115, 128, 141, 154, 166, 172], [69, 82, 95, 109,
123, 137, 143], [83, 96, 108, 121, 133, 147, 153], [40, 53, 66, 79,
92, 105, 111], [165, 178, 192, 205, 218, 234, 240], [31, 42, 53, 63,
73, 85, 91],
[124, 138, 152, 165, 178, 190, 196], [112, 125, 137, 150, 163, 173,
179], [102, 114, 126, 138, 149, 158, 164], [171, 186, 201, 215, 229,
245, 251], [48, 62, 75, 89, 102, 114, 120], [21, 35, 48, 62, 75, 90,
96], [32, 45, 58, 71, 83, 93, 99], [52, 66, 81, 95, 109, 123, 129],
[61, 72, 84, 96, 107, 120, 126], [55, 68, 81, 95, 109, 122, 128],
[72, 85, 97, 109, 122, 135, 141], [30, 45, 59, 73, 88, 103, 109],
[24, 39, 54, 69, 84, 95, 101], [46, 57, 69, 81, 93, 102, 108], [10,
23, 36, 49, 63, 78, 84], [153, 164, 175, 187, 199, 210, 216], [149,
160, 171, 181, 191, 203, 209], [38, 49, 61, 72, 84, 93, 99], [135,
146, 158, 170, 182, 190, 196], [147, 159, 172, 185, 198, 210, 216],
[139, 151, 163, 175, 187, 200, 206], [116, 131, 146, 161, 176, 190,
196], [145, 159, 172, 185, 199, 210, 216], [167, 177, 187, 198, 208,
221, 227], [170, 184, 198, 212, 225, 239, 245], [151, 164, 177, 189,
202, 212, 218], [48, 60, 73, 86, 98, 112, 118], [113, 124, 136, 147,
158, 170, 176], [77, 91, 105, 118, 131, 143, 149], [145, 159, 173,
187, 200, 212, 218],
[173, 188, 202, 217, 231, 243, 249], [164, 176, 188, 200, 212, 226,
232], [17, 31, 44, 57, 71, 85, 91], [155, 169, 184, 199, 214, 225,
231], [134, 147, 161, 174, 187, 199, 205], [124, 139, 155, 170, 185,
199, 205], [22, 35, 47, 60, 72, 83, 89], [71, 85, 98, 112, 126, 140,
146], [118, 129, 140, 152, 164, 173, 179], [156, 171, 186, 200, 215,
227, 233],
[69, 81, 93, 105, 118, 131, 137], [142, 155, 167, 180, 192, 203,
209], [57, 71, 84, 97, 111, 126, 132], [40, 55, 70, 84, 98, 112,
118], [143, 154, 165, 176, 188, 200, 206], [141, 157, 173, 188, 204,
217, 223], [39, 53, 67, 81, 96, 113, 119], [158, 170, 182, 194, 205,
216, 222], [54, 66, 78, 91, 104, 117, 123], [173, 185, 196, 207, 218,
230, 236],
[99, 113, 127, 140, 154, 165, 171], [161, 175, 189, 202, 215, 229,
235], [94, 105, 115, 126, 137, 148, 154], [94, 105, 116, 127, 138,
153, 159], [157, 169, 180, 191, 202, 214, 220], [102, 115, 127, 139,
152, 165, 171], [8, 19, 30, 41, 52, 65, 71], [111, 125, 138, 151,
164, 176, 182], [80, 92, 103, 114, 126, 137, 143], [109, 124, 139,
154, 169, 185, 191]]
```

#### implementation procedures

Using the Cplex and C++

the problems faced when I was coding 

- not familar with the Cplex and its c plus plus Reference Manual

- Promotional version problem.

  ​

#### convergence and computational efficiency analysis

NP hard (may not found solutions) taking the input info. into account.



#### scenario design

objective design

```c++
 // TFMP final target
        IloExpr FinalRes(env);
        IloExpr FinalRes_temp1(env);
        IloExpr FinalRes_temp2(env);
        for (int n=0; n<flight; n++) {
            int Cfg=cost_g[n];
            int Cfa=cost_a[n];
            int Df=D_f[n];
            int Rf=R_f[n];
            for (int m=1; m<t; m++) {
                if(m>=T_sector_first_f[n][0]&&m<=T_sector_last_f[n][0]){
                    FinalRes_temp1+=m*(Wfst[n][0][m]-Wfst[n][0][m-1]);
                }
                if(m>=T_sector_first_f[n][X+1]&&m<=T_sector_last_f[n][X+1]){
                    FinalRes_temp2+=m*(Wfst[n][X+1][m]-Wfst[n][X+1][m-1]);
                }
            }
            FinalRes+= (Cfg-Cfa)*FinalRes_temp1+Cfa*FinalRes_temp2+(Cfa-Cfg)*Df+Cfa*Rf;
          
        }
```

subjective design(for example)

```c++
  //subject to 5
        for (int m=0; m<flight; m++) {
            for (int n=0; n<X+1; n++) {
                for (int p=0; p<t; p++) {
                    //if n~T_f_j(T_sector_first_f T_sector_last_f)
                    if(p<=T_sector_last_f[m][n]&&p>=T_sector_first_f[m][n]){
                        int lfj=L_sector_f[m][n];
                        if(p+lfj<t){
                            model.add(Wfst[m][n+1][p+lfj]<=Wfst[m][n][p]);
                        }
                    }

                }
            }
        }
```

input structure design

output analysis



#### case studies

For the set of <u>200 flights,</u> to solve the problem CPLEX requires <u>234 seconds CPU time.</u> 

For the <u>1000</u>, solve it at the infeasibility border over a <u>24 hour time</u> period.



#### Compare your results to the paper. 

+ Paper

![屏幕快照 2018-05-12 21.32.57](/Users/xiongjunjie/Desktop/屏幕快照 2018-05-12 21.32.57.png)

+ mine 

```
1000-0.1-(5-8)-time()-0


Found incumbent of value 197745.000000 after 0.01 sec. (2.20 ticks)
Tried aggregator 99 times.
MIP Presolve eliminated 380071 rows and 202 columns.
Aggregator did 530 substitutions.
All rows and columns eliminated.
Presolve time = 8.32 sec. (3364.02 ticks)

1000-0.1-(10-13)-time()-0

MIP Presolve eliminated 942173 rows and 834 columns.
MIP Presolve modified 97 coefficients.
Aggregator did 241 substitutions.
Reduced MIP has 144 rows, 101 columns, and 369 nonzeros.
Reduced MIP has 99 binaries, 2 generals, 0 SOSs, and 0 indicators.
Presolve time = 4.85 sec. (4314.61 ticks)
```



