// Check and install Git if necessary
import { execSync } from "child_process";

// Check if Git is installed
try {
  execSync("git --version", { stdio: "ignore" });
} catch (error) {
  console.log("Git not found. Installing Git...");
  execSync("brew install git", { stdio: "inherit" });
}

// Check if Node.js is installed
try {
  execSync("node -v", { stdio: "ignore" });
} catch (error) {
  console.log("Node.js not found. Installing Node.js...");
  execSync("brew install node", { stdio: "inherit" });
}

// Install Firebase if not already installed
try {
  execSync("npm list firebase", { stdio: "ignore" });
} catch (error) {
  console.log("Firebase not found. Installing Firebase...");
  execSync("npm install firebase", { stdio: "inherit" });
}

// Import required packages
import inquirer from "inquirer"; 
import qr from "qr-image"; 
import fs from "fs";
import { initializeApp } from "firebase/app";
import { getDatabase, ref, set } from "firebase/database"; // Import Firebase database functions

// Your Firebase configuration
const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
  databaseURL: "https://YOUR_PROJECT_ID.firebaseio.com",
  projectId: "YOUR_PROJECT_ID",
  storageBucket: "YOUR_PROJECT_ID.appspot.com",
  messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
  appId: "YOUR_APP_ID",
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const database = getDatabase(app);

// Prompt the user for a URL
inquirer
  .prompt([
    {
      message: "Type in your URL: ",
      name: "URL"
    },
  ])
  .then((answers) => {
    const url = answers.URL;
    
    // Generate and save the QR code
    const qr_svg = qr.image(url);
    qr_svg.pipe(fs.createWriteStream("qr_image.png"));

    // Save the URL to a text file
    fs.writeFile("URL.txt", url, (err) => {
      if (err) throw err;
      console.log("The file has been saved!");
    });

    // Save the URL to Firebase Realtime Database
    const dbRef = ref(database, 'urls/' + Date.now()); // Using timestamp as a unique key
    set(dbRef, { url: url })
      .then(() => {
        console.log("URL saved to Firebase database!");
      })
      .catch((error) => {
        console.error("Error saving to Firebase:", error);
      });
  })
  .catch((error) => {
    if (error.isTtyError) {
      // Prompt couldn't be rendered in the current environment
    } else {
      console.error("An error occurred:", error);
    }
  });
