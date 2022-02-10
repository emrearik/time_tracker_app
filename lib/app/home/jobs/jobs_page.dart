import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_tracker_app/app/home/job_entries/job_entries_page.dart';
import 'package:flutter_time_tracker_app/app/home/jobs/edit_job_page.dart';
import 'package:flutter_time_tracker_app/app/home/jobs/empty_content.dart';
import 'package:flutter_time_tracker_app/app/home/jobs/job_list_tile.dart';
import 'package:flutter_time_tracker_app/app/home/jobs/list_items_builder.dart';
import 'package:flutter_time_tracker_app/app/home/models/job.dart';
import 'package:flutter_time_tracker_app/services/auth.dart';
import 'package:flutter_time_tracker_app/services/database.dart';
import 'package:provider/provider.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _signOut() async {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Jobs Page"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: _signOut,
              child: Icon(
                Icons.logout,
              ),
            ),
          ),
        ],
      ),
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => EditJobPage.show(context,
            database: Provider.of<Database>(context, listen: false)),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job?>>(
        stream: database.jobsStream(),
        builder: (context, snapshot) {
          return ListItemsBuilder(
            snapshot: snapshot,
            itemBuilder: (context, Job? job) => Dismissible(
              key: Key('job-${job!.id}'),
              background: Container(color: Colors.red),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) => _delete(context, job),
              child: JobListTile(
                job: job,
                onTap: () => JobEntriesPage.show(context, job),
              ),
            ),
          );
        });
  }

  Future<void> _delete(BuildContext context, Job job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job);
    } on FirebaseException catch (e) {
      return showDialog(
        context: context,
        builder: (error) => const AlertDialog(
          title: Text("Error"),
          content: Text("An error occured."),
        ),
      );
    }
  }
}
