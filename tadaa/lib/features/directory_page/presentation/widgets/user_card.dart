import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadaa/features/directory_page/presentation/blocs/users_bloc.dart';
import 'package:tadaa/features/directory_page/presentation/blocs/users_event.dart';
import 'package:tadaa/features/directory_page/presentation/blocs/users_state.dart';

class UserCardWidget extends StatefulWidget {
  const UserCardWidget({super.key});

  @override
  State<UserCardWidget> createState() => _UserCardWidgetState();
}


class _UserCardWidgetState extends State<UserCardWidget> {
  @override
void initState() {
  super.initState();
BlocProvider.of<UserBloc>(context).add(FetchAllUsers());
}

  @override
  Widget build(BuildContext context) {
     return BlocBuilder<UserBloc, UserState>(
      builder:(context, state) {
        if (state is UsersLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is UserError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is UsersLoaded) {
        return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 3.0,
                mainAxisSpacing: 5.0,
                mainAxisExtent: 250,
              ),
              itemCount: state.users.length,
              itemBuilder: (_, index) {
                return GestureDetector(
                  onTap: () {                    
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
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        
                        children: [
                          const SizedBox(height: 20,),
                          ClipRRect(           
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              topRight: Radius.circular(16.0),
                            ),
                            child: state.users[index].profilePicture != null
                              ? Image.network(
                                  state.users[index].profilePicture!,
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
                                   state.users[index].name,
                                    style: Theme.of(context).textTheme.subtitle1!.merge(
                                          const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                          ),
                                        ),
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Center(
                                  child: Text(                                
                                   state.users[index].email,
                                    style: 
                                          const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                            color: Colors.grey
                                          ),
                                        
                                  ),
                                ),

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
  });
  }
}