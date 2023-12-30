import 'package:danter/data/repository/auth_repository.dart';
import 'package:danter/di/di.dart';
import 'package:danter/screen/home/bloc/home_bloc.dart';
import 'package:danter/theme.dart';
import 'package:danter/widgets/error.dart';
import 'package:danter/widgets/post_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => HomeBloc(locator.get())
          ..add(HomeStartedEvent(user: AuthRepository.readid())),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeSuccesState) {
              return
              RefreshIndicator(

                onRefresh: () async {
                
                  BlocProvider.of<HomeBloc>(context)
                      .add(HomeRefreshEvent(user: AuthRepository.readid()));

                  await  Future.delayed(const Duration(seconds: 2));    
                },
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: false,
                      title: SizedBox(
                        height: 40,
                        width: 40,
                        child: GestureDetector(
                          onTap: () {},
                          child: Image.asset(
                            'assets/images/d.png',
                          ),
                        ),
                      ),
                      centerTitle: true,
                    ),
                    SliverList.builder(
                      itemCount: state.post.length,
                      itemBuilder: (context, index) {
                        return PostDetail(
                          onTabLike: () async {
                            if (!state.post[index].likes
                                .contains(AuthRepository.readid())) {
                              BlocProvider.of<HomeBloc>(context).add(
                                AddLikePostEvent(
                                  postId: state.post[index].id,
                                  user: AuthRepository.readid(),
                                ),
                              );
                            } else {
                              BlocProvider.of<HomeBloc>(context).add(
                                RemoveLikePostEvent(
                                  postId: state.post[index].id,
                                  user: AuthRepository.readid(),
                                ),
                              );
                            }
                          },
                          onTabmore: () {},
                          postEntity: state.post[index],
                        );
                      },
                    ),
                  ],
                ),
              );
            } else if (state is HomeLodingState) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: false,
                    title: SizedBox(
                      height: 40,
                      width: 40,
                      child: GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          'assets/images/d.png',
                        ),
                      ),
                    ),
                    centerTitle: true,
                  ),
                  SliverToBoxAdapter(
                    child: Center(
                      child: Container(
                          height: 40,
                          width: 40,
                          child: const CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: LightThemeColors.secondaryTextColor,
                          )),
                    ),
                  )
                ],
              );
            } else if (state is HomeErrorState) {
              return AppErrorWidget(
                exception: state.exception,
                onpressed: () {
                  BlocProvider.of<HomeBloc>(context)
                      .add(HomeRefreshEvent(user: AuthRepository.readid()));
                },
              );
            } else {
              throw Exception('state is not supported ');
            }
          },
        ),
      ),
    );
  }
}
