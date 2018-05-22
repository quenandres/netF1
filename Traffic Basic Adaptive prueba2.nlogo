globals [
  sample-car
  speed-to-beat
  acceleration
  best-acceleration-so-far
]

;;Variables intrínsecas a cada tortuga.
turtles-own [
  speed
  speed-limit
  speed-min
  name
  mecanicos
]

to setup
  clear-all
  ask patches [ setup-road ]
  setup-cars
  set acceleration init-acceleration
  watch sample-car
  reset-ticks
end

to setup-road ;; patch procedure
  if pycor < 5 and pycor > -5 [ set pcolor green ]
  if pxcor < -20 and pxcor > -24 [set pcolor yellow]

end

to setup-cars
  set-default-shape turtles "car"
  create-turtles number-of-cars [
    set color blue
    set xcor -22
    set ycor random-ycor
    set heading 90
    ;; set initial speed to be in range 0.1 to 1.0
    set speed 0.1 + random-float 0.9
    set speed-limit 1
    set speed-min 0
    set name 2
    set mecanicos 0
  ]



  set sample-car one-of turtles
  ask sample-car [ set color red ]
  ask sample-car [ set name 1 ]
end

to go
  ;; if there is a car right ahead of you, match its speed then slow down
  ask turtles [
   ;; if sample-car pxcor = -25 [show "pasa -24"]
    let car-ahead one-of turtles-on patch-ahead 1
    show mecanicos
    ifelse car-ahead != nobody
      [ slow-down-car car-ahead ]
      [ speed-up-car ] ;; otherwise, speed up
    ;; don't slow down below speed minimum or speed up beyond speed limit
    ;;show "car-ahead"
    ;;show car-ahead
    ;;show xcor

    ;;if xcor < -20 and xcor > -24 [pits car-ahead]
    if xcor < -22 and xcor > -24 [set speed 0]

    ;; [set speed (0)]
    show mecanicos
    ;;if speed < 0.1 [ set speed speed-limit ]
    if speed > 0.9 [ set speed speed-limit ]

    fd speed
    ;;show speed
  ]


  ask patches[

  ]
  tick
end

to pits [car-ahead]
  set speed 0
  ;;set mecanicos (random 5)
end

;;to funmecanicos
;;  (random 5)
;;end

to slow-down-car [ car-ahead ] ;; turtle procedure
  ;; slow down so you are driving more slowly than the car ahead of you
  set speed [ speed ] of car-ahead - deceleration
end

to speed-up-car ;; turtle procedure
  set speed speed + acceleration
end
@#$#@#$#@
GRAPHICS-WINDOW
5
265
1033
454
-1
-1
20.0
1
10
1
1
1
0
1
0
1
-25
25
-4
4
1
1
1
ticks
30.0

BUTTON
25
160
97
201
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
170
160
240
200
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
5
10
209
43
number-of-cars
number-of-cars
1
3
2.0
1
1
NIL
HORIZONTAL

SLIDER
5
80
210
113
deceleration
deceleration
0
.099
0.085
.001
1
NIL
HORIZONTAL

SLIDER
5
45
210
78
init-acceleration
init-acceleration
0
.099
0.0896
.0001
1
NIL
HORIZONTAL

PLOT
275
10
690
210
Car speeds
time
speed
0.0
300.0
0.0
1.1
true
true
"" ""
PENS
"red car" 1.0 0 -2674135 true "" "if plot-red-car? [ plotxy ticks [ speed ] of sample-car ]"
"min speed" 1.0 0 -13345367 true "" "plot min [speed] of turtles"
"max speed" 1.0 0 -10899396 true "" "plot max [speed] of turtles"
"avg speed" 1.0 0 -7500403 true "" "plot mean [speed] of turtles"

MONITOR
275
210
372
255
red car speed
ifelse-value any? turtles\n  [   [speed] of sample-car  ]\n  [  0 ]
3
1
11

MONITOR
130
210
267
255
current acceleration
acceleration
4
1
11

MONITOR
690
210
765
255
avg speed
mean [speed] of turtles
3
1
11

PLOT
690
10
1020
210
Speed to beat vs avg speed
NIL
NIL
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"speed to beat" 1.0 0 -16777216 true "" "plot speed-to-beat"
"avg speed" 1.0 0 -7500403 true "" "plot mean [ speed ] of turtles"

MONITOR
920
210
1020
255
NIL
speed-to-beat
4
1
11

MONITOR
5
210
120
255
best acceleration
best-acceleration-so-far
4
1
11

