import 'package:eschool/cubits/authCubit.dart';
import 'package:eschool/data/models/subject.dart';
import 'package:eschool/ui/screens/weekly_report/cubits/weekly_cubit.dart';
import 'package:eschool/ui/widgets/customBackButton.dart';
import 'package:eschool/ui/widgets/custom_drop_down.dart';
import 'package:eschool/ui/widgets/errorContainer.dart';
import 'package:eschool/ui/widgets/noDataContainer.dart';
import 'package:eschool/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'models/week_evalutions_model/week_evalutions_model.dart';
import 'models/weekly_reports_model/datum.dart';
import 'repositories/weekly_report_repo.dart';

class WeeklyReportSubjectsContainer extends StatefulWidget {
  final int? childId;
  final List<Subject>? subjects;

  const WeeklyReportSubjectsContainer({Key? key, this.childId, this.subjects})
      : super(key: key);

  @override
  WeeklyReportSubjectsContainerState createState() =>
      WeeklyReportSubjectsContainerState();

  static Route route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => WeeklyCubit(WeeklyReportRepository()),
        child: WeeklyReportSubjectsContainer(
          childId: arguments['childId'],
          subjects: arguments['subjects'],
        ),
      ),
    );
  }
}

class WeeklyReportSubjectsContainerState
    extends State<WeeklyReportSubjectsContainer> {
  List<Subject>? subjects;
  late CustomDropDownItem selectedMonthResult;

  @override
  void initState() {
    super.initState();
    selectedMonthResult = CustomDropDownItem(
      index: getMonthNumber(getMonthName(DateTime.now().month)) - 1,
      title: getMonthName(DateTime.now().month),
    );

    context.read<WeeklyCubit>().fetchWeeks(
          childId: widget.childId,
          month: DateTime.now().month,
          isParent: context.read<AuthCubit>().isParent(),
        );
    if (widget.subjects != null) subjects = List.from(widget.subjects!);
  }

  Widget _buildAppBar() {
    return ScreenTopBackgroundContainer(
      padding: EdgeInsets.zero,
      heightPercentage: UiUtils.appBarSmallerHeightPercentage,
      child: Stack(
        children: [
          context.read<AuthCubit>().isParent()
              ? CustomBackButton(
                  topPadding: MediaQuery.of(context).padding.top +
                      UiUtils.appBarContentTopPadding,
                )
              : const SizedBox.shrink(),
          Align(
            child: Text(
              UiUtils.getTranslatedLabel(context, weeklyReportsKey),
              style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
                fontSize: UiUtils.screenTitleFontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getMonthName(int monthNumber) {
    List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    if (monthNumber < 1 || monthNumber > 12) {
      return "Invalid month number";
    }

    return months[monthNumber - 1];
  }

  int getMonthNumber(String monthName) {
    List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    int monthIndex = months.indexOf(monthName);

    if (monthIndex == -1) {
      return -1;
    }

    return monthIndex + 1;
  }

  Widget _buildMySubjects() {
    print(getMonthName(DateTime.now().month));
    if (context.read<AuthCubit>().isParent() && subjects != null)
      subjects!.removeWhere((element) => element.id == 0);
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: UiUtils.getScrollViewTopPadding(
          context: context,
          appBarHeightPercentage: UiUtils.appBarSmallerHeightPercentage,
        ),
      ),
      child: Column(
        children: [
          CustomDropDownMenu(
            width: double.maxFinite,
            onChanged: (result) {
              context.read<WeeklyCubit>().fetchWeeks(
                  isParent: context.read<AuthCubit>().isParent(),
                  childId: widget.childId,
                  month: getMonthNumber(result!.title));
              setState(() {
                selectedMonthResult = result;
              });
            },
            menu: [
              "January",
              "February",
              "March",
              "April",
              "May",
              "June",
              "July",
              "August",
              "September",
              "October",
              "November",
              "December"
            ],
            currentSelectedItem: selectedMonthResult,
          ),
          BlocBuilder<WeeklyCubit, WeeklyState>(
            buildWhen: (previous, current) =>
                current is GetWeeksFailure ||
                current is GetWeeksSuccess ||
                current is GetWeeksLoading,
            builder: (context, state) {
              if (state is GetWeeksSuccess) {
                if (state.weeksModel.data!.isNotEmpty) {
                  List<String> weeksList = state.weeksModel.data!.map((item) {
                    String weekValue = item.week ?? '';
                    return weekValue;
                  }).toList();
                  context.read<WeeklyCubit>().fetchWeeklyReports(
                      isParent: context.read<AuthCubit>().isParent(),
                      childId: widget.childId,
                      date: state.weeksModel.data![0].date!);
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: WeeksDropDown(
                          childId: widget.childId!,
                          weeksModel: state.weeksModel,
                          weeksList: weeksList,
                        ),
                      ),
                      BlocBuilder<WeeklyCubit, WeeklyState>(
                        buildWhen: (previous, current) =>
                            current is GetWeeklyReportsFailure ||
                            current is GetWeeklyReportsSuccess ||
                            current is GetWeeklyReportsLoading,
                        builder: (context, state) {
                          if (state is GetWeeklyReportsSuccess) {
                            return WeeklyReportTable(
                              subjects: state.weeklyReportsModel.data!,
                            );
                          } else if (state is GetWeeklyReportsFailure) {
                            return ErrorContainer(
                              errorMessageCode: state.errorMessage,
                              onTapRetry: () {
                                context.read<WeeklyCubit>().fetchWeeklyReports(
                                    isParent:
                                        context.read<AuthCubit>().isParent(),
                                    childId: widget.childId,
                                    date: "");
                              },
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      )
                    ],
                  );
                } else {
                  return Center(
                    child: NoDataContainer(
                        titleKey: UiUtils.getTranslatedLabel(
                      context,
                      noWeeklyReportsKey,
                    )),
                  );
                }
              } else if (state is GetWeeksFailure) {
                return Center(
                  child: ErrorContainer(
                    errorMessageCode: state.errorMessage,
                    onTapRetry: () {
                      context.read<WeeklyCubit>().fetchWeeks(
                          isParent: context.read<AuthCubit>().isParent(),
                          childId: widget.childId,
                          month: DateTime.now().month);
                    },
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (context.read<AuthCubit>().isParent())
        ? Scaffold(
            body: Stack(
              children: [
                _buildMySubjects(),
                Align(
                  alignment: Alignment.topCenter,
                  child: _buildAppBar(),
                ),
              ],
            ),
          )
        : Stack(
            children: [
              _buildMySubjects(),
              Align(
                alignment: Alignment.topCenter,
                child: _buildAppBar(),
              ),
            ],
          );
  }
}

class WeeklyReportTable extends StatelessWidget {
  const WeeklyReportTable({
    super.key,
    required this.subjects,
  });

  final List<Datum> subjects;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 0.5,
            offset: Offset(0, 0),
            blurRadius: 4,
          )
        ],
      ),
      child: Table(
        children: [
          TableRow(children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  UiUtils.getTranslatedLabel(context, subjectNameKey),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  UiUtils.getTranslatedLabel(context, attendanceKey),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  UiUtils.getTranslatedLabel(context, interactionKey),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  UiUtils.getTranslatedLabel(context, homeworkKey),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  UiUtils.getTranslatedLabel(context, studentLevelKey),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ]),
          ...subjects.asMap().entries.map((entry) {
            int index = entry.key;
            var subject = entry.value;

            return TableRow(
              decoration: BoxDecoration(
                color: index % 2 == 0
                    ? Colors.grey[200]
                    : Colors.white, // Alternating row colors
              ),
              children: [
                Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                    child: FittedBox(
                      child: Text(
                        subject.subjectName!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      subject.attendance!.toString(),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      subject.participation.toString(),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      subject.homework.toString(),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      subject.studentLevel.toString(),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}

class WeeksDropDown extends StatefulWidget {
  const WeeksDropDown(
      {super.key,
      required this.weeksList,
      required this.weeksModel,
      required this.childId});

  final List<String> weeksList;
  final WeeksModel weeksModel;
  final int childId;

  @override
  State<WeeksDropDown> createState() => _WeeksDropDownState();
}

class _WeeksDropDownState extends State<WeeksDropDown> {
  CustomDropDownItem selectedWeekResult = CustomDropDownItem(
    index: 0,
    title: "",
  );

  String date = '';

  @override
  Widget build(BuildContext context) {
    return CustomDropDownMenu(
      width: double.maxFinite,
      onChanged: (result) {
        print(result!.title);
        date = widget.weeksModel.data!
            .firstWhere(
              (element) => element.week == result.title,
            )
            .date!;
        context.read<WeeklyCubit>().fetchWeeklyReports(
              isParent: context.read<AuthCubit>().isParent(),
              childId: widget.childId,
              date: date,
            );
        selectedWeekResult = result;
        setState(() {});
      },
      menu: widget.weeksList,
      currentSelectedItem: selectedWeekResult,
    );
  }
}
