declare namespace i = "http://iati.me";

element transactions {

for $t in //transaction

return element transaction {
  $t/@*,
  $t/*,
  $t/../iati-identifier,
  $t/../reporting-org
}

}
