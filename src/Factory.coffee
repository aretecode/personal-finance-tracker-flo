_ = require 'underscore'
uuid = require 'uuid'
dateFromAny = require('./Util/dateFromAny.coffee').dateFromAny
{Money} = require('./Money.coffee')
{Tag} = require('./Tag.coffee')
{Expense, Income} = require('./FinanceOperation.coffee')

# AbstractFinanceOperationFactory
class Factory 
  ### 
  @see {Money}
  @see {Income}
  @see {Expense}
  @TODO: if this fails, give back a payload http status code
  @TODO: add a constructor + chaining builder
  ###
  @createFrom: (opType, id, currency, amount, tags, createdAt = new Date(), description = "") =>
    c = dateFromAny(createdAt)
    id = uuid.v4() if id is null or id is undefined
    money = new Money(currency, amount)
    if opType is 'income'
      return new Income(id, money, tags, createdAt, description) 
    else if opType is 'expense'
      return new Expense(id, money, tags, createdAt, description) 

  @hydrateFrom: (opType, o, tags) ->
    c = new Date(o.created_at)
    return Factory.createFrom(
      opType, o.id, o.currency, o.amount, tags, c, o.description)

  @hydrateAllFrom: (opType, objs, tags) ->
    return objs.map (o) -> Factory.hydrateFrom(opType, o, tags)

  @income: (id, currency, amount, tags, createdAt = new Date, description = "") ->
    return Factory.createFrom('income', id, currency, amount, tags, createdAt, description)
  @expense: (id, currency, amount, tags, createdAt = new Date, description = "") ->
    return Factory.createFrom('expense', id, currency, amount, tags, createdAt, description)

module.exports.Factory = Factory