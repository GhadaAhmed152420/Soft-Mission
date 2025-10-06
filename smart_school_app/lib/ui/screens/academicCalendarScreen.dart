// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:eschool/cubits/appConfigurationCubit.dart';
import 'package:eschool/cubits/authCubit.dart';
import 'package:eschool/cubits/eventsCubit.dart';
import 'package:eschool/cubits/holidaysCubit.dart';
import 'package:eschool/data/models/event.dart';
import 'package:eschool/data/models/holiday.dart';
import 'package:eschool/data/repositories/systemInfoRepository.dart';
import 'package:eschool/ui/styles/colors.dart';
import 'package:eschool/ui/widgets/customBackButton.dart';
import 'package:eschool/ui/widgets/customShimmerContainer.dart';
import 'package:eschool/ui/widgets/customTabBarContainer.dart';
import 'package:eschool/ui/widgets/errorContainer.dart';
import 'package:eschool/ui/widgets/eventsContainer.dart';
import 'package:eschool/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:eschool/ui/widgets/shimmerLoadingContainer.dart';
import 'package:eschool/ui/widgets/tabBarBackgroundContainer.dart';
import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:eschool/ui/widgets/holidaysContainer.dart';

class AcademicCalendarScreen extends StatefulWidget {
  final bool isEvent;
  final bool hasBack;
  const AcademicCalendarScreen({
    Key? key,
    required this.isEvent,
    required this.hasBack,
  }) : super(key: key);

  static Route route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider<HolidaysCubit>(
            create: (context) => HolidaysCubit(SystemRepository()),
          ),
          BlocProvider<EventsCubit>(
            create: (context) => EventsCubit(SystemRepository()),
          ),
        ],
        child: AcademicCalendarScreen(
          isEvent: arguments['isEvent'] ?? false,
          hasBack: arguments['hasBack'] ?? false,
        ),
      ),
    );
  }

  @override
  State<AcademicCalendarScreen> createState() => _AcademicCalendarScreenState();
}

