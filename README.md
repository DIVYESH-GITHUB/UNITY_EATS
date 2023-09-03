# UNITY_EATS: A Food Donation Flutter App

![App Screenshots](link_to_screenshot)

## Overview

UNITY_EATS is a mobile application designed to facilitate food donations from individuals and organizations to nearby NGOs (Non-Governmental Organizations) that help distribute food to those in need. This project aims to bridge the gap between food donors, NGOs, and administrators to streamline the donation process.

The app is divided into three main modules:

1. **Donor Module:** Donors can easily create listings for available food donations. They provide details about the food items, quantity, and pickup location. Donors can also view requests from nearby NGOs and accept or decline them. Donors can see the feedback given from the NGOs to the food. Rest all basic operations such as editing profiles, ranking, and seeing NGOs can be done.

2. **NGO Module:** NGOs can browse available food donations in their vicinity and request them for distribution to beneficiaries. Donors receive these requests and can choose to fulfill them. on the basis of what the donor has selected, NGOs have to collect the food from a given location or can receive it at their own place. After food is successfully received NGOs can also give feedback to donors about the food by sharing photos also.

3. **Admin Module:** Administrators can verify and approve new NGO registrations. Only admin verification can authorize the NGOs to receive the donations. If the food quality of the donations was not good then NGOs can also report the donor, which will be then taken care of by the admin by reporting the donor. admin can also remove the accounts of NGOs and donors if needed. also admin can keep track of all the donations happening.

In the future, UNITY_EATS plans to expand its capabilities to include donations of other items such as clothes, books, money, toys, and more.

## Features

- **User Authentication:** Secure user authentication and registration.
- **Donation Listings:** Donors can create detailed listings for available food donations.
- **Request System:** NGOs can request food donations from nearby donors.
- **Administrator Approval:** Admins verify and approve new NGO registrations.
- **Scalability:** Designed for future expansion to include various types of donations.

## Getting Started

### Prerequisites

- Flutter and Dart installed on your development machine.
- Firebase project set up with Firestore and Authentication services.

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/UNITY_EATS.git
   
2. Navigate to the project folder:

   ```bash
   cd UNITY_EATS

3. Install dependencies:

   ```bash
   flutter pub get

4. Configure Firebase: Add your Firebase configuration files to the project.

5. Run the app:
   
   ```bash
   flutter run

## Contributing
Contributions are welcome! Please read the Contribution Guidelines for details on how to contribute to this project.

## Acknowledgments
Thanks to the Flutter and Firebase communities for their support and resources.

## Contact
For questions or feedback, please [contact me](mailto:divyeshpindaria09@gmail.com).

