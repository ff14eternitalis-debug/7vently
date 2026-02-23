# Eventbrite Lyon

![Ruby](https://img.shields.io/badge/Ruby-3.4.2-CC342D?style=flat&logo=ruby&logoColor=white)
![Rails](https://img.shields.io/badge/Rails-8.1.2-CC0000?style=flat&logo=rubyonrails&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-4169E1?style=flat&logo=postgresql&logoColor=white)
![Bootstrap](https://img.shields.io/badge/Bootstrap-5.3.3-7952B3?style=flat&logo=bootstrap&logoColor=white)
![Devise](https://img.shields.io/badge/Devise-auth-2E3440?style=flat&logo=ruby&logoColor=white)
![Stripe](https://img.shields.io/badge/Stripe-payments-635BFF?style=flat&logo=stripe&logoColor=white)
![PWA](https://img.shields.io/badge/PWA-Rails%208%20native-5A0FC8?style=flat&logo=pwa&logoColor=white)

A city-focused event management platform built with Ruby on Rails. Users can create events, browse upcoming events, and register for them. The application includes a full authentication system, automated email notifications, and a Progressive Web App (PWA) setup.

## Features

### Implemented
- Browse all upcoming events on the home page (hero + card grid)
- User registration and authentication (Devise) with Bootstrap-styled forms
- Create, edit and delete events (title, description, date, duration, price, location)
- User profile page: display info, list of organized events, edit links
- Edit profile (first name, last name, description) separately from account credentials
- Automated email notifications via Action Mailer (Gmail SMTP in production)
- Progressive Web App (PWA) support via Rails 8 native service worker + manifest
- Dark theme UI (Bootstrap 5.3.3 CDN)
- Flash messages (success / error) displayed in the navbar area

### Coming Soon
- Register for events with payment via Stripe
- Organizer dashboard: attendee list per event
- Image uploads for events and user avatars (Active Storage)
- Admin interface to approve or reject submitted events

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Ruby 3.4.2 |
| Framework | Rails 8.1.2 |
| Database | PostgreSQL |
| Authentication | Devise |
| UI Framework | Bootstrap 5.3.3 (CDN, dark theme) |
| PWA | Rails 8 native (service worker + manifest) |
| Payments | Stripe *(coming soon)* |
| File uploads | Active Storage *(coming soon)* |
| Emails | Action Mailer + Gmail SMTP |
| Dev email preview | letter_opener_web |
| Environment variables | dotenv-rails |

## Database Schema

![ERD Diagram](public/Projet%20validant%2024_02_2026%207vently.png)

### User
| Column | Type | Notes |
|---|---|---|
| `email` | string | not null, default: "" |
| `encrypted_password` | string | not null, default: "" |
| `first_name` | string | |
| `last_name` | string | |
| `description` | text | |

### Event
| Column | Type | Notes |
|---|---|---|
| `title` | string | 5–140 chars |
| `description` | text | 20–1000 chars |
| `start_date` | datetime | must be in the future |
| `duration` | integer | in minutes, multiple of 5 |
| `price` | integer | in euros, 1–1000 |
| `location` | string | |
| `user_id` | integer | foreign key → User (organizer) |

### Attendance
| Column | Type | Notes |
|---|---|---|
| `stripe_customer_id` | string | Stripe unique customer ID |
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
```

> To generate a Gmail App Password: Google Account → Security → 2-Step Verification → App Passwords

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

## Validations

**Event:**
- `title` — required, 5–140 characters
- `description` — required, 20–1000 characters
- `start_date` — required, must be in the future
- `duration` — required, positive integer, multiple of 5 (minutes)
- `price` — required, integer between 1 and 1000 (euros)
- `location` — required

## Production Deployment

SMTP is configured for Gmail in `config/environments/production.rb`. Make sure to set `GMAIL_USER_NAME` and `GMAIL_PASSWORD` as environment variables on your hosting platform.

> **Note:** Gmail is suitable for bootcamp and personal projects. For production-grade apps, consider a dedicated domain with SPF/DKIM configuration.
