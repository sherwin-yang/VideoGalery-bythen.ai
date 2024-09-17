# Contents
* [Overview](#Overview): Features, Architecture, and Assumptions
* [More About Architectures](#More-About-Architectures)
* [More About User Defined Packages and Systems](#More-About-User-Defined-Packages-and-Systems)
* [Improvement Plans](#Improvement-Plans)

# Overview
## Features
All views are supporting light and dark mode.

| Show List of Uploaded Videos | Retry Load Uploaded Videos |
|---|---|
| <img src="README_Assets/VideoList.jpeg" width="332" alt="Show List of Uploaded Videos"> | ![Retry Load Uploaded Videos](https://github.com/user-attachments/assets/5702c242-d79d-4f0c-a95d-23f165374cb0) |

| Upload Video | Retry Upload Video |
|---|---|
| ![Retry Upload Video](https://github.com/user-attachments/assets/619fb1c6-72af-4692-a003-f6fc049b95ac) | ![Retry Upload Video](https://github.com/user-attachments/assets/8f3551e9-cd22-4aef-9298-e27f35fc57bd) |

| Delete Video | Delete Last Recorded Uploading Video To Record New One |
|---|---|
| ![Delete Video](https://github.com/user-attachments/assets/1a970991-a71f-4caa-979f-c5e846fc2f03) | ![Delete Last Recorded Uploading Video To Record New One](https://github.com/user-attachments/assets/7b04a21f-0980-46c5-9565-f1ffea0fc977) |

## Architecture
<img src="README_Assets/MVVM.jpg" alt="MVVM">

***Higher Level Modules depend on Lower Level Modules through dependency injections of `protocol` or `function`***

* **SwiftUIView:** Presentation layer. (Exception to the rule above) Is dependent on its `ViewModel` concrete object (since a `ViewModel` belongs to a single View).
* **ViewModel:** Represent its presentation layer states and logic.
* **Interactor:** It can interact with another `Interactor` or `Adapter`. Responsibilites included are usually to transform raw data provided by `Adapter` layer into a ready to use data.
* **Adapter:** Interacts with other parties, making network request, etc.
* **Other Libary/Package/Module:** This can be user-defined, 3rd party, or Apple-built in.
 
See [More About Architectures](#More-About-Architectures) or [More About User Defined Packages and Systems](#More-About-User-Defined-Packages-and-Systems) for more implementation details

## Assumptions
* **Concept:** As a Galery App, it can be nice if there is some kind of visual representation of the videos when user is viewing and selecting the video for a preview. However, since image preview is not provided by the API, `public_id` and `created_at` are the representation of the videos information. Although generating image previews from the video might be achievable, with the limited time and also to load all the videos upfront can be inefficient, the other solution might be wiser.
* **Secure API Credentials Store:** `api_key` and `api_secret` are supposedly a secret information that should not be exposed in the codebase. So to prevent that, [ApiKeyProvider](#ApiKeyProvider) package is built for that concern.
* **1 Video Upload at a time:** The app is now only supporting for uploading a video at a time considering limited time since it can add a lot more complications to handle multiple video uploading system. To upload a new video, the user needs to cancel and delete previous unfinished uploading video if any.

# More About Architectures
## `VideoGaleryView`
<img src="README_Assets/VideoGaleryView.jpg" alt="VideoGaleryView">

**Navigates to:**
* `VideoPreviewView`
* `VideoRecordingView`: [open details](#VideoRecordingView)

**More About:**
* [ApiKeyProvider](#ApiKeyProvider)
* [HTTPClient](#HTTPClient)

## VideoRecordingView
Wrapping `CameraViewController` through `UIViewControllerRepresentable`. Use `AVCaptureSession` to connect to device's camera and enable video recording.

**Navigates to:**
* `UploadVideoPreviewView`: [open details](#UploadVideoPreviewView)

## UploadVideoPreviewView
<img src="README_Assets/UploadVideoPreviewView.jpg" alt="UploadVideoPreviewView">

*Upload Request using Alomofire*

**More About:**
* [ApiKeyProvider](#ApiKeyProvider)
* [HTTPClient](#HTTPClient)

# More About User Defined Packages and Systems
## `ApiKeyProvider`
Secure mechanism to retrieve Authentication information:
* `api_key` and `api_secret` are stored in Firebase (this is not necessarily the best practice of storing credential information, but only to perform secure retrieval of secret information that shouldn't be exposed in the codebase).
* It will only get the auth keys from remote (Firebase) once if it hasn't been stored in keychain. After that, it will be stored in secure local storage (Keychain) and the auth keys will be retrieved from secure local storage only.

<img src="README_Assets/ApiKeyProvider.jpg" alt="ApiKeyProvider">

## `HTTPClient`
Consist of:
* `HTTPRequest`: using `URLSession.shared` to make simple request (is used for `GET` and `DELETE` request in this project).
* `APIURLRequest`: to build the `URLRequest`.
* `CloudinaryURLBuilder`: to construct `URL` for `api.cloudinary.com` endpoints.

## Video Uploading System
<img src="README_Assets/UploadVideoSystem.jpg" alt="Upload Video System">

* `VideoUploader`: 
    * Make upload request
    * Retry upload request
    * Cancel upload request
    * Remove video file when necessary
    * Notify video uploading status through `NotificationCenter`
* `UploadVideoStatusPublisher`
    * Observe `NotificationCenter` to publish `UploadVideoStatus`
    ```
    enum UploadVideoStatus {
        case none
        case uploading
        case success
        case failed
    } 
    ```

# Improvement Plans
1. Move `UploadVideoStatus` checking in `VideoGaleryView` to its ViewModel
1. Move on Recording Button tapped logic in `VideoRecordingView` to a ViewModel 
1. `ApiKeyProvider` provides encoded auth key
1. Complete unit tests in some modules (check commits)
1. Add UI tests
1. (...)
