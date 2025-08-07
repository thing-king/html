import strutils, tables, options

import types



proc `==`*(a: HTMLNode, b: HTMLNode): bool =
  ## Compare two HTMLNodes
  if a.kind != b.kind:
    return false
  
  case a.kind
  of htmlnkText:
    return a.text == b.text
  of htmlnkElement:
    if a.tag != b.tag:
      return false
    
    if a.attributes != b.attributes:
      return false
    
    return true


proc treeRepr*(node: HTMLNode, ident: int = 0): string =
  ## Convert an HTMLNode to a tree representation
  var indent = "    ".repeat(ident)
  case node.kind
  of htmlnkText:
    result = indent & "[Text]: " & node.text
  of htmlnkElement:
    result = indent & "[" & node.tag & "]: "
    for key, value in node.attributes:
      if value == "":
        continue
      result &= key & "=\"" & value & "\" "
    
    result &= "\n"
    
    for child in node.children:
      result &= treeRepr(child, ident + 1) & "\n"
    result &= indent & "[/" & node.tag & "]"
proc treeRepr*(html: HTML): string =
  ## Convert a sequence of HTMLNodes to a tree representation
  result = ""
  for node in html:
    result &= treeRepr(node) & "\n"


proc `$`*(node: HTMLNode): string =
  ## Convert an HTMLNode to its string representation
  case node.kind
  of htmlnkText:
    result = node.text
  of htmlnkElement:
    result = "<" & node.tag
    
    for key, value in node.attributes:
      if value == "":
        continue
      result &= " " & key & "=\"" & value & "\""
    
    result &= ">"
    
    for child in node.children:
      result &= $child
    
    result &= "</" & node.tag & ">"
proc `$`*(nodes: seq[HTMLNode]): string =
  ## Convert a sequence of HTMLNodes to a string
  result = ""
  for node in nodes:
    result &= $node
proc asHTMLString*(html: HTML): string =
  return $html
proc toHTMLString*(html: HTML): string =
  return html.asHTMLString


proc walk*(body: HTML, prc: proc(node: HTMLNode): Option[HTMLNode] {.gcsafe.}): HTML {.gcsafe.} =
  # recursively walk through the HTML tree
  for node in body:
    var newNode = prc(node)
    if newNode.isSome:
      if newNode.get.kind == htmlnkElement:
        newNode.get.children = walk(node.children, prc)
      result.add newNode.get

type
  HTMLNodeFilter* = proc(node: HTMLNode): bool
proc filterNode*(node: HTMLNode, shouldExclude: HTMLNodeFilter): HTMLNode
proc filter*(html: HTML, shouldExclude: HTMLNodeFilter): HTML =
  result = @[]
  for node in html:
    if node.isNil:
      continue
    let filteredNode = filterNode(node, shouldExclude)
    if not filteredNode.isNil:
      result.add(filteredNode)

proc filterNode*(node: HTMLNode, shouldExclude: HTMLNodeFilter): HTMLNode =
  if shouldExclude(node):
    return nil
  
  case node.kind:
  of htmlnkText:
    # Create a copy of the text node
    result = HTMLNode(
      kind: htmlnkText,
      elementId: node.elementId,
      text: node.text
    )
  of htmlnkElement:
    # Create a copy of the element node
    result = HTMLNode(
      kind: htmlnkElement,
      elementId: node.elementId,
      tag: node.tag,
      attributes: node.attributes, # Reference copy is fine for attributes
      children: @[]
    )
    
    # Filter and add children
    for child in node.children:
      if child.isNil:
        continue
      let filteredChild = filterNode(child, shouldExclude)
      if not filteredChild.isNil:
        result.children.add(filteredChild)