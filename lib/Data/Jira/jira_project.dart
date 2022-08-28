// To parse this JSON data, do
//
//     final jiraProject = jiraProjectFromJson(jsonString);

import 'dart:convert';

List<JiraProject> jiraProjectFromJson(String str) => List<JiraProject>.from(json.decode(str).map((x) => JiraProject.fromJson(x)));

String jiraProjectToJson(List<JiraProject> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class JiraProject {
    JiraProject({
        this.expand,
        this.self,
        this.id,
        this.key,
        this.name,
        this.avatarUrls,
        this.projectCategory,
        this.projectTypeKey,
        this.archived,
    });

    Expand? expand;
    String? self;
    String? id;
    String? key;
    String? name;
    AvatarUrls? avatarUrls;
    ProjectCategory? projectCategory;
    ProjectTypeKey? projectTypeKey;
    bool? archived;

    factory JiraProject.fromJson(Map<String, dynamic> json) => JiraProject(
        expand: expandValues.map![json["expand"]],
        self: json["self"],
        id: json["id"],
        key: json["key"],
        name: json["name"],
        avatarUrls: AvatarUrls.fromJson(json["avatarUrls"]),
        projectCategory: json["projectCategory"] == null ? null : ProjectCategory.fromJson(json["projectCategory"]),
        projectTypeKey: projectTypeKeyValues.map![json["projectTypeKey"]],
        archived: json["archived"],
    );

    Map<String, dynamic> toJson() => {
        "expand": expandValues.reverse[expand],
        "self": self,
        "id": id,
        "key": key,
        "name": name,
        "avatarUrls": avatarUrls!.toJson(),
        "projectCategory": projectCategory == null ? null : projectCategory!.toJson(),
        "projectTypeKey": projectTypeKeyValues.reverse[projectTypeKey],
        "archived": archived,
    };
}

class AvatarUrls {
    AvatarUrls({
        this.the48X48,
        this.the24X24,
        this.the16X16,
        this.the32X32,
    });

    String? the48X48;
    String? the24X24;
    String? the16X16;
    String? the32X32;

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

enum Expand { DESCRIPTION_LEAD_URL_PROJECT_KEYS }

final expandValues = EnumValues({
    "description,lead,url,projectKeys": Expand.DESCRIPTION_LEAD_URL_PROJECT_KEYS
});

class ProjectCategory {
    ProjectCategory({
        this.self,
        this.id,
        this.name,
        this.description,
    });

    String? self;
    String? id;
    Name? name;
    Description? description;

    factory ProjectCategory.fromJson(Map<String, dynamic> json) => ProjectCategory(
        self: json["self"],
        id: json["id"],
        name: nameValues.map![json["name"]],
        description: descriptionValues.map![json["description"]],
    );

    Map<String, dynamic> toJson() => {
        "self": self,
        "id": id,
        "name": nameValues.reverse[name],
        "description": descriptionValues.reverse[description],
    };
}

enum Description { EMPTY, SET_OF_COMMON_LIBRARIES_USED_BY_MULTIPLE_ATLASSIAN_PRODUCTS }

final descriptionValues = EnumValues({
    "": Description.EMPTY,
    "Set of common libraries used by multiple Atlassian products": Description.SET_OF_COMMON_LIBRARIES_USED_BY_MULTIPLE_ATLASSIAN_PRODUCTS
});

enum Name { ATLASSIAN_ADD_ONS, ATLASSIAN_PRODUCTS, COMMON_MODULES}

final nameValues = EnumValues({
    "Atlassian Add-ons": Name.ATLASSIAN_ADD_ONS,
    "Atlassian Products": Name.ATLASSIAN_PRODUCTS,
    "Common Modules": Name.COMMON_MODULES
});

enum ProjectTypeKey { SOFTWARE }

final projectTypeKeyValues = EnumValues({
    "software": ProjectTypeKey.SOFTWARE
});

class EnumValues<T> {
    Map<String, T>? map;
    Map<T, String>? reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map!.map((k, v) => MapEntry(v, k));
        }
        return reverseMap!;
    }
}
