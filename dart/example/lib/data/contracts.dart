// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
import 'package:leancode_contracts/leancode_contracts.dart';
import 'package:leancode_pipe/leancode_pipe.dart';
part 'contracts.g.dart';

@ContractsSerializable()
class Auth with EquatableMixin {
  Auth();

  factory Auth.fromJson(Map<String, dynamic> json) => _$AuthFromJson(json);

  List<Object?> get props => [];

  Map<String, dynamic> toJson() => _$AuthToJson(this);
}

@ContractsSerializable()
class Clients with EquatableMixin {
  Clients();

  factory Clients.fromJson(Map<String, dynamic> json) =>
      _$ClientsFromJson(json);

  static const String adminApp = 'admin_app';

  static const String clientApp = 'client_app';

  List<Object?> get props => [];

  Map<String, dynamic> toJson() => _$ClientsToJson(this);
}

@ContractsSerializable()
class KnownClaims with EquatableMixin {
  KnownClaims();

  factory KnownClaims.fromJson(Map<String, dynamic> json) =>
      _$KnownClaimsFromJson(json);

  static const String userId = 'sub';

  static const String role = 'role';

  List<Object?> get props => [];

  Map<String, dynamic> toJson() => _$KnownClaimsToJson(this);
}

@ContractsSerializable()
class Roles with EquatableMixin {
  Roles();

  factory Roles.fromJson(Map<String, dynamic> json) => _$RolesFromJson(json);

  static const String user = 'user';

  static const String admin = 'admin';

  List<Object?> get props => [];

  Map<String, dynamic> toJson() => _$RolesToJson(this);
}

@ContractsSerializable()
class Scopes with EquatableMixin {
  Scopes();

  factory Scopes.fromJson(Map<String, dynamic> json) => _$ScopesFromJson(json);

  static const String internalApi = 'internal_api';

  List<Object?> get props => [];

  Map<String, dynamic> toJson() => _$ScopesToJson(this);
}

/// LeanCode.Contracts.Security.AuthorizeWhenHasAnyOfAttribute('admin')
@ContractsSerializable()
class AllEmployees with EquatableMixin implements Query<List<EmployeeDTO>> {
  AllEmployees();

  factory AllEmployees.fromJson(Map<String, dynamic> json) =>
      _$AllEmployeesFromJson(json);

  List<Object?> get props => [];

  Map<String, dynamic> toJson() => _$AllEmployeesToJson(this);

  List<EmployeeDTO> resultFactory(dynamic decodedJson) =>
      (decodedJson as Iterable<dynamic>)
          .map((dynamic e) => _$EmployeeDTOFromJson(e as Map<String, dynamic>))
          .toList();

  String getFullName() => 'ExampleApp.Core.Contracts.Employees.AllEmployees';
}

/// LeanCode.Contracts.Security.AuthorizeWhenHasAnyOfAttribute('admin')
@ContractsSerializable()
class CreateEmployee with EquatableMixin implements Command {
  CreateEmployee({
    required this.name,
    required this.email,
  });

  factory CreateEmployee.fromJson(Map<String, dynamic> json) =>
      _$CreateEmployeeFromJson(json);

  final String name;

  final String email;

  List<Object?> get props => [name, email];

  Map<String, dynamic> toJson() => _$CreateEmployeeToJson(this);

  String getFullName() => 'ExampleApp.Core.Contracts.Employees.CreateEmployee';
}

class CreateEmployeeErrorCodes {
  static const nameCannotBeEmpty = 1;

  static const nameTooLong = 2;

  static const emailInvalid = 3;

  static const emailIsNotUnique = 4;
}

@ContractsSerializable()
class EmployeeDTO with EquatableMixin {
  EmployeeDTO({
    required this.id,
    required this.name,
    required this.email,
  });

  factory EmployeeDTO.fromJson(Map<String, dynamic> json) =>
      _$EmployeeDTOFromJson(json);

  final String id;

  final String name;

  final String email;

  List<Object?> get props => [id, name, email];

  Map<String, dynamic> toJson() => _$EmployeeDTOToJson(this);
}

