BaseComponent = require './BaseComponent'

{newLine} = require 'dc-util'

module.exports = exports = class List extends BaseComponent
  constructor: (children) ->
    super()
    @initChildren(children)
    @isList = true
    return

  createDom: ->
    if length=@children.length
      {parentNode, children} = @
      children[length-1].nextNode = @nextNode
      for child, i in children
        child.parentNode = parentNode

    node = []
    @node = node

    @childNodes = node

    node.parentNode = @parentNode

    @createChildrenDom()

    @firstNode = @childFirstNode

    @childrenNextNode = @nextNode

    @node

  updateDom: ->
    {children, parentNode, invalidIndexes} = @

    for index in invalidIndexes
      children[index].parentNode = parentNode

    @childrenNextNode = @nextNode
    @updateChildrenDom()

    # do not worry about Tag component
    # 1. it does not call List.updateDom
    # 2. setFirstNode will affect BaseComponent holder (including Tag)
    @firstNode = @childFirstNode

    @node

  # set parentNode and nextNode field for transformComponent and its offspring, till baseComponent
  setParentNode: (parentNode) ->
    if @parentNode != parentNode
      @parentNode = parentNode
      for child in @children
        child.setParentNode(parentNode)
    return

  setNextNode: (nextNode) ->
    @nextNode = nextNode

    {children} = @
    childrenLength = children.length
    if childrenLength
       children[childrenLength-1].setNextNode(nextNode)

    return

  markRemovingDom: (removing) ->
    if !removing || (@node and @node.parentNode)
      @removing = removing
      for child in @children
        child.markRemovingDom(removing)
    return

  removeDom: ->
    if @removing
      @removing = false
      @holder = null
      @node.parentNode = null
      @emit('removeDom')
      for child in @children
        child.removeDom()
    @

  removeNode: ->
    @node.parentNode = null
    for child in @children
      child.baseComponent.removeNode()
    return

  # Tag, Comment, Html, Text should have attached them self in advace
  # But if the children is valid, and the List Component has been removeDom before,
  # it must attachNode of all the children to the parentNode
  attachNode: () ->

    {children, parentNode, nextNode, node} = @

    # different parentNode, it was removeDom before !
    # attach it again
    if parentNode != @node.parentNode or  nextNode != node.nextNode
      node.parentNode = parentNode
      node.nextNode = nextNode

      if children.length

        {nextNode} = @
        index = children.length - 1
        children[index].nextNode = nextNode

        while index >= 0
          child = children[index]
          child.parentNode = parentNode

          {baseComponent} = child
          baseComponent.parentNode = parentNode
          baseComponent.nextNode = child.nextNode
          baseComponent.attachNode()

          if index
            children[index-1].nextNode = child.firstNode or child.nextNode
          #else null # meet the first children
          index--

      # else null # no children, do nothing

    # else null # both parentNode and nextNode does not change, do nothing

    @node

  clone: -> (new List((for child in @children then child.clone()))).copyEventListeners(@)

  toString: (indent=0, addNewLine) ->
    if !@children.length then newLine("<List/>", indent, addNewLine)
    else
      s = newLine("<List>", indent, addNewLine)
      for child in @children
        s += child.toString(indent+2, true)
      s += newLine('</List>', indent, true)

extend = require('extend')
ListMixin = require('./ListMixin')
extend(List.prototype, ListMixin)