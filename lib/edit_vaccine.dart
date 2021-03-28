import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget _buildTextFieldTF(label, controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'OpenSans',
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Color(0xFF6CA8F1),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return '$label não pode ser nulo';
            }
            return null;
          },
          style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(14),
              hintText: '$label da vacina',
              hintStyle: TextStyle(
                color: Colors.white54,
                fontFamily: 'OpenSans',
              )),
          controller: controller,
        ),
      ),
    ],
  );
}

Widget _buildNumberFieldTF(label, controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'OpenSans',
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Color(0xFF6CA8F1),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return '$label não pode ser nulo';
            }
            return null;
          },
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(14),
              hintText: '$label da vacina',
              hintStyle: TextStyle(
                color: Colors.white54,
                fontFamily: 'OpenSans',
              )),
          controller: controller,
        ),
      ),
    ],
  );
}

Widget _buildAddVaccineBtn(
    BuildContext context,
    String documentId,
    TextEditingController name,
    TextEditingController dose,
    TextEditingController applicationDate,
    TextEditingController modelOrManufacturer,
    TextEditingController batch,
    TextEditingController localOrHealthUnit,
    String documentBelongsTo,
    GlobalKey<FormState> _formKey) {
  CollectionReference vaccines =
      FirebaseFirestore.instance.collection('vaccines');

  Future<void> editVaccine(String vaccineId) {
    return vaccines
        .doc(documentId)
        .update({
          'name': name.text,
          'dose': dose.text,
          'applicationDate': applicationDate.text,
          'modelOrManufacturer': modelOrManufacturer.text,
          'batch': batch.text,
          'localOrHealthUnit': localOrHealthUnit.text,
          'belongsTo': documentBelongsTo,
        })
        .then((value) => {print("Vaccine Updated")})
        .catchError((error) => {print("Failed to update vaccine: $error")});
  }

  return Container(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {
        if (_formKey.currentState.validate()) {
          editVaccine(documentId);
          Navigator.pop(context);
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
      child: Text(
        'ATUALIZAR',
        style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans'),
      ),
    ),
  );
}

class EditVaccine extends StatelessWidget {
  final DocumentSnapshot document;

  EditVaccine({this.document});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: document.data()['name']);
    final TextEditingController doseController =
        TextEditingController(text: document.data()['dose']);
    final TextEditingController applicationDateController =
        TextEditingController(text: document.data()['applicationDate']);
    final TextEditingController modelOrManufacturerController =
        TextEditingController(text: document.data()['modelOrManufacturer']);
    final TextEditingController batchController =
        TextEditingController(text: document.data()['batch']);
    final TextEditingController localOrHealthUnitController =
        TextEditingController(text: document.data()['localOrHealthUnit']);

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF73AEF5),
                  Color(0xFF61A4F1),
                  Color(0xFF478DE0),
                  Color(0xFF398AE5),
                ],
                stops: [0.1, 0.4, 0.7, 0.9],
              ),
            ),
          ),
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 80.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Editar Vacina",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.0),
                  _buildTextFieldTF("Nome", nameController),
                  SizedBox(height: 20),
                  _buildNumberFieldTF("Dose", doseController),
                  SizedBox(height: 20),
                  _buildTextFieldTF(
                      "Data da Aplicação", applicationDateController),
                  SizedBox(height: 20),
                  _buildTextFieldTF(
                      "Modelo/Fabricante", modelOrManufacturerController),
                  SizedBox(height: 20),
                  _buildTextFieldTF("Lote", batchController),
                  SizedBox(height: 20),
                  _buildTextFieldTF(
                      "Local/Unidade de Saúde", localOrHealthUnitController),
                  SizedBox(height: 40),
                  _buildAddVaccineBtn(
                    context,
                    document.id,
                    nameController,
                    doseController,
                    applicationDateController,
                    modelOrManufacturerController,
                    batchController,
                    localOrHealthUnitController,
                    document.data()['belongsTo'],
                    _formKey,
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
