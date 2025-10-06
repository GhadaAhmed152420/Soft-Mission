import 'package:eschool/cubits/authCubit.dart';
import 'package:eschool/data/models/subject.dart';
import 'package:eschool/ui/screens/teachers_evaluation/cubits/teachers_evaluation_cubit.dart';
import 'package:eschool/ui/widgets/customBackButton.dart';
import 'package:eschool/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/routes.dart';
import '../../../utils/animationConfiguration.dart';
import '../../widgets/customShimmerContainer.dart';
import '../../widgets/errorContainer.dart';
import '../../widgets/noDataContainer.dart';
import '../../widgets/shimmerLoadingContainer.dart';

class TeachersContainer extends StatefulWidget {
  final int? childId;
  final List<Subject>? subjects;

  const TeachersContainer({Key? key, this.childId, this.subjects})
      : super(key: key);

  @override
  TeachersContainerState createState() => TeachersContainerState();

  static Route route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
      builder: (_) => TeachersContainer(
        childId: arguments['childId'],
        subjects: arguments['subjects'],
      ),
    );
  }
}

class TeachersContainerState extends State<TeachersContainer> {
  List<Subject>? subjects;
  late TeachersEvaluationCubit teachersEvaluationCubit;

  @override
  void initState() {
    super.initState();
    teachersEvaluationCubit = BlocProvider.of<TeachersEvaluationCubit>(context);
    teachersEvaluationCubit.fetchTeachers(childId: widget.childId);
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
              UiUtils.getTranslatedLabel(context, evaluationTeacherKey),
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

  Widget _buildShimmerLoader() {
    return ShimmerLoadingContainer(
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          return SizedBox(
            height: double.maxFinite,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: UiUtils.defaultShimmerLoadingContentCount,
              itemBuilder: (context, index) {
                return _buildOneChatUserShimmerLoader();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildOneChatUserShimmerLoader() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: MediaQuery.of(context).size.width * (0.075),
      ),
      child: const ShimmerLoadingContainer(
        child: CustomShimmerContainer(
          height: 80,
          borderRadius: 12,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<TeachersEvaluationCubit, TeachersEvaluationState>(
      buildWhen: (previous, current) =>
          current is GetTeachersSuccess ||
          current is GetTeachersFailure ||
          current is GetTeachersLoading,
      builder: (context, state) {
        if (state is GetTeachersSuccess) {
          return state.teachersModel.data!.isEmpty
              ? const NoDataContainer(
                  titleKey: noUsersKey,
                )
              : Padding(
                  padding: EdgeInsetsDirectional.only(
                    top: UiUtils.getScrollViewTopPadding(
                      context: context,
                      keepExtraSpace: false,
                      appBarHeightPercentage:
                          UiUtils.appBarSmallerHeightPercentage,
                    ),
                  ),
                  child: SizedBox(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          ...List.generate(
                            state.teachersModel.data!.length,
                            (index) {
                              final currentUser =
                                  state.teachersModel.data![index];
                              return Animate(
                                effects: customItemFadeAppearanceEffects(),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: MediaQuery.of(context)
                                            .size
                                            .width *
                                        UiUtils
                                            .screenContentHorizontalPaddingInPercentage,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          Routes.teachersEvaluation,
                                          arguments: {
                                            "childId": widget.childId,
                                            "teacher": currentUser,
                                          });
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      height: 80,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            offset: const Offset(2.5, 2.5),
                                            blurRadius: 10,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary
                                                .withOpacity(0.15),
                                          )
                                        ],
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    currentUser.name!,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 2,
                                                ),
                                                Container(
                                                  constraints:
                                                      const BoxConstraints(
                                                          minHeight: 25),
                                                  //min height to not look bad when there is no notification count
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          "${UiUtils.getTranslatedLabel(context, subjectTeacherKey)} : ${currentUser.subjectName}",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        }
        if (state is GetTeachersFailure) {
          return Center(
            child: ErrorContainer(
              errorMessageCode: state.error,
              onTapRetry: () {
                teachersEvaluationCubit.fetchTeachers(childId: widget.childId);
              },
            ),
          );
        }
        return Padding(
          padding: EdgeInsetsDirectional.only(
            top: UiUtils.getScrollViewTopPadding(
              context: context,
              appBarHeightPercentage: UiUtils.appBarSmallerHeightPercentage,
            ),
          ),
          child: _buildShimmerLoader(),
        );
      },
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
