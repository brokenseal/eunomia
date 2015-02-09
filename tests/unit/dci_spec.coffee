expect = require("chai").expect
eunomia = require("../../src/eunomia")
testUtils = require("../utils")


roles = {
  customer: {order: ->}
  waiter: {serve: ->}
  cashier: {getTheMoney: ->}
}


describe('A context', ->
  it('represents at least one use case', ->
    # expect success
    eunomia.context({}, {
      sampleUseCase: ->
    })
    # expect failure
    expect(->
      eunomia.context({}, {})
    ).to.throw(Error)
  )
  it('can represent more than one use case', ->
    context = eunomia.context({}, {
      sampleUseCaseOne: ->
      sampleUseCaseTwo: ->
    })

    expect(context).to.have.ownProperty('sampleUseCaseOne')
    expect(context).to.have.ownProperty('sampleUseCaseTwo')
  )
  it('object is instantiated for each enactment of a use case for which it is responsible', ->
    # not sure what to do here
  )
  it('needs to identify the objects that will participate in the use case at the start of a use case enactment', ->
    # again, not sure what this means, a context should receive the entities, not look for them by itself
  )
  it('is responsible to assign roles to actors', ->
    restaurant = eunomia.context(roles, {
      serveTable: (actors) ->
        expect(eunomia.hasRole(actors.customer, roles.customer)).to.be.true
        expect(eunomia.hasRole(actors.waiter, roles.waiter)).to.be.true
    })

    restaurant.serveTable({
      customer: {}
      waiter: {}
    })
  )
)

describe('A role', ->
  it('needs to be stateless', ->
    # how do we ensure that a role is stateless? should we accept roles only with methods and not attributes?
    # we could use a singleton with private set of variable for internal use to a role if necessary
  )
  it('can only be bound to one actor', ->
    # the intrinsinc nature of json objects disallows multiple actors taking up the same role
    restaurant = eunomia.context(roles, {
      tip: (actors)->
        for name of actors
          expect(roles).to.have.ownProperty(name)
    })

    restaurant.tip({
      waiter: {}
      customer: {}
    })
  )
  it('but multiple roles can be bound to the same actor', ->

  )
  it('methods run in the context of an actor that is selected by the context to play it for the current use case
      enactment.', ->
    # contexts should not know about the state, attributes or methods of the data given to it, only roles methods should
    # need to access the actor
    # a context should only know about roles
  )
  it('infers an interface to an actor', ->

  )
  it('is cast anew on every use case enactment to an actor', ->

  )
  it('is removed at the end of a use case enactment from the corresponding actor', ->

  )
  it('can only be bound to objects to which it make sense to bind it, otherwise a `MESSAGE NOT UNDERSTOOD` error will
      be raised', ->
    # how do we make sure this is honored?
    # should we add pre conditions to specific roles? a role might need to expect the object to which it is bound to
    # have a specific interface
  )
)
