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