@#$#@#$#@
## ACKNOWLEDGMENT

This model is from Chapter Five of the book "Introduction to Agent-Based Modeling: Modeling Natural, Social and Engineered Complex Systems with NetLogo", by Uri Wilensky & William Rand.

* Wilensky, U. & Rand, W. (2015). Introduction to Agent-Based Modeling: Modeling Natural, Social and Engineered Complex Systems with NetLogo. Cambridge, MA. MIT Press.

This model is in the IABM Textbook folder of the NetLogo Models Library. The model, as well as any updates to the model, can also be found on the textbook website: http://www.intro-to-abm.com/.

## WHAT IS IT?

This model models the movement of cars on a highway. Each car follows a simple set of rules: it slows down (decelerates) if it sees a car close ahead, and speeds up (accelerates) if it doesn't see a car ahead. The model extends the Traffic Basic model, from the social science section of the NetLogo models library, by having cars adapt their acceleration to try and maintain a smooth flow of traffic.

An agent that can change its strategy based on prior experience is an adaptive agent. Unlike conventional agents, which will always do the same thing when presented with the same circumstances, adaptive agents can make different decisions if given the same set of inputs. In the Traffic Basic model, cars do not always take the same action; they operate differently based on the cars around them by either slowing down or speeding up. However, regardless of what has happened to the cars in the past (i.e., whether they got stuck in traffic jams or not) they will continue to take the same actions in the same conditions in the future. To be truly adaptive, agents need to be able to change not only their actions in time, but also their strategies. They must be able to change how they act because they have encountered a similar situation in the past and can react differently this time based on their past experience. In other words, the agents learn from their past experience and change their behavior in the future to account for this learning.

In this model, cars use the best acceleration they have found so far unless they are in a tick where they are exploring a new acceleration value, as specified by `ticks-between-tests`. Over time, the cars keep a weighted average of the speed they are able to maintain at the best acceleration; if the new acceleration allows for a faster speed, the cars will then switch to using that new acceleration. This average for the best acceleration weighs the past historical speeds higher (0.9) than the present speed (0.1), accounting for the fact that you can occasionally get spurious results (noise). Thus, it is better to rely on a large amount of data than one particular data point. However, the code still allows the best acceleration to change, which means even if the environment were to change (e.g., more cars on the road, longer road, etc.) the car could adapt to the new situation.

## HOW TO USE IT

Click on the SETUP button to set up the cars.

Set the NUMBER-OF-CARS slider to change the number of cars on the road.

Click on GO to start the cars moving.  Note that they wrap around the world as they move, so the road is like a continuous loop.

The INIT-ACCELERATION slider controls the rate at which cars initially accelerate (speed up) when there are no cars ahead.

When a car sees another car right in front, it matches that car's speed and then slows down a bit more.  How much slower it goes than the car in front of it is controlled by the DECELERATION slider.

Click on ADAPTIVE-GO to see how the results change when the cars are adapting to the environment around them, by changing their acceleration.

ADAPTIVE-GO employs the TICKS-BETWEEN-TESTS slider. This slider controls how frequently the model tests to see if it has found a better acceleration.

There are five monitors:

- BEST ACCELERATION displays the acceleration that the model believes leads to the fastest moving traffic. This is only used in ADAPTIVE-GO mode.

- CURRENT ACCELERATION displays the current value of the cars' acceleration. This only changes when in ADAPTIVE-GO mode.

- RED CAR SPEED displays the speed of one randomly selected car, which is colored red.

- AVG SPEED displays the average speed of the cars.

- SPEED-TO-BEAT displays the speed that AVG SPEED needs to beat when a test occurs for the model to think its found a better acceleration. This is only used in ADAPTIVE-GO mode.

The CAR SPEEDS plot plots the minimum, maximum and average speed of the cars. If the PLOT-RED-CAR? switch is on, it also plots the speed of the red car.

The SPEED TO BEAT VS AVG SPEED plot compares the average speed of the cars to the speed to beat over time. This is only used in ADAPTIVE-GO mode.

## THINGS TO NOTICE

Traffic Basic explored how traffic jams can start from small disturbances.  The goal of Traffic Basic Adaptive is to examine how this changes when the cars are actively trying to avoid traffic jams.  Does the behavior of the cars and jams visibly change when they are adapting? Is there a difference in the plot of the fastest, slowest, average and red cars, compared to the Traffic Basic model plot?

