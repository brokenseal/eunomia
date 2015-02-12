expect = require("chai").expect
eunomia = require("../src/eunomia")

hasRole = (actor, role)->
  return actor.role is role


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
        expect(hasRole(actors.potatoThrower, roles.potatoThrower)).to.be.true
        actors.potatoThrower.throw()
      eatPotatoes: (actors)->
        expect(hasRole(actors.potatoEater, roles.potatoEater)).to.be.true
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

  it('object is instantiated for each enactment of a use case for which it is responsible', ->
    # this one is part of the spec but does not apply here since, in this implementation, a context is not a class
  )

  it('needs to identify the objects that will participate in the use case at the start of a use case enactment', ->
    # a context automatically identifies actors by receiving them as the first argument
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

  it('but multiple roles can be bound to the same actor', ->
    potatoFestival = eunomia.context({
      potatoGrinder: eunomia.role({
        grindPotato: ->
          expect(@firstName).to.be.equal('Saul')
      })
      potatoSeller: eunomia.role({
        sellPotato: ->
          expect(@firstName).to.be.equal('Saul')
      })
    }, {
      potatoStuff: (actors)->
        actors.potatoGrinder.grindPotato()
        actors.potatoSeller.sellPotato()
    })

    saul = {firstName: 'Saul'}
    potatoFestival.potatoStuff({
      potatoGrinder: saul
      potatoSeller: saul
    })
  )

  it('methods run in the context of an actor that is selected by the context to play it for the current use case
          enactment.', ->
    potatoFestival = eunomia.context({
      potatoSeller: eunomia.role({
        sellPotato: ->
          expect(@firstName).to.be.equal('Saul')
          expect(@lastName).to.be.equal('MacCartney')
      })
    }, {
      potatoStuff: (actors)->
        actors.potatoSeller.sellPotato()
    })

    saul = {firstName: 'Saul', lastName: 'MacCartney'}
    potatoFestival.potatoStuff({
      potatoSeller: saul
    })
  )

  it('is cast anew on every use case enactment to an actor', ->
    roles = {
      potatoSeller: eunomia.role({
        sellPotato: ->
      })
    }
    potatoFestival = eunomia.context(roles, {
      potatoStuff: (actors)->
        expect(hasRole(actors.potatoSeller, roles.potatoSeller)).to.be.true
    })

    saul = {firstName: 'Saul', lastName: 'MacCartney'}
    expect(hasRole(saul, roles.potatoSeller)).to.be.false
    potatoFestival.potatoStuff({
      potatoSeller: saul
    })
    expect(hasRole(saul, roles.potatoSeller)).to.be.false
    potatoFestival.potatoStuff({
      potatoSeller: saul
    })
    expect(hasRole(saul, roles.potatoSeller)).to.be.false
  )

  it('is removed at the end of a use case enactment from the corresponding actor', ->
    roles = {
      potatoSeller: eunomia.role({
        sellPotato: ->
      })
    }
    potatoFestival = eunomia.context(roles, {
      potatoStuff: (actors)->
        expect(hasRole(actors.potatoSeller, roles.potatoSeller)).to.be.true
    })

    saul = {firstName: 'Saul', lastName: 'MacCartney'}
    expect(hasRole(saul, roles.potatoSeller)).to.be.false
    potatoFestival.potatoStuff({
      potatoSeller: saul
    })
    expect(hasRole(saul, roles.potatoSeller)).to.be.false
  )
  it('can only be bound to one actor', ->
    # there's nothing much to check here since a JSON object of entities passed in to a context cannot two equal
    # keys (well, they can but it's a programmer error)
  )
)