/// LeanCode.Contracts.Security.AuthorizeWhenHasAnyOfAttribute('user')
@ContractsSerializable()
class AddNotificationToken with EquatableMixin implements Command {
  AddNotificationToken({required this.token});

  factory AddNotificationToken.fromJson(Map<String, dynamic> json) =>
      _$AddNotificationTokenFromJson(json);

  final String token;

  List<Object?> get props => [token];

  Map<String, dynamic> toJson() => _$AddNotificationTokenToJson(this);

  String getFullName() =>
      'ExampleApp.Core.Contracts.Firebase.AddNotificationToken';
}

class AddNotificationTokenErrorCodes {
  static const tokenCannotBeEmpty = 1;
}

/// LeanCode.Contracts.Security.AuthorizeWhenHasAnyOfAttribute('user')
@ContractsSerializable()
class RemoveNotificationToken with EquatableMixin implements Command {
  RemoveNotificationToken({required this.token});

  factory RemoveNotificationToken.fromJson(Map<String, dynamic> json) =>
      _$RemoveNotificationTokenFromJson(json);

  final String token;

  List<Object?> get props => [token];

  Map<String, dynamic> toJson() => _$RemoveNotificationTokenToJson(this);

  String getFullName() =>
      'ExampleApp.Core.Contracts.Firebase.RemoveNotificationToken';
}

class RemoveNotificationTokenErrorCodes {
  static const tokenCannotBeEmpty = 1;
}

/// LeanCode.Contracts.Security.AuthorizeWhenHasAnyOfAttribute('user')
@ContractsSerializable()
class SendCustomNotification with EquatableMixin implements Command {
  SendCustomNotification({
    required this.content,
    required this.imageUrl,
  });

  factory SendCustomNotification.fromJson(Map<String, dynamic> json) =>
      _$SendCustomNotificationFromJson(json);

  final String content;

  final Uri? imageUrl;

  List<Object?> get props => [content, imageUrl];

  Map<String, dynamic> toJson() => _$SendCustomNotificationToJson(this);

  String getFullName() =>
      'ExampleApp.Core.Contracts.Firebase.SendCustomNotification';
}

class SendCustomNotificationErrorCodes {
  static const contentCannotBeEmpty = 1;

  static const imageUrlInvalid = 2;
}

@ContractsSerializable()
class KratosIdentityDTO with EquatableMixin {
  KratosIdentityDTO({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.schemaId,
    required this.email,
  });

  factory KratosIdentityDTO.fromJson(Map<String, dynamic> json) =>
      _$KratosIdentityDTOFromJson(json);

  final String id;

  final DateTimeOffset createdAt;

  final DateTimeOffset updatedAt;

  final String schemaId;

  final String email;

  List<Object?> get props => [id, createdAt, updatedAt, schemaId, email];

  Map<String, dynamic> toJson() => _$KratosIdentityDTOToJson(this);
}

/// LeanCode.Contracts.Security.AuthorizeWhenHasAnyOfAttribute('admin')
@ContractsSerializable()
class SearchIdentities
    with EquatableMixin
    implements PaginatedQuery<KratosIdentityDTO> {
  SearchIdentities({
    required this.pageNumber,
    required this.pageSize,
    required this.schemaId,
    required this.emailPattern,
    required this.givenNamePattern,
    required this.familyNamePattern,
  });

  factory SearchIdentities.fromJson(Map<String, dynamic> json) =>
      _$SearchIdentitiesFromJson(json);

  /// Zero-based.
  final int pageNumber;

  final int pageSize;

  final String? schemaId;

  final String? emailPattern;

  final String? givenNamePattern;

  final String? familyNamePattern;

  List<Object?> get props => [
        pageNumber,
        pageSize,
        schemaId,
        emailPattern,
        givenNamePattern,
        familyNamePattern
      ];

  Map<String, dynamic> toJson() => _$SearchIdentitiesToJson(this);

  PaginatedResult<KratosIdentityDTO> resultFactory(dynamic decodedJson) =>
      _$PaginatedResultFromJson(decodedJson as Map<String, dynamic>,
          (e) => _$KratosIdentityDTOFromJson(e as Map<String, dynamic>));

  String getFullName() =>
      'ExampleApp.Core.Contracts.Identities.SearchIdentities';
}

