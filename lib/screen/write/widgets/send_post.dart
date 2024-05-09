import 'package:danter/core/constants/variable_onstants.dart';
import 'package:danter/core/widgets/write.dart';
import 'package:danter/data/repository/auth_repository.dart';
import 'package:danter/screen/write/bloc/write_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendPost extends StatelessWidget {
  const SendPost({
    super.key,
    required this.themeData,
    required this.controller,
    required this.state,
  });

  final ThemeData themeData;
  final TextEditingController controller;
  final WriteState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      color: themeData.scaffoldBackgroundColor,
      height: 45,
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Anyone can reply',
                style: Theme.of(context).textTheme.labelSmall),
            GestureDetector(
              onTap: () {
                if (controller.text.isNotEmpty ||
                    VariableConstants.selectedImage!.isNotEmpty) {
                  BlocProvider.of<WriteBloc>(context).add(WriteSendPostEvent(
                      user: AuthRepository.readid(),
                      text: controller.text,
                      image: VariableConstants.selectedImage!));
                }
              },
              child: Container(
                height: 30,
                width: 55,
                decoration: BoxDecoration(
                    color: themeData.colorScheme.primary,
                    borderRadius: BorderRadius.circular(20)),
                child: state is WriteLodingState
                    ? Center(
                        child: SizedBox(
                          height: 23,
                          width: 23,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: themeData.colorScheme.secondary,
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          'Post',
                          style: themeData.textTheme.titleMedium!.copyWith(
                              fontSize: 14,
                              color: themeData.scaffoldBackgroundColor),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
