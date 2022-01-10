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

(: Find activities downstream :)

let $ids := ids:activities-from-files($file)

let $downstream:=distinct-values(($ids("seeds"), $ids("downstream")))

let $newids:=(
  (: ----- Pointing downstream from the set of knowns ----- :)

  (: participating-org that is funding :)
  //iati-activity[iati-identifier=$downstream]
    /participating-org[lower-case(@role)=("3","4","extending","implementing")]
    /xs:string(@activity-id),

  (: any activity that a downstream claims transactions go to :)
  //iati-activity[iati-identifier=$downstream]
    /transaction[lower-case(transaction-type/@code)=("2","3","7","c","d","r")]
    /receiver-org/xs:string(@receiver-activity-id),

  (: any activity that a downstream claims as child :)
  //iati-activity[iati-identifier=$downstream]
    /related-activity[@type="2"]/xs:string(@ref),

  (: ----- Pointing upstream to one of the knowns ----- :)

  (: claims one of the downstreams is funding it :)
  //participating-org[@activity-id=$downstream]
    [lower-case(@role)=("1","funding")]
    /../xs:string(iati-identifier),

  (: claims a transaction to from of the downstreams :)
  //provider-org[@provider-activity-id=$downstream]
    [lower-case(transaction-type/@code)=("2","3","7","c","d","r")]
    /../../xs:string(iati-identifier),

  (: claims a downstream is a parent or cofunder :)
  //related-activity[@ref=$downstream]
    [@type=("1","4")]
    /../xs:string(iati-identifier)
)

return concat(
  "# Downstream&#xa;&#xa;",
  string-join(distinct-values($ids("downstream")), '&#xa;'),
  "&#xa;&#xa;# Newly added&#xa;&#xa;",
  string-join(distinct-values($newids[not(.=$downstream)]), '&#xa;')
)
