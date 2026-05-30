// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scroll_session.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetScrollSessionCollection on Isar {
  IsarCollection<ScrollSession> get scrollSessions => this.collection();
}

const ScrollSessionSchema = CollectionSchema(
  name: r'ScrollSession',
  id: -2353229970039318333,
  properties: {
    r'appPackageName': PropertySchema(
      id: 0,
      name: r'appPackageName',
      type: IsarType.string,
    ),
    r'avgDrs': PropertySchema(
      id: 1,
      name: r'avgDrs',
      type: IsarType.double,
    ),
    r'completedCognitiveBump': PropertySchema(
      id: 2,
      name: r'completedCognitiveBump',
      type: IsarType.bool,
    ),
    r'endTime': PropertySchema(
      id: 3,
      name: r'endTime',
      type: IsarType.dateTime,
    ),
    r'isEvaded': PropertySchema(
      id: 4,
      name: r'isEvaded',
      type: IsarType.bool,
    ),
    r'peakDrs': PropertySchema(
      id: 5,
      name: r'peakDrs',
      type: IsarType.double,
    ),
    r'startTime': PropertySchema(
      id: 6,
      name: r'startTime',
      type: IsarType.dateTime,
    ),
    r'swipeCount': PropertySchema(
      id: 7,
      name: r'swipeCount',
      type: IsarType.long,
    ),
    r'tapCount': PropertySchema(
      id: 8,
      name: r'tapCount',
      type: IsarType.long,
    )
  },
  estimateSize: _scrollSessionEstimateSize,
  serialize: _scrollSessionSerialize,
  deserialize: _scrollSessionDeserialize,
  deserializeProp: _scrollSessionDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _scrollSessionGetId,
  getLinks: _scrollSessionGetLinks,
  attach: _scrollSessionAttach,
  version: '3.3.2',
);

int _scrollSessionEstimateSize(
  ScrollSession object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.appPackageName.length * 3;
  return bytesCount;
}

void _scrollSessionSerialize(
  ScrollSession object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.appPackageName);
  writer.writeDouble(offsets[1], object.avgDrs);
  writer.writeBool(offsets[2], object.completedCognitiveBump);
  writer.writeDateTime(offsets[3], object.endTime);
  writer.writeBool(offsets[4], object.isEvaded);
  writer.writeDouble(offsets[5], object.peakDrs);
  writer.writeDateTime(offsets[6], object.startTime);
  writer.writeLong(offsets[7], object.swipeCount);
  writer.writeLong(offsets[8], object.tapCount);
}

ScrollSession _scrollSessionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ScrollSession(
    appPackageName: reader.readString(offsets[0]),
    avgDrs: reader.readDouble(offsets[1]),
    completedCognitiveBump: reader.readBoolOrNull(offsets[2]) ?? false,
    endTime: reader.readDateTime(offsets[3]),
    id: id,
    isEvaded: reader.readBoolOrNull(offsets[4]) ?? false,
    peakDrs: reader.readDouble(offsets[5]),
    startTime: reader.readDateTime(offsets[6]),
    swipeCount: reader.readLong(offsets[7]),
    tapCount: reader.readLong(offsets[8]),
  );
  return object;
}

