import 'dart:developer';

import 'package:erp_app/Data/Jira/issue_entity.dart';
import 'package:erp_app/Data/Jira/jira_issue.dart';
import 'package:erp_app/Data/Jira/jira_project.dart';
import 'package:http/http.dart' as http;

class JiraDataSource {
  String baseUrl = "https://jira.atlassian.com/";
  String projectsEndPoint = "rest/api/2/project";
  String issuesEndPoint = "rest/api/2/search?jql=ORDER%20BY%20Created";

  Future<List<JiraProject>> fetchProjects() async {
    final response = await http.get(Uri.parse(baseUrl + projectsEndPoint));
    if (response.statusCode == 200) {
      List<JiraProject> projects = jiraProjectFromJson(response.body).toList();
      return projects;
    } else {
      throw Exception('Failed to Load Data');
    }
  }

  Future<List<Issue>> fetchIssues() async {
    final response = await http.get(Uri.parse(baseUrl + issuesEndPoint));
    if (response.statusCode == 200) {
      List<Issue> issues = jiraIssueFromJson(response.body).issues!.toList();
      return issues;
    } else {
      throw Exception('Failed to Load Data');
    }
  }

  Future<List<IssueEntity>> fetchIssueEntity() async {
    List<Issue> issueList = await fetchIssues();
    List<IssueEntity> issueEntityList = issueList.map((issue) {
      IssueEntity issueEntity = IssueEntity(
        creatorName: issue.fields!.creator!.displayName,
        priority: issue.fields!.priority!.name,
        projectName: issue.fields!.project!.name,
        statusName: issue.fields!.status!.name.toString(),
        statusDescription: issue.fields!.status!.description,
        summary: issue.fields!.summary,
      );
      return issueEntity;
    }).toList();
    return issueEntityList;
  }
}
