// Adaptated from https://github.com/plausible/analytics/blob/96633f46b15643b74e764a58ff31e529c6680a83/tracker/src/plausible.js
(function(window, host){
  'use strict';

  var location = window.location
  var document = window.document
  var domain = new URL(host).hostname
  var lastPage;

  function trigger(eventName, options) {
    var payload = {}
    payload.n = eventName
    payload.u = location.href
    payload.d = domain
    payload.r = document.referrer || null
    payload.w = window.innerWidth
    if (options && options.meta) {
      payload.m = JSON.stringify(options.meta)
    }
    if (options && options.props) {
      payload.p = JSON.stringify(options.props)
    }

    var request = new XMLHttpRequest();
    request.open('POST', host + '/event', true);
    request.setRequestHeader('Content-Type', 'text/plain');

    request.send(JSON.stringify(payload));

    request.onreadystatechange = function () {
      if (request.readyState == 4) {
        options && options.callback && options.callback()
      }
    }
  }

  function page() {
    if (lastPage === location.pathname) return;
    lastPage = location.pathname
    trigger('pageview')
  }

  function handleVisibilityChange() {
    if (!lastPage && document.visibilityState === 'visible') {
      page()
    }
  }

  try {
    var history = window.history
    if (history.pushState) {
      var originalPushState = history['pushState']
      history.pushState = function () {
        originalPushState.apply(this, arguments)
        page();
      }
      window.addEventListener('popstate', page)
    }

    var queue = (window.plausible && window.plausible.q) || []
    window.plausible = trigger
    for (var i = 0; i < queue.length; i++) {
      trigger.apply(this, queue[i])
    }

    if (document.visibilityState === 'prerender') {
      document.addEventListener("visibilitychange", handleVisibilityChange);
    } else {
      page()
    }
  } catch (e) {
    console.error(e)
  }
})(window, '%%ENDPOINT%%');