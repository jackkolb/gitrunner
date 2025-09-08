# Gitrunner

A simple script to pull from git and run a proc file after changes.

## Usage

1. Clone the project git repositories into this directory.
2. Open `repositories.txt` and write the repository names, one repository per line:
```
project-1
project-2
project-3
```
3. Open `proc.txt` and write the proc commands to run after each repo is updated, this is run in the project folder and should not be a persistent script:
```
project-1:run.sh
project-2:echo "Here!"
project-3:run.sh 42
```
4. Run `gitrunner.sh` via a cron job, or run `gitrunner-loop.sh` to run the script continuously with a 30 second sleep period.