(:~
: <h1>Find more identifiers linking to include in the list.</h1>
:)

import module namespace ids = "http://iati.me/map/ids" at "../lib/identifiers.xqm";
declare variable $file external;
declare option output:method 'text';

(: Find activities downstream :)

let $ids := ids:activities-from-files($file)

let $downstream:=distinct-values(($ids("seeds"), $ids("downstream")))

let $newids:=(
  (: ----- Pointing downstream from the set of knowns ----- :)

  (: participating-org that is funding :)
  //iati-activity[iati-identifier=$downstream]
    /participating-org[lower-case(@role)=("3","4","extending","implementing")]
    /@activity-id,

  (: any activity that a downstream claims transactions go to :)
  //iati-activity[iati-identifier=$downstream]
    /transaction[lower-case(transaction-type/@code)=("2","3","7","c","d","r")]
    /receiver-org/@receiver-activity-id,

  (: any activity that a downstream claims as child :)
  //iati-activity[iati-identifier=$downstream]
    /related-activity[@type="2"]/@ref,

  (: ----- Pointing downstream to one of the knowns ----- :)

  (: claims one of the downstreams is funding it :)
  //iati-activity
    [participating-org
      [@activity-id=$downstream and lower-case(@role)=("1","funding")]
    ]/iati-identifier,

  (: claims a transaction to from of the downstreams :)
  //iati-activity
    [/transaction
      [provider-org/@provider-activity-id=$downstream
      and lower-case(transaction-type/@code)=("2","3","7","c","d","r")]
    ]/iati-identifier,

  (: claims a downstream is a parent or cofunder :)
  //iati-activity
    [related-activity
      [@ref=$downstream and @type=("1","4")]
    ]/iati-identifier
)[not(.=$downstream)]

return concat(
  "# Downstream&#xa;&#xa;",
  string-join(distinct-values($ids("downstream")), '&#xa;'),
  "&#xa;&#xa;# Newly added&#xa;&#xa;",
  string-join(distinct-values(data($newids)), '&#xa;')
)
