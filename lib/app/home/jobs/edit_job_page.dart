import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_tracker_app/app/home/models/job.dart';
import 'package:flutter_time_tracker_app/services/database.dart';
import 'package:provider/provider.dart';

class EditJobPage extends StatefulWidget {
  final Database database;
  final Job? job;

  const EditJobPage({Key? key, required this.database, this.job})
      : super(key: key);

  static Future<void> show(BuildContext context,
      {Database? database, Job? job}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => EditJobPage(
                database: database!,
                job: job,
              ),
          fullscreenDialog: true),
    );
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  int? _ratePerHour;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job!.name;
      _ratePerHour = widget.job!.ratePerHour;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if (widget.job != null) {
          allNames.remove(widget.job!.name);
        }
        if (allNames.contains(_name)) {
          return showDialog(
              context: context,
              builder: (error) => AlertDialog(
                    title: Text("Error !"),
                    content: Text("Please choose another name."),
                  ));
        } else {
          String documentIdFromCurrentDate() =>
              DateTime.now().toIso8601String();
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Job(id: id, name: _name!, ratePerHour: _ratePerHour!);
          await widget.database.setJob(job);
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        return showDialog(
            context: context, builder: (error) => Text("An error occured."));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(widget.job == null ? "New Job" : "Edit Job"),
        actions: [
          MaterialButton(
            onPressed: _submit,
            child: Text(
              "Save",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          )
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey.shade200,
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child:
              Padding(padding: const EdgeInsets.all(16.0), child: _buildForm()),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: "Job Name"),
        initialValue: _name,
        onSaved: (value) => _name = value,
        validator: (value) => value!.isNotEmpty ? null : "Name can't be empty",
      ),
      TextFormField(
        decoration: InputDecoration(labelText: "Rate Per Hour"),
        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _ratePerHour = int.tryParse(value!) ?? 0,
      ),
    ];
  }
}
