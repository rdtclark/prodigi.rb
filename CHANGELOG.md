## [1.0.0] - 2025-11-21

### Breaking Changes
- Minimum Ruby version now 3.1+ (was 2.6+)
- Upgraded to Faraday 2.x (removed `faraday_middleware`)

### Added
- GitHub Actions CI with multi-version Ruby testing
- YARD documentation
- Specific error classes for better error handling:
  - `BadRequestError` for 400 responses
	- `UnauthorizedError` for 401 responses
	- `ForbiddenError` for 403 responses
	- `NotFoundError` for 404 responses
	- `RateLimitError` for 429 responses
	- `ServerError` for 5xx responses

### Changed
- Upgraded dependencies (rake, minitest, rubocop)
- Improved code quality and reduced complexity
- Enhanced test suite organization

## [0.1.0] - 2022-01-16

- Initial release
