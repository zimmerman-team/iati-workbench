(:~
: <h1>Get the activities based on a list of identifiers.</h1>
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
