# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a CFML (ColdFusion Markup Language) library for interacting with the Notifuse API. It's designed to work with both Lucee and ColdFusion engines and can be used as a standalone component or as a ColdBox module.

- **Main component**: [notifuse.cfc](notifuse.cfc) - The core API wrapper
- **Module configuration**: [ModuleConfig.cfc](ModuleConfig.cfc) - ColdBox module setup
- **CFML Engine**: Lucee 7 (configured in [server.json](server.json))
- **Package Manager**: CommandBox (configured in [box.json](box.json))

## Commands

### Development Server
```bash
# Start the local development server (runs on port 45000 by default)
box server start

# Stop the server
box server stop
```

### Testing
```bash
# Run all tests via CommandBox
box testbox run

# Run tests via HTTP (server must be running)
# Visit: http://127.0.0.1:45000/tests/runner.cfm

# Run specific test bundles
# Visit: http://127.0.0.1:45000/tests/runner.cfm?bundles=tests.specs.contactsSpec

# Run tests with different reporters (simple, json, xml, etc.)
# Visit: http://127.0.0.1:45000/tests/runner.cfm?reporter=json
```

### Code Formatting
```bash
# Format all code files (overwrites files)
box run-script format

# Check formatting without modifying files
box run-script format:check
```

### Dependency Management
```bash
# Install all dependencies
box install

# Update dependencies
box update
```

## Architecture

### API Client Structure

The [notifuse.cfc](notifuse.cfc) component follows a consistent pattern for all API interactions:

1. **Initialization** ([notifuse.cfc:5-40](notifuse.cfc#L5-L40)):
   - API key can be provided via constructor argument, environment variable `SENDGRID_API_KEY`, or Java system property
   - Base URL defaults to `https://demo.notifuse.com`
   - HTTP timeout configurable (default: 50 seconds)

2. **Public API Methods**: Each Notifuse API endpoint has a corresponding method (e.g., `transactionalSend()`, `contactsList()`, `contactsUpsert()`)
   - These methods handle parameter validation and transformation
   - They construct the appropriate request structure
   - They call the private `apiCall()` method

3. **Private HTTP Layer** ([notifuse.cfc:175-222](notifuse.cfc#L175-L222)):
   - `apiCall()`: Orchestrates the HTTP request and response handling
   - `makeHttpRequest()`: Executes the actual HTTP call using cfhttp
   - `getBaseHttpHeaders()`: Provides standard headers including Bearer token authentication

4. **Utility Methods** ([notifuse.cfc:265-331](notifuse.cfc#L265-L331)):
   - `parseHeaders()`: Converts header struct to array format
   - `parseQueryParams()`: Builds URL query strings with proper encoding
   - `parseBody()`: Serializes request bodies to JSON
   - `encodeUrl()`: Custom URL encoding implementation

### ColdBox Module Integration

The [ModuleConfig.cfc](ModuleConfig.cfc) enables this library to work as a ColdBox module:
- Registers the `notifuse` component as a singleton in WireBox
- Maps settings for `apiKey` and `baseUrl`
- Uses the module namespace `notifusecfml`

### Testing Infrastructure

Tests are located in [tests/specs/](tests/specs/) and use the TestBox BDD framework:

- **Test Application**: [tests/Application.cfc](tests/Application.cfc) sets up mappings for `/notifusecfml`, `/testbox`, `/coldbox`
- **Test Runner**: [tests/runner.cfm](tests/runner.cfm) executes tests with coverage reporting
- **Test Structure**: All specs extend `testbox.system.BaseSpec` and use BDD syntax (`describe`, `it`, `expect`)
- **Mocking**: Tests use TestBox's MockBox to mock HTTP responses (see [tests/specs/contactsSpec.cfc:8-21](tests/specs/contactsSpec.cfc#L8-L21) for the pattern)

Common test pattern:
```cfml
var notifuse = new notifuse( 'fake_key', 'https://demo.notifuse.com/' );
var httpService = getProperty( notifuse, 'httpService' );
prepareMock( httpService );
httpService.$( 'exec', { /* mock response */ } );
```

### API Method Patterns

When adding new API endpoints to [notifuse.cfc](notifuse.cfc), follow these patterns:

1. **GET requests with query parameters**: See `contactsList()` ([notifuse.cfc:66-115](notifuse.cfc#L66-L115))
   - Build `params` struct with query parameters
   - Call `apiCall( 'GET', '/endpoint', params, {}, {} )`

2. **POST requests with body**: See `contactsUpsert()` ([notifuse.cfc:126-172](notifuse.cfc#L126-L172))
   - Build `params` struct with request body structure
   - Call `apiCall( 'POST', '/endpoint', {}, params, {} )`

3. **Optional parameters**: Only include in request if provided
   - Use `if ( len( arguments.field ) )` for optional strings
   - Use `if ( arguments.struct.keyExists( 'field' ) )` for optional struct keys

## Code Style

This project uses CFFormat for code formatting. Configuration is in [.cfformat.json](.cfformat.json):
- **Indentation**: Tabs (indent_size: 2)
- **Max line length**: 120 characters
- **Quotes**: Double quotes for strings and attributes
- **Alignment**: Consecutive assignments, properties, and parameters are aligned
- **Function calls**: Built-in functions use cfdocs casing, user-defined use camelCase

When writing CFML code:
- Use component-based syntax (not tag-based) for .cfc files
- Follow the existing parameter naming patterns (snake_case for API parameters, camelCase for internal variables)
- Add descriptive tests for any new API methods
