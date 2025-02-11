/// Redirect information.
abstract interface class RedirectInfo {
  /// Returns the status code used for the redirect.
  int get statusCode;

  /// Returns the method used for the redirect.
  String get method;

  /// Returns the location for the redirect.
  Uri get location;
}

abstract interface class HttpClientResponse implements Stream<List<int>> {
  /// Returns the status code.
  ///
  /// The status code must be set before the body is written
  /// to. Setting the status code after writing to the body will throw
  /// a `StateError`.
  int get statusCode;

  /// Returns the reason phrase associated with the status code.
  ///
  /// The reason phrase must be set before the body is written
  /// to. Setting the reason phrase after writing to the body will throw
  /// a `StateError`.
  String get reasonPhrase;

  /// Returns the content length of the response body. Returns -1 if the size of
  /// the response body is not known in advance.
  ///
  /// If the content length needs to be set, it must be set before the
  /// body is written to. Setting the content length after writing to the body
  /// will throw a `StateError`.
  int get contentLength;

  // /// The compression state of the response.
  // ///
  // /// This specifies whether the response bytes were compressed when they were
  // /// received across the wire and whether callers will receive compressed
  // /// or uncompressed bytes when they listed to this response's byte stream.
  // @Since("2.4")
  // HttpClientResponseCompressionState get compressionState;

  /// Gets the persistent connection state returned by the server.
  ///
  /// If the persistent connection state needs to be set, it must be
  /// set before the body is written to. Setting the persistent connection state
  /// after writing to the body will throw a `StateError`.
  bool get persistentConnection;

  /// Returns whether the status code is one of the normal redirect
  /// codes [HttpStatus.movedPermanently], [HttpStatus.found],
  /// [HttpStatus.movedTemporarily], [HttpStatus.seeOther] and
  /// [HttpStatus.temporaryRedirect].
  bool get isRedirect;

  /// Returns the series of redirects this connection has been through. The
  /// list will be empty if no redirects were followed. [redirects] will be
  /// updated both in the case of an automatic and a manual redirect.
  List<RedirectInfo> get redirects;

  /// Redirects this connection to a new URL. The default value for
  /// [method] is the method for the current request. The default value
  /// for [url] is the value of the [HttpHeaders.locationHeader] header of
  /// the current response. All body data must have been read from the
  /// current response before calling [redirect].
  ///
  /// All headers added to the request will be added to the redirection
  /// request. However, any body sent with the request will not be
  /// part of the redirection request.
  ///
  /// If [followLoops] is set to `true`, redirect will follow the redirect,
  /// even if the URL was already visited. The default value is `false`.
  ///
  /// The method will ignore [HttpClientRequest.maxRedirects]
  /// and will always perform the redirect.
  Future<HttpClientResponse> redirect(
      [String? method, Uri? url, bool? followLoops]);

  /// Returns the client response headers.
  ///
  /// The client response headers are immutable.
  HttpHeaders get headers;

  // /// Detach the underlying socket from the HTTP client. When the
  // /// socket is detached the HTTP client will no longer perform any
  // /// operations on it.
  // ///
  // /// This is normally used when a HTTP upgrade is negotiated and the
  // /// communication should continue with a different protocol.
  // Future<Socket> detachSocket();

  // /// Cookies set by the server (from the 'set-cookie' header).
  // List<Cookie> get cookies;

  // /// Returns the certificate of the HTTPS server providing the response.
  // /// Returns null if the connection is not a secure TLS or SSL connection.
  // X509Certificate? get certificate;

  // /// Gets information about the client connection. Returns `null` if the socket
  // /// is not available.
  // HttpConnectionInfo? get connectionInfo;
}

