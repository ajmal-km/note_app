import 'package:flutter/material.dart';
import 'package:note_app/utils/color_constants.dart';
import 'package:note_app/view/note_database/note_database.dart';
import 'package:note_app/view/note_screen/note_screen.dart';
import 'package:note_app/view/note_screen/widgets/note_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.mainBlack,
      appBar: AppBar(
        backgroundColor: ColorConstants.mainRed,
        surfaceTintColor: ColorConstants.mainRed,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.home,
            color: ColorConstants.fontColor,
          ),
        ),
        titleSpacing: 0,
        title: Text(
          "Home",
          style: TextStyle(
            color: ColorConstants.fontColor,
            fontSize: 25,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.7,
          ),
        ),
      ),
      body: NoteDatabase.noteList.isEmpty
          ? Center(
              child: Text(
                "Add Note",
                style: TextStyle(
                  color: ColorConstants.mainRed,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -1,
                ),
              ),
            )
          : Column(
              children: <Widget>[
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 15),
                    padding: EdgeInsets.all(14),
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoteScreen(
                              noteTitle: NoteDatabase.noteList[index]["title"],
                              description: NoteDatabase.noteList[index]
                                  ["description"],
                              date: NoteDatabase.noteList[index]["date"],
                              onDelete: () {
                                setState(() {
                                  NoteDatabase.noteList.removeAt(index);
                                  Navigator.pop(context);
                                });
                              },
                            ),
                          ),
                        );
                      },
                      child: NoteCard(
                        title: NoteDatabase.noteList[index]["title"],
                        description: NoteDatabase.noteList[index]
                            ["description"],
                        date: NoteDatabase.noteList[index]["date"],
                        onEdit: () {
                          setState(() {
                            titleController.text =
                                NoteDatabase.noteList[index]["title"];
                            descriptionController.text =
                                NoteDatabase.noteList[index]["description"];
                            dateController.text =
                                NoteDatabase.noteList[index]["date"];
                            customBottomSheet(context,
                                isEdit: true, index: index);
                          });
                        },
                        onDelete: () {
                          setState(() {
                            NoteDatabase.noteList.removeAt(index);
                          });
                        },
                      ),
                    ),
                    itemCount: NoteDatabase.noteList.length,
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorConstants.mainRed,
        child: Icon(Icons.add, size: 40, color: ColorConstants.fontColor),
        onPressed: () {
          titleController.clear();
          descriptionController.clear();
          dateController.clear();
          customBottomSheet(context);
        },
      ),
    );
  }

  Future<dynamic> customBottomSheet(BuildContext context,
      {bool isEdit = false, int? index}) {
    return showModalBottomSheet(
      backgroundColor: ColorConstants.mainBlack,
      isScrollControlled: true,
      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.all(15),
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    isEdit ? "Edit Note" : "Add Note",
                    style: TextStyle(
                      color: ColorConstants.fontColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.7,
                    ),
                  ),
                ),
                TextField(
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  style: TextStyle(
                    color: ColorConstants.fontColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  controller: titleController,
                  decoration: InputDecoration(
                    fillColor: ColorConstants.mainRed,
                    filled: true,
                    hintText: "Title",
                    hintStyle: TextStyle(
                      color: ColorConstants.fontColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                      borderRadius: BorderRadius.circular(23),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  style: TextStyle(
                    color: ColorConstants.fontColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 7,
                  controller: descriptionController,
                  decoration: InputDecoration(
                    fillColor: ColorConstants.mainRed,
                    filled: true,
                    hintText: "Description",
                    hintStyle: TextStyle(
                      color: ColorConstants.fontColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                      borderRadius: BorderRadius.circular(23),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  style: TextStyle(
                    color: ColorConstants.fontColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  controller: dateController,
                  decoration: InputDecoration(
                    fillColor: ColorConstants.mainRed,
                    filled: true,
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.calendar_month_rounded,
                        color: ColorConstants.fontColor,
                      ),
                    ),
                    hintText: "Date",
                    hintStyle: TextStyle(
                      color: ColorConstants.fontColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                      borderRadius: BorderRadius.circular(23),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 170,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: ColorConstants.mainRed,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: ColorConstants.fontColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.6,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (isEdit) {
                            NoteDatabase.noteList[index!] = {
                              "title": titleController.text,
                              "description": descriptionController.text,
                              "date": dateController.text
                            };
                          } else {
                            NoteDatabase.noteList.add({
                              "title": titleController.text,
                              "description": descriptionController.text,
                              "date": dateController.text,
                            });
                            Navigator.pop(context);
                          }
                        });
                      },
                      child: Container(
                        width: 170,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: ColorConstants.mainRed,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Text(
                          isEdit ? "Update" : "Save",
                          style: TextStyle(
                            color: ColorConstants.fontColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.6,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
