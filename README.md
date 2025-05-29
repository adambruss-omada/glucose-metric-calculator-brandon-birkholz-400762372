# Glucose Metrics Calculator

## Design considerations

#### Authentication

I've deliberately kept the Member model and authentication light, as I considered it out of scope for this project. Authentication of API requests is done via JWTs that contain a Member id. JWTs keep the solution simple, since we don't need to store a record in the database of a user's session.
This way, we can use the authenticated Member to look up their associated glucose metrics. Registration, Login, and Logout are assumed, but omitted. Tests generate a JWT as needed. The frontend uses a hardcoded JWT.

#### Wider feature scope

Submitting glucose measurements is assumed, but considered out of scope.

#### Frontend

Given that my conversation with Adam indicated that frontend is a low priority for his team, I've kept the frontend very simple, with standard unstyled HTML.

#### Caching

_Because caching is always a matter of choosing performance at some tradeoff, I've explained some options below for potential future implementation._

Glucose measurements are assumed to be immutable, append-only, and uploaded automatically at the time of measurement. This means measurements are a time-series and can be cached in Postgres with a Block Range Index. Without a deep understanding of typical measurement cadence, I'm assuming the heaviest use case: a type 1 diabetic would measure at most 10 times a day, meaning 70 measurements in a week, 300 in a month. So the BRIN page size might be 70, as an example:

```sql
CREATE INDEX glucose_levels_tested_at_brin_idx
    ON glucose_levels
 USING BRIN (tested_at)
  WITH (pages_per_range = 70);
```

Additionally, a request-level cache that bypasses the entire application and database would be very simple. The cache could use a compound key of the `member_id` and `tested_at:date`. The only cache that would ever need to be invalidated would be the current date, when a new measurement is added. This would require restructuring the application to do the calculations client-side, and having the API return measurements grouped by date.

## Future improvements

- Uploading glucose measurements
- Viewing a list of all glucose measurements used in the calculations
- Graphs or other visual representations of measurements over time
- Member Login/Logout/Registration
- Member profiles
- Expiring JWTs, refresh tokens
- Frontend styling

## Cursor prompts

I was unable to use cursor-chat-browser to export my prompts as it was having runtime errors reading my cursor history. I suspect this might be a result of the major changes to Cursor recently, and that cursor-chat-browser hasn't been updated in a month.

So below are the prompts I gave Cursor during development:

```
Given the instructions in INSTRUCTIONS.md, write a new service for retrieving the glucose reading calculations. The service's methods should accept a Member and a time frame (week or month).
```

```
Write RSpec tests for the GlucoseMetricsService
```

```
Write a new API route that takes a time frame (week or month) and returns the metrics returned by the GlucoseMetricsService. The Member of the metrics is the Member making the API request, identified by the Authorization header containing a JWT.
```

```
Move JWT generation and decoding to a new Auth service
```

```
Update index.jsx with an option to select either week or month for the glucose metrics
```

```
Update the API request to use a JWT for authentication
```

```
Login and logout are out of scope for this. We'll use a hardcoded JWT for authentication with the API.
```

```
Update GlucoseMetricsService to also calculate the change in each metric compared to the previous period (for example, if the time period is "week", then it should calculate the change from the previous week)
```

```
Update index.jsx to display the change from previous period also
```

```
Use a table to display the metrics
```

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
