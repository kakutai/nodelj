local ffi  = require( "ffi" )

local libs = ffi_httpparser_lib or {
   OSX     = { x64 = "http-parser" },
   Windows = { x64 = "http-parser.dll"           },
   Linux   = { x64 = "http-parser.so"            , arm = "bin/Linux/http-parser.so"},
   BSD     = { x64 = "http-parser.so"            },
   POSIX   = { x64 = "http-parser.so"            },
   Other   = { x64 = "http-parser.so"            },
}

local lib  			= ffi_httpparser_lib or libs[ ffi.os ][ ffi.arch ]
local httpparser   	= ffi.load( lib )

ffi.cdef[[

/* Also update SONAME in the Makefile whenever you change these. */
static const int HTTP_PARSER_VERSION_MAJOR = 2;
static const int HTTP_PARSER_VERSION_MINOR = 9;
static const int HTTP_PARSER_VERSION_PATCH = 3;

typedef __int8 int8_t;
typedef unsigned __int8 uint8_t;
typedef __int16 int16_t;
typedef unsigned __int16 uint16_t;
typedef __int32 int32_t;
typedef unsigned __int32 uint32_t;
typedef __int64 int64_t;
typedef unsigned __int64 uint64_t;

/* Compile with -DHTTP_PARSER_STRICT=0 to make less checks, but run
 * faster
 */
static const int HTTP_PARSER_STRICT = 1;

/* Maximium header size allowed. If the macro is not defined
 * before including this header then the default is used. To
 * change the maximum header size, define the macro in the build
 * environment (e.g. -DHTTP_MAX_HEADER_SIZE=<value>). To remove
 * the effective limit on the size of the header, define the macro
 * to a very large number (e.g. -DHTTP_MAX_HEADER_SIZE=0x7fffffff)
 */
static const int HTTP_MAX_HEADER_SIZE = (80*1024);

typedef struct http_parser http_parser;
typedef struct http_parser_settings http_parser_settings;

/* Callbacks should return non-zero to indicate an error. The parser will
 * then halt execution.
 *
 * The one exception is on_headers_complete. In a HTTP_RESPONSE parser
 * returning '1' from on_headers_complete will tell the parser that it
 * should not expect a body. This is used when receiving a response to a
 * HEAD request which may contain 'Content-Length' or 'Transfer-Encoding:
 * chunked' headers that indicate the presence of a body.
 *
 * Returning `2` from on_headers_complete will tell parser that it should not
 * expect neither a body nor any futher responses on this connection. This is
 * useful for handling responses to a CONNECT request which may not contain
 * `Upgrade` or `Connection: upgrade` headers.
 *
 * http_data_cb does not return data chunks. It will be called arbitrarily
 * many times for each string. E.G. you might get 10 callbacks for "on_url"
 * each providing just a few characters more data.
 */
typedef int (*http_data_cb) (http_parser*, const char *at, size_t length);
typedef int (*http_cb) (http_parser*);


/* Status Codes */
static const int HTTP_STATUS_CONTINUE = 100;
static const int HTTP_STATUS_SWITCHING_PROTOCOLS = 101;
static const int HTTP_STATUS_PROCESSING = 102;
static const int HTTP_STATUS_OK = 200;
static const int HTTP_STATUS_CREATED = 201;
static const int HTTP_STATUS_ACCEPTED = 202;
static const int HTTP_STATUS_NON_AUTHORITATIVE_INFORMATION = 203;
static const int HTTP_STATUS_NO_CONTENT = 204;
static const int HTTP_STATUS_RESET_CONTENT = 205;
static const int HTTP_STATUS_PARTIAL_CONTENT = 206;
static const int HTTP_STATUS_MULTI_STATUS = 207;
static const int HTTP_STATUS_ALREADY_REPORTED = 208;
static const int HTTP_STATUS_IM_USED = 226;
static const int HTTP_STATUS_MULTIPLE_CHOICES = 300;
static const int HTTP_STATUS_MOVED_PERMANENTLY = 301;
static const int HTTP_STATUS_FOUND = 302;
static const int HTTP_STATUS_SEE_OTHER = 303;
static const int HTTP_STATUS_NOT_MODIFIED = 304;
static const int HTTP_STATUS_USE_PROXY = 305;
static const int HTTP_STATUS_TEMPORARY_REDIRECT = 307;
static const int HTTP_STATUS_PERMANENT_REDIRECT = 308;
static const int HTTP_STATUS_BAD_REQUEST = 400;
static const int HTTP_STATUS_UNAUTHORIZED = 401;
static const int HTTP_STATUS_PAYMENT_REQUIRED = 402;
static const int HTTP_STATUS_FORBIDDEN = 403;
static const int HTTP_STATUS_NOT_FOUND = 404;
static const int HTTP_STATUS_METHOD_NOT_ALLOWED = 405;
static const int HTTP_STATUS_NOT_ACCEPTABLE = 406;
static const int HTTP_STATUS_PROXY_AUTHENTICATION_REQUIRED = 407;
static const int HTTP_STATUS_REQUEST_TIMEOUT = 408;
static const int HTTP_STATUS_CONFLICT = 409;
static const int HTTP_STATUS_GONE = 410;
static const int HTTP_STATUS_LENGTH_REQUIRED = 411;
static const int HTTP_STATUS_PRECONDITION_FAILED = 412;
static const int HTTP_STATUS_PAYLOAD_TOO_LARGE = 413;
static const int HTTP_STATUS_URI_TOO_LONG = 414;
static const int HTTP_STATUS_UNSUPPORTED_MEDIA_TYPE = 415;
static const int HTTP_STATUS_RANGE_NOT_SATISFIABLE = 416;
static const int HTTP_STATUS_EXPECTATION_FAILED = 417;
static const int HTTP_STATUS_MISDIRECTED_REQUEST = 421;
static const int HTTP_STATUS_UNPROCESSABLE_ENTITY = 422;
static const int HTTP_STATUS_LOCKED = 423;
static const int HTTP_STATUS_FAILED_DEPENDENCY = 424;
static const int HTTP_STATUS_UPGRADE_REQUIRED = 426;
static const int HTTP_STATUS_PRECONDITION_REQUIRED = 428;
static const int HTTP_STATUS_TOO_MANY_REQUESTS = 429;
static const int HTTP_STATUS_REQUEST_HEADER_FIELDS_TOO_LARGE = 431;
static const int HTTP_STATUS_UNAVAILABLE_FOR_LEGAL_REASONS = 451;
static const int HTTP_STATUS_INTERNAL_SERVER_ERROR = 500;
static const int HTTP_STATUS_NOT_IMPLEMENTED = 501;
static const int HTTP_STATUS_BAD_GATEWAY = 502;
static const int HTTP_STATUS_SERVICE_UNAVAILABLE = 503;
static const int HTTP_STATUS_GATEWAY_TIMEOUT = 504;
static const int HTTP_STATUS_HTTP_VERSION_NOT_SUPPORTED = 505;
static const int HTTP_STATUS_VARIANT_ALSO_NEGOTIATES = 506;
static const int HTTP_STATUS_INSUFFICIENT_STORAGE = 507;
static const int HTTP_STATUS_LOOP_DETECTED = 508;
static const int HTTP_STATUS_NOT_EXTENDED = 510;
static const int HTTP_STATUS_NETWORK_AUTHENTICATION_REQUIRED = 511;

/* Request Methods */
static const int HTTP_DELETE = 0;
static const int HTTP_GET = 1;
static const int HTTP_HEAD = 2;
static const int HTTP_POST = 3;
static const int HTTP_PUT = 4;
  /* pathological */
static const int HTTP_CONNECT = 5;
static const int HTTP_OPTIONS = 6;
static const int HTTP_TRACE = 7;
  /* WebDAV */
static const int HTTP_COPY = 8;
static const int HTTP_LOCK = 9;
static const int HTTP_MKCOL = 10;
static const int HTTP_MOVE = 11;
static const int HTTP_PROPFIND = 12;
static const int HTTP_PROPPATCH = 13;
static const int HTTP_SEARCH = 14;
static const int HTTP_UNLOCK = 15;
static const int HTTP_BIND = 16;
static const int HTTP_REBIND = 17;
static const int HTTP_UNBIND = 18;
static const int HTTP_ACL = 19;
  /* subversion */
static const int HTTP_REPORT = 20;
static const int HTTP_MKACTIVITY = 21;
static const int HTTP_CHECKOUT = 22;
static const int HTTP_MERGE = 23;
  /* upnp */
static const int HTTP_MSEARCH = 24;
static const int HTTP_NOTIFY = 25;
static const int HTTP_SUBSCRIBE = 26;
static const int HTTP_UNSUBSCRIBE = 27;
  /* RFC-5789 */
static const int HTTP_PATCH = 28;
static const int HTTP_PURGE = 29;
  /* CalDAV */
static const int HTTP_MKCALENDAR = 30;
  /* RFC-2068, section 19.6.1.2 */
static const int HTTP_LINK = 31;
static const int HTTP_UNLINK = 32;
  /* icecast */
static const int HTTP_SOURCE = 33;

enum http_parser_type { HTTP_REQUEST, HTTP_RESPONSE, HTTP_BOTH };

/* Flag values for http_parser.flags field */
enum flags
  { F_CHUNKED               = 1 << 0
  , F_CONNECTION_KEEP_ALIVE = 1 << 1
  , F_CONNECTION_CLOSE      = 1 << 2
  , F_CONNECTION_UPGRADE    = 1 << 3
  , F_TRAILING              = 1 << 4
  , F_UPGRADE               = 1 << 5
  , F_SKIPBODY              = 1 << 6
  , F_CONTENTLENGTH         = 1 << 7
  , F_TRANSFER_ENCODING     = 1 << 8
  };


/* Map for errno-related constants
 *
 * The provided argument should be a macro that takes 2 arguments.
 */
enum http_errno {
  /* No error */
	HPE_OK,

  /* Callback-related errors */
	HPE_CB_message_begin,
	HPE_CB_url,
	HPE_CB_header_field,
	HPE_CB_header_value,
	HPE_CB_headers_complete,
	HPE_CB_body,
	HPE_CB_message_complete,
	HPE_CB_status,
	HPE_CB_chunk_header,
	HPE_CB_chunk_complete,

  /* Parsing-related errors */
	HPE_INVALID_EOF_STATE,
	HPE_HEADER_OVERFLOW,
	HPE_CLOSED_CONNECTION,
	HPE_INVALID_VERSION,
	HPE_INVALID_STATUS,
	HPE_INVALID_METHOD,
	HPE_INVALID_URL,
	HPE_INVALID_HOST,
	HPE_INVALID_PORT,
	HPE_INVALID_PATH,
	HPE_INVALID_QUERY_STRING,
	HPE_INVALID_FRAGMENT,
	HPE_LF_EXPECTED,
	HPE_INVALID_HEADER_TOKEN,
	HPE_INVALID_CONTENT_LENGTH,
	HPE_UNEXPECTED_CONTENT_LENGTH,
	HPE_INVALID_CHUNK_SIZE,
	HPE_INVALID_TRANSFER_ENCODING,
	HPE_INVALID_CONSTANT,
	HPE_INVALID_INTERNAL_STATE,
	HPE_STRICT,
	HPE_PAUSED,
	HPE_UNKNOWN
};

/* Get an http_errno value from an http_parser */
// #define HTTP_PARSER_ERRNO(p)            ((enum http_errno) (p)->http_errno)


struct http_parser {
  /** PRIVATE **/
  unsigned int type : 2;         /* enum http_parser_type */
  unsigned int state : 7;        /* enum state from http_parser.c */
  unsigned int header_state : 7; /* enum header_state from http_parser.c */
  unsigned int index : 7;        /* index into current matcher */
  unsigned int lenient_http_headers : 1;
  unsigned int flags : 16;       /* F_* values from 'flags' enum; semi-public */

  uint32_t nread;          /* # bytes read in various scenarios */
  uint64_t content_length; /* # bytes in body (0 if no Content-Length header) */

  /** READ-ONLY **/
  unsigned short http_major;
  unsigned short http_minor;
  unsigned int status_code : 16; /* responses only */
  unsigned int method : 8;       /* requests only */
  unsigned int http_errno : 7;

  /* 1 = Upgrade header was present and the parser has exited because of that.
   * 0 = No upgrade header present.
   * Should be checked when http_parser_execute() returns in addition to
   * error checking.
   */
  unsigned int upgrade : 1;

  /** PUBLIC **/
  void *data; /* A pointer to get hook to the "connection" or "socket" object */
};


struct http_parser_settings {
  http_cb      on_message_begin;
  http_data_cb on_url;
  http_data_cb on_status;
  http_data_cb on_header_field;
  http_data_cb on_header_value;
  http_cb      on_headers_complete;
  http_data_cb on_body;
  http_cb      on_message_complete;
  /* When on_chunk_header is called, the current chunk length is stored
   * in parser->content_length.
   */
  http_cb      on_chunk_header;
  http_cb      on_chunk_complete;
};


enum http_parser_url_fields
  { UF_SCHEMA           = 0
  , UF_HOST             = 1
  , UF_PORT             = 2
  , UF_PATH             = 3
  , UF_QUERY            = 4
  , UF_FRAGMENT         = 5
  , UF_USERINFO         = 6
  , UF_MAX              = 7
  };


/* Result structure for http_parser_parse_url().
 *
 * Callers should index into field_data[] with UF_* values iff field_set
 * has the relevant (1 << UF_*) bit set. As a courtesy to clients (and
 * because we probably have padding left over), we convert any port to
 * a uint16_t.
 */
struct http_parser_url {
  uint16_t field_set;           /* Bitmask of (1 << UF_*) values */
  uint16_t port;                /* Converted UF_PORT string */

  struct {
    uint16_t off;               /* Offset into buffer in which field starts */
    uint16_t len;               /* Length of run in buffer */
  } field_data[UF_MAX];
};

/* Returns the library version. Bits 16-23 contain the major version number,
 * bits 8-15 the minor version number and bits 0-7 the patch level.
 * Usage example:
 *
 *   unsigned long version = http_parser_version();
 *   unsigned major = (version >> 16) & 255;
 *   unsigned minor = (version >> 8) & 255;
 *   unsigned patch = version & 255;
 *   printf("http_parser v%u.%u.%u\n", major, minor, patch);
 */
unsigned long http_parser_version(void);

void http_parser_init(http_parser *parser, enum http_parser_type type);


/* Initialize http_parser_settings members to 0
 */
void http_parser_settings_init(http_parser_settings *settings);


/* Executes the parser. Returns number of parsed bytes. Sets
 * `parser->http_errno` on error. */
size_t http_parser_execute(http_parser *parser,
                           const http_parser_settings *settings,
                           const char *data,
                           size_t len);


/* If http_should_keep_alive() in the on_headers_complete or
 * on_message_complete callback returns 0, then this should be
 * the last message on the connection.
 * If you are the server, respond with the "Connection: close" header.
 * If you are the client, close the connection.
 */
int http_should_keep_alive(const http_parser *parser);

/* Returns a string version of the HTTP method. */
const char *http_method_str(enum http_method m);

/* Returns a string version of the HTTP status code. */
const char *http_status_str(enum http_status s);

/* Return a string name of the given error */
const char *http_errno_name(enum http_errno err);

/* Return a string description of the given error */
const char *http_errno_description(enum http_errno err);

/* Initialize all http_parser_url members to 0 */
void http_parser_url_init(struct http_parser_url *u);

/* Parse a URL; return nonzero on failure */
int http_parser_parse_url(const char *buf, size_t buflen,
                          int is_connect,
                          struct http_parser_url *u);

/* Pause or un-pause the parser; a nonzero value pauses */
void http_parser_pause(http_parser *parser, int paused);

/* Checks if this is the final chunk of the body. */
int http_body_is_final(const http_parser *parser);

/* Change the maximum header size provided at compile time. */
void http_parser_set_max_header_size(uint32_t size);

]]

return httpparser