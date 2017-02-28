declare variable $ids := (
  "NL-KVK-41160054",
  "NL-KVK-27108436",
  "NL-KVK-56484038",
  "NL-KVK-41207989"
);

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
  