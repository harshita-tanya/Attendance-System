class IssueEntity {
  final String? priority;
  final String? creatorName;
  final String? projectName;
  final String? statusName;
  final String? statusDescription;
  final String? summary;

  IssueEntity(
      {this.priority,
      this.creatorName,
      this.projectName,
      this.statusName,
      this.statusDescription,
      this.summary});
}
