import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadaa/features/directory_page/presentation/blocs/users_bloc.dart';
import 'package:tadaa/features/directory_page/presentation/blocs/users_state.dart';
import 'package:tadaa/features/directory_page/presentation/pages/directoryDetailsPage.dart';
import 'package:tadaa/features/profile_page/data/models/userModel.dart';

class UserCardWidget extends StatelessWidget {
  final List<UserModel> users;

  const UserCardWidget({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UsersLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is UserError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is UsersLoaded) {
          final filteredUsers = users; // Use the filtered users passed to the widget

          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.0,
              mainAxisSpacing: 5.0,
              mainAxisExtent: 260,
            ),
            itemCount: filteredUsers.length,
            itemBuilder: (_, index) {
              return GestureDetector(
                onTap: () {
                   Navigator.of(context).push(
                    PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 500),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        DirectoryDetailsPage(
                          user: filteredUsers[index],
                          ),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      var scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOut,
                        ),
                      );
                      var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOut,
                        ),
                      );

                      return ScaleTransition(
                        scale: scaleAnimation,
                        child: FadeTransition(
                          opacity: fadeAnimation,
                          child: child,
                        ),
                      );
                    },
                   ),

                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0),
                          ),
                          child: filteredUsers[index].profilePicture != null
                              ? Image.network(
                                  filteredUsers[index].profilePicture!,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/profile.jpg',
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.fill,
                                    );
                                  },
                                )
                              : Image.asset(
                                  'assets/images/profile.jpg',
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.fill,
                                ),
                        ),
                        const SizedBox(height: 2),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  filteredUsers[index].name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .merge(const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      )),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Center(
                                child: Text(
                                  filteredUsers[index].email,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                              ),
                              if (filteredUsers[index].position != null &&
                                  filteredUsers[index].position!.isNotEmpty) ...[
                                const SizedBox(height: 5),
                                Center(
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 151, 217, 243),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      filteredUsers[index].position!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .merge(const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                            color: Colors.white,
                                          )),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
        return Center(child: Text('No user available.'));
      },
    );
  }
}
