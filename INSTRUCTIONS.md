# Glucose Metric Calculator

Thank you for participating in our take-home interview exercise. This project is designed to let you show off your skills in developing a real world application. We understand that your time is valuable, so we recommend that you spend no more than two hours on this assignment. Focus on demonstrating your thought process and approach, even if you do not completely finish the task. It's perfectly acceptable to leave parts of the assignment unfinished. Prioritize quality over quantity in your submission.

## Guidelines
1. Complete this exercise independently.
2. Use any tools and resources you typically use in your daily work. This includes AI coding assistants like GitHub Copilot or ChatGPT. Please include a summary of your prompts your submission.
3. Please don’t spend more than 2 hours working on this exercise.
4. Completion of this assignment is not required. Please focus on quality rather than finishing every task.
5. Utilize this repository for building the required components.

## Project Overview
Continuous glucose monitoring generates a series of data points representing a person's glucose levels over time. Your goal is to create a full-stack application that calculates and displays glucose metrics from a member’s glucose data. This information will help health coaches make informed decisions about member’s care.

## Requirements
Develop a full-stack application that features a glucose metrics dashboard. The application should calculate and display the following glucose metrics for a given time period:
- Average glucose level
- Time below range
- Time above range

Each metric should be calculated for two different time frames: 
- The last 7 days
- The current calendar month

Additionally, the application should calculate the change in each metric from the prior period. For example, this includes comparing this month's average glucose level to last month's. Please refer to the definitions provided below for clarity on each metric.

## Definitions
- **Average Glucose (mg/dL):** The sum of all glucose values in a specific time frame (week/month) divided by the total number of readings available in that time frame.
- **Time Above Range (%):** The percentage of glucose readings in a specific time frame (week/month) that are above 180 mg/dL.
- **Time Below Range (%):** The percentage of glucose readings in a specific time frame (week/month) that are below 70 mg/dL. 
- **Last 7 Days:** The “Last 7 days” includes available glucose data from 12:00:00am to 11:59:59pm local time on the current day and the 6 prior days. 
- **Month:** A “month” of glucose data includes all available glucose readings from 12:00:00am local time on the first day of a calendar month to 11:59:59pm local time on the last day of that calendar month.
- **Change Since Prior Period (% or mg/dL):** The difference between a metric for the current time frame vs. the previous time frame (for example this month’s time in range compared to last month’s). Obtained by subtracting the current metric from the previous one. If the metrics being compared are percentages, the change will also be shown as a percentage.

## Technical Requirements
- Build this application using Ruby and Ruby on Rails.
- For the purpose of this exercise, use any active record compatible database. 
- Each metric should be associated with the member it was calculated for.
- Bonus:
  - Implement an API that can return metrics for a given member and time frame.
  - Consider caching strategies for performance enhancement.

## What We Are Looking For
Here’s what we value in this assignment:
- Functionality as outlined above.
- Best practices and clean, maintainable code.
- If you make any assumptions, please document them in your README.
- Highlight any improvements you’d make with more time in your README. You’ll have the chance to discuss these during the next onsite interview.

## Submission Guidelines
- Project Setup:
  - Set up your local development environment as needed.
  - Commit all changes to this repository.
- Submit Your Work:
  - Once your solution is complete and you’re ready to submit it, please create a Merge Request (Pull Request) against this repository.
  - Export AI prompt summaries and include them in the README file.
    - ChatGPT prompts can be exported to markdown (.md) format by clicking export in the top right corner of the chat window
    - Cursor prompts can be exported using https://github.com/thomas-pedersen/cursor-chat-browser
  - Email your submission to interview-submissions@omadahealth.com, cc'ing the recruiting team.
  - **Timeline: You have 3 days to complete and submit the assignment.** If you have questions or need assistance, contact interview-submissions@omadahealth.com.

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

The application uses React for the frontend with esbuild for bundling. Key files and directories:

- `app/javascript/application.js` - Main JavaScript entry point
- `app/javascript/application/` - React components directory
- `app/assets/builds/` - Compiled JavaScript assets

#### Building JavaScript Assets

For development with automatic rebuilding:
```bash
yarn build:watch
```

The watch mode will automatically rebuild your JavaScript assets whenever you make changes to your React components or JavaScript files.

### Testing

The project uses RSpec for testing. To run the test suite:

```bash
bundle exec rspec
```
