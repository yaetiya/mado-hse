import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madoapp/components/custom_divider.dart';
import 'package:madoapp/components/html_render.dart';
import 'package:madoapp/configs/theme_config.dart';
import 'package:madoapp/models/course.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const double paddingX = 26;

class ActiveCourse extends StatefulWidget {
  final Course course;
  final void Function() onCourseCompleted;
  final void Function() backToCourseDescription;
  const ActiveCourse(
      {Key? key,
      required this.course,
      required this.onCourseCompleted,
      required this.backToCourseDescription})
      : super(key: key);

  @override
  State<ActiveCourse> createState() => _ActiveCourseState();
}

class _ActiveCourseState extends State<ActiveCourse> {
  int activePartIndex = 0;
  double _paperOffset = 400.0;
  void onNextPartButtonClick() {
    if (activePartIndex == widget.course.parts.length - 1) {
      widget.onCourseCompleted();
      return;
    }
    setState(() {
      activePartIndex++;
    });
  }

  void onPrevPartButtonClick() {
    if (activePartIndex == 0) {
      widget.backToCourseDescription();
      return;
    }
    setState(() {
      --activePartIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    double fullWidthWithoutPadding = MediaQuery.of(context).size.width - 2 * 26;
    double fullWidth = MediaQuery.of(context).size.width;
    double fullHeight = MediaQuery.of(context).size.height;
    const double bottomBarHeight = 62.0;
    final activePart = widget.course.parts[activePartIndex];
    final totalParts = widget.course.parts.length - 1;
    final isLastStep = activePartIndex == widget.course.parts.length - 1;
    double bottomPaperBreakpoint = 3 * (fullHeight - bottomBarHeight) / 4;

    return Stack(fit: StackFit.expand, children: [
      activePart.interactiveUrl != null
          ? Positioned(
              key: ObjectKey(activePart.interactiveUrl!),
              left: 0,
              height: bottomPaperBreakpoint,
              width: fullWidth,
              child: WebView(
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: activePart.interactiveUrl!,
              ))
          : const SizedBox(),
      activePart.interactiveUrl != null
          ? Positioned(
              left: 0,
              top: _paperOffset,
              height: fullHeight - _paperOffset - bottomBarHeight,
              width: fullWidth,
              child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    _paperOffset += details.delta.dy;
                    if (_paperOffset <= fullHeight / 6) {
                      _paperOffset = fullHeight / 6;
                    }
                    if (_paperOffset > bottomPaperBreakpoint) {
                      _paperOffset = bottomPaperBreakpoint;
                    }
                    setState(() {});
                  },
                  child: Container(
                    // height: fullHeight - _paperOffset,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black87.withOpacity(0.2),
                          spreadRadius: 6,
                          blurRadius: 25,
                          offset: const Offset(
                              0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 3,
                          width: 60,
                          decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(50)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                            height:
                                fullHeight - _paperOffset - 8 - 20 - 20 - 60,
                            child: PartContent(activePart: activePart)),
                      ],
                    ),
                  )))
          : PartContent(activePart: activePart),
      Positioned(
          // height 16 + 16 + 8 + 8 + 14 (text) = 62
          bottom: 0.0,
          child: Container(
            width: fullWidth,
            decoration: const BoxDecoration(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.only(
                left: paddingX,
                right: paddingX,
              ),
              child: Column(
                children: [
                  const CustomDivider(),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CupertinoButton(
                          borderRadius: BorderRadius.circular(30.0),
                          onPressed: onPrevPartButtonClick,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 34, vertical: 16),
                          child: Text(AppLocalizations.of(context)!.back),
                        ),
                        Text((activePartIndex + 1).toString() +
                            '/' +
                            (totalParts + 1).toString()),
                        CupertinoButton(
                          borderRadius: BorderRadius.circular(30.0),
                          color: isLastStep
                              ? ThemeConfig.kSuccess
                              : ThemeConfig.kPrimary,
                          onPressed: onNextPartButtonClick,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                          child: Text(
                              isLastStep
                                  ? AppLocalizations.of(context)!.done
                                  : AppLocalizations.of(context)!.next,
                              style: const TextStyle(color: Colors.white)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    ]);
  }
}

class PartContent extends StatelessWidget {
  const PartContent({
    Key? key,
    required this.activePart,
  }) : super(key: key);

  final Part activePart;

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      isAlwaysShown: true,
      child: Padding(
        padding: const EdgeInsets.only(left: paddingX, right: paddingX),
        child: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              const SizedBox(
                height: 10,
              ),
              HtmlRender(html: activePart.content),
              const SizedBox(
                height: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
