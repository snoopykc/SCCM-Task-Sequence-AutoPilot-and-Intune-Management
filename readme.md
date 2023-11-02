This is a fork of the https://github.com/windows-admins/Intune/tree/main/TaskSequenceFiles repo and the https://github.com/credibledevcom/AutoPilotTS/tree/main/TaskSequenceFiles repo.

Please check those repos for installation instructions.

Modifications made were to include an additional script allowing the deletion of old Intune objects so that they may be deployed to other users. You can also create a new webhook chat to be notified of successful deletes and failures. Devices that aren't in Intune will fail with a null error. I plan to add cleaner errors for those devices at some point. Additional Azure permissions within the Azure app created for the Autopilot side will also need added.

Additional permissions needed for your API app are:
Device.ReadWrite.All
Device.ManagementManagedDevices.ReadWrite.All

There are also additional modules that were needed that I've included in my repo.

Your task sequence in SCCM will need an additional Powershell script step for Script4.ps1.
