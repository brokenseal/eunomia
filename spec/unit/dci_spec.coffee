expect = require("chai").expect
eunomia = require("../../src/eunomia")
testUtils = require("../utils")


describe('A context', ->
  it('represents at least one use case', ->
    expect(->
      eunomia.context({}, {})
    ).to.throw(Error)
    expect(->
      eunomia.context({}, {throwPotatoes: ->})
    ).to.not.throw(Error)
  )

  it('can represent more than one use case', ->
    context = null

    expect(->
      context = eunomia.context({}, {
        throwPotatoes: ->
        eatPotatoes: ->
      })
    ).to.not.throw(Error)

    expect(context.throwPotatoes).to.be.a.function
    expect(context.eatPotatoes).to.be.a.function
  )

  it('is responsible to assign roles to actors', ->
    roles = {
      potatoEater: eunomia.role({
        eat: (potato)->
      }),
      potatoThrower: eunomia.role({
        throw: (potato)->
      })
    }

    potatoFestival = eunomia.context(roles, {
      throwPotatoes: (actors)->
        expect(eunomia.hasRole(actors.potatoThrower, roles.potatoThrower)).to.be.true
        actors.potatoThrower.throw()
      eatPotatoes: (actors)->
        expect(eunomia.hasRole(actors.potatoEater, roles.potatoEater)).to.be.true
        actors.potatoEater.eat()
    })

    paul = {firstName: 'Paul'}

    potatoFestival.throwPotatoes({
      potatoThrower: paul
    })

    potatoFestival.eatPotatoes({
      potatoEater: paul
    })
  )
  it.skip('object is instantiated for each enactment of a use case for which it is responsible', ->
    # not sure if this applies here
  )

  it.skip('needs to identify the objects that will participate in the use case at the start of a use case enactment', ->
    # again, not sure what this means, a context should receive the entities, not look for them by itself
  )
)

describe('A role', ->
  it('needs to be stateless', ->
    # I'm not 100% sure this is the best way to make sure a role is stateless
    # in fact, I'm not sure if it's at all possible, at least not in Javascript
    expect(->
      eunomia.role({
        potatoes: [1, 2, 3, 4]
        throw: (potato)->
      })
    ).to.throw(Error)
    expect(->
      eunomia.role({
        potatoes: 3
        throw: (potato)->
      })
    ).to.throw(Error)
    expect(->
      eunomia.role({
        throw: (potato)->
      })
    ).to.not.throw(Error)
  )

  it('infers an interface to an actor', ->
    # at the moment, the current code does not infer methods to the actor but rather creates a proxy object which will
    # execute methods in the context of the actor itself
    potatoFestival = eunomia.context({
      potatoLover: eunomia.role({
        cookPotatoes: ->
        eatPotatoes: ->
      })
    }, {
      cookingCompetition: (actors)->
        expect(actors.potatoLover.cookPotatoes).to.be.a.function
        expect(actors.potatoLover.eatPotatoes).to.be.a.function
        expect(actors.potatoLover.smashPotatoes).to.not.be.a.function
    })
    jenny = {firstName: 'Jennifer'}
    potatoFestival.cookingCompetition({
      potatoLover: jenny
    })
  )

  it('can only be bound to objects to which it make sense to bind it, otherwise a `MESSAGE NOT UNDERSTOOD` error
          will be raised', ->
    potatoSmasher = eunomia.role({
      smashPotato: ->
        # here, the role methods will access attributes and methods from the entity
        @kissPotato()

        getPotatoFromStash = @potatoes.pop()
        # and now, smash it!
    }, {
      hasPotatoes: Boolean
      lovesPotatoes: Boolean
      potatoes: Array
      kissPotato: Function
    })

    potatoFestival = eunomia.context({
      potatoSmasher: potatoSmasher
    }, {
      smashingCompetition: (actors)->
        actors.potatoSmasher.smashPotato()
    })

    james = {firstName: 'James'}
    donald = {
      firstName: 'Donald'
      lovesPotatoes: new Boolean(true)  # ok, we have a problem with instanceof...
      hasPotatoes: new Boolean(true)
      potatoes: [1, 2, 3, 4, 5]
      kissPotato: ->
    }

    # expect error if given a wrong entity
    expect(->
      potatoFestival.smashingCompetition({
        potatoSmasher: james
      })
    ).to.throw(Error)

    # expect success if given a correct entity
    potatoFestival.smashingCompetition({
      potatoSmasher: donald
    })
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
