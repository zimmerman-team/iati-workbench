(:~
: <h1>Inspect sectors and recipient-country/regions.</h1>
: <p>Show an overview of all activities and the sectors used, followed
: by a list of activities and the recipient-country and recipient-region
: used.</p>
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

element sector-check {

for $a in //iati-activity[count(sector)>1]
order by $a/reporting-org/@ref

return element iati-activity {
  @*,
  $a/iati-identifier,
  element reporting-org {
    $a/reporting-org/@*
  },
  for $s in $a/sector
  return element {$s/name()} {
    $s/@*
  }
}

}
,

element recipient-check {

for $a in //iati-activity[(recipient-country|recipient-region)]
order by $a/reporting-org/@ref

return element iati-activity {
  @*,
  $a/iati-identifier,
  element reporting-org {
    $a/reporting-org/@*
  },
  for $s in $a/recipient-country|recipient-region
  return element {$s/name()} {
    $s/@*
  }
}

}
