import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madoapp/components/bouncing.dart';
import 'package:madoapp/components/section_name.dart';
import 'package:madoapp/components/service_view.dart';
import 'package:madoapp/components/show_paper.dart';
import 'package:madoapp/models/project.dart';
import 'package:madoapp/services/scren_size_service.dart';
import 'package:madoapp/tools/colors_tools.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:madoapp/tools/string_tools.dart';
import 'package:url_launcher/url_launcher.dart';

class TopServices extends StatelessWidget {
  final List<Project> projects;
  const TopServices({Key? key, required this.projects}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isBigScreen = ScreenSizeService.isBigScreen(context);

    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: SectionName(name: AppLocalizations.of(context)!.topServices),
        ),
        GridView(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 40),
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 2,
              crossAxisCount: (isBigScreen ? 4 : 2),
              crossAxisSpacing: 9,
              mainAxisSpacing: 9),
          children: (projects)
              .map((e) => ProjectSmallPreview(
                    project: e,
                  ))
              .toList(),
        )
      ],
    );
  }
}

class ProjectSmallPreview extends StatelessWidget {
  const ProjectSmallPreview({
    Key? key,
    required this.project,
  }) : super(key: key);

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Bouncing(
      onPress: () {
        if (StringTools.isMadoUrl(project.url)) {
          launch(project.url, forceSafariVC: false);
          return;
        }
        ShowPaper.showActionSheet(context, ServiceView(url: project.url),
            isWithPadding: false);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        elevation: 17,
        shadowColor: Colors.black45,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: project.color.toColor(),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: [
                      Text(
                        project.name,
                        style: TextStyle(
                            color: project.textColor.toColor(),
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        project.description,
                        style: TextStyle(
                            fontSize: 12, color: project.textColor.toColor()),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                bottom: 10,
                left: 10,
                child: Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 5,
                  children: project.tags
                      .map((t) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                // border: Border.all(color: Colors.black, width: 0.1),
                                borderRadius: BorderRadius.circular(40)),
                            child: Center(
                              child: Text(
                                t,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10),
                              ),
                            ),
                          ))
                      .toList(),
                )),
          ],
        ),
      ),
    );
  }
}
