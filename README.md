
<p align="center">
  <img src="./Powershelling_23-logo.png" alt="logo" title="Powershelling_23 logo" width="160">
</p>
# PowerShelling_23

Welcome to the `PowerShelling_23` project! This repository is an open-source initiative designed to offer a unique and interactive way to learn PowerShell. It's structured as a series of challenges, each progressively building on the skills acquired in the previous tasks. Whether you're a beginner or a seasoned PowerShell user, these tasks are designed to enhance your understanding and proficiency in scripting and system administration using PowerShell.

## Task Solutions

Below are the solutions for each user level in the PowerShelling_23 challenge:

### User 3 Solution

To find the `supersecret.txt` file for user3, use the following command:

```powershell
Get-ChildItem -Path C:\ -Recurse -Filter supersecret.txt -ErrorAction SilentlyContinue
```

### User 4 Solution

To retrieve the updated password for user4, run this command:

```powershell
(Get-EventLog -LogName Application -Source "Task4EventSource" -Newest 1).Message
```

### User 5 Solution

To get the password for user5 from the registry, execute:

```powershell
(Get-ItemProperty -Path "HKCU:\Software\Task5Challenge").Password
```

### User 6 Solution

For user6, find the current DNS setting with:

```powershell
(Get-DnsClientServerAddress -AddressFamily IPv4).ServerAddresses
```

### User 7 Solution

To identify the network adapter with the highest data usage for user7:

```powershell
(Get-NetAdapterStatistics | Sort-Object -Property ReceivedBytes -Descending | Select-Object -First 1).Name
```

## Contributing to PowerShelling_23

We welcome contributions to the PowerShelling_23 project! Whether you're looking to fix bugs, enhance the existing tasks, or add new challenges, your input is valuable. Here's how you can contribute:

1. Fork the Repository: Start by forking the PowerShelling_23 repository to your GitHub account.1

2. Clone the Forked Repo: Clone the repository to your local machine to make changes.

3. Create a New Branch: For each new feature or fix, create a separate branch.

4. Commit Your Changes: Make your changes in the respective branch and commit them with a clear, descriptive message.

5. Push to Your Fork: Push the changes to your forked repository.

6. Submit a Pull Request: Create a pull request from your forked repository to the original PowerShelling_23 repository.

7. Code Review: Your pull request will be reviewed, and, if approved, merged into the project.

We appreciate your efforts in improving and expanding the PowerShelling_23 learning experience!
