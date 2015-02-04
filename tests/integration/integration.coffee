assert = require("assert")
eunomia = _ = require("../../src/eunomia")
useCases = _ = require("./use_cases")


assertHasRole (object, role) ->
  if !_.hasRole(object, role)
    assert(false, 'Object ' + object + ' does not have role ' + role)


assertDoesNotHaveRole (object, role) ->
  if _.hasRole(object, role)
    assert(false, 'Object ' + object + ' has role ' + role)


describe('Roles', ->
  describe('inside a context', ->
    # roles only make sense inside a context, therefore can only be given (and removed) by a context object

    it('can be applied to any object', ->
      _.context('Test roles', [useCases.roles.developer, useCases.roles.projectManager], (contextObject) ->
        marcos = Person('Marcos', 'Diez')

        contextObject.giveRoles(
          useCases.roles.projectManager,
          # last role takes precedence to the others
          useCases.roles.developer
        ).to(marcos)

        assertHasRole(marcos, useCases.roles.projectManager)
        assertHasRole(marcos, useCases.roles.developer)
      )
    )

    it('can be removed', ->
      _.context('Test roles', [useCases.roles.developer, useCases.roles.projectManager], (contextObject) ->
        marcos = Person('Marcos', 'Diez')

        contextObject.giveRoles(
          useCases.roles.projectManager,
          useCases.roles.developer
        ).to(marcos)

        contextObject.removeRoles(useCases.roles.developer).to(marcos)

        assertDoesNotHaveRole(marcos, useCases.roles.developer)
        assertHasRole(marcos, useCases.roles.projectManager)
      )
    )
  )

  describe('A context', ->
    it('needs to describe a use case', ->
      pr = useCases.prUseCase({
        # initialize objects used inside this context/use case
        # this will represent the state of the context object
        repository: Repository('farmforce')
        developer: Person('Davide', 'Callegari')
        tester: Person('Namrata', 'Dharmani')
        merger: Person('Marcos', 'Diez')
        reviewer: Person('Bartosz', 'Bekier')
      }, {
        commits: [1, 2, 3, 4, 5, 6, 7]
      })
      assert(pr.isMerged(), 'PR not merged! Something went wrong')
    )

    it('does not accept roles not defined during initialization', ()->
      _.context('Test use case', [useCases.roles.developer], (contextObject)->

      )
    )
  )
)
