This is a fork of the https://github.com/windows-admins/Intune/tree/main/TaskSequenceFiles repo and the https://github.com/credibledevcom/AutoPilotTS/tree/main/TaskSequenceFiles repo.

Modifications made were to include an additional script allowing the deletion of old Intune objects so that they may be deployed to other users. You can also create a new webhook chat to be notified of successful deletes and failures. Devices that aren't in Intune will fail with a null error. I plan to add cleaner errors for those devices at some point. Additional Azure permissions within the Azure app created for the Autopilot side will also need added.

I have also changed how this is deployed in our Intune task sequence. We were having issues in our environment where devices wouldn't completely uninstall the CCMClient and the devices would appear as co-managed in Intune. We opted to change our task sequence so that a base image is layed with no drivers, then the SCCM Client is installed, then the scripts run. The task sequence restarts and wipes and repartitions the drive and images the device as normal. This avoids any chance of the SCCM client remaining on the device.

Additional permissions needed for your API app are:
Device.ReadWrite.All
Device.ManagementManagedDevices.ReadWrite.All

There are also additional modules that were needed that I've included in my repo.

The installation of this program is simple.
1. Create a package with the downloaded directory. Do not create a program.
2. Create steps in your task sequence to wipe the drive, install your base image.
3. Use Run Powershell Script steps, target each script in the package.
4. Restart in task sequence and image your device as normal.