abstract class PaginatedQuery<TResult>
    with EquatableMixin
    implements Query<PaginatedResult<TResult>> {
  PaginatedQuery({
    required this.pageNumber,
    required this.pageSize,
  });

  static const int minPageSize = 1;

  static const int maxPageSize = 100;

  /// Zero-based.
  final int pageNumber;

  final int pageSize;

  List<Object?> get props => [pageNumber, pageSize];
}

@ContractsSerializable(genericArgumentFactories: true)
class PaginatedResult<TResult> with EquatableMixin {
  PaginatedResult({
    required this.items,
    required this.totalCount,
  });

  factory PaginatedResult.fromJson(
    Map<String, dynamic> json,
    TResult Function(Object?) fromJsonTResult,
  ) =>
      _$PaginatedResultFromJson(json, fromJsonTResult);

  final List<TResult> items;

  final int totalCount;

  List<Object?> get props => [items, totalCount];
}

/// LeanCode.Contracts.Security.AllowUnauthorizedAttribute()
@ContractsSerializable()
class AddAssignmentsToProject with EquatableMixin implements Command {
  AddAssignmentsToProject({
    required this.projectId,
    required this.assignments,
  });

  factory AddAssignmentsToProject.fromJson(Map<String, dynamic> json) =>
      _$AddAssignmentsToProjectFromJson(json);

  final String projectId;

  final List<AssignmentWriteDTO> assignments;

  List<Object?> get props => [projectId, assignments];

  Map<String, dynamic> toJson() => _$AddAssignmentsToProjectToJson(this);

  String getFullName() =>
      'ExampleApp.Core.Contracts.Projects.AddAssignmentsToProject';
}

class AddAssignmentsToProjectErrorCodes {
  static const projectIdNotValid = 1;

  static const projectDoesNotExist = 2;

  static const assignmentsCannotBeNull = 3;

  static const assignmentsCannotBeEmpty = 4;
}

/// LeanCode.Contracts.Security.AllowUnauthorizedAttribute()
@ContractsSerializable()
class AllProjects with EquatableMixin implements Query<List<ProjectDTO>> {
  AllProjects({required this.sortByNameDescending});

  factory AllProjects.fromJson(Map<String, dynamic> json) =>
      _$AllProjectsFromJson(json);

  final bool sortByNameDescending;

  List<Object?> get props => [sortByNameDescending];

  Map<String, dynamic> toJson() => _$AllProjectsToJson(this);

  List<ProjectDTO> resultFactory(dynamic decodedJson) =>
      (decodedJson as Iterable<dynamic>)
          .map((dynamic e) => _$ProjectDTOFromJson(e as Map<String, dynamic>))
          .toList();

  String getFullName() => 'ExampleApp.Core.Contracts.Projects.AllProjects';
}

/// LeanCode.Contracts.Security.AuthorizeWhenHasAnyOfAttribute('admin')
@ContractsSerializable()
class AssignEmployeeToAssignment with EquatableMixin implements Command {
  AssignEmployeeToAssignment({
    required this.assignmentId,
    required this.employeeId,
  });

  factory AssignEmployeeToAssignment.fromJson(Map<String, dynamic> json) =>
      _$AssignEmployeeToAssignmentFromJson(json);

  final String assignmentId;

  final String employeeId;

  List<Object?> get props => [assignmentId, employeeId];

  Map<String, dynamic> toJson() => _$AssignEmployeeToAssignmentToJson(this);

  String getFullName() =>
      'ExampleApp.Core.Contracts.Projects.AssignEmployeeToAssignment';
}

class AssignEmployeeToAssignmentErrorCodes {
  static const assignmentIdNotValid = 1;

  static const projectWithAssignmentDoesNotExist = 2;

  static const employeeIdNotValid = 3;

  static const employeeDoesNotExist = 4;
}

@ContractsSerializable()
class AssignmentDTO with EquatableMixin implements AssignmentWriteDTO {
  AssignmentDTO({
    required this.name,
    required this.id,
  });

