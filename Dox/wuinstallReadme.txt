WuInstall Version 1.1.

(c) 2009 by hs2n Information Technology

WuInstall is a command line tool for windows, which enables you to install windows-updates for a certain workstation in a controlled way by using a command line script instead of the standard window update functionality.

It can be used by administrators for updates on many workstations using scripts or for users who do not want to us the automatic windows upates. 

WuInstall uses the windows update API and is written in C++. It searches either on the Microsoft - Update - Server or at the internal WSUS-Sever (depending on system configuration) for currently available updates for the current workstation and can also download and/or installs these updates. It is roughly comparable with a simplified apt-get command like in linux.

WuInstall was developed for XEOX, but can also be downloaded as a standalone-application for free.


Remark for using proxies:

- When using a proxy which needs authentifcation, the user who executes wuinstall has to have the right to access the internet via the prox
- When using a WSUS via prox, the wsus should be in the proxy exception list


Features:

	/search -> Searches only for available updates

	/download -> Searches and downloads updates

	/install -> Searches and downloads and installs update

	/reboot [nseconds] -> Forces a reboot after executing WuInstall after nseconds (or default 10) seconds

	/criteria "query string" -> searches for Updates, which match the query string. For query strings see http://msdn.microsoft.com/en-us/library/aa386526(VS.85).aspx. The default criteria is "IsInstalled=0 and Type='Software'"

	/match "search string" -> searches for updates which match the search string (no regular expressions posible so far!)


/criteria and /match and /reboot are applicable mit search, install or update. They can also be used in combination.

Example:
wuInstall /search /criteria "IsInstalled=1 and Type='Software'" /match "KB934"


Return codes:
	0  -> successful, no reboot required
	1  -> at least one error occured, no reboot required
	2  -> no more updates availabe
	3  -> no updates available that match specified match string
	4  -> invalid criteria specified
	5  -> reboot initialized successfull
	6  -> reboot failed
	10 -> successful, reboot required
	11 -> at least one error occured, reboot required


see also http://www.xeox.com for details and new versions


Contact wuinstall@hs2n.at for questions and requests