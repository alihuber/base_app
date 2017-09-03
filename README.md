# base_app
Model boilerplate Rails 5 application. Used just by me to tinker around and experiment with different Rails application architectures.

## Design goals
- Service-oriented (with the help of [active_interaction](https://github.com/orgsync/active_interaction))
- Make heavy use of engines, let each high-level use case live in its own engine
- Services are useable in different contexts
- RSpec tests live in main application, no engine-specific specs or dummy apps

## Features
- User session handling and authentication extracted into engine `base_auth`
- Functionality regarding user accounts (profile updates, password reset) extracted into engine `base_account`
- E-mail delivery extracted into generic mailer, living in engine `base_mailer`
- Embedded admin-only REST API on users living in engine `base_api`
- 2 API Authentication modes: JWT for external apps and traditional auth_token
- Site-specific AngularJS used for client-side form validation
- Admin backend for CRUD on users, also with the use of AngularJS
- Rudimentary use of ActionCable extracted into engine `base_messages`
- Admin can send messages to all users via websockets
- User/admin specific dashboards
- Friendly forwarding
- All Non-admin pages localized (de/en), language detection based on browser setting
- Test coverage ≈ 97%
- Selenium tests for testing AngularJS's form validation