  factory AssignmentDTO.fromJson(Map<String, dynamic> json) =>
      _$AssignmentDTOFromJson(json);

  final String name;

  final String id;

  List<Object?> get props => [name, id];

  Map<String, dynamic> toJson() => _$AssignmentDTOToJson(this);
}

@ContractsSerializable()
class AssignmentWriteDTO with EquatableMixin {
  AssignmentWriteDTO({required this.name});

  factory AssignmentWriteDTO.fromJson(Map<String, dynamic> json) =>
      _$AssignmentWriteDTOFromJson(json);

  final String name;

  List<Object?> get props => [name];

  Map<String, dynamic> toJson() => _$AssignmentWriteDTOToJson(this);
}

/// LeanCode.Contracts.Security.AllowUnauthorizedAttribute()
@ContractsSerializable()
class CreateProject with EquatableMixin implements Command {
  CreateProject({required this.name});

  factory CreateProject.fromJson(Map<String, dynamic> json) =>
      _$CreateProjectFromJson(json);

  final String name;

  List<Object?> get props => [name];

  Map<String, dynamic> toJson() => _$CreateProjectToJson(this);

  String getFullName() => 'ExampleApp.Core.Contracts.Projects.CreateProject';
}

class CreateProjectErrorCodes {
  static const nameCannotBeEmpty = 1;

  static const nameTooLong = 2;
}

@ContractsSerializable()
class EmployeeAssignedToAssignmentDTO
    with EquatableMixin
    implements ProjectEmployeesAssignmentsTopicNotification {
  EmployeeAssignedToAssignmentDTO({
    required this.assignmentId,
    required this.employeeId,
  });

  factory EmployeeAssignedToAssignmentDTO.fromJson(Map<String, dynamic> json) =>
      _$EmployeeAssignedToAssignmentDTOFromJson(json);

  final String assignmentId;

  final String employeeId;

  List<Object?> get props => [assignmentId, employeeId];

  Map<String, dynamic> toJson() =>
      _$EmployeeAssignedToAssignmentDTOToJson(this);
}

@ContractsSerializable()
class EmployeeAssignedToProjectAssignmentDTO
    with EquatableMixin
    implements EmployeeAssignmentsTopicNotification {
  EmployeeAssignedToProjectAssignmentDTO({
    required this.projectId,
    required this.assignmentId,
  });

  factory EmployeeAssignedToProjectAssignmentDTO.fromJson(
          Map<String, dynamic> json) =>
      _$EmployeeAssignedToProjectAssignmentDTOFromJson(json);

  final String projectId;

  final String assignmentId;

  List<Object?> get props => [projectId, assignmentId];

  Map<String, dynamic> toJson() =>
      _$EmployeeAssignedToProjectAssignmentDTOToJson(this);
}

@ContractsSerializable()
class EmployeeAssignmentsTopic
    with EquatableMixin
    implements Topic<EmployeeAssignmentsTopicNotification> {
  EmployeeAssignmentsTopic({required this.employeeId});

  factory EmployeeAssignmentsTopic.fromJson(Map<String, dynamic> json) =>
      _$EmployeeAssignmentsTopicFromJson(json);

  final String employeeId;

  List<Object?> get props => [employeeId];

  Map<String, dynamic> toJson() => _$EmployeeAssignmentsTopicToJson(this);

  EmployeeAssignmentsTopicNotification? castNotification(
    String tag,
    dynamic json,
  ) =>
      switch (tag) {
        'ExampleApp.Core.Contracts.Projects.EmployeeAssignedToProjectAssignmentDTO' =>
          _$EmployeeAssignedToProjectAssignmentDTOFromJson(
              json as Map<String, dynamic>),
        'ExampleApp.Core.Contracts.Projects.EmployeeUnassignedFromProjectAssignmentDTO' =>
          _$EmployeeUnassignedFromProjectAssignmentDTOFromJson(
              json as Map<String, dynamic>),
        _ => null
      } as EmployeeAssignmentsTopicNotification?;

  EmployeeAssignmentsTopic fromJson(Map<String, dynamic> json) =>
      EmployeeAssignmentsTopic.fromJson(json);

  String getFullName() =>
      'ExampleApp.Core.Contracts.Projects.EmployeeAssignmentsTopic';
}