/// Headers for HTTP requests and responses.
///
/// In some situations, headers are immutable:
///
/// * [HttpRequest] and [HttpClientResponse] always have immutable headers.
///
/// * [HttpResponse] and [HttpClientRequest] have immutable headers
///   from the moment the body is written to.
///
/// In these situations, the mutating methods throw exceptions.
///
/// For all operations on HTTP headers the header name is
/// case-insensitive.
///
/// To set the value of a header use the `set()` method:
///
///     request.headers.set(HttpHeaders.cacheControlHeader,
///                         'max-age=3600, must-revalidate');
///
/// To retrieve the value of a header use the `value()` method:
///
///     print(request.headers.value(HttpHeaders.userAgentHeader));
///
/// An `HttpHeaders` object holds a list of values for each name
/// as the standard allows. In most cases a name holds only a single value,
/// The most common mode of operation is to use `set()` for setting a value,
/// and `value()` for retrieving a value.
abstract interface class HttpHeaders {
  static const acceptHeader = "accept";
  static const acceptCharsetHeader = "accept-charset";
  static const acceptEncodingHeader = "accept-encoding";
  static const acceptLanguageHeader = "accept-language";
  static const acceptRangesHeader = "accept-ranges";
  static const accessControlAllowCredentialsHeader =
      'access-control-allow-credentials';
  static const accessControlAllowHeadersHeader = 'access-control-allow-headers';
  static const accessControlAllowMethodsHeader = 'access-control-allow-methods';
  static const accessControlAllowOriginHeader = 'access-control-allow-origin';
  static const accessControlExposeHeadersHeader =
      'access-control-expose-headers';
  static const accessControlMaxAgeHeader = 'access-control-max-age';
  static const accessControlRequestHeadersHeader =
      'access-control-request-headers';
  static const accessControlRequestMethodHeader =
      'access-control-request-method';
  static const ageHeader = "age";
  static const allowHeader = "allow";
  static const authorizationHeader = "authorization";
  static const cacheControlHeader = "cache-control";
  static const connectionHeader = "connection";
  static const contentEncodingHeader = "content-encoding";
  static const contentLanguageHeader = "content-language";
  static const contentLengthHeader = "content-length";
  static const contentLocationHeader = "content-location";
  static const contentMD5Header = "content-md5";
  static const contentRangeHeader = "content-range";
  static const contentTypeHeader = "content-type";
  static const dateHeader = "date";
  static const etagHeader = "etag";
  static const expectHeader = "expect";
  static const expiresHeader = "expires";
  static const fromHeader = "from";
  static const hostHeader = "host";
  static const ifMatchHeader = "if-match";
  static const ifModifiedSinceHeader = "if-modified-since";
  static const ifNoneMatchHeader = "if-none-match";
  static const ifRangeHeader = "if-range";
  static const ifUnmodifiedSinceHeader = "if-unmodified-since";
  static const lastModifiedHeader = "last-modified";
  static const locationHeader = "location";
  static const maxForwardsHeader = "max-forwards";
  static const pragmaHeader = "pragma";
  static const proxyAuthenticateHeader = "proxy-authenticate";
  static const proxyAuthorizationHeader = "proxy-authorization";
  static const rangeHeader = "range";
  static const refererHeader = "referer";
  static const retryAfterHeader = "retry-after";
  static const serverHeader = "server";
  static const teHeader = "te";
  static const trailerHeader = "trailer";
  static const transferEncodingHeader = "transfer-encoding";
  static const upgradeHeader = "upgrade";
  static const userAgentHeader = "user-agent";
  static const varyHeader = "vary";
  static const viaHeader = "via";
  static const warningHeader = "warning";
  static const wwwAuthenticateHeader = "www-authenticate";
  static const contentDisposition = "content-disposition";

  // Cookie headers from RFC 6265.
  static const cookieHeader = "cookie";
  static const setCookieHeader = "set-cookie";

  static const generalHeaders = [
    cacheControlHeader,
    connectionHeader,
    dateHeader,
    pragmaHeader,
    trailerHeader,
    transferEncodingHeader,
    upgradeHeader,
    viaHeader,
    warningHeader
  ];

  static const entityHeaders = [
    allowHeader,
    contentEncodingHeader,
    contentLanguageHeader,
    contentLengthHeader,
    contentLocationHeader,
    contentMD5Header,
    contentRangeHeader,
    contentTypeHeader,
    expiresHeader,
    lastModifiedHeader
  ];

  static const responseHeaders = [
    acceptRangesHeader,
    ageHeader,
    etagHeader,
    locationHeader,
    proxyAuthenticateHeader,
    retryAfterHeader,
    serverHeader,
    varyHeader,
    wwwAuthenticateHeader,
    contentDisposition
  ];

