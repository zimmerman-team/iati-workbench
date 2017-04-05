(:~
: <h1>Transform CSV into CSV-XML.</h1>
:)

declare variable $file external;

let $text := file:read-text($file)
return csv:parse($text, map { 'header': true(), 'format': 'attributes' })
