# ReFrameU

ReFrameU is an AI-powered iOS application designed to enhance emotional well-being through private, stigma-free self-reflection. Users can input negative thoughts and receive instant cognitive reframes—logical, optimistic, and compassionate—to foster healthier thinking patterns. The app also features mood tracking, private journaling, and a gamified "Island of Thoughts" to visualize personal growth.

## Features

- **AI-Powered Reframing Engine:** Provides three immediate perspectives—logical, optimistic, and compassionate—to help reframe negative thoughts.
- **Mood Tracking and Private Journaling:** Enables users to monitor their emotional patterns and reflect on daily experiences.
- **Gamified "Island of Thoughts":** Visual representation of personal growth, where reframes contribute to the flourishing of a virtual garden.
- **Privacy-Focused:** Designed for users who prefer self-guided reflection without the need for conversation.

## Technology Stack

- **SwiftUI:** Utilized for building the user interface, ensuring a smooth and responsive experience.
- **ASU GPT-4o AI Builder:** Employed to train and refine AI-generated reframes.
- **Gemini API:** Integrated for real-time, personalized AI responses.
- **Firebase:** Used for secure data storage, including mood logs and saved reframes, facilitating synchronization across devices.

## Installation

To set up the ReFrameU app locally:

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/Vaishh09/ReFrameU.git
Navigate to the Project Directory:

bash
Copy
Edit
cd ReFrameU
Open the Project in Xcode: Open the ReFrameU.xcodeproj file with Xcode.

Install Dependencies: Ensure all necessary dependencies are installed. If using CocoaPods, run:

bash
Copy
Edit
pod install
Configure Firebase:

Create a new project in the Firebase Console.

Add a new iOS app to your Firebase project.

Download the GoogleService-Info.plist file.

Add the GoogleService-Info.plist file to the ReFrameU project in Xcode.

Build and Run: Select the appropriate simulator or connected device and click 'Run' in Xcode.
