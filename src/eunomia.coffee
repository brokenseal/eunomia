_ = require('lodash')

# an actor factory is responsible to create proxies which encapsulate a role specification, exposing only the role
# specific methods and attributes and apply those methods to the given entity object
# this enforces a separation of logic and makes 99% sure the original role object is not polluted by other contexts
# unfortunately assigning the role object to a prototype is not enough because it would be impossible to execute
# methods using the actor as context of the function
actorFactory = (roleObject, entityObject)->
  # a roleObject is the specification describing a role
  # an actor is the object to which the role will be assigned
  actor = {}
  for name of roleObject
    if _.isFunction(roleObject[name])
      actor[name] = roleObject[name].bind(entityObject)
    else
      actor[name] = roleObject[name]

  return actor


useCaseFactory = (useCaseFunction, roles)->
  return (entities)->
    # the given entities object need to match the previously given roles for the context
    actors = {}
    # assign roles to entities, making them actor
    # this kind of assignment will also make sure that a given entity can impersonate multiple roles but any single
    # role can only be given to one actor
    # e.g. {waiter: obj1, manager: obj2, mother: obj1}
    for name of entities
      actors[name] = actorFactory(roles[name], entities[name])

    useCaseFunction(actors)

exports.context = (roles, useCases)->
  if Object.keys(useCases || {}).length == 0
    throw new Error('A context must specify at least one use case')

  internalUseCases = {}
  for name of useCases
    internalUseCases[name] = useCaseFactory(useCases[name], roles)

  return internalUseCases

exports.hasRole = (actor, role)->
  for name of role
    if not actor.hasOwnProperty(name)
      return false
  return true
