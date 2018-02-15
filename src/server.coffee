module.exports = ({
  config,
  getEntry,
  cache
  run,
  position,
  path,
  fs
  }) =>

  cacheFile = path.resolve(config.cache)
  _cache = null
  keep = []

  keepIt = (o) =>
    keep.push o.key unless ~keep.indexOf(o.key)

  getEntry.hookIn position.after, (o) =>
    for k,v of o.entry
      delete o.entry[k] if v == cacheFile

  
  cache.get.hookIn (o) =>
    _cache ?= await fs.readJson(cacheFile).catch => return {}
    o.cache = tmp if (tmp = _cache[o.key])
    keepIt(o)

  cache.set.hookIn (o) => 
    _cache[o.key] = o.cache
    keepIt(o)
  
  cache.keep.hookIn keepIt

  cache.discard.hookIn (o) => delete _cache[o.key]

  cache.save.hookIn =>
    for key in Object.keys(_cache)
      delete _cache[key] unless ~keep.indexOf(key)
    fs.outputJson(cacheFile, _cache)

module.exports.configSchema =
  cache:
    type: String
    default: "./test/cache.json"
    desc: "default storage of test cache"