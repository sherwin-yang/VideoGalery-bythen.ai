//
//  VideoGalery_bythen_aiApp.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/12/24.
//

import SwiftUI
import FirebaseCore

private final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        VideoUploader.shared.cancel()
    }
}

@main
struct VideoGalery_bythen_aiApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var delegate
    var body: some Scene {
        WindowGroup {
            if EnvironmentVariable.isUnitTest {
                TestingEnvEmptyView()
            } else {
                UploadedVideoListView()
            }
        }
    }
}

private struct TestingEnvEmptyView: View {
    var body: some View {
        VStack { }
    }
}

private struct EnvironmentVariable {
    static var isUnitTest: Bool {
        let bundleKeyPath = envVar(key: "XCTestBundlePath") ?? ""
        return bundleKeyPath.hasSuffix("VideoGalery-bythen.aiTests.xctest")
    }
    
    private static func envVar(key: String) -> String? {
        ProcessInfo.processInfo.environment[key]
    }
}
