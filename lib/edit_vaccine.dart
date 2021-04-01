import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ignilab/size_config.dart';

class EditVaccine extends StatelessWidget {
  final DocumentSnapshot document;

  EditVaccine({this.document});

  final _formKey = GlobalKey<FormState>();

  Widget _buildTextFieldTF(label, controller) {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return '$label não pode ser nulo';
        }
        return null;
      },
      style: TextStyle(fontFamily: 'OpenSans', fontSize: 18),
      decoration: InputDecoration(
        labelText: "$label",
        labelStyle: TextStyle(color: Color(0xFF787878)),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE0E0E0)),
        ),
        contentPadding: EdgeInsets.all(20),
      ),
      controller: controller,
    );
  }

  Widget _buildNumberFieldTF(label, controller) {
    return TextFormField(
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
      style: TextStyle(fontFamily: 'OpenSans', fontSize: 18),
      decoration: InputDecoration(
        labelText: "$label",
        labelStyle: TextStyle(color: Color(0xFF787878)),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE0E0E0)),
        ),
        contentPadding: EdgeInsets.all(20),
      ),
      controller: controller,
    );
  }

  Widget _buildDoseAndManufacturing(Widget dose, Widget manufacturing) {
    return Stack(
      children: <Widget>[
        Container(
          width: SizeConfig.blockSizeHorizontal * 25,
          child: dose,
        ),
        Container(
          margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 30),
          child: manufacturing,
        )
      ],
    );
  }

  Widget _buildAddVaccineBtn(
      BuildContext context,
      String documentId,
      TextEditingController vaccine,
      TextEditingController dose,
      TextEditingController manufacturer,
      TextEditingController local,
      TextEditingController applicationDate,
      TextEditingController control,
      TextEditingController batch,
      String documentBelongsTo,
      GlobalKey<FormState> _formKey) {
    CollectionReference vaccines =
        FirebaseFirestore.instance.collection('vaccines');

    Future<void> editVaccine(String vaccineId) {
      return vaccines
          .doc(documentId)
          .update({
            'vaccine': vaccine.text,
            'dose': dose.text,
            'manufacturer': manufacturer.text,
            'local': local.text,
            'applicationDate': applicationDate.text,
            'control': control.text,
            'batch': batch.text,
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
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF43B1BF)),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(20)),
        ),
        child: Text(
          'ATUALIZAR',
          style: TextStyle(
            letterSpacing: 1.25,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController vaccineController =
        TextEditingController(text: document.data()['vaccine']);
    final TextEditingController doseController =
        TextEditingController(text: document.data()['dose']);
    final TextEditingController manufacturerController =
        TextEditingController(text: document.data()['manufacturer']);
    final TextEditingController localController =
        TextEditingController(text: document.data()['local']);
    final TextEditingController applicationDateController =
        TextEditingController(text: document.data()['applicationDate']);
    final TextEditingController controlController =
        TextEditingController(text: document.data()['control']);
    final TextEditingController batchController =
        TextEditingController(text: document.data()['batch']);

    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 7),
          alignment: Alignment.topLeft,
          child: Row(
            children: <Widget>[
              Container(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xFF533A71),
                    size: 20,
                  ),
                ),
              ),
              Text(
                "Editar vacina",
                style: TextStyle(color: Color(0xFF533A71), fontSize: 20),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          margin: EdgeInsets.only(top: SizeConfig.screenHeight / 7),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(
              top: SizeConfig.blockSizeVertical * 3,
              left: SizeConfig.blockSizeVertical * 3,
              right: SizeConfig.blockSizeVertical * 3,
              bottom: SizeConfig.blockSizeVertical * 16,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "TODOS OS CAMPOS SÃO OBRIGATÓRIOS",
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 1.5,
                      color: Color(0xFF828282),
                    ),
                  ),
                  SizedBox(height: 25),
                  _buildTextFieldTF("Vacina", vaccineController),
                  SizedBox(height: 20),
                  _buildDoseAndManufacturing(
                    _buildNumberFieldTF('Dose', doseController),
                    _buildTextFieldTF("Fabricante", manufacturerController),
                  ),
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.screenWidth / 7,
                    ),
                    padding: EdgeInsets.all(SizeConfig.screenWidth / 40),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Text(
                      "INFORMAÇÕES ADICIONAIS",
                      style: TextStyle(
                        color: Color(0xFF6200EE),
                        fontFamily: "Roboto",
                        letterSpacing: 1.25,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildTextFieldTF("Local de vacinação", localController),
                  SizedBox(height: 20),
                  _buildTextFieldTF(
                      "Data da aplicação", applicationDateController),
                  SizedBox(height: 20),
                  _buildTextFieldTF("Controle", controlController),
                  SizedBox(height: 20),
                  _buildTextFieldTF("Lote", batchController),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 3),
          alignment: Alignment.bottomCenter,
          child: _buildAddVaccineBtn(
            context,
            document.id,
            vaccineController,
            doseController,
            manufacturerController,
            localController,
            applicationDateController,
            controlController,
            batchController,
            document.data()['belongsTo'],
            _formKey,
          ),
        )
      ]),
    );
  }
}
