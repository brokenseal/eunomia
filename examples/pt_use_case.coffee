eunomia = require("../../src/eunomia")
_ = require("underscore")


# this is a set of classes, roles and complex contexts used by tests
class Person
  constructor(@firstName, @lastName)


class Jenkins
  constructor(@url)


class Repository
  constructor(@name, @prs=[])->

  openPr: (commits, codeReviewer)->
    pr = PullRequest(commits, codeReviewer)
    @prs.push(pr)
    return pr

  mergePr: (pr) ->
    result = getRandomBool()

    if result
      pr.close()

    return result


class PullRequest
  constructor: (@commits, @codeReviewer)->
    @_isMerged = false

    @isMerged = () =>
      return @_isMerged

    @close = () =>
      @_isMerged = true


getRandomBool = ()->
  randint = parseInt(Math.random() * 10, 10)

  if randint > 5
    return false

  return true


roles = {
  merger: {
    canMergePullRequests: true
    runTests: () ->
    mergePr: (repository, pr)->
      return repository.mergePr(pr)
  }
  repository: _.extend({}, Repository.prototype)
  builder: {
    buildPr: getRandomBool
  }
  CEO: {
    canHire: true
    respondToEmail: () ->
  }
  developer: {
    canCode: true
    code: () ->
      return [1, 2, 3, 4, 5, 6]

    openPr: (repository, listOfCommits, codeReviewer) ->
      return repository.openPr(listOfCommits, codeReviewer)

    fixPr: (pr) ->
      return pr

    fixPrConflicts: (repository, pr)->
      return pr
  }
  codeReviewer: {
    canCodeReview: true
    codeReview: getRandomBool
  }
  tester: {
    canTest: true
    testPr: getRandomBool
  }
}


prUseCase = eunomia.context(
# a short description of the context
###
  Pull Request use case
  This context describes the workflow of a developer opening a pull request on a remote repository and the process
  and people involved
###
  # an object describing roles that entities will play inside of this context
  # during the setup phase, the context object will manage the mapping between the given entities to the roles
  # this way we are sure that any given entity has the correct role, therefore becoming an actor
  # furthermore, to avoid polluting the entity objects passed in and therefore consolidating the idea that the
  # context is an isolated environment, we create an actor having as prototype the entity itself, then applying
  # the various roles to actor
  roles,

  # the use case, a function describing interaction between actors; a function well describes an isolated running
  # environment and it must not maintain any state, it needs to be an enclosed, isolated environment
  # that's where the action is
  # the returning value of eunomia.context will be a wrapper of this function

  # the shortcomings of a class based approach to contexts is that they maintain a state which most likely won't be
  # valid after a first run

  # I think it would be nice, but I'm not 100% sure if it's convenient or feasible, to have contexts as deterministic
  # functions
  (actors) ->
  # interaction time! explain interactions between actors through code
  pr = actors.developer.openPr(actors.repository, actors.commits, actors.codeReviewer)

  # the following processes can potentially be split into multiple, concurrent use cases
  # to simplify operations, this code assumes that people can accomplish their tasks instantaneously and will also
  # assume that operations must be done sequentially and not at the same time

  # build process
  while 1
    if actors.builder.buildPr(actors.repository, pr)
      break
    pr = actors.developer.fixPr(pr)

  # code review process
  while 1
    if actors.codeReviewer.codeReview(pr)
      break
    pr = actors.developer.fixPr(pr)

  # human testing process
  while 1
    if actors.tester.testPr(pr)
      break
    pr = actors.developer.fixPr(pr)

  actors.merger.mergePr(actors.repository, pr)

  return pr
  ###
    Example usage:

    pr = useCases.prUseCase({
      # entities given to the context to be turned into actors
      # there needs to be a direct mapping one to one to roles with this object
      repository: Repository('farmforce')
      developer: Person('Davide', 'Callegari')
      tester: Person('Namrata', 'Dharmani')
      merger: Person('Marcos', 'Diez')
      codeReviewer: Person('Bartosz', 'Bekier')
      builder: Jenkins('http://my-awesome-jenkins-installation.com')

      # in this case, no role will be assigned to the "commits" data and that's ok since it is a passive actor in this
      # context
      commits: [1, 2, 3, 4, 5, 6, 7]
    })
  ###
)

# should we allow contexts to extend other contexts?
# the shortcoming of a functional approach to contexts, compared to a class based approach, is that it's harder to
# inherit from other contexts and change only a small part of the process
# maybe this can be improved by making it possible to define multiple, smaller steps, instead of a single step
# or by simply using multiple contexts
farmforcePrUseCase = eunomia.context('Farmforce special PR use case', {
  merger: _.extend(roles.merger, {hasMergerHammer: true})
}).extends(prUseCase)


# work in progress
#ptUseCase = eunomia.context(_.pick(roles, 'developer', 'tester', 'merger'), (actors) ->
###
  Pivotal Tracker story life cycle
###
#  # inside a use case you can use another use case
#  pr = prUseCase({
#    # initialize objects used inside this context/use case
#    # this will represent the state of the context object
#    repository: Repository('farmforce')
#    developer: Person('Davide', 'Callegari')
#    testers: [Person('Namrata', 'Dharmani'), Person('Saurav', 'Batti')]
#    merger: Person('Marcos', 'Diez')
#  })
#)

exports.prUseCase = prUseCase
#exports.ptUseCase = ptUseCase
exports.roles = roles
