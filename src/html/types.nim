import tables
import jsony_plus

type HTMLNodeKind* = enum
  htmlnkElement,
  htmlnkText

type HTMLNode* = ref object of RootObj
  elementId*: string

  case kind*: HTMLNodeKind
  of htmlnkElement:
    tag*: string
    attributes*: TableRef[string, string] = newTable[string, string]()
    children*: seq[HTMLNode]
  of htmlnkText:
    text*: string

type
  HTML* = seq[HTMLNode]

proc dumpHook*(s: var string, v: HTMLNode) =
  if v.isNil:
    s.add "null"
    return
  
  s.add "{"
  
  # Always include elementId and kind
  s.add "\"elementId\":"
  s.dumpHook(v.elementId)
  s.add ","
  
  s.add "\"kind\":"
  s.dumpHook($v.kind)
  
  # Add fields based on the kind
  case v.kind
  of htmlnkElement:
    s.add ","
    s.add "\"tag\":"
    s.dumpHook(v.tag)
    s.add ","
    
    s.add "\"attributes\":"
    s.dumpHook(v.attributes)
    s.add ","
    
    s.add "\"children\":"
    s.dumpHook(v.children)
    
  of htmlnkText:
    s.add ","
    s.add "\"text\":"
    s.dumpHook(v.text)
  
  s.add "}"

import json
proc parseHook*(s: string, i: var int, v: var HTMLNode) =
  # Handle null case
  if i < s.len and s[i] == 'n':
    var temp: string
    parseHook(s, i, temp)
    if temp == "null":
      v = nil
      return
  
  # Skip opening brace and whitespace
  if i < s.len and s[i] == '{':
    inc i
  
  # Initialize the ref object
  v = new(HTMLNode)
  
  # Parse as a generic object first to get all fields
  var obj: JsonNode
  dec i  # Go back to parse the whole object
  parseHook(s, i, obj)
  
  # Extract fields from JsonNode
  if obj.hasKey("elementId"):
    v.elementId = obj["elementId"].getStr()
  
  if obj.hasKey("kind"):
    let kindStr = obj["kind"].getStr()
    case kindStr:
    of "htmlnkElement":
      v.kind = htmlnkElement
    of "htmlnkText":
      v.kind = htmlnkText
    else:
      raise newException(ValueError, "Invalid HTMLNodeKind: " & kindStr)
  
  # Parse variant-specific fields
  case v.kind:
  of htmlnkElement:
    if obj.hasKey("tag"):
      v.tag = obj["tag"].getStr()
    
    if obj.hasKey("attributes"):
      v.attributes = newTable[string, string]()
      for key, val in obj["attributes"]:
        v.attributes[key] = val.getStr()
    else:
      v.attributes = newTable[string, string]()
    
    if obj.hasKey("children"):
      v.children = @[]
      for childJson in obj["children"]:
        var childStr = $childJson
        var childIndex = 0
        var childNode: HTMLNode
        parseHook(childStr, childIndex, childNode)
        v.children.add(childNode)
        
  of htmlnkText:
    if obj.hasKey("text"):
      v.text = obj["text"].getStr()

# echo fromJson("[]", HTML).repr