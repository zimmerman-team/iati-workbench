(:~
: <h1>Find more identifiers linking to include in the list.</h1>
:)

import module namespace ids = "http://iati.me/map/ids" at "../workspace/Partos-Spindle/src/identifiers2.xq";

declare option output:method 'text';

let $ids:=(
  //iati-activity[participating-org/@activity-id=$ids:activities]/iati-identifier,
  //iati-activity[transaction/provider-org/@provider-activity-id=$ids:activities]/iati-identifier,
  //iati-activity[transaction/receiver-org/@receiver-activity-id=$ids:activities]/iati-identifier,
  //iati-activity[related-activity/@ref=$ids:activities]/iati-identifier
)[not(.=$ids:activities)]

for $id in distinct-values(data($ids))
return concat('"', $id, '",&#xa;'),

let $ids:=(//iati-activity[iati-identifier=$ids:activities]/transaction/(provider-org/@provider-activity-id,receiver-org/@receiver-activity-id))[not(.=$ids:activities)]

for $id in distinct-values(data($ids))
return concat('"', $id, '",&#xa;')
