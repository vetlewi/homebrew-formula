# My own brew tap
---
This repo contains brew recipies that I use in other projects. I just need to have it somewhere.

To use it, first install Homebrew:
```
$ ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
```
Then you need to add this tap
```
$ brew tap vetlewi/formula
```
Then you can start installing stuff!

## Adding new packages
To add a new package to the repository one should just add the homebrew formula to this repo.

## Making bottle
To build and generate bottle run the two following commands:
```
brew install --build-bottle <name_of_formula>
```
Then run
```
brew bottle --root-url="https://github.com/vetlewi/homebrew-formula/releases/download/v1.0" --no-rebuild <name_of_formula>
```
Then upload the package to the github release, in this case the one with tag v1.0