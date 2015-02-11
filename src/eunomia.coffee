# TODO: instanceof is not reliable, use something else

class Role
  constructor: (spec, entityInterface)->
    # spec represents the role's methods, need to contain only methods and no state
    @validateSpec(spec)
    @spec = spec
    # entityInterface is a non mandatory interface to which entities need to comply to
    @entityInterface = entityInterface

  validateSpec: (spec)->
    # defined spec must contain only methods
    for name of spec
      if not (spec[name] instanceof Function)
        throw new Error('Given spec is not accepted')

  validateInterfaceAgainst: (entity)->
    if @entityInterface
      # check that the given entity complies to the previously given interface
      for name of @entityInterface
        if not (entity[name] instanceof @entityInterface[name])
          throw new Error("Given entity does not comply to the role's needed interface,
                          attribute missing: `" + name + "` of type " + @entityInterface[name])

  applyTo: (entity)->
    @validateInterfaceAgainst(entity)
    return new Actor(@, entity)


class Actor
  # an actor is a role proxy, it exposes the same interface as the role specification but will apply its methods to the
  # given entity
  # this way, the original entity object is left pristine and can easily impersonate other roles at the same time
  # without other roles interfering with each other
  constructor: (role, entity)->
    @entity = entity
    @role = role

    for name of @role.spec
      @[name] = @role.spec[name].bind(@entity)

useCaseFactory = (roles, method)->
  return (entities)->
    # create the actors the use case will manage
    actors = {}
    for name of entities
      actors[name] = roles[name].applyTo(entities[name])

    return method.call(null, actors)

exports.context = (roles, useCases)->
  # validate roles
  for name of roles
    if not (roles[name] instanceof Role)
      throw new Error("Roles can only be instances of Role")

  if Object.keys(useCases).length == 0
    throw new Error('Context must be able to enact at least one use case')

  useCasesProxies = {}
  for name of useCases
    useCasesProxies[name] = useCaseFactory(roles, useCases[name])

  return useCasesProxies

exports.role = (roleSpec, entityInterface)->
  return new Role(roleSpec, entityInterface)

exports.hasRole = (actor, role)->
  return actor.role is role
