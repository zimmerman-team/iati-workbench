declare variable $ids := (
  "NL-KVK-41160054",
  "NL-KVK-27108436",
  "NL-KVK-56484038",
  "NL-KVK-41207989"
);

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

let $portfolio := //iati-activity[reporting-org/@ref=$ids]

for $c in distinct-values($portfolio/recipient-country/@code)
return
  (
    let $o := $portfolio[recipient-country/@code=$c]
    return
      if (count(distinct-values($o/reporting-org/@ref))>=3)
      then
        element country {
          attribute code {$c},
          for $i in $ids
          return element org {
            attribute ref {$i},
            count($o[reporting-org/@ref=$i])
          }
        }
       else ()
  )
  