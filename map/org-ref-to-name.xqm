xquery version "3.1";
(:~
: <h1>Quality improvement map to find organisation names for identifiers.</h1>
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
