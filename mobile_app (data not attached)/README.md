# Mobile application data of a large retail chain

These data reflect how our application is installed (*installs*), how actively products are viewed in it (*events*), how actively purchases are made in it (*checks*), and the data on matching devices with logins (*devices*).

***installs*** — contains data about application installations per day.

**DeviceID** — identifier of the device on which the application was installed;
**InstallationDate** — date of application installation;
**InstallCost** — cost of application installation in rubles;
**Platform** — platform on which the application was installed (iOS/ Android);
**Source** — source of application installation (app store/ advertising system/ website referral).

***events*** — contains data on how actively users view products in the application per day.

**DeviceID** — identifier of the device on which the application is used;
**AppPlatform** — platform on which the application is used (iOS/ Android);
**EventDate** — date for which statistics are collected;
**events** — number of views of all products for this day for this DeviceID.

***checks*** — contains data on user purchases in the application per day.

**UserID** — user identifier;
**Rub** — user's total purchase amount for the date;
**BuyDate** — date for which statistics are collected.

The application's peculiarity is that no authentication is required to view products. Until the moment of authentication, only the user's DeviceID — device identifier is known. At the same time, for making a purchase, login is mandatory. At the authentication stage, the user is assigned a UserID, and then we already know two of their identifiers: DeviceID (device) and UserID (login). Since users can still be unauthenticated during the installation and catalog browsing stages, we only save DeviceID there. But since purchases cannot be made without authentication, purchases are only saved with UserID. In order to combine views and installations with purchases, we need a table mapping DeviceID to UserID, i.e., the devices table:

**DeviceID** — device identifier;
**UserID** — user identifier.