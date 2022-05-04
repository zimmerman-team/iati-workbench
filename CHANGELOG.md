# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

## [1.7.0](https://github.com/data4development/iati-workbench/compare/v1.6.1...v1.7.0) (2022-05-04)


### Features

* add optional vocabulary code and URI for recipient regions ([296902a](https://github.com/data4development/iati-workbench/commit/296902a8b81c3522e846fd8c93fdced9fe258dee))
* add optional vocabulary URI for policy markers ([92a0ca2](https://github.com/data4development/iati-workbench/commit/92a0ca28b03554cadeefa3b4cf25e20567f4e91f))
* add optional vocabulary URI for sectors ([47bd1b1](https://github.com/data4development/iati-workbench/commit/47bd1b1f2dc3550d3c0e6db7d1cf3835ae91102d))
* add tags template ([236443e](https://github.com/data4development/iati-workbench/commit/236443eecb105cff0f1707ea8914fca75b956673))


### Improvements

* handle ambiguous filenames containing 'projects" ([e34b05c](https://github.com/data4development/iati-workbench/commit/e34b05c65094d553db6fa884d6021f2e2f106827))
* return monetary values as strings rather than xs:decimal ([ffe3fc3](https://github.com/data4development/iati-workbench/commit/ffe3fc32c5c9677df3e0c53abce1be602d702f18))


### Debts

* make the version release process easier ([e55deca](https://github.com/data4development/iati-workbench/commit/e55deca6103aaf3acd8f3630b00a5494a83cde20))
* simplify test setup for default templates ([44d4a40](https://github.com/data4development/iati-workbench/commit/44d4a402d140ff76decb6b555cefd6b6526f86a5))

### [1.6.1](https://github.com/data4development/iati-workbench/compare/v1.6.0...v1.6.1) (2022-04-26)


### Improvements

* attribute is called indicator-uri rather than vocabulary-uri ([5bfe012](https://github.com/data4development/iati-workbench/commit/5bfe012306f81e5b552359355efd34aaab80b2ff))

## [1.6.0](https://github.com/data4development/iati-workbench/compare/v1.5.1...v1.6.0) (2022-04-26)


### Features

* add vocabulary code and URI on results and indicators ([57d60c0](https://github.com/data4development/iati-workbench/commit/57d60c0eccde4d6158d1f6e66e2f58e494fe46a3))


### Improvements

* add US$; simplify tests for currency symbol and value recognition ([1a7481d](https://github.com/data4development/iati-workbench/commit/1a7481dca541ced802b9a8f7b282bbe96e8482d7))

### [1.5.1](https://github.com/data4development/iati-workbench/compare/v1.5.0...v1.5.1) (2022-04-12)


### Documentation

* fix navigation that disappeared in merge ([54b6f82](https://github.com/data4development/iati-workbench/commit/54b6f82f59d27a11e10734c744f5943f00e77ebd))

## [1.5.0](https://github.com/data4development/iati-workbench/compare/v1.4.0-aida...v1.5.0) (2022-04-12)


### Features

* add custom configuration for specific client ([5fab225](https://github.com/data4development/iati-workbench/commit/5fab225354a0c7f38fab33e91726bb3f1b078605))


### Debts

* rename git branch aida to main ([8560617](https://github.com/data4development/iati-workbench/commit/856061731fa6ddf78fc55fe76d6f4bfc4c37b242))


### Documentation

* make aida-s2i consistent ([9b995ff](https://github.com/data4development/iati-workbench/commit/9b995ff4c9af9b56531709e256081c2a8d862e81))
* move date formats overview into references section ([4368f18](https://github.com/data4development/iati-workbench/commit/4368f18881e23586891bdf41bc85e5ac6a6ad018))


### Improvements

* add --init to git submodule update ([40ec4d1](https://github.com/data4development/iati-workbench/commit/40ec4d13c9147f589436d5b2aa35e980e3f4e632))
* add activity status code lookup and optional column ([02b28c1](https://github.com/data4development/iati-workbench/commit/02b28c12705abb4f4bdd97408cd7cb001e7fbe38))
* add an empty default-templates.xsl ([71f8fbe](https://github.com/data4development/iati-workbench/commit/71f8fbec22d10a7309342917bb25df13b7f50ace))
* add not-processed template for nuffic ([b47e376](https://github.com/data4development/iati-workbench/commit/b47e3763b85cb6ebd0ffd4fa050176cea6757242))
* handle utf8 in filenames ([aa9c141](https://github.com/data4development/iati-workbench/commit/aa9c1413e0419dab1069825110a79bcf12efa382))
* merge-activities shouldn't include related-activity with empty @ref ([1a0a053](https://github.com/data4development/iati-workbench/commit/1a0a053fb63bcc9f14330e5dd6ec2788646e18ba))
* no duplication of participating-orgs without @ref ([8f7caa4](https://github.com/data4development/iati-workbench/commit/8f7caa4a8197373f879a6c28d7361bb126036486))
* process Akvo files as regular IATI when no custom config exists ([9297874](https://github.com/data4development/iati-workbench/commit/9297874519a9fa64d6cdfd4dd7af25c21622dba7))
* run iati-s2i for files in the tmp folder ([8ee4c86](https://github.com/data4development/iati-workbench/commit/8ee4c86cbb3e4186d27c40b93965702bf5c76780))
* skip empty activity title and description narratives ([7eb6847](https://github.com/data4development/iati-workbench/commit/7eb6847f2c0b2d99292add066be78280e524d51b))
* update Nuffic activity status mapping ([7485c89](https://github.com/data4development/iati-workbench/commit/7485c89505c68cc4a457381a614db9f8cc5f6507))

## [1.4.0](https://github.com/data4development/iati-workbench/compare/v1.3.0...v1.4.0) (2022-01-12)


### Features

* add Akvo file processing, update IATI file processing ([64814f0](https://github.com/data4development/iati-workbench/commit/64814f0944272b2bcaba24e44bd805285ca2ea9c))
* convert timestamp values as dates ([3c76b2a](https://github.com/data4development/iati-workbench/commit/3c76b2a83d04fab1ee009df386e30acd63b1d0e5))


### Debts

* split file handling and merging of activities and organisations ([7a01d5b](https://github.com/data4development/iati-workbench/commit/7a01d5b7b196e2d02702937e65b65aa39e87c2bc))


### Documentation

* update description of s2i process ([5f07083](https://github.com/data4development/iati-workbench/commit/5f07083ccc42c4ec67adff63171fed9ef1a0f411))


### Risks and compliance

* for compliance, add AGPL license text to source files ([22cd10f](https://github.com/data4development/iati-workbench/commit/22cd10f607508ca431b456359ecf19149584cc4e))


### Improvements

* check if Akvo config exists ([5968415](https://github.com/data4development/iati-workbench/commit/596841565064ee15ecd8ac9c00fc8daf16568cbf))
* error introduced in merging activities ([e2cf9fd](https://github.com/data4development/iati-workbench/commit/e2cf9fd65047582f0eb33d9ddbea0c38b6081663))
* handle xml:lang better ([1da02a8](https://github.com/data4development/iati-workbench/commit/1da02a877cd64596025965219808da29168cc579))
* merge recipient-country and sector per code ([18637d1](https://github.com/data4development/iati-workbench/commit/18637d163c5aebf28e75b50908fbb9c2266e8cd7))
* output iati-activities and iati-organisations into separate files ([e86fb99](https://github.com/data4development/iati-workbench/commit/e86fb99835931f3722bc0fa6d9d1b6d575cad0e7))
* skip several elements with empty narratives in merge-activities ([95229d1](https://github.com/data4development/iati-workbench/commit/95229d149fd849d68ffeb22ae3f1bed51b7297b7))
* start updating handling of narratives ([0a0ae9d](https://github.com/data4development/iati-workbench/commit/0a0ae9dc59cbb4a8fa489921c6efc3108465ea5a))

## [1.3.0](https://github.com/data4development/iati-workbench/compare/v1.2.0...v1.3.0) (2021-11-30)


### Features

* add -v option to command line wrapper ([86adf12](https://github.com/data4development/iati-workbench/commit/86adf125d8d7987a4b2a6683f195c1b2f34f226b))


### Improvements

* add docs and check for git submodule update ([a4afef6](https://github.com/data4development/iati-workbench/commit/a4afef62450682c9a03ebbae81d1e4c7cb637fed))
* improve handling of multilingual narratives ([a285fb8](https://github.com/data4development/iati-workbench/commit/a285fb8ce26a7139a78733082909ca7d83108495))


### Debts

* add version tag to repo, allow building Docker image with it ([09c4ecc](https://github.com/data4development/iati-workbench/commit/09c4ecc238916639cdf87b9dd3b376234bf3a66d))


### Documentation

* add -w workspace to help info ([8a0a181](https://github.com/data4development/iati-workbench/commit/8a0a1816c5fbb3ea2b218e5eabe5a9decd7ad866))
* add build option in wrapper to README ([49fd828](https://github.com/data4development/iati-workbench/commit/49fd828086df7d2bf2945bfd3a19f3358f6a1364))

## [1.2.0](///compare/v1.1.1...v1.2.0) (2021-11-16)


### Features

* adapt s2i to run from variable workspace directory d6d52b8
* make workspace directory a parameter b9d580a


### Improvements

* improve date handling in conversions 965bcd3
* remove duplicated variables in org templates fe5b7d7
* remove include of develop/build.xml 6d26a5f


### Debts

* add standard-version helpers 2aa1240


### Documentation

* Mark `develop` branch as prerelease in docs d142583

### [1.1.1](https://github.com/data4development/iati-workbench/compare/v1.1.0...v1.1.1) (2021-11-11)


### Documentation

* change docs version to 'main' ([60fa75a](https://github.com/data4development/iati-workbench/commit/60fa75a9fc9b68a829e399e7ca3600646378795d))

## 1.1.0 (2021-10-24)


### Features

* **S2I:** add 'n/a' as default activity description ([6bcee3d](https://github.com/data4development/iati-workbench/commit/6bcee3d0b3eee843443cc4834bc99333e7d3dfe0))


### Improvements

* **S2I:** let date conversions return empty sequence for invalid dates ([2e9ae3d](https://github.com/data4development/iati-workbench/commit/2e9ae3d40df8f36fb47fb95e64372fff9d3af154))
