xquery version "3.1";
(:~
: <h1>Get the activities based on a list of identifiers.</h1>
:)

import module namespace ids = "http://iati.me/map/ids" at "../lib/identifiers.xqm";
declare variable $file external;
let $ids := ids:activities-from-files($file)

return element iati-activities {
  //iati-activity[iati-identifier=$ids("activities")]
}
