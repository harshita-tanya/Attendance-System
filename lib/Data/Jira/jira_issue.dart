// To parse this JSON data, do
//
//     final jiraIssue = jiraIssueFromJson(jsonString);

import 'dart:convert';

JiraIssue jiraIssueFromJson(String str) => JiraIssue.fromJson(json.decode(str));

String jiraIssueToJson(JiraIssue data) => json.encode(data.toJson());

class JiraIssue {
    JiraIssue({
        this.expand,
        this.startAt,
        this.maxResults,
        this.total,
        this.issues,
    });

    final String? expand;
    final int? startAt;
    final int? maxResults;
    final int? total;
    final List<Issue>? issues;

    factory JiraIssue.fromJson(Map<String, dynamic> json) => JiraIssue(
        expand: json["expand"],
        startAt: json["startAt"],
        maxResults: json["maxResults"],
        total: json["total"],
        issues: List<Issue>.from(json["issues"].map((x) => Issue.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "expand": expand,
        "startAt": startAt,
        "maxResults": maxResults,
        "total": total,
        "issues": List<dynamic>.from(issues!.map((x) => x.toJson())),
    };
}

class Issue {
    Issue({
        this.expand,
        this.id,
        this.self,
        this.key,
        this.fields,
    });

    final String? expand;
    final String? id;
    final String? self;
    final String? key;
    final IssueFields? fields;

    factory Issue.fromJson(Map<String, dynamic> json) => Issue(
        expand: json["expand"],
        id: json["id"],
        self: json["self"],
        key: json["key"],
        fields: IssueFields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "expand": expand,
        "id": id,
        "self": self,
        "key": key,
        "fields": fields!.toJson(),
    };
}

class IssueFields {
    IssueFields({
        this.customfield18232,
        this.customfield20430,
        this.customfield20031,
        this.customfield18230,
        this.customfield18231,
        this.customfield20030,
        this.customfield16732,
        this.customfield10350,
        this.customfield14430,
        this.customfield16730,
        this.customfield10230,
        this.resolution,
        this.customfield12930,
        this.customfield11436,
        this.customfield11435,
        this.customfield11437,
        this.customfield17130,
        this.lastViewed,
        this.customfield10180,
        this.customfield17531,
        this.customfield17530,
        this.customfield17930,
        this.priority,
        this.customfield13730,
        this.customfield11431,
        this.customfield17933,
        this.customfield11434,
        this.customfield11433,
        this.labels,
        this.customfield10610,
        this.aggregatetimeoriginalestimate,
        this.timeestimate,
        this.customfield20934,
        this.issuelinks,
        this.customfield20932,
        this.customfield20933,
        this.assignee,
        this.customfield20930,
        this.customfield20931,
        this.status,
        this.customfield20530,
        this.customfield16030,
        this.components,
        this.customfield18730,
        this.customfield20131,
        this.customfield14130,
        this.customfield14532,
        this.customfield10571,
        this.customfield18731,
        this.customfield12630,
        this.customfield10575,
        this.customfield11930,
        this.customfield10723,
        this.aggregatetimeestimate,
        this.customfield17230,
        this.creator,
        this.customfield17630,
        this.customfield20240,
        this.customfield15331,
        this.customfield20241,
        this.subtasks,
        this.customfield10160,
        this.customfield10161,
        this.customfield13430,
        this.customfield11130,
        this.customfield10680,
        this.customfield10681,
        this.reporter,
        this.customfield17631,
        this.aggregateprogress,
        this.progress,
        this.customfield20239,
        this.votes,
        this.customfield20237,
        this.customfield20238,
        this.customfield20631,
        this.customfield20236,
        this.customfield20632,
        this.customfield20233,
        this.customfield18430,
        this.customfield20234,
        this.customfield20630,
        this.issuetype,
        this.customfield20231,
        this.customfield20232,
        this.customfield16530,
        this.customfield18030,
        this.customfield20230,
        this.customfield18031,
        this.timespent,
        this.customfield10150,
        this.customfield16930,
        this.project,
        this.customfield16532,
        this.customfield16531,
        this.customfield18830,
        this.aggregatetimespent,
        this.customfield16933,
        this.customfield18831,
        this.customfield16932,
        this.customfield16535,
        this.resolutiondate,
        this.workratio,
        this.watches,
        this.customfield17333,
        this.customfield15430,
        this.customfield19230,
        this.customfield19231,
        this.created,
        this.customfield19232,
        this.customfield21030,
        this.customfield15830,
        this.customfield17335,
        this.customfield17334,
        this.customfield11631,
        this.customfield12833,
        this.customfield12832,
        this.customfield14735,
        this.updated,
        this.customfield20730,
        this.customfield20333,
        this.customfield20330,
        this.customfield14330,
        this.customfield18130,
        this.timeoriginalestimate,
        this.customfield10250,
        this.description,
        this.customfield16632,
        this.customfield16630,
        this.customfield10650,
        this.customfield14733,
        this.customfield14734,
        this.customfield10651,
        this.customfield14731,
        this.customfield18931,
        this.customfield12831,
        this.customfield18932,
        this.customfield14732,
        this.customfield10653,
        this.customfield12830,
        this.customfield10401,
        this.summary,
        this.customfield17432,
        this.customfield17431,
        this.customfield13230,
        this.customfield19330,
        this.customfield21130,
        this.customfield15532,
        this.customfield17831,
        this.customfield13231,
        this.customfield17830,
        this.customfield15530,
        this.customfield17433,
        this.customfield15932,
        this.customfield15930,
        this.customfield15931,
        this.customfield11730,
        this.customfield12931,
        this.environment,
        this.duedate,
        this.customfield20831,
        this.customfield20830,
        this.customfield14830,
        this.customfield14930,
        this.customfield12530,
        this.customfield10510,
        this.customfield10580,
        this.customfield12231,
        this.customfield10570,
        this.customfield12230,
        this.customfield10600,
        this.customfield10560,
        this.customfield10440,
        this.customfield13830,
        this.customfield16130,
        this.customfield10390,
        this.customfield10432,
        this.customfield10433,
        this.customfield17031,
        this.customfield17030,
        this.customfield13630,
        this.fixVersions,
        this.customfield19430,
        this.customfield21631,
        this.customfield21630,
        this.customfield10621,
        this.customfield14230,
        this.customfield10530,
        this.customfield19830,
        this.customfield19831,
        this.customfield19832,
        this.versions,
        this.customfield19931,
        this.customfield16330,
        this.customfield19730,
        this.customfield11331,
        this.customfield21632,
        this.customfield10590,
        this.customfield10591,
    });

    final dynamic customfield18232;
    final dynamic customfield20430;
    final dynamic customfield20031;
    final dynamic customfield18230;
    final dynamic customfield18231;
    final dynamic customfield20030;
    final dynamic customfield16732;
    final dynamic customfield10350;
    final dynamic customfield14430;
    final Customfield? customfield16730;
    final dynamic customfield10230;
    final Component? resolution;
    final dynamic customfield12930;
    final String? customfield11436;
    final String? customfield11435;
    final String? customfield11437;
    final Customfield? customfield17130;
    final dynamic lastViewed;
    final dynamic customfield10180;
    final dynamic customfield17531;
    final dynamic customfield17530;
    final dynamic customfield17930;
    final Component? priority;
    final dynamic customfield13730;
    final String? customfield11431;
    final dynamic customfield17933;
    final String? customfield11434;
    final String? customfield11433;
    final List<String>? labels;
    final int? customfield10610;
    final dynamic aggregatetimeoriginalestimate;
    final dynamic timeestimate;
    final dynamic customfield20934;
    final List<Issuelink>? issuelinks;
    final dynamic customfield20932;
    final dynamic customfield20933;
    final Creator? assignee;
    final dynamic customfield20930;
    final dynamic customfield20931;
    final Status? status;
    final dynamic customfield20530;
    final dynamic customfield16030;
    final List<Component>? components;
    final Customfield18730? customfield18730;
    final dynamic customfield20131;
    final dynamic customfield14130;
    final dynamic customfield14532;
    final dynamic customfield10571;
    final dynamic customfield18731;
    final dynamic customfield12630;
    final dynamic customfield10575;
    final dynamic customfield11930;
    final dynamic customfield10723;
    final dynamic aggregatetimeestimate;
    final dynamic customfield17230;
    final Creator? creator;
    final dynamic customfield17630;
    final dynamic customfield20240;
    final dynamic customfield15331;
    final dynamic customfield20241;
    final List<dynamic>? subtasks;
    final String? customfield10160;
    final String? customfield10161;
    final dynamic customfield13430;
    final String? customfield11130;
    final dynamic customfield10680;
    final dynamic customfield10681;
    final Creator? reporter;
    final dynamic customfield17631;
    final Progress? aggregateprogress;
    final Progress? progress;
    final Customfield? customfield20239;
    final Votes? votes;
    final dynamic customfield20237;
    final dynamic customfield20238;
    final dynamic customfield20631;
    final dynamic customfield20236;
    final dynamic customfield20632;
    final dynamic customfield20233;
    final dynamic customfield18430;
    final dynamic customfield20234;
    final dynamic customfield20630;
    final Issuetype? issuetype;
    final dynamic customfield20231;
    final Customfield? customfield20232;
    final dynamic customfield16530;
    final dynamic customfield18030;
    final dynamic customfield20230;
    final dynamic customfield18031;
    final dynamic timespent;
    final List<String>? customfield10150;
    final dynamic customfield16930;
    final Project? project;
    final dynamic customfield16532;
    final dynamic customfield16531;
    final dynamic customfield18830;
    final dynamic aggregatetimespent;
    final dynamic customfield16933;
    final dynamic customfield18831;
    final dynamic customfield16932;
    final dynamic customfield16535;
    final String? resolutiondate;
    final int? workratio;
    final Watches? watches;
    final dynamic customfield17333;
    final dynamic customfield15430;
    final dynamic customfield19230;
    final dynamic customfield19231;
    final String? created;
    final dynamic customfield19232;
    final dynamic customfield21030;
    final dynamic customfield15830;
    final dynamic customfield17335;
    final dynamic customfield17334;
    final dynamic customfield11631;
    final dynamic customfield12833;
    final dynamic customfield12832;
    final String? customfield14735;
    final String? updated;
    final dynamic customfield20730;
    final String? customfield20333;
    final dynamic customfield20330;
    final dynamic customfield14330;
    final dynamic customfield18130;
    final dynamic timeoriginalestimate;
    final String? customfield10250;
    final String? description;
    final dynamic customfield16632;
    final dynamic customfield16630;
    final dynamic customfield10650;
    final String? customfield14733;
    final String? customfield14734;
    final dynamic customfield10651;
    final String? customfield14731;
    final dynamic customfield18931;
    final dynamic customfield12831;
    final dynamic customfield18932;
    final String? customfield14732;
    final dynamic customfield10653;
    final dynamic customfield12830;
    final dynamic customfield10401;
    final String? summary;
    final dynamic customfield17432;
    final dynamic customfield17431;
    final String? customfield13230;
    final String? customfield19330;
    final dynamic customfield21130;
    final dynamic customfield15532;
    final dynamic customfield17831;
    final String? customfield13231;
    final dynamic customfield17830;
    final dynamic customfield15530;
    final dynamic customfield17433;
    final dynamic customfield15932;
    final dynamic customfield15930;
    final dynamic customfield15931;
    final dynamic customfield11730;
    final dynamic customfield12931;
    final dynamic environment;
    final dynamic duedate;
    final dynamic customfield20831;
    final Customfield? customfield20830;
    final String? customfield14830;
    final String? customfield14930;
    final dynamic customfield12530;
    final String? customfield10510;
    final dynamic customfield10580;
    final dynamic customfield12231;
    final dynamic customfield10570;
    final dynamic customfield12230;
    final dynamic customfield10600;
    final dynamic customfield10560;
    final dynamic customfield10440;
    final dynamic customfield13830;
    final dynamic customfield16130;
    final String? customfield10390;
    final dynamic customfield10432;
    final dynamic customfield10433;
    final Customfield? customfield17031;
    final Customfield? customfield17030;
    final dynamic customfield13630;
    final List<dynamic>? fixVersions;
    final dynamic customfield19430;
    final dynamic customfield21631;
    final dynamic customfield21630;
    final dynamic customfield10621;
    final dynamic customfield14230;
    final dynamic customfield10530;
    final List<Customfield>? customfield19830;
    final dynamic customfield19831;
    final String? customfield19832;
    final List<Version>? versions;
    final String? customfield19931;
    final String? customfield16330;
    final dynamic customfield19730;
    final dynamic customfield11331;
    final dynamic customfield21632;
    final Customfield? customfield10590;
    final Customfield? customfield10591;

    factory IssueFields.fromJson(Map<String, dynamic> json) => IssueFields(
        customfield18232: json["customfield_18232"],
        customfield20430: json["customfield_20430"],
        customfield20031: json["customfield_20031"],
        customfield18230: json["customfield_18230"],
        customfield18231: json["customfield_18231"],
        customfield20030: json["customfield_20030"],
        customfield16732: json["customfield_16732"],
        customfield10350: json["customfield_10350"],
        customfield14430: json["customfield_14430"],
        customfield16730: Customfield.fromJson(json["customfield_16730"]),
        customfield10230: json["customfield_10230"],
        resolution: json["resolution"] == null ? null : Component.fromJson(json["resolution"]),
        customfield12930: json["customfield_12930"],
        customfield11436: json["customfield_11436"],
        customfield11435: json["customfield_11435"],
        customfield11437: json["customfield_11437"],
        customfield17130: json["customfield_17130"] == null ? null : Customfield.fromJson(json["customfield_17130"]),
        lastViewed: json["lastViewed"],
        customfield10180: json["customfield_10180"],
        customfield17531: json["customfield_17531"],
        customfield17530: json["customfield_17530"],
        customfield17930: json["customfield_17930"],
        priority: json["priority"] == null ? null : Component.fromJson(json["priority"]),
        customfield13730: json["customfield_13730"],
        customfield11431: json["customfield_11431"],
        customfield17933: json["customfield_17933"],
        customfield11434: json["customfield_11434"],
        customfield11433: json["customfield_11433"],
        labels: List<String>.from(json["labels"].map((x) => x)),
        customfield10610: json["customfield_10610"] == null ? null : json["customfield_10610"],
        aggregatetimeoriginalestimate: json["aggregatetimeoriginalestimate"],
        timeestimate: json["timeestimate"],
        customfield20934: json["customfield_20934"],
        issuelinks: List<Issuelink>.from(json["issuelinks"].map((x) => Issuelink.fromJson(x))),
        customfield20932: json["customfield_20932"],
        customfield20933: json["customfield_20933"],
        assignee: json["assignee"] == null ? null : Creator.fromJson(json["assignee"]),
        customfield20930: json["customfield_20930"],
        customfield20931: json["customfield_20931"],
        status: Status.fromJson(json["status"]),
        customfield20530: json["customfield_20530"],
        customfield16030: json["customfield_16030"],
        components: List<Component>.from(json["components"].map((x) => Component.fromJson(x))),
        customfield18730: customfield18730Values.map![json["customfield_18730"]],
        customfield20131: json["customfield_20131"],
        customfield14130: json["customfield_14130"],
        customfield14532: json["customfield_14532"],
        customfield10571: json["customfield_10571"],
        customfield18731: json["customfield_18731"],
        customfield12630: json["customfield_12630"],
        customfield10575: json["customfield_10575"],
        customfield11930: json["customfield_11930"],
        customfield10723: json["customfield_10723"],
        aggregatetimeestimate: json["aggregatetimeestimate"],
        customfield17230: json["customfield_17230"],
        creator: Creator.fromJson(json["creator"]),
        customfield17630: json["customfield_17630"],
        customfield20240: json["customfield_20240"],
        customfield15331: json["customfield_15331"],
        customfield20241: json["customfield_20241"],
        subtasks: List<dynamic>.from(json["subtasks"].map((x) => x)),
        customfield10160: json["customfield_10160"],
        customfield10161: json["customfield_10161"],
        customfield13430: json["customfield_13430"],
        customfield11130: json["customfield_11130"],
        customfield10680: json["customfield_10680"],
        customfield10681: json["customfield_10681"],
        reporter: Creator.fromJson(json["reporter"]),
        customfield17631: json["customfield_17631"],
        aggregateprogress: Progress.fromJson(json["aggregateprogress"]),
        progress: Progress.fromJson(json["progress"]),
        customfield20239: json["customfield_20239"] == null ? null : Customfield.fromJson(json["customfield_20239"]),
        votes: Votes.fromJson(json["votes"]),
        customfield20237: json["customfield_20237"],
        customfield20238: json["customfield_20238"],
        customfield20631: json["customfield_20631"],
        customfield20236: json["customfield_20236"],
        customfield20632: json["customfield_20632"],
        customfield20233: json["customfield_20233"],
        customfield18430: json["customfield_18430"],
        customfield20234: json["customfield_20234"],
        customfield20630: json["customfield_20630"],
        issuetype: Issuetype.fromJson(json["issuetype"]),
        customfield20231: json["customfield_20231"],
        customfield20232: Customfield.fromJson(json["customfield_20232"]),
        customfield16530: json["customfield_16530"],
        customfield18030: json["customfield_18030"],
        customfield20230: json["customfield_20230"],
        customfield18031: json["customfield_18031"],
        timespent: json["timespent"],
        customfield10150: List<String>.from(json["customfield_10150"].map((x) => x)),
        customfield16930: json["customfield_16930"],
        project: Project.fromJson(json["project"]),
        customfield16532: json["customfield_16532"],
        customfield16531: json["customfield_16531"],
        customfield18830: json["customfield_18830"],
        aggregatetimespent: json["aggregatetimespent"],
        customfield16933: json["customfield_16933"],
        customfield18831: json["customfield_18831"],
        customfield16932: json["customfield_16932"],
        customfield16535: json["customfield_16535"],
        resolutiondate: json["resolutiondate"] == null ? null : json["resolutiondate"],
        workratio: json["workratio"],
        watches: Watches.fromJson(json["watches"]),
        customfield17333: json["customfield_17333"],
        customfield15430: json["customfield_15430"],
        customfield19230: json["customfield_19230"],
        customfield19231: json["customfield_19231"],
        created: json["created"],
        customfield19232: json["customfield_19232"],
        customfield21030: json["customfield_21030"],
        customfield15830: json["customfield_15830"],
        customfield17335: json["customfield_17335"],
        customfield17334: json["customfield_17334"],
        customfield11631: json["customfield_11631"],
        customfield12833: json["customfield_12833"],
        customfield12832: json["customfield_12832"],
        customfield14735: json["customfield_14735"],
        updated: json["updated"],
        customfield20730: json["customfield_20730"],
        customfield20333: json["customfield_20333"],
        customfield20330: json["customfield_20330"],
        customfield14330: json["customfield_14330"],
        customfield18130: json["customfield_18130"],
        timeoriginalestimate: json["timeoriginalestimate"],
        customfield10250: json["customfield_10250"] == null ? null : json["customfield_10250"],
        description: json["description"],
        customfield16632: json["customfield_16632"],
        customfield16630: json["customfield_16630"],
        customfield10650: json["customfield_10650"],
        customfield14733: json["customfield_14733"],
        customfield14734: json["customfield_14734"],
        customfield10651: json["customfield_10651"],
        customfield14731: json["customfield_14731"],
        customfield18931: json["customfield_18931"],
        customfield12831: json["customfield_12831"],
        customfield18932: json["customfield_18932"],
        customfield14732: json["customfield_14732"],
        customfield10653: json["customfield_10653"],
        customfield12830: json["customfield_12830"],
        customfield10401: json["customfield_10401"],
        summary: json["summary"],
        customfield17432: json["customfield_17432"],
        customfield17431: json["customfield_17431"],
        customfield13230: json["customfield_13230"] == null ? null : json["customfield_13230"],
        customfield19330: json["customfield_19330"] == null ? null : json["customfield_19330"],
        customfield21130: json["customfield_21130"],
        customfield15532: json["customfield_15532"],
        customfield17831: json["customfield_17831"],
        customfield13231: json["customfield_13231"] == null ? null : json["customfield_13231"],
        customfield17830: json["customfield_17830"],
        customfield15530: json["customfield_15530"],
        customfield17433: json["customfield_17433"],
        customfield15932: json["customfield_15932"],
        customfield15930: json["customfield_15930"],
        customfield15931: json["customfield_15931"],
        customfield11730: json["customfield_11730"],
        customfield12931: json["customfield_12931"],
        environment: json["environment"],
        duedate: json["duedate"],
        customfield20831: json["customfield_20831"],
        customfield20830: Customfield.fromJson(json["customfield_20830"]),
        customfield14830: json["customfield_14830"] == null ? null : json["customfield_14830"],
        customfield14930: json["customfield_14930"] == null ? null : json["customfield_14930"],
        customfield12530: json["customfield_12530"],
        customfield10510: json["customfield_10510"] == null ? null : json["customfield_10510"],
        customfield10580: json["customfield_10580"],
        customfield12231: json["customfield_12231"],
        customfield10570: json["customfield_10570"],
        customfield12230: json["customfield_12230"],
        customfield10600: json["customfield_10600"],
        customfield10560: json["customfield_10560"],
        customfield10440: json["customfield_10440"],
        customfield13830: json["customfield_13830"],
        customfield16130: json["customfield_16130"],
        customfield10390: json["customfield_10390"] == null ? null : json["customfield_10390"],
        customfield10432: json["customfield_10432"],
        customfield10433: json["customfield_10433"],
        customfield17031: json["customfield_17031"] == null ? null : Customfield.fromJson(json["customfield_17031"]),
        customfield17030: json["customfield_17030"] == null ? null : Customfield.fromJson(json["customfield_17030"]),
        customfield13630: json["customfield_13630"],
        fixVersions: json["fixVersions"] == null ? null : List<dynamic>.from(json["fixVersions"].map((x) => x)),
        customfield19430: json["customfield_19430"],
        customfield21631: json["customfield_21631"],
        customfield21630: json["customfield_21630"],
        customfield10621: json["customfield_10621"],
        customfield14230: json["customfield_14230"],
        customfield10530: json["customfield_10530"],
        customfield19830: json["customfield_19830"] == null ? null : List<Customfield>.from(json["customfield_19830"].map((x) => Customfield.fromJson(x))),
        customfield19831: json["customfield_19831"],
        customfield19832: json["customfield_19832"] == null ? null : json["customfield_19832"],
        versions: json["versions"] == null ? null : List<Version>.from(json["versions"].map((x) => Version.fromJson(x))),
        customfield19931: json["customfield_19931"] == null ? null : json["customfield_19931"],
        customfield16330: json["customfield_16330"] == null ? null : json["customfield_16330"],
        customfield19730: json["customfield_19730"],
        customfield11331: json["customfield_11331"],
        customfield21632: json["customfield_21632"],
        customfield10590: json["customfield_10590"] == null ? null : Customfield.fromJson(json["customfield_10590"]),
        customfield10591: json["customfield_10591"] == null ? null : Customfield.fromJson(json["customfield_10591"]),
    );

    Map<String, dynamic> toJson() => {
        "customfield_18232": customfield18232,
        "customfield_20430": customfield20430,
        "customfield_20031": customfield20031,
        "customfield_18230": customfield18230,
        "customfield_18231": customfield18231,
        "customfield_20030": customfield20030,
        "customfield_16732": customfield16732,
        "customfield_10350": customfield10350,
        "customfield_14430": customfield14430,
        "customfield_16730": customfield16730!.toJson(),
        "customfield_10230": customfield10230,
        "resolution": resolution == null ? null : resolution!.toJson(),
        "customfield_12930": customfield12930,
        "customfield_11436": customfield11436,
        "customfield_11435": customfield11435,
        "customfield_11437": customfield11437,
        "customfield_17130": customfield17130 == null ? null : customfield17130!.toJson(),
        "lastViewed": lastViewed,
        "customfield_10180": customfield10180,
        "customfield_17531": customfield17531,
        "customfield_17530": customfield17530,
        "customfield_17930": customfield17930,
        "priority": priority == null ? null : priority!.toJson(),
        "customfield_13730": customfield13730,
        "customfield_11431": customfield11431,
        "customfield_17933": customfield17933,
        "customfield_11434": customfield11434,
        "customfield_11433": customfield11433,
        "labels": List<dynamic>.from(labels!.map((x) => x)),
        "customfield_10610": customfield10610 == null ? null : customfield10610,
        "aggregatetimeoriginalestimate": aggregatetimeoriginalestimate,
        "timeestimate": timeestimate,
        "customfield_20934": customfield20934,
        "issuelinks": List<dynamic>.from(issuelinks!.map((x) => x.toJson())),
        "customfield_20932": customfield20932,
        "customfield_20933": customfield20933,
        "assignee": assignee == null ? null : assignee!.toJson(),
        "customfield_20930": customfield20930,
        "customfield_20931": customfield20931,
        "status": status!.toJson(),
        "customfield_20530": customfield20530,
        "customfield_16030": customfield16030,
        "components": List<dynamic>.from(components!.map((x) => x.toJson())),
        "customfield_18730": customfield18730Values.reverse[customfield18730],
        "customfield_20131": customfield20131,
        "customfield_14130": customfield14130,
        "customfield_14532": customfield14532,
        "customfield_10571": customfield10571,
        "customfield_18731": customfield18731,
        "customfield_12630": customfield12630,
        "customfield_10575": customfield10575,
        "customfield_11930": customfield11930,
        "customfield_10723": customfield10723,
        "aggregatetimeestimate": aggregatetimeestimate,
        "customfield_17230": customfield17230,
        "creator": creator!.toJson(),
        "customfield_17630": customfield17630,
        "customfield_20240": customfield20240,
        "customfield_15331": customfield15331,
        "customfield_20241": customfield20241,
        "subtasks": List<dynamic>.from(subtasks!.map((x) => x)),
        "customfield_10160": customfield10160,
        "customfield_10161": customfield10161,
        "customfield_13430": customfield13430,
        "customfield_11130": customfield11130,
        "customfield_10680": customfield10680,
        "customfield_10681": customfield10681,
        "reporter": reporter!.toJson(),
        "customfield_17631": customfield17631,
        "aggregateprogress": aggregateprogress!.toJson(),
        "progress": progress!.toJson(),
        "customfield_20239": customfield20239 == null ? null : customfield20239!.toJson(),
        "votes": votes!.toJson(),
        "customfield_20237": customfield20237,
        "customfield_20238": customfield20238,
        "customfield_20631": customfield20631,
        "customfield_20236": customfield20236,
        "customfield_20632": customfield20632,
        "customfield_20233": customfield20233,
        "customfield_18430": customfield18430,
        "customfield_20234": customfield20234,
        "customfield_20630": customfield20630,
        "issuetype": issuetype!.toJson(),
        "customfield_20231": customfield20231,
        "customfield_20232": customfield20232!.toJson(),
        "customfield_16530": customfield16530,
        "customfield_18030": customfield18030,
        "customfield_20230": customfield20230,
        "customfield_18031": customfield18031,
        "timespent": timespent,
        "customfield_10150": List<dynamic>.from(customfield10150!.map((x) => x)),
        "customfield_16930": customfield16930,
        "project": project!.toJson(),
        "customfield_16532": customfield16532,
        "customfield_16531": customfield16531,
        "customfield_18830": customfield18830,
        "aggregatetimespent": aggregatetimespent,
        "customfield_16933": customfield16933,
        "customfield_18831": customfield18831,
        "customfield_16932": customfield16932,
        "customfield_16535": customfield16535,
        "resolutiondate": resolutiondate == null ? null : resolutiondate,
        "workratio": workratio,
        "watches": watches!.toJson(),
        "customfield_17333": customfield17333,
        "customfield_15430": customfield15430,
        "customfield_19230": customfield19230,
        "customfield_19231": customfield19231,
        "created": created,
        "customfield_19232": customfield19232,
        "customfield_21030": customfield21030,
        "customfield_15830": customfield15830,
        "customfield_17335": customfield17335,
        "customfield_17334": customfield17334,
        "customfield_11631": customfield11631,
        "customfield_12833": customfield12833,
        "customfield_12832": customfield12832,
        "customfield_14735": customfield14735,
        "updated": updated,
        "customfield_20730": customfield20730,
        "customfield_20333": customfield20333,
        "customfield_20330": customfield20330,
        "customfield_14330": customfield14330,
        "customfield_18130": customfield18130,
        "timeoriginalestimate": timeoriginalestimate,
        "customfield_10250": customfield10250 == null ? null : customfield10250,
        "description": description,
        "customfield_16632": customfield16632,
        "customfield_16630": customfield16630,
        "customfield_10650": customfield10650,
        "customfield_14733": customfield14733,
        "customfield_14734": customfield14734,
        "customfield_10651": customfield10651,
        "customfield_14731": customfield14731,
        "customfield_18931": customfield18931,
        "customfield_12831": customfield12831,
        "customfield_18932": customfield18932,
        "customfield_14732": customfield14732,
        "customfield_10653": customfield10653,
        "customfield_12830": customfield12830,
        "customfield_10401": customfield10401,
        "summary": summary,
        "customfield_17432": customfield17432,
        "customfield_17431": customfield17431,
        "customfield_13230": customfield13230 == null ? null : customfield13230,
        "customfield_19330": customfield19330 == null ? null : customfield19330,
        "customfield_21130": customfield21130,
        "customfield_15532": customfield15532,
        "customfield_17831": customfield17831,
        "customfield_13231": customfield13231 == null ? null : customfield13231,
        "customfield_17830": customfield17830,
        "customfield_15530": customfield15530,
        "customfield_17433": customfield17433,
        "customfield_15932": customfield15932,
        "customfield_15930": customfield15930,
        "customfield_15931": customfield15931,
        "customfield_11730": customfield11730,
        "customfield_12931": customfield12931,
        "environment": environment,
        "duedate": duedate,
        "customfield_20831": customfield20831,
        "customfield_20830": customfield20830!.toJson(),
        "customfield_14830": customfield14830 == null ? null : customfield14830,
        "customfield_14930": customfield14930 == null ? null : customfield14930,
        "customfield_12530": customfield12530,
        "customfield_10510": customfield10510 == null ? null : customfield10510,
        "customfield_10580": customfield10580,
        "customfield_12231": customfield12231,
        "customfield_10570": customfield10570,
        "customfield_12230": customfield12230,
        "customfield_10600": customfield10600,
        "customfield_10560": customfield10560,
        "customfield_10440": customfield10440,
        "customfield_13830": customfield13830,
        "customfield_16130": customfield16130,
        "customfield_10390": customfield10390 == null ? null : customfield10390,
        "customfield_10432": customfield10432,
        "customfield_10433": customfield10433,
        "customfield_17031": customfield17031 == null ? null : customfield17031!.toJson(),
        "customfield_17030": customfield17030 == null ? null : customfield17030!.toJson(),
        "customfield_13630": customfield13630,
        "fixVersions": fixVersions == null ? null : List<dynamic>.from(fixVersions!.map((x) => x)),
        "customfield_19430": customfield19430,
        "customfield_21631": customfield21631,
        "customfield_21630": customfield21630,
        "customfield_10621": customfield10621,
        "customfield_14230": customfield14230,
        "customfield_10530": customfield10530,
        "customfield_19830": customfield19830 == null ? null : List<dynamic>.from(customfield19830!.map((x) => x.toJson())),
        "customfield_19831": customfield19831,
        "customfield_19832": customfield19832 == null ? null : customfield19832,
        "versions": versions == null ? null : List<dynamic>.from(versions!.map((x) => x.toJson())),
        "customfield_19931": customfield19931 == null ? null : customfield19931,
        "customfield_16330": customfield16330 == null ? null : customfield16330,
        "customfield_19730": customfield19730,
        "customfield_11331": customfield11331,
        "customfield_21632": customfield21632,
        "customfield_10590": customfield10590 == null ? null : customfield10590!.toJson(),
        "customfield_10591": customfield10591 == null ? null : customfield10591!.toJson(),
    };
}

class Progress {
    Progress({
        this.progress,
        this.total,
    });

    final int? progress;
    final int? total;

    factory Progress.fromJson(Map<String, dynamic> json) => Progress(
        progress: json["progress"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "progress": progress,
        "total": total,
    };
}

class Creator {
    Creator({
        this.self,
        this.name,
        this.key,
        this.avatarUrls,
        this.displayName,
        this.active,
        this.timeZone,
    });

    final String? self;
    final String? name;
    final String? key;
    final AvatarUrls? avatarUrls;
    final String? displayName;
    final bool? active;
    final TimeZone? timeZone;

    factory Creator.fromJson(Map<String, dynamic> json) => Creator(
        self: json["self"],
        name: json["name"],
        key: json["key"],
        avatarUrls: AvatarUrls.fromJson(json["avatarUrls"]),
        displayName: json["displayName"],
        active: json["active"],
        timeZone: timeZoneValues.map![json["timeZone"]],
    );

    Map<String, dynamic> toJson() => {
        "self": self,
        "name": name,
        "key": key,
        "avatarUrls": avatarUrls!.toJson(),
        "displayName": displayName,
        "active": active,
        "timeZone": timeZoneValues.reverse[timeZone],
    };
}

class AvatarUrls {
    AvatarUrls({
        this.the48X48,
        this.the24X24,
        this.the16X16,
        this.the32X32,
    });

    final String? the48X48;
    final String? the24X24;
    final String? the16X16;
    final String? the32X32;

    factory AvatarUrls.fromJson(Map<String, dynamic> json) => AvatarUrls(
        the48X48: json["48x48"],
        the24X24: json["24x24"],
        the16X16: json["16x16"],
        the32X32: json["32x32"],
    );

    Map<String, dynamic> toJson() => {
        "48x48": the48X48,
        "24x24": the24X24,
        "16x16": the16X16,
        "32x32": the32X32,
    };
}

enum TimeZone { AUSTRALIA_SYDNEY, UTC, AMERICA_CHICAGO, AMERICA_SAO_PAULO, AMERICA_NEW_YORK, EUROPE_AMSTERDAM, EUROPE_LONDON, ASIA_TOKYO, AMERICA_TORONTO }

final timeZoneValues = EnumValues({
    "America/Chicago": TimeZone.AMERICA_CHICAGO,
    "America/New_York": TimeZone.AMERICA_NEW_YORK,
    "America/Sao_Paulo": TimeZone.AMERICA_SAO_PAULO,
    "America/Toronto": TimeZone.AMERICA_TORONTO,
    "Asia/Tokyo": TimeZone.ASIA_TOKYO,
    "Australia/Sydney": TimeZone.AUSTRALIA_SYDNEY,
    "Europe/Amsterdam": TimeZone.EUROPE_AMSTERDAM,
    "Europe/London": TimeZone.EUROPE_LONDON,
    "UTC": TimeZone.UTC
});

class Component {
    Component({
        this.self,
        this.id,
        this.name,
        this.description,
        this.iconUrl,
    });

    final String? self;
    final String? id;
    final String? name;
    final String? description;
    final String? iconUrl;

    factory Component.fromJson(Map<String, dynamic> json) => Component(
        self: json["self"],
        id: json["id"],
        name: json["name"],
        description: json["description"] == null ? null : json["description"],
        iconUrl: json["iconUrl"] == null ? null : json["iconUrl"],
    );

    Map<String, dynamic> toJson() => {
        "self": self,
        "id": id,
        "name": name,
        "description": description == null ? null : description,
        "iconUrl": iconUrl == null ? null : iconUrl,
    };
}

class Customfield {
    Customfield({
        this.self,
        this.value,
        this.id,
        this.disabled,
    });

    final String? self;
    final Value? value;
    final String? id;
    final bool? disabled;

    factory Customfield.fromJson(Map<String, dynamic> json) => Customfield(
        self: json["self"],
        value: valueValues.map![json["value"]],
        id: json["id"],
        disabled: json["disabled"],
    );

    Map<String, dynamic> toJson() => {
        "self": self,
        "value": valueValues.reverse[value],
        "id": id,
        "disabled": disabled,
    };
}

enum Value { UNKNOWN, OTHER, NOT_DONE, MINOR, SEVERITY_3_MINOR, SEVERITY_2_MAJOR, MAJOR, FRENCH, PLEASE_SELECT_ONE, TRANSLATION_ERROR, NO }

final valueValues = EnumValues({
    "French": Value.FRENCH,
    "Major": Value.MAJOR,
    "Minor": Value.MINOR,
    "No": Value.NO,
    "Not Done": Value.NOT_DONE,
    "Other": Value.OTHER,
    "Please select one": Value.PLEASE_SELECT_ONE,
    "Severity 2 - Major": Value.SEVERITY_2_MAJOR,
    "Severity 3 - Minor": Value.SEVERITY_3_MINOR,
    "Translation Error": Value.TRANSLATION_ERROR,
    "Unknown": Value.UNKNOWN
});

enum Customfield18730 { EMPTY }

final customfield18730Values = EnumValues({
    "{}": Customfield18730.EMPTY
});

class Issuelink {
    Issuelink({
        this.id,
        this.self,
        this.type,
        this.inwardIssue,
        this.outwardIssue,
    });

    final String? id;
    final String? self;
    final Type? type;
    final WardIssue? inwardIssue;
    final WardIssue? outwardIssue;

    factory Issuelink.fromJson(Map<String, dynamic> json) => Issuelink(
        id: json["id"],
        self: json["self"],
        type: Type.fromJson(json["type"]),
        inwardIssue: json["inwardIssue"] == null ? null : WardIssue.fromJson(json["inwardIssue"]),
        outwardIssue: json["outwardIssue"] == null ? null : WardIssue.fromJson(json["outwardIssue"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "self": self,
        "type": type!.toJson(),
        "inwardIssue": inwardIssue == null ? null : inwardIssue!.toJson(),
        "outwardIssue": outwardIssue == null ? null : outwardIssue!.toJson(),
    };
}

class WardIssue {
    WardIssue({
        this.id,
        this.key,
        this.self,
        this.fields,
    });

    final String? id;
    final String? key;
    final String? self;
    final InwardIssueFields? fields;

    factory WardIssue.fromJson(Map<String, dynamic> json) => WardIssue(
        id: json["id"],
        key: json["key"],
        self: json["self"],
        fields: InwardIssueFields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "key": key,
        "self": self,
        "fields": fields!.toJson(),
    };
}

class InwardIssueFields {
    InwardIssueFields({
        this.summary,
        this.status,
        this.priority,
        this.issuetype,
    });

    final String? summary;
    final Status? status;
    final Component? priority;
    final Issuetype? issuetype;

    factory InwardIssueFields.fromJson(Map<String, dynamic> json) => InwardIssueFields(
        summary: json["summary"],
        status: Status.fromJson(json["status"]),
        priority: Component.fromJson(json["priority"]),
        issuetype: Issuetype.fromJson(json["issuetype"]),
    );

    Map<String, dynamic> toJson() => {
        "summary": summary,
        "status": status!.toJson(),
        "priority": priority!.toJson(),
        "issuetype": issuetype!.toJson(),
    };
}

class Issuetype {
    Issuetype({
        this.self,
        this.id,
        this.description,
        this.iconUrl,
        this.name,
        this.subtask,
        this.avatarId,
    });

    final String? self;
    final String? id;
    final String? description;
    final String? iconUrl;
    final IssuetypeName? name;
    final bool? subtask;
    final int? avatarId;

    factory Issuetype.fromJson(Map<String, dynamic> json) => Issuetype(
        self: json["self"],
        id: json["id"],
        description: json["description"],
        iconUrl: json["iconUrl"],
        name: issuetypeNameValues.map![json["name"]],
        subtask: json["subtask"],
        avatarId: json["avatarId"],
    );

    Map<String, dynamic> toJson() => {
        "self": self,
        "id": id,
        "description": description,
        "iconUrl": iconUrl,
        "name": issuetypeNameValues.reverse[name],
        "subtask": subtask,
        "avatarId": avatarId,
    };
}

enum IssuetypeName { BUG, SUGGESTION }

final issuetypeNameValues = EnumValues({
    "Bug": IssuetypeName.BUG,
    "Suggestion": IssuetypeName.SUGGESTION
});

class Status {
    Status({
        this.self,
        this.description,
        this.iconUrl,
        this.name,
        this.id,
        this.statusCategory,
    });

    final String? self;
    final String? description;
    final String? iconUrl;
    final StatusName? name;
    final String? id;
    final StatusCategory? statusCategory;

    factory Status.fromJson(Map<String, dynamic> json) => Status(
        self: json["self"],
        description: json["description"],
        iconUrl: json["iconUrl"],
        name: statusNameValues.map![json["name"]],
        id: json["id"],
        statusCategory: StatusCategory.fromJson(json["statusCategory"]),
    );

    Map<String, dynamic> toJson() => {
        "self": self,
        "description": description,
        "iconUrl": iconUrl,
        "name": statusNameValues.reverse[name],
        "id": id,
        "statusCategory": statusCategory!.toJson(),
    };
}

enum StatusName { CLOSED, GATHERING_IMPACT, NEEDS_TRIAGE, GATHERING_INTEREST, IN_REVIEW }

final statusNameValues = EnumValues({
    "Closed": StatusName.CLOSED,
    "Gathering Impact": StatusName.GATHERING_IMPACT,
    "Gathering Interest": StatusName.GATHERING_INTEREST,
    "In Review": StatusName.IN_REVIEW,
    "Needs Triage": StatusName.NEEDS_TRIAGE
});

class StatusCategory {
    StatusCategory({
        this.self,
        this.id,
        this.key,
        this.colorName,
        this.name,
    });

    final String? self;
    final int? id;
    final Key? key;
    final ColorName? colorName;
    final StatusCategoryName? name;

    factory StatusCategory.fromJson(Map<String, dynamic> json) => StatusCategory(
        self: json["self"],
        id: json["id"],
        key: keyValues.map![json["key"]],
        colorName: colorNameValues.map![json["colorName"]],
        name: statusCategoryNameValues.map![json["name"]],
    );

    Map<String, dynamic> toJson() => {
        "self": self,
        "id": id,
        "key": keyValues.reverse[key],
        "colorName": colorNameValues.reverse[colorName],
        "name": statusCategoryNameValues.reverse[name],
    };
}

enum ColorName { GREEN, BLUE_GRAY, YELLOW }

final colorNameValues = EnumValues({
    "blue-gray": ColorName.BLUE_GRAY,
    "green": ColorName.GREEN,
    "yellow": ColorName.YELLOW
});

enum Key { DONE, NEW, INDETERMINATE }

final keyValues = EnumValues({
    "done": Key.DONE,
    "indeterminate": Key.INDETERMINATE,
    "new": Key.NEW
});

enum StatusCategoryName { DONE, TO_DO, IN_PROGRESS }

final statusCategoryNameValues = EnumValues({
    "Done": StatusCategoryName.DONE,
    "In Progress": StatusCategoryName.IN_PROGRESS,
    "To Do": StatusCategoryName.TO_DO
});

class Type {
    Type({
        this.id,
        this.name,
        this.inward,
        this.outward,
        this.self,
    });

    final String? id;
    final String? name;
    final String? inward;
    final String? outward;
    final String? self;

    factory Type.fromJson(Map<String, dynamic> json) => Type(
        id: json["id"],
        name: json["name"],
        inward: json["inward"],
        outward: json["outward"],
        self: json["self"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "inward": inward,
        "outward": outward,
        "self": self,
    };
}

class Project {
    Project({
        this.self,
        this.id,
        this.key,
        this.name,
        this.projectTypeKey,
        this.avatarUrls,
        this.projectCategory,
    });

    final String? self;
    final String? id;
    final String? key;
    final String? name;
    final ProjectTypeKey? projectTypeKey;
    final AvatarUrls? avatarUrls;
    final Component? projectCategory;

    factory Project.fromJson(Map<String, dynamic> json) => Project(
        self: json["self"],
        id: json["id"],
        key: json["key"],
        name: json["name"],
        projectTypeKey: projectTypeKeyValues.map![json["projectTypeKey"]],
        avatarUrls: AvatarUrls.fromJson(json["avatarUrls"]),
        projectCategory: json["projectCategory"] == null ? null : Component.fromJson(json["projectCategory"]),
    );

    Map<String, dynamic> toJson() => {
        "self": self,
        "id": id,
        "key": key,
        "name": name,
        "projectTypeKey": projectTypeKeyValues.reverse[projectTypeKey],
        "avatarUrls": avatarUrls!.toJson(),
        "projectCategory": projectCategory == null ? null : projectCategory!.toJson(),
    };
}

enum ProjectTypeKey { SOFTWARE }

final projectTypeKeyValues = EnumValues({
    "software": ProjectTypeKey.SOFTWARE
});

class Version {
    Version({
        this.self,
        this.id,
        this.description,
        this.name,
        this.archived,
        this.released,
        this.releaseDate,
    });

    final String? self;
    final String? id;
    final String? description;
    final String? name;
    final bool? archived;
    final bool? released;
    final DateTime? releaseDate;

    factory Version.fromJson(Map<String, dynamic> json) => Version(
        self: json["self"],
        id: json["id"],
        description: json["description"] == null ? null : json["description"],
        name: json["name"],
        archived: json["archived"],
        released: json["released"],
        releaseDate: json["releaseDate"] == null ? null : DateTime.parse(json["releaseDate"]),
    );

    Map<String, dynamic> toJson() => {
        "self": self,
        "id": id,
        "description": description == null ? null : description,
        "name": name,
        "archived": archived,
        "released": released,
        "releaseDate": releaseDate == null ? null : "${releaseDate!.year.toString().padLeft(4, '0')}-${releaseDate!.month.toString().padLeft(2, '0')}-${releaseDate!.day.toString().padLeft(2, '0')}",
    };
}

class Votes {
    Votes({
        this.self,
        this.votes,
        this.hasVoted,
    });

    final String? self;
    final int? votes;
    final bool? hasVoted;

    factory Votes.fromJson(Map<String, dynamic> json) => Votes(
        self: json["self"],
        votes: json["votes"],
        hasVoted: json["hasVoted"],
    );

    Map<String, dynamic> toJson() => {
        "self": self,
        "votes": votes,
        "hasVoted": hasVoted,
    };
}

class Watches {
    Watches({
        this.self,
        this.watchCount,
        this.isWatching,
    });

    final String? self;
    final int? watchCount;
    final bool? isWatching;

    factory Watches.fromJson(Map<String, dynamic> json) => Watches(
        self: json["self"],
        watchCount: json["watchCount"],
        isWatching: json["isWatching"],
    );

    Map<String, dynamic> toJson() => {
        "self": self,
        "watchCount": watchCount,
        "isWatching": isWatching,
    };
}

class EnumValues<T> {
    Map<String, T>? map;
    Map<T, String>? reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map!.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap!;
    }
}
