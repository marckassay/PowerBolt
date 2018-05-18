[Flags()] enum BackupPredicates {
    IsConfigFileValid = 1
    IsTurnOnBackupValid = 2
    IsBackupPolicyValid = 4
    IsPrecheckValid = 7

    IsPathValid = 8
    IsDestinationValid = 16
    IsItemDirty = 32
    AreSourcesReady = 56

    HasUpdatedSuccessfully = 64
}