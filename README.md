## 2ner: a toon shader

2ner is a toon shader for Unity's built in render pipeline. It is my second
toon shader, replacing github.com/yum-food/Tooner.

It's a ground-up rewrite taking into account some key lessons from last time:

1. Performance perfectionism really is required for realtime graphics
   1.1. "You don't pay for what you don't use" must be respected!
2. Tooling is absolutely required to mitigate performance creep, minimize
   compilation times, and reduce the risk of hitting compiler bugs.
   2.1. Yes, I have hit compiler bugs!

As with Tooner, it is an all encompassing uber shader. The goal is to expose
feature rich abstractions for both avatars and worlds.

