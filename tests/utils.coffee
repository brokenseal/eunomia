#eunomia = require("../../src/eunomia")


exports.assertHasRole = (object, role) ->
  if not eunomia.hasRole(object, role)
    assert(false, 'Object ' + object + ' does not have role ' + role)


exports.assertDoesNotHaveRole = (object, role) ->
  if eunomia.hasRole(object, role)
    assert(false, 'Object ' + object + ' has role ' + role)
