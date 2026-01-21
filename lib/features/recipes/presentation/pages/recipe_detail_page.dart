import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe/core/utils/localization_extension.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/enums/view_mode.dart';
import '../../domain/entities/recipe.dart';
import '../bloc/recipe_detail/recipe_detail_bloc.dart';
import '../widgets/favorite_button.dart';
import '../widgets/image_viewer_dialog.dart';
import '../widgets/ingredient_list_tile.dart';
import '../widgets/instruction_list_tile.dart';
import '../widgets/shimmer_loading.dart';

class RecipeDetailPage extends StatefulWidget {
  final String recipeId;

  const RecipeDetailPage({super.key, required this.recipeId});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<RecipeDetailBloc>().add(LoadRecipeDetails(widget.recipeId));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      body: BlocBuilder<RecipeDetailBloc, RecipeDetailState>(
        builder: (context, state) {
          // if (state.isLoading) {
          //   return const ShimmerLoading(viewMode: ViewMode.list);
          // }

          if (state.error != null) {
            return Center(child: Text(state.error!));
          }

          final recipe = state.recipe;
          if (recipe == null) return Center(child: Text(l10n.recipeNotFound));

          return Skeletonizer(
            enabled: state.isLoading,
            child: DefaultTabController(
              length: 3,
              child: Scaffold(
                backgroundColor: AppColors.lightGray,
                body: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        expandedHeight: 320,
                        pinned: true,
                        backgroundColor: AppColors.primaryGreen,
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => context.pop(),
                        ),
                        actions: [
                          FavoriteButton(
                            recipeId: recipe.id,
                            size: 24,
                            // color: Colors.white,
                          ),
                        ],
                        flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          title: Text(
                            recipe.name,
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          background: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    ImageViewerDialog(imageUrl: recipe.imageUrl ?? '', title: recipe.name),
                              );
                            },
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Hero(
                                  tag: 'recipe-image-${recipe.id}',
                                  child: CachedNetworkImage(imageUrl: recipe.imageUrl ?? '', fit: BoxFit.cover),
                                ),
                                const DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Colors.black54, Colors.transparent, Colors.black54],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Sticky Tabs
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _TabBarDelegate(
                          TabBar(
                            labelColor: AppColors.primaryGreen,
                            unselectedLabelColor: AppColors.gray500,
                            indicator: const UnderlineTabIndicator(
                              borderSide: BorderSide(color: AppColors.primaryGreen, width: 3),
                            ),
                            tabs: [
                              Tab(text: l10n.overview),
                              Tab(text: l10n.ingredients),
                              Tab(text: l10n.instructions),
                            ],
                          ),
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    children: [
                      OverviewTab(recipe: recipe),
                      IngredientsList(recipe: recipe),
                      InstructionsList(recipe: recipe),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: AppColors.lightGray, child: tabBar);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class OverviewTab extends StatelessWidget {
  final Recipe recipe;

  const OverviewTab({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (recipe.category != null) Chip(label: Text(recipe.category!)),
              const SizedBox(width: 8),
              if (recipe.area != null) Chip(label: Text(recipe.area!)),
            ],
          ),

          const SizedBox(height: 24),

          if (recipe.hasVideo) ...[
            YoutubePlayer(
              controller: YoutubePlayerController(
                initialVideoId: YoutubePlayer.convertUrlToId(recipe.youtubeUrl!)!,
                flags: const YoutubePlayerFlags(autoPlay: false),
              ),
              showVideoProgressIndicator: true,
            ),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }
}

class IngredientsList extends StatelessWidget {
  final Recipe recipe;

  const IngredientsList({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final items = recipe.ingredients.asMap().entries;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: items.map((entry) {
        return IngredientListTile(ingredient: entry.value, measure: recipe.measures[entry.key]);
      }).toList(),
    );
  }
}

class InstructionsList extends StatelessWidget {
  final Recipe recipe;

  const InstructionsList({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final steps = recipe.instructions!.split('\n').where((e) => e.trim().isNotEmpty).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        return InstructionListTile(instruction: steps[index], step: index + 1);
      },
    );
  }
}
