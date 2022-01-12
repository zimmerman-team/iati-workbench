(:~
: <h1>Find more identifiers linking to include in the list.</h1>
:)

(:~  IATI workbench: produce and use IATI data
  Copyright (C) 2016-2022, drostan.org and data4development.org
  
  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU Affero General Public License as published
  by the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.
  
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Affero General Public License for more details.
  
  You should have received a copy of the GNU Affero General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
:)

import module namespace ids = "http://iati.me/map/ids" at "../lib/identifiers.xqm";
declare variable $file external;
declare option output:method 'text';

(: Find activities upstream :)

"Upstream:&#xa;&#xa;",

let $ids := ids:activities-from-files($file)

let $upstreams:=distinct-values(($ids("seeds"), $ids("upstream")))

let $newids:=(
  (: ----- Pointing upstream from the set of knowns ----- :)

  (: participating-org that is funding :)
  //iati-activity[iati-identifier=$upstreams]
    /participating-org[lower-case(@role)=("1","funding")]/@activity-id,

  (: any activity that an upstream claims transactions come from :)
  //iati-activity[iati-identifier=$upstreams]
    /transaction[lower-case(transaction-type/@code)=("1","11","if")]
    /provider-org/@provider-activity-id,

  (: any activity that an upstream claims as parent or cofunding :)
  //iati-activity[iati-identifier=$upstreams]
    /related-activity[@type=("1","4")]/@ref,

  (: ----- Pointing downstream to one of the knowns ----- :)

  (: claims one of the upstreams is implementing or extending it :)
  //iati-activity
    [participating-org
      [@activity-id=$upstreams and lower-case(@role)=("3","4","extending","implementing")]
    ]/iati-identifier,

  (: claims a transaction to one of the upstreams :)
  //iati-activity
    [/transaction
      [receiver-org/@receiver-activity-id=$upstreams
      and lower-case(transaction-type/@code)=("2","3","7","c","d","r")]
    ]/iati-identifier,

  (: claims an upstream is a child :)
  //iati-activity
    [related-activity
      [@ref=$upstreams and @type="2"]
    ]/iati-identifier
)[not(.=$upstreams)]

for $id in distinct-values(data($newids))
return concat($id, '&#xa;'),

(: Find activities downstream :)

"&#xa;&#xa;Downstream:&#xa;&#xa;",

let $ids := ids:activities-from-files($file)

let $downstreams:=distinct-values(($ids("seeds"), $ids("downstreams")))

let $newids:=(
  (: ----- Pointing downstream from the set of knowns ----- :)

  (: participating-org that is funding :)
  //iati-activity[iati-identifier=$downstreams]
    /participating-org[lower-case(@role)=("3","4","extending","implementing")]
    /@activity-id,

  (: any activity that a downstream claims transactions go to :)
  //iati-activity[iati-identifier=$downstreams]
    /transaction[lower-case(transaction-type/@code)=("2","3","7","c","d","r")]
    /receiver-org/@receiver-activity-id,

  (: any activity that a downstream claims as child :)
  //iati-activity[iati-identifier=$downstreams]
    /related-activity[@type="2"]/@ref,

  (: ----- Pointing downstream to one of the knowns ----- :)

  (: claims one of the downstreams is funding it :)
  //iati-activity
    [participating-org
      [@activity-id=$downstreams and lower-case(@role)=("1","funding")]
    ]/iati-identifier,

  (: claims a transaction to from of the downstreams :)
  //iati-activity
    [/transaction
      [provider-org/@provider-activity-id=$downstreams
      and lower-case(transaction-type/@code)=("2","3","7","c","d","r")]
    ]/iati-identifier,

  (: claims a downstream is a parent or cofunder :)
  //iati-activity
    [related-activity
      [@ref=$downstreams and @type=("1","4")]
    ]/iati-identifier
)[not(.=$downstreams)]

for $id in distinct-values(data($newids))
return concat($id, '&#xa;')
