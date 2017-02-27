xquery version "3.1";
(:~
: <h1>Get the activities based on a list of identifiers.</h1>
:)

import module namespace ids = "http://iati.me/map/ids" at "../lib/identifiers.xqm";
declare variable $file external;
declare option output:method 'text';

(: Find activities upstream :)

let $ids := ids:activities-from-files($file)

return concat(
"# Seeds:&#xa;&#xa;",
string-join($ids("seeds"), "&#xa;"),
"&#xa;&#xa;# Upstream:&#xa;&#xa;",
string-join($ids("upstream"), "&#xa;"),
"&#xa;&#xa;# Downstream:&#xa;&#xa;",
string-join($ids("downstream"), "&#xa;")
)
