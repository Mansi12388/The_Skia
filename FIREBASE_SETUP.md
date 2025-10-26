# Firebase Setup Guide for Parivartan

This guide explains how your Firebase integration works and how to complete the setup.

## ✅ What's Already Configured

1. **Firebase Dependencies Added**
   - `firebase_core: ^3.8.1`
   - `firebase_auth: ^5.3.4`
   - `cloud_firestore: ^5.5.2`

2. **Android Configuration**
   - Package name: `com.example.parivartan`
   - `google-services.json` is already in place at `android/app/`

3. **Firebase Project Details**
   - Project ID: `parivartan-c3238`
   - Project Number: `776412307701`
   - App ID: `1:776412307701:android:fe13f2c79d8260293d25bc`

## 🔥 Firebase Console Setup Required

### Step 1: Enable Authentication

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **Parivartan**
3. Navigate to **Authentication** → **Sign-in method**
4. Enable **Email/Password** authentication
5. Click **Save**

### Step 2: Create Cloud Firestore Database

1. In Firebase Console, navigate to **Firestore Database**
2. Click **Create database**
3. Choose **Start in production mode** (we'll set rules next)
4. Select your preferred location (closest to your users)
5. Click **Enable**

### Step 3: Set Firestore Security Rules

Replace the default rules with the following:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper function to check if user is authenticated
    function isSignedIn() {
      return request.auth != null;
    }
    
    // Helper function to check if user owns the document
    function isOwner(userId) {
      return isSignedIn() && request.auth.uid == userId;
    }
    
    // Users collection - base user data
    match /users/{userId} {
      allow read: if isOwner(userId);
      allow create: if isSignedIn() && request.auth.uid == userId;
      allow update: if isOwner(userId);
      allow delete: if false; // Users cannot delete their own accounts via app
    }
    
    // Common Men collection - role-specific data
    match /common_men/{userId} {
      allow read, write: if isOwner(userId);
    }
    
    // Universities collection - role-specific data
    match /universities/{userId} {
      allow read, write: if isOwner(userId);
    }
    
    // Volunteer Students collection - role-specific data
    match /volunteer_students/{userId} {
      allow read, write: if isOwner(userId);
    }
    
    // Admin Coordinators collection - role-specific data
    match /admin_coordinators/{userId} {
      allow read, write: if isOwner(userId);
    }
  }
}
```

4. Click **Publish**

## 📊 Database Structure

Your app stores data in the following structure:

### Base User Data (`users` collection)
```json
{
  "users": {
    "{uid}": {
      "id": "firebase_uid",
      "name": "John Doe",
      "email": "john@example.com",
      "phone": "9876543210",
      "role": "volunteerStudent",
      "profileImage": null,
      "createdAt": "2024-01-15T10:30:00.000Z"
    }
  }
}
```

### Role-Specific Collections

#### Common Man (`common_men/{uid}`)
```json
{
  "userId": "firebase_uid",
  "skills": "Teaching, Healthcare",
  "availability": "Weekends, Evenings",
  "updatedAt": "2024-01-15T10:30:00.000Z"
}
```

#### University (`universities/{uid}`)
```json
{
  "userId": "firebase_uid",
  "orgName": "ABC University",
  "coordId": "COORD123",
  "updatedAt": "2024-01-15T10:30:00.000Z"
}
```

#### Volunteer/Student (`volunteer_students/{uid}`)
```json
{
  "userId": "firebase_uid",
  "course": "Computer Science",
  "batch": "2024-25",
  "admissionYear": "2024",
  "updatedAt": "2024-01-15T10:30:00.000Z"
}
```

#### Admin/Coordinator (`admin_coordinators/{uid}`)
```json
{
  "userId": "firebase_uid",
  "authCode": "ADMIN123456",
  "updatedAt": "2024-01-15T10:30:00.000Z"
}
```

## 🚀 How It Works

### Sign Up Flow
1. User fills the signup form with role-specific fields
2. Firebase Authentication creates user with email/password
3. User data is stored in `users/{uid}` collection
4. Role-specific data is stored in the appropriate collection with same UID as document ID
5. User is automatically signed in and navigated to role-specific home page

### Login Flow
1. User selects their role and enters credentials
2. Firebase Authentication validates email/password
3. App fetches user data from Firestore
4. Verifies the selected role matches the stored role
5. If role mismatch, user is signed out and shown an error
6. If successful, navigates to role-specific home page

### Data Security
- Each user can only read/write their own data
- Document ID matches Firebase UID for security
- Role verification prevents unauthorized access
- All operations require authentication

## ⚡ Testing the Integration

### Test Signup
1. Run the app: `flutter run`
2. Tap **Sign Up**
3. Select a role (e.g., Volunteer/Student)
4. Fill in all required fields
5. Create an account with a valid email and strong password

**Password Requirements:**
- At least 8 characters
- Contains uppercase letter
- Contains lowercase letter
- Contains number
- Contains special character

### Test Login
1. Use the same email and password from signup
2. **Important:** Select the same role you signed up with
3. Tap **Login**
4. You should be navigated to the role-specific home page

### Verify in Firebase Console
1. Go to **Authentication** → **Users**
   - You should see your test user listed
2. Go to **Firestore Database**
   - Check `users` collection → you should see a document with your UID
   - Check the appropriate role collection (e.g., `volunteer_students`) → you should see your role-specific data

## 🔍 Troubleshooting

### "An internal error has occurred"
- Make sure you've enabled Email/Password authentication in Firebase Console

### "Network error"
- Check your internet connection
- Verify Firebase project is active in Firebase Console

### "User data not found"
- This means authentication succeeded but Firestore write failed
- Check Firestore security rules are properly set
- Verify your Firestore database is created and active

### "Invalid role"
- You're trying to login with a different role than you signed up with
- Each account is tied to one specific role

### Build Errors
If you get build errors after adding Firebase:
```bash
flutter clean
flutter pub get
flutter run
```

## 📱 Next Steps (Future Implementation)

After email/password authentication is working, we can add:

1. **Google Sign-In**
   - User signs in with Google
   - If new user, show role selection and collect role-specific data
   - If existing user, navigate to home page

2. **Facebook Sign-In**
   - Similar flow to Google Sign-In
   - Collect additional data on first login

3. **Profile Management**
   - Users can update their profile information
   - Upload profile pictures to Firebase Storage

4. **Password Reset**
   - Forgot password functionality
   - Email verification

## 📧 Support

If you encounter any issues:
1. Check the Firebase Console for error logs
2. Review the Firestore security rules
3. Verify all credentials are correctly configured
4. Check Android logcat for detailed error messages: `flutter logs`

---

**Important Notes:**
- Keep your `google-services.json` secure and never commit it to public repositories
- The current implementation uses Android only; iOS and Web configurations need to be added separately
- For production, consider implementing additional security measures like email verification and rate limiting

