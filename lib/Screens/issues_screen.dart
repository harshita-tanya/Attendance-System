import 'dart:developer';
import 'package:erp_app/Data/Jira/jira_data_source.dart';
import 'package:erp_app/Data/Jira/jira_issue.dart' as issue;
import 'package:flutter/material.dart';

class IssueScreen extends StatefulWidget {
  const IssueScreen({Key? key}) : super(key: key);

  @override
  State<IssueScreen> createState() => _IssueScreenState();
}

class _IssueScreenState extends State<IssueScreen> {
  Future<List<issue.Issue>>? _issueEntities;

  Future<List<issue.Issue>> getIssues() {
    return JiraDataSource().fetchIssues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Issues",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<List<issue.Issue?>>(
        future: getIssues(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            log(snapshot.data!.toString());
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: ((context, index) {
                return SizedBox(
                  height: 310.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  snapshot.data![index]!.fields!.creator!
                                      .displayName!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Status: ${snapshot.data![index]!.fields!.status!.name.toString().split('.').last}",
                              style: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Project: ${snapshot.data![index]!.fields!.project!.name}",
                              style: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "summary: ${snapshot.data![index]!.fields!.summary}",
                              style: const TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          }
          return Container();
        }),
      ),
    );
  }
}
