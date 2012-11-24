chai = require('chai')
expect = chai.expect

DataManager=require('../server/data-manager')

describe 'PointlessCharacterCounter', () ->
  describe 'DataManager', () ->
    dm = new DataManager
    it 'should start with an empty object', () ->
    	expect(dm.get()).to.be.an 'object'
    	expect(dm.get()).to.deep.equal({})
    it 'should allow you to add characters', () ->
    	dm.add "babba"
    	expect(dm.get()).to.deep.equal({"a":2,"b":3})
    it 'should only accept alpha-numeric characters', () ->
    	dm.add "ba * ( 1"
    	expect(dm.get()).to.deep.equal({"a":3,"b":4,"1":1})

