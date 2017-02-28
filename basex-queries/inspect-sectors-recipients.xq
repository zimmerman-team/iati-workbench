(:~
: <h1>Inspect sectors and recipient-country/regions.</h1>
: <p>Show an overview of all activities and the sectors used, followed
: by a list of activities and the recipient-country and recipient-region
: used.</p>
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
