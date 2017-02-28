(:~
: <h1>Get the activities based on a list of identifiers.</h1>
:)

import module namespace ids = "http://iati.me/map/ids" at "../workspace/dfid/src/identifiers.xq";

element iati-activities {
  for $a in //iati-activity[iati-identifier=$ids:activities]
  return element iati-activity {
    $a/@*,
    $a/iati-idenfifier,
    $a/reporting-org,
    $a/participating-org,
    $a/title,
    $a/related-activity,
    $a/transaction[provider-org or receiver-org]
  }
}
