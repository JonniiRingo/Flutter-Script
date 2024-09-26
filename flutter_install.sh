// Check and install Git if necessary
import { execSync } from "child_process";

try {
  execSync("git --version", { stdio: "ignore" });
} catch (error) {
  console.log("Git not found. Installing Git...");
  execSync("brew install git", { stdio: "inherit" });
}

// Import required packages
import inquirer from "inquirer"; 
import qr from "qr-image"; 
import fs from "fs";

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
  })
  .catch((error) => {
    if (error.isTtyError) {
      // Prompt couldn't be rendered in the current environment
    } else {
      console.error("An error occurred:", error);
    }
  });