  static const requestHeaders = [
    acceptHeader,
    acceptCharsetHeader,
    acceptEncodingHeader,
    acceptLanguageHeader,
    authorizationHeader,
    expectHeader,
    fromHeader,
    hostHeader,
    ifMatchHeader,
    ifModifiedSinceHeader,
    ifNoneMatchHeader,
    ifRangeHeader,
    ifUnmodifiedSinceHeader,
    maxForwardsHeader,
    proxyAuthorizationHeader,
    rangeHeader,
    refererHeader,
    teHeader,
    userAgentHeader
  ];

  /// The date specified by the [dateHeader] header, if any.
  DateTime? date;

  /// The date and time specified by the [expiresHeader] header, if any.
  DateTime? expires;

  /// The date and time specified by the [ifModifiedSinceHeader] header, if any.
  DateTime? ifModifiedSince;

  /// The value of the [hostHeader] header, if any.
  String? host;

  /// The value of the port part of the [hostHeader] header, if any.
  int? port;

  /// The [ContentType] of the [contentTypeHeader] header, if any.
  // ContentType? contentType;

  /// The value of the [contentLengthHeader] header, if any.
  ///
  /// The value is negative if there is no content length set.
  int contentLength = -1;

  /// Whether the connection is persistent (keep-alive).
  late bool persistentConnection;

  /// Whether the connection uses chunked transfer encoding.
  ///
  /// Reflects and modifies the value of the [transferEncodingHeader] header.
  late bool chunkedTransferEncoding;

  /// The values for the header named [name].
  ///
  /// Returns null if there is no header with the provided name,
  /// otherwise returns a new list containing the current values.
  /// Not that modifying the list does not change the header.
  List<String>? operator [](String name);

  /// Convenience method for the value for a single valued header.
  ///
  /// The value must not have more than one value.
  ///
  /// Returns `null` if there is no header with the provided name.
  String? value(String name);

  /// Adds a header value.
  ///
  /// The header named [name] will have a string value derived from [value]
  /// added to its list of values.
  ///
  /// Some headers are single valued, and for these, adding a value will
  /// replace a previous value. If the [value] is a [DateTime], an
  /// HTTP date format will be applied. If the value is an [Iterable],
  /// each element will be added separately. For all other
  /// types the default [Object.toString] method will be used.
  ///
  /// Header names are converted to lower-case unless
  /// [preserveHeaderCase] is set to true. If two header names are
  /// the same when converted to lower-case, they are considered to be
  /// the same header, with one set of values.
  ///
  /// The current case of the a header name is that of the name used by
  /// the last [set] or [add] call for that header.
  void add(String name, Object value, {bool preserveHeaderCase = false});

  /// Sets the header [name] to [value].
  ///
  /// Removes all existing values for the header named [name] and
  /// then [add]s [value] to it.
  void set(String name, Object value, {bool preserveHeaderCase = false});

  /// Removes a specific value for a header name.
  ///
  /// Some headers have system supplied values which cannot be removed.
  /// For all other headers and values, the [value] is converted to a string
  /// in the same way as for [add], then that string value is removed from the
  /// current values of [name].
  /// If there are no remaining values for [name], the header is no longer
  /// considered present.
  void remove(String name, Object value);

  /// Removes all values for the specified header name.
  ///
  /// Some headers have system supplied values which cannot be removed.
  /// All other values for [name] are removed.
  /// If there are no remaining values for [name], the header is no longer
  /// considered present.
  void removeAll(String name);

  /// Performs the [action] on each header.
  ///
  /// The [action] function is called with each header's name and a list
  /// of the header's values. The casing of the name string is determined by
  /// the last [add] or [set] operation for that particular header,
  /// which defaults to lower-casing the header name unless explicitly
  /// set to preserve the case.
  void forEach(void Function(String name, List<String> values) action);

  /// Disables folding for the header named [name] when sending the HTTP header.
  ///
  /// By default, multiple header values are folded into a
  /// single header line by separating the values with commas.
  ///
  /// The 'set-cookie' header has folding disabled by default.
  void noFolding(String name);

  /// Removes all headers.
  ///
  /// Some headers have system supplied values which cannot be removed.
  /// All other header values are removed, and header names with not
  /// remaining values are no longer considered present.
  void clear();
}