class _AcademicCalendarScreenState extends State<AcademicCalendarScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  final ValueNotifier<String> _selectedTabTitle = ValueNotifier(holidaysKey);

  //last and first day of calendar
  DateTime firstDay = DateTime.now();
  DateTime lastDay = DateTime.now();

  //for range showing
  List<DateTime> innerDates = [];
  List<DateTime> startWithNoEnd = [];
  List<DateTime> startDates = [];
  List<DateTime> endDates = [];

  //current day
  DateTime holidayFocusedDay = DateTime.now();
  DateTime eventsFocusedDay = DateTime.now();

  List<Event> events = [];
  List<Holiday> holidays = [];

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      if (widget.isEvent) {
        _pageController.jumpToPage(1);
      }
      context.read<HolidaysCubit>().fetchHolidays();
      context.read<EventsCubit>().fetchEvents();
    });

    super.initState();
  }

  @override
  void dispose() {
    _selectedTabTitle.dispose();
    _pageController.dispose();

    super.dispose();
  }

  void updateMonthViceHolidays() {
    holidays.clear();
    for (final holiday in context.read<HolidaysCubit>().holidays()) {
      if (holiday.date.month == holidayFocusedDay.month &&
          holiday.date.year == holidayFocusedDay.year) {
        holidays.add(holiday);
      }
    }

    holidays.sort((first, second) => first.date.compareTo(second.date));
    setState(() {});
  }

  void updateMonthViceEvents() {
    events.clear();
    startDates.clear();
    startWithNoEnd.clear();
    endDates.clear();
    innerDates.clear();
    for (final event in context.read<EventsCubit>().events()) {
      if (event.startDate?.month == eventsFocusedDay.month &&
          event.startDate?.year == eventsFocusedDay.year) {
        events.add(event);
      } else if (event.endDate?.month == eventsFocusedDay.month &&
          event.endDate?.year == eventsFocusedDay.year) {
        events.add(event);
      }
    }

    events
        .sort((first, second) => first.startDate!.compareTo(second.startDate!));

    //calculation for ranged highliters
    for (int i = 0; i < events.length; i++) {
      Event event = events[i];
      if (event.startDate != null) {
        if (event.endDate == null) {
          startWithNoEnd.add(event.startDate!);
        } else {
          startDates.add(event.startDate!);
          endDates.add(event.endDate!);
          for (DateTime date = event.startDate!.add(Duration(days: 1));
              date.isBefore(event.endDate!);
              date = date.add(Duration(days: 1))) {
            innerDates.add(date);
          }
        }
      }
    }
    setState(() {});
  }

  Widget _buildAppBar() {
    return ScreenTopBackgroundContainer(
      heightPercentage: UiUtils.appBarBiggerHeightPercentage,
      child: LayoutBuilder(builder: (context, boxConstraints) {
        return ValueListenableBuilder<String>(
          valueListenable: _selectedTabTitle,
          builder: (context, selectedTitle, _) => Stack(
            clipBehavior: Clip.none,
            children: [
              context.read<AuthCubit>().isParent() || widget.hasBack
                  ? const CustomBackButton()
                  : const SizedBox(),
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  UiUtils.getTranslatedLabel(context, academicCalendarKey),
                  style: TextStyle(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    fontSize: UiUtils.screenTitleFontSize,
                  ),
                ),
              ),
              AnimatedAlign(
                curve: UiUtils.tabBackgroundContainerAnimationCurve,
                duration: UiUtils.tabBackgroundContainerAnimationDuration,
                alignment: selectedTitle == holidaysKey
                    ? AlignmentDirectional.centerStart
                    : AlignmentDirectional.centerEnd,
                child:
                    TabBarBackgroundContainer(boxConstraints: boxConstraints),
              ),
              CustomTabBarContainer(
                boxConstraints: boxConstraints,
                alignment: AlignmentDirectional.centerStart,
                isSelected: selectedTitle == holidaysKey,
                onTap: () {
                  if (_selectedTabTitle.value != holidaysKey) {
                    _pageController.jumpToPage(0);
                    _selectedTabTitle.value = holidaysKey;
                  }
                },
                customPostFix: holidays.isEmpty
                    ? null
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: onPrimaryColor,
                        ),
                        margin: const EdgeInsetsDirectional.only(start: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          holidays.length.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                titleKey: holidaysKey,
              ),
              CustomTabBarContainer(
                boxConstraints: boxConstraints,
                alignment: AlignmentDirectional.centerEnd,
                isSelected: selectedTitle == eventsKey,
                onTap: () {
                  if (_selectedTabTitle.value != eventsKey) {
                    _pageController.jumpToPage(1);
                    _selectedTabTitle.value = eventsKey;
                  }
                },
                customPostFix: events.isEmpty
                    ? null
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: onPrimaryColor,
                        ),
                        margin: const EdgeInsetsDirectional.only(start: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          events.length.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                titleKey: eventsKey,
              ),
            ],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocListener<EventsCubit, EventsState>(
            listener: (context, state) {
              if (state is EventsFetchSuccess) {
                if (UiUtils.isTodayInSessionYear(
                  context
                      .read<AppConfigurationCubit>()
                      .getAppConfiguration()
                      .sessionYear
                      .startDate,
                  context
                      .read<AppConfigurationCubit>()
                      .getAppConfiguration()
                      .sessionYear
                      .endDate,
                )) {
                  firstDay = context
                      .read<AppConfigurationCubit>()
                      .getAppConfiguration()
                      .sessionYear
                      .startDate;
                  lastDay = context
                      .read<AppConfigurationCubit>()
                      .getAppConfiguration()
                      .sessionYear
                      .endDate;
                  updateMonthViceEvents();
                }
              }
            },
            child: BlocListener<HolidaysCubit, HolidaysState>(
              listener: (context, state) {
                if (state is HolidaysFetchSuccess) {
                  if (UiUtils.isTodayInSessionYear(
                    context
                        .read<AppConfigurationCubit>()
                        .getAppConfiguration()
                        .sessionYear
                        .startDate,
                    context
                        .read<AppConfigurationCubit>()
                        .getAppConfiguration()
                        .sessionYear
                        .endDate,
                  )) {
                    firstDay = context
                        .read<AppConfigurationCubit>()
                        .getAppConfiguration()
                        .sessionYear
                        .startDate;
                    lastDay = context
                        .read<AppConfigurationCubit>()
                        .getAppConfiguration()
                        .sessionYear
                        .endDate;
                    updateMonthViceHolidays();
                  }
                }
              },
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  if (index == 0) {
                    _selectedTabTitle.value = holidaysKey;
                  } else {
                    _selectedTabTitle.value = eventsKey;
                  }
                },
                children: [
                  BlocBuilder<HolidaysCubit, HolidaysState>(
                    builder: (context, state) {
                      if (state is HolidaysFetchSuccess) {
                        return HolidaysContainer(
                          holidays: holidays,
                          onPageChanged: (DateTime dateTime) {
                            setState(() {
                              holidayFocusedDay = dateTime;
                            });
                            updateMonthViceHolidays();
                          },
                          firstDay: firstDay,
                          lastDay: lastDay,
                          focusedDay: holidayFocusedDay,
                        );
                      }

                      if (state is HolidaysFetchFailure) {
                        return Padding(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width *
                                UiUtils
                                    .screenContentHorizontalPaddingInPercentage,
                            right: MediaQuery.of(context).size.width *
                                UiUtils
                                    .screenContentHorizontalPaddingInPercentage,
                            bottom: UiUtils.getScrollViewBottomPadding(context),
                            top: UiUtils.getScrollViewTopPadding(
                              context: context,
                              appBarHeightPercentage:
                                  UiUtils.appBarBiggerHeightPercentage,
                            ),
                          ),
                          child: Center(
                            child: ErrorContainer(
                              errorMessageCode: state.errorMessage,
                              onTapRetry: () {
                                context.read<HolidaysCubit>().fetchHolidays();
                              },
                            ),
                          ),
                        );
                      }
                      return Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width *
                              UiUtils
                                  .screenContentHorizontalPaddingInPercentage,
                          right: MediaQuery.of(context).size.width *
                              UiUtils
                                  .screenContentHorizontalPaddingInPercentage,
                          bottom: UiUtils.getScrollViewBottomPadding(context),
                          top: UiUtils.getScrollViewTopPadding(
                            context: context,
                            appBarHeightPercentage:
                                UiUtils.appBarBiggerHeightPercentage,
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 25,
                            ),
                            ShimmerLoadingContainer(
                              child: CustomShimmerContainer(
                                height: MediaQuery.of(context).size.height *
                                    (0.425),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  BlocBuilder<EventsCubit, EventsState>(
                    builder: (context, state) {
                      if (state is EventsFetchSuccess) {
                        return EventsContainer(
                          events: events,
                          onPageChanged: (DateTime dateTime) {
                            setState(() {
                              eventsFocusedDay = dateTime;
                            });
                            updateMonthViceEvents();
                          },
                          firstDay: firstDay,
                          lastDay: lastDay,
                          focusedDay: eventsFocusedDay,
                          innerDates: innerDates,
                          startDates: startDates,
                          startWithNoEnd: startWithNoEnd,
                          endDates: endDates,
                        );
                      }

                      if (state is EventsFetchFailure) {
                        return Padding(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width *
                                UiUtils
                                    .screenContentHorizontalPaddingInPercentage,
                            right: MediaQuery.of(context).size.width *
                                UiUtils
                                    .screenContentHorizontalPaddingInPercentage,
                            bottom: UiUtils.getScrollViewBottomPadding(context),
                            top: UiUtils.getScrollViewTopPadding(
                              context: context,
                              appBarHeightPercentage:
                                  UiUtils.appBarBiggerHeightPercentage,
                            ),
                          ),
                          child: Center(
                            child: ErrorContainer(
                              errorMessageCode: state.errorMessage,
                              onTapRetry: () {
                                context.read<EventsCubit>().fetchEvents();
                              },
                            ),
                          ),
                        );
                      }
                      return Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width *
                              UiUtils
                                  .screenContentHorizontalPaddingInPercentage,
                          right: MediaQuery.of(context).size.width *
                              UiUtils
                                  .screenContentHorizontalPaddingInPercentage,
                          bottom: UiUtils.getScrollViewBottomPadding(context),
                          top: UiUtils.getScrollViewTopPadding(
                            context: context,
                            appBarHeightPercentage:
                                UiUtils.appBarBiggerHeightPercentage,
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 25,
                            ),
                            ShimmerLoadingContainer(
                              child: CustomShimmerContainer(
                                height: MediaQuery.of(context).size.height *
                                    (0.425),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Align(alignment: Alignment.topCenter, child: _buildAppBar()),
        ],
      ),
    );
  }
}
