# ReleaseTickets
Prints a list of tickets for a specified release (compatible with git flow). For this script to work the project must use commit mesages beggining with ticket name, i.e.
```
#3: fix misspelings in README.md
```

## Example

Running following command on this repository
```bash
./tickets.rb --from 0.2.0 --to 0.1.0
```

will print out
```
Found 3 tickets in git:
#1
#2
#3
```

## How It Works

This script first searches for branches and tags having names ending with given versions. Sticking to our example our repository looks like this
```
c5ca77993fbbd95cfed2f052f1d188465f01e12c	refs/heads/develop
0cbc7d36258df84f016df2a49a54771f77fc0bf0	refs/heads/feature/1
c5ca77993fbbd95cfed2f052f1d188465f01e12c	refs/heads/feature/2
77d9ad42b76cd712659a2aa5dd7539726382ccad	refs/heads/master
3cd60dc6c6aa1b63823244804db24cacbd5872d3	refs/heads/release/0.2.0
504a71184e785bca0f46febae945645f54167908	refs/tags/0.1.0
```

After extracting hashes for matching tags and branches it then extracts ticket numbers from all commit messages between two hashes. In our example we have following commits
```
* 3cd60dc (HEAD, origin/release/0.2.0, release/0.2.0) #3: add example of how it works to README.md
* 7d024b0 #3: fix misspelings in README.md
* 8c74d95 fix error messages
* c5ca779 (origin/feature/2, origin/develop, feature/2, develop) #2: print ticket number message separated with new lines
* 0cbc7d3 (origin/feature/1, feature/1) #1: move ticket number reggae from config to script
```
Above it is visible that tickets number 1, 2, 3 are included in the next release 0.2.0.

## Ticket names in commit messages
This script will work if commit messages follow convention
```
<ticket name><rest of the message>
```

Multiline messages are also supported
```
<ticket name><rest of the message>
<other ticket name><rest of the message>
```

What is also important is that ticket name has to end with ticket number. Examples of supported ticket names:
9000
\#9000
NEXTBIGTHING-9000

In case when number is prefixed, please configure it in `config.yaml`. For the last example proper config will look like this
```
tickets_prefix: 'NEXTBIGTHING-'
```
