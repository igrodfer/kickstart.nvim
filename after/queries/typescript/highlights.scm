; extends

; LSP classifies TypeScript method calls as generic `member` tokens with
; priority 125. Keep method calls distinct without recoloring properties.
((call_expression
  function: (member_expression
    property: (property_identifier) @function.method.call))
  (#set! priority 126))
