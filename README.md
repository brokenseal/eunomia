DCI project aiming Javascript
=============================
Many thanks go to [Timothy Farrell](https://github.com/explorigin) for his help defining the spec.

A short description of DCI: Data, Context, Interaction

- **Data**: a dumb object passed in and used inside a context
- **Context**: an environment where roles are given to data to turn them into smart objects and interact with each other
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


API
---
Eunomia exposes two main functions: role and context

**eunomia.role(roleSpec, entityInterface)**
- roleSpec is a generic JSON object defining all methods that express the role
- entityInterface is a, non mandatory, generic JSON object defining the interface that actors will have to comply to, a sort of structural static type specification

Examples:
```
var roles = {
    waiter: eunomia.role({
        takeOrder: function(order){},
        serve: function(){}
    }),
    manager: eunomia.role({
        createInvoiceFor: function(supplier){
            // code here
            this.createNewExcelSheet();
            // more code here
        }
    }, {
        knowsHowToCount: Boolean,
        createNewExcelSheet: Function
    }),
    customer: eunomia.role({
        orderFood: function(){},
        paysForFood: function(amount){
            // code here
            this.wallet -= amount;
            // more code here
        },
        choosesFood: function(menu){},
        eat: function(food){}
    }, {
        wallet: 1000
    })
};
```

**eunomia.context(roles, useCases)**
- roles is a generic JSON object referring to roles created by eunomia.role
- useCases is a generic JSON object referring to use cases as functions; these use cases will be invoked using the appropriate actors

Example:
```
// Using the previous roles object
var restaurant = eunomia.context(roles, {
    takeOrder: function(actors){
        var order = actors.choosesFood(actors.menu);
        actors.waiter.takeOrder(order);
    },
    serveFood: function(actors){
        var food = actors.waiter.serve();
        actors.customer.eat(food);
    }
});

var paul = {firstName: 'Paul'};
var jake = {firstName: 'Jake'};

restaurant.takeOrder({
    customer: paul,
    waiter: jake
});

restaurant.serveFood({
    customer: paul,
    waiter: jake
});
```

For more examples, please consider taking a look at the unit tests under spec/

*For anyone interested, Eunomia is the ancient greek goddess of law and order*
