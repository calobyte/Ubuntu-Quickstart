# Callum's quick start for Ubuntu

## The problem

I love Ubuntu, however I find myself (re)installing the distro multiple times a year. That takes away from precious time that could be spend writing code or spending time with my family

## The solution

I want to automate the whole bang-shoot, I have already created [Nubuntu](https://github.com/calobyte/nubuntu) for debloating, theming and installing the necessary packages I need and [Laravel-Localenv](https://github.com/calobyte/laravel-localenv) that I use to setup some basic VS Code extensions as well as install `php`, `composer` and `laravel` as well as `nvm`, `node` and `npm`. So I am pretty much there...

## What more do I need?

- [x] More VS Code extensions
  - [x] spellchecker
  - [x] Error lens
  - [x] prettier
- [x] A SSH key pair
- [x] Git Config
- [x] Some additional applications
  - [x] VirtualBox
  - [x] Tilix (a better terminal)
        [x] Fix error on launch
  - [x] Localsend
  - [x] Bruno (REST Client)
  - [x] Something to sign PDF's with (found xournalapp)
  - [x] Basic office suite (Probably libre office went for only office)
  - [x] OBS
  - [x] GIMP and Pinta
  - [x] Video editor (kdenlive? or better maybe resolve) (settled for kdenlive)
  - [x] Cura for 3D slicing
  - [x] Remote desktop software (remmina)
  - [x] Media player (vlc)

There are quite a few applications on this list, and I probably have not exhausted the requirements, however I think this is a great start!

```bash
time sudo apt-get install -yq curl && curl -o- https://raw.githubusercontent.com/calobyte/woza/refs/heads/main/24.04.sh | bash
```

```bash
time sudo apt-get install -yq curl && curl -o- https://raw.githubusercontent.com/calobyte/woza/refs/heads/main/25.04.sh | bash
```

