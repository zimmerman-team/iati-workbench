(:~
: <h1>Transform CSV into CSV-XML.</h1>
:)

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
(:~
We use BaseX's CSV module https://docs.basex.org/wiki/CSV_Module

Upsides:

It has a pretty robust CSV parser, with a simple XML output format.

It can handle CSV with multiline content (where text cells contain newlines within quotes).

Excel or ODF XML formats are much harder to parse, especially with column or row spans in the content.

Downsides:

It is an Xquery-based module with a pretty big executable.

The resulting CSVXML document quickly grows very big.
:)
declare variable $file external;

let $text := file:read-text($file)
return csv:parse($text, map { 'header': true(), 'format': 'attributes' })
