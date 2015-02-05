DCI project aiming Javascript
=============================

A short description of DCI: Data, Context, Interaction

- **Data**: a dumb object passed in and used inside a context
- **Context**: an environment where roles are given to data to make turn them into smart objects and interact with each other
- **Interaction**: interaction between actors is expressed with code inside the enclosed environment that is the context

For a more complete description please read more at the following links:
- [http://en.wikipedia.org/wiki/Data,_context_and_interaction](Wikipedia article about DCI)
- [https://groups.google.com/forum/#!msg/object-composition/umY_w1rXBEw/hyAF-jPgFn4J](FullOO (a.k.a. DCI) Summit in Oslo)
- [http://fulloo.info/](Full OO Website)
- [http://folk.uio.no/trygver/](Trygve Reenskaug Website)


Terminology
------------
- **Data**: an **actor** wannabe, any object given to a **context** that has not yet received a **role**
- **Actor**: **Data**, an object, with a specific set of **roles**, that will interact inside a **context** with other **actors**
- **Context**: a **use case** scenario where one ore more actors will act
- **Use case**: same as a **context**
- **Role**: a set of abilities and attributes to be given to an **actor**
- **Context object**: whenever a **context** is used, a new **context object** will be created that will handle **role** assignment and other things (not clear at the moment)

This is still a very incomplete project under heavy development, I'm still not sure if I like the api as it is now

For anyone interested, Eunomia is the ancient greek goddess of law and order
