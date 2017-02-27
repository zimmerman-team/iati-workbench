module namespace ids = "http://iati.me/map/ids";
(: declare variable $file external; :)

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
