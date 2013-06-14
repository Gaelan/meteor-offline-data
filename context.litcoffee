    class Context

      constructor: (@entry, @parentContext) ->

      add: (entry) ->
        return new Context(entry, this)

      toArray: ->
        array = []
        context = this
        while context?
          entry = context.entry
          if entry?
            array.push(entry)
          context = context.parentContext
        return array.reverse()


    contextVar = new Meteor.EnvironmentVariable()


    getContext = ->
      context = contextVar.get()
      if context?
        context.toArray()
      else
        []


    withContext = (entry, fn) ->
      if typeof fn isnt 'function'
        throw new Error "withContext: fn arg is not a function: #{fn}"
      context = new Context(entry, contextVar.get())
      return contextVar.withValue(context, fn)


    resetContext = (fn) ->
      contextVar.withValue(null, fn)


    (@awwx or= {}).Context = {
      getContext
      resetContext
      withContext
    }
