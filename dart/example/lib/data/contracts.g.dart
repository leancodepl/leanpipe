// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contracts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Auth _$AuthFromJson(Map<String, dynamic> json) => Auth();

Map<String, dynamic> _$AuthToJson(Auth instance) => <String, dynamic>{};

Clients _$ClientsFromJson(Map<String, dynamic> json) => Clients();

Map<String, dynamic> _$ClientsToJson(Clients instance) => <String, dynamic>{};

KnownClaims _$KnownClaimsFromJson(Map<String, dynamic> json) => KnownClaims();

Map<String, dynamic> _$KnownClaimsToJson(KnownClaims instance) =>
    <String, dynamic>{};

Roles _$RolesFromJson(Map<String, dynamic> json) => Roles();

Map<String, dynamic> _$RolesToJson(Roles instance) => <String, dynamic>{};

Scopes _$ScopesFromJson(Map<String, dynamic> json) => Scopes();

Map<String, dynamic> _$ScopesToJson(Scopes instance) => <String, dynamic>{};

AllEmployees _$AllEmployeesFromJson(Map<String, dynamic> json) =>
    AllEmployees();

Map<String, dynamic> _$AllEmployeesToJson(AllEmployees instance) =>
    <String, dynamic>{};

CreateEmployee _$CreateEmployeeFromJson(Map<String, dynamic> json) =>
    CreateEmployee(
      name: json['Name'] as String,
      email: json['Email'] as String,
    );

Map<String, dynamic> _$CreateEmployeeToJson(CreateEmployee instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Email': instance.email,
    };

EmployeeDTO _$EmployeeDTOFromJson(Map<String, dynamic> json) => EmployeeDTO(
      id: json['Id'] as String,
      name: json['Name'] as String,
      email: json['Email'] as String,
    );

Map<String, dynamic> _$EmployeeDTOToJson(EmployeeDTO instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'Email': instance.email,
    };

AddNotificationToken _$AddNotificationTokenFromJson(
        Map<String, dynamic> json) =>
    AddNotificationToken(
      token: json['Token'] as String,
    );

Map<String, dynamic> _$AddNotificationTokenToJson(
        AddNotificationToken instance) =>
    <String, dynamic>{
      'Token': instance.token,
    };

RemoveNotificationToken _$RemoveNotificationTokenFromJson(
        Map<String, dynamic> json) =>
    RemoveNotificationToken(
      token: json['Token'] as String,
    );

Map<String, dynamic> _$RemoveNotificationTokenToJson(
        RemoveNotificationToken instance) =>
    <String, dynamic>{
      'Token': instance.token,
    };

SendCustomNotification _$SendCustomNotificationFromJson(
        Map<String, dynamic> json) =>
    SendCustomNotification(
      content: json['Content'] as String,
      imageUrl: json['ImageUrl'] == null
          ? null
          : Uri.parse(json['ImageUrl'] as String),
    );

Map<String, dynamic> _$SendCustomNotificationToJson(
        SendCustomNotification instance) =>
    <String, dynamic>{
      'Content': instance.content,
      'ImageUrl': instance.imageUrl?.toString(),
    };

KratosIdentityDTO _$KratosIdentityDTOFromJson(Map<String, dynamic> json) =>
    KratosIdentityDTO(
      id: json['Id'] as String,
      createdAt: DateTimeOffset.fromJson(json['CreatedAt'] as String),
      updatedAt: DateTimeOffset.fromJson(json['UpdatedAt'] as String),
      schemaId: json['SchemaId'] as String,
      email: json['Email'] as String,
    );

Map<String, dynamic> _$KratosIdentityDTOToJson(KratosIdentityDTO instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'CreatedAt': instance.createdAt,
      'UpdatedAt': instance.updatedAt,
      'SchemaId': instance.schemaId,
      'Email': instance.email,
    };

SearchIdentities _$SearchIdentitiesFromJson(Map<String, dynamic> json) =>
    SearchIdentities(
      pageNumber: json['PageNumber'] as int,
      pageSize: json['PageSize'] as int,
      schemaId: json['SchemaId'] as String?,
      emailPattern: json['EmailPattern'] as String?,
      givenNamePattern: json['GivenNamePattern'] as String?,
      familyNamePattern: json['FamilyNamePattern'] as String?,
    );

Map<String, dynamic> _$SearchIdentitiesToJson(SearchIdentities instance) =>
    <String, dynamic>{
      'PageNumber': instance.pageNumber,
      'PageSize': instance.pageSize,
      'SchemaId': instance.schemaId,
      'EmailPattern': instance.emailPattern,
      'GivenNamePattern': instance.givenNamePattern,
      'FamilyNamePattern': instance.familyNamePattern,
    };

