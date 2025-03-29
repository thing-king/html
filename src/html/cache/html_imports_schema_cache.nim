import tables


## HTMLElements

type
  HTMLElementsValueAttributesValue* = object
    deprecated*: bool
    experimental*: bool

type
  HTMLElementsValueAttributes* = Table[string, HTMLElementsValueAttributesValue]
type
  HTMLElementsValue* = object
    deprecated*: bool
    experimental*: bool
    attributes*: HTMLElementsValueAttributes

type
  HTMLElements* = Table[string, HTMLElementsValue]