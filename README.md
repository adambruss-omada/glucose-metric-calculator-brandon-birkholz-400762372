# Glucose Metrics Calculator

## Design considerations

I've deliberately kept the Member model and authentication light, as I considered it out of scope for this project. Authentication of API requests is done via JWTs that contain a Member id.
This way, we can use the authenticated Member to look up their associated glucose metrics. Registration, Login, and Logout are assumed, but omitted. Tests generate a JWT as needed. The frontend uses a hardcoded JWT.

Submitting glucose measurements is also considered out of scope.

## Cursor prompts

## Prerequisites

- Ruby 3.1.3
- Rails 7.1.5
- Node.js 18 or higher
- Yarn package manager
- SQLite3
- Bundler

## Technology Stack

- **Backend**: Ruby on Rails 7.1.5
- **Frontend**: React 19
- **Database**: SQLite3
- **JavaScript Bundler**: esbuild
- **Testing**: RSpec, Factory Bot

## Setup

### Local Development Setup

1. Install Ruby dependencies:

```bash
bundle install
```

2. Install JavaScript dependencies:

```bash
yarn install
```

3. Build JavaScript assets:

```bash
yarn build
```

4. Set up the database:

```bash
bundle exec rails db:create db:setup db:seed
```

5. Start the development server:

```bash
bin/dev
```

The application will be available at `http://localhost:3000`

## Development

### Frontend Development

For development with automatic rebuilding:

```bash
yarn build:watch
```

### Testing

The project uses RSpec for testing. To run the test suite:

```bash
bundle exec rspec
```
