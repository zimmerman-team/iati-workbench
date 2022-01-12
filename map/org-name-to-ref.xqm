xquery version "3.1";
(:~
: <h1>Quality improvement map to find organisation identifiers for names.</h1>
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

module namespace org-name-to-ref = "http://iati.me/map/org-name-to-ref";

(:~
: Quality improvement map for organisation names to reference: the key is a
: lowercase string to look up, the value is an improved ("canonical")
: organisation identifier to use.
:)
declare variable $org-name-to-ref:map := map {
  "adra-uk": "GB-COH-1074937",
  "danish international development agency - danida": "DK-1",
  "department for international development (dfid)": "GB-1",
  "dfid": "GB-1",
  "dfid gpaf": "GB-1",
  "uk department for international development": "GB-1",
  "department for international development": "GB-1",
  "danida": "DK-1",
  "icco": "NL-KVK-56484038",
  "phase nepal": "NP-DAO-531/062/063",
  "save the children - uk": "GB-COH-213890",
  "uk government, department for international development": "GB-1",
  "wwf-uk": "GB-COH-1081247",
  "bbc media action": "GB-CHC-1076235",
  "womankind worldwide": "GB-CHC-328206",
  "care international uk": "GB-CHC-292506",
  "saferworld": "GB-CHC-1043843",
  "stars": "GB-CHC-1087997",
  "find your feet": "GB-CHC-250456",
  "find your feet uk": "GB-CHC-250456",
  "interburns": "GB-CHC-1122299",
  "actionaid uk": "GB-CHC-274467",
  "actionaid international": "NL-KVK-27264198",
  "action aid international": "NL-KVK-27264198",
  "terre des hommes-netherlands": "NL-KVK-41149287",
  "terre des hommes netherlands": "NL-KVK-41149287",
  "ministry of foreign affairs, the netherlands": "XM-DAC-7",
  "ministry of foreign affairs, srgr": "XM-DAC-7",
  "ministry of foreign affairs, gaa": "XM-DAC-7",
  "ministry of foreign affairs, csec (ecpat)": "XM-DAC-7",
  "transparency international": "21033",
  "zoa vluchtelingenzorg": "NL-KVK-41009723",
  "terre des hommes-netherlands bangladesh": "NL-KVK-41149287", (: errors in TDH preview :)
  "ministerie van buitenlandse zaken": "XM-DAC-7", (: errors in Amref/HSA preview :)
  "amref flying doctors": "NL-KVK-41150298",
  "plan nederland": "NL-KVK-41198890",  (: errors in TdH/DTZ data :)
  "terre des hommes": "NL-KVK-41149287",
  "ministry of foreign affairs dtz": "XM-DAC-7",
  "zoa": "NL-KVK-41009723",
  "stichting dorcas": "NL-KVK-41236410",
  "plan nederland office": "NL-KVK-41198890", (: errors in PlanNL/DTZ :)
  "defence for children international netherlands - ecpat netherlands": "NL-KVK-41208813", (: errors in Defence for Children/DTZ :)
  "netherlands enterprise agency": "NL-KVK-27378529", (: RVO.nl :)
  "stichting woord en daad": "NL-KVK-41118168" (: Woord en Daad w-d :)
};
