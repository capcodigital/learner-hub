[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]

<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/capcodigital/flutter-confluence">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">Flutter Confluence</h3>

  <p align="center">
  An application built in Flutter that showcases confluence pages
    <br />
    <a href="https://github.com/capcodigital/flutter-confluence"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/capcodigital/flutter-confluence">View Demo</a>
    ·
    <a href="https://github.com/capcodigital/flutter-confluence/issues">Report Bug</a>
    ·
    <a href="https://github.com/capcodigital/flutter-confluence/issues">Request Feature</a>
  </p>
</p>

<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary><h2 style="display: inline-block">Table of Contents</h2></summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project

[![Product Name Screen Shot][product-screenshot]](https://example.com)

Here's a blank template to get started:
**To avoid retyping too much info. Do a search and replace with your text editor for the following:**
`capcodigital`, `repo_name`, `twitter_handle`, `email`, `project_title`, `project_description`

### Built With

* [Flutter](https://flutter.dev/)
* [CircleCI](https://circleci.com/)
* [Terraform](https://www.terraform.io/)

<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple steps.

### Prerequisites

* Flutter
* Python Virtual Environment
* Terraform
* gGloud
* GCP Service Account Key

#### Flutter Installation

In order to run the application locally, you must have the Flutter SDK installed.  Follow the steps within the [Flutter Documentation](https://flutter.dev/docs/get-started/install) to install the Flutter SDK on your local machine.

#### Python Virtual Environment

To use `pre-commit` isolated from other projects a virtual environment called _.venv-flutter-confluence_.  The virtual environment can be created in multiple ways, this example shows using `pyenv` which can be found [here](https://github.com/pyenv/pyenv).

```shell
pyenv virtualenv 3.9.1 .venv-flutter-confluence
```

#### Terraform

To develop the `terraform` configuration you will need the correct version of `terraform` installed, currently `1.0.0`.  One approach is to use `tfenv` to enable local management of multiple versions.  For instructions on installing `tfenv` see [here](https://github.com/tfutils/tfenv).

```shell
tfenv install 1.0.0
tfenv use 1.0.0
```

#### gCloud

`gcloud` needs to to be installed on the local machine.  You can find installation instructions in the offical documentation [here](https://cloud.google.com/sdk/docs/install).

#### GCP Service Account Key

A service account key file is required to be located in the project root called `.gcloud.json`.

This service account must have the following roles:

* Service Usage Admin
* Storage Admin
* Storage Object Admin

### Installation

```shell
# clone the repo
git clone https://github.com/capcodigital/flutter-confluence.git

# configures the local env
source .env
```

<!-- USAGE EXAMPLES -->
## Usage

### Designs

<img src="images/home-screen.png" alt="HomeScreen" width="200" height="400">

For details related to the user flow and usage, please visit the [confluence page](https://ilabs-capco.atlassian.net/wiki/spaces/BPG/pages/2610627123/Flutter+Confluence) for this project.

<!-- ROADMAP -->
## Roadmap

See the [open issues](https://github.com/capcodigital/flutter-confluence/issues) for a list of proposed features (and known issues).

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

If you would like to contribute to any Capco Digital OSS projects please read:

* [Code of Conduct](https://github.com/capcodigital/.github/blob/master/CODE_OF_CONDUCT.md)
* [Contributing Guidelines](https://github.com/capcodigital/.github/blob/master/CONTRIBUTING.md)

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.

<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements

* [Best README Template](https://github.com/othneildrew/Best-README-Template/blob/master/README.md)

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/capcodigital/flutter-confluence.svg?style=for-the-badge
[contributors-url]: https://github.com/capcodigital/flutter-confluence/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/capcodigital/flutter-confluence.svg?style=for-the-badge
[forks-url]: https://github.com/capcodigital/flutter-confluence/network/members
[stars-shield]: https://img.shields.io/github/stars/capcodigital/flutter-confluence.svg?style=for-the-badge
[stars-url]: https://github.com/capcodigital/flutter-confluence/stargazers
[issues-shield]: https://img.shields.io/github/issues/capcodigital/flutter-confluence.svg?style=for-the-badge
[issues-url]: https://github.com/capcodigital/flutter-confluence/issues
[license-shield]: https://img.shields.io/github/license/capcodigital/flutter-confluence.svg?style=for-the-badge
[license-url]: https://github.com/capcodigital/flutter-confluence/blob/master/LICENSE