sealed class EmployeeAssignmentsTopicNotification {}

@ContractsSerializable()
class EmployeeUnassignedFromAssignmentDTO
    with EquatableMixin
    implements ProjectEmployeesAssignmentsTopicNotification {
  EmployeeUnassignedFromAssignmentDTO({required this.assignmentId});

  factory EmployeeUnassignedFromAssignmentDTO.fromJson(
          Map<String, dynamic> json) =>
      _$EmployeeUnassignedFromAssignmentDTOFromJson(json);

  final String assignmentId;

  List<Object?> get props => [assignmentId];

  Map<String, dynamic> toJson() =>
      _$EmployeeUnassignedFromAssignmentDTOToJson(this);
}

@ContractsSerializable()
class EmployeeUnassignedFromProjectAssignmentDTO
    with EquatableMixin
    implements EmployeeAssignmentsTopicNotification {
  EmployeeUnassignedFromProjectAssignmentDTO({
    required this.projectId,
    required this.assignmentId,
  });

  factory EmployeeUnassignedFromProjectAssignmentDTO.fromJson(
          Map<String, dynamic> json) =>
      _$EmployeeUnassignedFromProjectAssignmentDTOFromJson(json);

  final String projectId;

  final String assignmentId;

  List<Object?> get props => [projectId, assignmentId];

  Map<String, dynamic> toJson() =>
      _$EmployeeUnassignedFromProjectAssignmentDTOToJson(this);
}

@ContractsSerializable()
class ProjectDTO with EquatableMixin {
  ProjectDTO({
    required this.id,
    required this.name,
  });

  factory ProjectDTO.fromJson(Map<String, dynamic> json) =>
      _$ProjectDTOFromJson(json);

  final String id;

  final String name;

  List<Object?> get props => [id, name];

  Map<String, dynamic> toJson() => _$ProjectDTOToJson(this);
}

/// LeanCode.Contracts.Security.AllowUnauthorizedAttribute()
@ContractsSerializable()
class ProjectDetails with EquatableMixin implements Query<ProjectDetailsDTO?> {
  ProjectDetails({required this.id});

  factory ProjectDetails.fromJson(Map<String, dynamic> json) =>
      _$ProjectDetailsFromJson(json);

  final String id;

  List<Object?> get props => [id];

  Map<String, dynamic> toJson() => _$ProjectDetailsToJson(this);

  ProjectDetailsDTO? resultFactory(dynamic decodedJson) => decodedJson == null
      ? null
      : _$ProjectDetailsDTOFromJson(decodedJson as Map<String, dynamic>);

  String getFullName() => 'ExampleApp.Core.Contracts.Projects.ProjectDetails';
}

@ContractsSerializable()
class ProjectDetailsDTO with EquatableMixin implements ProjectDTO {
  ProjectDetailsDTO({
    required this.id,
    required this.name,
    required this.assignments,
  });

  factory ProjectDetailsDTO.fromJson(Map<String, dynamic> json) =>
      _$ProjectDetailsDTOFromJson(json);

  final String id;

  final String name;

  final List<AssignmentDTO> assignments;

  List<Object?> get props => [id, name, assignments];

  Map<String, dynamic> toJson() => _$ProjectDetailsDTOToJson(this);
}

