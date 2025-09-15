Clean Debian/Ubuntu System
This script cleans a Debian or Ubuntu system by removing old kernels, residual configuration files, user trash, and APT cache. It is designed to free up disk space and keep the system tidy.
Features

Removes old Linux kernels (except the current and common ones).
Purges residual configuration files (packages in 'rc' state).
Clears the APT cache.
Empties the trash for all users (including root).
Updates the package list quietly after cleanup.

Prerequisites

A Debian or Ubuntu-based system.
Root privileges (must run with sudo).
apt and dpkg installed (typically available by default).

Installation

Clone the repository:git clone https://github.com/lmdeuser/clean-debian.git
cd clean-debian


Make the script executable:chmod +x clean-debian.sh



Usage
Run the script with root privileges:
sudo ./clean-debian.sh

The script will:

Check for root privileges.
Identify and remove old kernels and configuration files.
Clear the APT cache and user trash directories.
Update the package list.

Notes

Backup important data before running the script, as it permanently deletes files.
The script avoids removing the current kernel and common kernel packages.
Errors during trash deletion are suppressed to avoid interruptions.

License
This project is licensed under the MIT License. See the LICENSE file for details.
Contributing
Feel free to submit issues or pull requests to improve the script. Ensure any changes are tested on a Debian/Ubuntu system.
Author

Dmitriy Volkov
GitHub: lmdeuser
