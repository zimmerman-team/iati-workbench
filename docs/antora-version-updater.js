const antoraversion=/version:\s*(\S+)/

module.exports.readVersion = function(contents) {
    return contents.match(antoraversion)[1]
}

module.exports.writeVersion = function(contents, version) {
    return contents.replace(antoraversion, 'version: '+version)
}
