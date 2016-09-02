xquery version "3.1";
(:~
: <h1>Quality improvement map to find organisation names for identifiers.</h1>
:)

module namespace org-ref-to-name = "http://iati.me/map/org-ref-to-name";

(:~
: Quality improvement map for organisation names: the key is an uppercase
: identifier to look up, the value is an improved ("canonical") name to use.
:)
declare variable $org-ref-to-name:map := map {
  "NL-KVK-27264198": "ActionAid International",
  "NL-KVK-41009723": "ZOA",
  "NL-KVK-41149287": "Terre des Hommes Netherlands",
  "XM-DAC-7": "Ministry of Foreign Affairs, The Netherlands",
  "GB-1": "Department for International Development (DfID)",
  "21033": "Transparency International"
};
