# RokuPDF

RokuPDF is a modular i3wm script for navigating directories and opening PDF and EPUB files using Rofi. It allows you to browse directories, view recent directories, and open files seamlessly in Okular.

## Features
- Navigate directories and open PDF/EPUB files with Rofi.
- Custom icons for file types: 📂 for directories, 📄 for PDFs, 📖 for EPUBs.
- Support for recent directories and default directory option.
- Modular design for easy customization and maintenance.
- ESC key support to navigate back to previous menu when inside a directory.

# Dependencies

- [Rofi](https://github.com/davatorium/rofi): A window switcher, application launcher, and more, used for displaying file selections.
- [Okular](https://github.com/KDE/okular): A universal document viewer used to open PDF files.

### Installation Instructions

#### Install Rofi
##### Debian/Ubuntu:

    sudo apt update
    sudo apt install rofi

#### Arch Linux:

    sudo pacman -S rofi

#### Void Linux:

    sudo xbps-install -S rofi

### Install Okular
####Debian/Ubuntu:

    sudo apt update
    sudo apt install okular

#### Arch Linux:

    ``sudo pacman -S okular``

#### Void Linux:

    ``sudo xbps-install -S okular``

### Installation Steps

   - Clone this repository to your local machine:

    ``git clone https://github.com/KamiSenpai64/RokuPDF.git``

#### Navigate to the project directory:

    ``cd RokuPDF``

#### Make the script executable (if applicable):

    ``chmod +x rofi-PDF.sh``

#### Add the script to your system's PATH or launch it directly from the terminal:

    ``./rofi-PDF.sh``

### Usage

   - Run the main script: To open the Rofi file selection menu and start browsing directories, run:

    ``./rofi-PDF.sh``

   - Selecting a file: Once inside a directory, you'll see a list of available PDF and EPUB files. Select a file to open it in Okular.

   - Navigating directories: Use the Rofi menu to select directories. You can also access recent directories or reset to the default directory.

   - Exit: Press ESC to return to the previous menu or exit the script.

### Configuration

You can customize the script by modifying the following files:

   - rofi_config.sh – Customize Rofi's appearance and behavior.
   - select_file.sh – Modify how files are presented and filtered.
   - icons.sh – Adjust the icons used for file types (📂, 📄, 📖).

#### Troubleshooting

   - "git push" errors: If you encounter issues with pushing to the remote repository, try synchronizing your local branch with the remote by using git pull.
   - Missing dependencies: Make sure you have installed Rofi and Okular using your distribution's package manager.
   - Directory navigation issues: Ensure that the script is pointing to valid directories and that you have the correct permissions.

#### Contributing

We welcome contributions to improve and expand the functionality of RokuPDF! If you have suggestions or fixes, feel free to open a pull request.

   - Fork the repository.
   - Create a new branch for your feature.
   - Make your changes and commit them.
   - Push to your forked repository and create a pull request.
