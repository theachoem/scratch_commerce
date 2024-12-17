# README

This project is a Rails 8 e-commerce application built from scratch to simplify the codebase, avoid unnecessary abstractions, and help me fully understand and control every part of the system. It is largely inspired by concepts from Spree and Solidus but focuses on a cleaner, minimal implementation.

It leverages Rails 8 features without any external PaaS dependencies:

- SQLite is used as the database (instead of PostgreSQL or MySQL).
- Solid Queue replaces Sidekiq for background job processing.
- Solid Cache replaces Redis for caching.
- Authentication is implemented from scratch using Rails 8 Auth (instead of Devise).

## Setup
Follow these steps to get the project up and running:

1. Install Rails: Ensure Ruby & Rails 8 are installed with [official guide](https://guides.rubyonrails.org/install_ruby_on_rails.html).

    Note: Database, solid cache & solid queue are using sqlite. They are implemented as Rails gems, no additional setup is required for them. You only need to install Ruby & Rails.

2. Verify Installation: Run the following commands to confirm your setup:

    ```s
    $ ruby --version
    ruby 3.3.5 (2024-09-03 revision ef084cc8f4) [arm64-darwin23]

    $ rails --version
    Rails 8.0.1
    ```

3. Run the Project: Use the following command to start the development server:

    ```s
    $ bin/dev

    10:54:10 web.1  | started with pid 65490
    10:54:10 css.1  | started with pid 65491
    10:54:11 web.1  | => Booting Puma
    10:54:11 web.1  | => Rails 8.0.1 application starting in development 
    10:54:11 web.1  | => Run `bin/rails server --help` for more startup options
    10:54:11 web.1  | Puma starting in single mode...
    10:54:11 web.1  | * Puma version: 6.5.0 ("Sky's Version")
    10:54:11 web.1  | * Ruby version: ruby 3.3.5 (2024-09-03 revision ef084cc8f4) [arm64-darwin23]
    10:54:11 web.1  | *  Min threads: 3
    10:54:11 web.1  | *  Max threads: 3
    10:54:11 web.1  | *  Environment: development
    10:54:11 web.1  | *          PID: 65490
    10:54:11 web.1  | * Listening on http://127.0.0.1:3000
    10:54:11 web.1  | * Listening on http://[::1]:3000
    ```
4. Access the Application: Open your browser and go to http://127.0.0.1:3000 to view the app.

## References
- https://rubyonrails.org/2024/11/7/rails-8-no-paas-required