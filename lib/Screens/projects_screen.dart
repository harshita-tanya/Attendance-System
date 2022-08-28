import 'dart:developer';
import 'package:erp_app/Data/Jira/jira_data_source.dart';
import 'package:erp_app/Data/Jira/jira_project.dart';
import 'package:flutter/material.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({Key? key}) : super(key: key);

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  Future<List<JiraProject>>? _projects;

  Future<List<JiraProject>> getProjects() {
    return JiraDataSource().fetchProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Projects",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<List<JiraProject?>>(
        future: getProjects(),
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
                    height: 110.0,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    snapshot.data![index]!.name!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  Image.network(
                                    snapshot
                                        .data![index]!.avatarUrls!.the24X24!,
                                    loadingBuilder: (context, child,
                                            loadingProgress) =>
                                        (loadingProgress == null)
                                            ? child
                                            : const CircularProgressIndicator(),
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Text("noImage"),
                                  ),
                                ],
                              ),
                              Text(
                                "Project ID: ${snapshot.data![index]!.id!}",
                                style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }));
          }
          return Container();
        }),
      ),
    );
  }
}
