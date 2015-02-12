DCI project aiming Javascript
=============================
*For anyone interested, Eunomia is the ancient greek goddess of law and order*

A short description of DCI: Data, Context, Interaction

- **Data**: a dumb object passed in and used inside a context
- **Context**: an environment where roles are given to data to make turn them into smart objects and interact with each other
- **Interaction**: interaction between actors is expressed with code inside the enclosed environment that is the context

For a more complete description please read more at the following links:
- [Wikipedia article about DCI](http://en.wikipedia.org/wiki/Data,_context_and_interaction)
- [FullOO (a.k.a. DCI Summit in Oslo)](https://groups.google.com/forum/#!msg/object-composition/umY_w1rXBEw/hyAF-jPgFn4J)
- [Full OO Website](http://fulloo.info/)
- [Trygve Reenskaug Website](http://folk.uio.no/trygver/)


Eunomia Terminology
-------------------
- **Entity**: **data**, an object, an **actor** wannabe, any object given to a **use case** that has not yet received a **role**
- **Actor**: **Data**, an object, with a specific set of **roles**, that will interact inside a **context** with other **actors**
- **Context**: a group of one or more **use case** scenarios where one ore more actors will act
- **Use case**: the core of your software, where all the action will happen, the place where actors will interact giving value to your application
- **Role**: a set of abilities and attributes to be given to an **actor**

This is still a very incomplete project under heavy development, I'm still not sure if I like the api as it is now


Many thanks go to [Timothy Farrell](https://github.com/explorigin) for his help defining the spec.
