(:~
: <h1>Inspect results.</h1>
: <p>Show an overview of all activities with results, ordered
: by organisation.</p>
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

element results-check {

for $a in //iati-activity[result]
order by $a/reporting-org/@ref

return element iati-activity {
  @*,
  $a/iati-identifier,
  element reporting-org {
    $a/reporting-org/@*
  },
  for $s in $a/result
  return element {$s/name()} {
    $s/@*,
    element title {data($s/title/narrative)},

    for $i in $s/indicator
    return element {$i/name()} {
      $i/@*,
      element title {data($i/title/narrative)},
      $i/(baseline|period)
    }
  }
}

}
