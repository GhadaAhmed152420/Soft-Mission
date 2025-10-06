import 'package:cached_network_image/cached_network_image.dart';
import 'package:eschool/app/routes.dart';
import 'package:eschool/cubits/subjectVideosCubit.dart';
import 'package:eschool/data/models/studyMaterial.dart';
import 'package:eschool/ui/widgets/noDataContainer.dart';
import 'package:eschool/utils/animationConfiguration.dart';
import 'package:eschool/utils/labelKeys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../cubits/authCubit.dart';
import '../../../../utils/uiUtils.dart';
import '../../../widgets/customShimmerContainer.dart';
import '../../../widgets/errorContainer.dart';
import '../../../widgets/shimmerLoadingContainer.dart';

class LessonVideosContainer extends StatefulWidget {
  final int subjectId;
  final int? childId;

  const LessonVideosContainer({Key? key, required this.subjectId, this.childId})
      : super(key: key);

  @override
  State<LessonVideosContainer> createState() => _LessonVideosContainerState();
}

class _LessonVideosContainerState extends State<LessonVideosContainer> {
  late List<StudyMaterial> videos;

  Widget _buildVideoContainer({
    required StudyMaterial video,
    required BuildContext context,
  }) {
    return Animate(
      effects: customItemFadeAppearanceEffects(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            video.studyMaterialType == StudyMaterialType.other
                ? UiUtils.viewOrDownloadStudyMaterial(
                    context: context,
                    storeInExternalStorage: false,
                    studyMaterial: video,
                  )
                : Navigator.of(context).pushNamed(
                    Routes.playVideo,
                    arguments: {
                      "relatedVideos": videos,
                      "currentlyPlayingVideo": video
                    },
                  );
          },
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                  offset: const Offset(5, 5),
                  blurRadius: 10,
                )
              ],
            ),
            width: MediaQuery.of(context).size.width * (0.85),
            child: LayoutBuilder(
              builder: (context, boxConstraints) {
                return Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            video.fileThumbnail,
                          ),
                        ),
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 65,
                      width: boxConstraints.maxWidth * (0.3),
                    ),
                    SizedBox(
                      width: boxConstraints.maxWidth * (0.05),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            video.fileName,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                              fontSize: 13.0,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChapterDetailsShimmerContainer() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        width: MediaQuery.of(context).size.width * (0.85),
        child: LayoutBuilder(
          builder: (context, boxConstraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                    margin: EdgeInsetsDirectional.only(
                      end: boxConstraints.maxWidth * (0.7),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                    margin: EdgeInsetsDirectional.only(
                      end: boxConstraints.maxWidth * (0.5),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                    margin: EdgeInsetsDirectional.only(
                      end: boxConstraints.maxWidth * (0.7),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                    margin: EdgeInsetsDirectional.only(
                      end: boxConstraints.maxWidth * (0.5),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectVideosCubit, SubjectVideosState>(
      builder: (context, state) {
        if (state is SubjectVideosFetchSuccess) {
          videos = state.videos;
          return state.videos.isEmpty
              ? const NoDataContainer(titleKey: noVideosUploadedKey)
              : Column(
                  children: List.generate(
                    state.videos.length,
                    (index) => Animate(
                      effects: listItemAppearanceEffects(
                        itemIndex: index,
                        totalLoadedItems: state.videos.length,
                      ),
                      child: _buildVideoContainer(
                          video: state.videos[index], context: context),
                    ),
                  ),
                );
        }
        if (state is SubjectVideosFetchFailure) {
          return ErrorContainer(
            errorMessageCode: state.errorMessage,
            onTapRetry: () {
              context.read<SubjectVideosCubit>().fetchSubjectVideos(
                    subjectId: widget.subjectId,
                    useParentApi: context.read<AuthCubit>().isParent(),
                    childId: widget.childId,
                  );
            },
          );
        }
        return Column(
          children: List.generate(5, (index) => index)
              .map(
                (e) => _buildChapterDetailsShimmerContainer(),
              )
              .toList(),
        );
      },
    );
  }
/*Widget build(BuildContext context) {
    return Column(
      children: studyMaterials.isEmpty
          ? [const NoDataContainer(titleKey: noVideosUploadedKey)]
          : studyMaterials
          .map(
            (studyMaterial) => _buildVideoContainer(
          studyMaterial: studyMaterial,
          context: context,
        ),
      )
          .toList(),
    );
  }*/
}
