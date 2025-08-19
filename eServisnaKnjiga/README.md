# eServisnaKnjiga

**eServisnaKnjiga** The seminar project for Software Development II presents an integrated software platform designed to optimize the workflow of vehicle service centers. The solution consists of a desktop application and a mobile application, both built with Flutter, connected to a central ASP.NET Core Web API backend. The mobile app enables clients to easily schedule service appointments and make secure payments, while the desktop app provides service staff with tools for managing appointments and handling customer information. This architecture ensures smooth data synchronization and an improved user experience for both customers and service providers.

## Features

- **Desktop Applications**: Developed for car service centers, providing tools for managing appointments, updating service records, and controlling overall operations.
- **Mobile Application**: Created for clients, enabling easy service appointment scheduling and secure mobile payments.

## Technologies Used

- **Backend**: ASP.NET Core Web API with Entity Framework, with the API, SQL database, and RabbitMQ containerized using Docker.
- **Frontend**: Flutter (for both desktop and mobile applications).

## Recommendation System

The platform includes an **item-to-item collaborative filtering recommendation system** for service packages. It analyzes past reservations to determine which packages are frequently purchased together and generates personalized recommendations for clients.

- The recommendation model is **automatically trained when the application starts**, ensuring that the system has an up-to-date model from the very beginning.
- The model is **refreshed daily at 6 AM** using a background job, keeping recommendations current as new reservation data is added.

This system leverages **Microsoft ML.NET's Matrix Factorization** to learn patterns from historical reservation data and provide meaningful suggestions to clients.

## SMS Notification System

The platform integrates **Vonage API** to send SMS notifications to clients.  

- **Account Notifications:** Clients receive an SMS when a new account is created, providing them with essential login information.  
- **Appointment Updates:** Clients are notified via SMS when a service appointment is **approved, declined, or rescheduled**, ensuring they are always informed of changes.  
- **Service Reminders:** A background job runs **daily at 12 PM** to automatically send reminders to clients whose service appointments or subscriptions have expired, helping them stay up-to-date with their vehicle maintenance.  

This ensures timely communication with clients and improves engagement through automated SMS notifications.

## Getting Started

Follow the steps below to set up and run the project.

### Prerequisites

Ensure you have the following tools installed:
- **Docker**: For containerizing the backend.
- **Visual Studio Code**: Recommended for editing and running the frontend (Flutter).
- **Flutter**: To run the desktop and mobile applications.

### Clone the Repository

```bash
git clone https://github.com/StefanDjukic4/EServisnaKnjiga.git
```

### Environment variables

The following environment variables are required:

- **Backend:** ```SQL_USER```, ```SQL_PASSWORD```, ```SQL_HOST```, ```SQL_DB_NAME```, ```ASPNETCORE_ENVIRONMENT```, ```RABBITMQ_HOST```, ```RABBITMQ_PORT```, ```RABBITMQ_USERNAME```, ```RABBITMQ_PASSWORD```, ```VONAGE_API_KEY```, ```VONAGE_API_SECRET```, ```STRIPE_SECRET_KEY``` and ```STRIPE_PUBLISHABLE_KEY```
- **Frontend (desktop app):** ```BASE_URL_DESKTO```
- **Frontend (mobile app):** ```BASE_URL_MOBILE```

### Running the Backend API

Creating a ```.env``` file in:

- **Backend:** ```EServisnaKnjiga\eServisnaKnjiga```

To start the API and other necessary services, navigate to the project's root folder (```EServisnaKnjiga\eServisnaKnjiga```) and run the following command:

```bash
docker-compose up --build
```

### Running the Desktop App

1. Navigate to the appropriate folder: ```eServisnaKnjiga\UI\eservisnaknjiga_admin```

2. Install the necessary dependencies:

```bash
flutter pub get
```

3. Run the application:

```bash
flutter run -d windows --dart-define=BASE_URL_DESKTOP=http://localhost:7042/
```

### Running the Mobile App

1. Navigate to the mobile app folder: ```eServisnaKnjiga\UI\eservisnaknjiga_mobile```.

2. Install dependencies:

```bash
flutter pub get
```

3. Run the application:

```bash
flutter run --dart-define=BASE_URL_MOBILE=http://10.0.2.2:7042/
```

### Credentials For Testing

#### Desktop App

- Username: ```admin@example.com```
- Password: ```admin```

#### Mobile App

- Username: ```marko1@example.com```
- Password: ```korisnik```

Additionally, there are several test accounts available (e.g., jelena2@example.com, petar5@example.com, ivana6@example.com...), all using the password ```korisnik```.

#### Testing Payments

To test payment processing, use the following details:

- Card Number: ```4242 4242 4242 4242```
- Expiration Date: ```Any future date```
- CVC: ```Any three-digit number```

## License

This project is licensed under the [MIT License](LICENSE).
