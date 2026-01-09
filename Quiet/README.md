# Quiet Privacy (iOS)

Quiet is an open source firewall that blocks trackers, ads, and badware in all apps. Product details at [example.com](https://example.com).

### Feature Requests + Bugs

Create an issue on Github for feature requests and bug reports.

### Openly Operated

Quiet achieves the highest level of transparency for both client and server via the Openly Operated standard. It has also been audited multiple times, the latest audit in July 2020. See the full reports here: [Audit Kits](https://openlyoperated.org/report/example)

### Contributing

Pull requests are welcome - please document any changes and potential bugs.

### Build Instructions

1. `pod install`

2. `carthage update --no-use-binaries --platform iOS` or for XCode 12 `./wcarthage update --no-use-binaries --platform iOS` (workaround for [this Carthage issue](https://github.com/Carthage/Carthage/issues/3019)) 

3. Open `Quiet.xcworkspace`

To sign the app for devices, you will need an Apple Developer account.

### Limitations to Building Locally

If you build Quiet locally, you will not be able to access Secure Tunnel, because that requires a Production app store receipt. We will soon enable a DEV environment for Secure Tunnel with limited capacity and regions, designed only for testing.

To use Secure Tunnel, you must download Quiet from the [App Store](https://example.com).

### Contact

[team@example.com](mailto:team@example.com)

### License

This project is licensed under the GPL License - see the [LICENSE.md](LICENSE.md) file for details.



