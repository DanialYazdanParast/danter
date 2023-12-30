import 'dart:io';

import 'package:danter/data/model/post.dart';
import 'package:danter/data/repository/auth_repository.dart';
import 'package:danter/di/di.dart';
import 'package:danter/screen/image/image_screen.dart';
import 'package:danter/screen/replies/bloc/reply_bloc.dart';
import 'package:danter/screen/replies/write_reply/bloc/write_reply_bloc.dart';
import 'package:danter/screen/write/bloc/write_bloc.dart';
import 'package:danter/screen/write/write_screen.dart';
import 'package:danter/widgets/image.dart';
import 'package:danter/widgets/image_post.dart';
import 'package:danter/widgets/write.dart';
import 'package:danter/theme.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WriteReply extends StatelessWidget {
  final PostEntity postEntity;
  final String namePage;

  WriteReply({super.key, required this.postEntity, required this.namePage});
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WriteReplyBloc(locator.get()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('Reply'), elevation: 0.5),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned.fill(
              top: 0,
              right: 0,
              left: 0,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    PostWrite(postEntity: postEntity),
                    FildWrite(
                      controller: _controller,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                color: Colors.white,
                height: 35,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Anyone can reply',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .apply(fontSizeFactor: 0.9),
                    ),
                    BlocConsumer<WriteReplyBloc, WriteReplyState>(
                      listener: (context, state) {
                        if (state is WriteReplySuccesState) {
                          _controller.text = '';
                          selectedImage = [];
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              margin: const EdgeInsets.only(
                                  bottom: 55, left: 30, right: 30),

                              //  width: 280.0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              content: const Center(
                                  child: Padding(
                                padding: EdgeInsets.all(14),
                                child: Text('با موفقیت ثبت شد'),
                              )),
                            ),
                          );
                          if(namePage == 'reply'){
                            BlocProvider.of<ReplyBloc>(context).add(
                              ReplyRefreshEvent(
                                  postId: postEntity.id,
                                  ));
                          }
                          

                        } else if (state is WriteReplyErrorState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              margin: const EdgeInsets.only(
                                  bottom: 55, left: 30, right: 30),

                              //  width: 280.0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              content: Center(
                                  child: Padding(
                                padding: EdgeInsets.all(14),
                                child: Text(state.exception.message),
                              )),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: () {
                            if (_controller.text.isNotEmpty ||
                                selectedImage!.isNotEmpty) {
                              BlocProvider.of<WriteReplyBloc>(context).add(
                                  WriteReplySendPostEvent(
                                      user: AuthRepository.readid(),
                                      text: _controller.text,
                                      postid: postEntity.id,
                                      image: selectedImage!));
                            }
                          },
                          child: state is WriteReplyLodingState
                              ? const CupertinoActivityIndicator()
                              : const Text(
                                  'Post',
                                  style: TextStyle(
                                      fontFamily: 'Shabnam',
                                      fontSize: 18,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600),
                                ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PostWrite extends StatelessWidget {
  final PostEntity postEntity;
  const PostWrite({
    super.key,
    required this.postEntity,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Positioned(
              left: 33,
              top: 75,
              bottom: 0,
              child: Container(
                width: 1,
                color: LightThemeColors.secondaryTextColor,
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (postEntity.user.avatarchek.isNotEmpty)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: SizedBox(
                                height: 47,
                                width: 47,
                                child: ImageLodingService(
                                    imageUrl: postEntity.user.avatar)),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              height: 47,
                              width: 47,
                              color: LightThemeColors.secondaryTextColor
                                  .withOpacity(0.4),
                              child: const Icon(
                                CupertinoIcons.person_fill,
                                color: Colors.white,
                                size: 55,
                              ),
                            ),
                          ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              postEntity.user.username,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 7, right: 7),
                              child: Text(
                                postEntity.text,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
             ImagePost(postEntity: postEntity),
            ],
          ),
        ],
      ),
    );
  }
}