PaginatedResult<TResult> _$PaginatedResultFromJson<TResult>(
  Map<String, dynamic> json,
  TResult Function(Object? json) fromJsonTResult,
) =>
    PaginatedResult<TResult>(
      items: (json['Items'] as List<dynamic>).map(fromJsonTResult).toList(),
      totalCount: json['TotalCount'] as int,
    );

Map<String, dynamic> _$PaginatedResultToJson<TResult>(
  PaginatedResult<TResult> instance,
  Object? Function(TResult value) toJsonTResult,
) =>
    <String, dynamic>{
      'Items': instance.items.map(toJsonTResult).toList(),
      'TotalCount': instance.totalCount,
    };

AddAssignmentsToProject _$AddAssignmentsToProjectFromJson(
        Map<String, dynamic> json) =>
    AddAssignmentsToProject(
      projectId: json['ProjectId'] as String,
      assignments: (json['Assignments'] as List<dynamic>)
          .map((e) => AssignmentWriteDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AddAssignmentsToProjectToJson(
        AddAssignmentsToProject instance) =>
    <String, dynamic>{
      'ProjectId': instance.projectId,
      'Assignments': instance.assignments,
    };

AllProjects _$AllProjectsFromJson(Map<String, dynamic> json) => AllProjects(
      sortByNameDescending: json['SortByNameDescending'] as bool,
    );

Map<String, dynamic> _$AllProjectsToJson(AllProjects instance) =>
    <String, dynamic>{
      'SortByNameDescending': instance.sortByNameDescending,
    };

AssignEmployeeToAssignment _$AssignEmployeeToAssignmentFromJson(
        Map<String, dynamic> json) =>
    AssignEmployeeToAssignment(
      assignmentId: json['AssignmentId'] as String,
      employeeId: json['EmployeeId'] as String,
    );

Map<String, dynamic> _$AssignEmployeeToAssignmentToJson(
        AssignEmployeeToAssignment instance) =>
    <String, dynamic>{
      'AssignmentId': instance.assignmentId,
      'EmployeeId': instance.employeeId,
    };

AssignmentDTO _$AssignmentDTOFromJson(Map<String, dynamic> json) =>
    AssignmentDTO(
      name: json['Name'] as String,
      id: json['Id'] as String,
    );

Map<String, dynamic> _$AssignmentDTOToJson(AssignmentDTO instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Id': instance.id,
    };

AssignmentWriteDTO _$AssignmentWriteDTOFromJson(Map<String, dynamic> json) =>
    AssignmentWriteDTO(
      name: json['Name'] as String,
    );

Map<String, dynamic> _$AssignmentWriteDTOToJson(AssignmentWriteDTO instance) =>
    <String, dynamic>{
      'Name': instance.name,
    };

CreateProject _$CreateProjectFromJson(Map<String, dynamic> json) =>
    CreateProject(
      name: json['Name'] as String,
    );

Map<String, dynamic> _$CreateProjectToJson(CreateProject instance) =>
    <String, dynamic>{
      'Name': instance.name,
    };

EmployeeAssignedToAssignmentDTO _$EmployeeAssignedToAssignmentDTOFromJson(
        Map<String, dynamic> json) =>
    EmployeeAssignedToAssignmentDTO(
      assignmentId: json['AssignmentId'] as String,
      employeeId: json['EmployeeId'] as String,
    );

Map<String, dynamic> _$EmployeeAssignedToAssignmentDTOToJson(
        EmployeeAssignedToAssignmentDTO instance) =>
    <String, dynamic>{
      'AssignmentId': instance.assignmentId,
      'EmployeeId': instance.employeeId,
    };

EmployeeAssignedToProjectAssignmentDTO
    _$EmployeeAssignedToProjectAssignmentDTOFromJson(
            Map<String, dynamic> json) =>
        EmployeeAssignedToProjectAssignmentDTO(
          projectId: json['ProjectId'] as String,
          assignmentId: json['AssignmentId'] as String,
        );

Map<String, dynamic> _$EmployeeAssignedToProjectAssignmentDTOToJson(
        EmployeeAssignedToProjectAssignmentDTO instance) =>
    <String, dynamic>{
      'ProjectId': instance.projectId,
      'AssignmentId': instance.assignmentId,
    };

EmployeeAssignmentsTopic _$EmployeeAssignmentsTopicFromJson(
        Map<String, dynamic> json) =>
    EmployeeAssignmentsTopic(
      employeeId: json['EmployeeId'] as String,
    );

Map<String, dynamic> _$EmployeeAssignmentsTopicToJson(
        EmployeeAssignmentsTopic instance) =>
    <String, dynamic>{
      'EmployeeId': instance.employeeId,
    };

EmployeeUnassignedFromAssignmentDTO
    _$EmployeeUnassignedFromAssignmentDTOFromJson(Map<String, dynamic> json) =>
        EmployeeUnassignedFromAssignmentDTO(
          assignmentId: json['AssignmentId'] as String,
        );

Map<String, dynamic> _$EmployeeUnassignedFromAssignmentDTOToJson(
        EmployeeUnassignedFromAssignmentDTO instance) =>
    <String, dynamic>{
      'AssignmentId': instance.assignmentId,
    };

EmployeeUnassignedFromProjectAssignmentDTO
    _$EmployeeUnassignedFromProjectAssignmentDTOFromJson(
            Map<String, dynamic> json) =>
        EmployeeUnassignedFromProjectAssignmentDTO(
          projectId: json['ProjectId'] as String,
          assignmentId: json['AssignmentId'] as String,
        );

Map<String, dynamic> _$EmployeeUnassignedFromProjectAssignmentDTOToJson(
        EmployeeUnassignedFromProjectAssignmentDTO instance) =>
    <String, dynamic>{
      'ProjectId': instance.projectId,
      'AssignmentId': instance.assignmentId,
    };

ProjectDTO _$ProjectDTOFromJson(Map<String, dynamic> json) => ProjectDTO(
      id: json['Id'] as String,
      name: json['Name'] as String,
    );

Map<String, dynamic> _$ProjectDTOToJson(ProjectDTO instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
    };

ProjectDetails _$ProjectDetailsFromJson(Map<String, dynamic> json) =>
    ProjectDetails(
      id: json['Id'] as String,
    );

Map<String, dynamic> _$ProjectDetailsToJson(ProjectDetails instance) =>
    <String, dynamic>{
      'Id': instance.id,
    };

ProjectDetailsDTO _$ProjectDetailsDTOFromJson(Map<String, dynamic> json) =>
    ProjectDetailsDTO(
      id: json['Id'] as String,
      name: json['Name'] as String,
      assignments: (json['Assignments'] as List<dynamic>)
          .map((e) => AssignmentDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProjectDetailsDTOToJson(ProjectDetailsDTO instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'Assignments': instance.assignments,
    };

ProjectEmployeesAssignmentsTopic _$ProjectEmployeesAssignmentsTopicFromJson(
        Map<String, dynamic> json) =>
    ProjectEmployeesAssignmentsTopic(
      projectId: json['ProjectId'] as String,
    );

Map<String, dynamic> _$ProjectEmployeesAssignmentsTopicToJson(
        ProjectEmployeesAssignmentsTopic instance) =>
    <String, dynamic>{
      'ProjectId': instance.projectId,
    };

UnassignEmployeeFromAssignment _$UnassignEmployeeFromAssignmentFromJson(
        Map<String, dynamic> json) =>
    UnassignEmployeeFromAssignment(
      assignmentId: json['AssignmentId'] as String,
    );

Map<String, dynamic> _$UnassignEmployeeFromAssignmentToJson(
        UnassignEmployeeFromAssignment instance) =>
    <String, dynamic>{
      'AssignmentId': instance.assignmentId,
    };

VersionSupport _$VersionSupportFromJson(Map<String, dynamic> json) =>
    VersionSupport(
      platform: $enumDecode(_$PlatformDTOEnumMap, json['Platform']),
      version: json['Version'] as String,
    );

Map<String, dynamic> _$VersionSupportToJson(VersionSupport instance) =>
    <String, dynamic>{
      'Platform': _$PlatformDTOEnumMap[instance.platform]!,
      'Version': instance.version,
    };

const _$PlatformDTOEnumMap = {
  PlatformDTO.android: 0,
  PlatformDTO.ios: 1,
};

VersionSupportDTO _$VersionSupportDTOFromJson(Map<String, dynamic> json) =>
    VersionSupportDTO(
      currentlySupportedVersion: json['CurrentlySupportedVersion'] as String,
      minimumRequiredVersion: json['MinimumRequiredVersion'] as String,
      result: $enumDecode(_$VersionSupportResultDTOEnumMap, json['Result']),
    );

Map<String, dynamic> _$VersionSupportDTOToJson(VersionSupportDTO instance) =>
    <String, dynamic>{
      'CurrentlySupportedVersion': instance.currentlySupportedVersion,
      'MinimumRequiredVersion': instance.minimumRequiredVersion,
      'Result': _$VersionSupportResultDTOEnumMap[instance.result]!,
    };

const _$VersionSupportResultDTOEnumMap = {
  VersionSupportResultDTO.updateRequired: 0,
  VersionSupportResultDTO.updateSuggested: 1,
  VersionSupportResultDTO.upToDate: 2,
};
