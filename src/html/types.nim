import tables

type HTMLNodeKind* = enum
  htmlnkElement,
  htmlnkText

type HTMLNode* = object
  # TODO: seperate this into elementId and elementIndex
  elementId*: string

  case kind*: HTMLNodeKind
  of htmlnkElement:
    tag*: string
    attributes*: Table[string, string] = initTable[string, string]()
    children*: seq[HTMLNode] = @[]
  of htmlnkText:
    text*: string

type
  HTML* = seq[HTMLNode]