P _scrollSessionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _scrollSessionGetId(ScrollSession object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _scrollSessionGetLinks(ScrollSession object) {
  return [];
}

void _scrollSessionAttach(
    IsarCollection<dynamic> col, Id id, ScrollSession object) {
  object.id = id;
}

extension ScrollSessionQueryWhereSort
    on QueryBuilder<ScrollSession, ScrollSession, QWhere> {
  QueryBuilder<ScrollSession, ScrollSession, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ScrollSessionQueryWhere
    on QueryBuilder<ScrollSession, ScrollSession, QWhereClause> {
  QueryBuilder<ScrollSession, ScrollSession, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ScrollSessionQueryFilter
    on QueryBuilder<ScrollSession, ScrollSession, QFilterCondition> {
  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      appPackageNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appPackageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      appPackageNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'appPackageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      appPackageNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'appPackageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      appPackageNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'appPackageName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      appPackageNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'appPackageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      appPackageNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'appPackageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      appPackageNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'appPackageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      appPackageNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'appPackageName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      appPackageNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appPackageName',
        value: '',
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      appPackageNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'appPackageName',
        value: '',
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      avgDrsEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avgDrs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      avgDrsGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'avgDrs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      avgDrsLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'avgDrs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      avgDrsBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'avgDrs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      completedCognitiveBumpEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedCognitiveBump',
        value: value,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      endTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      endTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      endTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      endTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      isEvadedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isEvaded',
        value: value,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      peakDrsEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'peakDrs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      peakDrsGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'peakDrs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      peakDrsLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'peakDrs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      peakDrsBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'peakDrs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      startTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      startTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      startTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      startTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      swipeCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'swipeCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      swipeCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'swipeCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      swipeCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'swipeCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      swipeCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'swipeCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      tapCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tapCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      tapCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tapCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      tapCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tapCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterFilterCondition>
      tapCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tapCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ScrollSessionQueryObject
    on QueryBuilder<ScrollSession, ScrollSession, QFilterCondition> {}

extension ScrollSessionQueryLinks
    on QueryBuilder<ScrollSession, ScrollSession, QFilterCondition> {}

extension ScrollSessionQuerySortBy
    on QueryBuilder<ScrollSession, ScrollSession, QSortBy> {
  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy>
      sortByAppPackageName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appPackageName', Sort.asc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy>
      sortByAppPackageNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appPackageName', Sort.desc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy> sortByAvgDrs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgDrs', Sort.asc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy> sortByAvgDrsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgDrs', Sort.desc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy>
      sortByCompletedCognitiveBump() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedCognitiveBump', Sort.asc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy>
      sortByCompletedCognitiveBumpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedCognitiveBump', Sort.desc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy> sortByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy> sortByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy> sortByIsEvaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEvaded', Sort.asc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy>
      sortByIsEvadedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEvaded', Sort.desc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy> sortByPeakDrs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peakDrs', Sort.asc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy> sortByPeakDrsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peakDrs', Sort.desc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy> sortByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy>
      sortByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy> sortBySwipeCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'swipeCount', Sort.asc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy>
      sortBySwipeCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'swipeCount', Sort.desc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy> sortByTapCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tapCount', Sort.asc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy>
      sortByTapCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tapCount', Sort.desc);
    });
  }
}

extension ScrollSessionQuerySortThenBy
    on QueryBuilder<ScrollSession, ScrollSession, QSortThenBy> {
  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy>
      thenByAppPackageName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appPackageName', Sort.asc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy>
      thenByAppPackageNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appPackageName', Sort.desc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy> thenByAvgDrs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgDrs', Sort.asc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy> thenByAvgDrsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgDrs', Sort.desc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy>
      thenByCompletedCognitiveBump() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedCognitiveBump', Sort.asc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy>
      thenByCompletedCognitiveBumpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedCognitiveBump', Sort.desc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy> thenByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy> thenByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy> thenByIsEvaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEvaded', Sort.asc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy>
      thenByIsEvadedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEvaded', Sort.desc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy> thenByPeakDrs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peakDrs', Sort.asc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy> thenByPeakDrsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peakDrs', Sort.desc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy> thenByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy>
      thenByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy> thenBySwipeCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'swipeCount', Sort.asc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy>
      thenBySwipeCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'swipeCount', Sort.desc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy> thenByTapCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tapCount', Sort.asc);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QAfterSortBy>
      thenByTapCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tapCount', Sort.desc);
    });
  }
}

extension ScrollSessionQueryWhereDistinct
    on QueryBuilder<ScrollSession, ScrollSession, QDistinct> {
  QueryBuilder<ScrollSession, ScrollSession, QDistinct>
      distinctByAppPackageName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'appPackageName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QDistinct> distinctByAvgDrs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'avgDrs');
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QDistinct>
      distinctByCompletedCognitiveBump() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedCognitiveBump');
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QDistinct> distinctByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endTime');
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QDistinct> distinctByIsEvaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isEvaded');
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QDistinct> distinctByPeakDrs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'peakDrs');
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QDistinct> distinctByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startTime');
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QDistinct> distinctBySwipeCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'swipeCount');
    });
  }

  QueryBuilder<ScrollSession, ScrollSession, QDistinct> distinctByTapCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tapCount');
    });
  }
}

extension ScrollSessionQueryProperty
    on QueryBuilder<ScrollSession, ScrollSession, QQueryProperty> {
  QueryBuilder<ScrollSession, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ScrollSession, String, QQueryOperations>
      appPackageNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'appPackageName');
    });
  }

  QueryBuilder<ScrollSession, double, QQueryOperations> avgDrsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'avgDrs');
    });
  }

  QueryBuilder<ScrollSession, bool, QQueryOperations>
      completedCognitiveBumpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedCognitiveBump');
    });
  }

  QueryBuilder<ScrollSession, DateTime, QQueryOperations> endTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endTime');
    });
  }

  QueryBuilder<ScrollSession, bool, QQueryOperations> isEvadedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isEvaded');
    });
  }

  QueryBuilder<ScrollSession, double, QQueryOperations> peakDrsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'peakDrs');
    });
  }

  QueryBuilder<ScrollSession, DateTime, QQueryOperations> startTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startTime');
    });
  }

  QueryBuilder<ScrollSession, int, QQueryOperations> swipeCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'swipeCount');
    });
  }

  QueryBuilder<ScrollSession, int, QQueryOperations> tapCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tapCount');
    });
  }
}
