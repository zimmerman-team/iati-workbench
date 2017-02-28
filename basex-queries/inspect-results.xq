(:~
: <h1>Inspect results.</h1>
: <p>Show an overview of all activities with results, ordered
: by organisation.</p>
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
