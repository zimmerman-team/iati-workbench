module namespace ids = "http://iati.me/map/ids";
(: declare variable $file external; :)
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

declare function ids:get-identifiers($file as xs:string) as xs:string* {
  distinct-values(
    if (file:is-file($file))
    then
      let $ids := file:read-text-lines($file)
      return (
        for $id in $ids
        return normalize-space($id)
      )
    else ()
  )[not(starts-with(.,"# ") or .="")]
};

declare function ids:activities-from-files($seedsfile as xs:string) as map(xs:string, xs:string*) {
  let $seeds := ids:get-identifiers($seedsfile)
  let $upstream := ids:get-identifiers(concat($seedsfile,".up"))
  let $downstream := ids:get-identifiers(concat($seedsfile,".down"))

  return map {
      "seeds": $seeds,
      "upstream": $upstream,
      "downstream": $downstream,
      "activities": ($seeds, $upstream, $downstream)
    }
};
