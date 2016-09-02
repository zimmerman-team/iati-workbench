xquery version "3.1";
(:~
: <h1>Organisation filter</h1>
: <p>Add or replace the iati-me:ref attribute and the iati-me:narrative element
: in organisations.</p>
:)

module namespace iati-map-organisation = "http://iati.me/map/organisation";
declare namespace iati-me = "http://iati.me";

import module namespace org-name-to-name = "http://iati.me/map/org-name-to-name"
  at "org-name-to-name.xqm";
import module namespace org-name-to-ref = "http://iati.me/map/org-name-to-ref"
  at "org-name-to-ref.xqm";
import module namespace org-ref-to-ref = "http://iati.me/map/org-ref-to-ref"
  at "org-ref-to-ref.xqm";
import module namespace org-ref-to-name = "http://iati.me/map/org-ref-to-name"
  at "org-ref-to-name.xqm";

(:~
: Add augmented information to organisations.
:
: Look up organisation names and identifiers and add "canonical" versions to be
: used in further filtering and analysis. Add annotations with improvements
: made. The original data is kept, new information is added in the
: <pre>iati-me</pre> namespace.
:
: All organisation elements will get an attribute iati-me:ref with an
: identifier that can be used in further processing. If no identifier is given
: or known, one will be constructed from the name, with XX- as prefix.
:
: @param Document to improve.
: @return Augmented document with additional information.
:)
declare function iati-map-organisation:doc($doc as document-node()) as document-node()
{
  $doc
    =>iati-map-organisation:part('reporting-org')
    =>iati-map-organisation:part('participating-org')
    =>iati-map-organisation:part('provider-org')
    =>iati-map-organisation:part('receiver-org')
};

(:~
: Improve elements with a specific name.
:
: @param Input document to improve.
: @param Element name to look for with organisation information.
: @return Improved document.
:)
declare %private function iati-map-organisation:part($doc as document-node(), $item as xs:string) as document-node()
{
  copy $aDoc := $doc
  modify (
    for $o in $aDoc//*[name(.) = $item]
    return replace node $o with iati-map-organisation:improve($o)
  )
  return $aDoc
};

(:~
: Improve a single element.
:
: @param Element to improve.
: @return Improved element.
:)
declare function iati-map-organisation:improve ($org as element()) as element()
{
  let $name := normalize-space(
    if ($org/narrative)
    then (: IATI 2.01+ :)
      string($org/narrative[1])
    else (: IATI 1.0x or empty :)
      string($org)
  )

  let $name := if (map:contains($org-name-to-name:map, lower-case($name)))
    then
      map:get($org-name-to-name:map, lower-case($name))
    else
      $name

  let $nameattrs := if ($org/narrative)
    then
      $org/narrative[1]/@*
    else
      $org/@*[name() = 'xml:lang']

  let $ref := iati-map-organisation:id($org, $name)

  let $name := if (map:contains($org-ref-to-name:map, $ref))
    then
      map:get($org-ref-to-name:map, $ref)
    else
      $name

  return element { node-name($org)} {
    attribute iati-me:ref {$ref},
    $org/@*[not(name() = 'iati-me:ref')],

    if ($name != '')
    then
      element iati-me:narrative {$nameattrs, $name}
    else
      (),

    $org/*[not(name() = 'iati-me:narrative')]
  }
};

(:~
: Determine an organisation identifier based om either the existing identifier
: or on the name if no identifier is known.
:
: @param Organisation element to inspect.
: @param Name to look up or encode as identifier.
: @param Organisation identifier.
:)
declare function iati-map-organisation:id($org as element(), $name as xs:string) as xs:string {
  let $ref := $org/@ref=>normalize-space()=>upper-case()
  return
    if ($ref and not(index-of($org-ref-to-ref:ignore, $ref)))
    then
      (: check ref :)
      if (map:contains($org-ref-to-ref:map, $ref))
        then
          map:get($org-ref-to-ref:map, $ref)
        else
          $ref

    else
      (: see if we have a ref for the name :)
      if (map:contains($org-name-to-ref:map, lower-case($name)))
        then
          map:get($org-name-to-ref:map, lower-case($name))
        else
          'XX-'=>concat(
            $name=>normalize-space()
              =>lower-case()
              =>hash:md5()
              =>xs:hexBinary()
              =>string()
          )
};
