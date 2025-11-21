# frozen_string_literal: true

module Prodigi
  class Error < StandardError; end

  class BadRequestError < Error; end
  class UnauthorizedError < Error; end
  class ForbiddenError < Error; end
  class NotFoundError < Error; end
  class RateLimitError < Error; end
  class ServerError < Error; end
end
