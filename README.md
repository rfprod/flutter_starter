# flutter_starter

Flutter starter project with workflow automation.

[![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/)

## Workflows

|                                                                              | Trigger                             | Badge                                                                                                                                                                                                        |
| ---------------------------------------------------------------------------- | ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [:information_source:](# "Full testing, deliverables build and deployment.") | PR merge event (destination: trunk) | [![trunk](https://github.com/rfprod/flutter_starter/actions/workflows/trunk.yml/badge.svg)](https://github.com/rfprod/flutter_starter/actions/workflows/trunk.yml)                                           |
| [:information_source:](# "Code ownership validation.")                       | Scheduled (weekly)                  | [![validate-codeowners](https://github.com/rfprod/flutter_starter/actions/workflows/validate-codeowners.yml/badge.svg)](https://github.com/rfprod/flutter_starter/actions/workflows/validate-codeowners.yml) |
| [:information_source:](# "Quality gates: pull request validation.")          | PR open event (destination: trunk)  | [![validate-pr](https://github.com/rfprod/flutter_starter/actions/workflows/validate-pr.yml/badge.svg)](https://github.com/rfprod/flutter_starter/actions/workflows/validate-pr.yml)                         |

## Requirements

In order to run own copy of the project one must fulfill the following requirements.

### Supported operating systems

- :trophy: [Debian based Linux](https://en.wikipedia.org/wiki/List_of_Linux_distributions#Debian-based) - `recommended`
  - check out [this dev setup instructions](https://github.com/rfprod/wdsdu) to facilitate setting up the dev environment;
- :ok: [OSX](https://en.wikipedia.org/wiki/MacOS) - `should work due to the similarities with Linux`
  - one will have to figure out oneself how to set up the dev environment;
- :no_entry_sign: [Windows](https://en.wikipedia.org/wiki/Microsoft_Windows) - `not recommended`
  - one will have to figure out oneself how to set up the dev environment.

### Core dependencies

- [Git](https://git-scm.com/)
- [Bash 5](https://www.gnu.org/software/bash/)
- [Flutter](https://flutter.dev)

### Setting up Flutter on a Debian based Linux

Check out this repository [WDSDU](https://github.com/rfprod/wdsdu). It has automated installation instructions for Debian based Linux distributions.

To install everything clone [WDSDU](https://github.com/rfprod/wdsdu)

```bash
cd ./proj # or whatever your git projects folder is
git clone git@github.com:rfprod/wdsdu.git
```

, cd into the project directory, execute `instal.sh` and pay attention to the prompts in the terminal where the `install.sh` was executed

```bash
cd ./wdsdu
bash ./install.sh
```

## Working with the project

Use the [Flutter CLI](https://docs.flutter.dev/reference/flutter-cli) to work with the project.

### Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### Environment variables

Create an `.env` file in the project root with the following values

```plaintext
SENTRY_DSN='...'
FIRE_API_KEY='...'
FIRE_APP_ID='...'
FIRE_MESSAGING_SENDER_ID='...'
FIRE_PROJECT_ID='...'
```

### Google services integration

Put the `google-services.json` file into the `./android/app` directory.

### Quick references

1. **show help**

```bash
flutter --help
```

2. **list the devices**

```bash
flutter devices list
```

Example output

```bash
$ flutter devices list
2 connected devices:

Android SDK built for x86 (mobile) • emulator-5554 • android-x86    • Android 11 (API 30) (emulator)
Chrome (web)                       • chrome        • web-javascript • Google Chrome 100.0.4896.75
```

3. **list the emulators**

```bash
flutter emulators
```

Example output

```bash
$ flutter emulators
1 available emulator:

api31device • api31device •  • android

To run an emulator, run 'flutter emulators --launch <emulator id>'.
To create a new emulator, run 'flutter emulators --create [--name xyz]'.

You can find more information on managing emulators at the links below:
  https://developer.android.com/studio/run/managing-avds
  https://developer.android.com/studio/command-line/avdmanager
```

4. **launch an emulator**

Given you have devices and emulators as listed above (see point 2, point 2), to launch an emulator execute

```bash
flutter emulators --launch api31device
```

5. **run the application on the emulator**

```bash
flutter run
```

## Technologies Reference

### Client

- [Flutter](https://flutter.dev)
- [Flutter CLI](https://docs.flutter.dev/reference/flutter-cli)

### Server

- [Firebase](https://firebase.google.com)

### API integrations

- [Blockchain](https://blockchain.info/ticker)
- [CoinGecko](https://www.coingecko.com/en/api) // TBI

### CI

- [GitHub Actions](https://github.com/features/actions)

### Development methodology

- [Trunk based development](https://trunkbaseddevelopment.com/)
