import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/common_widgets/bottom_sheet/add_bottom_sheet.dart';
import 'package:todo/constant/colors.dart';
import 'package:todo/constant/font_style.dart';
import 'package:todo/home/controller/home_controller.dart';
import 'package:todo/login/data/model/todo_model.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    log('home view');
    HomeController homeController = Provider.of<HomeController>(context);
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => AddBottomSheet(
              onChangedDate: (DateTime newDate) {
                homeController.taskDate = newDate.toString();
              },
              onChangedDescription: (txt) => homeController.taskDescription = txt,
              onChangedName: (txt) => homeController.taskName = txt,
              onTap: () async {
                Navigator.of(context).pop();
                await homeController.addTodo();
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: AppColors.primaryColor,
            padding: EdgeInsets.only(left: 16, right: 16, top: MediaQuery.of(context).viewPadding.top + 10, bottom: 10),
            child: Consumer<HomeController>(builder: (context, result, child) {
              return Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(result.userDataValue?.fullName ?? 'N/A',
                          style: AppTextStyle.textStyle16W600.copyWith(color: AppColors.whiteColor, fontSize: 18)),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: ()async{
                          await homeController.logout(context);
                        },
                        child: Row(
                          children: [
                            Text('Sign Out',
                                style: AppTextStyle.textStyle16W600
                                    .copyWith(color: AppColors.whiteColor, fontSize: 18, decoration: TextDecoration.underline)),
                            const SizedBox(width: 5),
                            const Icon(Icons.logout, color: AppColors.whiteColor, size: 20)
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: AppColors.whiteColor,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(result.userDataValue?.profilePic ??
                          'https://static.vecteezy.com/system/resources/previews/006/208/073/original/cute-dog-face-cartoon-icon-illustration-animal-nature-icon-concept-isolated-premium-flat-cartoon-style-vector.jpg'),
                    ),
                  ),
                ],
              );
            }),
          ),
          Flexible(
            child: Consumer<HomeController>(builder: (context, todosValue, child) {
              return Stack(
                children: [
                  ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: homeController.todos?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Slidable(
                          key: Key(homeController.todos?[index].todoId ?? 'N/A'),
                          endActionPane: ActionPane(
                            motion: const BehindMotion(),
                            dismissible: DismissiblePane(onDismissed: () async {
                              await homeController.deleteTodo(homeController.todos?[index].todoId ?? 'N/A');
                            }),
                            children: [
                              SlidableAction(
                                onPressed: (BuildContext? context) async {
                                  TodoModel? todoModel = homeController.todos?[index];
                                  todoModel?.isMark = true;
                                  await homeController.updateTodo(todoModel);
                                },
                                backgroundColor: const Color(0xff64BC44),
                                foregroundColor: Colors.white,
                                icon: Icons.check,
                                label: 'Completed',
                              ),
                              SlidableAction(
                                onPressed: (BuildContext? cxt) {
                                  if (cxt != null) {
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: cxt,
                                        builder: (context) {
                                          TodoModel? todoData = homeController.todos?[index];
                                          return AddBottomSheet(
                                            taskName: todoData?.taskName,
                                            taskDescription: todoData?.description,
                                            initialDate: todoData?.date,
                                            onChangedDate: (DateTime newDate) {
                                              todoData?.date = newDate.toString();
                                            },
                                            onChangedDescription: (txt) => todoData?.description = txt,
                                            onChangedName: (txt) => todoData?.taskName = txt,
                                            onTap: () async {
                                              Navigator.of(context).pop();
                                              await homeController.updateTodoLoader(todoData);
                                            },
                                          );
                                        });
                                  }
                                },
                                backgroundColor: const Color(0xFF21B7CA),
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                                label: 'Edit',
                              ),
                              SlidableAction(
                                onPressed: (BuildContext? context) async {
                                  await homeController.deleteTodo(homeController.todos?[index].todoId ?? 'N/A');
                                },
                                backgroundColor: const Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: Card(
                            child: ListTile(
                              horizontalTitleGap: 0,
                              minLeadingWidth: 0,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              leading: Checkbox(
                                  value: homeController.todos?[index].isMark,
                                  onChanged: (checkValue) async {
                                    TodoModel? todoModel = homeController.todos?[index];
                                    todoModel?.isMark = checkValue;
                                    await homeController.updateTodoLoader(todoModel);
                                  }),
                              title: Row(
                                children: [
                                  Text(homeController.todos?[index].taskName ?? ''),
                                  const Spacer(),
                                  Text(
                                    DateFormat('MMMM, yyyy-dd, hh:mm a').format(
                                      DateTime.parse(homeController.todos?[index].date ?? ''),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(homeController.todos?[index].description ?? ''),
                            ),
                          ),
                        );
                      }),
                  if (todosValue.addTodoLoader)
                    Container(
                      color: Colors.black12,
                      child: const Center(child: CircularProgressIndicator()),
                    )
                ],
              );
            }),
          )
        ],
      ),
    );
  }
}
