(:~
: <h1>Find more identifiers linking to include in the list.</h1>
:)

import module namespace ids = "http://iati.me/map/ids" at "../lib/identifiers.xqm";
declare variable $file external;
declare option output:method 'text';

(: Find activities upstream :)

let $ids := ids:activities-from-files($file)

let $upstream:=distinct-values(($ids("seeds"), $ids("upstream")))

let $newids:=(
  (: ----- Pointing upstream from the set of knowns ----- :)

  (: participating-org that is funding :)
  //iati-activity[iati-identifier=$upstream]
    /participating-org[lower-case(@role)=("1","funding")]/@activity-id,

  (: any activity that an upstream claims transactions come from :)
  //iati-activity[iati-identifier=$upstream]
    /transaction[lower-case(transaction-type/@code)=("1","11","if")]
    /provider-org/@provider-activity-id,

  (: any activity that an upstream claims as parent or cofunding :)
  //iati-activity[iati-identifier=$upstream]
    /related-activity[@type=("1","4")]/@ref,

  (: ----- Pointing downstream to one of the knowns ----- :)

  (: claims one of the upstreams is implementing or extending it :)
  //iati-activity
    [participating-org
      [@activity-id=$upstream and lower-case(@role)=("3","4","extending","implementing")]
    ]/iati-identifier,

  (: claims a transaction to one of the upstreams :)
  //iati-activity
    [/transaction
      [receiver-org/@receiver-activity-id=$upstream
      and lower-case(transaction-type/@code)=("2","3","7","c","d","r")]
    ]/iati-identifier,

  (: claims an upstream is a child :)
  //iati-activity
    [related-activity
      [@ref=$upstream and @type="2"]
    ]/iati-identifier
)[not(.=$upstream)]

return concat(
  "# Upstream&#xa;&#xa;",
  string-join(distinct-values($ids("upstream")), '&#xa;'),
  "&#xa;&#xa;# Newly added&#xa;&#xa;",
  string-join(distinct-values(data($newids)), '&#xa;')
)
