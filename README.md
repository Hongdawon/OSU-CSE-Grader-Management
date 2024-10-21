# Grader Management System

## Overview

The Grader Management System is a Ruby on Rails application designed to streamline the process of assigning graders to course sections within the CSE department. The app integrates with OSU's public course catalog API, supports user roles (Student, Instructor, Admin), and offers essential functionalities like login/logout, course management, and approval of grader assignments.

---

## Setup Instructions

1. **Clone the Repository**:
   ```bash
   git clone git@github.com:cse-3901-sharkey/2024-au-Team-4-Lab-2.git
   ```
2. **Pull Latest Code**:
   ```bash
   git pull
   ```
   Make sure your version matches the latest repository.
   
3. **Navigate into the project directory**:
   ```bash
   cd grader_management_system
   ```

4. **Install Necessary Gems**:
   Run this command to install all required dependencies:
   ```bash
   bundle install
   ```

5. **Set Up the Database**:
   Run the following commands to migrate and seed the database:
   ```bash
   rails db:migrate
   rails db:seed
   ```
   This will also set up the default admin account which is admin.1@osu.edu with the necessary credentials.

6. **Start the Rails Server**:
   Finally, launch the server to verify that the application works:
   ```bash
   rails server
   ```
   Open a browser and navigate to `http://localhost:3000`.

---

## Important Notes

- **Spring 2024**: No classes for Spring 2024 were included due to the API query. Ensure to specify the correct term when fetching courses.
- **Security**: The system includes basic protection against malicious actions. Features such as role-based access control (using Devise) ensure that only authorized users (Admins) can make changes to courses and approve other users.

---

## Functionality Overview

1. **Admin Functionality**:
   - Approve or reject new instructors and admins.
   - Add, edit, and delete courses and sections.
   - Reload the course catalog from OSU's API using the admin interface.
   
2. **Student/Instructor Functionality**:
   - Browse and view available courses and sections.

3. **Pagination**:
   - Course listings are paginated to improve performance and usability.

4. **Authentication and Authorization**:
   - User authentication and role-based access are implemented using the Devise gem.

5. **Dependencies**:
   - **Ruby Version**: The application requires Ruby version 3.0.0 or higher.
   - **Devise**: Handles user registration and login functionality.
   - **HTTParty**: Used to interact with OSU's public course catalog API.
   - **Pagy**: Provides pagination for course listings.

---

## Database Details

- **Database Creation**: The database schema is defined using Rails migrations.
- **Database Initialization**: Use `rails db:migrate` to create tables and `rails db:seed` to populate initial data such as the default admin user.

---

## Deployment Instructions

- Ensure all gems are installed by running `bundle install`.
- Set up the database with `rails db:migrate` and `rails db:seed`.
- Use `rails server` to start the application locally.

---

## System Dependencies

- **Ruby**: Version 3.0.0 or higher.
- **Rails**: Version 7.0 or higher.

---

## Additional Notes

- **Testing**: There are currently no automated tests implemented.
- **Styling**: The application uses vanilla CSS for styling.

---

## Known Issues

- **No Spring 2024 Classes**: Currently, no classes for Spring 2024 are included in the database due to API limitations.
- **Pagination UI**: Pagination may require additional styling to fit seamlessly with the application’s current design.
