import 'package:eschool/cubits/authCubit.dart';
import 'package:eschool/data/models/subject.dart';
import 'package:eschool/ui/screens/teachers_evaluation/cubits/teachers_evaluation_cubit.dart';
import 'package:eschool/ui/styles/colors.dart';
import 'package:eschool/ui/widgets/customBackButton.dart';
import 'package:eschool/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:intl/intl.dart';

import '../../widgets/customRoundedButton.dart';
import 'models/teachers_model/datum.dart';

class TeachersEvaluationContainer extends StatefulWidget {
  final int? childId;
  final Datum teacher;

  const TeachersEvaluationContainer({
    Key? key,
    this.childId,
    required this.teacher,
  }) : super(key: key);

  @override
  TeachersEvaluationContainerState createState() =>
      TeachersEvaluationContainerState();

  static Route route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
      builder: (_) => TeachersEvaluationContainer(
        teacher: arguments["teacher"],
        childId: arguments['childId'],
      ),
    );
  }
}

class TeachersEvaluationContainerState
    extends State<TeachersEvaluationContainer> {
  List<Subject>? subjects;
  late TeachersEvaluationCubit teachersEvaluationCubit;

  @override
  void initState() {
    super.initState();
    teachersEvaluationCubit = BlocProvider.of<TeachersEvaluationCubit>(context);
    teachersEvaluationCubit.fetchTeachers(childId: widget.childId);
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
              widget.teacher.name!,
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

  List<String> labels = [
    explanationKey,
    followingOnAssignmentsKey,
    commitmentClassTimeKey,
    takingIndividualDifferencesKey,
    methodDealingInteractingStudentsKey
  ];
  List<int> ratings = [];

  Widget _buildBody() {
    labels.forEach(
      (element) => ratings.add(5),
    );
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.only(
              top: UiUtils.getScrollViewTopPadding(
                context: context,
                appBarHeightPercentage: UiUtils.appBarSmallerHeightPercentage,
              ),
              left: 35,
              right: 35,
            ),
            separatorBuilder: (context, index) => SizedBox(height: 15),
            itemCount: labels.length,
            itemBuilder: (context, index) => Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                //color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${UiUtils.getTranslatedLabel(context, labels[index])} : ",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: UiUtils.screenTitleFontSize,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  EmojiFeedback(
                    initialRating: ratings[index],
                    customLabels: [
                      UiUtils.getTranslatedLabel(context, veryBadKey),
                      UiUtils.getTranslatedLabel(context, badKey),
                      UiUtils.getTranslatedLabel(context, goodKey),
                      UiUtils.getTranslatedLabel(context, veryGoodKey),
                      UiUtils.getTranslatedLabel(context, excellentKey),
                    ],
                    emojiPreset: classicEmojiPreset,
                    inactiveElementScale: 1,
                    elementSize: 35,
                    labelTextStyle: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontWeight: FontWeight.w400),
                    onChanged: (value) {
                      setState(() => ratings[index] = value!);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        BlocConsumer<TeachersEvaluationCubit, TeachersEvaluationState>(
          buildWhen: (previous, current) =>
              current is StoreTeachersEvaluationFailure ||
              current is StoreTeachersEvaluationLoading ||
              current is StoreTeachersEvaluationSuccess,
          listener: (context, state) {
            if (state is StoreTeachersEvaluationSuccess) {
              UiUtils.showCustomSnackBar(
                context: context,
                errorMessage: state.teacherEvaluationModel.message!,
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
              );
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            return state is StoreTeachersEvaluationLoading
                ? CircularProgressIndicator(
                    backgroundColor: primaryColor,
                  )
                : CustomRoundedButton(
                    onTap: () async => state is StoreTeachersEvaluationLoading
                        ? null
                        : await teachersEvaluationCubit.storeEvaluation(
                            childId: widget.childId!,
                            date: DateFormat('yyyy-MM-dd')
                                .format(DateTime.now())
                                .toString(),
                            teacherId: widget.teacher.teacherId!,
                            subjectId: widget.teacher.subjectId!,
                            classSectionId: widget.teacher.classSectionId!,
                            explanation: ratings[0],
                            homeworkFollowUp: ratings[1],
                            punctuality: ratings[2],
                            individualDifferences: ratings[3],
                            interAction: ratings[4],
                          ),
                    widthPercentage: 0.6,
                    radius: 25,
                    height: 40,
                    backgroundColor: UiUtils.getColorScheme(context).primary,
                    buttonTitle: UiUtils.getTranslatedLabel(context, sendKey),
                    showBorder: false,
                  );
          },
        ),
        SizedBox(
          height: 50,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return //(context.read<AuthCubit>().isParent())
        Scaffold(
      body: Stack(
        children: [
          _buildBody(),
          Align(
            alignment: Alignment.topCenter,
            child: _buildAppBar(),
          ),
        ],
      ),
    );
  }
}
