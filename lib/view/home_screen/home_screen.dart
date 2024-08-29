import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:note_app/utils/app_sessions.dart';
import 'package:note_app/utils/color_constants.dart';
import 'package:note_app/view/note_screen/note_screen.dart';
import 'package:note_app/view/home_screen/widgets/note_card.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  // list of colors to change the color of the note card
  List noteColors = [
    ColorConstants.blue,
    ColorConstants.coral,
    ColorConstants.lightred,
    ColorConstants.cyanGreen,
    ColorConstants.darkCream,
  ];
  // Hive
  var noteBox = Hive.box(AppSessions.noteBox);
  List noteKeys = [];
  int selectedColorIndex = 0;

  @override
  void initState() {
    noteKeys = noteBox.keys.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.mainColor,
      appBar: _buildAppBarSection(),
      body: noteKeys.isEmpty
          ? Center(
              child: Text(
                "Add Note",
                style: TextStyle(
                  color: ColorConstants.blue,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -1,
                ),
              ),
            )
          : _buildNoteListDisplaySection(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorConstants.blue,
        child: Icon(Icons.add, size: 40, color: ColorConstants.mainColor),
        onPressed: () {
          titleController.clear();
          descriptionController.clear();
          dateController.clear();
          customBottomSheet(context);
        },
      ),
    );
  }

  Widget _buildNoteListDisplaySection() {
    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: 15),
      padding: EdgeInsets.all(14),
      itemBuilder: (context, index) {
        final currentNote = noteBox.get(noteKeys[index]);
        return InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoteScreen(
                  noteTitle: currentNote["title"],
                  description: currentNote["description"],
                  date: currentNote["date"],
                  appBarColor: noteColors[currentNote["colorIndex"]],
                  onDelete: () async {
                    await noteBox.delete(noteKeys[index]);
                    setState(() {
                      noteKeys = noteBox.keys.toList();
                      Navigator.pop(context);
                    });
                  },
                ),
              ),
            );
          },
          child: NoteCard(
            title: currentNote["title"],
            description: currentNote["description"],
            date: currentNote["date"],
            cardColor: noteColors[currentNote["colorIndex"]],
            onEdit: () {
              titleController.text = currentNote["title"];
              descriptionController.text = currentNote["description"];
              dateController.text = currentNote["date"];
              selectedColorIndex = currentNote["colorIndex"];
              customBottomSheet(context, isEdit: true, index: index);
              setState(() {});
            },
            onDelete: () async {
              await noteBox.delete(noteKeys[index]);
              setState(() {
                noteKeys = noteBox.keys.toList();
              });
            },
            onShare: () {
              Share.share(
                """
${currentNote["title"]}
${currentNote["description"]}
${currentNote["date"]}""",
              );
            },
          ),
        );
      },
      itemCount: noteKeys.length,
    );
  }

  AppBar _buildAppBarSection() {
    return AppBar(
      backgroundColor: ColorConstants.blue,
      surfaceTintColor: ColorConstants.blue,
      leading: IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.home,
          color: ColorConstants.appBarFont,
        ),
      ),
      titleSpacing: 0,
      title: Text(
        "Home",
        style: TextStyle(
          color: ColorConstants.appBarFont,
          fontSize: 25,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.7,
        ),
      ),
    );
  }

  Future<dynamic> customBottomSheet(BuildContext context,
      {bool isEdit = false, int? index}) {
    return showModalBottomSheet(
      backgroundColor: ColorConstants.mainColor,
      isScrollControlled: true,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, bottomSetState) => Padding(
          padding: EdgeInsets.all(15),
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
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
                        color: ColorConstants.blue,
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
                      color: ColorConstants.blue,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                    controller: titleController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23),
                        borderSide:
                            BorderSide(width: 2, color: ColorConstants.blue),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23),
                        borderSide:
                            BorderSide(width: 2, color: ColorConstants.blue),
                      ),
                      hintText: "Title",
                      hintStyle: TextStyle(
                        color: ColorConstants.blue,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
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
                      color: ColorConstants.blue,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 7,
                    controller: descriptionController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23),
                        borderSide:
                            BorderSide(width: 2, color: ColorConstants.blue),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23),
                        borderSide:
                            BorderSide(width: 2, color: ColorConstants.blue),
                      ),
                      hintText: "Description",
                      hintStyle: TextStyle(
                        color: ColorConstants.blue,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
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
                    readOnly: true,
                    style: TextStyle(
                      color: ColorConstants.blue,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    controller: dateController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23),
                        borderSide:
                            BorderSide(width: 2, color: ColorConstants.blue),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23),
                        borderSide:
                            BorderSide(width: 2, color: ColorConstants.blue),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          var selectedDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          dateController.text =
                              DateFormat('MMMEd').format(selectedDate!);
                        },
                        icon: Icon(
                          Icons.calendar_month_rounded,
                          color: ColorConstants.blue,
                        ),
                      ),
                      hintText: "Date",
                      hintStyle: TextStyle(
                        color: ColorConstants.blue,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
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
                    children: List.generate(
                      noteColors.length,
                      (index) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: InkWell(
                            onTap: () {
                              bottomSetState(() {
                                selectedColorIndex = index;
                              });
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: selectedColorIndex == index
                                    ? Border.all(
                                        width: 4,
                                        color: ColorConstants.fontColor,
                                      )
                                    : null,
                                color: noteColors[index],
                              ),
                              child: selectedColorIndex == index
                                  ? Icon(
                                      Icons.check,
                                      size: 40,
                                      color: ColorConstants.fontColor,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        borderRadius: BorderRadius.circular(13),
                        onTap: () {
                          selectedColorIndex = 0;
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 170,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: ColorConstants.blue,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: ColorConstants.appBarFont,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.6,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(13),
                        onTap: () async {
                          if (isEdit) {
                            // updating data
                            noteBox.put(noteKeys[index!], {
                              "title": titleController.text,
                              "description": descriptionController.text,
                              "date": dateController.text,
                              "colorIndex": selectedColorIndex,
                            });
                            Navigator.pop(context);
                          } else {
                            // adding data to hive box
                            await noteBox.add({
                              "title": titleController.text,
                              "description": descriptionController.text,
                              "date": dateController.text,
                              "colorIndex": selectedColorIndex,
                            });
                            noteKeys = noteBox.keys.toList();
                            selectedColorIndex = 0;
                            Navigator.pop(context);
                          }
                          setState(() {});
                        },
                        child: Container(
                          width: 170,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: ColorConstants.blue,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Text(
                            isEdit ? "Update" : "Save",
                            style: TextStyle(
                              color: ColorConstants.appBarFont,
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
      ),
    );
  }
}
