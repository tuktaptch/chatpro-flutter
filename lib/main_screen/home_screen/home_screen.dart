import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/constraints/c_typography.dart';
import 'package:chat_pro/main_screen/chats_list_screen.dart';
import 'package:chat_pro/main_screen/groups_screen.dart';
import 'package:chat_pro/main_screen/home_screen/home_screen_provider.dart';
import 'package:chat_pro/main_screen/people_screen.dart';
import 'package:chat_pro/main_screen/profile_screen/profile_screen.dart';
import 'package:chat_pro/provider/authentication_provider.dart';
import 'package:chat_pro/widgets/avartar/user_image_avertar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static String routeName = '/main/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _HomeBody(),
      bottomNavigationBar: _GradientBottomNavBar(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    final provider = context.read<HomeScreenProvider>();
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.axis == Axis.vertical) {
          provider.onScroll(notification.metrics.pixels);
        }
        return false;
      },
      child: Selector<HomeScreenProvider, double>(
        selector: (_, p) => p.scrollOffset,
        builder: (context, scrollOffset, _) {
          final searchOpacity = (1 - (scrollOffset / 80)).clamp(0.0, 1.0);

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              _HomeAppBar(
                innerBoxIsScrolled: innerBoxIsScrolled,
                scrollOffset: scrollOffset,
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SearchHeaderDelegate(
                  opacity: searchOpacity,
                  gradient: LinearGradient(
                    colors: [
                      CColors.hotPink.withAlpha(120),
                      CColors.pinkOrange.withAlpha(80),
                      CColors.salmonPink.withAlpha(60),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ],
            body: PageView(
              controller: provider.pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: provider.onPageChanged,
              children: const [
                ChatsListScreen(),
                GroupsScreen(),
                PeopleScreen(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HomeAppBar extends StatelessWidget {
  final double scrollOffset;
  final bool innerBoxIsScrolled;

  const _HomeAppBar({
    required this.scrollOffset,
    required this.innerBoxIsScrolled,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthenticationProvider>();

    return SliverAppBar(
      pinned: true,
      backgroundColor: scrollOffset > 0 ? Colors.white : Colors.transparent,
      elevation: innerBoxIsScrolled ? 4 : 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 8, right: 16),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Chat Pro",
              style: CTypography.heading3.copyWith(
                color: CColors.hotPink,
                fontSize: 24,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(
                context,
                ProfileScreen.routeName,
                arguments: ProfileScreenArguments(
                  uid: authProvider.userModel?.uid ?? '',
                ),
              ),
              child: CAvatar(imageUrl: authProvider.userModel?.image ?? ''),
            ),
          ],
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                CColors.hotPink.withAlpha(120),
                CColors.pinkOrange.withAlpha(80),
                CColors.salmonPink.withAlpha(60),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double opacity;
  final LinearGradient gradient;

  _SearchHeaderDelegate({required this.opacity, required this.gradient});

  @override
  double get minExtent => 56;
  @override
  double get maxExtent => 56;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Opacity(
      opacity: opacity,
      child: Container(
        decoration: BoxDecoration(gradient: gradient),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TextField(
          decoration: InputDecoration(
            hintText: "Search...",
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white.withAlpha(180),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SearchHeaderDelegate oldDelegate) {
    return oldDelegate.opacity != opacity || oldDelegate.gradient != gradient;
  }
}

class _GradientBottomNavBar extends StatelessWidget {
  const _GradientBottomNavBar();

  @override
  Widget build(BuildContext context) {
    final LinearGradient gradient = LinearGradient(
      colors: [
        CColors.hotPink.withAlpha(120),
        CColors.pinkOrange.withAlpha(80),
        CColors.salmonPink.withAlpha(60),
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    Widget buildNavItem(
      RiveIcon icon,
      int index,
      int currentIndex,
      HomeScreenProvider provider,
    ) {
      final bool selected = currentIndex == index;
      return Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => provider.onTapNavBar(index),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 2),
                height: 4,
                width: selected ? 20 : 0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Center(
                child: RiveAnimatedIcon(
                  onTap: () => provider.onTapNavBar(index),
                  riveIcon: icon,
                  width: 36,
                  height: 36,
                  color: selected ? Colors.white : Colors.white70,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Consumer<HomeScreenProvider>(
      builder: (context, provider, __) {
        final currentIndex = provider.currentIndex;
        return SafeArea(
          top: false,
          child: ClipRRect(
            clipBehavior: Clip.none,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: CColors.hotPink.withAlpha(120),
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  buildNavItem(RiveIcon.message, 0, currentIndex, provider),
                  buildNavItem(RiveIcon.profile, 1, currentIndex, provider),
                  buildNavItem(RiveIcon.globe, 2, currentIndex, provider),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
