{test, getCache, setCache} = require "snapy"

test (snap) =>
  setCache saveState: "cacheValue", key: "cacheKey"
  .then =>
    # file contains cacheValue
    snap textfile: "./test/cache.json", modify: [
      JSON.parse
      "cacheKey"
    ]
    # getCache give cacheValue
    snap promise: getCache key: "cacheKey"

