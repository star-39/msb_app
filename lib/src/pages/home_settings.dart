
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:msb_app/src/define.dart';
import 'package:msb_app/src/settings.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:provider/provider.dart';
import '../util.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(builder: (context, provider, child) {
      var sections = <SettingsSection>[
        SettingsSection(
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              title: Text(AppLocalizations.of(context)!.publisher),
              value: Text(provider.publisher),
              description: Text(AppLocalizations.of(context)!.publisherDesc),
              onPressed: (context) {
                context.push('/settings/publisher');
              },
            ),
          ],
        ),
        SettingsSection(
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              title: Text(AppLocalizations.of(context)!.about),
              onPressed: (context) {
                context.push('/settings/about');
              },
            ),
          ],
        ),
      ];
      if (provider.updateAvailable) {
        sections.add(SettingsSection(
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              title: Text(AppLocalizations.of(context)!.installUpdate),
              onPressed: (context) {
                openDownloadLink();
              },
            ),
          ],
        ));
      }

      return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text(AppLocalizations.of(context)!.about),
          ),
          child: SafeArea(
              child: SettingsList(
            applicationType: ApplicationType.cupertino,
            brightness: MediaQuery.of(context).platformBrightness,
            sections: sections,
            platform: DevicePlatform.iOS,
          )));
    });
  }
}

class PublisherPage extends StatefulWidget {
  const PublisherPage({super.key});

  @override
  State<PublisherPage> createState() => _PublisherPage();
}

class _PublisherPage extends State<PublisherPage> {
  late TextEditingController _publisherController;

  @override
  void dispose() {
    _publisherController.dispose();
    super.dispose();
  }

  void onComplete(provider) {
    setState(() {
      provider.publisher = _publisherController.text;
    });
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(builder: (context, provider, child) {
      _publisherController = TextEditingController(text: provider.publisher);

      return CupertinoPageScaffold(
          backgroundColor: CupertinoColors.secondarySystemBackground,
          navigationBar: CupertinoNavigationBar(
            middle: Text(AppLocalizations.of(context)!.publisher),
          ),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              CupertinoTextField(
                autofocus: true,
                controller: _publisherController,
                autocorrect: false,
                onEditingComplete: () => onComplete(provider),
              )
            ],
          ));
    });
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(AppLocalizations.of(context)!.about),
        ),
        child: const Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text("Telegram @$botName"),
          SizedBox(height: 10),
          Text("Released under the GPL v3 License."),
          SizedBox(height: 10),
          Text("Version: $versionNumber"),
          SizedBox(height: 10),
          CupertinoButton(
            onPressed: openHomePage,
            child: Text(projectUrl),
          ),
        ])));
  }
}
