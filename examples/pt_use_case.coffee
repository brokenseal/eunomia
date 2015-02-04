# this is a set of classes, roles and complex contexts used by tests
class Person
  constructor(@firstName, @lastName)


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
  repository: Object.create(Repository.prototype)
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

# work in progress
#ptUseCase = _.context('Pivotal Tracker story life cycle', [roles.developer, roles.tester, roles.merger], (contextObject, state) ->
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

prUseCase = _.context(
  # short description of this use case, for a more long description add comments in the code at the beginning of the
  # context
  # optional?
  'PR use case',

  # a list of roles that actors will play inside of this context
  [roles.repository, roles.developer, roles.tester, roles.merger, roles.codeReviewer, roles.builder],

  # a function describing interaction between actors, that's where the action is
  (contextObject, actors, state) ->
  # initialization time, give roles to actors
  # should this be automated? not sure, it might be an overkill; a solution would be to give actors to the context in
  # the right sequence
  # e.g. prUseCase(Person('Dev'), Person('Tester'), Person('Manager'), Person('Reviewer'))
  # this way we could have an automatic and direct mapping of roles with actors at initialization time, it might work
  # the problem with this approach is that I might have more actors, already having the correct role or not needing a
  # particular role, they might be already smart enough
  # in the case they are smart enough though we can use the expected role as an interface, thus forcing structural
  # typing on the already smart enough object
  contextObject.giveRole(roles.tester).to(actors.tester)
  contextObject.giveRole(roles.developer).to(actors.developer)
  contextObject.giveRole(roles.merger).to(actors.merger)
  contextObject.giveRole(roles.codeReviewer).to(actors.codeReviewer)

  # interaction time! explain interactions between actors through code
  pr = actors.developer.openPr(actors.repository, state.commits, actors.codeReviewer)

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

  # the use case needs to be an enclosed environment, the actors need to be stripped of any of the given roles
  # if no role was given to a particular actor then no strip is necessary, actors might already have a particular role
  # endorsed from an external context
  return pr
  # implementation detail: at this point the context wrapper should clean up the roles added during this use case, it's
  # better if it is an automated process, handled by the context creator
  # actually, as a second thought, it might not be necessary if assigning a role will be done on a new object having as
  # prototype the passed in actor, since the original actor will be left untouched and we would be using a new one

  ###
    Example usage:

    pr = useCases.prUseCase({
      # initialize objects used inside this context/use case
      # this will represent the state of the context object
      repository: Repository('farmforce')
      developer: Person('Davide', 'Callegari')
      tester: Person('Namrata', 'Dharmani')
      merger: Person('Marcos', 'Diez')
      codeReviewer: Person('Bartosz', 'Bekier')
      jenkins: {}
    }, {
      commits: [1, 2, 3, 4, 5, 6, 7]
    })
  ###
)

exports.prUseCase = prUseCase
exports.ptUseCase = ptUseCase
exports.roles = roles
