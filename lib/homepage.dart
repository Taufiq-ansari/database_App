import 'package:db_pratice/db_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  List<Map<String, dynamic>> allNote = [];

  DbHepler? dbref;

  @override
  void initState() {
    super.initState();
    dbref = DbHepler.getInstance;

    getNote();
  }

  getNote() async {
    allNote = await dbref!.getAllNote();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sqlite Notes"),
      ),

      // all note visible here
      body: allNote.isNotEmpty
          ? ListView.builder(
              itemCount: allNote.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(allNote[index][DbHepler.COLUMN_NOTE_TITLE]),
                  subtitle: Text(allNote[index][DbHepler.COLUMN_NOTE_DESC]),
                  leading: Text("${index + 1}"),
                  trailing: SizedBox(
                    width: 60,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            titleController.text =
                                allNote[index][DbHepler.COLUMN_NOTE_TITLE];
                            descController.text =
                                allNote[index][DbHepler.COLUMN_NOTE_DESC];
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                // titleController.text =
                                // allNote[index][DbHepler.COLUMN_NOTE_TITLE];
                                // descController.text =
                                // allNote[index][DbHepler.COLUMN_NOTE_DESC];
                                return getBottomSheetWidget(
                                    isUpdate: true,
                                    sno: allNote[index]
                                        [DbHepler.COLUMN_NOTE_SNO]);
                              },
                            );
                          },
                          child: const Icon(Icons.edit),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            bool check = await dbref!.deleteNote(
                                sno: allNote[index][DbHepler.COLUMN_NOTE_SNO]);
                            if (check) {
                              getNote();
                            }
                          },
                          child: const Icon(Icons.remove_circle),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: Text("no notes yet"),
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          titleController.clear();
          descController.clear();
          //note to be add here
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return getBottomSheetWidget();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget getBottomSheetWidget({bool isUpdate = false, int sno = 0}) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Text(isUpdate ? "update note" : "add note"),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
                labelText: "title",
                hintText: "enter title here",
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            maxLines: 2,
            controller: descController,
            decoration: InputDecoration(
                labelText: "desc",
                hintText: "enter desc here",
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                )),
          ),
          Row(
            children: [
              OutlinedButton(
                onPressed: () async {
                  String title = titleController.text;
                  String desc = descController.text;
                  if (title.isNotEmpty && desc.isNotEmpty) {
                    bool check = isUpdate
                        ? await dbref!
                            .updateNote(mtitle: title, mdesc: desc, sno: sno)
                        : await dbref!.addNote(mTitle: title, mDesc: desc);
                    if (check) {
                      getNote();
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("please fill all the required blanks"),
                      ),
                    );
                  }
                  titleController.clear();
                  descController.clear();

                  Navigator.pop(context);
                },
                child: Text(isUpdate ? "update note" : "add note"),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("cancel "),
              ),
            ],
          )
        ],
      ),
    );
  }
}