/// LeanCode.Contracts.Security.AuthorizeWhenHasAnyOfAttribute('admin')
@ContractsSerializable()
class ProjectEmployeesAssignmentsTopic
    with EquatableMixin
    implements Topic<ProjectEmployeesAssignmentsTopicNotification> {
  ProjectEmployeesAssignmentsTopic({required this.projectId});

  factory ProjectEmployeesAssignmentsTopic.fromJson(
          Map<String, dynamic> json) =>
      _$ProjectEmployeesAssignmentsTopicFromJson(json);

  final String projectId;

  List<Object?> get props => [projectId];

  Map<String, dynamic> toJson() =>
      _$ProjectEmployeesAssignmentsTopicToJson(this);

  ProjectEmployeesAssignmentsTopicNotification? castNotification(
    String tag,
    dynamic json,
  ) =>
      switch (tag) {
        'ExampleApp.Core.Contracts.Projects.EmployeeAssignedToAssignmentDTO' =>
          _$EmployeeAssignedToAssignmentDTOFromJson(
              json as Map<String, dynamic>),
        'ExampleApp.Core.Contracts.Projects.EmployeeUnassignedFromAssignmentDTO' =>
          _$EmployeeUnassignedFromAssignmentDTOFromJson(
              json as Map<String, dynamic>),
        _ => null
      } as ProjectEmployeesAssignmentsTopicNotification?;

  ProjectEmployeesAssignmentsTopic fromJson(Map<String, dynamic> json) =>
      ProjectEmployeesAssignmentsTopic.fromJson(json);

  String getFullName() =>
      'ExampleApp.Core.Contracts.Projects.ProjectEmployeesAssignmentsTopic';
}

sealed class ProjectEmployeesAssignmentsTopicNotification {}

/// LeanCode.Contracts.Security.AuthorizeWhenHasAnyOfAttribute('admin')
@ContractsSerializable()
class UnassignEmployeeFromAssignment with EquatableMixin implements Command {
  UnassignEmployeeFromAssignment({required this.assignmentId});

  factory UnassignEmployeeFromAssignment.fromJson(Map<String, dynamic> json) =>
      _$UnassignEmployeeFromAssignmentFromJson(json);

  final String assignmentId;

  List<Object?> get props => [assignmentId];

  Map<String, dynamic> toJson() => _$UnassignEmployeeFromAssignmentToJson(this);

  String getFullName() =>
      'ExampleApp.Core.Contracts.Projects.UnassignEmployeeFromAssignment';
}

class UnassignEmployeeFromAssignmentErrorCodes {
  static const assignmentIdNotValid = 1;

  static const projectWithAssignmentDoesNotExist = 2;
}

abstract class SortedQuery<TResult, TSort>
    with EquatableMixin
    implements PaginatedQuery<TResult> {
  SortedQuery({
    required this.pageNumber,
    required this.pageSize,
    required this.sortBy,
    required this.sortByDescending,
  });

  /// Zero-based.
  final int pageNumber;

  final int pageSize;

  final TSort sortBy;

  final bool sortByDescending;

  List<Object?> get props => [pageNumber, pageSize, sortBy, sortByDescending];
}

enum PlatformDTO {
  @JsonValue(0)
  android,
  @JsonValue(1)
  ios
}

@ContractsSerializable()
class VersionSupport with EquatableMixin implements Query<VersionSupportDTO> {
  VersionSupport({
    required this.platform,
    required this.version,
  });

  factory VersionSupport.fromJson(Map<String, dynamic> json) =>
      _$VersionSupportFromJson(json);

  final PlatformDTO platform;

  final String version;

  List<Object?> get props => [platform, version];

  Map<String, dynamic> toJson() => _$VersionSupportToJson(this);

  VersionSupportDTO resultFactory(dynamic decodedJson) =>
      _$VersionSupportDTOFromJson(decodedJson as Map<String, dynamic>);

  String getFullName() => 'LeanCode.ForceUpdate.Contracts.VersionSupport';
}

@ContractsSerializable()
class VersionSupportDTO with EquatableMixin {
  VersionSupportDTO({
    required this.currentlySupportedVersion,
    required this.minimumRequiredVersion,
    required this.result,
  });

  factory VersionSupportDTO.fromJson(Map<String, dynamic> json) =>
      _$VersionSupportDTOFromJson(json);

  final String currentlySupportedVersion;

  final String minimumRequiredVersion;

  final VersionSupportResultDTO result;

  List<Object?> get props =>
      [currentlySupportedVersion, minimumRequiredVersion, result];

  Map<String, dynamic> toJson() => _$VersionSupportDTOToJson(this);
}

enum VersionSupportResultDTO {
  @JsonValue(0)
  updateRequired,
  @JsonValue(1)
  updateSuggested,
  @JsonValue(2)
  upToDate
}
