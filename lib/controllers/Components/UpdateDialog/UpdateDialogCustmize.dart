import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xeats/controllers/Components/AppBar/AppBarCustomized.dart';

class UpdateDialog extends StatefulWidget {
  const UpdateDialog({super.key});

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  Future<bool> checkVersion() async {
    final newVersion = NewVersionPlus(
      androidId: "com.xeats.egy",
    );
    final status = await newVersion.getVersionStatus();

    bool Check = status!.canUpdate;
    print(Check);
    print(status);
    if (status.canUpdate) {
      newVersion.showUpdateDialog(
        launchMode: LaunchMode.externalApplication,
        context: context,
        versionStatus: status,
        allowDismissal: false,
        dialogTitle: "UPDATE!!!",
        dialogText:
            "Please update the app from ${status.localVersion} to ${status.storeVersion}",
        updateButtonText: "Lets update",
      );
      return true;
    } else {
      return false;
    }
  }

  void initState() {
    checkVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context,
        subtitle: "UpdateScreen",
        title: "Update Screen",
      ),
    );
  }
}
