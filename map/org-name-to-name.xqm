xquery version "3.1";
(:~
: <h1>Quality improvement map for organisation names.</h1>
:)

module namespace org-name-to-name = "http://iati.me/map/org-name-to-name";

(:~
: Quality improvement map for organisation names: the key is a lowercase string
: to look up, the value is an improved ("canonical") name to use.
:)
declare variable $org-name-to-name:map := map {
  "world vision international - nepal": "World Vision Nepal",
  "actionaid united kingdom": "ActionAid UK",
  "elca - provider does not have an id": "ELCA",
  "from elca": "ELCA",
  "dance for life": "Dance4Life",
  "dance 4 life": "Dance4Life",
  "d4l": "Dance4Life",
  "terre des hommes": "Terre des Hommes",
  "fondazione terre des hommes italia onlus": "Terre des Hommes - Italy",
  "terre des hommes deutschland e. v.": "Terre des Hommes - Germany",
  "private individuals": "Individual",
  "private citizen": "Individual",
  "high value supporter": "Individual",
  "corporate - new business": "Corporate",
  "corporate - partners - other established": "Corporate",
  "business": "Corporate",
  "feminist dalit organisation": "Feminist Dalit Organisation (FEDO)",
  "centre for integrated urban development": "Centre for Integrated Urban Development (CIUD)",
  "wwscc": "Women’s Welfare Saving and Credit Cooperative",
  "the informal sector service center (insec)": "Informal Sector Service Center (INSEC)",
  "unrestricted donations": "Other Donors",
  "unrestricted": "Other Donors",
  "unrestricted income": "Other Donors",
  "unrestricted other": "Other Donors",
  "donations": "Other Donors",
  "major donor": "Other Donors",
  "forum for awarness and youth activity nepal (faya-nepal)": "Forum for Awareness and Youth Activity Nepal (FAYA-Nepal)",
  "forum for awareness and youth activity- nepal": "Forum for Awareness and Youth Activity Nepal (FAYA-Nepal)",
  "forum for protection of public interest": "Forum for Protection of the Public Interest",
  "rural women\'s development and unity center": "Rural Women's Development and Unity Center",
  "rural women\\'s development and unity center": "Rural Women's Development and Unity Center",
  "lumanti support group for shelter": "Lumanti Support Group for Shelter (LUMANTI)",
  "un united nations children's fund unicef": "UNICEF",
  "united nations children's fund": "UNICEF",
  "backward society education": "Backward Society Education (BASE)",
  "community development forum": "Community Development Forum (CDF)",
  "european union (madad fund)": "European Union",
  "npl, sweetie": "Nationale Postcode Loterij",
  "npl, watch": "Nationale Postcode Loterij",
  "amref health in africa": "Amref Health Africa", (: Amref data fixes :)
  "amref health africa hq": "Amref Health Africa",
  "amref health africa in kenya": "Amref Health Africa Kenya",
  "amref health africa in uganda": "Amref Health Africa Uganda",
  "plan indonesia country office": "Plan Indonesia", (: PlanNL fixes :)
  "plan dominican republic country office": "Plan Dominican Republic",
  "plan brazil country office": "Plan Brazil"
};
