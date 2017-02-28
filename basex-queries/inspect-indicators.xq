(:~
: <h1>Inspect result indicators.</h1>
: <p>Show an overview of all indicators in the data, and per indicator
: the activities in which it is used and how.</p>
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
