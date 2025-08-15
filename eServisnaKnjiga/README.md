# eServisnaKnjiga

**eServisnaKnjiga** The seminar project for Software Development II presents an integrated software platform designed to optimize the workflow of vehicle service centers. The solution consists of a desktop application and a mobile application, both built with Flutter, connected to a central ASP.NET Core Web API backend. The mobile app enables clients to easily schedule service appointments and make secure payments, while the desktop app provides service staff with tools for managing appointments and handling customer information. This architecture ensures smooth data synchronization and an improved user experience for both customers and service providers.

## Features

- **Desktop Applications**: Developed for car service centers, providing tools for managing appointments, updating service records, and controlling overall operations.
- **Mobile Application**: Created for clients, enabling easy service appointment scheduling and secure mobile payments.

## Technologies Used

- **Backend**: ASP.NET Core Web API with Entity Framework, with the API, SQL database, and RabbitMQ containerized using Docker.
- **Frontend**: Flutter (for both desktop and mobile applications).

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

- **Backend:** ```SQL_USER```, ```SQL_PASSWORD```, ```SQL_PASSWORD_DOCKER```, ```SQL_HOST```, ```SQL_DB_NAME```, ```ASPNETCORE_ENVIRONMENT```, ```RABBITMQ_HOST```, ```RABBITMQ_PORT```, ```RABBITMQ_USERNAME```, ```RABBITMQ_PASSWORD```, ```VONAGE_API_KEY```, ```VONAGE_API_SECRET```, ```STRIPE_SECRET_KEY``` and ```STRIPE_PUBLISHABLE_KEY```
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

1. Navigate to the mobile app folder: ```eServisnaKnjiga\UI\eservisnaknjiga_mobile``.

2. Install dependencies:

```bash
flutter pub get
```

3. Run the application:

```bash
flutter run --dart-define=BASE_URL_MOBILE=https://10.0.2.2:7042/
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
