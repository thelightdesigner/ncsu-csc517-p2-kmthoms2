# Volunteer Manager

## Setup

1. Install dependencies:
   - `bundle install`
2. Create and migrate the database:
   - `ruby bin/rails db:create`
   - `ruby bin/rails db:migrate`
3. Seed the preconfigured admin account:
   - `ruby bin/rails db:seed`
4. Run the server:
   - `ruby bin/rails server`

## Preconfigured Admin Account

- Username: `admin`
- Password: `12345`

The system supports exactly one admin account. The admin account cannot be deleted.

## Key Functionalities

### Volunteer signs up for an event

1. Log in as a volunteer on the **Log In** page.
2. Click **Available Events** in the navigation.
3. On the **Available Events** page, click the **Sign Up** button for an open event.
4. This creates a volunteer assignment with `pending` status for admin approval.

### Volunteer withdraws from an event

1. Log in as a volunteer.
2. Click **My Assignments** in the navigation.
3. On the **Events Assigned To Me** page, click the **Withdraw** button for that assignment.

### Admin creates a new event

1. Log in as an admin on the **Log In** page by choosing account type `Admin`.
2. Click **Events** in the navigation.
3. On the **All Events** page, click **Create New Event**.
4. Fill in event details and click **Create Event**.

### Admin logs volunteer hours

1. Log in as an admin.
2. Click **Assignments** in the navigation.
3. On the **All Volunteer Assignments** page, click **Log Hours** for an assignment.
4. Enter `hours_worked` and `date_logged`, then click **Save Hours**.

## Behavior Rules Implemented

- Event start time must be before end time.
- Required volunteer count must be greater than 0.
- Email addresses are validated for volunteers and admin.
- Required fields are validated for admin, volunteer, and event records.
- Hours worked must be non-negative and cannot exceed event duration.
- Only approved assignments can have hours logged.
- Volunteer sign-up creates `pending` assignments; admin must approve them.
- Event status is automatically maintained:
  - `full` when approved volunteers reach required count.
  - `open` when slots become available again.
- When a volunteer withdraws or an admin removes an assignment, the slot is released.
