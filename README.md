# Connecting To An AT&T Developer Program Service - The Basics

## Getting Ready

-   Determine Where Your App Is Deployed
-   Register your application with APIMatrix
-   Obtain a client_id and client_secret for your app from APIMatrix

## Making The Call

-   Request authorization code on the User's behalf from AT&T OAuth server
-   AT&T OAuth Server redirects back to your app with OAuth code
-   Use returned oauth code to request OAuth access token
-   Use OAuth access token to call API

## Authorization

Your app will need to be given permission by each user in order to access their personal data. Here is how it works:

-   The app will navigate to the “Consent Request” page automatically, whenever the app needs to obtain authorization to access user data
-   User enters their username/password then click on "Allow" button
-   Now the application is authorized to call APIs on the user's behalf

## Profile API

The Profile API allows you to return the user profile data for the current user. The user will need to give permission to the application that wants to retrieve this data, and the application will only be able to get the profile data for the user’s own account.

## How To Run The Sample Code

    bundle install
    CLIENT_ID=<your client ID here> CLIENT_SECRET=<your secret here> AUTH_SERVER=<auth server> API_SERVER=<api server> SCOPE=<desired scope> ruby helloapp.rb