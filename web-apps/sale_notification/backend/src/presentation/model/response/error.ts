interface Error {
  type: string;
  message: string;
}

enum ErrorType {
  INVALID_REQUEST = "INVALID_REQUEST",
}

export class InvalidRequestError implements Error {
  type = ErrorType.INVALID_REQUEST;
  message = "Invalid request parameter";
}
