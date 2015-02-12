var global = Function("return this;")();
/*!
  * Ender: open module JavaScript framework (client-lib)
  * copyright Dustin Diaz & Jacob Thornton 2011 (@ded @fat)
  * http://ender.no.de
  * License MIT
  */
!function (context) {

  // a global object for node.js module compatiblity
  // ============================================

  context['global'] = context

  // Implements simple module system
  // losely based on CommonJS Modules spec v1.1.1
  // ============================================

  var modules = {}
    , old = context.$

  function require (identifier) {
    // modules can be required from ender's build system, or found on the window
    var module = modules[identifier] || window[identifier]
    if (!module) throw new Error("Requested module '" + identifier + "' has not been defined.")
    return module
  }

  function provide (name, what) {
    return (modules[name] = what)
  }

  context['provide'] = provide
  context['require'] = require

  function aug(o, o2) {
    for (var k in o2) k != 'noConflict' && k != '_VERSION' && (o[k] = o2[k])
    return o
  }

  function boosh(s, r, els) {
    // string || node || nodelist || window
    if (typeof s == 'string' || s.nodeName || (s.length && 'item' in s) || s == window) {
      els = ender._select(s, r)
      els.selector = s
    } else els = isFinite(s.length) ? s : [s]
    return aug(els, boosh)
  }

  function ender(s, r) {
    return boosh(s, r)
  }

  aug(ender, {
      _VERSION: '0.3.6'
    , fn: boosh // for easy compat to jQuery plugins
    , ender: function (o, chain) {
        aug(chain ? boosh : ender, o)
      }
    , _select: function (s, r) {
        return (r || document).querySelectorAll(s)
      }
  })

  aug(boosh, {
    forEach: function (fn, scope, i) {
      // opt out of native forEach so we can intentionally call our own scope
      // defaulting to the current item and be able to return self
      for (i = 0, l = this.length; i < l; ++i) i in this && fn.call(scope || this[i], this[i], i, this)
      // return self for chaining
      return this
    },
    $: ender // handy reference to self
  })

  ender.noConflict = function () {
    context.$ = old
    return this
  }

  if (typeof module !== 'undefined' && module.exports) module.exports = ender
  // use subscript notation as extern for Closure compilation
  context['ender'] = context['$'] = context['ender'] || ender

}(this);
// pakmanager:eunomia
(function (context) {
  
  var module = { exports: {} }, exports = module.exports
    , $ = require("ender")
    ;
  
  !function t(n,e,r){function i(c,f){if(!e[c]){if(!n[c]){var a="function"==typeof require&&require;if(!f&&a)return a(c,!0);if(o)return o(c,!0);throw new Error("Cannot find module '"+c+"'")}var s=e[c]={exports:{}};n[c][0].call(s.exports,function(t){var e=n[c][1][t];return i(e?e:t)},s,s.exports,t,n,e,r)}return e[c].exports}for(var o="function"==typeof require&&require,c=0;c<r.length;c++)i(r[c]);return i}({1:[function(t,n,e){(function(){var t,n,r;n=function(){function n(t,n){this.validateSpec(t),this.spec=t,this.entityInterface=n}return n.prototype.validateSpec=function(t){var n,e;e=[];for(n in t){if(!(t[n]instanceof Function))throw new Error("Given spec is not accepted");e.push(void 0)}return e},n.prototype.validateInterfaceAgainst=function(t){var n,e,r,i;if(this.entityInterface){i=[];for(e in this.entityInterface)if(r=t[e],n=this.entityInterface[e],!(r instanceof n||toString.call(r)==="[object "+n.name+"]"))throw new Error("Given entity does not comply to the role's needed interface, attribute missing: `"+e+"` of type "+this.entityInterface[e]);return i}},n.prototype.applyTo=function(n){return this.validateInterfaceAgainst(n),new t(this,n)},n}(),t=function(){function t(t,n){var e;this.entity=n,this.role=t;for(e in this.role.spec)this[e]=this.role.spec[e].bind(this.entity)}return t}(),r=function(t,n){return function(e){var r,i;r={};for(i in e)r[i]=t[i].applyTo(e[i]);return n.call(null,r)}},e.context=function(t,e){var i,o;for(i in t)if(!(t[i]instanceof n))throw new Error("Roles can only be instances of Role");if(0===Object.keys(e).length)throw new Error("Context must be able to enact at least one use case");o={};for(i in e)o[i]=r(t,e[i]);return o},e.role=function(t,e){return new n(t,e)}}).call(this)},{}]},{},[1]);
  provide("eunomia", module.exports);
}(global));