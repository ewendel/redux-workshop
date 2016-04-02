function matchesHashtags(tweet) {
  return filter =>
    tweet.entities.hashtags &&
    filter.hashtags &&
      tweet.entities.hashtags
        .map(h => h.text)
        .some(h => filter.hashtags.find(fh => fh === h));
}

function matchesText(tweet) {
  return filter =>
    tweet.text &&
    tweet.text.indexOf(filter.text) > -1;
}

function matchesGeo(tweet) {
  return filter => false;
}

function filterMatch(tweet) {
  const matchers = [
    matchesHashtags,
    matchesText,
    matchesGeo
  ].map(m => m(tweet));

  return filter => matchers.some(m => m(filter));
}

export function findFilterMatch(tweet, filters) {
  return filters.find(filterMatch(tweet));
}
