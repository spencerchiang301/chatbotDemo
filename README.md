# ChatbotDemo

A quick demonstration of using OpenAI to retrieve information from the world.

[Watch the Demo Video](https://youtube.com/shorts/kf82kTXHG80?feature=share)

---

## Features

1. **Login/Register**:
   - For first-time users, log in or register using:
     - Email: `will.lin@gmail.com`
     - Password: `qqq123`
   - Once registered, log in with your chosen username and password.

2. **Restaurant Information**:
   - Swipe right to left to browse through restaurant suggestions.
   - Click on the buttons to:
     - **Make a Reservation**.
     - **Dial a Phone**.
     - **Navigate** to the restaurant.

3. **Steak Restaurant Focus**:
   - The chatbot currently returns only steak restaurant recommendations.
   - This behavior is hard-coded due to the absence of NLP processing.

---

## Environment Setup

### Requirements
- A mobile phone running **Android 11**.
- **Docker Containers**:
  1. MongoDB
  2. Python backend server

### AWS Hosting
- Hosted on an **AWS EC2 t2.small** instance.
- Handles all required Docker containers.

---

## How to Use

1. **Log In or Register**:
   - Use the provided credentials for a quick start:
     - Email: `will.lin@gmail.com`
     - Password: `qqq123`
   - Or create a new user account.

2. **Browse Restaurants**:
   - Swipe right to left to see the next restaurant.
   - Use the action buttons to:
     - Make a reservation.
     - Dial the restaurant.
     - Get directions.

3. **Chatbot Behavior**:
   - All requests to the chatbot will return steak restaurant suggestions.
   - NLP is not yet integrated, so this behavior is hardcoded.

