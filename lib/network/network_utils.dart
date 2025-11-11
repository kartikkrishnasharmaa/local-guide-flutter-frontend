String getErrorMessage(int? statusCode) {
  switch (statusCode) {
    case RESPONSE_OK:
      return "OK";
    case RESPONSE_CREATED:
      return "Created";
    case RES_NOT_FOUND:
      return "Resource Not Found";
    case RES_UNAUTHORIZED:
      return "Unauthorized";
    case RES_BLOCKED:
      return "Blocked";
    case RES_FORBIDDEN:
      return "Forbidden";
    case RESPONSE_NOT_FOUND:
      return "Bad Request: Resource Not Found";
    case RESPONSE_SERVER_ERROR:
      return "Internal Server Error";
    default:
      return "Unknown Error";
  }
}

const int RESPONSE_OK = 200;
const int RESPONSE_CREATED = 201;
const int RES_NOT_FOUND = 404;
const int RES_UNAUTHORIZED = 401;
const int RES_BLOCKED = 402;
const int RES_FORBIDDEN = 403;
const int RESPONSE_NOT_FOUND = 400;
const int RESPONSE_SERVER_ERROR = 500;