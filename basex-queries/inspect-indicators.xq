(:~
: <h1>Inspect result indicators.</h1>
: <p>Show an overview of all indicators in the data, and per indicator
: the activities in which it is used and how.</p>
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

element indicators {

for $i in distinct-values(//iati-activity/result/indicator/title/narrative)

return element indicator {
  element title {$i},
  for $a in //iati-activity[data(*/indicator/title/narrative)=$i]
  return element activity {
    $a/iati-identifier,
    element title {data($a/title/narrative)},
    $a/result/indicator[title=$i]/period

  }
}

}
