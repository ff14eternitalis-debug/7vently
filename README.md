# Eventbrite Lyon

![Ruby](https://img.shields.io/badge/Ruby-3.4.2-CC342D?style=flat&logo=ruby&logoColor=white)
![Rails](https://img.shields.io/badge/Rails-8.1.2-CC0000?style=flat&logo=rubyonrails&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-4169E1?style=flat&logo=postgresql&logoColor=white)
![Bootstrap](https://img.shields.io/badge/Bootstrap-5.3.3-7952B3?style=flat&logo=bootstrap&logoColor=white)
![Devise](https://img.shields.io/badge/Devise-auth-2E3440?style=flat&logo=ruby&logoColor=white)
![Stripe](https://img.shields.io/badge/Stripe-payments-635BFF?style=flat&logo=stripe&logoColor=white)
![Active Storage](https://img.shields.io/badge/Active%20Storage-uploads-CC0000?style=flat&logo=rubyonrails&logoColor=white)
![PWA](https://img.shields.io/badge/PWA-Rails%208%20native-5A0FC8?style=flat&logo=pwa&logoColor=white)

A city-focused event management platform built with Ruby on Rails. Users can create events, browse upcoming events, and register for them. The application includes a full authentication system, Stripe payments, file uploads, automated email notifications, an admin dashboard, and a Progressive Web App (PWA) setup.

## Features

### Implemented

- Browse all validated upcoming events on the home page (card grid with photos)
- User registration and authentication (Devise) with Bootstrap-styled forms
- Create, edit and delete events (title, description, date, duration, price, location, photo)
- Event photo upload (required) via Active Storage — displayed in index cards and show page
- User profile page: avatar, bio, list of organized events with validation status badges
- Edit profile (first name, last name, description, avatar) separately from account credentials
- User avatar upload via Active Storage — DiceBear API fallback (deterministic per email)
- Register for paid events via Stripe Checkout Session
- Register for free events directly (no payment required)
- Organizer dashboard: attendee list per event with registration date
- Event validation system: new events are pending until an admin approves or rejects them
- Admin dashboard (`/admin`) — restricted to admin users:
  - Manage users (view, edit, delete, toggle admin role)
  - Review and approve/reject event submissions (with email notification to organizer)
  - Manage all events (view, edit, delete, change validation status)
- Automated email notifications via Action Mailer (Gmail SMTP in production)
- Progressive Web App (PWA) support via Rails 8 native service worker + manifest
- Dark theme UI with Modern Business template (Bootstrap 5.3.3)
- Flash messages (success / error) displayed in the navbar area

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Ruby 3.4.2 |
| Framework | Rails 8.1.2 |
| Database | PostgreSQL |
| Authentication | Devise |
| UI Framework | Bootstrap 5.3.3 + Modern Business template (Propshaft) |
| PWA | Rails 8 native (service worker + manifest) |
| Payments | Stripe Checkout Session |
| File uploads | Active Storage (local disk in dev/prod) |
| Image processing | image_processing (~> 1.2) |
| Emails | Action Mailer + Gmail SMTP |
| Dev email preview | letter_opener_web |
| Environment variables | dotenv-rails |

## Database Schema

![ERD Diagram](public/Projet%20validant%2024_02_2026%207evently.png)

### User
| Column | Type | Notes |
|---|---|---|
| `email` | string | not null, default: "" |
| `encrypted_password` | string | not null, default: "" |
| `first_name` | string | |
| `last_name` | string | |
| `description` | text | |
| `admin` | boolean | default: false — grants access to `/admin` |
| `avatar` | attachment | via Active Storage (optional, DiceBear fallback) |

### Event
| Column | Type | Notes |
|---|---|---|
| `title` | string | 5–140 chars |
| `description` | text | 20–1000 chars |
| `start_date` | datetime | must be in the future |
| `duration` | integer | in minutes, multiple of 5 |
| `price` | integer | in euros, 0–1000 (0 = free) |
| `location` | string | |
| `validated` | boolean | nil = pending, true = approved, false = rejected |
| `user_id` | integer | foreign key → User (organizer) |
| `photo` | attachment | via Active Storage (required) |

### Attendance
| Column | Type | Notes |
|---|---|---|
| `stripe_customer_id` | string | Stripe unique customer ID (nil for free events) |
| `user_id` | integer | foreign key → User |
| `event_id` | integer | foreign key → Event |

## Getting Started

### Prerequisites

- Ruby 3.4.2
- PostgreSQL
- Bundler

### Installation

```bash
# Clone the repository
git clone <repo-url>
cd <repo-name>

# Install dependencies
bundle install

# Set up environment variables
cp .env.example .env
# Then fill in your credentials in .env
```

### Environment Variables

Create a `.env` file at the root (never commit it — already in `.gitignore`):

```env
GMAIL_USER_NAME=your.address@gmail.com
GMAIL_PASSWORD=your_16_char_app_password
STRIPE_SECRET_KEY=sk_test_...
STRIPE_PUBLIC_KEY=pk_test_...
```

> To generate a Gmail App Password: Google Account → Security → 2-Step Verification → App Passwords
> Stripe keys are available in your [Stripe Dashboard](https://dashboard.stripe.com/apikeys)

### Database Setup

```bash
rails db:create
rails db:migrate
rails db:seed
```

### Running the App

```bash
rails server
```

Visit [http://localhost:3000](http://localhost:3000)

### Admin Access

To grant admin rights to a user, run in the Rails console:

```ruby
User.find_by(email: "your@email.com").update!(admin: true)
```

The admin dashboard is then accessible at `/admin`.

### Email Preview (Development)

Emails are intercepted and stored locally in development. Visit:

```
http://localhost:3000/letter_opener
```

## Automated Emails

| Trigger | Recipient | Description |
|---|---|---|
| User created | New user | Welcome email |
| Attendance created | Event organizer | New registration notification |
| Event validated by admin | Event organizer | Approval confirmation |
| Event rejected by admin | Event organizer | Rejection notification |

## Validations

**Event:**
- `title` — required, 5–140 characters
- `description` — required, 20–1000 characters
- `start_date` — required, must be in the future
- `duration` — required, positive integer, multiple of 5 (minutes)
- `price` — required, integer between 0 and 1000 (euros, 0 = free)
- `location` — required
- `photo` — required (Active Storage attachment)

## Event Lifecycle

```
User creates event → status: "pending" (validated: nil)
         ↓
Admin reviews in /admin/event_submissions
         ↓
  ┌──────┴──────┐
Approve        Reject
  ↓              ↓
validated:true  validated:false
Email sent      Email sent
Event visible   Event hidden
on public site
```

## Production Deployment

SMTP is configured for Gmail in `config/environments/production.rb`. Make sure to set `GMAIL_USER_NAME`, `GMAIL_PASSWORD`, `STRIPE_SECRET_KEY`, and `STRIPE_PUBLIC_KEY` as environment variables on your hosting platform.

> **Note:** Gmail is suitable for bootcamp and personal projects. For production-grade apps, consider a dedicated domain with SPF/DKIM configuration.
> **Note:** Active Storage uses local disk service. For production, configure a cloud storage provider (S3, GCS, etc.) in `config/storage.yml`.
