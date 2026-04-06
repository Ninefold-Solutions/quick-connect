function csrfToken() {
  const token = document.querySelector("meta[name='csrf-token']")
  return token ? token.content : null
}

function acceptHeader(responseKind) {
  const kind = (responseKind || "").toString().toLowerCase()

  if (kind === "turbo-stream") {
    return "text/vnd.turbo-stream.html, text/html, application/xhtml+xml"
  }

  if (kind === "json" || kind === "application/json") {
    return "application/json"
  }

  return "*/*"
}

class FetchResponse {
  constructor(response) {
    this.response = response
  }

  get ok() {
    return this.response.ok
  }

  get statusCode() {
    return this.response.status
  }

  get redirected() {
    return this.response.redirected
  }

  get location() {
    return this.response.url
  }

  get headers() {
    return this.response.headers
  }

  get text() {
    return this.response.text()
  }

  get json() {
    return this.response.json()
  }
}

export class FetchRequest {
  constructor(method, url, options = {}) {
    this.method = method
    this.url = url
    this.options = options
  }

  async perform() {
    const headers = new Headers(this.options.headers || {})
    const token = csrfToken()

    if (!headers.has("Accept")) {
      headers.set("Accept", acceptHeader(this.options.responseKind))
    }

    if (!headers.has("X-Requested-With")) {
      headers.set("X-Requested-With", "XMLHttpRequest")
    }

    if (token && !headers.has("X-CSRF-Token")) {
      headers.set("X-CSRF-Token", token)
    }

    if (this.options.body != null && !headers.has("Content-Type") && !(this.options.body instanceof FormData)) {
      headers.set("Content-Type", "application/json")
    }

    const response = await fetch(this.url, {
      method: this.method,
      body: this.options.body,
      headers,
      credentials: this.options.credentials || "same-origin",
      redirect: this.options.redirect || "follow"
    })

    const fetchResponse = new FetchResponse(response)

    if (response.ok && (this.options.responseKind || "").toString().toLowerCase() === "turbo-stream") {
      const stream = await fetchResponse.text
      if (window.Turbo && typeof window.Turbo.renderStreamMessage === "function") {
        window.Turbo.renderStreamMessage(stream)
      }
    }

    return fetchResponse
  }
}

function request(method, url, options = {}) {
  return new FetchRequest(method, url, options).perform()
}

export function get(url, options = {}) {
  return request("get", url, options)
}

export function post(url, options = {}) {
  return request("post", url, options)
}

export function put(url, options = {}) {
  return request("put", url, options)
}

export function patch(url, options = {}) {
  return request("patch", url, options)
}

export function destroy(url, options = {}) {
  return request("delete", url, options)
}
