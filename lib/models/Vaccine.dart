import 'package:cloud_firestore/cloud_firestore.dart';

class Vaccine {
  String _id;
  String _name;
  double _dose;
  Timestamp _applicationDate;
  String _modelOrManufacturer;
  String _batch;
  String _localOrHealthUnit;

  Vaccine(
    this._id,
    this._name,
    this._dose,
    this._applicationDate,
    this._modelOrManufacturer,
    this._batch,
    this._localOrHealthUnit,
  );

  Vaccine.map(dynamic obj) {
    this._id = obj['id'];
    this._name = obj['name'];
    this._dose = obj['dose'];
    this._applicationDate = obj['applicationDate'];
    this._modelOrManufacturer = obj['modelOrManufacturer'];
    this._batch = obj['batch'];
    this._localOrHealthUnit = obj['localOrHealthUnit'];
  }

  String get id => _id;
  String get name => _name;
  double get dose => _dose;
  Timestamp get applicationDate => _applicationDate;
  String get modelOrManufacturer => _modelOrManufacturer;
  String get batch => _batch;
  String get localOrHealthUnit => _localOrHealthUnit;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['_name'] = _name;
    map['_dose'] = _dose;
    map['_applicationDate'] = _applicationDate;
    map['_modelOrManufacturer'] = _modelOrManufacturer;
    map['_batch'] = _batch;
    map['_localOrHealthUnit'] = _localOrHealthUnit;

    return map;
  }

  Vaccine.fromMap(Map<String, dynamic> map, String id) {
    this._id = id ?? '';
    this._name = map['name'];
    this._dose = map['dose'];
    this._applicationDate = map['applicationDate'];
    this._modelOrManufacturer = map['modelOrManufacturer'];
    this._batch = map['batch'];
    this._localOrHealthUnit = map['localOrHealthUnit'];
  }
}
