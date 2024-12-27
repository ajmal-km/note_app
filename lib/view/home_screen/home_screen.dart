import 'package:flutter/material.dart';
import 'package:note_app/utils/app_utils.dart';
import 'package:provider/provider.dart';
import '../../controller/home_controller.dart';
import '../../utils/color_constants.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/note_card.dart';

class HomeScreen extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => HomeScreen());
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();

  @override
  void initState() {
    context.read<HomeController>().getNotes();
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    context.read<HomeController>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, homeValue, child) => Scaffold(
        backgroundColor: ColorConstants.mainColor,
        appBar: _buildAppBarSection(),
        body: homeValue.noteKeys.isEmpty
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
            customBottomSheet();
          },
        ),
      ),
    );
  }

  Widget _buildNoteListDisplaySection() {
    return Consumer<HomeController>(
      builder: (context, value, child) => SingleChildScrollView(
        child: Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => SizedBox(height: 15),
              padding: EdgeInsets.all(14),
              itemBuilder: (context, index) {
                final currentNote = value.getCurrentNote(index);
                return NoteCard(
                  title: currentNote["title"],
                  description: currentNote["description"],
                  date: currentNote["date"],
                  cardColor: value.noteColors[currentNote["colorIndex"]],
                  onEdit: () {
                    titleController.text = currentNote["title"];
                    descriptionController.text = currentNote["description"];
                    dateController.text = currentNote["date"];
                    value.selectedColorIndex = currentNote["colorIndex"];
                    value.isSaved = currentNote["bookmarked"];
                    customBottomSheet(isEdit: true, index: index);
                  },
                  onDelete: () async => await value.removeNote(index),
                  onShare: () async => await AppUtils.shareNote(currentNote),
                );
              },
              itemCount: value.noteKeys.length,
            ),
          ],
        ),
      ),
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

  Future<dynamic> customBottomSheet({bool isEdit = false, int? index}) {
    return showModalBottomSheet(
      backgroundColor: ColorConstants.mainColor,
      isScrollControlled: true,
      context: navState.currentContext!,
      builder: (context) => Consumer<HomeController>(
        builder: (context, provider, child) => Padding(
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
                  CustomTextField(
                    controller: titleController,
                    hint: "Title",
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    controller: descriptionController,
                    hint: "Description",
                    maxlines: 7,
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    controller: dateController,
                    readOnly: true,
                    hint: "Date",
                    sufixIcon: Icons.calendar_month_outlined,
                    onSuffixTap: () async {
                      dateController.text = await AppUtils.formatedDatePicker(
                          firstdate: DateTime(2020));
                    },
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: List.generate(
                      provider.noteColors.length,
                      (index) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: GestureDetector(
                            onTap: () => provider.setColorIndex(index),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: provider.selectedColorIndex == index
                                    ? Border.all(
                                        width: 4,
                                        color: ColorConstants.fontColor,
                                      )
                                    : null,
                                color: provider.noteColors[index],
                              ),
                              child: provider.selectedColorIndex == index
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
                      CustomButton(
                        label: "Cancel",
                        onpressed: () {
                          provider.resetColorIndex();
                          Navigator.pop(context);
                        },
                      ),
                      CustomButton(
                        label: isEdit ? "Update" : "Save",
                        onpressed: () async {
                          if (isEdit) {
                            // updating data
                            await provider.editNote(
                              index: index!,
                              title: titleController.text,
                              description: descriptionController.text,
                              date: dateController.text,
                              colorIndex: provider.selectedColorIndex,
                            );
                          } else {
                            // adding data to hive
                            await provider.addNote(
                              title: titleController.text,
                              description: descriptionController.text,
                              date: dateController.text,
                              colorIndex: provider.selectedColorIndex,
                            );
                          }
                          // reset the selected color index to 0
                          provider.resetColorIndex();
                          Navigator.pop(context);
                        },
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