In Traffic Basic changing the Acceleration and Deceleration could affect the model dramatically. What role does the INIT-ACCELERATION slider in this model play versus the ACCELERATION slider in the original model?  Does it affect the results as much?  How about the DECELERATION slider?  Has its effect changed?

## THINGS TO TRY

The purpose of the TICKS-BETWEEN-TESTS slider is to allow the speed to stabilize between changes to acceleration. What happens if you set TICKS-BETWEEN-TESTS to `1`, thereby _not_ giving the speed a chance to stabilize?

Can you find a better value for TICKS-BETWEEN-TESTS than the default value for the model? A good way to do that would be to design a BehaviorSpace experiment that tries many possible values of TICKS-BETWEEN-TESTS and checks how long it takes (if ever) for the cars to reach an average speed of `1.0`. You would need to have multiple repetitions for each value, however, because the randomness in the model can lead to different results from one run to another.

## EXTENDING THE MODEL

In this version of the model, the `acceleration` is the same for all agents, and agents are trying to maximize the average speed of all cars. Without looking at the "Traffic Basic Adaptive Individuals" model, can you modify the model so all cars have their own acceleration and are trying to maximize their individual speed?

In the `adaptive-go` procedure, we compare the `speed-to-beat` with the `mean [ speed ] of turtles`. That gives us the mean speed at the current tick, but what if we looked instead at the mean speed for all ticks since the previous test? Would that help the cars achieve faster speed?

## NETLOGO FEATURES

The behavior of the CAR SPEEDS plot is conditional on the value of the PLOT-RED-CAR? switch. This is achieved by using a simple `if`-condition in the update commands of the `"red car"` plot pen:

    if plot-red-car? [ plotxy ticks [ speed ] of sample-car ]

Notice the use of `plotxy ticks ...` instead of just `plot ...`. Since the plot pen may not be updated right from the start, we need to make sure we plot the right _x_ value, namely `ticks`.

## RELATED MODELS

- "Traffic Basic": a simple model of the movement of cars on a highway.

- "Traffic Basic Utility": a version of "Traffic Basic" including a utility function for the cars.

- "Traffic Basic Adaptive Individuals": a version of "Traffic Basic Adaptive" where each car adapts individually, instead of all cars adapting in unison.

- "Traffic 2 Lanes": a more sophisticated two-lane version of the "Traffic Basic" model.

- "Traffic Intersection": a model of cars traveling through a single intersection.

- "Traffic Grid": a model of traffic moving in a city grid, with stoplights at the intersections.

- "Traffic Grid Goal": a version of "Traffic Grid" where the cars have goals, namely to drive to and from work.

- "Gridlock HubNet": a version of "Traffic Grid" where students control traffic lights in real-time.

- "Gridlock Alternate HubNet": a version of "Gridlock HubNet" where students can enter NetLogo code to plot custom metrics.

The traffic models from chapter 5 of the IABM textbook demonstrate different types of cognitive agents: "Traffic Basic Utility" demonstrates _utility-based agents_, "Traffic Grid Goal" demonstrates _goal-based agents_, and "Traffic Basic Adaptive" and "Traffic Basic Adaptive Individuals" demonstrate _adaptive agents_.

## HOW TO CITE

This model is part of the textbook, “Introduction to Agent-Based Modeling: Modeling Natural, Social and Engineered Complex Systems with NetLogo.”

If you mention this model or the NetLogo software in a publication, we ask that you include the citations below.

For the model itself:

* Rand, W., Wilensky, U. (2008).  NetLogo Traffic Basic Adaptive model.  http://ccl.northwestern.edu/netlogo/models/TrafficBasicAdaptive.  Center for Connected Learning and Computer-Based Modeling, Northwestern Institute on Complex Systems, Northwestern University, Evanston, IL.

Please cite the NetLogo software as:

* Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

Please cite the textbook as:

* Wilensky, U. & Rand, W. (2015). Introduction to Agent-Based Modeling: Modeling Natural, Social and Engineered Complex Systems with NetLogo. Cambridge, MA. MIT Press.

## COPYRIGHT AND LICENSE

Copyright 2008 Uri Wilensky.

![CC BY-NC-SA 3.0](http://ccl.northwestern.edu/images/creativecommons/byncsa.png)

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License.  To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.

Commercial licenses are also available. To inquire about commercial licenses, please contact Uri Wilensky at uri@northwestern.edu.

<!-- 2008 Cite: Rand, W., Wilensky, U. -->
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.3
@#$#@#$#@
setup
repeat 180 [ go ]
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
1
@#$#@#$#@
