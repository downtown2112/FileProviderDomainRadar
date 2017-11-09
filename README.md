# FileProviderDomainRadar

# Description
I am utilizing NSFileProviderDomains to segregate a single file provider into multiple NSFileProviderExtension. Each domain will represent a separate user account and is necessary so that the extension may fetch data with the correct set of credentials.

The issue is that removing an NSFileProviderDomain does not update any system UIs which may be displaying a list of NSFileProviderExtensions. I'm using the Files app for illustration purposes, but the same issue applies to 3rd party applications displaying the file provider UI.  This can lead (at best) to uncertainty on the user's part to (at worst) a crash of the application displaying the extensions.

Note that ADDING a domain DOES immediately update system UIs.  Interestingly, ADDING a new domain also causes extensions based on a deleted domain to disappear from the UI.


# Steps to Reproduce - Generic
1. Implement rudimentary support for a File Provider in an application.  (I just used the stock boilerplate template and code.)

2. Install the application

3. Before doing anything in the application, look at the list of locations in the Files app. Note that one FileProviderExtension exists for the application.  (This is NOT domain based)

4. In the application, create a new NSFileProviderDomain
5. Go to the Files app and see that the generic (no domain) extension has been removed from Locations and it has been replaced with the new extension (with a domain)
6. In the application, remove the domain just created
7. Go to the Files app and see that the extension still exists that was based on the removed domain.
8. Click on the extension 
9. Files app crashes

# Steps to Reproduce - Sample App

1. Test harness source code available from GitHub:
2. Install FileProviderDomainRadar on an iPad that supports side-by-side multitasking (changing signing credentials in XCode as necessary)
3. After the app launches, open the Files app in multitasking mode
4. FileProviderDomainRadar will have an empty table.
5. The Files app will show an extension named "MyFileProvider"
6. In the FileProviderDomainRadar app, click the "Add" button in the bottom left to create a new domain
7. You will see the File app's Locations immediately update. "MyFileProvider" will be removed and it will be replaced with "MyFileProvider - <domainIdentifier>"
8. In the FileProviderDomainRadar app, click the "Delete First" button in the bottom right to delete the first domain in the table
9. The Files app does NOT immediately update. It still shows the same extension from Step 7.
10. In the FileProviderDomainRadar app, click the Add button again.
11. The Files app updates to remove the "bad" extension and it is replaced with the correc one.
12. Click the "Delete First" button again in FileProviderDomainRadar app
13. The Files app does NOT update.
14. Click on the extension in the Files app that SHOULD have been removed.
15. The Files app crashes

# Expected Result
When deleting a NSFileProviderDomain, an extension based on this domain should be removed from system UIs