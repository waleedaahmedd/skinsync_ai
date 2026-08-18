import Flutter
import UIKit
import GoogleMaps
import Firebase
import AVFoundation
import MediaPlayer

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var eventSink: FlutterEventSink?
  private var volumeView: MPVolumeView?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyA0X5qoEmjUDlEQzbW0yZLGWAAfbos8GIE")
    GeneratedPluginRegistrant.register(with: self)

    if let controller = window?.rootViewController as? FlutterViewController {
        let volumeEventChannel = FlutterEventChannel(name: "com.skinsyncai/volume_buttons", binaryMessenger: controller.binaryMessenger)
        volumeEventChannel.setStreamHandler(self)

        let volumeMethodChannel = FlutterMethodChannel(name: "com.skinsyncai/volume_buttons_method", binaryMessenger: controller.binaryMessenger)
        volumeMethodChannel.setMethodCallHandler { [weak self] (call, result) in
            switch call.method {
            case "enableInterception":
                self?.showHiddenVolumeView(true)
                result(nil)
            case "disableInterception":
                self?.showHiddenVolumeView(false)
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func showHiddenVolumeView(_ show: Bool) {
    if show {
        if volumeView == nil {
            volumeView = MPVolumeView(frame: CGRect(x: -100, y: -100, width: 0, height: 0))
            volumeView?.alpha = 0.01
            window?.rootViewController?.view.addSubview(volumeView!)
        }
        volumeView?.isHidden = false
    } else {
        volumeView?.isHidden = true
    }
  }
}

extension AppDelegate: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        do {
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            AVAudioSession.sharedInstance().addObserver(self, forKeyPath: "outputVolume", options: .new, context: nil)
        } catch {
            print("Error setting up volume observer: \(error)")
        }
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        AVAudioSession.sharedInstance().removeObserver(self, forKeyPath: "outputVolume")
        self.eventSink = nil
        return nil
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "outputVolume", let eventSink = self.eventSink {
            eventSink("volumeUp")
        }
    }
}
