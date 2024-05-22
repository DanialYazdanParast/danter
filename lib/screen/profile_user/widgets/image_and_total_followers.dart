import 'package:danter/core/widgets/photo_user_followers.dart';
import 'package:danter/data/model/user.dart';
import 'package:danter/screen/followers/screens/followers_screen.dart';
import 'package:danter/screen/root/screens/root.dart';
import 'package:flutter/material.dart';

class ImageAndTotalFollowers extends StatelessWidget {
  const ImageAndTotalFollowers({
    super.key,
    required this.userFollowers,
    required this.user,
  });

  final List<User> userFollowers;
  final User user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context,
                rootNavigator: RootScreen.isMobile(context) ? true : false)
            .push(MaterialPageRoute(
          builder: (context) => FollowersScreen(
            namePage: 'ProfileUser',
            userid: user.id,
            username: user.username,
          ),
        ));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          userFollowers.length > 1
              ? Stack(
                  clipBehavior: Clip.none,
                  children: [
                    (userFollowers[0].avatarchek.isNotEmpty)
                        ? ImageReplyUser(
                            photo: userFollowers[0].avatar,
                          )
                        : const PhotoReplyUserNoPhoto(),
                    Positioned(
                      left: 13,
                      bottom: 0,
                      child: (userFollowers[1].avatarchek.isNotEmpty)
                          ? ImageReplyUser(
                              photo: userFollowers[1].avatar,
                            )
                          : const PhotoReplyUserNoPhoto(),
                    )
                  ],
                )
              : userFollowers.length == 1
                  ? Container(
                      margin: const EdgeInsets.only(left: 0),
                      child: (userFollowers[0].avatarchek.isNotEmpty)
                          ? ImageReplyUser(
                              photo: userFollowers[0].avatar,
                            )
                          : const PhotoReplyUserNoPhoto(),
                    )
                  : Container(
                      margin: const EdgeInsets.only(left: 0),
                    ),
          SizedBox(
            width: userFollowers.isEmpty
                ? 0
                : userFollowers.length == 1
                    ? 10
                    : 20,
          ),
          Text(
            user.followers.length.toString(),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(
            width: 6,
          ),
          Text(
            userFollowers.length < 2 ? 'follower' : 'followers',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}
