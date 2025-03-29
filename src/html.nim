import html/util
import html/types
import html/imports
export util
export types
export imports

import tables


# getElement
proc getElement*(name: string): HTMLElementsValue =
  if not htmlElements.hasKey(name):
    raise newException(ValueError, "Element not found: " & name)
  return htmlElements[name]

# getAttribute
proc getAttribute*(htmlElement: HTMLElementsValue, attributeName: string): HTMLElementsValueAttributesValue =
  if not htmlElement.attributes.hasKey(attributeName):
    raise newException(ValueError, "Attribute not found: " & attributeName)
  return htmlElement.attributes[attributeName]
proc getAttribute*(elementName: string, attributeName: string): HTMLElementsValueAttributesValue =
  if not htmlElements.hasKey(elementName):
    raise newException(ValueError, "Element not found: " & elementName)
  if not htmlElements[elementName].attributes.hasKey(attributeName):
    raise newException(ValueError, "Attribute not found: " & attributeName)
  return htmlElements[elementName].attributes[attributeName]

# getAttributes
proc getAttributes*(htmlElement: HTMLElementsValue): HTMLElementsValueAttributes =
  return htmlElement.attributes
proc getAttributes*(elementName: string): HTMLElementsValueAttributes =
  if not htmlElements.hasKey(elementName):
    raise newException(ValueError, "Element not found: " & elementName)
  return htmlElements[elementName].attributes

# isElement
proc isElement*(name: string): bool =
  return htmlElements.hasKey(name)

# isAttribute
proc isAttribute*(htmlElement: HTMLElementsValue, attributeName: string): bool =
  return htmlElement.attributes.hasKey(attributeName)
proc isAttribute*(elementName: string, attributeName: string): bool =
  if not htmlElements.hasKey(elementName):
    return false
  return htmlElements[elementName].isAttribute(attributeName)

# isDeprecated
proc isDeprecated*(htmlElement: HTMLElementsValue): bool =
  return htmlElement.deprecated
proc isDeprecated*(elementName: string): bool =
  if not htmlElements.hasKey(elementName):
    return false
  return htmlElements[elementName].isDeprecated
proc isDeprecated*(htmlElement: HTMLElementsValue, attributeName: string): bool =
  if not htmlElement.attributes.hasKey(attributeName):
    return false
  return htmlElement.attributes[attributeName].deprecated
proc isDeprecated*(elementName: string, attributeName: string): bool =
  if not htmlElements.hasKey(elementName):
    return false
  if not isAttribute(elementName, attributeName):
    return false
  return htmlElements[elementName].isDeprecated(attributeName)


# isExperimental
proc isExperimental*(htmlElement: HTMLElementsValue): bool =
  return htmlElement.experimental
proc isExperimental*(elementName: string): bool =
  if not htmlElements.hasKey(elementName):
    return false
  return htmlElements[elementName].isExperimental
proc isExperimental*(htmlElement: HTMLElementsValue, attributeName: string): bool =
  if not htmlElement.attributes.hasKey(attributeName):
    return false
  return htmlElement.attributes[attributeName].experimental
proc isExperimental*(elementName: string, attributeName: string): bool =
  if not htmlElements.hasKey(elementName):
    return false
  if not isAttribute(elementName, attributeName):
    return false
  return htmlElements[elementName].isExperimental(attributeName)