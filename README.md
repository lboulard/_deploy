## Semi scripted installation of Windows setup

This is mix an user only installations and system installations.

### Fixed locations

- `LBHOME` = `C:\lb`
- `LBPROGRAMS` = `C:\lb\programs`

Modify `lb\01_lb_acl.bat` and `lb\02_setx_env.bat` to change default location.


### Caveats

#### Restoring from network drive

When restoring from network drive, a mapped network drive on local letter drive
is required. When running from (mapped or not) network drive, Windows sees
junction folder as normal folder.

SECURITY: with mapped network driver, system installation does not see mapped
drive of logged user. You need to create same letter drive for same mapped
network drive in an Administrator `CMD.EXE` using `net use` command.

#### Vim (system)

Restoring Vim is complex:

 - Import `installs/attended/Vim 9.1.reg` in `HKLM` registry. File contains
   "uninstall" data that will be used to install Vim again.
 - WARNING: default installation is `C:\lb\Vim`.
 - WARNING: Change registry files before import when VIM version is different.
 - You can change installation location during Vim setup wizard.

#### Git (system)

Git system install requires that Vim is already installed in `C:\lb\Vim` first.
Edit `silent-install-git.inf` to change location.


### Folder

- `lb`: copy to "`$LBHOME/_deploy`" ("`%LBHOME%\_deploy`")
- `installs`: copy to "`.../Installs/_deploy`" ("`...\Installs\_deploy`")
