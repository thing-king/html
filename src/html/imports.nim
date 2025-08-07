# import schema
# import cacher
# import macro_utils
# cacheSchema "thing/web/html/cache/html_imports_schema_cache.nim", "web/html/cache/html_imports_schema_cache.nim":
#   fromSchema "web/html/schemas/elements.schema.json", "HTMLElements"
# cacheTypes "thing/web/html/cache/html_imports_cache.nim", "html_imports_schema_cache.nim":
#   const htmlData = staticRead("data/elements.json")
#   const htmlElements* = htmlData.fromJson(HTMLElements)

import cache/html_imports_schema_cache
import cache/html_imports_cache
export html_imports_schema_cache
export html_imports_cache

const JS_EVENTS* = [
  "onabort", "onafterprint", "onbeforeprint", "onbeforeunload", "onblur", 
  "oncanplay", "oncanplaythrough", "onchange", "onclick", "oncontextmenu", 
  "oncopy", "oncuechange", "oncut", "ondblclick", "ondrag", "ondragend", 
  "ondragenter", "ondragleave", "ondragover", "ondragstart", "ondrop", 
  "ondurationchange", "onemptied", "onended", "onerror", "onfocus", 
  "onhashchange", "oninput", "oninvalid", "onkeydown", "onkeypress", 
  "onkeyup", "onload", "onloadeddata", "onloadedmetadata", "onloadstart", 
  "onmessage", "onmousedown", "onmousemove", "onmouseout", "onmouseover", "onmouseenter", "onmouseleave",
  "onmouseup", "onmousewheel", "onoffline", "ononline", "onopen", "onpagehide", 
  "onpageshow", "onpaste", "onpause", "onplay", "onplaying", "onpopstate", 
  "onprogress", "onratechange", "onreset", "onresize", "onscroll", "onsearch", 
  "onseeked", "onseeking", "onselect", "onshow", "onstalled", "onsubmit", 
  "onsuspend", "ontimeupdate", "ontoggle", "onunload", "onvolumechange", 
  "onwaiting", "onwheel"
]