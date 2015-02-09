expect = require("chai").expect
eunomia = require("../../src/eunomia")
testUtils = require("../utils")


describe('A context', ->
  it.skip('object is instantiated for each enactment of a use case for which it is responsible', ->
    # not sure if this applies here
  )

  it.skip('needs to identify the objects that will participate in the use case at the start of a use case enactment', ->
    # again, not sure what this means, a context should receive the entities, not look for them by itself
  )

  it.skip('represents at least one use case', ->
  )

  it.skip('can represent more than one use case', ->
  )

  it.skip('is responsible to assign roles to actors', ->
  )
)

describe('A role', ->
  it.skip('needs to be stateless', ->
    # how do we ensure that a role is stateless? should we accept roles only with methods and not attributes?
    # we could use a singleton with private set of variable for internal use to a role if necessary
  )

  it.skip('infers an interface to an actor', ->
    # at the moment, the current code does not infer methods to the actor but rather create a proxy object which will
    # execute methods in the context of the actor itself
  )

  it.skip('can only be bound to objects to which it make sense to bind it, otherwise a `MESSAGE NOT UNDERSTOOD` error
          will be raised', ->
    # the role could need the actor to which it will be bound to conform to a specific interface, therefore forcing a
    # structural type checking on actors to which it is applied to
  )

  it.skip('but multiple roles can be bound to the same actor', ->
  )

  it.skip('can only be bound to one actor', ->
  )

  it.skip('methods run in the context of an actor that is selected by the context to play it for the current use case
          enactment.', ->
  )

  it.skip('is cast anew on every use case enactment to an actor', ->
  )

  it.skip('is removed at the end of a use case enactment from the corresponding actor', ->
  )
)
