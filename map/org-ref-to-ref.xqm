xquery version "3.1";
(:~
: <h1>Quality improvement map for organisation identifiers.</h1>
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

module namespace org-ref-to-ref = "http://iati.me/map/org-ref-to-ref";

(:~
: Quality improvement map for organisation identifiers: the key is an uppercase
: identifier to look up, the value is an improved ("canonical") identifier to use.
:)
declare variable $org-ref-to-ref:map := map {
  "UK DFID": "GB-1",
  "GB-CHC-27446721": "GB-CHC-274467", (: non-existant CHC number :)
  "GB-CH-1127488-NEP": "GB-CH-1127488", (: non-existant CHC number :)
  "NL-1": "XM-DAC-7",
  "GB-1": "GB-GOV-1",
  "FIND YOUR FEET UK": "GB-CHC-250456",
  "US-GG-5857": "NP-DAO-531/062/063",
  "INTERBURNS": "GB-CHC-1122299",
  "0000506969": "NL-KVK-41149287",  (: from Oxfam Novib set :)
  "21033-1.0792": "21033", (: errors in data Transparency International :)
  "21033-1.1068": "21033",
  "21033-1.1003": "21033",
  "21033-1.2001": "21033",
  "21033-1.1053": "21033",
  "XM-DAC-7-PPR-28436": "XM-DAC-7", (: errors in data TDH preview :)
  "21045": "NL-KVK-41150298",  (: Amref :)
  "UG=RSB=73316": "UG-RSB-73316", (: errors in Amref/HSA preview :)
  "NL-KVK-41201644-HSAGEN": "NL-KVK-41201644",
  "NL-KVK-4119890": "NL-KVK-41198890", (: errors in PlanNL/DTZ :)
  "NL-KVK-4198890": "NL-KVK-41198890",
  "NLKVK41149287": "NL-KVK-41149287"
};

(:~
: Quality improvement list of organisation identifiers to ignore.
:)
declare variable $org-ref-to-ref:ignore := (
  "UNKNOWN",
  "22000",
  "TERRE DES HOMMES-NETHERLANDS BANGLADESH", (: errors in data TDH preview :)
  "RVKO ",
  "RATANA METTA ORGANIZATION",
  "RAKS THAI FOUNDATION",
  "THE UGANDA ASSOCIATION OF WOMEN LAWYERS (FIDA UGANDA)",
  "UNITED DEVELOPMENT INITIATIVES FOR PROGRAMMED ACTIONS",
  "YAYASAN PEMERHATI SOSIAL INDONESIA",
  "VULNERABLE YOUTH DEVELOPMENT ASSOCIATION",
  "FORUM ON SUSTAINABLE CHILD EMPOWERMENT"
);
