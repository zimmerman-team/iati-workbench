module namespace ids = "http://iati.me/map/ids";
(: declare variable $file external; :)

declare function ids:activities-from-files($seedsfile as xs:string) as map(xs:string, xs:string*) {
  let $seeds := if (file:is-file($seedsfile))
    then distinct-values(file:read-text-lines($seedsfile))
    else ()
  let $upstream := if (file:is-file(concat($seedsfile,".up")))
    then distinct-values(file:read-text-lines(concat($seedsfile,".up")))
    else ()
  let $downstream := if (file:is-file(concat($seedsfile,".down")))
    then distinct-values(file:read-text-lines(concat($seedsfile,".down")))
    else ()
  return map {
      "seeds": $seeds,
      "upstream": $upstream,
      "downstream": $downstream,
      "activities": ($seeds, $upstream, $downstream)
    }
};
