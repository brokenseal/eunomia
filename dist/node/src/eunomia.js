var Actor, MalformedRoleSpec, MessageNotUnderstood, Role, useCaseFactory,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  __hasProp = {}.hasOwnProperty;

Role = (function() {
  function Role(spec, entityInterface) {
    if (entityInterface == null) {
      entityInterface = null;
    }
    this.validateSpec(spec);
    this.spec = spec;
    this["interface"] = entityInterface;
  }

  Role.prototype.validateSpec = function(spec) {
    var name, _results;
    _results = [];
    for (name in spec) {
      if (!(spec[name] instanceof Function)) {
        throw new MalformedRoleSpec('Given spec is not accepted');
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  Role.prototype.validateInterfaceAgainst = function(entity) {
    var name, _results;
    if (this["interface"] === !null) {
      _results = [];
      for (name in this["interface"]) {
        if (!(this.spec[name] instanceof this["interface"][name])) {
          throw new MessageNotUnderstood("Given entity does not comply to the role's needed interface");
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    }
  };

  Role.prototype.applyTo = function(entity) {
    this.validateInterfaceAgainst(entity);
    return new Actor(this, entity);
  };

  return Role;

})();

Actor = (function() {
  function Actor(role, entity) {
    var name;
    this.entity = entity;
    this.role = role;
    for (name in this.role.spec) {
      console.log(name);
      this[name] = this.role.spec[name].bind(this.entity);
    }
  }

  return Actor;

})();

MessageNotUnderstood = (function(_super) {
  __extends(MessageNotUnderstood, _super);

  function MessageNotUnderstood() {
    return MessageNotUnderstood.__super__.constructor.apply(this, arguments);
  }

  return MessageNotUnderstood;

})(Error);

MalformedRoleSpec = (function(_super) {
  __extends(MalformedRoleSpec, _super);

  function MalformedRoleSpec() {
    return MalformedRoleSpec.__super__.constructor.apply(this, arguments);
  }

  return MalformedRoleSpec;

})(Error);

useCaseFactory = function(roles, method) {
  return function(entities) {
    var actors, name;
    actors = {};
    for (name in entities) {
      actors[name] = new Actor(roles[name], entities[name]);
    }
    return method.call(null, actors);
  };
};

exports.context = function(roles, useCases) {
  var name, useCasesProxies;
  for (name in roles) {
    if (!(roles[name] instanceof Role)) {
      throw new Error("Roles can only be instances of Role");
    }
  }
  if (Object.keys(useCases).length === 0) {
    throw new Error('Context must be able to enact at least one use case');
  }
  useCasesProxies = {};
  for (name in useCases) {
    useCasesProxies[name] = useCaseFactory(roles, useCases[name]);
  }
  return useCasesProxies;
};

exports.role = function(roleSpec, entityInterface) {
  return new Role(roleSpec, entityInterface);
};

exports.hasRole = function(actor, role) {
  return actor.role === role;
};

exports.exceptions = {
  MessageNotUnderstood: MessageNotUnderstood,
  MalformedRoleSpec: MalformedRoleSpec
};

//# sourceMappingURL=data:application/json;base64,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ZVJvb3QiOiIvc291cmNlLyIsInNvdXJjZXNDb250ZW50IjpbImNsYXNzIFJvbGVcbiAgY29uc3RydWN0b3I6IChzcGVjLCBlbnRpdHlJbnRlcmZhY2U9bnVsbCktPlxuICAgICMgc3BlYyByZXByZXNlbnRzIHRoZSByb2xlJ3MgbWV0aG9kcywgbmVlZCB0byBjb250YWluIG9ubHkgbWV0aG9kcyBhbmQgbm8gc3RhdGVcbiAgICBAdmFsaWRhdGVTcGVjKHNwZWMpXG4gICAgQHNwZWMgPSBzcGVjXG4gICAgIyBlbnRpdHlJbnRlcmZhY2UgaXMgYSBub24gbWFuZGF0b3J5IGludGVyZmFjZSB0byB3aGljaCBlbnRpdGllcyBuZWVkIHRvIGNvbXBseSB0b1xuICAgIEBpbnRlcmZhY2UgPSBlbnRpdHlJbnRlcmZhY2VcblxuICB2YWxpZGF0ZVNwZWM6IChzcGVjKS0+XG4gICAgIyBkZWZpbmVkIHNwZWMgbXVzdCBjb250YWluIG9ubHkgbWV0aG9kc1xuICAgIGZvciBuYW1lIG9mIHNwZWNcbiAgICAgIGlmIG5vdCAoc3BlY1tuYW1lXSBpbnN0YW5jZW9mIEZ1bmN0aW9uKVxuICAgICAgICB0aHJvdyBuZXcgTWFsZm9ybWVkUm9sZVNwZWMoJ0dpdmVuIHNwZWMgaXMgbm90IGFjY2VwdGVkJylcblxuICB2YWxpZGF0ZUludGVyZmFjZUFnYWluc3Q6IChlbnRpdHkpLT5cbiAgICBpZiBAaW50ZXJmYWNlIGlzIG5vdCBudWxsXG4gICAgICAjIGNoZWNrIHRoYXQgdGhlIGdpdmVuIGVudGl0eSBjb21wbGllcyB0byB0aGUgcHJldmlvdXNseSBnaXZlbiBpbnRlcmZhY2VcbiAgICAgIGZvciBuYW1lIG9mIEBpbnRlcmZhY2VcbiAgICAgICAgaWYgbm90IChAc3BlY1tuYW1lXSBpbnN0YW5jZW9mIEBpbnRlcmZhY2VbbmFtZV0pXG4gICAgICAgICAgdGhyb3cgbmV3IE1lc3NhZ2VOb3RVbmRlcnN0b29kKFwiR2l2ZW4gZW50aXR5IGRvZXMgbm90IGNvbXBseSB0byB0aGUgcm9sZSdzIG5lZWRlZCBpbnRlcmZhY2VcIilcblxuICBhcHBseVRvOiAoZW50aXR5KS0+XG4gICAgQHZhbGlkYXRlSW50ZXJmYWNlQWdhaW5zdChlbnRpdHkpXG4gICAgcmV0dXJuIG5ldyBBY3RvcihALCBlbnRpdHkpXG5cblxuY2xhc3MgQWN0b3JcbiAgIyBhbiBhY3RvciBpcyBhIHJvbGUgcHJveHksIGl0IGV4cG9zZXMgdGhlIHNhbWUgaW50ZXJmYWNlIGFzIHRoZSByb2xlIHNwZWNpZmljYXRpb24gYnV0IHdpbGwgYXBwbHkgaXRzIG1ldGhvZHMgdG8gdGhlXG4gICMgZ2l2ZW4gZW50aXR5XG4gICMgdGhpcyB3YXksIHRoZSBvcmlnaW5hbCBlbnRpdHkgb2JqZWN0IGlzIGxlZnQgcHJpc3RpbmUgYW5kIGNhbiBlYXNpbHkgaW1wZXJzb25hdGUgb3RoZXIgcm9sZXMgYXQgdGhlIHNhbWUgdGltZVxuICAjIHdpdGhvdXQgb3RoZXIgcm9sZXMgaW50ZXJmZXJpbmcgd2l0aCBlYWNoIG90aGVyXG4gIGNvbnN0cnVjdG9yOiAocm9sZSwgZW50aXR5KS0+XG4gICAgQGVudGl0eSA9IGVudGl0eVxuICAgIEByb2xlID0gcm9sZVxuXG4gICAgZm9yIG5hbWUgb2YgQHJvbGUuc3BlY1xuICAgICAgY29uc29sZS5sb2cobmFtZSlcbiAgICAgIEBbbmFtZV0gPSBAcm9sZS5zcGVjW25hbWVdLmJpbmQoQGVudGl0eSlcblxuXG5jbGFzcyBNZXNzYWdlTm90VW5kZXJzdG9vZCBleHRlbmRzIEVycm9yXG5jbGFzcyBNYWxmb3JtZWRSb2xlU3BlYyBleHRlbmRzIEVycm9yXG5cbnVzZUNhc2VGYWN0b3J5ID0gKHJvbGVzLCBtZXRob2QpLT5cbiAgcmV0dXJuIChlbnRpdGllcyktPlxuICAgICMgY3JlYXRlIHRoZSBhY3RvcnMgdGhlIHVzZSBjYXNlIHdpbGwgbWFuYWdlXG4gICAgYWN0b3JzID0ge31cbiAgICBmb3IgbmFtZSBvZiBlbnRpdGllc1xuICAgICAgYWN0b3JzW25hbWVdID0gbmV3IEFjdG9yKHJvbGVzW25hbWVdLCBlbnRpdGllc1tuYW1lXSlcblxuICAgIHJldHVybiBtZXRob2QuY2FsbChudWxsLCBhY3RvcnMpXG5cbmV4cG9ydHMuY29udGV4dCA9IChyb2xlcywgdXNlQ2FzZXMpLT5cbiAgIyB2YWxpZGF0ZSByb2xlc1xuICBmb3IgbmFtZSBvZiByb2xlc1xuICAgIGlmIG5vdCAocm9sZXNbbmFtZV0gaW5zdGFuY2VvZiBSb2xlKVxuICAgICAgdGhyb3cgbmV3IEVycm9yKFwiUm9sZXMgY2FuIG9ubHkgYmUgaW5zdGFuY2VzIG9mIFJvbGVcIilcblxuICBpZiBPYmplY3Qua2V5cyh1c2VDYXNlcykubGVuZ3RoID09IDBcbiAgICB0aHJvdyBuZXcgRXJyb3IoJ0NvbnRleHQgbXVzdCBiZSBhYmxlIHRvIGVuYWN0IGF0IGxlYXN0IG9uZSB1c2UgY2FzZScpXG5cbiAgdXNlQ2FzZXNQcm94aWVzID0ge31cbiAgZm9yIG5hbWUgb2YgdXNlQ2FzZXNcbiAgICB1c2VDYXNlc1Byb3hpZXNbbmFtZV0gPSB1c2VDYXNlRmFjdG9yeShyb2xlcywgdXNlQ2FzZXNbbmFtZV0pXG5cbiAgcmV0dXJuIHVzZUNhc2VzUHJveGllc1xuXG5leHBvcnRzLnJvbGUgPSAocm9sZVNwZWMsIGVudGl0eUludGVyZmFjZSktPlxuICByZXR1cm4gbmV3IFJvbGUocm9sZVNwZWMsIGVudGl0eUludGVyZmFjZSlcblxuZXhwb3J0cy5oYXNSb2xlID0gKGFjdG9yLCByb2xlKS0+XG4gIHJldHVybiBhY3Rvci5yb2xlIGlzIHJvbGVcblxuZXhwb3J0cy5leGNlcHRpb25zID0ge1xuICBNZXNzYWdlTm90VW5kZXJzdG9vZDogTWVzc2FnZU5vdFVuZGVyc3Rvb2RcbiAgTWFsZm9ybWVkUm9sZVNwZWM6IE1hbGZvcm1lZFJvbGVTcGVjXG59XG4iXX0=